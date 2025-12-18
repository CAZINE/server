-- PvP Framework - Client Main
print("[DEBUG] client/main.lua carregado!")
print("[DEBUG] client/main.lua iniciou")
local PlayerData = {}
local ScoreboardData = {}
local isHUDVisible = true
local isScoreboardVisible = false

-- (Removido: shutdown do loadscreen do início do script)

-- Adicione no topo para acessar lastAppearance do character
local lastAppearance = nil

-- Tente obter lastAppearance do resource character
CreateThread(function()
    while lastAppearance == nil do
        Wait(500)
        if exports['character'] and exports['character'].getLastAppearance then
            lastAppearance = exports['character']:getLastAppearance()
        end
    end
end)

math.randomseed(GetGameTimer())
local spawnPoints = {
    {x = 1370.7, y = -581.47, z = 24.17, heading =  450.0}, -- Aeroporto
    {x = 1278.88, y = 3040.94, z = 35.49, heading = 450.0}, -- Paleto Bay
    {x = -1652.66, y = -1017.42, z = 17.01, heading = 450.0}, -- Sandy Shores
    {x = 1419.0, y = 6534.0, z = 20.73, heading = 450.0} -- (Z+2)
}
function GetRandomSpawn()
    local idx = math.random(1, #spawnPoints)
    return spawnPoints[idx]
end

function SpawnPlayer()
    print("[DEBUG] Chamando SpawnPlayer()")
    local playerId = PlayerId()
    local model = GetHashKey("mp_m_freemode_01")
    Utils.Log("[SPAWN] Requesting model: " .. tostring(model))
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end
    Utils.Log("[SPAWN] Model loaded!")
    SetPlayerModel(playerId, model)
    SetModelAsNoLongerNeeded(model)
    local ped = PlayerPedId()
    local spawn = GetRandomSpawn()
    SetEntityCoordsNoOffset(ped, spawn.x, spawn.y, spawn.z, false, false, false)
    SetEntityHeading(ped, spawn.heading)
    Utils.Log("[SPAWN] Ped criado e teleportado!")
    while not NetworkIsPlayerActive(playerId) or not DoesEntityExist(ped) do
        Wait(100)
    end
    Utils.Log("[SPAWN] Ped existe e player ativo!")
    SetEntityVisible(ped, true, false)
    FreezeEntityPosition(ped, false)
    SetPlayerControl(playerId, true, 0)
    SetEntityInvincible(ped, false) -- garantir invencibilidade desativada
    ResurrectPed(ped)
    ClearPedTasksImmediately(ped)
    SetEntityHealth(ped, 200)
    SetPedArmour(ped, 0)
    ClearPedBloodDamage(ped)
    TriggerEvent('pvp:playerSpawned')
    TriggerEvent('playerSpawned')
    -- Disparar evento para o HUD customizado
    TriggerEvent('pvp:playerSpawned')
    TriggerEvent('mapStart')
    -- Só aplicar skin/roupa padrão se não houver lastAppearance
    if not lastAppearance then
        if model == GetHashKey("mp_m_freemode_01") then
            -- Pele morena (head blend)
            SetPedHeadBlendData(ped, 21, 21, 0, 21, 21, 0, 1.0, 1.0, 0.0, false)
            -- Olhos vermelhos
            SetPedEyeColor(ped, 6) -- 6 = vermelho
            -- Cabelo preto
            SetPedHairColor(ped, 1, 0) -- 1 = preto
            SetPedComponentVariation(ped, 2, 2, 0, 2) -- tipo de cabelo
            
            -- Verificar se há roupas mod disponíveis antes de aplicar roupas padrão
            local hasModClothes = false
            local torsoDrawables = GetNumberOfPedDrawableVariations(ped, 11)
            local undershirtDrawables = GetNumberOfPedDrawableVariations(ped, 8)
            
            if torsoDrawables > 15 or undershirtDrawables > 15 then
                hasModClothes = true
                print("[DEBUG] Roupas mod detectadas! Torso:", torsoDrawables, "Undershirt:", undershirtDrawables)
            end
            
            -- Só aplicar roupas padrão se não houver roupas mod
            if not hasModClothes then
                -- SEM CAMISA (torso e undershirt)
                SetPedComponentVariation(ped, 11, 15, 0, 2) -- torso sem camisa
                SetPedComponentVariation(ped, 8, 15, 0, 2)  -- undershirt sem nada
                SetPedComponentVariation(ped, 3, 15, 0, 2)  -- mãos 15
                SetPedComponentVariation(ped, 4, 14, 1, 2)  -- bermuda
                SetPedComponentVariation(ped, 6, 5, 0, 2)   -- chinelo
                -- Enviar customização para o servidor
                local clothesData = {
                    hands = {component = 3, drawable = 15, texture = 0, palette = 2},
                    torso = {component = 11, drawable = 15, texture = 0, palette = 2},
                    undershirt = {component = 8, drawable = 15, texture = 0, palette = 2},
                    pants = {component = 4, drawable = 14, texture = 1, palette = 2},
                    shoes = {component = 6, drawable = 5, texture = 0, palette = 2}
                }
                TriggerServerEvent('pvp:syncClothes', clothesData)
            else
                print("[DEBUG] Roupas mod detectadas, não aplicando roupas padrão")
            end
        end
    else
        -- -- Se houver lastAppearance, aplique a skin/roupa salva
        -- exports['character']:applyAppearance(lastAppearance)
    end
    print("[DEBUG] Disparando evento pvp:playerSpawned")
    -- NÃO disparar evento para reaplicar skin/roupa do character
    -- TriggerEvent('character:forceApplyAppearance')
end

-- Spawn automático ao entrar
CreateThread(function()
    print("[DEBUG] Thread de spawn automático iniciada")
    local spawned = false
    while not spawned do
        Wait(500)
        if NetworkIsSessionStarted() and not spawned then
            if not DoesEntityExist(PlayerPedId()) or GetEntityModel(PlayerPedId()) ~= GetHashKey("mp_m_freemode_01") then
                print("[DEBUG] Condição para SpawnPlayer() atendida")
                SpawnPlayer()
                spawned = true
            end
        end
    end
end)

-- Cria blips para cada ponto de spawn
for _, spawn in ipairs(spawnPoints) do
    -- Blip branco (círculo)
    local blipWhite = AddBlipForCoord(spawn.x, spawn.y, spawn.z)
    SetBlipSprite(blipWhite, 1) -- 9 = círculo
    SetBlipScale(blipWhite, 2.6) -- pequeno
    SetBlipColour(blipWhite, 0) -- 0 = branco
    SetBlipAlpha(blipWhite, 120) -- opacidade média
    SetBlipAsShortRange(blipWhite, true)

end



-- Evento para notificações do sistema de permissões
RegisterNetEvent('pvp:notification')
AddEventHandler('pvp:notification', function(message, type)
    if type == "success" then
        Utils.SendNotification(nil, message, "success")
    elseif type == "error" then
        Utils.SendNotification(nil, message, "error")
    elseif type == "info" then
        Utils.SendNotification(nil, message, "info")
    else
        Utils.SendNotification(nil, message, "info")
    end
end)

-- Evento para toggle noclip
RegisterNetEvent('pvp:toggleNoclip')
AddEventHandler('pvp:toggleNoclip', function()
    ToggleNoclip()
end)

-- Evento para mudar cor da arma
RegisterNetEvent('pvp:setWeaponColor')
AddEventHandler('pvp:setWeaponColor', function(weapon, color)
    local ped = PlayerPedId()
    local weaponHash = GetHashKey(weapon)
    
    if HasPedGotWeapon(ped, weaponHash, false) then
        -- Aplicar cor da arma
        SetPedWeaponTintIndex(ped, weaponHash, color)
        Utils.SendNotification(nil, "Cor da arma " .. weapon .. " alterada para " .. color, "success")
    else
        Utils.SendNotification(nil, "Você não tem a arma " .. weapon, "error")
    end
end)

-- Evento para mudar cor de todas as armas
RegisterNetEvent('pvp:setAllWeaponColors')
AddEventHandler('pvp:setAllWeaponColors', function(color)
    print("[DEBUG] Evento pvp:setAllWeaponColors recebido! Cor:", color)
    local ped = PlayerPedId()
    local weaponsChanged = 0
    print("[DEBUG] Ped ID:", ped)
    
    -- Lista de armas padrão do framework
    local defaultWeapons = {
        "WEAPON_PISTOL",
        "WEAPON_COMBATPISTOL", 
        "WEAPON_APPISTOL",
        "WEAPON_PISTOL50",
        "WEAPON_SNSPISTOL",
        "WEAPON_HEAVYPISTOL",
        "WEAPON_VINTAGEPISTOL",
        "WEAPON_MARKSMANPISTOL",
        "WEAPON_MACHINEPISTOL",
        "WEAPON_VPISTOL",
        "WEAPON_PISTOL_MK2",
        "WEAPON_SNSPISTOL_MK2",
        "WEAPON_REVOLVER",
        "WEAPON_REVOLVER_MK2",
        "WEAPON_DOUBLEACTION",
        "WEAPON_CERAMICPISTOL",
        "WEAPON_NAVYREVOLVER",
        "WEAPON_GADGETPISTOL",
        "WEAPON_STUNGUN",
        "WEAPON_FLAREGUN",
        "WEAPON_RAYPISTOL",
        "WEAPON_KNIFE",
        "WEAPON_NIGHTSTICK",
        "WEAPON_HAMMER",
        "WEAPON_BAT",
        "WEAPON_CROWBAR",
        "WEAPON_GOLFCLUB",
        "WEAPON_BOTTLE",
        "WEAPON_DAGGER",
        "WEAPON_HATCHET",
        "WEAPON_KNUCKLE",
        "WEAPON_MACHETE",
        "WEAPON_SWITCHBLADE",
        "WEAPON_WRENCH",
        "WEAPON_BATTLEAXE",
        "WEAPON_POOLCUE",
        "WEAPON_STONE_HATCHET"
    }
    
    print("[DEBUG] Verificando armas no evento...")
    for _, weapon in ipairs(defaultWeapons) do
        local weaponHash = GetHashKey(weapon)
        local hasWeapon = HasPedGotWeapon(ped, weaponHash, false)
        print("[DEBUG] Arma:", weapon, "Hash:", weaponHash, "Possui:", hasWeapon)
        
        if hasWeapon then
            print("[DEBUG] Aplicando cor", color, "na arma", weapon)
            SetPedWeaponTintIndex(ped, weaponHash, color)
            weaponsChanged = weaponsChanged + 1
            print("[DEBUG] Cor aplicada com sucesso!")
        end
    end
    
    print("[DEBUG] Total de armas alteradas no evento:", weaponsChanged)
    
    if weaponsChanged > 0 then
        Utils.SendNotification(nil, "Cor de " .. weaponsChanged .. " armas alterada para " .. color, "success")
    else
        Utils.SendNotification(nil, "Você não tem armas para alterar a cor", "error")
    end
end)

-- Tabela para callbacks de permissão por requestId
local permissionCallbacks = {}
local permissionRequestCounter = 0

function CheckPermission(permission, callback)
    permissionRequestCounter = permissionRequestCounter + 1
    local requestId = permissionRequestCounter
    permissionCallbacks[requestId] = callback
    TriggerServerEvent('pvp:checkPermission', permission, requestId)
end

RegisterNetEvent('pvp:permissionResult')
AddEventHandler('pvp:permissionResult', function(hasPermission, requestId)
    print('[DEBUG][CLIENT] Evento pvp:permissionResult recebido! hasPermission:', hasPermission, 'requestId:', requestId)
    if requestId and permissionCallbacks[requestId] then
        permissionCallbacks[requestId](hasPermission)
        permissionCallbacks[requestId] = nil
    end
end)

-- Inicialização do cliente
CreateThread(function()
    Wait(1000) -- Aguardar carregamento
    
    -- Configurações iniciais
    SetCanAttackFriendly(PlayerPedId(), true, false)
    NetworkSetFriendlyFireOption(true)
    SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
    
    -- Desabilitar algumas funcionalidades do GTA
    Citizen.CreateThread(function()
        while true do
            Wait(0)
            -- Desabilitar wanted level
            SetPlayerWantedLevel(PlayerId(), 0, false)
            SetPlayerWantedLevelNow(PlayerId(), false)
            
            -- Desabilitar polícia
            SetPoliceIgnorePlayer(PlayerId(), true)
            SetDispatchCopsForPlayer(PlayerId(), false)
            
            -- Desabilitar roda de armas padrão do GTA V (TAB)
            -- Comentado temporariamente para permitir troca de armas com 1,2,3,4
            -- DisableControlAction(0, 37, true) -- TAB - Weapon Wheel
            

            
            -- Manter jogador vivo (REMOVIDO: revive automático)
            -- if IsEntityDead(PlayerPedId()) then
            --     SetEntityHealth(PlayerPedId(), 200)
            -- end
        end
    end)
    
    Utils.Log("PvP Framework Client iniciado!")
end)

-- Evento customizado quando jogador spawna
AddEventHandler('pvp:playerSpawned', function(spawn)
    print("[DEBUG] Handler do evento pvp:playerSpawned executado")
    local player = PlayerPedId()
    Utils.Log("[SPAWN] Evento pvp:playerSpawned chamado!")
    -- Configurações do jogador
    SetEntityHealth(player, 200)
    SetPedArmour(player, 0)
    SetPlayerInvincible(PlayerId(), false)
    -- Remover wanted level
    SetPlayerWantedLevel(PlayerId(), 0, false)
    -- Solicitar dados do jogador
    TriggerServerEvent('pvp:getPlayerData')
    Utils.Log("Jogador spawnou!")
    -- Fechar o loadscreen somente agora
    print("[DEBUG] Fechando loading padrão do GTA/FiveM")
    if ShutdownLoadingScreen then ShutdownLoadingScreen() end
    print("[DEBUG] ShutdownLoadingScreen chamado")
    if ShutdownLoadingScreenNui then ShutdownLoadingScreenNui() end
    print("[DEBUG] ShutdownLoadingScreenNui chamado")
    -- Fechar loadscreen customizado
    TriggerEvent('pvp:closeLoadscreen')
    -- Garante que o loadscreen será fechado mesmo se houver delay de NUI
    SetTimeout(2000, function()
        TriggerEvent('pvp:closeLoadscreen')
    end)
end)

-- Evento para receber dados do jogador
RegisterNetEvent('pvp:receivePlayerData')
AddEventHandler('pvp:receivePlayerData', function(data)
    PlayerData = data
    Utils.Log("Dados do jogador recebidos!")
end)

-- Evento para dar armas
RegisterNetEvent('pvp:giveWeapons')
AddEventHandler('pvp:giveWeapons', function(weapons)
    local player = PlayerPedId()
    
    -- Remover todas as armas
    RemoveAllPedWeapons(player, true)
    
    -- Dar armas
    for _, weapon in ipairs(weapons) do
        GiveWeaponToPed(player, GetHashKey(weapon), Config.WeaponAmmo[weapon] or 100, false, true)
    end
    
    Utils.Log("Armas recebidas!")
end)

-- Evento para respawn
RegisterNetEvent('pvp:respawn')
AddEventHandler('pvp:respawn', function()
    lastDeathTime = 0
    local player = PlayerPedId()
    
    -- Respawn
    NetworkResurrectLocalPlayer(GetEntityCoords(player), GetEntityHeading(player), true, false)
    SetEntityHealth(player, 200)
    ClearPedBloodDamage(player)
    -- Remover todas as armas
    RemoveAllPedWeapons(player, true)
    
    Utils.Log("Respawn realizado!")
end)

-- Evento para notificações
RegisterNetEvent('pvp:notification')
AddEventHandler('pvp:notification', function(message, type)
    Utils.SendNotification(nil, message, type)
end)

-- Evento para atualizar scoreboard
RegisterNetEvent('pvp:updateScoreboard')
AddEventHandler('pvp:updateScoreboard', function(data)
    ScoreboardData = data
    if isScoreboardVisible then
        UpdateScoreboardUI()
    end
end)

-- Evento para mostrar scoreboard
RegisterNetEvent('pvp:showScoreboard')
AddEventHandler('pvp:showScoreboard', function()
    isScoreboardVisible = true
    UpdateScoreboardUI()
end)

-- Evento para receber estatísticas pessoais
RegisterNetEvent('pvp:receivePersonalStats')
AddEventHandler('pvp:receivePersonalStats', function(stats)
    PlayerData.stats = stats
end)

-- Controles do teclado
CreateThread(function()
    while true do
        Wait(0)
        
        -- Toggle HUD (F1)
        if IsControlJustPressed(0, 288) then -- F1
            isHUDVisible = not isHUDVisible
            Utils.SendNotification(nil, "HUD " .. (isHUDVisible and "ativado" or "desativado"), "info")
        end
        
        -- Removido: Toggle Scoreboard (TAB)
        -- if IsControlPressed(0, 37) then -- TAB
        --     if not isScoreboardVisible then
        --         isScoreboardVisible = true
        --         UpdateScoreboardUI()
        --     end
        -- else
        --     if isScoreboardVisible then
        --         isScoreboardVisible = false
        --         HideScoreboardUI()
        --     end
        -- end
        
        -- Comandos rápidos
        if IsControlJustPressed(0, 289) then -- F2
            TriggerServerEvent('pvp:heal')
        end
        
        -- Removido: F3 para dar armas
        -- if IsControlJustPressed(0, 170) then -- F3
        --     TriggerServerEvent('pvp:giveWeapons')
        -- end
        
        if IsControlJustPressed(0, 167) then -- F6
            TriggerServerEvent('pvp:respawn')
        end
    end
end)

local lastDeathTime = 0

-- Detecção de kills
CreateThread(function()
    while true do
        Wait(100)
        local player = PlayerPedId()
        if IsEntityDead(player) then
            SavePlayerWeapons() -- Salva armas ao morrer
            -- RemoveAllPedWeapons(player, true) -- NÃO remover armas ao morrer
            local now = GetGameTimer()
            if now - lastDeathTime > 2000 then -- só executa se já passou 2s da última morte
                lastDeathTime = now
                local killer = GetPedSourceOfDeath(player)
                local weapon = GetPedCauseOfDeath(player)
                local bone = GetPedLastDamageBone(player)
                if killer and killer ~= player then
                    local isHeadshot = Utils.IsHeadshot(bone)
                    local killerId = NetworkGetPlayerIndexFromPed(killer)
                    if killerId then
                        local killerServerId = GetPlayerServerId(killerId)
                        local killerName = GetPlayerName(killerId)
                        local victimName = GetPlayerName(PlayerId())
                        -- Killfeed NUI para todos
                        -- TriggerServerEvent('mark:broadcastKillfeed', killerName, victimName) -- REMOVIDO para evitar duplicidade
                        print("[DEBUG] Disparando TriggerServerEvent pvp:playerKilled", killerServerId, weapon, isHeadshot)
                        -- TriggerServerEvent('pvp:playerKilled', killerServerId, weapon, isHeadshot) -- REMOVIDO para evitar duplicidade
                        -- Disparar evento com informações de headshot para som
                        print("[DEBUG] Disparando evento pvp:playerKilledWithInfo com isHeadshot:", isHeadshot)
                        TriggerEvent('pvp:playerKilledWithInfo', isHeadshot)
                        -- Sons removidos
                        if isHeadshot then
                            print("[DEBUG] Headshot registrado!")
                        else
                            print("[DEBUG] Kill registrada!")
                        end
                    end
                end
                -- Adicionado: Disparar evento de morte para o servidor
                TriggerServerEvent('pvp:playerDied', killer, weapon)
            end
            -- Aguardar respawn
            Wait(Config.RespawnTime)
        end
    end
end)

-- Respawn automático ao morrer (só após morte real, sem forçar health)
CreateThread(function()
    while true do
        Wait(500)
        local ped = PlayerPedId()
        if IsEntityDead(ped) and GetEntityHealth(ped) == 0 then
            -- Disparar evento de morte para o HUD customizado
            TriggerEvent('pvp:playerDied')
            local deathTime = GetGameTimer()
            Utils.SendNotification(nil, "Aguarde 10 segundos ou pressione E para respawnar", "info")
            local respawned = false
            while not respawned do
                Wait(0)
                ped = PlayerPedId()
                local now = GetGameTimer()
                local canRespawn = (now - deathTime > 10000)
                if canRespawn and (IsControlJustPressed(0, 38) or now - deathTime > 20000) then
                    local spawn = GetRandomSpawn()
                    NetworkResurrectLocalPlayer(spawn.x, spawn.y, spawn.z, spawn.heading, true, false)
                    -- RemoveAllPedWeapons(PlayerPedId(), true) -- NÃO remover armas ao respawnar
                    Wait(100)
                    ClearPedTasksImmediately(ped)
                    ClearPedBloodDamage(ped)
                    SetEntityHealth(ped, 200)
                    SetPedArmour(ped, 0)
                    -- NÃO restaurar armas após respawn
                    -- RestorePlayerWeapons()
                    -- Adicionado: avisar o servidor para restaurar armas salvas
                    TriggerServerEvent('pvp:playerRespawned')
                    SpawnPlayer()
                    respawned = true;
                end
            end
        end
    end
end)

-- Controle de veículos usados recentemente
local recentPlayerVehicles = {}
local VEHICLE_GRACE_PERIOD = 120 -- segundos

-- Marcar veículo quando jogador entra
CreateThread(function()
    while true do
        Wait(500)
        local player = PlayerPedId()
        if IsPedInAnyVehicle(player, false) then
            local veh = GetVehiclePedIsIn(player, false)
            if veh and veh ~= 0 then
                recentPlayerVehicles[veh] = GetGameTimer()
            end
        end
    end
end)

-- Limpar veículos antigos do controle
CreateThread(function()
    while true do
        Wait(10000)
        local now = GetGameTimer()
        for veh, lastUsed in pairs(recentPlayerVehicles) do
            if not DoesEntityExist(veh) or (now - lastUsed) > (VEHICLE_GRACE_PERIOD * 1000) then
                recentPlayerVehicles[veh] = nil
            end
        end
    end
end)

-- Remover todos os NPCs e veículos do mapa
CreateThread(function()
    while true do
        Wait(0)
        -- Remove todos os peds não jogadores
        for ped in EnumeratePeds() do
            if not IsPedAPlayer(ped) then
                RemovePedElegantly(ped)
            end
        end
        -- Remove todos os veículos não ocupados por jogadores e não usados recentemente
        local now = GetGameTimer()
        for veh in EnumerateVehicles() do
            if veh ~= nil and veh ~= 0 and veh ~= -1 and DoesEntityExist(veh) then
                -- Checar se há algum jogador em qualquer assento
                local hasAnyPlayer = false
                for i = -1, GetVehicleMaxNumberOfPassengers(veh) - 1 do
                    local ped = GetPedInVehicleSeat(veh, i)
                    if ped and IsPedAPlayer(ped) then
                        hasAnyPlayer = true
                        break
                    end
                end
                local recentlyUsed = recentPlayerVehicles[veh] and (now - recentPlayerVehicles[veh] < VEHICLE_GRACE_PERIOD * 1000)
                if not hasAnyPlayer and not recentlyUsed then
                  
                    SetEntityAsMissionEntity(veh, true, true)
                    DeleteVehicle(veh)
                end
            end
        end
        -- Bloquear spawn de NPCs e veículos
        SetPedDensityMultiplierThisFrame(0.0)
        SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
        SetVehicleDensityMultiplierThisFrame(0.0)
        SetRandomVehicleDensityMultiplierThisFrame(0.0)
        SetParkedVehicleDensityMultiplierThisFrame(0.0)
        SetScenarioTypeEnabled("WORLD_VEHICLE_PARK_PERPENDICULAR_NOSE_IN", false)
        SetScenarioTypeEnabled("WORLD_VEHICLE_PARK_PARALLEL", false)
        SetScenarioTypeEnabled("WORLD_VEHICLE_DRIVE_SOLO", false)
        SetScenarioTypeEnabled("WORLD_VEHICLE_DRIVE_PASSENGERS", false)
        SetScenarioTypeEnabled("WORLD_VEHICLE_DRIVE_LOW", false)
        SetScenarioTypeEnabled("WORLD_VEHICLE_DRIVE_EMPTY", false)
        SetGarbageTrucks(false)
        SetRandomBoats(false)
        SetCreateRandomCops(false)
        SetCreateRandomCopsNotOnScenarios(false)
        SetCreateRandomCopsOnScenarios(false)
    end
end)

-- Funções utilitárias para enumerar entidades
function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
    end
}

