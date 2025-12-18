local created = false
local lastAppearance = nil
local creatorCam = nil
local creatorHeading = 0.0
local creatorCamCoords = nil
local creatorCamTarget = nil

-- Comando para abrir criador manualmente
RegisterCommand('criar', function()
    TriggerEvent('character:openCreator')
end, false)

-- Comando para fechar criador
RegisterCommand('fechar', function()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'hide' })
    FreezeEntityPosition(PlayerPedId(), false)
    destroyCreatorCam()
    -- Mostrar HUD novamente usando o evento específico
    TriggerEvent("character:creatorClosed")
end, false)

-- Comando para testar visibilidade do HUD
RegisterCommand('testehud', function()
    print("[DEBUG] Testando visibilidade do HUD")
    TriggerEvent("character:creatorOpened")
    Wait(2000)
    TriggerEvent("character:creatorClosed")
end, false)

RegisterCommand('testtattoo', function()
    local ped = PlayerPedId()
    -- Garantir torso e undershirt sem camisa para visualização
    SetPedComponentVariation(ped, 11, 15, 0, 2)
    SetPedComponentVariation(ped, 8, 15, 0, 2)
    ClearPedDecorations(ped)
    print("[DEBUG] Aplicando tattoo de teste: mpbusiness_overlays FM_Bus_Big_001")
    AddPedDecorationFromHashes(ped, GetHashKey("mpbusiness_overlays"), GetHashKey("FM_Bus_Big_001"))
end, false)

-- Listas de tattoos (collection:name) para cada membro (exemplo, pode ser expandido com outras tattoos reais)
local tattoos_arm_r = {
    nil,
    "mpbiker_overlays:MP_MP_Biker_Tat_007_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_014_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_033_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_042_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_046_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_047_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_002_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_021_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_024_M",
    "mpheist3_overlays:mpHeist3_Tat_034_M",
    "mpheist3_overlays:mpHeist3_Tat_042_M",
    "mpheist3_overlays:mpHeist3_Tat_043_M",
    "mpheist3_overlays:mpHeist3_Tat_044_M",
    "mpimportexport_overlays:MP_MP_ImportExport_Tat_003_M",
    "mpimportexport_overlays:MP_MP_ImportExport_Tat_005_M",
    "mpimportexport_overlays:MP_MP_ImportExport_Tat_006_M",
    "mpimportexport_overlays:MP_MP_ImportExport_Tat_007_M",
    "mpimportexport_overlays:MP_MP_ImportExport_Tat_010_M",
    "mpchristmas2017_overlays:MP_Christmas2017_Tattoo_006_M"
}
local tattoos_arm_l = {
    nil,
    "mpbiker_overlays:MP_MP_Biker_Tat_012_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_016_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_020_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_024_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_025_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_035_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_045_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_004_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_008_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_015_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_016_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_025_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_027_M",
    "mpheist3_overlays:mpHeist3_Tat_040_M",
    "mpheist3_overlays:mpHeist3_Tat_041_M",
    "mpimportexport_overlays:MP_MP_ImportExport_Tat_004_M",
    "mpimportexport_overlays:MP_MP_ImportExport_Tat_008_M",
    "mpchristmas2017_overlays:MP_Christmas2017_Tattoo_001_M",
    "mpchristmas2017_overlays:MP_Christmas2017_Tattoo_004_M"
}
local tattoos_leg_r = {
    nil,
    "mpbiker_overlays:MP_MP_Biker_Tat_004_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_022_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_028_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_040_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_048_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_006_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_019_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_026_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_030_M",
    "mpheist3_overlays:mpHeist3_Tat_031_M",
    "mpheist3_overlays:mpHeist3_Tat_032_M",
    "mpimportexport_overlays:MP_MP_ImportExport_Tat_001_M",
    "mpimportexport_overlays:MP_MP_ImportExport_Tat_009_M",
    "mpchristmas2017_overlays:MP_Christmas2017_Tattoo_005_M",
    "mpchristmas2017_overlays:MP_Christmas2017_Tattoo_012_M",
    "mpchristmas2017_overlays:MP_Christmas2017_Tattoo_014_M",
    "mpchristmas2017_overlays:MP_Christmas2017_Tattoo_018_M",
    "mpchristmas2017_overlays:MP_Christmas2017_Tattoo_020_M",
    "mpchristmas2017_overlays:MP_Christmas2017_Tattoo_022_M"
}
local tattoos_leg_l = {
    nil,
    "mpbiker_overlays:MP_MP_Biker_Tat_015_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_027_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_036_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_037_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_044_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_005_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_007_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_011_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_023_M",
    "mpheist3_overlays:mpHeist3_Tat_031_M",
    "mpheist3_overlays:mpHeist3_Tat_032_M",
    "mpimportexport_overlays:MP_MP_ImportExport_Tat_002_M",
    "mpimportexport_overlays:MP_MP_ImportExport_Tat_008_M",
    "mpchristmas2017_overlays:MP_Christmas2017_Tattoo_003_M",
    "mpchristmas2017_overlays:MP_Christmas2017_Tattoo_007_M",
    "mpchristmas2017_overlays:MP_Christmas2017_Tattoo_009_M",
    "mpchristmas2017_overlays:MP_Christmas2017_Tattoo_011_M",
    "mpchristmas2017_overlays:MP_Christmas2017_Tattoo_013_M",
    "mpchristmas2017_overlays:MP_Christmas2017_Tattoo_015_M"
}
local tattoos_back = {
    nil,
    "mpbiker_overlays:MP_MP_Biker_Tat_001_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_009_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_017_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_018_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_030_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_034_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_009_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_012_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_013_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_017_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_018_M",
    "mpheist3_overlays:mpHeist3_Tat_023_M",
    "mpheist3_overlays:mpHeist3_Tat_024_M",
    "mpimportexport_overlays:MP_MP_ImportExport_Tat_000_M",
    "mpimportexport_overlays:MP_MP_ImportExport_Tat_009_M",
    "mpchristmas2017_overlays:MP_Christmas2017_Tattoo_002_M",
    "mpchristmas2017_overlays:MP_Christmas2017_Tattoo_008_M",
    "mpchristmas2017_overlays:MP_Christmas2017_Tattoo_016_M",
    "mpchristmas2017_overlays:MP_Christmas2017_Tattoo_021_M"
}
local tattoos_chest = {
    nil,
    "mpbiker_overlays:MP_MP_Biker_Tat_002_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_005_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_011_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_019_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_026_M",
    "mpbiker_overlays:MP_MP_Biker_Tat_031_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_000_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_010_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_012_M",
    "mpgunrunning_overlays:MP_Gunrunning_Tattoo_014_M",
    "mpheist3_overlays:mpHeist3_Tat_025_M",
    "mpheist3_overlays:mpHeist3_Tat_026_M",
    "mpimportexport_overlays:MP_MP_ImportExport_Tat_002_M",
    "mpimportexport_overlays:MP_MP_ImportExport_Tat_010_M",
    "mpchristmas2017_overlays:MP_Christmas2017_Tattoo_000_M",
    "mpchristmas2017_overlays:MP_Christmas2017_Tattoo_003_M",
    "mpchristmas2017_overlays:MP_Christmas2017_Tattoo_009_M",
    "mpchristmas2017_overlays:MP_Christmas2017_Tattoo_015_M",
    "mpchristmas2017_overlays:MP_Christmas2017_Tattoo_019_M"
}

