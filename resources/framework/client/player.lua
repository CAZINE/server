-- PvP Framework - Player Client

local PlayerData = {}
local isProtected = false
local spawnTime = 0

-- Variável para controlar spectator
local isSpectating = false
local spectateTarget = nil

-- Variável para guardar o último killer real
local lastKillerServerId = nil
local lastKillerId = nil

-- Função para obter dados do jogador
function GetPlayerData()
    return PlayerData
end

-- Função para verificar se está protegido
function IsProtected()
    return isProtected
end

-- Função para obter tempo de spawn
function GetSpawnTime()
    return spawnTime
end

-- Função para encontrar um player válido para espectar
function GetRandomSpectateTarget()
    local myId = PlayerId()
    local players = GetActivePlayers()
    for _, id in ipairs(players) do
        if id ~= myId then
            local ped = GetPlayerPed(id)
            if DoesEntityExist(ped) and not IsEntityDead(ped) then
                return ped
            end
        end
    end
    return nil
end

-- Função para entrar em modo spectator
function EnterSpectatorMode(targetId)
    local player = PlayerPedId()
    SetEntityVisible(player, false, false)
    SetEntityInvincible(player, true)
    SetEntityAlpha(player, 0, false)
    local ped = nil
    print("[DEBUG] EnterSpectatorMode targetId:", targetId)
    if targetId and targetId ~= -1 and targetId ~= PlayerId() then
        ped = GetPlayerPed(targetId)
        print("[DEBUG] Killer ped:", ped, DoesEntityExist(ped), IsEntityDead(ped))
        if not DoesEntityExist(ped) or IsEntityDead(ped) then
            ped = nil
        end
    end
    if not ped then
        ped = GetRandomSpectateTarget()
        print("[DEBUG] Random spectate ped:", ped, DoesEntityExist(ped), ped and IsEntityDead(ped))
    end
    spectateTarget = ped
    if spectateTarget then
        NetworkSetInSpectatorMode(true, spectateTarget)
        SetFocusEntity(spectateTarget)
        isSpectating = true
        print("[DEBUG] Spectating ped:", spectateTarget)
        
        -- Buscar dados reais do jogador sendo espectado
        local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(spectateTarget))
        local targetName = GetPlayerName(NetworkGetPlayerIndexFromPed(spectateTarget)) or "Desconhecido"
        local health = math.floor((GetEntityHealth(spectateTarget) / 200) * 100)
        
        -- Enviar dados para o servidor buscar estatísticas
        TriggerServerEvent('pvp:requestSpectateStats', targetServerId, 1, targetName, health)
        
        -- Mostrar HUD de espectador imediatamente com dados básicos
        SendNUIMessage({
            action = "spectateKiller",
            payload = {
                viewers = 1,
                name = targetName,
                score = 0,
                user = targetName,
                id = targetServerId,
                health = health
            }
        })
    else
        TriggerEvent("notify:show", {type = "warning", message = "Nenhum jogador para espectar."})
        print("[DEBUG] Nenhum ped válido para espectar.")
    end
end

-- Função para sair do modo spectator
function ExitSpectatorMode()
    local player = PlayerPedId()
    NetworkSetInSpectatorMode(false, 0)
    SetEntityVisible(player, true, false)
    ResetEntityAlpha(player)
    SetEntityInvincible(player, false)
    isSpectating = false
    spectateTarget = nil
    -- Esconder o box do espectador
    SendNUIMessage({
        action = "stopSpectate"
    })
end

-- Função para respawn
function RespawnPlayer()
    ExitSpectatorMode()
    local player = PlayerPedId()
    -- Coordenadas fixas de respawn
    local spawn = {x = -1037.74, y = -2738.04, z = 20.17, heading = 327.94}
    -- Respawn
    NetworkResurrectLocalPlayer(spawn.x, spawn.y, spawn.z, spawn.heading, true, false)
    SetEntityCoordsNoOffset(player, spawn.x, spawn.y, spawn.z, false, false, false)
    SetEntityHeading(player, spawn.heading)
    SetEntityHealth(player, 200)
    ClearPedBloodDamage(player)
    -- Resetar proteção
    isProtected = true
    spawnTime = GetGameTimer()
    -- Solicitar respawn com armas restauradas do servidor
    TriggerServerEvent('pvp:respawn')
    -- Remover proteção após tempo
    SetTimeout(Config.SpawnProtection, function()
        isProtected = false
        TriggerEvent("notify:show", {type = "info", message = "Proteção de spawn removida!"})
    end)
    TriggerEvent("notify:show", {type = "info", message = "Respawn realizado!"})