-- Função para atualizar UI do scoreboard
function UpdateScoreboardUI()
    SendNUIMessage({
        type = 'updateScoreboard',
        data = ScoreboardData
    })
end

-- Função para esconder UI do scoreboard
function HideScoreboardUI()
    SendNUIMessage({
        type = 'hideScoreboard'
    })
end

-- Função para atualizar HUD
function UpdateHUD()
    if not isHUDVisible then return end
    
    SendNUIMessage({
        type = 'updateHUD',
        data = {
            player = PlayerData,
            scoreboard = ScoreboardData
        }
    })
end

-- Timer para atualizar HUD
CreateThread(function()
    while true do
        Wait(1000) -- Atualizar a cada segundo
        UpdateHUD()
    end
end)

-- Ocultar minimapa e HUD padrão do GTA V
CreateThread(function()
    while true do
        Wait(0)
        DisplayRadar(false)
        -- DisplayHud(false) -- HUD padrão do GTA V não será mais escondida
    end
end)

-- Comandos do cliente
RegisterCommand('hud', function(source, args, rawCommand)
    -- Verificar permissão admin
    CheckPermission('admin.all', function(hasPermission)
        if hasPermission then
            isHUDVisible = not isHUDVisible
            Utils.SendNotification(nil, "HUD " .. (isHUDVisible and "ativado" or "desativado"), "info")
        else
            Utils.SendNotification(nil, "Você não tem permissão para usar este comando!", "error")
        end
    end)
end, false)

