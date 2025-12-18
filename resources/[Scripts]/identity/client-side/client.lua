-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local showingIdentity = false
local showingTop = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- IDENTIDADE - F11
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("identity", "Mostrar Identidade", "keyboard", "F11")

RegisterCommand("identity", function()
    if not showingIdentity then
        TriggerServerEvent("identity:requestIdentity")
    else
        SendNUIMessage({ action = "hideIdentity" })
    end
    showingIdentity = not showingIdentity
end, false)

RegisterNetEvent("identity:receiveIdentity")
AddEventHandler("identity:receiveIdentity", function(data)
    SendNUIMessage({
        action = "showIdentity",
        data = data
    })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOP DOMINAÇÕES - K
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("+exitdominas", function()
    if not showingTop then
        SetNuiFocus(true, true)
        TriggerServerEvent("exit:pedirTopDominas")
    else
        SetNuiFocus(false, false)
        SendNUIMessage({ action = "hideTop" })
    end
    showingTop = not showingTop
end)

RegisterKeyMapping("+exitdominas", "Abrir/Fechar Top Dominações", "keyboard", "K")

RegisterNetEvent("exit:mostrarTopDominas")
AddEventHandler("exit:mostrarTopDominas", function(data)
    SendNUIMessage({
        action = "showTop",
        data = data
    })
end)

RegisterNUICallback("hideTop", function(_, cb)
    SetNuiFocus(false, false)
    cb({})
end)

RegisterNetEvent("fire:showKillNotify")
AddEventHandler("fire:showKillNotify", function(name)
    SendNUIMessage({
        type = "notifyKill",
        victim = name,
        icon = "gun"
    })
end)

RegisterNetEvent("fire:showDeathNotify")
AddEventHandler("fire:showDeathNotify", function(name)
    SendNUIMessage({
        type = "notifyKill",
        victim = name,
        icon = "skull"
    })
end)

local activeSpeakers = {}
local cachedInformations = {}

RegisterNetEvent('talking-screen:talkingScreen', function(src, talking)
    local id = nil
    local name = nil

    if cachedInformations[src] then
        id = cachedInformations[src].id
        name = cachedInformations[src].name
    else
        -- Como não temos mais Remote:getPlayerInfos, apenas use o id e nome padrão
        id = src
        name = "Player" .. tostring(src)
        cachedInformations[src] = {
            id = id,
            name = name
        }
    end

    if id and name then
        name = string.gsub(name, "%[%w+%]%s*", "")

        if talking then
            activeSpeakers[id] = { id = id, name = name }
        else
            activeSpeakers[id] = nil
        end

        local speakerList = {}
        for _, speaker in pairs(activeSpeakers) do
            table.insert(speakerList, speaker)
        end

        SendNUIMessage({
            action = "setSpeakersExit",
            data = speakerList
        })
    end
end)