end

-- Função para curar jogador
function HealPlayer()
    local player = PlayerPedId()
    SetEntityHealth(player, 200)
    ClearPedBloodDamage(player)
end

-- Função para teleportar jogador
function TeleportPlayer(x, y, z)
    local player = PlayerPedId()
    SetEntityCoords(player, x, y, z, false, false, false, true)
    TriggerEvent("notify:show", {type = "info", message = "Teleportado!"})
end

-- Função para obter posição do jogador
function GetPlayerPosition()
    local player = PlayerPedId()
    return GetEntityCoords(player)
end

-- Função para obter vida do jogador
function GetPlayerHealth()
    local player = PlayerPedId()
    return GetEntityHealth(player)
end

-- Função para obter armadura do jogador
function GetPlayerArmor()
    local player = PlayerPedId()
    return GetPedArmour(player)
end

-- Função para definir vida do jogador
function SetPlayerHealth(health)
    local player = PlayerPedId()
    SetEntityHealth(player, health)
end

-- Função para definir armadura do jogador
function SetPlayerArmor(armor)
    local player = PlayerPedId()
    SetPedArmour(player, armor)
end

-- Evento para receber dados do jogador
RegisterNetEvent('pvp:receivePlayerData')
AddEventHandler('pvp:receivePlayerData', function(data)
    PlayerData = data
end)

-- Evento para respawn
-- RegisterNetEvent('pvp:respawn')
-- AddEventHandler('pvp:respawn', function()
--     RespawnPlayer()
-- end)

-- Evento para curar
RegisterNetEvent('pvp:heal')
AddEventHandler('pvp:heal', function()
    HealPlayer()
end)

-- Evento para teleportar
RegisterNetEvent('pvp:teleport')
AddEventHandler('pvp:teleport', function(x, y, z)
    TeleportPlayer(x, y, z)
end)

-- Salvar o último atacante ao receber dano
RegisterNetEvent('baseevents:onPlayerDamaged')
AddEventHandler('baseevents:onPlayerDamaged', function(attacker, weapon, bodypart)
    if attacker and attacker ~= -1 then
        _G.lastKillerId = attacker
        print("[DEBUG] Salvando lastKillerId:", _G.lastKillerId)
    end
end)

-- Evento para salvar o killer ao morrer
RegisterNetEvent('baseevents:onPlayerKilled')
AddEventHandler('baseevents:onPlayerKilled', function(killedBy, reason)
    if killedBy and killedBy ~= -1 then
        lastKillerServerId = killedBy
    end
end)

local myGroups = nil

RegisterNetEvent('pvp:receivePlayerGroups')
AddEventHandler('pvp:receivePlayerGroups', function(groups)
    myGroups = groups
end)

function RequestMyGroups()
    TriggerServerEvent('pvp:getPlayerGroups')
end

-- Modificar thread de monitoramento de vida para ativar spectator ao morrer
CreateThread(function()
    print("[DEBUG] Thread de morte rodando no client", GetPlayerServerId(PlayerId()))
    while true do
        Wait(1000)
        local health = GetPlayerHealth()
        
        if health <= 0 and not isProtected and not isSpectating then
            print("[DEBUG] Entrou no bloco de morte!")
            SetEntityHealth(PlayerPedId(), 0)
            
            local killerIdx = -1
            if _G.lastKillerId and _G.lastKillerId ~= -1 then
                killerIdx = GetPlayerFromServerId(_G.lastKillerId)
            end
            print("[DEBUG] Ativando spectator para killerIdx:", killerIdx)
            EnterSpectatorMode(killerIdx)
            
            -- Solicitar grupos do servidor
            myGroups = nil
            RequestMyGroups()
            local waited = 0
            while myGroups == nil and waited < 2000 do Wait(50) waited = waited + 50 end
            -- Definir tempo de revive conforme grupo
            local timer = 10
            if myGroups then
                if table.contains then
                    -- Se já existir função table.contains
                else
                    function table.contains(tbl, val)
                        for i=1,#tbl do if tbl[i] == val then return true end end
                        return false
                    end
                end
                if table.contains(myGroups, "vip_milionario") then
                    timer = 2
                elseif table.contains(myGroups, "vip_playboy") then
                    timer = 5
                elseif table.contains(myGroups, "vip_quebrada") then
                    timer = 7
                end
            end
            local canRevive = false
            for i=1,timer do
                Wait(1000)
            end
            canRevive = true
            while canRevive do
                Wait(0)
                if IsControlJustPressed(0, 38) then -- Tecla E
                    canRevive = false
                end
            end
            ExitSpectatorMode()
        end
    end
end)