RegisterCommand('stats', function(source, args, rawCommand)
    TriggerServerEvent('pvp:getPersonalStats')
end, false)

RegisterCommand("giveweapon", function(source, args)
    -- Verificar permissão admin
    CheckPermission('admin.all', function(hasPermission)
        if hasPermission then
            local weapon = args[1] or "WEAPON_PISTOL"
            local ammo = tonumber(args[2]) or 100
            GiveWeaponToPed(PlayerPedId(), GetHashKey(weapon), ammo, false, true)
            Utils.SendNotification(nil, "Arma recebida: " .. weapon .. " com " .. ammo .. " balas", "success")
        else
            Utils.SendNotification(nil, "Você não tem permissão para usar este comando!", "error")
        end
    end)
end, false)

-- Comando para jogador mudar cor da própria arma
RegisterCommand("myweaponcolor", function(source, args)
    print("[DEBUG] Comando myweaponcolor executado!")
    
    if #args < 1 then
        Utils.SendNotification(nil, "Uso: /myweaponcolor <color>", "error")
        Utils.SendNotification(nil, "Exemplo: /myweaponcolor 7", "info")
        Utils.SendNotification(nil, "Cores: 0-7", "info")
        return
    end
    
    local color = tonumber(args[1])
    print("[DEBUG] Cor solicitada:", color)
    
    if not color or color < 0 or color > 7 then
        Utils.SendNotification(nil, "Cor inválida! Use valores de 0 a 7", "error")
        return
    end
    
    local ped = PlayerPedId()
    local weaponsChanged = 0
    print("[DEBUG] Ped ID:", ped)
    
    -- Lista de armas padrão do framework
    local defaultWeapons = {
        "WEAPON_PISTOL",
        "WEAPON_COMBATPISTOL", 
        "WEAPON_APPISTOL",
        "WEAPON_PISTOL50",
        "WEAPON_SNSPISTOL",
        "WEAPON_HEAVYPISTOL",
        "WEAPON_VINTAGEPISTOL",
        "WEAPON_MARKSMANPISTOL",
        "WEAPON_MACHINEPISTOL",
        "WEAPON_VPISTOL",
        "WEAPON_PISTOL_MK2",
        "WEAPON_SNSPISTOL_MK2",
        "WEAPON_REVOLVER",
        "WEAPON_REVOLVER_MK2",
        "WEAPON_DOUBLEACTION",
        "WEAPON_CERAMICPISTOL",
        "WEAPON_NAVYREVOLVER",
        "WEAPON_GADGETPISTOL",
        "WEAPON_STUNGUN",
        "WEAPON_FLAREGUN",
        "WEAPON_RAYPISTOL",
        "WEAPON_KNIFE",
        "WEAPON_NIGHTSTICK",
        "WEAPON_HAMMER",
        "WEAPON_BAT",
        "WEAPON_CROWBAR",
        "WEAPON_GOLFCLUB",
        "WEAPON_BOTTLE",
        "WEAPON_DAGGER",
        "WEAPON_HATCHET",
        "WEAPON_KNUCKLE",
        "WEAPON_MACHETE",
        "WEAPON_SWITCHBLADE",
        "WEAPON_WRENCH",
        "WEAPON_BATTLEAXE",
        "WEAPON_POOLCUE",
        "WEAPON_STONE_HATCHET"
    }
    
    print("[DEBUG] Verificando armas...")
    for _, weapon in ipairs(defaultWeapons) do
        local weaponHash = GetHashKey(weapon)
        local hasWeapon = HasPedGotWeapon(ped, weaponHash, false)
        print("[DEBUG] Arma:", weapon, "Hash:", weaponHash, "Possui:", hasWeapon)
        
        if hasWeapon then
            print("[DEBUG] Aplicando cor", color, "na arma", weapon)
            SetPedWeaponTintIndex(ped, weaponHash, color)
            weaponsChanged = weaponsChanged + 1
            print("[DEBUG] Cor aplicada com sucesso!")
        end
    end
    
    print("[DEBUG] Total de armas alteradas:", weaponsChanged)
    
    if weaponsChanged > 0 then
        Utils.SendNotification(nil, "Cor de " .. weaponsChanged .. " armas alterada para " .. color, "success")
    else
        Utils.SendNotification(nil, "Você não tem armas para alterar a cor", "error")
    end
end, false)