local function applyTattoo(ped, tattooValue)
    if tattooValue and tattooValue ~= "none" then
        local split = {}
        for str in string.gmatch(tattooValue, "([^:]+)") do table.insert(split, str) end
        if #split == 2 then
            local collection, name = split[1], split[2]
            print("[DEBUG] Aplicando tattoo:", collection, name)
            AddPedDecorationFromHashes(ped, GetHashKey(collection), GetHashKey(name))
        end
    end
end

local function applyAppearance(data)
    local ped = PlayerPedId()
    local father = tonumber(data.father) or 0
    local mother = tonumber(data.mother) or 0
    local skinMix = tonumber(data.skin) or 0.5
    SetPedHeadBlendData(ped, father, mother, 0, father, mother, 0, skinMix, skinMix, 0.0, false)
    SetPedEyeColor(ped, tonumber(data.eyeColor) or 0)
    SetPedHairColor(ped, tonumber(data.hairColor) or 0, 0)
    SetPedComponentVariation(ped, 2, tonumber(data.hairStyle) or 0, 0, 2)
    -- Maquiagem
    SetPedHeadOverlay(ped, 4, tonumber(data.makeup) or 0, 1.0)
    
    -- Casaco (torso) customizável
    if (tonumber(data.jacket) or 0) == 0 or (tonumber(data.shirt) or 0) == 0 then
        -- Sem camisa: undershirt 15 (para homem, pode ajustar para mulher se necessário)
        SetPedComponentVariation(ped, 8, 15, 0, 2)
    else
        SetPedComponentVariation(ped, 8, tonumber(data.shirt) or 0, tonumber(data.shirtTexture) or 0, 2)
    end
    SetPedComponentVariation(ped, 11, tonumber(data.jacket) or 0, tonumber(data.jacketTexture) or 0, 2) -- Casaco (torso)
    SetPedComponentVariation(ped, 4, tonumber(data.box) or 0, tonumber(data.boxTexture) or 0, 2) -- Box/short
    SetPedComponentVariation(ped, 6, tonumber(data.shoes) or 0, tonumber(data.shoesTexture) or 0, 2) -- Sapato
    SetPedComponentVariation(ped, 7, tonumber(data.accessory) or 0, tonumber(data.accessoryTexture) or 0, 2) -- Acessório
    SetPedComponentVariation(ped, 4, tonumber(data.pants) or 0, tonumber(data.pantsTexture) or 0, 2) -- Calça (sobrescreve box se necessário)
    SetPedComponentVariation(ped, 1, tonumber(data.mask) or 0, tonumber(data.maskTexture) or 0, 2) -- Máscara
    SetPedComponentVariation(ped, 3, tonumber(data.hands) or 0, tonumber(data.handsTexture) or 0, 2) -- Mãos (luvas/acessórios)
    -- Chapéu (prop 0)
    ClearPedProp(ped, 0)
    if tonumber(data.hat) and tonumber(data.hat) > 0 then
        SetPedPropIndex(ped, 0, tonumber(data.hat) or 0, tonumber(data.hatTexture) or 0, true)
    end
    -- Óculos (prop 1)
    ClearPedProp(ped, 1)
    if tonumber(data.glasses) and tonumber(data.glasses) > 0 then
        SetPedPropIndex(ped, 1, tonumber(data.glasses) or 0, tonumber(data.glassesTexture) or 0, true)
    end
    -- Tatuagem grande (braço/perna)
    ClearPedDecorations(ped)
    -- Tatuagens
    local idx_r = tonumber(data.tattoo_arm_r) or 0
    local idx_l = tonumber(data.tattoo_arm_l) or 0
    local idx_lr = tonumber(data.tattoo_leg_r) or 0
    local idx_ll = tonumber(data.tattoo_leg_l) or 0
    local idx_back = tonumber(data.tattoo_back) or 0
    local idx_chest = tonumber(data.tattoo_chest) or 0
    if tattoos_arm_r[idx_r+1] then applyTattoo(ped, tattoos_arm_r[idx_r+1]) end
    if tattoos_arm_l[idx_l+1] then applyTattoo(ped, tattoos_arm_l[idx_l+1]) end
    if tattoos_leg_r[idx_lr+1] then applyTattoo(ped, tattoos_leg_r[idx_lr+1]) end
    if tattoos_leg_l[idx_ll+1] then applyTattoo(ped, tattoos_leg_l[idx_ll+1]) end
    if tattoos_back[idx_back+1] then applyTattoo(ped, tattoos_back[idx_back+1]) end
    if tattoos_chest[idx_chest+1] then applyTattoo(ped, tattoos_chest[idx_chest+1]) end