-- Thread para monitorar proteção de spawn
CreateThread(function()
    while true do
        Wait(100)
        
        if isProtected then
            local player = PlayerPedId()
            local currentTime = GetGameTimer()
            local timeLeft = Config.SpawnProtection - (currentTime - spawnTime)
            
            if timeLeft <= 0 then
                isProtected = false
                TriggerEvent("notify:show", {type = "info", message = "Proteção de spawn removida!"})
            end
        end
    end
end)

-- Handler para NUI callback de respawn
RegisterNUICallback('respawnPlayer', function(data, cb)
    RespawnPlayer()
    cb({})
end)

-- Thread para atualizar vida do jogador sendo espectado
CreateThread(function()
    while true do
        Wait(500) -- Atualizar a cada meio segundo
        if isSpectating and spectateTarget and DoesEntityExist(spectateTarget) then
            local health = math.floor((GetEntityHealth(spectateTarget) / 200) * 100)
            local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(spectateTarget))
            local targetName = GetPlayerName(NetworkGetPlayerIndexFromPed(spectateTarget)) or "Desconhecido"
            
            -- Atualizar apenas a vida no HUD
            SendNUIMessage({
                action = "updateSpectateHealth",
                payload = {
                    health = health,
                    name = targetName,
                    id = targetServerId
                }
            })
        end
    end
end)

-- Comandos do jogador
-- RegisterCommand('respawn', function(source, args, rawCommand)
--     RespawnPlayer()
-- end, false)

RegisterCommand('heal', function(source, args, rawCommand)
    HealPlayer()
end, false)

RegisterCommand('tpcds', function(source, args, rawCommand)
    if #args < 3 then
        TriggerEvent("notify:show", {type = "error", message = "Uso: /tpcds [x] [y] [z]"})
        return
    end
    
    local x = tonumber(args[1])
    local y = tonumber(args[2])
    local z = tonumber(args[3])
    
    if x and y and z then
        TeleportPlayer(x, y, z)
    else
        TriggerEvent("notify:show", {type = "error", message = "Coordenadas inválidas!"})
    end
end, false)

RegisterCommand('tpway', function()
    local blipIterator = GetBlipInfoIdIterator(8)
    local blip = GetFirstBlipInfoId(8)
    local found = false
    local x, y
    while DoesBlipExist(blip) do
        if GetBlipInfoIdType(blip) == 4 then -- Waypoint
            x = GetBlipInfoIdCoord(blip).x
            y = GetBlipInfoIdCoord(blip).y
            found = true
            break
        end
        blip = GetNextBlipInfoId(8)
    end
    if found and x and y then
        -- Procurar o solo (z) de cima para baixo, aguardando o carregamento
        local groundZ = nil
        local tries = 0
        for height = 1000.0, 0.0, -5.0 do
            RequestCollisionAtCoord(x, y, height)
            Wait(10)
            local success, zTest = GetGroundZFor_3dCoord(x, y, height, 0)
            if success then
                groundZ = zTest + 1.0 -- um pouco acima do solo
                break
            end
            tries = tries + 1
            if tries > 50 then break end
        end
        if not groundZ then groundZ = 100.0 end
        TeleportPlayer(x, y, groundZ)
    else
        TriggerEvent("notify:show", {type = "error", message = "Nenhum waypoint marcado no mapa!"})
    end
end, false)

RegisterCommand('pos', function(source, args, rawCommand)
    local pos = GetPlayerPosition()
    TriggerEvent("notify:show", {type = "info", message = string.format("Posição: %.2f, %.2f, %.2f", pos.x, pos.y, pos.z)})
end, false)

RegisterCommand('health', function(source, args, rawCommand)
    local health = GetPlayerHealth()
    local armor = GetPlayerArmor()
    TriggerEvent("notify:show", {type = "info", message = string.format("Vida: %d | Armadura: %d", health, armor)})
end, false)

RegisterCommand('sethealth', function(source, args, rawCommand)
    if #args < 1 then
        TriggerEvent("notify:show", {type = "error", message = "Uso: /sethealth [vida]"})
        return
    end
    
    local health = tonumber(args[1])
    if health and health >= 0 and health <= 200 then
        SetPlayerHealth(health)
        TriggerEvent("notify:show", {type = "success", message = "Vida definida para: " .. health})
    else
        TriggerEvent("notify:show", {type = "error", message = "Valor de vida inválido!"})
    end
end, false)