-- Comando para testar cores de arma
RegisterCommand("testweaponcolor", function(source, args)
    print("[DEBUG] Testando cores de arma...")
    local ped = PlayerPedId()
    print("[DEBUG] Ped ID:", ped)
    
    -- Testar com uma arma específica
    local testWeapon = "WEAPON_PISTOL"
    local weaponHash = GetHashKey(testWeapon)
    local hasWeapon = HasPedGotWeapon(ped, weaponHash, false)
    
    print("[DEBUG] Testando arma:", testWeapon)
    print("[DEBUG] Hash:", weaponHash)
    print("[DEBUG] Possui arma:", hasWeapon)
    
    if hasWeapon then
        print("[DEBUG] Aplicando cor 7 (vermelho) na arma...")
        SetPedWeaponTintIndex(ped, weaponHash, 7)
        print("[DEBUG] Cor aplicada!")
        
        -- Verificar se a cor foi aplicada
        local currentTint = GetPedWeaponTintIndex(ped, weaponHash)
        print("[DEBUG] Cor atual da arma:", currentTint)
    else
        print("[DEBUG] Jogador não possui a arma de teste!")
    end
end, false)

-- Noclip avançado estilo ESX Admin
local isNoclip = false
local noclipSpeed = 1.5
local minSpeed = 0.1
local maxSpeed = 10.0
local noclipCam = nil
local initialHeading = 0.0

