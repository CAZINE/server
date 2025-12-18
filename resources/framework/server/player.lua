-- PvP Framework - Player Management (Server)

-- Evento para dar armas ao jogador
RegisterNetEvent('pvp:giveWeapons')
AddEventHandler('pvp:giveWeapons', function()
    local source = source
    if not source then return end
    
    -- Verificar se o jogador é válido antes de chamar GetPlayerPed
    if not DoesEntityExist(GetPlayerPed(source)) then return end
    local player = GetPlayerPed(source)
    
    -- Remover todas as armas
    RemoveAllPedWeapons(player, true)
    
    Utils.SendNotification(source, "Armas recebidas!", "success")
end)

-- Evento para respawn do jogador
RegisterNetEvent('pvp:respawn')
AddEventHandler('pvp:respawn', function()
    local source = source
    if not source then return end
    
    -- Verificar se o jogador é válido antes de chamar GetPlayerPed
    if not DoesEntityExist(GetPlayerPed(source)) then return end
    local player = GetPlayerPed(source)
    local playerData = GetPlayerData(source)
    
    if playerData then
        -- Resetar proteção
        playerData.isProtected = true
        playerData.spawnTime = GetGameTimer()
        
        -- Spawn em local aleatório
        local spawnPoint = Utils.GetRandomSpawnPoint()
        SetEntityCoords(player, spawnPoint.x, spawnPoint.y, spawnPoint.z)
        SetEntityHeading(player, spawnPoint.heading)
        
        -- Restaurar vida (client only)
        -- SetEntityHealth(player, 200)
        -- ClearPedBloodDamage(player)
        
        -- Remover proteção após tempo
        SetTimeout(Config.SpawnProtection, function()
            local currentPlayerData = GetPlayerData(source)
            if currentPlayerData then
                currentPlayerData.isProtected = false
                Utils.SendNotification(source, "Proteção de spawn removida!", "info")
            end
        end)
        
        Utils.SendNotification(source, "Respawn realizado!", "info")
    end
end)

-- Evento para teleportar jogador
RegisterNetEvent('pvp:teleport')
AddEventHandler('pvp:teleport', function(x, y, z)
    local source = source
    if not source then return end
    
    -- Verificar se o jogador é válido antes de chamar GetPlayerPed
    if not DoesEntityExist(GetPlayerPed(source)) then return end
    local player = GetPlayerPed(source)
    local playerData = GetPlayerData(source)
    
    if playerData then
        SetEntityCoords(player, x, y, z, false, false, false, true)
        Utils.SendNotification(source, "Teleportado!", "info")
    end
end)

-- Evento para curar jogador
RegisterNetEvent('pvp:heal')
AddEventHandler('pvp:heal', function()
    local source = source
    if not source then return end
    
    -- Verificar se o jogador é válido antes de chamar GetPlayerPed
    if not DoesEntityExist(GetPlayerPed(source)) then return end
    local player = GetPlayerPed(source)
    local playerData = GetPlayerData(source)
    
    if playerData then
        -- SetEntityHealth(player, 200)
        -- ClearPedBloodDamage(player)
        TriggerClientEvent('pvp:heal', source)
        
    end
end)

-- Evento para dar dinheiro
RegisterNetEvent('pvp:giveMoney')
AddEventHandler('pvp:giveMoney', function(amount)
    local source = source
    local playerData = GetPlayerData(source)
    
    if playerData then
        playerData.money = playerData.money + amount
        Utils.SendNotification(source, "Recebeu $" .. amount, "success")
    end
end)

-- Evento para obter dados do jogador
RegisterNetEvent('pvp:getPlayerData')
AddEventHandler('pvp:getPlayerData', function()
    local source = source
    local playerData = GetPlayerData(source)
    
    if playerData then
        TriggerClientEvent('pvp:receivePlayerData', source, playerData)
    end
end)

