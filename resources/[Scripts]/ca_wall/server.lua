-- Wall System - Server Side
-- Adaptado para PvP Framework

Config = {}

-- Função para obter ID do jogador
function GetPlayerId(source)
    if source and source ~= 0 then
        -- Usar sistema de ID do framework
        return source
    end
    return nil
end

-- Função para verificar permissão
function HasPermission(source, permission)
    if not source then 
        print("[Wall Debug] Source é nil!")
        return false 
    end
    
    print("[Wall Debug] Verificando permissão para source:", source, "permission:", permission)
    
    -- Usar o sistema de permissões do framework
    local frameworkPerm = exports['framework']:HasPermission(source, permission)
    print("[Wall Debug] Framework permission result:", frameworkPerm)
    
    if frameworkPerm then
        return true
    end
    
    -- Verificar se é admin (fallback)
    local playerData = GetPlayerData(source)
    print("[Wall Debug] Player data:", json.encode(playerData))
    
    if playerData and playerData.group and (playerData.group == "admin" or playerData.group == Config.Permissao) then
        print("[Wall Debug] Admin fallback ativado!")
        return true
    end
    
    print("[Wall Debug] Nenhuma permissão encontrada!")
    return false
end

-- Função para obter dados do jogador
function GetPlayerData(source)
    if not source then return nil end
    
    -- Usar o sistema de permissões do framework
    local group = exports['framework']:GetPlayerGroup(source)
    local name = GetPlayerName(source)
    
    return {
        id = source,
        name = name or ("ID_" .. tostring(source)),
        group = group or "user"
    }
end

-- Evento para verificar permissão
RegisterNetEvent('wall:checkPermission')
AddEventHandler('wall:checkPermission', function()
    local source = source
    print("[Wall Debug] Verificando permissão para jogador:", source)
    
    local hasPerm = HasPermission(source, "wall")
    print("[Wall Debug] Resultado da verificação:", hasPerm)
    
    TriggerClientEvent('wall:permissionResult', source, hasPerm)
    
    -- Log para Discord se configurado
    if hasPerm and Config.Webhook and Config.Webhook ~= "" then
        local playerData = GetPlayerData(source)
        SendDiscordLog(playerData)
    end
end)

-- Função para enviar log para Discord
function SendDiscordLog(playerData)
    if not Config.Webhook or Config.Webhook == "" then return end
    
    local imageurl = "https://media.discordapp.net/attachments/810316657632870413/810506541316309012/Screenshot_3.png"
    local embed = {
        title = "Um administrador utilizou o comando /wall",
        fields = {
            {
                name = "ID do Administrador: " .. playerData.id,
                value = "Observação: Sistema adaptado para PvP Framework.\n Não oferecemos suporte a esse script Free."
            }
        },
        footer = {
            text = "PvP Framework - Wall - " .. os.date("%d/%m/%Y | %H:%M:%S"),
            icon_url = imageurl
        },
        color = 3093194
    }
    
    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', 
        json.encode({
            username = 'PvP Framework - Sistema de Wall',
            avatar_url = imageurl,
            embeds = {embed}
        }), 
        { ['Content-Type'] = 'application/json' }
    )
end

-- Evento para obter ID do jogador
RegisterNetEvent('wall:getPlayerId')
AddEventHandler('wall:getPlayerId', function()
    local source = source
    local playerId = GetPlayerId(source)
    TriggerClientEvent('wall:receivePlayerId', source, playerId)
end)

-- Evento para verificar se é admin
RegisterNetEvent('wall:checkAdmin')
AddEventHandler('wall:checkAdmin', function()
    local source = source
    local isAdmin = exports['framework']:HasPermission(source, "wall") or HasPermission(source, "wall")
    
    TriggerClientEvent('wall:adminResult', source, isAdmin)
end)

-- Inicialização
CreateThread(function()
    Wait(1000)
    print("[Wall System] Sistema de Wall inicializado!")
end)

-- Comando de teste para verificar permissões
RegisterCommand('testwall', function(source, args, rawCommand)
    local playerData = GetPlayerData(source)
    local hasWallPerm = HasPermission(source, "wall")
    local isAdmin = Permissions.HasPermission(source, "wall")
    
    print(string.format("[Wall Test] Player: %s, Group: %s, Has Wall: %s, Is Admin: %s", 
        playerData.name, playerData.group, tostring(hasWallPerm), tostring(isAdmin)))
    
    TriggerClientEvent('pvp:notification', source, 
        string.format("Teste Wall - Grupo: %s, Permissão: %s", 
            playerData.group, tostring(hasWallPerm)), "info")
end, false)