function RotationToDirection(rot)
    local z = math.rad(rot.z)
    local x = math.rad(rot.x)
    local num = math.abs(math.cos(x))
    return vector3(
        -math.sin(z) * num,
        math.cos(z) * num,
        math.sin(x)
    )
end

-- Função para ativar/desativar noclip
function ToggleNoclip()
    local ped = PlayerPedId()
    isNoclip = not isNoclip
    print('[DEBUG] isNoclip agora:', isNoclip)
    if isNoclip then
        print('[DEBUG] Ativando noclip')
        initialHeading = GetEntityHeading(ped)
        SetEntityCollision(ped, false, false)
        SetEntityVisible(ped, false, false)
        SetEntityInvincible(ped, true)
        noclipCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamActive(noclipCam, true)
        RenderScriptCams(true, false, 0, true, true)
        local currentRot = GetGameplayCamRot(2)
        SetCamRot(noclipCam, currentRot.x, currentRot.y, currentRot.z, 2)
        Utils.SendNotification(nil, "Noclip ativado! (Scroll = velocidade)", "info")
    else
        print('[DEBUG] Desativando noclip')
        SetEntityCollision(ped, true, true)
        SetEntityVisible(ped, true, false)
        SetEntityInvincible(ped, false)
        RenderScriptCams(false, false, 0, true, true)
        if noclipCam then
            DestroyCam(noclipCam, false)
            noclipCam = nil
        end
        Utils.SendNotification(nil, "Noclip desativado!", "info")
    end
end

RegisterCommand('nc', function()
    print('[DEBUG] Comando /nc chamado')
    CheckPermission('admin.noclip', function(hasPermission)
        print('[DEBUG] Callback CheckPermission executado, hasPermission:', hasPermission)
        if not hasPermission then
            Utils.SendNotification(nil, "Você não tem permissão para usar o noclip!", "error")
            print('[DEBUG] Sem permissão para noclip')
            return
        end
        print('[DEBUG] Permissão concedida para noclip')
        ToggleNoclip()
    end)
end, false)

RegisterNetEvent('pvp:toggleNoclip')
AddEventHandler('pvp:toggleNoclip', function()
    ToggleNoclip()
end)

CreateThread(function()
    while true do
        Wait(0)
        if isNoclip and noclipCam then
            local ped = PlayerPedId()
            SetEntityHeading(ped, initialHeading)
            DisableControlAction(0, 1, true) -- look left/right
            DisableControlAction(0, 2, true) -- look up/down
            local camRot = GetCamRot(noclipCam, 2)
            local camYaw = camRot.z
            local camPitch = camRot.x
            local sensitivity = 8.0
            -- Mouse look
            local mouseX = GetDisabledControlNormal(0, 1)
            local mouseY = GetDisabledControlNormal(0, 2)
            camYaw = camYaw - (mouseX * sensitivity)
            camPitch = camPitch - (mouseY * sensitivity)
            camPitch = math.max(math.min(camPitch, 89.0), -89.0)
            SetCamRot(noclipCam, camPitch, 0.0, camYaw, 2)
            -- Direção
            local camDir = RotationToDirection(vector3(camPitch, 0.0, camYaw))
            local coords = GetEntityCoords(ped)
            -- Velocidade no scroll
            if IsControlJustPressed(0, 15) then
                noclipSpeed = math.min(noclipSpeed + 0.5, maxSpeed)
            elseif IsControlJustPressed(0, 14) then
                noclipSpeed = math.max(noclipSpeed - 0.5, minSpeed)
            end
            -- Movimento
            if IsControlPressed(0, 32) then -- W
                coords = coords + camDir * noclipSpeed
            elseif IsControlPressed(0, 269) then -- S
                coords = coords - camDir * noclipSpeed
            end
            if IsControlPressed(0, 34) then -- A
                coords = coords + vector3(-camDir.y, camDir.x, 0.0) * noclipSpeed
            elseif IsControlPressed(0, 35) then -- D
                coords = coords + vector3(camDir.y, -camDir.x, 0.0) * noclipSpeed
            end
            if IsControlPressed(0, 44) then -- Q
                coords = coords + vector3(0, 0, 0.5 * noclipSpeed)
            elseif IsControlPressed(0, 36) then -- Shift
                coords = coords - vector3(0, 0, 0.5 * noclipSpeed)
            end
            SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
            SetCamCoord(noclipCam, coords.x, coords.y, coords.z)
        end
    end
end)

-- Exportar funções
exports('GetPlayerData', function()
    return PlayerData
end)

exports('GetScoreboardData', function()
    return ScoreboardData
end) 

-- Configuração da mira
local crosshair = {
    enabled = false, -- Mira customizada desativada
    radius = 0.004, -- Raio do círculo (tamanho da mira)
    thickness = 0.0015, -- Espessura dos pontos
    segments = 32, -- Quantidade de pontos (quanto mais, mais liso)
    color = {r = 83, g = 0, b = 171, a = 77}, -- #5300ab4d
    effectColor = {r = 255, g = 0, b = 0, a = 255},
    effectTime = 300,
    lastKill = 0
}

function DrawCircleCrosshair()
    local color = crosshair.color
    if GetGameTimer() - crosshair.lastKill < crosshair.effectTime then
        color = crosshair.effectColor
    end

    local centerX, centerY = 0.5, 0.5
    local radius = 0.004 -- raio da bolinha
    local thickness = 0.0015
    local segments = 32

    -- Corrige o aspect ratio
    local _, screenY = GetActiveScreenResolution()
    local aspect = GetAspectRatio(false)

    for i = 1, segments do
        local angle = (2 * math.pi) * (i / segments)
        -- Corrige o raio X pelo aspect ratio
        local x = centerX + (radius / aspect) * math.cos(angle)
        local y = centerY + radius * math.sin(angle)
        DrawRect(x, y, thickness, thickness, color.r, color.g, color.b, color.a)
    end
    DrawRect(centerX, centerY, thickness, thickness, color.r, color.g, color.b, color.a)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if crosshair.enabled then
            -- Mira customizada só aparece se crosshair.enabled for true
            DrawCircleCrosshair()
        end
    end
end)

AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        local victim = args[1]
        local attacker = args[2]
        if attacker == PlayerPedId() and IsPedAPlayer(victim) then
            Citizen.SetTimeout(50, function()
                if IsEntityDead(victim) then
                    crosshair.lastKill = GetGameTimer()
                end
            end)
        end
    end
