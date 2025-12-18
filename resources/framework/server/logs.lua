-- Sistema de Logs Avançado do Framework
-- Envia logs detalhados com informações do jogador para webhook do Discord

local Logs = {}

-- CONFIGURE AQUI O SEU WEBHOOK DO DISCORD
local DISCORD_WEBHOOK = "https://ptb.discord.com/api/webhooks/1450883760961618000/oyEuBcw4WNQoj8lVu9DvkO8peLrn57_PeSx8B7YnOzCy_mtgtbK1Q9upaOvwb8JrToYp"

-- Cores para diferentes tipos de log
local COLORS = {
    KILL = 15158332,    -- Vermelho
    SPAWN = 3066993,    -- Verde
    CONNECT = 3447003,  -- Azul
    DISCONNECT = 15105570, -- Laranja
    ADMIN = 10181046,   -- Roxo
    INFO = 15844367     -- Amarelo
}

-- Função para obter informações detalhadas do jogador
local function getPlayerInfo(playerId)
    -- Verificar se playerId é válido
    if not playerId or playerId == 0 then
        return {
            name = "Jogador Desconhecido",
            steam = "Não encontrado",
            license = "Não encontrado", 
            discord = "Não encontrado",
            xbox = "Não encontrado"
        }
    end
    
    local player = GetPlayerName(playerId)
    if not player then
        player = "Jogador Desconhecido"
    end
    
    local identifiers = GetPlayerIdentifiers(playerId)
    
    local info = {
        name = player,
        steam = "Não encontrado",
        license = "Não encontrado", 
        discord = "Não encontrado",
        xbox = "Não encontrado"
    }
    
    if identifiers then
        for _, identifier in pairs(identifiers) do
            if string.find(identifier, "steam:") then
                info.steam = identifier
            elseif string.find(identifier, "license:") then
                info.license = identifier
            elseif string.find(identifier, "discord:") then
                info.discord = identifier
            elseif string.find(identifier, "xbl:") then
                info.xbox = identifier
            end
        end
    end
    
    return info
end

-- Função para criar embed do Discord
local function createEmbed(title, description, color, fields)
    local embed = {
        title = title,
        description = description,
        color = color,
        fields = fields or {},
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        footer = {
            text = "PvP Server - Sistema de Logs"
        },
        thumbnail = {
            url = "https://i.imgur.com/8tBXd6G.png" -- Ícone do servidor
        }
    }
    
    return {embeds = {embed}}
end

-- Função interna para enviar mensagem ao Discord
local function sendToDiscord(embed)
    if DISCORD_WEBHOOK == "" or DISCORD_WEBHOOK == nil then return end
    PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode(embed), { ['Content-Type'] = 'application/json' })
end

-- Função para logar um kill
function Logs.logKill(killerId, victimId, weapon)
    if not killerId or not victimId then return end
    
    local killerInfo = getPlayerInfo(killerId)
    local victimInfo = getPlayerInfo(victimId)
    
    local fields = {
        {
            name = "🔫 Matador",
            value = string.format("**%s**\nSteam: %s\nLicense: %s\nDiscord: %s", 
                killerInfo.name, killerInfo.steam, killerInfo.license, killerInfo.discord),
            inline = true
        },
        {
            name = "💀 Vítima", 
            value = string.format("**%s**\nSteam: %s\nLicense: %s\nDiscord: %s",
                victimInfo.name, victimInfo.steam, victimInfo.license, victimInfo.discord),
            inline = true
        },
        {
            name = "⚔️ Arma",
            value = weapon or "Desconhecida",
            inline = false
        }
    }
    
    local embed = createEmbed("💀 KILL REGISTRADA", "Um jogador foi eliminado no servidor!", COLORS.KILL, fields)
    sendToDiscord(embed)
end