-- Evento para mostrar o ID do jogador
RegisterNetEvent('pvp:showMyId')
AddEventHandler('pvp:showMyId', function()
    local src = source
    TriggerClientEvent('chat:addMessage', src, {
        color = {255, 0, 255},
        multiline = false,
        args = {"ID", "Seu ID no servidor é: " .. tostring(src)}
    })
    -- Notificação visual
    TriggerClientEvent('notify:show', src, { type = "info", message = "Seu ID no servidor é: " .. tostring(src) })
end)

-- Função para calcular o level igual ao hud-go
local function getLevelAndMeta(xp)
    local level = 1
    local xpBase = 0
    local meta = 300
    local fator = 1.25
    local base = 300
    while level < 100 do
        local nextMeta = math.floor(base * (level ^ fator))
        if xp < nextMeta then
            meta = nextMeta
            break
        end
        xpBase = nextMeta
        level = level + 1
    end
    if level >= 100 then
        level = 100
        meta = math.floor(base * (99 ^ fator))
        xpBase = math.floor(base * (98 ^ fator))
    end
    return level, meta, xpBase
end

-- Evento para receber o pedido de stats do espectado e responder ao client com kills, level, id, nome, vida, viewers. (Evento: pvp:requestSpectateStats)
RegisterNetEvent('pvp:requestSpectateStats')
AddEventHandler('pvp:requestSpectateStats', function(targetId, viewers, killerName, health)
    local src = source
    local playerData = GetPlayerData(targetId)
    local kills = playerData and (playerData.kills or 0) or 0
    local killerId = targetId or 0
    -- Buscar XP do killer na tabela player_xp
    local identifier = GetPlayerIdentifier(targetId, 0)
    exports.oxmysql:fetch('SELECT xp FROM player_xp WHERE identifier = ?', { identifier }, function(result)
        local xp = 0
        if result and result[1] then
            xp = tonumber(result[1].xp) or 0
        end
        local level = getLevelAndMeta(xp)
        -- Enviar para o client que pediu
        TriggerClientEvent('pvp:receiveSpectateStats', src, {
            viewers = viewers,
            level = level,
            killerName = killerName,
            killerId = killerId,
            health = health,
            kills = kills
        })
    end)
end)

-- Comandos para jogadores
RegisterCommand('kill', function(source, args, rawCommand)
    if source == 0 then -- Console
        local targetId = tonumber(args[1])
        if targetId then
            -- Tentar encontrar por player_id primeiro
            local playerData = GetPlayerData(targetId)
            if not playerData then
                -- Se não encontrou, tentar por fixed_id
                local foundPlayerId = exports['framework']:GetPlayerIdByFixedId(targetId)
                if foundPlayerId then
                    targetId = foundPlayerId
                    playerData = GetPlayerData(targetId)
                end
            end
            
            if playerData then
                TriggerClientEvent('pvp:kill', targetId)
                print("Jogador " .. targetId .. " (FixedID: " .. (playerData.fixed_id or "N/A") .. ") morto!")
            else
                print("Jogador não encontrado!")
            end
        else
            print("Uso: kill <player_id ou fixed_id>")
        end
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local targetId = tonumber(args[1])
        if targetId then
            -- Tentar encontrar por player_id primeiro
            local playerData = GetPlayerData(targetId)
            if not playerData then
                -- Se não encontrou, tentar por fixed_id
                local foundPlayerId = exports['framework']:GetPlayerIdByFixedId(targetId)
                if foundPlayerId then
                    targetId = foundPlayerId
                    playerData = GetPlayerData(targetId)
                end
            end
            
            if playerData then
                TriggerClientEvent('pvp:kill', targetId)
                TriggerClientEvent('pvp:notification', source, "Jogador " .. targetId .. " (FixedID: " .. (playerData.fixed_id or "N/A") .. ") morto!", "success")
            else
                TriggerClientEvent('pvp:notification', source, "Jogador não encontrado!", "error")
            end
        else
            TriggerClientEvent('pvp:notification', source, "Uso: /kill <player_id ou fixed_id>", "error")
        end
    end
end, false)

