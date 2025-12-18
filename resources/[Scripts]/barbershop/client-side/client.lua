-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVIDO VRP/TUNNEL/PROXY
-----------------------------------------------------------------------------------------------------------------------------------------
-- cRP = {}
-- Tunnel.bindInterface("barbershop", cRP)
-- vSERVER = Tunnel.getInterface("barbershop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local cam = -1
local myClothes = {}
local canStartTread = 0
local canUpdate = false
local custom
local currentCharacterMode = {
    father = 0, mother = 0, skincolor = 0, shapemix = 0.0, eyescolor = 0, eyebrowsheight = 0, eyebrowsmargin = 0,
    nose = 0, noseheight = 0, nosemargin = 0, nosebridge = 0, nosetip = 0, noseshift = 0, cheekboneheight = 0,
    cheekbonemargin = 0, cheekbone = 0, lips = 0, lipsmargin = 0, lipsheight = 0, chinlength = 0, chinposition = 0,
    chinwidth = 0, chinshape = 0, neckwidth = 0, hairmodel = 4, hairfirstcolor = 0, hairsecondarycolor = 0, eyebrows = 0,
    eyebrowscolor = 0, beard = -1, beardcolor = 0, chest = -1, chestcolor = 0, blush = -1, blushcolor = 0,
    lipstick = -1, lipstickcolor = 0, blemishes = -1, ageing = -1, complexion = -1, sundamage = -1,
    freckles = -1, makeup = -1
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION
-----------------------------------------------------------------------------------------------------------------------------------------
function f(n)
    n = tonumber(n) or 0
    return n + 0.00000
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETCHAR
-----------------------------------------------------------------------------------------------------------------------------------------
custom = currentCharacterMode
-- Substituir funções cRP.* por funções locais
local function setCharacter(data)
    if data then
        custom = data
        canStartTread = 1
        canUpdate = true
        _setCustomization()
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESKIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateSkin", function(data)
    if data["value"] then
        SetNuiFocus(false)
        displayBarbershop(false)
        StopAnimTask(PlayerPedId(), "move_f@multiplayer", "idle", 2.0)
        TriggerServerEvent('barbershop:updateSkin', data)
        SendNUIMessage({ openBarbershop = false })
    end

    -- CONVERTE STRINGS PARA NÚMERO
    for k, v in pairs(data) do
        data[k] = tonumber(v) or v
    end
    custom = data
    _setCustomization()

    -- SALVAR NO BANCO NOVO!
    SaveBarbershop(data)
end)

local function updateFacial(data)
    if data then
        custom = data
        canStartTread = 1
        _setCustomization()
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROTATELEFT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("rotate", function(data, cb)
    local ped = PlayerPedId()
    local heading = GetEntityHeading(ped)
    if data == "left" then
        SetEntityHeading(ped, heading + 30)
    elseif data == "right" then
        SetEntityHeading(ped, heading - 30)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISPLAYBARBERSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function displayBarbershop(enable)
    local ped = PlayerPedId()

    if enable then
        SetEntityHeading(PlayerPedId(), 332.21)
        SetFollowPedCamViewMode(0)
        SetNuiFocus(true, true)
        local customization = custom

        SetNuiFocus(true, true)
        SendNUIMessage({
            openBarbershop = true, father = customization.father, mother = customization.mother, eyescolor = customization.eyescolor, eyebrowsheight = customization.eyebrowsheight, eyebrowsmargin = customization.eyebrowsmargin, nose = customization.nose, noseheight = customization.noseheight, nosemargin = customization.nosemargin, nosebridge = customization.nosebridge, nosetip = customization.nosetip, noseshift = customization.noseshift, cheekboneheight = customization.cheekboneheight, cheekbonemargin = customization.cheekbonemargin, cheekbone = customization.cheekbone, lips = customization.lips, lipsmargin = customization.lipsmargin, lipsheight = customization.lipsheight, chinlength = customization.chinlength, chinposition = customization.chinposition, chinwidth = customization.chinwidth, chinshape = customization.chinshape, neckwidth = customization.neckwidth, hairmodel = customization.hairmodel, hairfirstcolor = customization.hairfirstcolor, hairsecondarycolor = customization.hairsecondarycolor, eyebrows = customization.eyebrows, eyebrowscolor = customization.eyebrowscolor, beard = customization.beard, beardcolor = customization.beardcolor, chest = customization.chest, chestcolor = customization.chestcolor, blush = customization.blush, blushcolor = customization.blushcolor, lipstick = customization.lipstick, lipstickcolor = customization.lipstickcolor, blemishes = customization.blemishes, ageing = customization.ageing, complexion = customization.complexion, sundamage = customization.sundamage, freckles = customization.freckles, makeup = customization.makeup, shapemix = customization.shapemix, skincolor = customization.skincolor,
        })

        TaskPlayAnim(PlayerPedId(), "move_f@multiplayer", "idle", 11.0, -1, -1, 3, 0, false, false, false)
        FreezeEntityPosition(ped, true)

        if IsDisabledControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 142) then
            SendNUIMessage({ type = "click" })
        end

        SetPlayerInvincible(ped, false)--mqcu

        if not DoesCamExist(cam) then
            cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
            SetCamCoord(cam, GetEntityCoords(ped))
            SetCamRot(cam, 0.0, 0.0, 0.0)
            SetCamActive(cam, true)
            RenderScriptCams(true, false, 0, true, true)
            SetCamCoord(cam, GetEntityCoords(ped))
        end

        local x, y, z = table.unpack(GetEntityCoords(ped))
        SetCamCoord(cam, x + 0.2, y + 0.5, z + 0.7)
        SetCamRot(cam, 0.0, 0.0, 150.0)
    else
        SetPlayerInvincible(ped, false)
        FreezeEntityPosition(ped, false)
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETCUSTOMIZATION
-----------------------------------------------------------------------------------------------------------------------------------------
-- Substituir chamadas cRP.* por funções locais
local function defaultCustom(status)
    myClothes = {}
    myClothes = { status[1], status[2], status[3], status[4], status[5], status[6], status[7], status[8], status[9], status[10], status[11], status[12], status[13], status[14], status[15], status[16], status[17], status[18], status[19], status[20] }

    local ped = PlayerPedId()
    SetPedComponentVariation(ped, 2, status[1], 0, 2)
    SetPedHairColor(ped, status[2], status[3])

    SetPedHeadOverlay(ped, 4, status[4], 0.99)
    SetPedHeadOverlayColor(ped, 4, 0, 0, 0)

    --	SetPedHeadOverlayColor(ped,4,0,status[6],status[6])

    SetPedHeadOverlay(ped, 8, status[7], 0.99)
    SetPedHeadOverlayColor(ped, 8, 2, status[9], status[9])

    SetPedHeadOverlay(ped, 2, status[10], 0.99)
    SetPedHeadOverlayColor(ped, 2, 1, status[12], status[12])

    SetPedHeadOverlay(ped, 1, status[13], 0.99)
    SetPedHeadOverlayColor(ped, 1, 1, status[15], status[15])

    SetPedHeadOverlay(ped, 5, status[16], 0.99)
    SetPedHeadOverlayColor(ped, 5, 2, status[18], status[18])

    -- Pelo Corporal
    SetPedHeadOverlay(ped, 10, status[19], 0.99)
    SetPedHeadOverlayColor(ped, 10, 1, status[20], status[20])
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTFOCUS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    SetNuiFocus(false)
    SendNUIMessage({ openBarbershop = false })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCATIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local locations = {
    { -813.37, -183.85, 37.57 },
    { 138.13, -1706.46, 29.3 },
    { -1280.92, -1117.07, 7.0 },
    { 1930.54, 3732.06, 32.85 },
    { 1214.2, -473.18, 66.21 },
    { -33.61, -154.52, 57.08 },
    { -276.65, 6226.76, 31.7 },
    { -1604.91, -1073.97, 13.02 } -- PIER
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHOVERFY
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    local innerTable = {}
    for k, v in pairs(locations) do
        table.insert(innerTable, { v[1], v[2], v[3], 2.5, "E", "Barbearia", "Pressione para abrir" })
    end
    TriggerEvent("hoverfy:insertTable", innerTable)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISPLAYBARBERSHOP EVENT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("barbershop:displayBarbershop", function()
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped) then
        local coords = GetEntityCoords(ped)
        for _, v in pairs(locations) do
            local distance = #(coords - vector3(v[1], v[2], v[3]))
            if distance <= 2.5 then
                displayBarbershop(true)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISPLAYBARBERSHOP EVENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("barbearia", function()
    TriggerServerEvent('barbershop:checkPermission')
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("syncarea")
AddEventHandler("syncarea", function(x, y, z, distance)
    ClearAreaOfVehicles(x, y, z, distance + 0.0, false, false, false, false, false)
    ClearAreaOfEverything(x, y, z, distance + 0.0, false, false, false, false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD SYNC PED
-----------------------------------------------------------------------------------------------------------------------------------------
function _setCustomization()
    Citizen.CreateThread(function()
        while not IsPedModel(PlayerPedId(), "mp_m_freemode_01") and not IsPedModel(PlayerPedId(), "mp_f_freemode_01") do
            Citizen.Wait(10)
        end
        if custom then
            TaskUpdateSkinOptions()
            TaskUpdateFaceOptions()
            TaskUpdateHeadOptions()
        end
        canStartTread = 0
    end)
end


function TaskUpdateSkinOptions()
    local data = custom
    SetPedHeadBlendData(PlayerPedId(), data.father, data.mother, 0, data.skincolor, 0, 0, f(data.shapemix), 0, 0, false)
end

function TaskUpdateFaceOptions()
    local ped = PlayerPedId()
    local data = custom

    -- Olhos
    SetPedEyeColor(ped, data.eyescolor)
    -- Sobrancelha
    SetPedFaceFeature(ped, 6, data.eyebrowsheight)
    SetPedFaceFeature(ped, 7, data.eyebrowsmargin)
    -- Nariz
    SetPedFaceFeature(ped, 0, data.nose)
    SetPedFaceFeature(ped, 1, data.noseheight)
    SetPedFaceFeature(ped, 2, data.nosemargin)
    SetPedFaceFeature(ped, 3, data.nosebridge)
    SetPedFaceFeature(ped, 4, data.nosetip)
    SetPedFaceFeature(ped, 5, data.noseshift)
    -- Bochechas
    SetPedFaceFeature(ped, 8, data.cheekboneheight)
    SetPedFaceFeature(ped, 9, data.cheekbonemargin)
    SetPedFaceFeature(ped, 10, data.cheekbone)
    -- Boca/Mandibula
    SetPedFaceFeature(ped, 12, data.lips)
    SetPedFaceFeature(ped, 13, data.lipsmargin)
    SetPedFaceFeature(ped, 14, data.lipsheight)
    -- Queixo
    SetPedFaceFeature(ped, 15, data.chinlength)
    SetPedFaceFeature(ped, 16, data.chinposition)
    SetPedFaceFeature(ped, 17, data.chinwidth)
    SetPedFaceFeature(ped, 18, data.chinshape)
    -- Pescoço
    SetPedFaceFeature(ped, 19, data.neckwidth)
end

function TaskUpdateHeadOptions()
    local ped = PlayerPedId()
    local data = custom
    -- Cabelo
    SetPedComponentVariation(ped, 2, data.hairmodel, 0, 0)
    SetPedHairColor(ped, data.hairfirstcolor, data.hairsecondarycolor)
    -- Sobracelha
    SetPedHeadOverlay(ped, 2, data.eyebrows, 0.99)
    SetPedHeadOverlayColor(ped, 2, 1, data.eyebrowscolor, data.eyebrowscolor)
    -- Barba
    SetPedHeadOverlay(ped, 1, data.beard, 0.99)
    SetPedHeadOverlayColor(ped, 1, 1, data.beardcolor, data.beardcolor)
    -- Pelo Corporal
    SetPedHeadOverlay(ped, 10, data.chest, 0.99)
    SetPedHeadOverlayColor(ped, 10, 1, data.chestcolor, data.chestcolor)
    -- Blush
    SetPedHeadOverlay(ped, 5, data.blush, 0.99)
    SetPedHeadOverlayColor(ped, 5, 2, data.blushcolor, data.blushcolor)
    -- Battom
    SetPedHeadOverlay(ped, 8, data.lipstick, 0.99)
    SetPedHeadOverlayColor(ped, 8, 2, data.lipstickcolor, data.lipstickcolor)
    -- Manchas
    SetPedHeadOverlay(ped, 0, data.blemishes, 0.99)
    SetPedHeadOverlayColor(ped, 0, 0, 0, 0)
    -- Envelhecimento
    SetPedHeadOverlay(ped, 3, data.ageing, 0.99)
    SetPedHeadOverlayColor(ped, 3, 0, 0, 0)
    -- Aspecto
    SetPedHeadOverlay(ped, 6, data.complexion, 0.99)
    SetPedHeadOverlayColor(ped, 6, 0, 0, 0)
    -- Pele
    SetPedHeadOverlay(ped, 7, data.sundamage, 0.99)
    SetPedHeadOverlayColor(ped, 7, 0, 0, 0)
    -- Sardas
    SetPedHeadOverlay(ped, 9, data.freckles, 0.99)
    SetPedHeadOverlayColor(ped, 9, 0, 0, 0)
    -- Maquiagem
    SetPedHeadOverlay(ped, 4, data.makeup, 0.99)
    SetPedHeadOverlayColor(ped, 4, 0, 0, 0)
end


local barbershopCoords = {
    vector4(1378.53,-576.54,74.26,102.05),
    vector4(1278.31,3022.38,43.54,5.67),
    vector4(-1644.47,-987.66,13.01,229.61),
    vector4(1442.67,6527.28,17.3,82.21),
}

CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, coords in ipairs(barbershopCoords) do
            local dist = #(playerCoords - coords.xyz)
            if dist < 30.0 then
                sleep = 0
                DrawFloatingLabel(coords.x, coords.y, coords.z + 1.35, "~g~[E] Babrbearia")

                if dist < 2.0 and IsControlJustPressed(0, 38) then
                    TriggerEvent("barbershop:opennpc")
                end
            end
        end

        Wait(sleep)
    end
end)

RegisterNetEvent("barbershop:opennpc")
AddEventHandler("barbershop:opennpc", function()
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped) then
        displayBarbershop(true)
    end
end)

function DrawFloatingLabel(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        local px, py, pz = table.unpack(GetGameplayCamCoords())
        local dist = #(vector3(px, py, pz) - vector3(x, y, z))
        local scale = (1 / dist) * 1.8 * (1 / GetGameplayCamFov()) * 100

        SetTextScale(0.0, 0.9 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextCentre(1)
        SetTextColour(255, 255, 255, 255)
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y + 0.05)
    end
end

-- Ao spawnar, requisitar dados do barbershop
AddEventHandler("playerSpawned", function()
    TriggerServerEvent("barbershop:requestData")
end)

-- Aplicar só cabelo/barba/etc recebidos do servidor
RegisterNetEvent("barbershop:applyData")
AddEventHandler("barbershop:applyData", function(data)
    if data then
        custom = data
        _setCustomization()
    end
end)

-- Função para salvar alterações do barbershop
function SaveBarbershop(data)
  
    TriggerServerEvent("barbershop:saveData", data)
end

--RegisterNetEvent("checkPlayerModel")
--AddEventHandler("checkPlayerModel", function(user_id)
--    local ped = PlayerPedId()
--    local model = GetEntityModel(ped)
--
--    local mp_m = GetHashKey("mp_m_freemode_01")
--    local mp_f = GetHashKey("mp_f_freemode_01")
--
--    if model ~= mp_m and model ~= mp_f then
--        local randomGender = math.random(1, 2)
--        local newModel = (randomGender == 1) and "mp_m_freemode_01" or "mp_f_freemode_01"
--
--        RequestModel(newModel)
--        while not HasModelLoaded(newModel) do
--            Wait(100)
--        end
--
--        SetPlayerModel(PlayerId(), GetHashKey(newModel))
--        SetModelAsNoLongerNeeded(GetHashKey(newModel))
--
--        -- Notificação local
--        TriggerEvent("Notify", "vermelho", "Seu personagem foi resetado por estar fora do padrão.", 5000)
--
--        -- Enviar log para o servidor se quiser
--        TriggerServerEvent("logResetModel", user_id, newModel)
--    end
--end)

-- Adicionar/ajustar evento para abrir a NUI corretamente
RegisterNetEvent('barbershop:checkPermissionResult')
AddEventHandler('barbershop:checkPermissionResult', function(allowed)
    if allowed then
        displayBarbershop(true)
    else
        -- Notificação opcional
        TriggerEvent('notify:show', { type = 'error', message = 'Você não tem permissão para usar a barbearia.' })
    end
end)

-- Spawnar NPC fixo em todas as coordenadas do barbershopCoords
CreateThread(function()
    local npcModel = GetHashKey("player_one")
    RequestModel(npcModel)
    while not HasModelLoaded(npcModel) do Wait(10) end
    for _, coords in ipairs(barbershopCoords) do
        local npc = CreatePed(4, npcModel, coords.x, coords.y, coords.z - 1.0, coords.w, false, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        FreezeEntityPosition(npc, true)
        -- Removida a animação, NPC ficará fixo parado
    end
end)