end) 

--[[
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        -- Esconde todos os componentes do HUD, exceto a mira (14)
        for i = 0, 22 do
            if i ~= 14 then
                HideHudComponentThisFrame(i)
            end
        end
        -- Esconde explicitamente o notify padrão
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
        -- Garante que a mira padrão nunca será escondida
        -- (Nada será feito aqui para o componente 14)
    end
end)
]]
-- Evento para aplicar roupas em qualquer ped
RegisterNetEvent('pvp:applyClothes')
AddEventHandler('pvp:applyClothes', function(targetId, clothesData)
    local ped = GetPlayerPed(GetPlayerFromServerId(targetId))
    if ped and clothesData then
        if clothesData.hands then
            SetPedComponentVariation(ped, clothesData.hands.component, clothesData.hands.drawable, clothesData.hands.texture, clothesData.hands.palette)
        end
        if clothesData.torso then
            SetPedComponentVariation(ped, clothesData.torso.component, clothesData.torso.drawable, clothesData.torso.texture, clothesData.torso.palette)
        end
        if clothesData.undershirt then
            SetPedComponentVariation(ped, clothesData.undershirt.component, clothesData.undershirt.drawable, clothesData.undershirt.texture, clothesData.undershirt.palette)
        end
        if clothesData.pants then
            SetPedComponentVariation(ped, clothesData.pants.component, clothesData.pants.drawable, clothesData.pants.texture, clothesData.pants.palette)
        end
        if clothesData.shoes then
            SetPedComponentVariation(ped, clothesData.shoes.component, clothesData.shoes.drawable, clothesData.shoes.texture, clothesData.shoes.palette)
        end
    end
end) 

-- Comando para garantir mira padrão do GTA V
RegisterCommand('mirapadrao', function()
    crosshair.enabled = false
    Utils.SendNotification(nil, "Mira padrão do GTA V ativada!", "success")
end, false)

-- Sistema para desabilitar completamente a roda de armas do GTA V
CreateThread(function()
    while true do
        Wait(0)
        -- Desabilitar TODOS os controles relacionados à roda de armas
        DisableControlAction(0, 37, true) -- TAB - Weapon Wheel
        -- DisableControlAction(0, 140, true) -- Melee Attack 1 (REMOVIDO para liberar soco)
        -- DisableControlAction(0, 141, true) -- Melee Attack 2 (REMOVIDO para liberar chute)
        -- DisableControlAction(0, 142, true) -- Melee Attack Alternate (REMOVIDO para liberar ataque alternativo)
        -- DisableControlAction(0, 257, true) -- Attack 2 (REMOVIDO para liberar ataque alternativo)
        -- DisableControlAction(0, 263, true) -- Melee Attack 1 (REMOVIDO para liberar soco)
        -- DisableControlAction(0, 264, true) -- Melee Attack 2 (REMOVIDO para liberar chute)
        
        -- Desabilitar TODOS os controles de seleção de arma da roda
        DisableControlAction(0, 157, true) -- Select Weapon Wheel Slot 1
        DisableControlAction(0, 158, true) -- Select Weapon Wheel Slot 2
        DisableControlAction(0, 160, true) -- Select Weapon Wheel Slot 3
        DisableControlAction(0, 164, true) -- Select Weapon Wheel Slot 4
        DisableControlAction(0, 165, true) -- Select Weapon Wheel Slot 5
        DisableControlAction(0, 159, true) -- Select Weapon Wheel Slot 6
        DisableControlAction(0, 161, true) -- Select Weapon Wheel Slot 7
        DisableControlAction(0, 162, true) -- Select Weapon Wheel Slot 8
        DisableControlAction(0, 163, true) -- Select Weapon Wheel Slot 9
        
        -- Desabilitar controles adicionais da roda de armas (mas manter mirar)
        DisableControlAction(0, 24, true) -- Attack
        -- NÃO desabilitar 25 (Aim) - é usado para mirar
        DisableControlAction(0, 47, true) -- Detonate
        DisableControlAction(0, 58, true) -- Weapon Special
        -- DisableControlAction(0, 263, true) -- Melee Attack 1 (REMOVIDO para liberar soco)
        -- DisableControlAction(0, 264, true) -- Melee Attack 2 (REMOVIDO para liberar chute)
        -- DisableControlAction(0, 257, true) -- Attack 2 (REMOVIDO para liberar ataque alternativo)
        -- DisableControlAction(0, 140, true) -- Melee Attack 1 (REMOVIDO para liberar soco)
        -- DisableControlAction(0, 141, true) -- Melee Attack 2 (REMOVIDO para liberar chute)
        -- DisableControlAction(0, 142, true) -- Melee Attack Alternate (REMOVIDO para liberar ataque alternativo)
        -- DisableControlAction(0, 143, true) -- Melee Block (REMOVIDO para liberar bloqueio corpo a corpo)
        
        -- Garantir que o controle de mirar esteja habilitado
        EnableControlAction(0, 25, true) -- Aim
        
        -- Garantir que controles de tiro estejam habilitados
        EnableControlAction(0, 24, true) -- Attack (tiro)
        EnableControlAction(0, 140, true) -- Melee Attack 1 (soco)
        EnableControlAction(0, 141, true) -- Melee Attack 2 (chute)
        
        -- Re-habilitar apenas os controles 1,2,3,4 para o hud-go
        EnableControlAction(0, 157, true) -- 1
        EnableControlAction(0, 158, true) -- 2
        EnableControlAction(0, 160, true) -- 3
        EnableControlAction(0, 164, true) -- 4
        
        -- Forçar fechamento da roda de armas se detectada
        if IsControlPressed(0, 37) then -- TAB
            -- Cancelar qualquer NUI ativa
            SetNuiFocus(false, false)
            -- Forçar o jogador a sair da roda de armas
            ClearPedTasks(PlayerPedId())
            -- Desabilitar temporariamente o controle
            DisableControlAction(0, 37, true)
        end
    end
end)

-- Thread adicional para forçar fechamento da roda de armas
CreateThread(function()
    while true do
        Wait(100)
        local ped = PlayerPedId()
        
        -- Verificar se o jogador está em uma animação de roda de armas
        if IsPedUsingActionMode(ped) then
            -- Forçar saída do modo de ação (roda de armas)
            SetPedUsingActionMode(ped, false, -1, "DEFAULT_ACTION")
        end
        
        -- Verificar se há alguma interface de arma ativa
        if IsControlPressed(0, 37) then -- TAB
            -- Cancelar imediatamente
            DisableControlAction(0, 37, true)
            SetNuiFocus(false, false)
        end
        
        -- Forçar fechamento da roda de armas se detectada
        if IsControlPressed(0, 157) or IsControlPressed(0, 158) or IsControlPressed(0, 160) or IsControlPressed(0, 164) then
            -- Cancelar qualquer NUI ativa
            SetNuiFocus(false, false)
            -- Forçar o jogador a sair da roda de armas
            ClearPedTasks(PlayerPedId())
        end
    end
end)

-- Thread para desabilitar completamente a roda de armas
CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        
        -- Desabilitar completamente a roda de armas
        SetPedCanSwitchWeapon(ped, false)
        
        -- Se o jogador tentar abrir a roda de armas, cancelar
        if IsControlPressed(0, 37) then -- TAB
            SetPedCanSwitchWeapon(ped, false)
            DisableControlAction(0, 37, true)
        end
    end
end)

