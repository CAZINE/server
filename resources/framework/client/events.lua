-- PvP Framework - Events Client

-- Sistema de notificações usando notify:show

-- Sistema de efeitos de partículas para morte
local deathParticleEffects = {}
local activeEffects = {}

-- Função para criar efeito de partículas de morte (versão simples - raio roxo)
function CreateDeathParticleEffect(victimPed, killerPed)
    if not victimPed or not DoesEntityExist(victimPed) then return end
    if not Config.DeathEffects or not Config.DeathEffects.enabled then return end
    
    local coords = GetEntityCoords(victimPed)
    print("[DEBUG] Criando efeito de morte em:", coords.x, coords.y, coords.z)
    
    -- Efeito simples de raio roxo
    local effectId = #deathParticleEffects + 1
    deathParticleEffects[effectId] = {
        coords = coords,
        startTime = GetGameTimer(),
        type = "death",
        lightActive = true,
        id = effectId
    }
    
    -- Thread para criar raio roxo suave
    CreateThread(function()
        local startTime = GetGameTimer()
        local duration = Config.DeathEffects.duration.blood
        print("[DEBUG] Iniciando thread de efeito de morte, duração:", duration)
        
        while deathParticleEffects[effectId] and deathParticleEffects[effectId].lightActive do
            local currentTime = GetGameTimer()
            if currentTime - startTime > duration then
                print("[DEBUG] Efeito de morte expirou")
                break
            end
            
            -- Raio roxo suave e pulsante
            local pulse = math.sin((currentTime - startTime) * 0.002) * 0.2 + 0.8
            local intensity = 1.5 * pulse
            local range = 1.5
            
            -- Desenhar luz roxa
            DrawLightWithRange(
                coords.x, coords.y, coords.z + 0.5,
                128, 0, 255, -- Roxo
                intensity, -- Intensidade baixa
                range -- Raio pequeno
            )
            
            -- Debug: mostrar informações a cada segundo
            if (currentTime - startTime) % 1000 < 50 then
                print("[DEBUG] Efeito ativo - Intensidade:", intensity, "Pulse:", pulse)
            end
            
            Wait(50) -- Atualizar suavemente
        end
        
        if deathParticleEffects[effectId] then
            deathParticleEffects[effectId] = nil
            print("[DEBUG] Efeito de morte removido")
        end
    end)
    
    print("[DEATH EFFECTS] Raio roxo criado")
end

-- Função para criar efeito de headshot (versão simples - raio roxo)
function CreateHeadshotEffect(victimPed, killerPed)
    if not victimPed or not DoesEntityExist(victimPed) then return end
    if not Config.DeathEffects or not Config.DeathEffects.enabled then return end
    
    local coords = GetEntityCoords(victimPed)
    print("[DEBUG] Criando efeito de headshot em:", coords.x, coords.y, coords.z)
    
    -- Efeito simples de raio roxo
    local effectId = #deathParticleEffects + 1
    deathParticleEffects[effectId] = {
        coords = coords,
        startTime = GetGameTimer(),
        type = "headshot",
        lightActive = true,
        id = effectId
    }
    
    -- Thread para criar raio roxo suave
    CreateThread(function()
        local startTime = GetGameTimer()
        local duration = Config.DeathEffects.duration.headshot
        print("[DEBUG] Iniciando thread de headshot, duração:", duration)
        
        while deathParticleEffects[effectId] and deathParticleEffects[effectId].lightActive do
            local currentTime = GetGameTimer()
            if currentTime - startTime > duration then
                print("[DEBUG] Efeito de headshot expirou")
                break
            end
            
            -- Raio roxo suave e pulsante
            local pulse = math.sin((currentTime - startTime) * 0.004) * 0.4 + 0.6
            local intensity = 2.5 * pulse
            local range = 2.5
            
            -- Desenhar luz roxa
            DrawLightWithRange(
                coords.x, coords.y, coords.z + 1.5,
                128, 0, 255, -- Roxo
                intensity, -- Intensidade um pouco maior
                range -- Raio um pouco maior
            )
            
            -- Debug: mostrar informações a cada segundo
            if (currentTime - startTime) % 1000 < 50 then
                print("[DEBUG] Headshot ativo - Intensidade:", intensity, "Pulse:", pulse)
            end
            
            Wait(50) -- Atualizar suavemente
        end
        
        if deathParticleEffects[effectId] then
            deathParticleEffects[effectId] = nil
            print("[DEBUG] Efeito de headshot removido")
        end
    end)
    
    print("[HEADSHOT EFFECT] Raio roxo criado")
end

-- Função para limpar todos os efeitos de partículas
function ClearAllDeathEffects()
    for effectId, effect in pairs(deathParticleEffects) do
        if effect.lightActive then
            effect.lightActive = false
        end
    end
    deathParticleEffects = {}
    print("[DEATH EFFECTS] Todos os efeitos de partículas foram limpos")