RegisterCommand('setarmor', function(source, args, rawCommand)
    if #args < 1 then
        TriggerEvent("notify:show", {type = "error", message = "Uso: /setarmor [armadura]"})
        return
    end
    
    local armor = tonumber(args[1])
    if armor and armor >= 0 and armor <= 100 then
        SetPlayerArmor(armor)
        TriggerEvent("notify:show", {type = "success", message = "Armadura definida para: " .. armor})
    else
        TriggerEvent("notify:show", {type = "error", message = "Valor de armadura inválido!"})
    end
end, false)

RegisterCommand('godmode', function(source, args, rawCommand)
    local player = PlayerPedId()
    local isInvincible = GetPlayerInvincible(PlayerId())
    
    SetPlayerInvincible(PlayerId(), not isInvincible)
    SetEntityInvincible(player, not isInvincible)
    
    TriggerEvent("notify:show", {type = "info", message = "Godmode " .. (not isInvincible and "ativado" or "desativado")})
end, false)


-- Novo comando para mostrar o identifier real do jogador
RegisterCommand('meuidentifier', function()
    TriggerServerEvent('pvp:showMyIdentifier')
end, false)

RegisterCommand('meuidfixo', function()
    TriggerServerEvent('pvp:showMyFixedId')
end, false)

-- Função para obter estatísticas do jogador
function GetPlayerStats()
    return {
        health = GetPlayerHealth(),
        armor = GetPlayerArmor(),
        position = GetPlayerPosition(),
        isProtected = isProtected,
        spawnTime = spawnTime,
        data = PlayerData
    }
end

-- Função para verificar se jogador está vivo
function IsPlayerAlive()
    return GetPlayerHealth() > 0
end

-- Função para verificar se jogador está em veículo
function IsPlayerInVehicle()
    local player = PlayerPedId()
    return IsPedInAnyVehicle(player, false)
end

-- Função para obter veículo do jogador
function GetPlayerVehicle()
    local player = PlayerPedId()
    if IsPedInAnyVehicle(player, false) then
        return GetVehiclePedIsIn(player, false)
    end
    return nil
end

-- Função para ejetar jogador do veículo
function EjectPlayerFromVehicle()
    local player = PlayerPedId()
    if IsPedInAnyVehicle(player, false) then
        TaskLeaveVehicle(player, GetVehiclePedIsIn(player, false), 0)
        TriggerEvent("notify:show", {type = "info", message = "Ejetado do veículo!"})
    end
end

-- Comando para ejetar do veículo
RegisterCommand('eject', function(source, args, rawCommand)
    EjectPlayerFromVehicle()
end, false)

-- Receber stats reais do espectado do servidor
RegisterNetEvent('pvp:receiveSpectateStats')
AddEventHandler('pvp:receiveSpectateStats', function(data)
    -- Atualizar HUD com dados reais do servidor
    SendNUIMessage({
        action = "spectateKiller",
        payload = {
            viewers = data.viewers or 1,
            name = data.killerName or "Desconhecido",
            score = data.kills or 0,
            user = data.killerName or "Desconhecido",
            id = data.killerId or 0,
            health = data.health or 100,
            level = data.level or 1
        }
    })
end)

RegisterNetEvent('pvp:showCoordsF8')
AddEventHandler('pvp:showCoordsF8', function(x, y, z)
    print(string.format("Suas coordenadas: X: %.2f | Y: %.2f | Z: %.2f", x, y, z))
end)

-- Exportar funções
exports('GetPlayerData', GetPlayerData)
exports('IsProtected', IsProtected)
exports('GetSpawnTime', GetSpawnTime)
exports('RespawnPlayer', RespawnPlayer)
exports('HealPlayer', HealPlayer)
exports('TeleportPlayer', TeleportPlayer)
exports('GetPlayerPosition', GetPlayerPosition)
exports('GetPlayerHealth', GetPlayerHealth)
exports('GetPlayerArmor', GetPlayerArmor)
exports('SetPlayerHealth', SetPlayerHealth)
exports('SetPlayerArmor', SetPlayerArmor)
exports('GetPlayerStats', GetPlayerStats)
exports('IsPlayerAlive', IsPlayerAlive)
exports('IsPlayerInVehicle', IsPlayerInVehicle)
exports('GetPlayerVehicle', GetPlayerVehicle)
exports('EjectPlayerFromVehicle', EjectPlayerFromVehicle) 
_G.EnterSpectatorMode = EnterSpectatorMode
_G.isSpectating = isSpectating 