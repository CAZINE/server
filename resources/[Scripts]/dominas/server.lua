-- Estado das zonas
local zoneStates = {}
for i, zone in ipairs(zones) do
    zoneStates[i] = {
        cooldown = false,
        cooldownTime = 0,
        activeGang = nil,
        timer = nil
    }
end

-- Configurações
local dominationTime = 60 -- segundos para dominar
local cooldownTime = 300 -- segundos de cooldown

-- Utilitário para broadcast
local function updateAllClients()
    TriggerClientEvent("domination:updateBlip", -1, zoneStates)
end

-- Função utilitária para pegar o identifier do jogador
local function getPlayerIdentifier(src)
    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            return v
        end
    end
    return nil
end

-- Função para buscar o nome do time do jogador
local function getPlayerTeamName(src, cb)
    local identifier = getPlayerIdentifier(src)
    if not identifier then cb(nil) return end
    exports.oxmysql:scalar('SELECT id FROM gangue_players WHERE identifier = ?', {identifier}, function(playerId)
        if not playerId then cb(nil) return end
        exports.oxmysql:scalar('SELECT t.name FROM gangue_team_members m JOIN gangue_teams t ON m.team_id = t.id WHERE m.player_id = ?', {playerId}, function(teamName)
            cb(teamName)
        end)
    end)
end

-- Substitui o evento de dominação para usar o nome do time
RegisterServerEvent("domination:start")
AddEventHandler("domination:start", function(zoneId)
    local source = source
    local state = zoneStates[zoneId]
    if not state or state.cooldown or state.activeGang then return end

    getPlayerTeamName(source, function(teamName)
        local gang = teamName or (GetPlayerData and GetPlayerData(source) and GetPlayerData(source).name) or GetPlayerName(source) or ("Jogador " .. tostring(source))
        state.activeGang = gang
        updateAllClients()
        TriggerClientEvent("domination:startTimer", source, dominationTime)

        -- Timer de dominação
        state.timer = SetTimeout(dominationTime * 1000, function()
            state.cooldown = true
            state.cooldownTime = cooldownTime
            state.activeGang = gang
            updateAllClients()
            TriggerClientEvent("domination:stopTimer", -1)
            -- Inicia cooldown
            state.timer = SetTimeout(cooldownTime * 1000, function()
                state.cooldown = false
                state.cooldownTime = 0
                state.activeGang = nil
                updateAllClients()
            end)
        end)
    end)
end)

RegisterServerEvent("domination:cancel")
AddEventHandler("domination:cancel", function(zoneId, reason)
    local source = source
    local state = zoneStates[zoneId]
    if not state then return end
    if state.timer then
        ClearTimeout(state.timer)
        state.timer = nil
    end
    state.activeGang = nil
    TriggerClientEvent("domination:stopTimer", -1)
    updateAllClients()
end)

-- Sincroniza estado ao entrar
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    deferrals.defer()
    Wait(100)
    deferrals.done()
    local src = source
    TriggerClientEvent("domination:updateBlip", src, zoneStates)
end)

-- Atualiza cooldowns a cada segundo
CreateThread(function()
    while true do
        for i, state in ipairs(zoneStates) do
            if state.cooldown and state.cooldownTime > 0 then
                state.cooldownTime = state.cooldownTime - 1
                if state.cooldownTime <= 0 then
                    state.cooldown = false
                    state.activeGang = nil
                    updateAllClients()
                end
            end
        end
        Wait(1000)
    end
end) 