end

local function createCreatorCam()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    creatorHeading = heading
    -- Câmera mais longe e de frente
    local forward = GetEntityForwardVector(ped)
    creatorCamCoords = coords + (forward * 3.5) + vector3(0, 0, 0.7)
    creatorCamTarget = coords + vector3(0, 0, 0.7)
    creatorCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(creatorCam, creatorCamCoords.x, creatorCamCoords.y, creatorCamCoords.z)
    PointCamAtCoord(creatorCam, creatorCamTarget.x, creatorCamTarget.y, creatorCamTarget.z)
    SetCamActive(creatorCam, true)
    RenderScriptCams(true, false, 0, true, true)
end

local function updateCreatorCam()
    if creatorCam and creatorCamCoords and creatorCamTarget then
        SetCamCoord(creatorCam, creatorCamCoords.x, creatorCamCoords.y, creatorCamCoords.z)
        PointCamAtCoord(creatorCam, creatorCamTarget.x, creatorCamTarget.y, creatorCamTarget.z)
    end
end

local function destroyCreatorCam()
    if creatorCam then
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(creatorCam, false)
        creatorCam = nil
    end
end

local pedPitch = 0.0 -- ângulo de inclinação do ped

RegisterNetEvent('character:openCreator', function()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'show' })
    -- Interior de Bunker (sala principal)
    RequestIpl("gr_case0_bunker")
    RequestIpl("gr_case0_bunkerclosed")
    Wait(500) -- Aguarda IPL carregar

    -- Coloca o jogador em um mundo solo (routing bucket próprio)
    TriggerServerEvent('character:setBucketSolo')

    local x, y, z = 892.638, -3245.866, -98.95 -- Z ajustado para ficar no chão
    local heading = 90.0
    local model = GetHashKey('mp_m_freemode_01')
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end
    FreezeEntityPosition(PlayerPedId(), false)
    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)
    Wait(100)
    SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, true)
    SetEntityHeading(PlayerPedId(), heading)
    SetEntityVisible(PlayerPedId(), true, false)
    SetFocusEntity(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), true)
    -- Aplica aparência para preview ao abrir o criador
    if lastAppearance then
        applyAppearance(lastAppearance)
    else
        applyAppearance({
            father = 0, mother = 0, skin = 0.5,
            eyeColor = 0, hairColor = 0, hairStyle = 0,
            makeup = 0, jacket = 0, jacketTexture = 0,
            pants = 0, pantsTexture = 0, mask = 0, maskTexture = 0,
            hat = 0, hatTexture = 0, glasses = 0, glassesTexture = 0,
            tattoo_arm_r = 0, tattoo_arm_l = 0, tattoo_leg_r = 0, tattoo_leg_l = 0, tattoo_back = 0, tattoo_chest = 0
        })
    end
    createCreatorCam()
    TriggerEvent("character:creatorOpened")
