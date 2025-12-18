-- PvP Framework - Events Server

-- Evento quando jogador morre
RegisterNetEvent('pvp:playerDied')
AddEventHandler('pvp:playerDied', function(killedBy, reason)
    local source = source
    if not source then return end
    
    -- NÃO use GetPlayerPed ou DoesEntityExist no server
    if not GetPlayerName(source) then return end
    
    local playerData = GetPlayerData(source)
    if playerData and not playerData.isProtected then
        playerData.deaths = playerData.deaths + 1
        playerData.money = playerData.money - Config.Events.deathPenalty
        
        -- Salvar dados após morte usando o sistema de persistência
        exports['framework']:SavePlayerData(source, playerData)
        print("[DEBUG] Dados salvos após morte do jogador:", source, "FixedID:", playerData.fixed_id or "N/A")
        
        -- Trigger evento de morte com fixed_id
        TriggerEvent('playerDeath', killedBy, reason)
        
        -- NÃO salvar armas do jogador antes da morte
        -- if Config.Respawn.saveWeaponsOnDeath then
        --     local playerWeapons = GetAllPlayerWeapons(source)
        --     if playerWeapons and #playerWeapons > 0 then
        --         playerData.lastWeapons = playerWeapons
        --         Utils.Log("Armas salvas para jogador " .. playerData.name .. ": " .. #playerWeapons .. " armas")
        --     end
        -- end
        
        -- Verificar se foi headshot
        local isHeadshot = false
        -- Não é possível checar bone do ped no server, só no client
        --if killedBy and killedBy ~= -1 then
        --    local bone = GetPedLastDamageBone(player)
        --    isHeadshot = Utils.IsHeadshot(bone)
        --end
        
        -- Notificar morte
        local deathMessage = "Você morreu!"
        if isHeadshot then
            deathMessage = "Você foi headshot!"
        end
        
        Utils.SendNotification(source, deathMessage, "error")
        
        -- Respawn após tempo definido
        -- SetTimeout(Config.RespawnTime, function()
        --     if GetPlayerData(source) then
        --         TriggerClientEvent('pvp:respawn', source)
        --     end
        -- end)
    end
end)

-- Evento quando jogador mata outro (com fixed_id)
RegisterNetEvent('pvp:playerKilled')
AddEventHandler('pvp:playerKilled', function(victimId)
    local source = source
    if not source then return end
    
    local playerData = GetPlayerData(source)
    if playerData then
        playerData.kills = playerData.kills + 1
        playerData.money = playerData.money + Config.Events.killReward
        
        -- Salvar dados após kill usando o sistema de persistência
        exports['framework']:SavePlayerData(source, playerData)
        print("[DEBUG] Dados salvos após kill do jogador:", source, "FixedID:", playerData.fixed_id or "N/A", "Victim:", victimId)
        
        -- Trigger evento de kill com fixed_id
        TriggerEvent('playerKill', victimId)
        
        -- Notificar kill
        local victimData = GetPlayerData(victimId)
        local victimName = victimData and victimData.name or "Desconhecido"
        local victimFixedId = victimData and victimData.fixed_id or "N/A"
        
        Utils.SendNotification(source, "Você matou " .. victimName .. " (ID: " .. victimFixedId .. ")!", "success")
        
        -- Notificar vítima
        if victimData then
            Utils.SendNotification(victimId, "Você foi morto por " .. playerData.name .. " (ID: " .. playerData.fixed_id .. ")!", "error")
        end
    end
end)

-- Evento quando jogador entra em uma zona
RegisterNetEvent('pvp:zoneEntered')
AddEventHandler('pvp:zoneEntered', function(zoneId)
    local source = source
    local playerData = GetPlayerData(source)
    
    if playerData then
        AddPlayerToZone(source, zoneId)
    end
end)

-- Evento quando jogador sai de uma zona
RegisterNetEvent('pvp:zoneLeft')
AddEventHandler('pvp:zoneLeft', function(zoneId)
    local source = source
    local playerData = GetPlayerData(source)
    
    if playerData then
        RemovePlayerFromZone(source, zoneId)
    end
end)

-- Evento quando jogador muda de arma
RegisterNetEvent('pvp:weaponChanged')
AddEventHandler('pvp:weaponChanged', function(weapon)
    local source = source
    local playerData = GetPlayerData(source)
    
    if playerData then
        -- Log da mudança de arma (opcional)
        Utils.Log("Jogador " .. playerData.name .. " (FixedID: " .. (playerData.fixed_id or "N/A") .. ") mudou para: " .. weapon)
    end
end)

-- Evento quando jogador recarrega arma
RegisterNetEvent('pvp:weaponReloaded')
AddEventHandler('pvp:weaponReloaded', function(weapon)
    local source = source
    local playerData = GetPlayerData(source)
    
    if playerData then
        -- Log da recarga (opcional)
        Utils.Log("Jogador " .. playerData.name .. " (FixedID: " .. (playerData.fixed_id or "N/A") .. ") recarregou: " .. weapon)
    end
end)

-- Evento quando jogador é teleportado
RegisterNetEvent('pvp:playerTeleported')
AddEventHandler('pvp:playerTeleported', function(x, y, z)
    local source = source
    if not source then return end
    
    local playerData = GetPlayerData(source)
    
    if playerData then
        -- Verificar se o jogador é válido antes de chamar GetPlayerPed
        if not GetPlayerName(source) then return end
        local player = GetPlayerPed(source)
        SetEntityCoords(player, x, y, z, false, false, false, true)
        Utils.SendNotification(source, "Teleportado!", "info")
    end
end)

-- Evento quando jogador é curado
RegisterNetEvent('pvp:playerHealed')
AddEventHandler('pvp:playerHealed', function()
    local source = source
    if not source then return end
    
    local playerData = GetPlayerData(source)
    
    if playerData then
        -- Verificar se o jogador é válido antes de chamar GetPlayerPed
        if not GetPlayerName(source) then return end
        local player = GetPlayerPed(source)
        SetEntityHealth(player, 200)
        ClearPedBloodDamage(player)
      
    end
end)

-- Evento quando jogador faz respawn
RegisterNetEvent('pvp:playerRespawned')
AddEventHandler('pvp:playerRespawned', function()
    local source = source
    local playerData = GetPlayerData(source)
    
    if playerData then
        -- Resetar proteção
        playerData.isProtected = true
        playerData.spawnTime = GetGameTimer()
        
        -- NÃO dar armas automaticamente no respawn
        -- Restaurar armas do jogador se existirem, senão dar armas padrão
        -- if Config.Respawn.restoreWeaponsOnRespawn and playerData.lastWeapons and #playerData.lastWeapons > 0 then
        --     -- Restaurar armas salvas
        --     local weaponsToGive = {}
        --     for _, weaponData in ipairs(playerData.lastWeapons) do
        --         table.insert(weaponsToGive, weaponData.weapon)
        --     end
        --     TriggerClientEvent('pvp:giveWeapons', source, weaponsToGive)
        --     Utils.Log("Armas restauradas para jogador " .. playerData.name .. ": " .. #playerData.lastWeapons .. " armas")
        --     -- Limpar armas salvas após restaurar
        --     playerData.lastWeapons = nil
        -- else
        --     -- Dar armas padrão se não houver armas salvas ou se a restauração estiver desabilitada
        --     if Config.Respawn.fallbackToDefaultWeapons then
        --         TriggerClientEvent('pvp:giveWeapons', source, Config.DefaultWeapons)
        --         Utils.Log("Armas padrão dadas para jogador " .. playerData.name)
        --     end
        -- end
        
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

-- Evento para solicitar dados do jogador
RegisterNetEvent('pvp:getPlayerData')
AddEventHandler('pvp:getPlayerData', function()
    local source = source
    local playerData = GetPlayerData(source)
    
    if playerData then
        TriggerClientEvent('pvp:receivePlayerData', source, playerData)
    end
end)

-- Evento para solicitar estatísticas pessoais
RegisterNetEvent('pvp:getPersonalStats')
AddEventHandler('pvp:getPersonalStats', function()
    local source = source
    local playerData = GetPlayerData(source)
    
    if playerData then
        local stats = {
            fixed_id = playerData.fixed_id,
            kills = playerData.kills,
            deaths = playerData.deaths,
            kdRatio = Utils.CalculateKDRatio(playerData.kills, playerData.deaths),
            money = playerData.money,
            rank = GetPlayerRank(source)
        }
        
        TriggerClientEvent('pvp:receivePersonalStats', source, stats)
    end
end)

-- Evento para solicitar scoreboard
RegisterNetEvent('pvp:requestScoreboard')
AddEventHandler('pvp:requestScoreboard', function()
    local source = source
    local scoreboardData = GetScoreboardData()
    TriggerClientEvent('pvp:updateScoreboard', source, scoreboardData)
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

-- Evento para obter armas do jogador
RegisterNetEvent('pvp:getPlayerWeapons')
AddEventHandler('pvp:getPlayerWeapons', function()
    local source = source
    local weapons = GetPlayerWeapons(source)
    TriggerClientEvent('pvp:receivePlayerWeapons', source, weapons)
end)

-- Evento para solicitar fixed_id do jogador
RegisterNetEvent('pvp:requestFixedId')
AddEventHandler('pvp:requestFixedId', function()
    local source = source
    local playerData = GetPlayerData(source)
    
    if playerData and playerData.fixed_id then
        TriggerClientEvent('pvp:receiveFixedId', source, playerData.fixed_id)
    else
        TriggerClientEvent('pvp:receiveFixedId', source, nil)
    end
end)

-- Evento para buscar jogador por fixed_id
RegisterNetEvent('pvp:findPlayerByFixedId')
AddEventHandler('pvp:findPlayerByFixedId', function(fixed_id)
    local source = source
    local targetPlayerId = exports['framework']:GetPlayerIdByFixedId(fixed_id)
    
    if targetPlayerId then
        local targetPlayerData = GetPlayerData(targetPlayerId)
        TriggerClientEvent('pvp:receivePlayerByFixedId', source, {
            playerId = targetPlayerId,
            fixed_id = targetPlayerData.fixed_id,
            name = targetPlayerData.name,
            kills = targetPlayerData.kills,
            deaths = targetPlayerData.deaths
        })
    else
        TriggerClientEvent('pvp:receivePlayerByFixedId', source, nil)
    end
end)

-- Função para enviar evento para todos os jogadores
function SendEventToAll(eventName, ...)
    TriggerClientEvent(eventName, -1, ...)
end

-- Função para enviar evento para jogadores em uma zona
function SendEventToZone(zoneId, eventName, ...)
    local zone = ActiveZones[zoneId]
    if zone then
        for playerId, _ in pairs(zone.players) do
            TriggerClientEvent(eventName, playerId, ...)
        end
    end
end

-- Função para enviar evento para jogadores próximos
function SendEventToNearbyPlayers(playerId, eventName, radius, ...)
    local player = GetPlayerPed(playerId)
    local playerPos = GetEntityCoords(player)
    
    for id, _ in pairs(Players) do
        if id ~= playerId then
            local otherPlayer = GetPlayerPed(id)
            local otherPos = GetEntityCoords(otherPlayer)
            local distance = Utils.GetDistance(playerPos, otherPos)
            
            if distance <= radius then
                TriggerClientEvent(eventName, id, ...)
            end
        end
    end
end

-- Exportar funções
exports('SendEventToAll', SendEventToAll)
exports('SendEventToZone', SendEventToZone)
exports('SendEventToNearbyPlayers', SendEventToNearbyPlayers) 