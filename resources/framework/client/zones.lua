-- PvP Framework - Zones Client

local CurrentZone = nil
local ZoneBlips = {}

-- Função para criar blip de zona
function CreateZoneBlip(zone)
    if ZoneBlips[zone.id] then
        RemoveBlip(ZoneBlips[zone.id])
    end
    
    local blip = AddBlipForRadius(zone.coords.x, zone.coords.y, zone.coords.z, zone.radius)
    SetBlipRotation(blip, 0)
    SetBlipColour(blip, 1) -- Vermelho
    SetBlipAlpha(blip, zone.color.a or 100)
    
    -- Blip central da zona
    local centerBlip = AddBlipForCoord(zone.coords.x, zone.coords.y, zone.coords.z)
    SetBlipSprite(centerBlip, 1)
    SetBlipDisplay(centerBlip, 4)
    SetBlipScale(centerBlip, 1.0)
    SetBlipColour(centerBlip, 1)
    SetBlipAsShortRange(centerBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(zone.name)
    EndTextCommandSetBlipName(centerBlip)
    
    ZoneBlips[zone.id] = {
        radius = blip,
        center = centerBlip
    }
end

-- Função para remover blip de zona
function RemoveZoneBlip(zoneId)
    if ZoneBlips[zoneId] then
        RemoveBlip(ZoneBlips[zoneId].radius)
        RemoveBlip(ZoneBlips[zoneId].center)
        ZoneBlips[zoneId] = nil
    end
end

-- Função para criar todos os blips de zona
function CreateAllZoneBlips()
    for _, zone in ipairs(Config.PvPZones) do
        CreateZoneBlip(zone)
    end
end

-- Função para remover todos os blips
function RemoveAllZoneBlips()
    for zoneId, _ in pairs(ZoneBlips) do
        RemoveZoneBlip(zoneId)
    end
end

-- Função para desenhar zona no mapa
function DrawZoneOnMap(zone)
    local playerPos = GetEntityCoords(PlayerPedId())
    local distance = Utils.GetDistance(playerPos, zone.coords)
    
    if distance <= zone.radius * 2 then -- Desenhar apenas se próximo
        DrawMarker(1, zone.coords.x, zone.coords.y, zone.coords.z - 1.0, 
            0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
            zone.radius * 2.0, zone.radius * 2.0, 1.0, 
            zone.color.r, zone.color.g, zone.color.b, zone.color.a, 
            false, true, 2, false, nil, nil, false)
    end
end

-- Função para verificar zona atual
function CheckCurrentZone()
    local playerPos = GetEntityCoords(PlayerPedId())
    local newZone = Utils.GetPlayerZone(playerPos)
    
    if newZone and newZone.id ~= (CurrentZone and CurrentZone.id) then
        -- Jogador entrou em uma nova zona
        if CurrentZone then
            TriggerEvent('pvp:zoneLeft', CurrentZone)
        end
        
        CurrentZone = newZone
        TriggerEvent('pvp:zoneEntered', newZone)
        
        -- Notificar servidor
        TriggerServerEvent('pvp:requestZoneInfo')
        
    elseif not newZone and CurrentZone then
        -- Jogador saiu da zona
        TriggerEvent('pvp:zoneLeft', CurrentZone)
        CurrentZone = nil
        
        -- Notificar servidor
        TriggerServerEvent('pvp:requestZoneInfo')
    end
end

-- Evento quando entra em uma zona
AddEventHandler('pvp:zoneEntered', function(zone)
    Utils.SendNotification(nil, "Entrou na zona: " .. zone.name, "info")
    
    -- Efeito visual
    local player = PlayerPedId()
    SetEntityHealth(player, GetEntityHealth(player) + 10) -- Pequeno bônus de vida
    
    -- Som de entrada na zona removido
end)

-- Evento quando sai de uma zona
AddEventHandler('pvp:zoneLeft', function(zone)
    Utils.SendNotification(nil, "Saiu da zona: " .. zone.name, "info")
    
    -- Som de saída da zona removido
end)

-- Evento para receber informações da zona
RegisterNetEvent('pvp:receiveZoneInfo')
AddEventHandler('pvp:receiveZoneInfo', function(zoneInfo)
    if zoneInfo then
        -- Atualizar informações da zona atual
        CurrentZone = zoneInfo
    else
        CurrentZone = nil
    end
end)

-- Evento para receber todas as zonas
RegisterNetEvent('pvp:receiveAllZones')
AddEventHandler('pvp:receiveAllZones', function(zones)
    -- Atualizar blips se necessário
    for _, zone in ipairs(zones) do
        if not ZoneBlips[zone.id] then
            CreateZoneBlip(zone)
        end
    end
end)

-- Thread para verificar zona atual
CreateThread(function()
    while true do
        Wait(1000) -- Verificar a cada segundo
        CheckCurrentZone()
    end
end)

-- Thread para desenhar zonas no mapa
CreateThread(function()
    while true do
        Wait(0)
        for _, zone in ipairs(Config.PvPZones) do
            DrawZoneOnMap(zone)
        end
    end
end)

-- Comandos do cliente
RegisterCommand('zoneinfo', function(source, args, rawCommand)
    if CurrentZone then
        Utils.SendNotification(nil, "Zona atual: " .. CurrentZone.name, "info")
        if CurrentZone.players then
            Utils.SendNotification(nil, "Jogadores na zona: " .. #CurrentZone.players, "info")
        end
    else
        Utils.SendNotification(nil, "Você não está em nenhuma zona", "info")
    end
end, false)

RegisterCommand('zones', function(source, args, rawCommand)
    Utils.SendNotification(nil, "Zonas disponíveis:", "info")
    for i, zone in ipairs(Config.PvPZones) do
        Utils.SendNotification(nil, i .. ". " .. zone.name, "info")
    end
end, false)

RegisterCommand('togglemap', function(source, args, rawCommand)
    local blipsVisible = not ZoneBlips[1]
    
    if blipsVisible then
        CreateAllZoneBlips()
        Utils.SendNotification(nil, "Blips de zona ativados", "success")
    else
        RemoveAllZoneBlips()
        Utils.SendNotification(nil, "Blips de zona desativados", "info")
    end
end, false)

-- Função para obter zona atual
function GetCurrentZone()
    return CurrentZone
end

-- Função para teleportar para uma zona
function TeleportToZone(zoneId)
    if zoneId and zoneId <= #Config.PvPZones then
        local zone = Config.PvPZones[zoneId]
        local player = PlayerPedId()
        
        SetEntityCoords(player, zone.coords.x, zone.coords.y, zone.coords.z, false, false, false, true)
        Utils.SendNotification(nil, "Teleportado para: " .. zone.name, "success")
    else
        Utils.SendNotification(nil, "Zona inválida!", "error")
    end
end

-- Função para obter distância até uma zona
function GetDistanceToZone(zoneId)
    if zoneId and zoneId <= #Config.PvPZones then
        local zone = Config.PvPZones[zoneId]
        local playerPos = GetEntityCoords(PlayerPedId())
        
        return Utils.GetDistance(playerPos, zone.coords)
    end
    return -1
end

-- Inicialização
CreateThread(function()
    Wait(2000) -- Aguardar carregamento
    
    -- Criar blips de zona
    CreateAllZoneBlips()
    
    -- Solicitar informações de zona
    TriggerServerEvent('pvp:requestZoneInfo')
    
    Utils.Log("Sistema de zonas inicializado!")
end)

-- Exportar funções
exports('GetCurrentZone', GetCurrentZone)
exports('TeleportToZone', TeleportToZone)
exports('GetDistanceToZone', GetDistanceToZone)
exports('CreateZoneBlip', CreateZoneBlip)
exports('RemoveZoneBlip', RemoveZoneBlip) 