RegisterCommand('god', function(source, args, rawCommand)
    if source == 0 then -- Console
        local targetId = tonumber(args[1])
        if targetId then
            -- Tentar encontrar por player_id primeiro
            local playerData = GetPlayerData(targetId)
            if not playerData then
                -- Se não encontrou, tentar por fixed_id
                local foundPlayerId = exports['framework']:GetPlayerIdByFixedId(targetId)
                if foundPlayerId then
                    targetId = foundPlayerId
                    playerData = GetPlayerData(targetId)
                end
            end
            
            if playerData then
                TriggerClientEvent('pvp:heal', targetId)
                print("Jogador " .. targetId .. " (FixedID: " .. (playerData.fixed_id or "N/A") .. ") curado!")
            else
                print("Jogador não encontrado!")
            end
        else
            print("Uso: god <player_id ou fixed_id>")
        end
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local targetId = tonumber(args[1])
        if targetId then
            -- Tentar encontrar por player_id primeiro
            local playerData = GetPlayerData(targetId)
            if not playerData then
                -- Se não encontrou, tentar por fixed_id
                local foundPlayerId = exports['framework']:GetPlayerIdByFixedId(targetId)
                if foundPlayerId then
                    targetId = foundPlayerId
                    playerData = GetPlayerData(targetId)
                end
            end
            
            if playerData then
                TriggerClientEvent('pvp:heal', targetId)
                TriggerClientEvent('pvp:notification', source, "Jogador " .. targetId .. " (FixedID: " .. (playerData.fixed_id or "N/A") .. ") curado!", "success")
            else
                TriggerClientEvent('pvp:notification', source, "Jogador não encontrado!", "error")
            end
        else
            TriggerClientEvent('pvp:notification', source, "Uso: /god <player_id ou fixed_id>", "error")
        end
    end
end, false)

-- Comando weapons desabilitado para não dar armas automaticamente
-- RegisterCommand('weapons', function(source, args, rawCommand)
--     if source == 0 then -- Console
--         local targetId = tonumber(args[1])
--         if targetId then
--             local playerData = GetPlayerData(targetId)
--             if playerData then
--                 TriggerClientEvent('pvp:giveWeapons', targetId, Config.DefaultWeapons)
--                 print("Armas dadas para jogador " .. targetId)
--             end
--         else
--             print("Uso: weapons <player_id>")
--         end
--     else
--         -- Verificar permissão admin
--         if not exports['framework']:HasPermission(source, "admin") then
--             TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
--             return
--         end
--         
--         local targetId = tonumber(args[1])
--         if targetId then
--             local playerData = GetPlayerData(targetId)
--             if playerData then
--                 TriggerClientEvent('pvp:giveWeapons', targetId, Config.DefaultWeapons)
--                 TriggerClientEvent('pvp:notification', source, "Armas dadas para jogador " .. targetId, "success")
--             end
--         else
--             TriggerClientEvent('pvp:notification', source, "Uso: /weapons <player_id>", "error")
--         end
--     end
-- end, false)

RegisterCommand('respawn', function(source, args, rawCommand)
    if source == 0 then -- Console
        local targetId = tonumber(args[1])
        if targetId then
            -- Tentar encontrar por player_id primeiro
            local playerData = GetPlayerData(targetId)
            if not playerData then
                -- Se não encontrou, tentar por fixed_id
                local foundPlayerId = exports['framework']:GetPlayerIdByFixedId(targetId)
                if foundPlayerId then
                    targetId = foundPlayerId
                    playerData = GetPlayerData(targetId)
                end
            end
            
            if playerData then
                TriggerClientEvent('pvp:respawn', targetId)
                print("Jogador " .. targetId .. " (FixedID: " .. (playerData.fixed_id or "N/A") .. ") respawnado!")
            else
                print("Jogador não encontrado!")
            end
        else
            print("Uso: respawn <player_id ou fixed_id>")
        end
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local targetId = tonumber(args[1])
        if targetId then
            -- Tentar encontrar por player_id primeiro
            local playerData = GetPlayerData(targetId)
            if not playerData then
                -- Se não encontrou, tentar por fixed_id
                local foundPlayerId = exports['framework']:GetPlayerIdByFixedId(targetId)
                if foundPlayerId then
                    targetId = foundPlayerId
                    playerData = GetPlayerData(targetId)
                end
            end
            
            if playerData then
                TriggerClientEvent('pvp:respawn', targetId)
                TriggerClientEvent('pvp:notification', source, "Jogador " .. targetId .. " (FixedID: " .. (playerData.fixed_id or "N/A") .. ") respawnado!", "success")
            else
                TriggerClientEvent('pvp:notification', source, "Jogador não encontrado!", "error")
            end
        else
            TriggerClientEvent('pvp:notification', source, "Uso: /respawn <player_id ou fixed_id>", "error")
        end
    end
end, false)

