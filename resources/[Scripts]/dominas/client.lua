
print("ZONES:", json and json.encode and json.encode(zones) or tostring(zones))
for i, z in ipairs(zones or {}) do
    print("Zona:", z.name, z.coords)
end

for i, z in ipairs(zones) do
    z.blip = nil
    z.areaBlip = nil
    z.cooldown = false
    z.cooldownTime = 0
end

local isDominating = false
local currentDomination = nil
local lastEnteredZone = nil

CreateThread(function()
    for i, zone in ipairs(zones) do
        zone.blip = AddBlipForCoord(zone.coords.x, zone.coords.y, zone.coords.z)
        SetBlipSprite(zone.blip, 310)
        SetBlipDisplay(zone.blip, 2)
        SetBlipScale(zone.blip, 0.6)
        SetBlipColour(zone.blip, 75)
        SetBlipAsShortRange(zone.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Zona de Dominação")
        EndTextCommandSetBlipName(zone.blip)
        zone.areaBlip = AddBlipForRadius(zone.coords.x, zone.coords.y, zone.coords.z, zone.radius)
        SetBlipColour(zone.areaBlip, 75)
        SetBlipAlpha(zone.areaBlip, 120)
    end
end)

RegisterNetEvent("domination:updateBlip")
AddEventHandler("domination:updateBlip", function(a, b, c, d)
    -- Detecta se foi enviado a tabela completa
    if type(a) == "table" and b == nil then
        -- Novo formato: a == zones
        for i, z in ipairs(a) do
            local zone = zones[i]
            if zone then
                zone.cooldown = z.cooldown
                zone.cooldownTime = z.cooldownTime
                local name = "Zona de Dominação"
                local blipSprite = 310
                local areaColor = 1

                if z.cooldown then
                    name = "Zona em Cooldown"
                    blipSprite = 42
                    areaColor = 0
                elseif z.activeGang and z.activeGang ~= "" then
                    name = "Dominando por: " .. z.activeGang
                    blipSprite = 419
                    -- Notificação de dominação
                    TriggerEvent("Notify", "verde", "Zona dominada por: " .. z.activeGang, 5000)
                    SendNUIMessage({
                        type = "notifyDomination",
                        text = "Zona dominada por: " .. z.activeGang
                    })
                end

                SetBlipSprite(zone.blip, blipSprite)
                SetBlipColour(zone.blip, areaColor)
                SetBlipScale(zone.blip, 0.6)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(name)
                EndTextCommandSetBlipName(zone.blip)
                SetBlipColour(zone.areaBlip, areaColor)
                SetBlipAlpha(zone.areaBlip, 120)
            end
        end
    else
        local zone = zones[a]
        if zone then
            zone.cooldown = b
            zone.cooldownTime = c
            local name = "Zona de Dominação"
            local blipSprite = 310
            local areaColor = 1

            if b then
                name = "Zona em Cooldown"
                blipSprite = 42
                areaColor = 0
            elseif d and d ~= "" then
                name = "Dominando por: " .. d
                blipSprite = 419
                -- Notificação de dominação
                TriggerEvent("Notify", "verde", "Zona dominada por: " .. d, 5000)
                SendNUIMessage({
                    type = "notifyDomination",
                    text = "Zona dominada por: " .. d
                })
            end

            SetBlipSprite(zone.blip, blipSprite)
            SetBlipColour(zone.blip, areaColor)
            SetBlipScale(zone.blip, 0.5)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(name)
            EndTextCommandSetBlipName(zone.blip)
            SetBlipColour(zone.areaBlip, areaColor)
            SetBlipAlpha(zone.areaBlip, 120)
        end
    end
end)

local zoneStates = {}

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local zoneFound = false

        for i, zone in ipairs(zones) do
            local dist = #(coords - zone.coords)
            if dist < zone.radius then
                zoneFound = true
                if not zone.cooldown then
                    if not zoneStates[i] then
                        zoneStates[i] = true
                        TriggerServerEvent("domination:start", i)
                    end
                elseif lastEnteredZone ~= i then
                    TriggerEvent("Notify", "vermelho", "A área está em cooldown!", 5000)
                    lastEnteredZone = i
                end
            elseif zoneStates[i] and dist >= zone.radius then
                zoneStates[i] = false
                TriggerServerEvent("domination:cancel", i, "saiu")
                TriggerEvent("domination:stopTimer")
            end
        end

        Wait(zoneFound and 1000 or 1500)
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        for i, zone in ipairs(zones) do
            local dist = #(coords - zone.coords)
            if dist < zone.radius then
                sleep = 0
                DrawMarker(
                        1,
                        zone.coords.x, zone.coords.y, zone.coords.z - 100.0,
                        0.0, 0.0, 0.0,
                        0.0, 0.0, 0.0,
                        zone.radius * 2.0, zone.radius * 2.0, 1000.0,
                        255, 50, 50, 50, -- vermelho claro com opacidade reduzida
                        false, false, 2, false, nil, nil, false
                )
            end
        end
        Wait(sleep)
    end
end)