-- Função para logar um spawn
function Logs.logSpawn(playerId, location)
    if not playerId then return end
    
    local playerInfo = getPlayerInfo(playerId)
    
    local fields = {
        {
            name = "👤 Jogador",
            value = string.format("**%s**\nSteam: %s\nLicense: %s\nDiscord: %s",
                playerInfo.name, playerInfo.steam, playerInfo.license, playerInfo.discord),
            inline = true
        },
        {
            name = "📍 Localização",
            value = location or "Local desconhecido",
            inline = true
        }
    }
    
    local embed = createEmbed("🔄 SPAWN REGISTRADO", "Um jogador spawnou no servidor!", COLORS.SPAWN, fields)
    sendToDiscord(embed)
end

-- Função para logar conexão
function Logs.logConnect(playerId)
    local playerInfo = getPlayerInfo(playerId)
    
    local fields = {
        {
            name = "👤 Jogador",
            value = string.format("**%s**\nSteam: %s\nLicense: %s\nDiscord: %s\nXbox: %s",
                playerInfo.name, playerInfo.steam, playerInfo.license, playerInfo.discord, playerInfo.xbox),
            inline = false
        }
    }
    
    local embed = createEmbed("🟢 CONEXÃO", "Um jogador conectou ao servidor!", COLORS.CONNECT, fields)
    sendToDiscord(embed)
end

-- Função para logar desconexão
function Logs.logDisconnect(playerId, reason)
    if not playerId then return end
    
    local playerInfo = getPlayerInfo(playerId)
    
    local fields = {
        {
            name = "👤 Jogador",
            value = string.format("**%s**\nSteam: %s\nLicense: %s\nDiscord: %s",
                playerInfo.name, playerInfo.steam, playerInfo.license, playerInfo.discord),
            inline = true
        },
        {
            name = "📝 Motivo",
            value = reason or "Desconhecido",
            inline = true
        }
    }
    
    local embed = createEmbed("🔴 DESCONEXÃO", "Um jogador desconectou do servidor!", COLORS.DISCONNECT, fields)
    sendToDiscord(embed)
end

-- Função para logar ação administrativa
function Logs.logAdmin(playerId, action, target, details)
    if not playerId then return end
    
    local playerInfo = getPlayerInfo(playerId)
    
    local fields = {
        {
            name = "👨‍💼 Administrador",
            value = string.format("**%s**\nSteam: %s\nLicense: %s\nDiscord: %s",
                playerInfo.name, playerInfo.steam, playerInfo.license, playerInfo.discord),
            inline = true
        },
        {
            name = "⚡ Ação",
            value = action,
            inline = true
        }
    }
    
    if target then
        table.insert(fields, {
            name = "🎯 Alvo",
            value = target,
            inline = true
        })
    end
    
    if details then
        table.insert(fields, {
            name = "📋 Detalhes",
            value = details,
            inline = false
        })
    end
    
    local embed = createEmbed("🛡️ AÇÃO ADMINISTRATIVA", "Uma ação administrativa foi executada!", COLORS.ADMIN, fields)
    sendToDiscord(embed)
end

-- Função genérica para outros logs
function Logs.log(event, message, playerId)
    if not event or not message then return end
    
    local fields = {}
    
    if playerId then
        local playerInfo = getPlayerInfo(playerId)
        table.insert(fields, {
            name = "👤 Jogador",
            value = string.format("**%s**\nSteam: %s\nLicense: %s\nDiscord: %s",
                playerInfo.name, playerInfo.steam, playerInfo.license, playerInfo.discord),
            inline = false
        })
    end
    
    table.insert(fields, {
        name = "📝 Mensagem",
        value = message,
        inline = false
    })
    
    local embed = createEmbed(string.format("ℹ️ %s", event:upper()), "Log do sistema!", COLORS.INFO, fields)
    sendToDiscord(embed)
end

-- Eventos automáticos
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals, source)
    if source and source > 0 then
        Logs.logConnect(source)
    end
end)

AddEventHandler('playerDropped', function(reason)
    if source and source > 0 then
        Logs.logDisconnect(source, reason)
    end
end)

return Logs
