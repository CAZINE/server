-- PvP Framework - Zones Management (Server)

local ActiveZones = {}

-- Inicializar zonas
function InitializeZones()
    for i, zone in ipairs(Config.PvPZones) do
        ActiveZones[i] = {
            id = i,
            name = zone.name,
            coords = zone.coords,
            radius = zone.radius,
            color = zone.color,
            players = {}
        }
    end
    
    Utils.Log("Zonas PvP inicializadas: " .. #ActiveZones)
end

-- Função para verificar se jogador está em uma zona
function IsPlayerInZone(playerId, zoneId)
    -- Verificar se o jogador é válido antes de chamar GetPlayerPed
    if not playerId or not DoesEntityExist(GetPlayerPed(playerId)) then return false end
    local player = GetPlayerPed(playerId)
    
    local playerPos = GetEntityCoords(player)
    local zone = ActiveZones[zoneId]
    
    if not zone then return false end
    
    return Utils.GetDistance(playerPos, zone.coords) <= zone.radius
end

-- Função para obter zona atual do jogador
function GetPlayerCurrentZone(playerId)
    -- Verificar se o jogador é válido antes de chamar GetPlayerPed
    if not playerId or not DoesEntityExist(GetPlayerPed(playerId)) then return nil end
    local player = GetPlayerPed(playerId)
    
    local playerPos = GetEntityCoords(player)
    
    for i, zone in ipairs(ActiveZones) do
        if Utils.GetDistance(playerPos, zone.coords) <= zone.radius then
            return zone
        end
    end
    
    return nil
end

-- Função para adicionar jogador a uma zona
function AddPlayerToZone(playerId, zoneId)
    local zone = ActiveZones[zoneId]
    if not zone then return false end
    
    if not zone.players[playerId] then
        zone.players[playerId] = {
            id = playerId,
            name = GetPlayerName(playerId) or "Unknown",
            joinTime = GetGameTimer()
        }
        
        Utils.SendNotification(playerId, "Entrou na zona: " .. zone.name, "info")
        TriggerClientEvent('pvp:zoneEntered', playerId, zone)
        
        return true
    end
    
    return false
end

-- Função para remover jogador de uma zona
function RemovePlayerFromZone(playerId, zoneId)
    local zone = ActiveZones[zoneId]
    if not zone or not zone.players[playerId] then return false end
    
    local playerData = zone.players[playerId]
    zone.players[playerId] = nil
    
    Utils.SendNotification(playerId, "Saiu da zona: " .. zone.name, "info")
    TriggerClientEvent('pvp:zoneLeft', playerId, zone)
    
    return true
end

-- Função para obter jogadores em uma zona
function GetPlayersInZone(zoneId)
    local zone = ActiveZones[zoneId]
    if not zone then return {} end
    
    local players = {}
    for playerId, playerData in pairs(zone.players) do
        table.insert(players, playerData)
    end
    
    return players
end

-- Função para obter todas as zonas
function GetAllZones()
    return ActiveZones
end

-- Timer para verificar posição dos jogadores
CreateThread(function()
    while true do
        Wait(1000) -- Verificar a cada segundo
        
        local players = GetPlayers()
        for _, playerId in ipairs(players) do
            local playerData = GetPlayerData(playerId)
            if playerData then
                local currentZone = GetPlayerCurrentZone(playerId)
                local previousZone = playerData.currentZone
                
                if currentZone and currentZone.id ~= previousZone then
                    -- Jogador entrou em uma nova zona
                    if previousZone then
                        RemovePlayerFromZone(playerId, previousZone)
                    end
                    AddPlayerToZone(playerId, currentZone.id)
                    playerData.currentZone = currentZone.id
                    
                elseif not currentZone and previousZone then
                    -- Jogador saiu da zona
                    RemovePlayerFromZone(playerId, previousZone)
                    playerData.currentZone = nil
                end
            end
        end
    end
end)

-- Evento para solicitar informações da zona
RegisterNetEvent('pvp:requestZoneInfo')
AddEventHandler('pvp:requestZoneInfo', function()
    local source = source
    local currentZone = GetPlayerCurrentZone(source)
    
    if currentZone then
        local zoneInfo = {
            id = currentZone.id,
            name = currentZone.name,
            players = GetPlayersInZone(currentZone.id)
        }
        
        TriggerClientEvent('pvp:receiveZoneInfo', source, zoneInfo)
    else
        TriggerClientEvent('pvp:receiveZoneInfo', source, nil)
    end
end)

-- Evento para solicitar todas as zonas
RegisterNetEvent('pvp:requestAllZones')
AddEventHandler('pvp:requestAllZones', function()
    local source = source
    local zones = GetAllZones()
    
    TriggerClientEvent('pvp:receiveAllZones', source, zones)
end)

-- Comando para teleportar para zona
RegisterCommand('zone', function(source, args, rawCommand)
    if source == 0 then -- Console
        if #args < 2 then
            print("Uso: zone <player_id> [número da zona]")
            return
        end
        
        local targetId = tonumber(args[1])
        local zoneId = tonumber(args[2])
        
        if not targetId or not zoneId or zoneId < 1 or zoneId > #ActiveZones then
            print("Parâmetros inválidos!")
            return
        end
        
        local zone = ActiveZones[zoneId]
        if zone then
            -- Verificar se o jogador é válido antes de chamar GetPlayerPed
            if not targetId or not DoesEntityExist(GetPlayerPed(targetId)) then
                print("Jogador inválido!")
                return
            end
            local player = GetPlayerPed(targetId)
            SetEntityCoords(player, zone.coords.x, zone.coords.y, zone.coords.z, false, false, false, true)
            print("Jogador " .. targetId .. " teleportado para: " .. zone.name)
        end
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        if #args < 2 then
            TriggerClientEvent('pvp:notification', source, "Uso: /zone <player_id> [número da zona]", "error")
            return
        end
        
        local targetId = tonumber(args[1])
        local zoneId = tonumber(args[2])
        
        if not targetId or not zoneId or zoneId < 1 or zoneId > #ActiveZones then
            TriggerClientEvent('pvp:notification', source, "Parâmetros inválidos!", "error")
            return
        end
        
        local zone = ActiveZones[zoneId]
        if zone then
            -- Verificar se o jogador é válido antes de chamar GetPlayerPed
            if not targetId or not DoesEntityExist(GetPlayerPed(targetId)) then
                TriggerClientEvent('pvp:notification', source, "Jogador inválido!", "error")
                return
            end
            local player = GetPlayerPed(targetId)
            SetEntityCoords(player, zone.coords.x, zone.coords.y, zone.coords.z, false, false, false, true)
            TriggerClientEvent('pvp:notification', source, "Jogador " .. targetId .. " teleportado para: " .. zone.name, "success")
        end
    end
end, false)

-- Comando para listar zonas
RegisterCommand('zones', function(source, args, rawCommand)
    if source == 0 then -- Console
        Utils.Log("=== ZONAS PVP ===")
        for i, zone in ipairs(ActiveZones) do
            local playerCount = 0
            for _ in pairs(zone.players) do
                playerCount = playerCount + 1
            end
            Utils.Log(string.format("%d. %s - Jogadores: %d", i, zone.name, playerCount))
        end
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local zones = GetAllZones()
        for i, zone in ipairs(zones) do
            local playerCount = 0
            for _ in pairs(zone.players) do
                playerCount = playerCount + 1
            end
            TriggerClientEvent('pvp:notification', source, string.format("%d. %s - Jogadores: %d", i, zone.name, playerCount), "info")
        end
    end
end, false)

-- Comando para criar zona personalizada (apenas admin)
RegisterCommand('createzone', function(source, args, rawCommand)
    if source == 0 then -- Console
        if #args < 4 then
            print("Uso: createzone [nome] [x] [y] [z] [raio]")
            return
        end
        
        local name = args[1]
        local x = tonumber(args[2])
        local y = tonumber(args[3])
        local z = tonumber(args[4])
        local radius = tonumber(args[5]) or 100.0
        
        if not x or not y or not z then
            print("Coordenadas inválidas!")
            return
        end
        
        local newZone = {
            id = #ActiveZones + 1,
            name = name,
            coords = vector3(x, y, z),
            radius = radius,
            color = {r = 255, g = 255, b = 255, a = 100},
            players = {}
        }
        
        table.insert(ActiveZones, newZone)
        print("Zona criada: " .. name)
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        if #args < 4 then
            TriggerClientEvent('pvp:notification', source, "Uso: /createzone [nome] [x] [y] [z] [raio]", "error")
            return
        end
        
        local name = args[1]
        local x = tonumber(args[2])
        local y = tonumber(args[3])
        local z = tonumber(args[4])
        local radius = tonumber(args[5]) or 100.0
        
        if not x or not y or not z then
            TriggerClientEvent('pvp:notification', source, "Coordenadas inválidas!", "error")
            return
        end
        
        local newZone = {
            id = #ActiveZones + 1,
            name = name,
            coords = vector3(x, y, z),
            radius = radius,
            color = {r = 255, g = 255, b = 255, a = 100},
            players = {}
        }
        
        table.insert(ActiveZones, newZone)
        TriggerClientEvent('pvp:notification', source, "Zona criada: " .. name, "success")
    end
end, false)

-- Inicializar zonas quando o resource iniciar
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    InitializeZones()
end)

-- Exportar funções
exports('GetPlayerCurrentZone', GetPlayerCurrentZone)
exports('GetPlayersInZone', GetPlayersInZone)
exports('GetAllZones', GetAllZones)
exports('IsPlayerInZone', IsPlayerInZone) 