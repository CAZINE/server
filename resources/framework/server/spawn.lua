-- PvP Framework - Custom Spawn System (Server)

local SpawnPoints = Config.SpawnPoints or {
    {x = -1037.74, y = -2738.04, z = 20.17, heading = 327.94},
    {x = -800.0, y = -2500.0, z = 20.0, heading = 0.0},
    {x = -1200.0, y = -3000.0, z = 20.0, heading = 180.0},
    {x = -1000.0, y = -2800.0, z = 20.0, heading = 90.0}
}

-- Função para obter spawn point aleatório
function GetRandomSpawnPoint()
    return SpawnPoints[math.random(#SpawnPoints)]
end

-- Função para spawnar jogador
function SpawnPlayer(playerId)
    local playerData = GetPlayerData(playerId)
    if not playerData then
        -- Inicializa o jogador se não existir
        playerData = {
            id = playerId,
            name = GetPlayerName(playerId),
            kills = 0,
            deaths = 0,
            money = 1000,
            spawnTime = GetGameTimer(),
            isProtected = true,
            currentZone = nil,
            lastKill = 0
        }
        -- Adiciona à tabela Players
        SetPlayerData(playerId, playerData)
    end
    
    -- Verificar se o jogador é válido antes de chamar GetPlayerPed
    if not playerId or not DoesEntityExist(GetPlayerPed(playerId)) then return false end
    local player = GetPlayerPed(playerId)
    
    
    local spawnPoint = GetRandomSpawnPoint()
    
    -- Teleportar para spawn point
    SetEntityCoords(player, spawnPoint.x, spawnPoint.y, spawnPoint.z, false, false, false, true)
    SetEntityHeading(player, spawnPoint.heading)
    
    -- Restaurar vida e armadura
    -- SetEntityHealth(player, 200)
    -- SetPedArmour(player, 0)
    
    -- Limpar sangue
    -- ClearPedBloodDamage(player)
    
    -- Restaurar armas do jogador se existirem, senão dar armas padrão
    -- NÃO restaurar armas salvas nem dar armas padrão no respawn
    -- if Config.Respawn.restoreWeaponsOnRespawn and playerData.lastWeapons and #playerData.lastWeapons > 0 then
    --     -- Restaurar armas salvas
    --     local weaponsToGive = {}
    --     for _, weaponData in ipairs(playerData.lastWeapons) do
    --         table.insert(weaponsToGive, weaponData.weapon)
    --     end
    --     TriggerClientEvent('pvp:giveWeapons', playerId, weaponsToGive)
    --     Utils.Log("Armas restauradas para jogador " .. playerData.name .. ": " .. #playerData.lastWeapons .. " armas")
    --     -- Limpar armas salvas após restaurar
    --     playerData.lastWeapons = nil
    -- else
    --     if Config.Respawn.fallbackToDefaultWeapons then
    --         TriggerClientEvent('pvp:giveWeapons', playerId, Config.DefaultWeapons)
    --         Utils.Log("Armas padrão dadas para jogador " .. playerData.name)
    --     end
    -- end
    
    -- Configurar proteção de spawn
    playerData.isProtected = true
    playerData.spawnTime = GetGameTimer()
    
    -- Remover proteção após tempo
    SetTimeout(Config.SpawnProtection, function()
        local currentPlayerData = GetPlayerData(playerId)
        if currentPlayerData then
            currentPlayerData.isProtected = false
            Utils.SendNotification(playerId, "Proteção de spawn removida!", "info")
        end
    end)
    
    Utils.Log("Jogador " .. playerData.name .. " spawnou em: " .. spawnPoint.x .. ", " .. spawnPoint.y .. ", " .. spawnPoint.z)
    return true
end



-- Evento para respawn manual
RegisterNetEvent('pvp:respawn')
AddEventHandler('pvp:respawn', function()
    local source = source
    SpawnPlayer(source)
    Utils.SendNotification(source, "Respawn realizado!", "info")
end)

-- Evento para spawn em local específico
RegisterNetEvent('pvp:spawnAt')
AddEventHandler('pvp:spawnAt', function(x, y, z, heading)
    local source = source
    if not source then return end
    
    local playerData = GetPlayerData(source)
    if not playerData then return end
    
    -- Verificar se o jogador é válido antes de chamar GetPlayerPed
    if not DoesEntityExist(GetPlayerPed(source)) then return end
    local player = GetPlayerPed(source)
    
    -- Teleportar para local específico
    SetEntityCoords(player, x or -1037.74, y or -2738.04, z or 20.17, false, false, false, true)
    SetEntityHeading(player, heading or 327.94)
    
    -- Restaurar vida
    -- SetEntityHealth(player, 200)
    -- ClearPedBloodDamage(player)
    TriggerClientEvent('pvp:heal', source)
    
    -- NÃO dar armas automaticamente no spawn
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
    
    Utils.SendNotification(source, "Spawnado em local específico!", "info")
end)

-- Comando para spawn
RegisterCommand('spawn', function(source, args, rawCommand)
    if source == 0 then -- Console
        local targetId = tonumber(args[1])
        if targetId then
            local playerData = GetPlayerData(targetId)
            if playerData then
                SpawnPlayer(targetId)
                print("Jogador " .. targetId .. " spawnado!")
            end
        else
            print("Uso: spawn <player_id>")
        end
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local targetId = tonumber(args[1])
        if targetId then
            local playerData = GetPlayerData(targetId)
            if playerData then
                SpawnPlayer(targetId)
                TriggerClientEvent('pvp:notification', source, "Jogador " .. targetId .. " spawnado!", "success")
            end
        else
            TriggerClientEvent('pvp:notification', source, "Uso: /spawn <player_id>", "error")
        end
    end
end, false)

-- Comando para spawn em local específico
RegisterCommand('spawnat', function(source, args, rawCommand)
    if source == 0 then -- Console
        if #args < 3 then
            print("Uso: spawnat <player_id> [x] [y] [z] [heading]")
            return
        end
        
        local targetId = tonumber(args[1])
        local x = tonumber(args[2])
        local y = tonumber(args[3])
        local z = tonumber(args[4])
        local heading = tonumber(args[5]) or 0
        
        if targetId and x and y and z then
            TriggerClientEvent('pvp:spawnAt', targetId, x, y, z, heading)
            print("Jogador " .. targetId .. " spawnado em local específico!")
        else
            print("Parâmetros inválidos!")
        end
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        if #args < 4 then
            TriggerClientEvent('pvp:notification', source, "Uso: /spawnat <player_id> [x] [y] [z] [heading]", "error")
            return
        end
        
        local targetId = tonumber(args[1])
        local x = tonumber(args[2])
        local y = tonumber(args[3])
        local z = tonumber(args[4])
        local heading = tonumber(args[5]) or 0
        
        if targetId and x and y and z then
            TriggerClientEvent('pvp:spawnAt', targetId, x, y, z, heading)
            TriggerClientEvent('pvp:notification', source, "Jogador " .. targetId .. " spawnado em local específico!", "success")
        else
            TriggerClientEvent('pvp:notification', source, "Parâmetros inválidos!", "error")
        end
    end
end, false)

-- Exportar funções
exports('GetRandomSpawnPoint', GetRandomSpawnPoint)
exports('SpawnPlayer', SpawnPlayer) 