end

-- Tornar funções globais para acesso pelos comandos de teste
_G.CreateDeathParticleEffect = CreateDeathParticleEffect
_G.CreateHeadshotEffect = CreateHeadshotEffect
_G.ClearAllDeathEffects = ClearAllDeathEffects

-- Evento quando jogador spawna
AddEventHandler('playerSpawned', function(spawn)
    local player = PlayerPedId()
    RemoveAllPedWeapons(player, true)
    -- Removido: Dar faca ao spawnar - jogadores agora entram sem armas
    
    -- Configurações iniciais
    SetEntityHealth(player, 200)
    SetPedArmour(player, 0)
    SetPlayerInvincible(PlayerId(), false)
    
    -- Remover wanted level
    SetPlayerWantedLevel(PlayerId(), 0, false)
    
    -- Solicitar dados do jogador
    TriggerServerEvent('pvp:getPlayerData')
    
    Utils.Log("Jogador spawnou!")

    -- Ocultar HUD de espectador ao respawnar
    SendNUIMessage({ action = "stopSpectate" })
    
    -- Limpar efeitos de partículas ao spawnar
    ClearAllDeathEffects()
end)

-- Evento quando jogador morre
AddEventHandler('baseevents:onPlayerKilled', function(killedBy, reason)
    local player = PlayerPedId()
    RemoveAllPedWeapons(player, true)

    -- Verificar se foi headshot
    local isHeadshot = false
    if killedBy and killedBy ~= -1 then
        local bone = GetPedLastDamageBone(player)
        isHeadshot = Utils.IsHeadshot(bone)
    end

    -- Notificar morte
    local deathMessage = "Você morreu!"
    if isHeadshot then
        deathMessage = "Você foi headshot!"
    end

    TriggerEvent('notify:show', {type = 'error', message = deathMessage})

    -- Efeito de morte
    SetEntityHealth(player, 0)

    -- Tentar identificar o killer corretamente
    local killerPed = GetPedSourceOfDeath(player)
    local killerIdx = -1
    if killerPed and killerPed ~= 0 then
        killerIdx = NetworkGetPlayerIndexFromPed(killerPed)
    end
    print("[DEBUG] killerPed:", killerPed, "killerIdx:", killerIdx)

    -- Salvar o killer para uso posterior
    if killerIdx ~= -1 then
        _G.lastKillerId = GetPlayerServerId(killerIdx)
        print("[DEBUG] Salvando lastKillerId:", _G.lastKillerId)
        
        -- Criar efeitos de partículas se foi morto por outro jogador
        if killerPed and killerPed ~= player then
            CreateDeathParticleEffect(player, killerPed)
            
            if isHeadshot then
                CreateHeadshotEffect(player, killerPed)
            end
        end
    end

    -- Ativar modo espectador se não estiver já espectando
    if not _G.isSpectating and _G.EnterSpectatorMode then
        _G.EnterSpectatorMode(killerIdx)
    end
end)

-- Evento quando mata outro jogador
AddEventHandler('baseevents:onPlayerKilled', function(killedBy, reason)
    if killedBy and killedBy ~= -1 then
        local killer = GetPlayerPed(killedBy)
        local victim = PlayerPedId()
        
        if killer == victim then
            -- Suicídio
            -- TriggerEvent('notify:show', {type = 'error', message = "Você se matou!"})
        else
            -- Kill
            local weapon = GetPedCauseOfDeath(victim)
            local bone = GetPedLastDamageBone(victim)
            local isHeadshot = Utils.IsHeadshot(bone)
            
            -- Notificar kill
            local weaponName = Utils.GetWeaponName(weapon)
            TriggerEvent('notify:show', {type = 'success', message = "Você matou um jogador com " .. weaponName})
            
            if isHeadshot then
                TriggerEvent('notify:show', {type = 'success', message = "Headshot! +50 bônus"})
            end
        end
    end
end)

-- Evento para receber notificação de morte de outro jogador
RegisterNetEvent('pvp:playerKilledByOther')
AddEventHandler('pvp:playerKilledByOther', function(victimId, killerId, isHeadshot)
    local victimPed = GetPlayerPed(GetPlayerFromServerId(victimId))
    local killerPed = GetPlayerPed(GetPlayerFromServerId(killerId))
    
    if victimPed and DoesEntityExist(victimPed) then
        -- Criar efeitos de partículas para a morte
        CreateDeathParticleEffect(victimPed, killerPed)
        
        if isHeadshot then
            CreateHeadshotEffect(victimPed, killerPed)
        end
    end
end)

