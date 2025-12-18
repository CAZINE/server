-- PvP Framework - Scoreboard Management (Server)

local ScoreboardData = {}

-- Função para atualizar scoreboard
function UpdateScoreboard()
    local players = GetPlayers()
    local scoreboard = {}
    
    for _, playerId in ipairs(players) do
        local playerData = GetPlayerData(playerId)
        if playerData then
            table.insert(scoreboard, {
                id = playerId,
                fixed_id = playerData.fixed_id,
                name = playerData.name,
                kills = playerData.kills,
                deaths = playerData.deaths,
                kdRatio = Utils.CalculateKDRatio(playerData.kills, playerData.deaths),
                money = playerData.money,
                isOnline = true
            })
        end
    end
    
    -- Ordenar por kills (decrescente)
    table.sort(scoreboard, function(a, b)
        if a.kills == b.kills then
            return a.deaths < b.deaths
        end
        return a.kills > b.kills
    end)
    
    -- Limitar número de entradas
    local limitedScoreboard = {}
    for i = 1, math.min(Config.Scoreboard.maxEntries, #scoreboard) do
        table.insert(limitedScoreboard, scoreboard[i])
    end
    
    ScoreboardData = limitedScoreboard
    
    -- Enviar para todos os clientes
    TriggerClientEvent('pvp:updateScoreboard', -1, ScoreboardData)
end

-- Evento para solicitar scoreboard
RegisterNetEvent('pvp:requestScoreboard')
AddEventHandler('pvp:requestScoreboard', function()
    local source = source
    TriggerClientEvent('pvp:updateScoreboard', source, ScoreboardData)
end)

-- Evento para obter estatísticas pessoais
RegisterNetEvent('pvp:getPersonalStats')
AddEventHandler('pvp:getPersonalStats', function()
    local source = source
    
    local playerData = GetPlayerData(source)
    if playerData then
        local stats = {
            fixed_id = playerData.fixed_id,
            kills = playerData.kills,
            deaths = playerData.deaths,
            kdRatio = Utils.CalculateKDRatio(playerData.kills, playerData.deaths),
            money = playerData.money,
            rank = GetPlayerRank(source)
        }
        
        TriggerClientEvent('pvp:receivePersonalStats', source, stats)
    end
end)

-- Função para obter rank do jogador
function GetPlayerRank(playerId)
    local playerData = GetPlayerData(playerId)
    if not playerData then return 0 end
    
    local allPlayers = {}
    local players = GetAllPlayers()
    for id, player in pairs(players) do
        table.insert(allPlayers, {
            id = id,
            fixed_id = player.fixed_id,
            kills = player.kills,
            deaths = player.deaths
        })
    end
    
    -- Ordenar por kills
    table.sort(allPlayers, function(a, b)
        if a.kills == b.kills then
            return a.deaths < b.deaths
        end
        return a.kills > b.kills
    end)
    
    -- Encontrar posição do jogador
    for i, player in ipairs(allPlayers) do
        if player.id == playerId then
            return i
        end
    end
    
    return 0
end

-- Função para obter top players
function GetTopPlayers(limit)
    local players = GetAllPlayers()
    local allPlayers = {}
    
    for id, player in pairs(players) do
        table.insert(allPlayers, {
            id = id,
            fixed_id = player.fixed_id,
            name = player.name,
            kills = player.kills,
            deaths = player.deaths,
            kdRatio = Utils.CalculateKDRatio(player.kills, player.deaths)
        })
    end
    
    -- Ordenar por kills
    table.sort(allPlayers, function(a, b)
        if a.kills == b.kills then
            return a.deaths < b.deaths
        end
        return a.kills > b.kills
    end)
    
    -- Retornar top players
    local topPlayers = {}
    for i = 1, math.min(limit or 10, #allPlayers) do
        table.insert(topPlayers, allPlayers[i])
    end
    
    return topPlayers
end

-- Evento para solicitar top players
RegisterNetEvent('pvp:requestTopPlayers')
AddEventHandler('pvp:requestTopPlayers', function()
    local source = source
    local topPlayers = GetTopPlayers(10)
    TriggerClientEvent('pvp:receiveTopPlayers', source, topPlayers)
end)

-- Função para obter estatísticas do servidor
function GetServerStats()
    local players = GetAllPlayers()
    local totalKills = 0
    local totalDeaths = 0
    local totalMoney = 0
    local onlinePlayers = 0
    
    for _, player in pairs(players) do
        totalKills = totalKills + (player.kills or 0)
        totalDeaths = totalDeaths + (player.deaths or 0)
        totalMoney = totalMoney + (player.money or 0)
        onlinePlayers = onlinePlayers + 1
    end
    
    return {
        onlinePlayers = onlinePlayers,
        totalKills = totalKills,
        totalDeaths = totalDeaths,
        totalMoney = totalMoney,
        averageKDRatio = totalDeaths > 0 and (totalKills / totalDeaths) or totalKills
    }
end

-- Evento para solicitar estatísticas do servidor
RegisterNetEvent('pvp:requestServerStats')
AddEventHandler('pvp:requestServerStats', function()
    local source = source
    local serverStats = GetServerStats()
    TriggerClientEvent('pvp:receiveServerStats', source, serverStats)
end)

-- Função para buscar jogador por nome ou fixed_id
function SearchPlayer(query)
    local players = GetAllPlayers()
    local results = {}
    
    for id, player in pairs(players) do
        local nameMatch = string.find(string.lower(player.name or ""), string.lower(query))
        local fixedIdMatch = tostring(player.fixed_id or "") == query
        
        if nameMatch or fixedIdMatch then
            table.insert(results, {
                id = id,
                fixed_id = player.fixed_id,
                name = player.name,
                kills = player.kills,
                deaths = player.deaths,
                kdRatio = Utils.CalculateKDRatio(player.kills, player.deaths),
                money = player.money
            })
        end
    end
    
    return results
end

-- Evento para buscar jogador
RegisterNetEvent('pvp:searchPlayer')
AddEventHandler('pvp:searchPlayer', function(query)
    local source = source
    local results = SearchPlayer(query)
    TriggerClientEvent('pvp:receiveSearchResults', source, results)
end)

-- Atualizar scoreboard periodicamente
CreateThread(function()
    while true do
        UpdateScoreboard()
        Wait(Config.Scoreboard.updateInterval)
    end
end)

-- Exportar funções
exports('UpdateScoreboard', UpdateScoreboard)
exports('GetTopPlayers', GetTopPlayers)
exports('GetServerStats', GetServerStats)
exports('SearchPlayer', SearchPlayer)
exports('GetPlayerRank', GetPlayerRank) 