--local notificationsEnabled = true
--
--RegisterCommand("domnotify", function()
--    notificationsEnabled = not notificationsEnabled
--    if notificationsEnabled then
--        TriggerEvent("Notify", "verde", "Notificações de dominação ativadas.", 5000)
--    else
--        TriggerEvent("Notify", "vermelho", "Notificações de dominação desativadas.", 5000)
--    end
--end)

--RegisterNetEvent("domination:notifyUI")
--AddEventHandler("domination:notifyUI", function(text)
--    if notificationsEnabled then
--        SendNUIMessage({
--            type = "showNotification",
--            text = text
--        })
--    end
--end)

--RegisterNetEvent("domination:notifyUI")
--AddEventHandler("domination:notifyUI", function(text)
--    if notificationsEnabled then
--        SendNUIMessage({
--            action = "addAlert",
--            data = {
--                message = text,
--                delay = 5000 -- tempo de exibição em milissegundos
--            }
--        })
--    end
--end)


--RegisterNetEvent("fire:showXPNotify")
--AddEventHandler("fire:showXPNotify", function(amount)
--    SendNUIMessage({
--        action = "addXp",
--        data = amount
--    })
--end)

-- Notificação de kill (exemplo)
RegisterNetEvent("fire:showKillNotify")
AddEventHandler("fire:showKillNotify", function(name)
    TriggerEvent("Notify", "verde", "Você eliminou " .. (name or "um jogador") .. "!", 5000)
    SendNUIMessage({
        type = "notifyKill",
        victim = name,
        icon = "gun"
    })
end)
--
--RegisterNetEvent("fire:showDeathNotify")
--AddEventHandler("fire:showDeathNotify", function(name)
--    SendNUIMessage({
--        type = "notifyKill",
--        victim = name,
--        icon = "skull"
--    })
--end)

--RegisterCommand("xpnotify", function()
--    TriggerEvent("fire:showXPNotify", "+150 XP por eliminar inimigos.")
--end)
--
--RegisterCommand("killnotify", function()
--    TriggerEvent("fire:showKillNotify", "Você eliminou [Inimigo123]")
--end)
--
--RegisterCommand("deathnotify", function()
--    TriggerEvent("fire:showDeathNotify", "Você foi eliminado por [Inimigo123]")
--end)


RegisterNetEvent("domination:startTimer")
AddEventHandler("domination:startTimer", function(time)
    SendNUIMessage({
        type = "startTimer",
        time = time
    })
end)

RegisterNetEvent("domination:stopTimer")
AddEventHandler("domination:stopTimer", function()
    SendNUIMessage({
        type = "stopTimer"
    })
end)

exports("insideDomZone",function()
    local inZone = false
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    for _, zone in pairs(zones) do
        local dist = #(coords - zone.coords)
        if dist < zone.radius and not zone.cooldown then
            inZone = true
            break
        end
    end

    return inZone
end)