local onMenu = false
local lastVehicleModel = nil
local spawn_vehicle = GetGameTimer()

local cachedVehicles = nil


function openSpawn(list)
    if list then
        onMenu = true
        SetNuiFocus(true, true)
        
        Citizen.Wait(0)
        
        SendNUIMessage({
            action = 'open',
            vehicles = list.vehicles,
            playerLevel = list.playerLevel
        })
    end
end

function closeSpawn()
    onMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

RegisterNetEvent("car:sendVehicleList", function(data)
    cachedVehicles = data
    openSpawn(cachedVehicles)
end)

function requestVehicleMenu()
    if cachedVehicles then
        openSpawn(cachedVehicles)
    else
        TriggerServerEvent("car:getVehicleList")
    end
end

local carMenuCooldown = false

RegisterCommand('openCarMenu', function()
    if carMenuCooldown then
        TriggerEvent('Notify', 'amarelo', 'Aguarde alguns segundos para abrir novamente.', 3000)
        return
    end

    if IsPedInAnyVehicle(PlayerPedId()) then 
        return 
    end

    if exports['dominas']:insideDomZone() then
        TriggerEvent('Notify', 'vermelho', 'Você não pode spawnar um veículo enquanto estiver dentro de uma zona de dominação.', 4000)
        return
    end

    carMenuCooldown = true
    SetTimeout(15000, function()
        carMenuCooldown = false
    end)

    requestVehicleMenu()
end)

-- Registrar mapeamento de tecla APÓS declarar o comando para garantir compatibilidade
RegisterKeyMapping('openCarMenu', 'Abrir menu de veículos', 'keyboard', 'F2')

RegisterNUICallback('close', function(_, cb)
    closeSpawn()
    cb({})
end)

RegisterNUICallback('spawn', function(data, cb)
    local modelHash = GetHashKey(data.spawn)

    -- Validações básicas
    if IsPedInAnyVehicle(PlayerPedId()) then 
        TriggerEvent('Notify', 'amarelo', 'Você já está em um veículo.', 3000)
        return 
    end

    if GetEntityHealth(PlayerPedId()) <= 101 then
        TriggerEvent('Notify', 'vermelho', 'Você está morto e não pode spawnar veículos.', 4000)
        return
    end

    if exports['dominas']:insideDomZone() then
        TriggerEvent('Notify', 'vermelho', 'Você não pode spawnar um veículo enquanto estiver dentro de uma zona de dominação.', 4000)
        return
    end

    -- Verificar se o modelo é válido
    if not IsModelValid(modelHash) then 
        TriggerEvent('Notify', 'vermelho', 'Modelo de veículo inválido: ' .. data.spawn, 4000)
        return 
    end

    -- Verificar se o modelo é um veículo
    if not IsModelAVehicle(modelHash) then
        TriggerEvent('Notify', 'vermelho', 'O modelo especificado não é um veículo válido.', 4000)
        return
    end

    RequestModel(modelHash)
    
    local timeout = 0
    while not HasModelLoaded(modelHash) do
        Wait(100)
        timeout = timeout + 100
        if timeout > 10000 then -- 10 segundos de timeout
            TriggerEvent('Notify', 'vermelho', 'Timeout ao carregar modelo do veículo.', 4000)
            return
        end
    end

    TriggerServerEvent("car:spawnVehicle", data.spawn)
    lastVehicleModel = data.spawn
    SetEntityAsNoLongerNeeded(modelHash)
    closeSpawn()
    cb({})
end)