-- Comando de debug para testar controles 1,2,3,4
RegisterCommand('testcontrols', function()
    print("[DEBUG] Testando controles...")
    print("[DEBUG] Controle 1 (157):", IsControlPressed(0, 157))
    print("[DEBUG] Controle 2 (158):", IsControlPressed(0, 158))
    print("[DEBUG] Controle 3 (160):", IsControlPressed(0, 160))
    print("[DEBUG] Controle 4 (164):", IsControlPressed(0, 164))
    print("[DEBUG] Controle TAB (37):", IsControlPressed(0, 37))
end, false) 

local savedWeapons = {}
local defaultWeapons = {
    "WEAPON_PISTOL",
    "WEAPON_COMBATPISTOL", 
    "WEAPON_APPISTOL",
    "WEAPON_PISTOL50",
    "WEAPON_SNSPISTOL",
    "WEAPON_HEAVYPISTOL",
    "WEAPON_VINTAGEPISTOL",
    "WEAPON_MARKSMANPISTOL",
    "WEAPON_MACHINEPISTOL",
    "WEAPON_VPISTOL",
    "WEAPON_PISTOL_MK2",
    "WEAPON_SNSPISTOL_MK2",
    "WEAPON_REVOLVER",
    "WEAPON_REVOLVER_MK2",
    "WEAPON_DOUBLEACTION",
    "WEAPON_CERAMICPISTOL",
    "WEAPON_NAVYREVOLVER",
    "WEAPON_GADGETPISTOL",
    "WEAPON_STUNGUN",
    "WEAPON_FLAREGUN",
    "WEAPON_RAYPISTOL",
    "WEAPON_KNIFE",
    "WEAPON_NIGHTSTICK",
    "WEAPON_HAMMER",
    "WEAPON_BAT",
    "WEAPON_CROWBAR",
    "WEAPON_GOLFCLUB",
    "WEAPON_BOTTLE",
    "WEAPON_DAGGER",
    "WEAPON_HATCHET",
    "WEAPON_KNUCKLE",
    "WEAPON_MACHETE",
    "WEAPON_SWITCHBLADE",
    "WEAPON_WRENCH",
    "WEAPON_BATTLEAXE",
    "WEAPON_POOLCUE",
    "WEAPON_STONE_HATCHET"
}

function SavePlayerWeapons()
    local ped = PlayerPedId()
    savedWeapons = {}
    for i = 1, #defaultWeapons do
        local weapon = GetHashKey(defaultWeapons[i])
        if HasPedGotWeapon(ped, weapon, false) then
            local ammo = GetAmmoInPedWeapon(ped, weapon)
            table.insert(savedWeapons, {weapon = weapon, ammo = ammo})
        end
    end
end

function RestorePlayerWeapons()
    local ped = PlayerPedId()
    for i = 1, #savedWeapons do
        GiveWeaponToPed(ped, savedWeapons[i].weapon, savedWeapons[i].ammo, false, true)
    end
end 

local showPlayerIds = false

-- Sistema de persistência para showPlayerIds
local function SaveShowPlayerIdsState()
    SetResourceKvp("showPlayerIds", showPlayerIds and "true" or "false")
end

local function LoadShowPlayerIdsState()
    local saved = GetResourceKvpString("showPlayerIds")
    if saved then
        showPlayerIds = (saved == "true")
    end
end

-- Carregar estado salvo ao iniciar
LoadShowPlayerIdsState()

-- Variável de proteção
local lastKnownShowPlayerIdsState = showPlayerIds

-- Inicialização robusta
CreateThread(function()
    Wait(2000) -- Aguardar 2 segundos para garantir que tudo carregou
    LoadShowPlayerIdsState() -- Recarregar estado
    lastKnownShowPlayerIdsState = showPlayerIds -- Inicializar variável de proteção
    print('[DEBUG] Inicialização do showPlayerIds concluída. Estado:', showPlayerIds)
end)

-- Thread de proteção para showPlayerIds
CreateThread(function()
    while true do
        Wait(1000) -- Verificar a cada segundo
        
        -- Se o estado mudou sem ser pelo F7 ou comando, restaurar
        if showPlayerIds ~= lastKnownShowPlayerIdsState then
            print('[DEBUG] showPlayerIds alterado sem autorização! Restaurando...')
            print('[DEBUG] Estado anterior:', lastKnownShowPlayerIdsState)
            print('[DEBUG] Estado atual:', showPlayerIds)
            
            -- Restaurar estado salvo
            LoadShowPlayerIdsState()
            print('[DEBUG] Estado restaurado para:', showPlayerIds)
        end
        
        lastKnownShowPlayerIdsState = showPlayerIds
    end
end)

function DrawText3D(x, y, z, text)
    SetTextScale(0.45, 0.45)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z + 0.4, 0) -- offset ainda mais baixo
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

CreateThread(function()
    while true do
        Wait(0)
        if showPlayerIds then
            local players = GetActivePlayers()
            local myPed = PlayerPedId()
            local myCoords = GetEntityCoords(myPed)
            for i = 1, #players do
                local player = players[i]
                local ped = GetPlayerPed(player)
                local coords = GetEntityCoords(ped)
                local dist = #(myCoords - coords)
                if dist < 25.0 then
                    local serverId = GetPlayerServerId(player)
                    DrawText3D(coords.x, coords.y, coords.z + 0.6, tostring(serverId))
                end
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(0, 168) then -- F7
            showPlayerIds = not showPlayerIds
            lastKnownShowPlayerIdsState = showPlayerIds -- Atualizar variável de proteção
            SaveShowPlayerIdsState() -- Salvar estado
            print('[DEBUG] F7 pressed, showPlayerIds:', showPlayerIds)
            Utils.SendNotification(nil, showPlayerIds and "IDs ativados" or "IDs desativados", "info")
        end
    end
end) 

RegisterCommand('car', function(source, args, rawCommand)
    local vehicleName = args[1]
    if not vehicleName then
        Utils.SendNotification(nil, "Uso: /car <nome_do_veiculo>", "error")
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
        Utils.SendNotification(nil, "Modelo de veículo inválido ou não carregou!", "error")
        return
    end
    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, true) -- networked, mission entity
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetPedIntoVehicle(ped, vehicle, -1)
    Wait(100) -- Pequeno delay para garantir que o jogador entrou
    recentPlayerVehicles[vehicle] = GetGameTimer() -- Marcar como recentemente usado
    SetModelAsNoLongerNeeded(model)
    Utils.SendNotification(nil, "Veículo spawnado: " .. vehicleName, "success")
end, false) 

-- COMENTADO: Handler movido para hud-go para evitar duplicação
-- RegisterNetEvent('kill:showKill')
-- AddEventHandler('kill:showKill', function(victimName, victimId, weaponName)
--     print("[DEBUG][CLIENT] Recebido kill:showKill", victimName, victimId, weaponName)
--     SendNUIMessage({
--         action = "showKill",
--         payload = {
--             victimName = victimName,
--             victimId = victimId,
--             weaponName = weaponName
--         }
--     })
-- end) 

-- RegisterCommand('testkillmark', function()
--     print('[DEBUG][CLIENT] Comando /testkillmark executado!')
--     SendNUIMessage({
--         action = "showKill",
--         payload = {
--             victimName = "TESTEPLAYER",
--             victimId = 99999
--         }
--     })
-- end, false) 

CreateThread(function()
    while true do
        Wait(0)
        HideHudComponentThisFrame(1) -- Health bar
        HideHudComponentThisFrame(2) -- Armour bar (às vezes é necessário)
        HideHudComponentThisFrame(3) -- Armour bar (alternativo)
        HideHudComponentThisFrame(6) -- Weapon icon/reticle (opcional)
        HideHudComponentThisFrame(7) -- Area name (opcional)
        HideHudComponentThisFrame(8) -- Vehicle class (opcional)
        HideHudComponentThisFrame(9) -- Street name (opcional)
    end
end) 

