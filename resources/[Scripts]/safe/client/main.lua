-- Safe Zone Client Script
local isInSafeZone = false
local currentSafeZone = nil
local safeZoneBlips = {}

-- Função para verificar se o jogador está em uma safe zone
function IsPlayerInSafeZone()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    for i, zone in ipairs(Config.SafeZones) do
        local distance = #(playerCoords - zone.coords)
        if distance <= zone.radius then
            return true, zone
        end
    end
    
    return false, nil
end

-- Função para desenhar safe zone usando DrawMarker (bolha no chão)
function DrawSafeZone(coords, radius, height, color)
    -- Ajustar altura para ficar no chão
    local groundZ = coords.z - 10.0 -- 10 metros abaixo da coordenada original
    
    -- Desenhar cilindro principal (bolha sólida no chão)
    DrawMarker(
        1, -- Tipo: cilindro
        coords.x, coords.y, groundZ, -- Posição no chão
        0.0, 0.0, 0.0, -- Direção
        0.0, 0.0, 0.0, -- Rotação
        radius * 2, radius * 2, height, -- Escala (largura, altura, profundidade)
        color.r, color.g, color.b, color.a, -- Cor
        false, -- Bob up and down
        false, -- Face camera
        2, -- P19 (rotatable)
        false, -- Draw on entities
        nil, -- Texture dict
        nil, -- Texture name
        false -- Draw on entities
    )
    
    -- Desenhar círculo no chão (borda)
    DrawMarker(
        25, -- Tipo: cilindro no chão
        coords.x, coords.y, groundZ - 0.5, -- Posição ligeiramente abaixo do chão
        0.0, 0.0, 0.0, -- Direção
        0.0, 0.0, 0.0, -- Rotação
        radius * 2, radius * 2, 1.0, -- Escala (largura, altura, profundidade)
        color.r, color.g, color.b, color.a, -- Cor
        false, -- Bob up and down
        false, -- Face camera
        2, -- P19 (rotatable)
        false, -- Draw on entities
        nil, -- Texture dict
        nil, -- Texture name
        false -- Draw on entities
    )
    
    -- Desenhar borda superior
    DrawMarker(
        1, -- Tipo: cilindro
        coords.x, coords.y, groundZ + height, -- Posição no topo
        0.0, 0.0, 0.0, -- Direção
        0.0, 0.0, 0.0, -- Rotação
        radius * 2, radius * 2, 1.0, -- Escala (largura, altura, profundidade)
        color.r, color.g, color.b, color.a, -- Cor
        false, -- Bob up and down
        false, -- Face camera
        2, -- P19 (rotatable)
        false, -- Draw on entities
        nil, -- Texture dict
        nil, -- Texture name
        false -- Draw on entities
    )
end

-- Função para criar blips das safe zones
function CreateSafeZoneBlips()
    for i, zone in ipairs(Config.SafeZones) do
        local blip = AddBlipForCoord(zone.coords.x, zone.coords.y, zone.coords.z)
        SetBlipSprite(blip, Config.BlipSprite)
        SetBlipScale(blip, Config.BlipScale)
        SetBlipColour(blip, Config.BlipColor)
        SetBlipAlpha(blip, Config.BlipAlpha)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Safe Zone - " .. zone.name)
        EndTextCommandSetBlipName(blip)
        
        table.insert(safeZoneBlips, blip)
    end
end

