-- PvP Framework - Server Movement System

-- Função para enviar configurações de movimento para todos os clientes
function SendMovementConfigToAll()
    TriggerClientEvent('pvp:updateMovementConfig', -1, Config.PlayerMovement)
end

-- Função para enviar configurações de movimento para um jogador específico
function SendMovementConfigToPlayer(playerId)
    if playerId and GetPlayerName(playerId) then
        TriggerClientEvent('pvp:updateMovementConfig', playerId, Config.PlayerMovement)
        print("[MOVEMENT] Configurações enviadas para " .. GetPlayerName(playerId))
    end
end

-- Comando para alterar velocidade de movimento (para todos os jogadores)
RegisterCommand('setmovement', function(source, args)
    
    if #args < 2 then
            TriggerClientEvent('notify:show', source, {type = "info", message = "Uso: /setmovement [tipo] [valor]"})
    TriggerClientEvent('notify:show', source, {type = "info", message = "Tipos: walk, run, sprint, swim"})
        return
    end
    
    local movementType = args[1]
    local value = tonumber(args[2])
    
    if not value or value < 0.1 or value > 3.0 then
        TriggerClientEvent('notify:show', source, {type = "error", message = "Valor deve ser entre 0.1 e 3.0"})
        return
    end
    
    local validTypes = {
        walk = 'walkSpeed',
        run = 'runSpeed', 
        sprint = 'sprintSpeed',
        swim = 'swimSpeed'
    }
    
    if not validTypes[movementType] then
        TriggerClientEvent('notify:show', source, {type = "error", message = "Tipo inválido. Use: walk, run, sprint, swim"})
        return
    end
    
    Config.PlayerMovement[validTypes[movementType]] = value
    SendMovementConfigToAll()
    
    local playerName = GetPlayerName(source) or "Admin"
    TriggerClientEvent('notify:show', source, {type = "success", message = "Velocidade de " .. movementType .. " alterada para " .. value})
    
    -- Log da alteração
    Utils.Log("[MOVEMENT] " .. playerName .. " alterou " .. movementType .. " para " .. value)
end, false)

-- Comando para resetar todas as velocidades
RegisterCommand('resetmovement', function(source, args)
    
    Config.PlayerMovement = {
        walkSpeed = 1.0,
        runSpeed = 1.0,
        sprintSpeed = 1.0,
        swimSpeed = 1.0
    }
    
    SendMovementConfigToAll()
    TriggerClientEvent('notify:show', source, {type = "success", message = "Todas as velocidades foram resetadas!"})
    
    local playerName = GetPlayerName(source) or "Admin"
    Utils.Log("[MOVEMENT] " .. playerName .. " resetou todas as velocidades")
end, false)

-- Comando para mostrar configurações atuais
RegisterCommand('movement', function(source, args)
    
    local config = Config.PlayerMovement
    TriggerClientEvent('notify:show', source, {type = "info", message = "Configurações de Movimento:"})
    TriggerClientEvent('notify:show', source, {type = "info", message = "Andar: " .. config.walkSpeed})
    TriggerClientEvent('notify:show', source, {type = "info", message = "Correr: " .. config.runSpeed})
    TriggerClientEvent('notify:show', source, {type = "info", message = "Sprint: " .. config.sprintSpeed})
    TriggerClientEvent('notify:show', source, {type = "info", message = "Natação: " .. config.swimSpeed})
end, false)

-- Evento para quando um jogador entrar no servidor
RegisterNetEvent('pvp:playerJoined')
AddEventHandler('pvp:playerJoined', function()
    local playerId = source
    SendMovementConfigToPlayer(playerId)
end)

-- Evento para quando um jogador spawnar
RegisterNetEvent('pvp:playerSpawned')
AddEventHandler('pvp:playerSpawned', function()
    local playerId = source
    Wait(1000) -- Aguardar um pouco
    SendMovementConfigToPlayer(playerId)
end)

-- Enviar configurações para todos os jogadores quando o servidor iniciar
CreateThread(function()
    Wait(5000) -- Aguardar 5 segundos para o servidor inicializar
    SendMovementConfigToAll()
    -- Utils.Log("[MOVEMENT] Configurações de movimento enviadas para todos os jogadores")
end)

-- Enviar configurações para novos jogadores que entrarem
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    -- Aguardar o jogador conectar completamente
    CreateThread(function()
        Wait(10000) -- Aguardar 10 segundos para garantir que o jogador está conectado
        local players = GetPlayers()
        for _, playerId in ipairs(players) do
            if GetPlayerName(playerId) == name then
                SendMovementConfigToPlayer(playerId)
                TriggerClientEvent('pvp:applySpeedOnJoin', playerId)
                break
            end
        end
    end)
end)

-- Evento para quando um jogador entrar no servidor
AddEventHandler('playerJoining', function()
    local playerId = source
    CreateThread(function()
        Wait(5000) -- Aguardar 5 segundos
        SendMovementConfigToPlayer(playerId)
        TriggerClientEvent('pvp:applySpeedOnJoin', playerId)
    end)
end)

-- Exportar funções para outros recursos
exports('SendMovementConfigToAll', SendMovementConfigToAll)
exports('SendMovementConfigToPlayer', SendMovementConfigToPlayer) 