end)

RegisterNUICallback('updateAppearance', function(data, cb)
    applyAppearance(data)
    lastAppearance = data
    cb('ok')
end)

RegisterNUICallback('rotate', function(data, cb)
    local ped = PlayerPedId()
    if data.dir == 'left' then
        creatorHeading = creatorHeading + 10.0
        SetEntityHeading(ped, creatorHeading)
        updateCreatorCam()
    elseif data.dir == 'right' then
        creatorHeading = creatorHeading - 10.0
        SetEntityHeading(ped, creatorHeading)
        updateCreatorCam()
    elseif data.dir == 'up' then
        pedPitch = math.max(pedPitch - 10.0, -30.0)
        SetPedPitch(ped, pedPitch)
        -- Não atualizar a câmera aqui
    elseif data.dir == 'down' then
        pedPitch = math.min(pedPitch + 10.0, 30.0)
        SetPedPitch(ped, pedPitch)
        -- Não atualizar a câmera aqui
    end
    cb('ok')
end)

-- Função para inclinar o ped (pitch)
function SetPedPitch(ped, pitch)
    local heading = GetEntityHeading(ped)
    local coords = GetEntityCoords(ped)
    SetEntityRotation(ped, pitch, 0.0, heading, 2, true)
    SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, true)
end

RegisterNUICallback('finishCreation', function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'hide' })
    FreezeEntityPosition(PlayerPedId(), false)
    TriggerServerEvent('character:save', data)
    created = true
    lastAppearance = data
    applyAppearance(data)
    destroyCreatorCam()
    -- Volta para o mundo principal
    TriggerServerEvent('character:setBucketMain')
    -- Teleporta para o aeroporto
    local x, y, z = -1037.6, -2738.0, 20.1693
    local heading = 328.0
    SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, true)
    SetEntityHeading(PlayerPedId(), heading)
    -- Mostrar HUD novamente usando o evento específico
    TriggerEvent("character:creatorClosed")
    cb('ok')
end)

AddEventHandler('playerSpawned', function()
    if not created then
        TriggerServerEvent('character:check')
    end
end)

RegisterNetEvent('character:alreadyCreated', function(appearance)
    created = true
    if appearance then
        local data = json.decode(appearance)
        if data then
            -- NÃO aplicar skin automaticamente aqui
            lastAppearance = data
        end
    end
    destroyCreatorCam()
end)

RegisterNetEvent('character:needCreate', function()
    created = false
    TriggerEvent('character:openCreator')
end) 

-- Remover aplicação automática de skin no respawn
--[[
RegisterNetEvent('pvp:respawn')
AddEventHandler('pvp:respawn', function()
    if lastAppearance then
        applyAppearance(lastAppearance)
    end
end) 

RegisterNetEvent('character:forceApplyAppearance')
AddEventHandler('character:forceApplyAppearance', function()
    if lastAppearance then
        applyAppearance(lastAppearance)
    end
end)
]]--

exports('applyAppearance', applyAppearance)
exports('getLastAppearance', function()
    return lastAppearance
end) 