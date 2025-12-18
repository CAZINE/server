-- PvP Framework - Player Movement System

local isMovementEnabled = true

-- Função para aplicar velocidade de movimento
function ApplyMovementSpeed()
    if not isMovementEnabled then return end
    
    local playerPed = PlayerPedId()
    if not DoesEntityExist(playerPed) then return end
    
    -- Verificar se o ped é válido
    if not IsPedAPlayer(playerPed) then return end
    
    -- Aplicar velocidade de andar
    SetPedMoveRateOverride(playerPed, Config.PlayerMovement.walkSpeed)
    
    -- Aplicar velocidade de corrida/sprint
    SetRunSprintMultiplierForPlayer(PlayerId(), Config.PlayerMovement.sprintSpeed)
    
    -- Aplicar velocidade de natação
    SetSwimMultiplierForPlayer(PlayerId(), Config.PlayerMovement.swimSpeed)
    
    -- Debug (remover depois)
    
end

-- Função para resetar velocidade de movimento
function ResetMovementSpeed()
    local playerPed = PlayerPedId()
    if not DoesEntityExist(playerPed) then return end
    
    -- Resetar para valores padrão
    SetPedMoveRateOverride(playerPed, 1.0)
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
    SetSwimMultiplierForPlayer(PlayerId(), 1.0)
end

-- Função para habilitar/desabilitar sistema de movimento
function SetMovementEnabled(enabled)
    isMovementEnabled = enabled
    if not enabled then
        ResetMovementSpeed()
    else
        ApplyMovementSpeed()
    end
end

-- Thread principal para aplicar velocidade de movimento
CreateThread(function()
    while true do
        Wait(1000) -- Verificar a cada segundo
        
        if isMovementEnabled then
            ApplyMovementSpeed()
        end
    end
end)

-- Evento para aplicar velocidade quando o jogador spawnar
RegisterNetEvent('pvp:playerSpawned')
AddEventHandler('pvp:playerSpawned', function()
    Wait(1000) -- Aguardar um pouco para garantir que o ped foi criado
    ApplyMovementSpeed()
end)

-- Evento para aplicar velocidade quando o jogador entrar no servidor
RegisterNetEvent('playerSpawned')
AddEventHandler('playerSpawned', function()
    Wait(2000) -- Aguardar um pouco mais para garantir que tudo foi carregado
    ApplyMovementSpeed()
end)

-- Evento para aplicar velocidade quando o jogador renascer
RegisterNetEvent('pvp:respawn')
AddEventHandler('pvp:respawn', function()
    Wait(1500) -- Aguardar para garantir que o respawn foi completado
    ApplyMovementSpeed()
end)

-- Aplicar velocidade quando o script iniciar
CreateThread(function()
    Wait(3000) -- Aguardar 3 segundos para o servidor inicializar
    ApplyMovementSpeed()
end)

-- Thread para aplicar velocidade automaticamente quando o jogador entrar
CreateThread(function()
    local applied = false
    
    while not applied do
        Wait(1000)
        
        local playerPed = PlayerPedId()
        if DoesEntityExist(playerPed) and IsPedAPlayer(playerPed) then
            -- Verificar se o jogador já está carregado
            if NetworkIsPlayerActive(PlayerId()) then
                ApplyMovementSpeed()
                applied = true
                
            end
        end
    end
end)

-- Evento para receber configurações de movimento do servidor
RegisterNetEvent('pvp:updateMovementConfig')
AddEventHandler('pvp:updateMovementConfig', function(movementConfig)
    if movementConfig then
        Config.PlayerMovement = movementConfig
        ApplyMovementSpeed()
        print("[MOVEMENT] Configurações recebidas do servidor e aplicadas")
    end
end)

-- Evento para aplicar velocidade quando entrar no servidor
RegisterNetEvent('pvp:applySpeedOnJoin')
AddEventHandler('pvp:applySpeedOnJoin', function()
    Wait(2000) -- Aguardar um pouco
    ApplyMovementSpeed()
 
end)

-- Comando para testar velocidade (para todos os jogadores)
RegisterCommand('speed', function(source, args)
    if args[1] then
        local speed = tonumber(args[1])
        if speed and speed > 0 and speed <= 3.0 then
            Config.PlayerMovement.walkSpeed = speed
            Config.PlayerMovement.runSpeed = speed + 0.2
            Config.PlayerMovement.sprintSpeed = speed + 0.4
            ApplyMovementSpeed()
            TriggerEvent("notify:show", {type = "success", message = "Velocidade alterada para " .. speed})
        else
            TriggerEvent("notify:show", {type = "error", message = "Velocidade deve ser entre 0.1 e 3.0"})
        end
    else
        TriggerEvent("notify:show", {type = "info", message = "Uso: /speed [valor]"})
    end
end, false)

-- Comando para resetar velocidade
RegisterCommand('resetspeed', function()
    Config.PlayerMovement = {
        walkSpeed = 1.0,
        runSpeed = 1.0,
        sprintSpeed = 1.0,
        swimSpeed = 1.0
    }
    ResetMovementSpeed()
    TriggerEvent("notify:show", {type = "info", message = "Velocidade resetada para padrão!"})
end, false)

-- Exportar funções para outros recursos
exports('ApplyMovementSpeed', ApplyMovementSpeed)
exports('ResetMovementSpeed', ResetMovementSpeed)
exports('SetMovementEnabled', SetMovementEnabled) 