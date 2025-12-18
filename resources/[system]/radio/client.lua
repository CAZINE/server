-----------------------------------------------------------------------------------------------------------------------------------------
-- PvP Framework (sem vRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Comunicação com o servidor será feita via eventos nativos
-----------------------------------------------------------------------------------------------------------------------------------------
local function parseInt(val)
    return tonumber(val) or 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
local radioVolume = 20
local actionDelay = 0
local activeFrequency = 0
local radioActive = false
local frequencyCallbackId = 0
local frequencyCallbacks = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLENUI
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("radio",function()
    TriggerEvent("radio:RadioNui")
end)

RegisterNetEvent("radio:RadioNui")
AddEventHandler("radio:RadioNui", function()
    SetNuiFocus(true, true)
    SetCursorLocation(0.9, 0.9)
    SendNUIMessage({ action = "showMenu", volume = radioVolume, radio = radioActive })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHANGEVOLUME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("changeVolume", function(data, cb)
    if parseInt(data["volume"]) ~= radioVolume then
        radioVolume = parseInt(data["volume"])
        exports["pma-voice"]:setRadioVolume(radioVolume)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HANDLEFREQUENCY
-----------------------------------------------------------------------------------------------------------------------------------------
local function handleFrequency(frequency)
    frequency = parseInt(frequency)

    if (frequency <= 0 or frequency > 1000) and (activeFrequency ~= frequency) then
        return
    end

    if actionDelay >= GetGameTimer() then
        TriggerEvent("Notify", "vermelho", "Aguarde alguns instantes.", 5000)
        return
    end

    -- Comunicação assíncrona com o servidor
    frequencyCallbackId = frequencyCallbackId + 1
    local cbId = frequencyCallbackId
    TriggerServerEvent("radio:startFrequency", frequency, cbId)
    frequencyCallbacks[cbId] = function(allowed)
        if not allowed then
            actionDelay = GetGameTimer() + 2000
            return
        end
        exports["pma-voice"]:addPlayerToRadio(frequency)
        exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
        TriggerEvent("hud:Radio", frequency)
        radioActive = true
        activeFrequency = frequency
        TriggerEvent("Notify", "verde", "Conectado <b>" .. frequency .. ".00</b> MHz.", 5000)
        SendNUIMessage({ action = "updateStatus", radio = radioActive })
    end
end

RegisterNetEvent("radio:frequencyResult")
AddEventHandler("radio:frequencyResult", function(allowed, cbId)
    if frequencyCallbacks[cbId] then
        frequencyCallbacks[cbId](allowed)
        frequencyCallbacks[cbId] = nil
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIOF
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("radiof", function(_, args, raw)
    if not args[1] then
        return
    end

    TriggerEvent("talking-screen:clearTalkingList")
    handleFrequency(args[1])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVEFREQUENCY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("activeFrequency", function(data, cb)
    handleFrequency(data["radio"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INATIVEFREQUENCY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("deactiveFrequency", function(data, cb)
    TriggerEvent("radio:RadioClean")
    TriggerEvent("Notify", "verde", "Desconectado", 5000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OUTSERVERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("radio:RadioClean")
AddEventHandler("radio:RadioClean", function()
    exports["pma-voice"]:removePlayerFromRadio()
    exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
    TriggerEvent("hud:Radio", "")
    TriggerEvent("talking-screen:clearTalkingList")
    radioActive = false
    activeFrequency = 0
    SendNUIMessage({ action = "updateStatus", radio = radioActive })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSERADIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("closeRadio", function(data, cb)
    SetNuiFocus(false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADRADIOEXIST
-----------------------------------------------------------------------------------------------------------------------------------------
local Timer = GetGameTimer()
CreateThread(function()
    while true do
        local route = LocalPlayer.state and LocalPlayer.state.route
        if GetGameTimer() >= Timer and activeFrequency and activeFrequency ~= 0 and type(route) == "number" and route < 900000 then
            Timer = GetGameTimer() + 60000
        end
        Wait(10000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIO ANIMATION INTEGRADA AO ESTADO DO PMA-VOICE
-----------------------------------------------------------------------------------------------------------------------------------------
local radioAnimDict = "random@arrests"
local radioAnimName = "generic_radio_enter"
local radioAnimPlaying = false

local function playRadioAnim()
    if radioAnimPlaying then return end
    RequestAnimDict(radioAnimDict)
    while not HasAnimDictLoaded(radioAnimDict) do
        Wait(10)
    end
    TaskPlayAnim(PlayerPedId(), radioAnimDict, radioAnimName, 8.0, 2.0, -1, 50, 2.0, 0, 0, 0)
    radioAnimPlaying = true
end

local function stopRadioAnim()
    if not radioAnimPlaying then return end
    StopAnimTask(PlayerPedId(), radioAnimDict, radioAnimName, -4.0)
    radioAnimPlaying = false
end

-- Sincroniza animação com o estado do rádio do pma-voice
RegisterNetEvent("pma-voice:radioActive")
AddEventHandler("pma-voice:radioActive", function(isTalking)
    local playerName = GetPlayerName(PlayerId())
    SendNUIMessage({ action = "radioTalking", talking = isTalking, player = playerName })
end)

RegisterNetEvent("pma-voice:setTalkingOnRadio")
AddEventHandler("pma-voice:setTalkingOnRadio", function(serverId, isTalking)
    if serverId ~= GetPlayerServerId(PlayerId()) then -- Não mostrar para si mesmo, só para outros
        local player = GetPlayerFromServerId(serverId)
        if player ~= -1 then
            local playerName = GetPlayerName(player)
            SendNUIMessage({ action = "radioTalking", talking = isTalking, player = playerName })
        end
    end
end)