-- Evento para notificações
RegisterNetEvent('pvp:notification')
AddEventHandler('pvp:notification', function(message, type)
    TriggerEvent('notify:show', {type = type, message = message})
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
    local player = PlayerPedId()
    RemoveAllPedWeapons(player, true)
    
    -- Respawn
    NetworkResurrectLocalPlayer(GetEntityCoords(player), GetEntityHeading(player), true, false)
    SetEntityHealth(player, 200)
    ClearPedBloodDamage(player)
    
    -- As armas serão dadas pelo servidor automaticamente
    -- TriggerServerEvent('pvp:giveWeapons')
    
    Utils.Log("Respawn realizado!")
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

-- Evento para receber informações da zona
RegisterNetEvent('pvp:receiveZoneInfo')
AddEventHandler('pvp:receiveZoneInfo', function(zoneInfo)
    if zoneInfo then
        CurrentZone = zoneInfo
    else
        CurrentZone = nil
    end
end)

-- Evento para receber todas as zonas
RegisterNetEvent('pvp:receiveAllZones')
AddEventHandler('pvp:receiveAllZones', function(zones)
    -- Atualizar blips se necessário
    for _, zone in ipairs(zones) do
        if not ZoneBlips[zone.id] then
            CreateZoneBlip(zone)
        end
    end
end)

-- Evento para receber armas do jogador
RegisterNetEvent('pvp:receivePlayerWeapons')
AddEventHandler('pvp:receivePlayerWeapons', function(weapons)
    PlayerWeapons = weapons
end)

-- Evento quando entra em uma zona
AddEventHandler('pvp:zoneEntered', function(zone)
    TriggerEvent('notify:show', {type = 'info', message = "Entrou na zona: " .. zone.name})
    
    -- Efeito visual
    local player = PlayerPedId()
    SetEntityHealth(player, GetEntityHealth(player) + 10) -- Pequeno bônus de vida
    
    -- Som de entrada na zona removido
end)

-- Evento quando sai de uma zona
AddEventHandler('pvp:zoneLeft', function(zone)
    TriggerEvent('notify:show', {type = 'info', message = "Saiu da zona: " .. zone.name})
    
    -- Som de saída da zona removido
end)

-- Evento para mostrar notificação na tela
RegisterNetEvent('pvp:showNotification')
AddEventHandler('pvp:showNotification', function(message, type)
    ShowNotification(message, type)
end)

-- Função para enviar evento de kill
function SendKillEvent(killedPlayer, weapon, isHeadshot)
    TriggerServerEvent('pvp:playerKilled', killedPlayer, weapon, isHeadshot)
end

-- Função para enviar evento de morte
function SendDeathEvent(killedBy, reason)
    TriggerServerEvent('pvp:playerDied', killedBy, reason)
end

-- Função para enviar evento de entrada na zona
function SendZoneEnterEvent(zoneId)
    TriggerServerEvent('pvp:zoneEntered', zoneId)
end

-- Função para enviar evento de saída da zona
function SendZoneLeaveEvent(zoneId)
    TriggerServerEvent('pvp:zoneLeft', zoneId)
end

-- Função para enviar evento de mudança de arma
function SendWeaponChangeEvent(weapon)
    TriggerServerEvent('pvp:weaponChanged', weapon)
end

-- Função para enviar evento de recarga
function SendReloadEvent(weapon)
    TriggerServerEvent('pvp:weaponReloaded', weapon)
end

-- Função para enviar evento de teleporte
function SendTeleportEvent(x, y, z)
    TriggerServerEvent('pvp:playerTeleported', x, y, z)
end

-- Função para enviar evento de cura
function SendHealEvent()
    TriggerServerEvent('pvp:playerHealed')
end

-- Função para enviar evento de respawn
function SendRespawnEvent()
    TriggerServerEvent('pvp:playerRespawned')
end

-- Evento para mudança de tempo
RegisterNetEvent('pvp:setTime')
AddEventHandler('pvp:setTime', function(hour, minute, second)
    NetworkOverrideClockTime(hour, minute or 0, second or 0)
    print("[DEBUG] Tempo alterado para: " .. hour .. ":" .. (minute or 0) .. ":" .. (second or 0))
end)

-- Exportar funções
exports('SendKillEvent', SendKillEvent)
exports('SendDeathEvent', SendDeathEvent)
exports('SendZoneEnterEvent', SendZoneEnterEvent)
exports('SendZoneLeaveEvent', SendZoneLeaveEvent)
exports('SendWeaponChangeEvent', SendWeaponChangeEvent)
exports('SendReloadEvent', SendReloadEvent)
exports('SendTeleportEvent', SendTeleportEvent)
exports('SendHealEvent', SendHealEvent)
exports('SendRespawnEvent', SendRespawnEvent) 