--RegisterKeyMapping('spawnLastVehicle', 'Spawnar último veículo', 'keyboard', 'G')
--RegisterCommand('spawnLastVehicle', function()
--    if IsPedInAnyVehicle(PlayerPedId()) then return end
--
--    if GetEntityHealth(PlayerPedId()) <= 101 then
--        TriggerEvent('Notify', 'vermelho', 'Você está morto e não pode spawnar veículos.', 4000)
--        return
--    end
--
--    if exports['dominas']:insideDomZone() then
--        TriggerEvent('Notify', 'vermelho', 'Você não pode spawnar um veículo enquanto estiver dentro de uma zona de dominação.', 4000)
--        return
--    end
--
--    if not lastVehicleModel then
--        TriggerEvent('Notify', 'vermelho', 'Não possuí nenhum veículo spawnado.', 4000)
--        return
--    end
--
--    if GetGameTimer() >= spawn_vehicle then
--        spawn_vehicle = GetGameTimer() + 1000
--        Remote.spawnVehicle(lastVehicleModel)
--    end
--end)

RegisterCommand('spawnLastVehicle', function()
    local ped = PlayerPedId()

    if IsPedInAnyVehicle(ped, false) then return end

    if GetEntityHealth(ped) <= 101 then
        TriggerEvent("Notify", "vermelho", "Você está morto e não pode spawnar veículos.", 4000)
        return
    end

    if exports['dominas']:insideDomZone() then
        TriggerEvent("Notify", "vermelho", "Você não pode spawnar um veículo dentro de uma zona de dominação.", 4000)
        return
    end

    TriggerServerEvent("car:spawnLastVehicle")
end)

-- Registrar mapeamento de tecla APÓS declarar o comando
RegisterKeyMapping('spawnLastVehicle', 'Spawnar último veículo', 'keyboard', 'G')

--AddEventHandler('gameEventTriggered', function(name, data)
--    if name ~= 'CEventNetworkPlayerEnteredVehicle' then return end
--    
--    local ped = PlayerPedId()
--    local vehicle = GetVehiclePedIsUsing(ped)
--    if GetPedInVehicleSeat(vehicle, -1) ~= ped then return end
--
--    Citizen.CreateThread(function()
--        while IsPedInAnyVehicle(ped, false) do Citizen.Wait(4) end
--        --TriggerEvent('car:playerLeaveVehicle')
--    end)
--end)

RegisterNetEvent("car:doSpawnVehicle")
AddEventHandler("car:doSpawnVehicle", function(vehicle)
    -- COPIAR EXATAMENTE A LÓGICA DO COMANDO /car DO FRAMEWORK
    local vehicleName = vehicle
    if not vehicleName then
        TriggerEvent('Notify', 'vermelho', 'Nome do veículo não fornecido!', 4000)
        return
    end
    
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local model = GetHashKey(vehicleName)
    
    RequestModel(model)
    local timeout = 0
    while not HasModelLoaded(model) and timeout < 100 do
        Wait(100)
        timeout = timeout + 1
    end
    
    if not HasModelLoaded(model) then
        TriggerEvent('Notify', 'vermelho', 'Modelo de veículo inválido ou não carregou!', 4000)
        return
    end
    
    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, true) -- networked, mission entity
    
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetPedIntoVehicle(ped, vehicle, -1)
    Wait(100) -- Pequeno delay para garantir que o jogador entrou
    
    -- Marcar como recentemente usado (como no framework)
    if recentPlayerVehicles then
        recentPlayerVehicles[vehicle] = GetGameTimer()
    end
    
    SetModelAsNoLongerNeeded(model)
    TriggerEvent('Notify', 'verde', 'Veículo spawnado: ' .. vehicleName, 3000)
end)

RegisterNetEvent('car:vehicleSpawned')
AddEventHandler('car:vehicleSpawned', function(vehicleModel)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    RequestModel(vehicleModel)
    while not HasModelLoaded(vehicleModel) do
        Citizen.Wait(0)
    end

    local vehicle = CreateVehicle(vehicleModel, coords.x + 3.0, coords.y, coords.z, GetEntityHeading(playerPed), true, false)
    SetPedIntoVehicle(playerPed, vehicle, -1)
    SetModelAsNoLongerNeeded(vehicleModel)
end)

-- Evento para receber atualização de nível
RegisterNetEvent("car:updateLevel")
AddEventHandler("car:updateLevel", function(level)
    print('[CAR][CLIENT] Nível atualizado para:', level)
    SendNUIMessage({ action = "updateLevel", level = level })
end)