-- Safe Zone Server Script
local playersInSafeZone = {}

-- Função para verificar se um jogador está em safe zone
function IsPlayerInSafeZone(playerId)
    local playerPed = GetPlayerPed(playerId)
    if not playerPed or playerPed == 0 then return false, nil end
    
    local playerCoords = GetEntityCoords(playerPed)
    
    for i, zone in ipairs(Config.SafeZones) do
        local distance = #(playerCoords - zone.coords)
        if distance <= zone.radius then
            return true, zone
        end
    end
    
    return false, nil
end

-- Função para obter lista de jogadores em safe zone
function GetPlayersInSafeZone()
    local players = {}
    for playerId, zone in pairs(playersInSafeZone) do
        table.insert(players, {
            playerId = playerId,
            zone = zone
        })
    end
    return players
end

-- Thread para monitorar jogadores em safe zones
CreateThread(function()
    while true do
        Wait(1000) -- Verificar a cada segundo
        
        local players = GetPlayers()
        
        for _, playerId in ipairs(players) do
            local wasInSafeZone = playersInSafeZone[playerId] ~= nil
            local inSafeZone, zone = IsPlayerInSafeZone(playerId)
            
            if inSafeZone and not wasInSafeZone then
                -- Jogador entrou na safe zone
                playersInSafeZone[playerId] = zone
                TriggerClientEvent('safe:playerEnteredZone', -1, playerId, zone)
                print("^2[SAFE ZONE]^7 Jogador " .. GetPlayerName(playerId) .. " entrou na Safe Zone: " .. zone.name)
                
            elseif not inSafeZone and wasInSafeZone then
                -- Jogador saiu da safe zone
                local previousZone = playersInSafeZone[playerId]
                playersInSafeZone[playerId] = nil
                TriggerClientEvent('safe:playerLeftZone', -1, playerId, previousZone)
                print("^3[SAFE ZONE]^7 Jogador " .. GetPlayerName(playerId) .. " saiu da Safe Zone: " .. previousZone.name)
            end
        end
    end
end)

-- Eventos do servidor
RegisterNetEvent('safe:requestSafeZoneStatus')
AddEventHandler('safe:requestSafeZoneStatus', function()
    local source = source
    local inSafeZone, zone = IsPlayerInSafeZone(source)
    
    TriggerClientEvent('safe:receiveSafeZoneStatus', source, inSafeZone, zone)
end)

RegisterNetEvent('safe:requestPlayersInSafeZone')
AddEventHandler('safe:requestPlayersInSafeZone', function()
    local source = source
    local players = GetPlayersInSafeZone()
    
    TriggerClientEvent('safe:receivePlayersInSafeZone', source, players)
end)

-- Comando para listar jogadores em safe zones (admin)
RegisterCommand('safezonelist', function(source, args, rawCommand)
    local players = GetPlayersInSafeZone()
    
    if #players > 0 then
        print("^2[SAFE ZONE]^7 Jogadores em Safe Zones:")
        for _, player in ipairs(players) do
            print("  - " .. GetPlayerName(player.playerId) .. " (ID: " .. player.playerId .. ") em " .. player.zone.name)
        end
    else
        print("^3[SAFE ZONE]^7 Nenhum jogador está em Safe Zones no momento")
    end
end, false)

-- Comando para teleportar para safe zone (admin)
RegisterCommand('tpsafezone', function(source, args, rawCommand)
    if #args < 1 then
        print("^1[SAFE ZONE]^7 Uso: /tpsafezone <número_da_zona>")
        print("^3[SAFE ZONE]^7 Zonas disponíveis:")
        for i, zone in ipairs(Config.SafeZones) do
            print("  " .. i .. " - " .. zone.name)
        end
        return
    end
    
    local zoneIndex = tonumber(args[1])
    if not zoneIndex or zoneIndex < 1 or zoneIndex > #Config.SafeZones then
        print("^1[SAFE ZONE]^7 Número de zona inválido!")
        return
    end
    
    local zone = Config.SafeZones[zoneIndex]
    local playerPed = GetPlayerPed(source)
    
    if playerPed and playerPed ~= 0 then
        SetEntityCoords(playerPed, zone.coords.x, zone.coords.y, zone.coords.z, false, false, false, true)
        SetEntityHeading(playerPed, zone.heading)
        
        TriggerClientEvent('safe:teleportedToZone', source, zone)
        print("^2[SAFE ZONE]^7 Jogador " .. GetPlayerName(source) .. " foi teleportado para " .. zone.name)
    end
end, false)

-- Comando para adicionar nova safe zone (admin)
RegisterCommand('addsafezone', function(source, args, rawCommand)
    if #args < 4 then
        print("^1[SAFE ZONE]^7 Uso: /addsafezone <nome> <x> <y> <z> [raio] [altura]")
        return
    end
    
    local name = args[1]
    local x = tonumber(args[2])
    local y = tonumber(args[3])
    local z = tonumber(args[4])
    local radius = tonumber(args[5]) or 100.0
    local height = tonumber(args[6]) or 200.0
    
    if not x or not y or not z then
        print("^1[SAFE ZONE]^7 Coordenadas inválidas!")
        return
    end
    
    local newZone = {
        name = name,
        coords = vector3(x, y, z),
        radius = radius,
        height = height,
        color = {r = 0, g = 255, b = 0, a = 10},
        heading = 450.0
    }
    
    table.insert(Config.SafeZones, newZone)
    
    -- Notificar todos os clientes sobre a nova zona
    TriggerClientEvent('safe:zoneAdded', -1, newZone)
    
    print("^2[SAFE ZONE]^7 Nova Safe Zone adicionada: " .. name .. " em " .. x .. ", " .. y .. ", " .. z)
end, false)

-- Comando para remover safe zone (admin)
RegisterCommand('removesafezone', function(source, args, rawCommand)
    if #args < 1 then
        print("^1[SAFE ZONE]^7 Uso: /removesafezone <número_da_zona>")
        print("^3[SAFE ZONE]^7 Zonas disponíveis:")
        for i, zone in ipairs(Config.SafeZones) do
            print("  " .. i .. " - " .. zone.name)
        end
        return
    end
    
    local zoneIndex = tonumber(args[1])
    if not zoneIndex or zoneIndex < 1 or zoneIndex > #Config.SafeZones then
        print("^1[SAFE ZONE]^7 Número de zona inválido!")
        return
    end
    
    local removedZone = table.remove(Config.SafeZones, zoneIndex)
    
    -- Notificar todos os clientes sobre a remoção da zona
    TriggerClientEvent('safe:zoneRemoved', -1, zoneIndex)
    
    print("^2[SAFE ZONE]^7 Safe Zone removida: " .. removedZone.name)
end, false)

-- Inicialização
CreateThread(function()
    Wait(1000) -- Aguardar carregamento completo
    print("^2[SAFE ZONE]^7 Servidor iniciado com " .. #Config.SafeZones .. " zonas configuradas")
end)

-- Cleanup ao parar o resource
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        playersInSafeZone = {}
        print("^1[SAFE ZONE]^7 Servidor parado")
    end
end)

-- Exportar funções para outros resources
exports('IsPlayerInSafeZone', IsPlayerInSafeZone)
exports('GetPlayersInSafeZone', GetPlayersInSafeZone)
