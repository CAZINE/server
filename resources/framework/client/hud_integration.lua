-- hud_integration.lua - Integração do HUD customizado com o framework PvP
print("[DEBUG] hud_integration.lua carregado!")

local hudVisible = false
local playerKills = 0
local playerDeaths = 0
local creatorOpen = false -- Variável para controlar se o criador está aberto

-- Função para mostrar a HUD
function ShowHUD()
    if not hudVisible and not creatorOpen then
        hudVisible = true
        TriggerEvent("hud:toggleVisibility", true)
        print("[PvP Framework] HUD customizada ativada")
    end
end

-- Função para esconder a HUD
function HideHUD()
    if hudVisible then
        hudVisible = false
        TriggerEvent("hud:toggleVisibility", false)
        print("[PvP Framework] HUD customizada desativada")
    end
end

-- Função para atualizar kills do player
function UpdatePlayerKills(kills)
    playerKills = kills
    TriggerEvent("hud:updatePlayerKills", kills)
end

-- Função para atualizar contagem de players
function UpdatePlayersCount(count)
    TriggerEvent("hud:updatePlayersCount", count)
end

-- Função para atualizar timer de safezone (se aplicável)
function UpdateSafezoneTimer(time)
    TriggerEvent("hud:updateSafezoneTimer", time)
end

-- Evento quando o player spawna
RegisterNetEvent("pvp:playerSpawned")
AddEventHandler("pvp:playerSpawned", function()
    if not creatorOpen then
        ShowHUD()
    end
    -- Atualiza contagem de players
    local playerCount = #GetActivePlayers()
    UpdatePlayersCount(playerCount)
end)

-- Evento quando o player morre
RegisterNetEvent("pvp:playerDied")
AddEventHandler("pvp:playerDied", function()
    HideHUD()
    playerDeaths = playerDeaths + 1
end)

-- Evento quando o player mata outro
RegisterNetEvent("pvp:playerKilled")
AddEventHandler("pvp:playerKilled", function(victimName, victimId, weaponName)
    print("[DEBUG] Evento pvp:playerKilled recebido no client!")
    print("[DEBUG] victimName:", victimName)
    print("[DEBUG] victimId:", victimId)
    print("[DEBUG] weaponName:", weaponName)
    
    playerKills = playerKills + 1
    UpdatePlayerKills(playerKills)
    -- Som de kill removido
    print("[PvP Framework] Kill registrada!")
    -- Enviar para o NUI exibir o killfeed
    SendNUIMessage({
        action = "showKill",
        payload = {
            victimName = victimName or "Jogador",
            victimId = victimId or 0,
            weaponName = weaponName or ""
        }
    })
end)

-- Evento quando o player mata outro (com informações de headshot)
RegisterNetEvent("pvp:playerKilledWithInfo")
AddEventHandler("pvp:playerKilledWithInfo", function(isHeadshot)
    print("[DEBUG] Evento pvp:playerKilledWithInfo recebido! isHeadshot:", isHeadshot)
    playerKills = playerKills + 1
    UpdatePlayerKills(playerKills)
    
    if isHeadshot then
        -- Headshot sem som
        print("[PvP Framework] Headshot registrado!")
    else
        -- Kill normal sem som
        print("[PvP Framework] Kill normal registrada!")
    end
    
    -- Remover tentativa de som via NUI para evitar problemas
    
    -- O evento playerKilledAnother já é chamado automaticamente pelo HUD
end)

-- Evento para quando o criador de personagem está aberto
RegisterNetEvent("character:creatorOpened")
AddEventHandler("character:creatorOpened", function()
    creatorOpen = true
    HideHUD()
    print("[PvP Framework] Criador aberto - HUD escondida")
end)

-- Evento para quando o criador de personagem é fechado
RegisterNetEvent("character:creatorClosed")
AddEventHandler("character:creatorClosed", function()
    creatorOpen = false
    ShowHUD()
    print("[PvP Framework] Criador fechado - HUD mostrada")
end)

-- Thread para atualizar contagem de players periodicamente
CreateThread(function()
    while true do
        if hudVisible then
            local playerCount = #GetActivePlayers()
            UpdatePlayersCount(playerCount)
        end
        Wait(5000) -- Atualiza a cada 5 segundos
    end
end)

-- Comando para testar a HUD
RegisterCommand("testhud", function(source, args)
    if args[1] == "show" then
        ShowHUD()
    elseif args[1] == "hide" then
        HideHUD()
    else
        hudVisible = not hudVisible
        TriggerEvent("hud:toggleVisibility", hudVisible)
        print("[PvP Framework] HUD toggled:", hudVisible)
    end
end)

-- Comando para testar kills
RegisterCommand("testkills", function(source, args)
    local kills = tonumber(args[1]) or 1
    playerKills = playerKills + kills
    UpdatePlayerKills(playerKills)
    print("[PvP Framework] Kills atualizadas:", playerKills)
end)

-- Comando para testar som de kill (usando som nativo)
RegisterCommand("testsound", function(source, args)
    local soundType = args[1] or "kill"
    if soundType == "kill" then
        PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0)
        print("[PvP Framework] Som de kill nativo testado!")
    elseif soundType == "headshot" then
        PlaySoundFrontend(-1, "Headshot", "DLC_HEIST_FLEECA_SOUNDSET", 0)
        print("[PvP Framework] Som de headshot nativo testado!")
    else
        print("[PvP Framework] Uso: /testsound [kill|headshot]")
    end
end)

-- Comando para testar sons nativos do GTA
RegisterCommand("testsounds", function(source, args)
    local soundType = args[1] or "kill"
    if soundType == "kill" then
        PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0)
        print("[PvP Framework] Som de kill nativo testado!")
    elseif soundType == "headshot" then
        PlaySoundFrontend(-1, "Headshot", "DLC_HEIST_FLEECA_SOUNDSET", 0)
        print("[PvP Framework] Som de headshot testado!")
    elseif soundType == "success" then
        PlaySoundFrontend(-1, "Success", "DLC_HEIST_FLEECA_SOUNDSET", 0)
        print("[PvP Framework] Som de sucesso testado!")
    elseif soundType == "beep" then
        PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_FLEECA_SOUNDSET", 0)
        print("[PvP Framework] Som de beep testado!")
    elseif soundType == "ping" then
        PlaySoundFrontend(-1, "Ping", "DLC_HEIST_FLEECA_SOUNDSET", 0)
        print("[PvP Framework] Som de ping testado!")
    else
        print("[PvP Framework] Sons disponíveis: kill, headshot, success, beep, ping")
    end
end)

-- Comando para resetar stats
RegisterCommand("resetstats", function(source, args)
    playerKills = 0
    playerDeaths = 0
    UpdatePlayerKills(0)
    print("[PvP Framework] Stats resetadas")
end)

-- Exporta funções para uso em outros scripts
exports('ShowHUD', ShowHUD)
exports('HideHUD', HideHUD)
exports('UpdatePlayerKills', UpdatePlayerKills)
exports('UpdatePlayersCount', UpdatePlayersCount)
exports('UpdateSafezoneTimer', UpdateSafezoneTimer) 

-- Thread para enviar o horário do jogo para o NUI
CreateThread(function()
    while true do
        Wait(1000)
        if hudVisible then
            local hour = GetClockHours()
            local minute = GetClockMinutes()
            local timeStr = string.format("%02d:%02d", hour, minute)
            SendNUIMessage({
                action = "updateTime",
                time = timeStr
            })
        end
    end
end) 