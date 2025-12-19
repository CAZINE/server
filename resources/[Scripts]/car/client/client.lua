local onMenu = false
local lastVehicleModel = nil
local spawn_vehicle = GetGameTimer()

local cachedVehicles = nil
local recentPlayerVehicles = {} -- ✅ FIX

-- função segura para verificar dominação
local function insideDomZoneSafe()
    if exports['dominas'] and exports['dominas'].insideDomZone then
        return exports['dominas']:insideDomZone()
    end
    return false
end

function openSpawn(list)
    if list then
        onMenu = true
        SetNuiFocus(true, true)

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

    if IsPedInAnyVehicle(PlayerPedId()) then return end

    if insideDomZoneSafe() then
        TriggerEvent('Notify', 'vermelho', 'Você não pode spawnar um veículo nesta zona.', 4000)
        return
    end

    carMenuCooldown = true
    SetTimeout(15000, function()
        carMenuCooldown = false
    end)

    requestVehicleMenu()
end)

RegisterKeyMapping('openCarMenu', 'Abrir menu de veículos', 'keyboard', 'F2')

RegisterNUICallback('close', function(_, cb)
    closeSpawn()
    cb({})
end)

RegisterNUICallback('spawn', function(data, cb)
    local ped = PlayerPedId()
    local modelHash = GetHashKey(data.spawn)

    if IsPedInAnyVehicle(ped) then
        TriggerEvent('Notify', 'amarelo', 'Você já está em um veículo.', 3000)
        cb({})
        return
    end

    if GetEntityHealth(ped) <= 101 then
        TriggerEvent('Notify', 'vermelho', 'Você está morto.', 4000)
        cb({})
        return
    end

    if insideDomZoneSafe() then
        TriggerEvent('Notify', 'vermelho', 'Você não pode spawnar veículo aqui.', 4000)
        cb({})
        return
    end

    if not IsModelValid(modelHash) or not IsModelAVehicle(modelHash) then
        TriggerEvent('Notify', 'vermelho', 'Modelo inválido.', 4000)
        cb({})
        return
    end

    RequestModel(modelHash)
    local timeout = 0
    while not HasModelLoaded(modelHash) do
        Wait(100)
        timeout = timeout + 100
        if timeout > 10000 then
            TriggerEvent('Notify', 'vermelho', 'Timeout ao carregar veículo.', 4000)
            cb({})
            return
        end
    end

    TriggerServerEvent("car:spawnVehicle", data.spawn)
    lastVehicleModel = data.spawn
    SetModelAsNoLongerNeeded(modelHash)
    closeSpawn()
    cb({})
end)

RegisterCommand('spawnLastVehicle', function()
    local ped = PlayerPedId()

    if IsPedInAnyVehicle(ped) then return end
    if GetEntityHealth(ped) <= 101 then return end
    if insideDomZoneSafe() then return end

    TriggerServerEvent("car:spawnLastVehicle")
end)

RegisterKeyMapping('spawnLastVehicle', 'Spawnar último veículo', 'keyboard', 'G')

RegisterNetEvent("car:doSpawnVehicle")
AddEventHandler("car:doSpawnVehicle", function(vehicleName)
    if not vehicleName then return end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local model = GetHashKey(vehicleName)

    RequestModel(model)
    while not HasModelLoaded(model) do Wait(100) end

    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, true)
    SetPedIntoVehicle(ped, veh, -1)
    recentPlayerVehicles[veh] = GetGameTimer()

    SetModelAsNoLongerNeeded(model)
    TriggerEvent('Notify', 'verde', 'Veículo spawnado: ' .. vehicleName, 3000)
end)

RegisterNetEvent("car:updateLevel")
AddEventHandler("car:updateLevel", function(level)
    SendNUIMessage({ action = "updateLevel", level = level })
end)