-- Função para remover blips
function RemoveSafeZoneBlips()
    for _, blip in ipairs(safeZoneBlips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    safeZoneBlips = {}
end

-- Thread principal para desenhar as safe zones
CreateThread(function()
    while true do
        Wait(Config.UpdateInterval)
        
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        for i, zone in ipairs(Config.SafeZones) do
            local distance = #(playerCoords - zone.coords)
            
            -- Só desenhar se estiver próximo o suficiente
            if distance <= Config.DrawDistance then
                -- Debug: verificar se está desenhando
                if distance <= 50.0 then -- Só mostrar debug quando muito próximo
                 
                end
                
                DrawSafeZone(zone.coords, zone.radius, zone.height, zone.color)
            end
        end
    end
end)

-- Thread para verificar se o jogador está em safe zone
CreateThread(function()
    while true do
        Wait(500) -- Verificar a cada 500ms
        
        local wasInSafeZone = isInSafeZone
        local inSafeZone, zone = IsPlayerInSafeZone()
        
        if inSafeZone and not wasInSafeZone then
            -- Entrou na safe zone
            isInSafeZone = true
            currentSafeZone = zone
            TriggerEvent('safe:enteredZone', zone)
            -- Aqui você pode adicionar lógica adicional quando entrar na zona
            -- Por exemplo, desabilitar PvP, mostrar notificação, etc.
        elseif not inSafeZone and wasInSafeZone then
            -- Saiu da safe zone
            isInSafeZone = false
            local previousZone = currentSafeZone
            currentSafeZone = nil
            TriggerEvent('safe:leftZone', previousZone)
            
            -- Ativar progressbar quando sair da safezone (se habilitado)
            if Config.ProgressBarOnExit.enabled then
                TriggerEvent('hud:showProgressBarOnExit', {
                    duration = Config.ProgressBarOnExit.duration,
                    showPercentage = Config.ProgressBarOnExit.showPercentage,
                    type = Config.ProgressBarOnExit.type
                })
            end
        end
    end
end)

-- Eventos para quando entrar/sair da safe zone (notificações desabilitadas)
RegisterNetEvent('safe:enteredZone')
AddEventHandler('safe:enteredZone', function(zone)
    -- Notificações desabilitadas
    -- print("^2[SAFE ZONE]^7 Entrou na zona: " .. zone.name)
end)

RegisterNetEvent('safe:leftZone')
AddEventHandler('safe:leftZone', function(zone)
    -- Notificações desabilitadas
    -- print("^3[SAFE ZONE]^7 Saiu da zona: " .. zone.name)
end)

-- Comando para toggle das safe zones (apenas para admins)
RegisterCommand('togglesafezones', function()
    -- Usar sistema de permissões do framework se disponível
    if GetResourceState('pvp') == 'started' and exports['pvp'] and exports['pvp'].CheckPermission then
        exports['pvp']:CheckPermission('admin.all', function(hasPermission)
            if hasPermission then
                ToggleSafeZones()
            else
                if exports['pvp'] and exports['pvp'].SendNotification then
                    exports['pvp']:SendNotification(nil, "Você não tem permissão para usar este comando!", "error")
                else
                    SetNotificationTextEntry("STRING")
                    AddTextComponentString("Você não tem permissão para usar este comando!")
                    DrawNotification(false, false)
                end
            end
        end)
    else
        ToggleSafeZones()
    end
end, false)

-- Função para alternar visibilidade das safe zones
function ToggleSafeZones()
    Config.ShowBlips = not Config.ShowBlips
    
    if Config.ShowBlips then
        CreateSafeZoneBlips()
        if GetResourceState('pvp') == 'started' and exports['pvp'] and exports['pvp'].SendNotification then
            exports['pvp']:SendNotification(nil, "Blips das Safe Zones ativados no mapa", "success")
        else
            SetNotificationTextEntry("STRING")
            AddTextComponentString("Blips das Safe Zones ativados no mapa")
            DrawNotification(false, false)
        end
    else
        RemoveSafeZoneBlips()
        if GetResourceState('pvp') == 'started' and exports['pvp'] and exports['pvp'].SendNotification then
            exports['pvp']:SendNotification(nil, "Blips das Safe Zones desativados no mapa", "info")
        else
            SetNotificationTextEntry("STRING")
            AddTextComponentString("Blips das Safe Zones desativados no mapa")
            DrawNotification(false, false)
        end
    end
end

-- Comando para verificar se está em safe zone
RegisterCommand('safezone', function()
    if isInSafeZone then
        if GetResourceState('pvp') == 'started' and exports['pvp'] and exports['pvp'].SendNotification then
            exports['pvp']:SendNotification(nil, "Você está na Safe Zone: " .. currentSafeZone.name, "info")
        else
            SetNotificationTextEntry("STRING")
            AddTextComponentString("Você está na Safe Zone: " .. currentSafeZone.name)
            DrawNotification(false, false)
        end
    else
        if GetResourceState('pvp') == 'started' and exports['pvp'] and exports['pvp'].SendNotification then
            exports['pvp']:SendNotification(nil, "Você não está em uma Safe Zone", "warning")
        else
            SetNotificationTextEntry("STRING")
            AddTextComponentString("Você não está em uma Safe Zone")
            DrawNotification(false, false)
        end
    end
end, false)

-- Comando de teste para forçar desenho de uma zona
RegisterCommand('testsafezone', function()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local testZone = {
        coords = playerCoords,
        radius = 50.0,
        height = 100.0,
        color = {r = 0, g = 255, b = 0, a = 150} -- Verde com alta opacidade para teste
    }
    
    print("^2[SAFE ZONE TEST]^7 Desenhando zona de teste em: " .. playerCoords.x .. ", " .. playerCoords.y .. ", " .. playerCoords.z)
    
    -- Desenhar zona de teste por 10 segundos
    CreateThread(function()
        local endTime = GetGameTimer() + 10000 -- 10 segundos
        while GetGameTimer() < endTime do
            DrawSafeZone(testZone.coords, testZone.radius, testZone.height, testZone.color)
            Wait(0)
        end
    end)
    
    if GetResourceState('pvp') == 'started' and exports['pvp'] and exports['pvp'].SendNotification then
        exports['pvp']:SendNotification(nil, "Zona de teste desenhada por 10 segundos!", "info")
    else
        SetNotificationTextEntry("STRING")
        AddTextComponentString("Zona de teste desenhada por 10 segundos!")
        DrawNotification(false, false)
    end
end, false)

-- Comando para testar a progressbar de saída da safezone
RegisterCommand('testprogressbar', function()
    print("^2[SAFE ZONE TEST]^7 Simulando saída da safezone...")
    
    -- Simular evento de saída da safezone
    TriggerEvent('hud:showProgressBarOnExit', {
        duration = Config.ProgressBarOnExit.duration,
        showPercentage = Config.ProgressBarOnExit.showPercentage,
        type = Config.ProgressBarOnExit.type
    })
    
    if GetResourceState('pvp') == 'started' and exports['pvp'] and exports['pvp'].SendNotification then
        exports['pvp']:SendNotification(nil, "Testando progressbar de saída da safezone!", "info")
    else
        SetNotificationTextEntry("STRING")
        AddTextComponentString("Testando progressbar de saída da safezone!")
        DrawNotification(false, false)
    end
end, false)


-- Inicialização
CreateThread(function()
    Wait(2000) -- Aguardar carregamento completo
    
    -- Blips desativados por padrão - apenas visualização 3D no jogo
    -- if Config.ShowBlips then
    --     CreateSafeZoneBlips()
    -- end
    
    print("^2[SAFE ZONE]^7 Sistema carregado com " .. #Config.SafeZones .. " zonas configuradas (apenas visualização 3D)")
end)

-- Cleanup ao parar o resource
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        RemoveSafeZoneBlips()
        print("^1[SAFE ZONE]^7 Sistema parado")
    end
end)

-- Exportar funções para outros resources
exports('IsPlayerInSafeZone', IsPlayerInSafeZone)
exports('GetCurrentSafeZone', function()
    return currentSafeZone
end)
exports('IsInSafeZone', function()
    return isInSafeZone
end)
