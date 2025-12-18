-- Wall System - Client Side
-- Adaptado para PvP Framework

Config = {}

-- Função de notificação alternativa
local function SendNotification(message, type)
    if Utils and Utils.SendNotification then
        Utils.SendNotification(nil, message, type)
    else
        -- Notificação alternativa usando o sistema nativo do GTA
        SetNotificationTextEntry('STRING')
        AddTextComponentString(message)
        DrawNotification(false, false)
        print("[Wall] " .. message)
    end
end

local mostrando = false
local players = {}
local staff = false
local hasPermission = false

-- Comando para ativar/desativar wall
RegisterCommand("wall", function()
    print("[Wall Debug] Comando /wall executado!")
    SendNotification("Verificando permissão...", "info")
    TriggerServerEvent('wall:checkPermission')
end)

-- Evento para receber resultado da verificação de permissão
RegisterNetEvent('wall:permissionResult')
AddEventHandler('wall:permissionResult', function(hasPerm)
    print("[Wall Debug] Recebido resultado de permissão:", hasPerm)
    hasPermission = hasPerm
    
    if hasPermission then
        mostrando = not mostrando
        
        if mostrando then
            SendNotification("Wall ativado", "success")
            print("[Wall Debug] Wall ativado!")
        else
            SendNotification("Wall desativado", "info")
            print("[Wall Debug] Wall desativado!")
        end
    else
        SendNotification("Você não tem permissão para usar este comando!", "error")
        print("[Wall Debug] Sem permissão!")
    end
end)

-- Thread principal para desenhar o wall
CreateThread(function()
    while true do
        Wait(1)
        
        if mostrando and hasPermission then
            local playerPos = GetEntityCoords(PlayerPedId())
            
            for _, id in ipairs(GetActivePlayers()) do
                local targetPed = GetPlayerPed(id)
                local targetPos = GetEntityCoords(targetPed)
                local distance = GetDistanceBetweenCoords(playerPos, targetPos)
                local name = GetPlayerName(id)
                
                if name == nil or name == "" or name == -1 then
                    name = "Steam indisponível"
                end
                
                local health = (GetEntityHealth(targetPed) - 100)
                if health == 1 then
                    health = 0
                end
                local healthpercent = health / 1
                healthpercent = math.floor(healthpercent)
                
                if distance <= Config.DistanciaWall then
                    -- Desenhar linha até o jogador
                    DrawLine(
                        playerPos.x, playerPos.y, playerPos.z,
                        targetPos.x, targetPos.y, targetPos.z,
                        129, 61, 138, 255
                    )
                    
                    -- Desenhar texto 3D
                    local displayText = string.format(
                        "~g~%s\n~b~Vida: ~w~%d%%\n~b~ID: ~w~%s\n~b~Distância: ~w~%dm",
                        name, healthpercent, players[id] or "N/A", math.floor(distance)
                    )
                    
                    DrawText3D(targetPos.x, targetPos.y, targetPos.z + 1.20, displayText)
                end
            end
        end
    end
end)

-- Thread para atualizar IDs dos jogadores
CreateThread(function()
    while true do
        for _, id in ipairs(GetActivePlayers()) do
            if id ~= -1 and id ~= nil then
                TriggerServerEvent('wall:getPlayerId')
                Wait(100) -- Pequena pausa para evitar spam
            end
        end
        Wait(1400)
    end
end)

-- Evento para receber ID do jogador
RegisterNetEvent('wall:receivePlayerId')
AddEventHandler('wall:receivePlayerId', function(playerId)
    if playerId then
        players[GetPlayerServerId(PlayerId())] = playerId
    end
end)

-- Thread para verificar status de admin
CreateThread(function()
    while true do
        TriggerServerEvent('wall:checkAdmin')
        Wait(12000)
    end
end)

-- Evento para receber resultado de verificação de admin
RegisterNetEvent('wall:adminResult')
AddEventHandler('wall:adminResult', function(isAdmin)
    staff = isAdmin
end)

-- Função para desenhar texto 3D
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
    
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    
    if onScreen then
        SetTextFont(0)
        SetTextProportional(1)
        SetTextScale(0.0, 0.25)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

-- Thread para atualizar IDs dos jogadores (backup)
CreateThread(function()
    while true do
        Wait(1)
        for _, id in ipairs(GetActivePlayers()) do
            local pid = GetPlayerServerId(id)
            if pid and pid ~= -1 then
                players[id] = pid
            end
        end
    end
end)

-- Inicialização
CreateThread(function()
    Wait(2000)
    print("[Wall System] Cliente inicializado!")
    print("[Wall Debug] Config.DistanciaWall:", Config.DistanciaWall)
    print("[Wall Debug] Config.Permissao:", Config.Permissao)
end)

-- Comando de teste simples
RegisterCommand("testwall", function()
    print("[Wall Test] Comando de teste executado!")
    SendNotification("Teste do Wall System", "info")
    TriggerServerEvent('wall:checkPermission')
end, false)

-- Comando para forçar ativação do wall (para teste)
RegisterCommand("forcewall", function()
    print("[Wall Test] Forçando ativação do wall!")
    mostrando = not mostrando
    hasPermission = true
    
    if mostrando then
        SendNotification("Wall FORÇADO ativado", "success")
        print("[Wall Debug] Wall forçado ativado!")
    else
        SendNotification("Wall FORÇADO desativado", "info")
        print("[Wall Debug] Wall forçado desativado!")
    end
end, false)