RegisterCommand('cdstest', function(source, args, rawCommand)
    if source == 0 then -- Console
        local targetId = tonumber(args[1])
        if targetId then
            -- Tentar encontrar por player_id primeiro
            local playerData = GetPlayerData(targetId)
            if not playerData then
                -- Se não encontrou, tentar por fixed_id
                local foundPlayerId = exports['framework']:GetPlayerIdByFixedId(targetId)
                if foundPlayerId then
                    targetId = foundPlayerId
                    playerData = GetPlayerData(targetId)
                end
            end
            
            if playerData then
                local player = GetPlayerPed(targetId)
                if player then
                    local coords = GetEntityCoords(player)
                    local x = math.floor(coords.x * 100) / 100
                    local y = math.floor(coords.y * 100) / 100
                    local z = math.floor(coords.z * 100) / 100
                    print("Coordenadas do jogador " .. targetId .. " (FixedID: " .. (playerData.fixed_id or "N/A") .. "): " .. x .. ", " .. y .. ", " .. z)
                end
            else
                print("Jogador não encontrado!")
            end
        else
            print("Uso: cdstest <player_id ou fixed_id>")
        end
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local targetId = tonumber(args[1])
        if targetId then
            -- Tentar encontrar por player_id primeiro
            local playerData = GetPlayerData(targetId)
            if not playerData then
                -- Se não encontrou, tentar por fixed_id
                local foundPlayerId = exports['framework']:GetPlayerIdByFixedId(targetId)
                if foundPlayerId then
                    targetId = foundPlayerId
                    playerData = GetPlayerData(targetId)
                end
            end
            
            if playerData then
                local player = GetPlayerPed(targetId)
                if player then
                    local coords = GetEntityCoords(player)
                    local x = math.floor(coords.x * 100) / 100
                    local y = math.floor(coords.y * 100) / 100
                    local z = math.floor(coords.z * 100) / 100
                    TriggerClientEvent('pvp:showCoordsF8', source, x, y, z)
                    TriggerClientEvent('pvp:notification', source, "Coordenadas do jogador " .. targetId .. " (FixedID: " .. (playerData.fixed_id or "N/A") .. "): " .. x .. ", " .. y .. ", " .. z, "info")
                end
            else
                TriggerClientEvent('pvp:notification', source, "Jogador não encontrado!", "error")
            end
        else
            TriggerClientEvent('pvp:notification', source, "Uso: /cdstest <player_id ou fixed_id>", "error")
        end
    end
end, false)

-- Função para verificar se jogador está protegido
function IsPlayerProtected(playerId)
    local playerData = GetPlayerData(playerId)
    return playerData and playerData.isProtected
end

-- Função para obter dados do jogador
function GetPlayerStats(playerId)
    local playerData = GetPlayerData(playerId)
    if playerData then
        return {
            kills = playerData.kills,
            deaths = playerData.deaths,
            kdRatio = Utils.CalculateKDRatio(playerData.kills, playerData.deaths),
            money = playerData.money,
            isProtected = playerData.isProtected
        }
    end
    return nil
end

-- Função para resetar estatísticas do jogador
function ResetPlayerStats(playerId)
    local playerData = GetPlayerData(playerId)
    if playerData then
        playerData.kills = 0
        playerData.deaths = 0
        playerData.money = 1000
        Utils.SendNotification(playerId, "Estatísticas resetadas!", "info")
    end
end

-- Exportar funções
exports('IsPlayerProtected', IsPlayerProtected)
exports('GetPlayerStats', GetPlayerStats)
exports('ResetPlayerStats', ResetPlayerStats) 