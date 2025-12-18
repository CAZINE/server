-- PvP Framework - Shared Server Variables
Players = {}
Scoreboard = {}

-- Função para obter dados do jogador
function GetPlayerData(playerId)
    return Players[playerId]
end

-- Função para definir dados do jogador
function SetPlayerData(playerId, data)
    Players[playerId] = data
end

-- Função para remover dados do jogador
function RemovePlayerData(playerId)
    Players[playerId] = nil
end

-- Função para obter todos os jogadores
function GetAllPlayers()
    return Players
end

-- Função para obter scoreboard
function GetScoreboardData()
    return Scoreboard
end

-- Função para definir scoreboard
function SetScoreboardData(data)
    Scoreboard = data
end

-- Função para obter o tamanho de uma tabela
function GetTableSize(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

-- Sistema de logs
local Logs = LoadResourceFile(GetCurrentResourceName(), 'server/logs.lua')
if Logs then
    Logs = load(Logs)()
else
    Logs = {}
    print("^1[ERRO] Sistema de logs não encontrado!^0")
end

-- Exportação do sistema de logs para outros recursos
exports('GetLogs', function()
    return Logs
end) 