RegisterNetEvent('pvp:showSS')
AddEventHandler('pvp:showSS', function(url)
    SendNUIMessage({ action = 'showSS', url = url })
end)

RegisterNetEvent('pvp:hideSS')
AddEventHandler('pvp:hideSS', function()
    SendNUIMessage({ action = 'hideSS' })
end)

RegisterCommand('ss', function(source, args, rawCommand)
    local id = tonumber(args[1])
    if id then
        TriggerServerEvent('pvp:ssForPlayer', id)
    else
        Utils.SendNotification(nil, 'Uso: /ss <id>', 'error')
    end
end, false)

RegisterCommand('retirarss', function(source, args, rawCommand)
    TriggerServerEvent('pvp:broadcastHideSS')
end, false) 

-- Evento para aplicar tuning máximo no veículo
RegisterNetEvent('pvp:applyMaxTuning')
AddEventHandler('pvp:applyMaxTuning', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle == 0 then
        Utils.SendNotification(nil, "Você precisa estar em um veículo para usar este comando!", "error")
        return
    end
    
    -- Aplicar todas as melhorias possíveis
    -- Motor
    SetVehicleMod(vehicle, 11, GetNumVehicleMods(vehicle, 11) - 1, false) -- Engine
    -- Freios
    SetVehicleMod(vehicle, 12, GetNumVehicleMods(vehicle, 12) - 1, false) -- Brakes
    -- Transmissão
    SetVehicleMod(vehicle, 13, GetNumVehicleMods(vehicle, 13) - 1, false) -- Transmission
    -- Suspensão
    SetVehicleMod(vehicle, 15, GetNumVehicleMods(vehicle, 15) - 1, false) -- Suspension
    -- Blindagem
    SetVehicleMod(vehicle, 16, GetNumVehicleMods(vehicle, 16) - 1, false) -- Armor
    
    -- Melhorias de performance
    SetVehicleMod(vehicle, 0, GetNumVehicleMods(vehicle, 0) - 1, false) -- Spoiler
    SetVehicleMod(vehicle, 1, GetNumVehicleMods(vehicle, 1) - 1, false) -- Front Bumper
    SetVehicleMod(vehicle, 2, GetNumVehicleMods(vehicle, 2) - 1, false) -- Rear Bumper
    SetVehicleMod(vehicle, 3, GetNumVehicleMods(vehicle, 3) - 1, false) -- Side Skirt
    SetVehicleMod(vehicle, 4, GetNumVehicleMods(vehicle, 4) - 1, false) -- Exhaust
    SetVehicleMod(vehicle, 5, GetNumVehicleMods(vehicle, 5) - 1, false) -- Frame
    SetVehicleMod(vehicle, 6, GetNumVehicleMods(vehicle, 6) - 1, false) -- Grille
    SetVehicleMod(vehicle, 7, GetNumVehicleMods(vehicle, 7) - 1, false) -- Hood
    SetVehicleMod(vehicle, 8, GetNumVehicleMods(vehicle, 8) - 1, false) -- Fender
    SetVehicleMod(vehicle, 9, GetNumVehicleMods(vehicle, 9) - 1, false) -- Right Fender
    SetVehicleMod(vehicle, 10, GetNumVehicleMods(vehicle, 10) - 1, false) -- Roof
    
    -- Rodas
    SetVehicleMod(vehicle, 23, GetNumVehicleMods(vehicle, 23) - 1, false) -- Front Wheels
    SetVehicleMod(vehicle, 24, GetNumVehicleMods(vehicle, 24) - 1, false) -- Back Wheels
    
    -- Melhorias de neon
    SetVehicleNeonLightEnabled(vehicle, 0, true) -- Front
    SetVehicleNeonLightEnabled(vehicle, 1, true) -- Back
    SetVehicleNeonLightEnabled(vehicle, 2, true) -- Left
    SetVehicleNeonLightEnabled(vehicle, 3, true) -- Right
    SetVehicleNeonLightsColour(vehicle, 255, 0, 255) -- Cor roxa
    
    -- Turbo
    ToggleVehicleMod(vehicle, 18, true) -- Turbo
    
    -- Xenon Lights
    ToggleVehicleMod(vehicle, 22, true) -- Xenon Lights
    
    -- Melhorias de performance extras
    SetVehicleModKit(vehicle, 0)
    
    -- Aplicar melhorias de handling
    local handling = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce")
    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce", handling * 1.5)
    
    local topSpeed = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel")
    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel", topSpeed * 1.3)
    
    local acceleration = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce")
    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce", acceleration * 1.4)
    
    -- Reparar veículo completamente
    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleUndriveable(vehicle, false)
    SetVehicleEngineOn(vehicle, true, true, false)
    SetVehicleEngineHealth(vehicle, 1000.0)
    SetVehicleBodyHealth(vehicle, 1000.0)
    SetVehiclePetrolTankHealth(vehicle, 1000.0)
    
    -- Aplicar cor personalizada (opcional)
    SetVehicleCustomPrimaryColour(vehicle, 0, 0, 0) -- Preto
    SetVehicleCustomSecondaryColour(vehicle, 255, 255, 255) -- Branco
    
    Utils.SendNotification(nil, "Tuning máximo aplicado com sucesso!", "success")
end)

RegisterNetEvent('pvp:showAnuncio')
AddEventHandler('pvp:showAnuncio', function(text)
    SendNUIMessage({ action = 'showAnuncio', text = text })
end)

RegisterCommand('anuncio', function(source, args, rawCommand)
    local text = table.concat(args, ' ')
    if not text or text == '' then
        Utils.SendNotification(nil, 'Uso: /anuncio <mensagem>', 'error')
        return
    end
    TriggerServerEvent('pvp:broadcastAnuncio', text)
end, false) 

-- Remover mira vermelha (lock-on) ao mirar em outros players
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        SetPlayerCanDoDriveBy(PlayerId(), false)
        SetPlayerTargetingMode(0) -- 0 = livre, 1 = lock-on
        SetPedConfigFlag(PlayerPedId(), 78, false) -- Remove lock-on
    end
end) 

-- Comando para controlar manualmente os IDs
RegisterCommand('showids', function(source, args, rawCommand)
    if #args > 0 then
        if args[1] == "on" or args[1] == "true" or args[1] == "1" then
            showPlayerIds = true
            lastKnownShowPlayerIdsState = showPlayerIds -- Atualizar variável de proteção
            SaveShowPlayerIdsState()
            Utils.SendNotification(nil, "IDs ativados manualmente", "success")
        elseif args[1] == "off" or args[1] == "false" or args[1] == "0" then
            showPlayerIds = false
            lastKnownShowPlayerIdsState = showPlayerIds -- Atualizar variável de proteção
            SaveShowPlayerIdsState()
            Utils.SendNotification(nil, "IDs desativados manualmente", "success")
        else
            Utils.SendNotification(nil, "Uso: /showids [on/off/true/false/1/0]", "error")
        end
    else
        -- Toggle manual
        showPlayerIds = not showPlayerIds
        lastKnownShowPlayerIdsState = showPlayerIds -- Atualizar variável de proteção
        SaveShowPlayerIdsState()
        Utils.SendNotification(nil, showPlayerIds and "IDs ativados" or "IDs desativados", "info")
    end
    print('[DEBUG] Comando showids executado, showPlayerIds:', showPlayerIds)
end, false)

-- Comando para verificar o estado atual
RegisterCommand('checkids', function(source, args, rawCommand)
    Utils.SendNotification(nil, "Estado dos IDs: " .. (showPlayerIds and "ATIVADO" or "DESATIVADO"), "info")
    print('[DEBUG] Estado atual do showPlayerIds:', showPlayerIds)
end, false) 