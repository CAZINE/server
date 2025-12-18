print("[PERMISSIONS] Arquivo permissions.lua carregado!")
-- Verificar se oxmysql está disponível
local oxmysql = exports.oxmysql
if not oxmysql then
    print("[PERMISSIONS] AVISO: oxmysql não está disponível! O sistema funcionará apenas em memória.")
end

-- Importar configuração de grupos
-- Remover esta linha, pois não se usa require em FiveM:
-- local Config = require 'resources/framework/shared/groups_config.lua'

local Permissions = {
    -- Armazenamento de jogadores e seus grupos (cache)
    Players = {} -- Agora: [playerId] = { "vip_quebrada", "premium" }
}

-- Função para obter identifier do jogador
function Permissions.GetPlayerIdentifier(playerId)
    local identifiers = GetPlayerIdentifiers(playerId)
    for _, identifier in ipairs(identifiers) do
        if string.find(identifier, "license:") then
            return identifier
        end
    end
    return nil
end

-- Função para carregar permissões do banco de dados (todos os grupos)
function Permissions.LoadPlayerPermission(playerId)
    local identifier = Permissions.GetPlayerIdentifier(playerId)
    if not identifier then return false end
    if not oxmysql then return false end
    local success, result = pcall(function()
        return exports.oxmysql:query_async("SELECT group_name FROM player_permissions WHERE identifier = ?", {identifier})
    end)
    if success and result then
        local groups = {}
        for _, row in ipairs(result) do
            table.insert(groups, row.group_name)
        end
        Permissions.Players[playerId] = groups
        return true
    end
    Permissions.Players[playerId] = {}
    return false
end

-- Função para salvar permissão (adicionar grupo)
function Permissions.AddPlayerGroup(playerId, group, addedBy)
    local identifier = Permissions.GetPlayerIdentifier(playerId)
    if not identifier then return false end
    if not oxmysql then return false end
    local playerName = GetPlayerName(playerId) or ("ID_"..tostring(playerId))
    -- Verifica se já tem esse grupo
    local success, result = pcall(function()
        return exports.oxmysql:query_async("SELECT id FROM player_permissions WHERE identifier = ? AND group_name = ?", {identifier, group})
    end)
    if success and result and #result > 0 then
        return true -- já tem
    end
    local success2, insertResult = pcall(function()
        return exports.oxmysql:insert_async("INSERT INTO player_permissions (identifier, player_name, group_name, added_by) VALUES (?, ?, ?, ?)", {
            identifier, playerName, group, addedBy
        })
    end)
    if success2 then
        -- Atualizar cache
        if not Permissions.Players[playerId] then Permissions.Players[playerId] = {} end
        table.insert(Permissions.Players[playerId], group)
    end
    return success2
end

-- Função para remover grupo do jogador
function Permissions.RemovePlayerGroup(playerId, group)
    local identifier = Permissions.GetPlayerIdentifier(playerId)
    if not identifier then return false end
    if not oxmysql then return false end
    local success = pcall(function()
        return oxmysql.update.await("DELETE FROM player_permissions WHERE identifier = ? AND group_name = ?", {identifier, group})
    end)
    if success then
        -- Atualizar cache
        if Permissions.Players[playerId] then
            for i, g in ipairs(Permissions.Players[playerId]) do
                if g == group then table.remove(Permissions.Players[playerId], i) break end
            end
        end
    end
    return success
end

-- Função para verificar se um jogador tem permissão (em qualquer grupo)
function Permissions.HasPermission(playerId, permission)
    local groups = Permissions.Players[playerId]
    if not groups then
        if Permissions.LoadPlayerPermission(playerId) then
            groups = Permissions.Players[playerId]
        else
            return false
        end
    end
    for _, group in ipairs(groups) do
        if group == "admin" then return true end
        local permissions = Config.GetGroupPermissions(group)
        for _, perm in ipairs(permissions) do
            if perm == permission then
                return true
            end
        end
    end
    return false
end

-- Função para definir todos os grupos de um jogador (sobrescreve)
function Permissions.SetPlayerGroups(playerId, groups, addedBy)
    local identifier = Permissions.GetPlayerIdentifier(playerId)
    if not identifier then return false end
    if not oxmysql then return false end
    -- Remove todos os grupos antigos
    oxmysql.update.await("DELETE FROM player_permissions WHERE identifier = ?", {identifier})
    -- Adiciona os novos grupos
    for _, group in ipairs(groups) do
        Permissions.AddPlayerGroup(playerId, group, addedBy)
    end
    Permissions.Players[playerId] = groups
    return true
end

-- Função para obter grupos do jogador
function Permissions.GetPlayerGroups(playerId)
    local groups = Permissions.Players[playerId]
    if not groups then
        if Permissions.LoadPlayerPermission(playerId) then
            groups = Permissions.Players[playerId]
        end
    end
    return groups or {"user"}
end

-- Função para obter nome do grupo
function Permissions.GetGroupName(group)
    return Config.GetGroupName(group)
end

-- Função para obter cor do grupo
function Permissions.GetGroupColor(group)
    return Config.GetGroupColor(group)
end

-- Função para listar todos os jogadores com permissões
function Permissions.GetAllPlayersWithPermissions()
    if not oxmysql then return {} end
    local success, result = pcall(function()
        return oxmysql.query.await("SELECT identifier, player_name, group_name, added_by, added_date, last_login FROM player_permissions ORDER BY added_date DESC")
    end)
    if success and result then
        return result
    else
        return {}
    end
end

-- Função para remover permissão de um jogador
function Permissions.RemovePlayerPermission(playerId)
    local identifier = Permissions.GetPlayerIdentifier(playerId)
    if not identifier then return false end
    
    -- Verificar se oxmysql está disponível
    if not oxmysql then
        print("[PERMISSIONS] oxmysql não está disponível!")
        return false
    end
    
    local success = pcall(function()
        return oxmysql.update.await("DELETE FROM player_permissions WHERE identifier = ?", {identifier})
    end)
    
    if success then
        Permissions.Players[playerId] = nil
        return true
    else
        return false
    end
end

-- Exportar funções
exports('HasPermission', Permissions.HasPermission)
exports('AddPlayerGroup', Permissions.AddPlayerGroup)
exports('RemovePlayerGroup', Permissions.RemovePlayerGroup)
exports('GetPlayerGroups', Permissions.GetPlayerGroups)
exports('SetPlayerGroups', Permissions.SetPlayerGroups)
exports('GetAllPlayersWithPermissions', Permissions.GetAllPlayersWithPermissions)

-- Export para obter o grupo principal do jogador (primeiro grupo)
exports('GetPlayerGroup', function(playerId)
    local groups = Permissions.GetPlayerGroups(playerId)
    if groups and #groups > 0 then
        return groups[1]
    else
        return 'user'
    end
end)

-- Comandos administrativos
RegisterCommand('setgroup', function(source, args, rawCommand)
    if source == 0 then -- Console
        local targetId = tonumber(args[1])
        local group = args[2]
        
        if not targetId or not group then
            print("Uso: setgroup <player_id> <group>")
            return
        end
        
        local success = Permissions.SetPlayerGroups(targetId, {group}, "Console")
        if success then
            print("Grupo definido para jogador " .. targetId .. ": " .. group)
            TriggerClientEvent('pvp:notification', targetId, "Seus grupos foram definidos para: " .. Permissions.GetGroupName(group), "success")
        else
            print("Erro ao definir grupo")
        end
    else
        -- Remover/verificar permissão
        -- Qualquer jogador pode usar agora

        local targetId = tonumber(args[1])
        local group = args[2]
        
        if not targetId or not group then
            TriggerClientEvent('pvp:notification', source, "Uso: /setgroup <player_id> <group>", "error")
            return
        end
        
        local adminName = GetPlayerName(source) or "Admin"
        local success = Permissions.SetPlayerGroups(targetId, {group}, adminName)
        if success then
            TriggerClientEvent('pvp:notification', source, "Grupos definidos para jogador " .. targetId .. ": " .. Permissions.GetGroupName(group), "success")
            TriggerClientEvent('pvp:notification', targetId, "Seus grupos foram definidos para: " .. Permissions.GetGroupName(group), "success")
        else
            TriggerClientEvent('pvp:notification', source, "Erro ao definir grupo", "error")
        end
    end
end, false)

-- Comando para kickar jogador
RegisterCommand('kick', function(source, args, rawCommand)
    if source == 0 then -- Console
        local targetId = tonumber(args[1])
        local reason = table.concat(args, " ", 2) or "Sem motivo"
        
        if not targetId then
            print("Uso: kick <player_id> [motivo]")
            return
        end
        
        DropPlayer(targetId, reason)
        print("Jogador " .. targetId .. " kickado. Motivo: " .. reason)
    else
        if not Permissions.HasPermission(source, "admin.kick") and not Permissions.HasPermission(source, "mod.kick") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local targetId = tonumber(args[1])
        local reason = table.concat(args, " ", 2) or "Sem motivo"
        
        if not targetId then
            TriggerClientEvent('pvp:notification', source, "Uso: /kick <player_id> [motivo]", "error")
            return
        end
        
        DropPlayer(targetId, reason)
        TriggerClientEvent('pvp:notification', source, "Jogador " .. targetId .. " kickado. Motivo: " .. reason, "success")
    end
end, false)

-- Comando para teleportar
RegisterCommand('tp', function(source, args, rawCommand)
    if source == 0 then return end -- Apenas jogadores
    
    if not Permissions.HasPermission(source, "admin.teleport") and 
       not Permissions.HasPermission(source, "mod.teleport") and
       not Permissions.HasPermission(source, "support.teleport") then
        TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
        return
    end
    
    local targetId = tonumber(args[1])
    if not targetId then
        TriggerClientEvent('pvp:notification', source, "ID inválido!", "error")
        return
    end
    local ped = GetPlayerPed(targetId)
    if not DoesEntityExist(ped) then
        TriggerClientEvent('pvp:notification', source, "Jogador encontrado, mas ped não existe (pode estar carregando ou morto).", "error")
        return
    end
    if not source or not DoesEntityExist(GetPlayerPed(source)) then
        TriggerClientEvent('pvp:notification', source, "Erro interno!", "error")
        return
    end
    
    local targetPed = GetPlayerPed(targetId)
    local sourcePed = GetPlayerPed(source)
    local coords = GetEntityCoords(targetPed)
        SetEntityCoords(sourcePed, coords.x, coords.y, coords.z, false, false, false, true)
    TriggerClientEvent('pvp:notification', source, "Teleportado para o jogador " .. targetId, "success")
end, false)

-- Comando para dar armas
RegisterCommand('giveweapon', function(source, args, rawCommand)
    if source == 0 then return end -- Apenas jogadores
    
    if not Permissions.HasPermission(source, "admin.giveweapon") then
        TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
        return
    end
    
    local targetId = tonumber(args[1])
    local weapon = args[2] or "WEAPON_PISTOL"
    local ammo = tonumber(args[3]) or 100
    
    if not targetId then
        TriggerClientEvent('pvp:notification', source, "Uso: /giveweapon <player_id> [weapon] [ammo]", "error")
        return
    end
    
    -- Verificar se o jogador é válido antes de chamar GetPlayerPed
    if not targetId or not DoesEntityExist(GetPlayerPed(targetId)) then
        TriggerClientEvent('pvp:notification', source, "Jogador não encontrado!", "error")
        return
    end
    
    local targetPed = GetPlayerPed(targetId)
    GiveWeaponToPed(targetPed, GetHashKey(weapon), ammo, false, true)
    TriggerClientEvent('pvp:notification', source, "Arma " .. weapon .. " dada para jogador " .. targetId, "success")
    TriggerClientEvent('pvp:notification', targetId, "Você recebeu uma arma: " .. weapon, "success")
end, false)

-- Comando para curar
RegisterCommand('heal', function(source, args, rawCommand)
    if source == 0 then return end -- Apenas jogadores
    
    if not Permissions.HasPermission(source, "admin.heal") and 
       not Permissions.HasPermission(source, "mod.heal") and
       not Permissions.HasPermission(source, "support.heal") and
       not Permissions.HasPermission(source, "premium.heal") then
        TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
        return
    end
    
    local targetId = tonumber(args[1])
    if not targetId then
        -- Curar a si mesmo
        -- Verificar se o jogador é válido antes de chamar GetPlayerPed
        if not source or not DoesEntityExist(GetPlayerPed(source)) then
            TriggerClientEvent('pvp:notification', source, "Erro interno!", "error")
            return
        end
        local ped = GetPlayerPed(source)
        SetEntityHealth(ped, 200)
        SetPedArmour(ped, 100)
        TriggerClientEvent('pvp:notification', source, "Você foi curado!", "success")
    else
        -- Curar outro jogador
        -- Verificar se o jogador é válido antes de chamar GetPlayerPed
        if not targetId or not DoesEntityExist(GetPlayerPed(targetId)) then
            TriggerClientEvent('pvp:notification', source, "Jogador não encontrado!", "error")
            return
        end
        local targetPed = GetPlayerPed(targetId)
        SetEntityHealth(targetPed, 200)
        SetPedArmour(targetPed, 100)
        TriggerClientEvent('pvp:notification', source, "Jogador " .. targetId .. " curado!", "success")
        TriggerClientEvent('pvp:notification', targetId, "Você foi curado!", "success")
    end
end, false)

-- Comando para reviver
RegisterCommand('revive', function(source, args, rawCommand)
    if source == 0 then return end -- Apenas jogadores
    
    if not Permissions.HasPermission(source, "admin.revive") and 
       not Permissions.HasPermission(source, "mod.revive") and
       not Permissions.HasPermission(source, "support.revive") then
        TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
        return
    end
    
    local targetId = tonumber(args[1])
    if not targetId then
        -- Reviver a si mesmo
        TriggerClientEvent('pvp:respawn', source)
        TriggerClientEvent('pvp:notification', source, "Você foi revivido!", "success")
    else
        -- Reviver outro jogador
        TriggerClientEvent('pvp:respawn', targetId)
        TriggerClientEvent('pvp:notification', source, "Jogador " .. targetId .. " revivido!", "success")
        TriggerClientEvent('pvp:notification', targetId, "Você foi revivido!", "success")
    end
end, false)

-- Comando para noclip
RegisterCommand('noclip', function(source, args, rawCommand)
    if source == 0 then return end -- Apenas jogadores
    
    if not Permissions.HasPermission(source, "admin.noclip") and 
       not Permissions.HasPermission(source, "mod.noclip") then
        TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
        return
    end
    
    TriggerClientEvent('pvp:toggleNoclip', source)
end, false)

-- Comando para anunciar
RegisterCommand('announce', function(source, args, rawCommand)
    if source == 0 then -- Console
        local message = table.concat(args, " ")
        if message ~= "" then
            TriggerClientEvent('pvp:notification', -1, "[ANÚNCIO] " .. message, "info")
            print("Anúncio enviado: " .. message)
        else
            print("Uso: announce <mensagem>")
        end
    else
        if not Permissions.HasPermission(source, "admin.announce") and 
           not Permissions.HasPermission(source, "mod.announce") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local message = table.concat(args, " ")
        if message ~= "" then
            TriggerClientEvent('pvp:notification', -1, "[ANÚNCIO] " .. message, "info")
            TriggerClientEvent('pvp:notification', source, "Anúncio enviado!", "success")
        else
            TriggerClientEvent('pvp:notification', source, "Uso: /announce <mensagem>", "error")
        end
    end
end, false)

-- Comando para limpar área
RegisterCommand('cleararea', function(source, args, rawCommand)
    if source == 0 then return end -- Apenas jogadores
    
    if not Permissions.HasPermission(source, "admin.cleararea") then
        TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
        return
    end
    
    -- Verificar se o jogador é válido antes de chamar GetPlayerPed
    if not source or not DoesEntityExist(GetPlayerPed(source)) then
        TriggerClientEvent('pvp:notification', source, "Erro interno!", "error")
        return
    end
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    
    -- Limpar veículos na área
    local vehicles = GetGamePool('CVehicle')
    for _, vehicle in ipairs(vehicles) do
        local vehCoords = GetEntityCoords(vehicle)
        local distance = #(coords - vehCoords)
        if distance < 50.0 then
            DeleteEntity(vehicle)
        end
    end
    
    TriggerClientEvent('pvp:notification', source, "Área limpa!", "success")
end, false)


-- Comando para alterar clima
RegisterCommand('weather', function(source, args, rawCommand)
    if source == 0 then -- Console
        local weather = args[1] or "CLEAR"
        SetWeatherTypeNow(weather)
        SetWeatherTypePersist(weather)
        print("Clima alterado para: " .. weather)
    else
        if not Permissions.HasPermission(source, "admin.weather") and 
           not Permissions.HasPermission(source, "premium.weather") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local weather = args[1] or "CLEAR"
        SetWeatherTypeNow(weather)
        SetWeatherTypePersist(weather)
        TriggerClientEvent('pvp:notification', source, "Clima alterado para: " .. weather, "success")
    end
end, false)

-- Comando para alterar hora
RegisterCommand('time', function(source, args, rawCommand)
    if source == 0 then -- Console
        local hour = tonumber(args[1]) or 12
        TriggerClientEvent('pvp:setTime', -1, hour, 0, 0)
        print("Hora alterada para: " .. hour .. ":00")
    else
        if not Permissions.HasPermission(source, "admin.time") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local hour = tonumber(args[1]) or 12
        TriggerClientEvent('pvp:setTime', -1, hour, 0, 0)
        TriggerClientEvent('pvp:notification', source, "Hora alterada para: " .. hour .. ":00", "success")
    end
end, false)

-- Comando para alternar entre dia e noite (português)
RegisterCommand('dianoite', function(source, args, rawCommand)
    if source == 0 then -- Console
        local currentHour = GetClockHours()
        local newHour = currentHour >= 6 and currentHour < 18 and 20 or 12 -- Se for dia (6-17h), vira noite (20h). Se for noite, vira dia (12h)
        TriggerClientEvent('pvp:setTime', -1, newHour, 0, 0)
        local timeText = newHour >= 6 and newHour < 18 and "DIA" or "NOITE"
        print("Tempo alterado para: " .. timeText .. " (" .. newHour .. ":00)")
    else
        if not Permissions.HasPermission(source, "admin.time") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local currentHour = GetClockHours()
        local newHour = currentHour >= 6 and currentHour < 18 and 20 or 12 -- Se for dia (6-17h), vira noite (20h). Se for noite, vira dia (12h)
        TriggerClientEvent('pvp:setTime', -1, newHour, 0, 0)
        local timeText = newHour >= 6 and newHour < 18 and "DIA" or "NOITE"
        TriggerClientEvent('pvp:notification', source, "Tempo alterado para: " .. timeText .. " (" .. newHour .. ":00)", "success")
    end
end, false)

-- Comando para definir dia específico (português)
RegisterCommand('dia', function(source, args, rawCommand)
    if source == 0 then -- Console
        TriggerClientEvent('pvp:setTime', -1, 12, 0, 0)
        print("Tempo alterado para: DIA (12:00)")
    else
        if not Permissions.HasPermission(source, "admin.time") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        TriggerClientEvent('pvp:setTime', -1, 12, 0, 0)
        TriggerClientEvent('pvp:notification', source, "Tempo alterado para: DIA (12:00)", "success")
    end
end, false)

-- Comando para definir noite específica (português)
RegisterCommand('noite', function(source, args, rawCommand)
    if source == 0 then -- Console
        TriggerClientEvent('pvp:setTime', -1, 20, 0, 0)
        print("Tempo alterado para: NOITE (20:00)")
    else
        if not Permissions.HasPermission(source, "admin.time") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        TriggerClientEvent('pvp:setTime', -1, 20, 0, 0)
        TriggerClientEvent('pvp:notification', source, "Tempo alterado para: NOITE (20:00)", "success")
    end
end, false)

-- Comando para definir hora específica (português)
RegisterCommand('hora', function(source, args, rawCommand)
    if source == 0 then -- Console
        local hour = tonumber(args[1]) or 12
        TriggerClientEvent('pvp:setTime', -1, hour, 0, 0)
        print("Hora alterada para: " .. hour .. ":00")
    else
        if not Permissions.HasPermission(source, "admin.time") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local hour = tonumber(args[1]) or 12
        TriggerClientEvent('pvp:setTime', -1, hour, 0, 0)
        TriggerClientEvent('pvp:notification', source, "Hora alterada para: " .. hour .. ":00", "success")
    end
end, false)

-- Comando para ver permissões
RegisterCommand('perms', function(source, args, rawCommand)
    if source == 0 then return end -- Apenas jogadores
    
    local targetId = tonumber(args[1])
    if not targetId then
        targetId = source
    end
    
    local groups = Permissions.GetPlayerGroups(targetId)
    local groupNames = {}
    for _, group in ipairs(groups) do
        table.insert(groupNames, Permissions.GetGroupName(group))
    end
    TriggerClientEvent('pvp:notification', source, "Jogador " .. targetId .. " - Grupos: " .. table.concat(groupNames, ", "), "info")
end, false)

-- Comando para listar grupos
RegisterCommand('groups', function(source, args, rawCommand)
    if source == 0 then
        print("Grupos disponíveis:")
        for group, data in pairs(Config.GetAllGroups()) do
            print("- " .. group .. " (" .. data.name .. ")")
        end
    else
        TriggerClientEvent('pvp:notification', source, "Grupos disponíveis: admin, moderador, suporte, premium, premium_outro, premium_diario, premium_bronze", "info")
    end
end, false)

-- Comando para definir grupo sem permissões (para configuração)
RegisterCommand('setgroupnoperm', function(source, args, rawCommand)
    local targetId = tonumber(args[1])
    local group = args[2]
    
    if not targetId or not group then
        if source == 0 then
            print("Uso: setgroupnoperm <player_id> <group>")
        else
            TriggerClientEvent('pvp:notification', source, "Uso: /setgroupnoperm <player_id> <group>", "error")
        end
        return
    end
    
    -- Verificar se o grupo é válido
    if not Config.GetGroupPermissions(group) then
        if source == 0 then
            print("Erro: Grupo inválido - " .. group)
        else
            TriggerClientEvent('pvp:notification', source, "Erro: Grupo inválido - " .. group, "error")
        end
        return
    end
    
    -- Salvar no banco de dados
    local addedBy = source == 0 and "Console" or (GetPlayerName(source) or "Admin")
    local success = Permissions.SavePlayerPermission(targetId, group, addedBy)
    
    if success then
        -- Atualizar cache
        Permissions.Players[targetId] = group
        
        if source == 0 then
            print("Grupo definido para jogador " .. targetId .. ": " .. group .. " (salvo no banco)")
        else
            TriggerClientEvent('pvp:notification', source, "Grupo definido para jogador " .. targetId .. ": " .. group .. " (salvo no banco)", "success")
        end
        
        TriggerClientEvent('pvp:notification', targetId, "Seu grupo foi alterado para: " .. Permissions.GetGroupName(group), "success")
    else
        if source == 0 then
            print("Erro: Não foi possível salvar no banco de dados")
        else
            TriggerClientEvent('pvp:notification', source, "Erro: Não foi possível salvar no banco de dados", "error")
        end
    end
end, false)

-- Comando para remover grupo de um jogador (sem permissões)
RegisterCommand('removegroup', function(source, args, rawCommand)
    local targetId = tonumber(args[1])
    
    if not targetId then
        if source == 0 then
            print("Uso: removegroup <player_id>")
        else
            TriggerClientEvent('pvp:notification', source, "Uso: /removegroup <player_id>", "error")
        end
        return
    end
    
    -- Remover do banco de dados
    local success = Permissions.RemovePlayerPermission(targetId)
    
    if success then
        if source == 0 then
            print("Grupo removido do jogador " .. targetId .. " (removido do banco)")
        else
            TriggerClientEvent('pvp:notification', source, "Grupo removido do jogador " .. targetId .. " (removido do banco)", "success")
        end
        
        TriggerClientEvent('pvp:notification', targetId, "Seu grupo foi removido!", "info")
    else
        if source == 0 then
            print("Erro: Não foi possível remover do banco de dados")
        else
            TriggerClientEvent('pvp:notification', source, "Erro: Não foi possível remover do banco de dados", "error")
        end
    end
end, false)

-- Evento para sincronizar permissões quando jogador entra
RegisterNetEvent('pvp:playerJoined')
AddEventHandler('pvp:playerJoined', function()
    local playerId = source
    -- Carregar permissão do banco de dados
    Permissions.LoadPlayerPermission(playerId)
end)

-- Evento quando jogador spawna
AddEventHandler('playerSpawned', function()
    local playerId = source
    -- Atualizar último login
    Permissions.UpdateLastLogin(playerId)
end)

-- Evento para remover jogador quando sai
AddEventHandler('playerDropped', function(reason)
    local playerId = source
    Permissions.Players[playerId] = nil
end)

-- Evento para verificar permissão do cliente
RegisterNetEvent('pvp:checkPermission')
AddEventHandler('pvp:checkPermission', function(permission, requestId)
    print('[DEBUG][SERVER] Evento pvp:checkPermission recebido! Permissão:', permission, 'Source:', source, 'requestId:', requestId)
    local source = source
    local hasPermission = Permissions.HasPermission(source, permission)
    TriggerClientEvent('pvp:permissionResult', source, hasPermission, requestId)
end)

-- Comando para listar todos os jogadores com permissões
RegisterCommand('listpermissions', function(source, args, rawCommand)
    if source == 0 then -- Console
        local players = Permissions.GetAllPlayersWithPermissions()
        print("=== JOGADORES COM PERMISSÕES ===")
        for _, player in ipairs(players) do
            print(string.format("ID: %s | Nome: %s | Grupo: %s | Adicionado por: %s | Data: %s", 
                player.identifier, player.player_name, player.group_name, player.added_by or "N/A", player.added_date))
        end
    else
        -- Verificar permissão admin
        if not Permissions.HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local players = Permissions.GetAllPlayersWithPermissions()
        TriggerClientEvent('pvp:notification', source, "=== JOGADORES COM PERMISSÕES ===", "info")
        for _, player in ipairs(players) do
            TriggerClientEvent('pvp:notification', source, 
                string.format("Nome: %s | Grupo: %s | Adicionado por: %s", 
                    player.player_name, player.group_name, player.added_by or "N/A"), "info")
        end
    end
end, false)

-- Comando para remover permissão de um jogador
RegisterCommand('removepermission', function(source, args, rawCommand)
    if source == 0 then -- Console
        local targetId = tonumber(args[1])
        
        if not targetId then
            print("Uso: removepermission <player_id>")
            return
        end
        
        if Permissions.RemovePlayerPermission(targetId) then
            print("Permissão removida do jogador " .. targetId)
            TriggerClientEvent('pvp:notification', targetId, "Suas permissões foram removidas!", "error")
        else
            print("Erro ao remover permissão")
        end
    else
        -- Verificar permissão admin
        if not Permissions.HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local targetId = tonumber(args[1])
        
        if not targetId then
            TriggerClientEvent('pvp:notification', source, "Uso: /removepermission <player_id>", "error")
            return
        end
        
        if Permissions.RemovePlayerPermission(targetId) then
            TriggerClientEvent('pvp:notification', source, "Permissão removida do jogador " .. targetId, "success")
            TriggerClientEvent('pvp:notification', targetId, "Suas permissões foram removidas!", "error")
        else
            TriggerClientEvent('pvp:notification', source, "Erro ao remover permissão", "error")
        end
    end
end, false)

-- Comando para verificar permissão de um jogador
RegisterCommand('checkpermission', function(source, args, rawCommand)
    if source == 0 then -- Console
        local targetId = tonumber(args[1])
        
        if not targetId then
            print("Uso: checkpermission <player_id>")
            return
        end
        
        local groups = Permissions.GetPlayerGroups(targetId)
        local groupNames = {}
        for _, group in ipairs(groups) do
            table.insert(groupNames, Permissions.GetGroupName(group))
        end
        TriggerClientEvent('pvp:notification', source, "Jogador " .. targetId .. " - Grupos: " .. table.concat(groupNames, ", "), "info")
    else
        -- Verificar permissão admin
        if not Permissions.HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local targetId = tonumber(args[1])
        
        if not targetId then
            TriggerClientEvent('pvp:notification', source, "Uso: /checkpermission <player_id>", "error")
            return
        end
        
        local groups = Permissions.GetPlayerGroups(targetId)
        local groupNames = {}
        for _, group in ipairs(groups) do
            table.insert(groupNames, Permissions.GetGroupName(group))
        end
        TriggerClientEvent('pvp:notification', source, 
            "Jogador " .. targetId .. " - Grupos: " .. table.concat(groupNames, ", "), "info")
    end
end, false)

-- Comando para testar conexão com banco de dados
RegisterCommand('testdb', function(source, args, rawCommand)
    if source == 0 then -- Console
        print("=== TESTE DE CONEXÃO COM BANCO DE DADOS ===")
        
        if not oxmysql then
            print("❌ oxmysql não está disponível!")
            return
        end
        
        -- Testar se a tabela existe
        local success, result = pcall(function()
            return oxmysql.query.await("SHOW TABLES LIKE 'player_permissions'")
        end)
        
        if success and result and #result > 0 then
            print("✅ Tabela player_permissions existe")
        else
            print("❌ Tabela player_permissions não encontrada")
            return
        end
        
        -- Testar inserção
        local testIdentifier = "license:test123"
        local insertSuccess, testResult = pcall(function()
            return oxmysql.insert.await("INSERT INTO player_permissions (identifier, player_name, group_name, added_by) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE group_name = ?", {
                testIdentifier, "Test Player", "admin", "Console", "admin"
            })
        end)
        
        if insertSuccess and testResult then
            print("✅ Inserção/atualização funcionando")
            
            -- Testar consulta
            local querySuccess, queryResult = pcall(function()
                return oxmysql.query.await("SELECT * FROM player_permissions WHERE identifier = ?", {testIdentifier})
            end)
            
            if querySuccess and queryResult and #queryResult > 0 then
                print("✅ Consulta funcionando")
                print("Dados encontrados: " .. queryResult[1].player_name .. " - " .. queryResult[1].group_name)
            else
                print("❌ Consulta falhou")
            end
            
            -- Limpar teste
            local deleteSuccess = pcall(function()
                return oxmysql.update.await("DELETE FROM player_permissions WHERE identifier = ?", {testIdentifier})
            end)
            
            if deleteSuccess then
                print("✅ Limpeza funcionando")
            else
                print("❌ Limpeza falhou")
            end
        else
            print("❌ Inserção falhou")
        end
        
        print("=== FIM DO TESTE ===")
    else
        TriggerClientEvent('pvp:notification', source, "Este comando só pode ser usado no console", "error")
    end
end, false)

RegisterCommand('admintest', function(source, args, rawCommand)
    if not Permissions.HasPermission(source, "admin.all") then
        -- Notificação na tela
        TriggerClientEvent('pvp:notification', source, "Você NÃO tem permissão de admin!", "error")
        -- Mensagem no F8/chat
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Permissão", "Você NÃO tem permissão de admin!"}
        })
        print("[PERMISSIONS][DEBUG] Jogador", source, "tentou usar /admintest sem permissão.")
        return
    end
    -- Notificação na tela
    TriggerClientEvent('pvp:notification', source, "Você TEM permissão de admin! Comando liberado.", "success")
    -- Mensagem no F8/chat
    TriggerClientEvent('chat:addMessage', source, {
        color = {0, 255, 0},
        multiline = true,
        args = {"Permissão", "Você TEM permissão de admin! Comando liberado."}
    })
    print("[PERMISSIONS][DEBUG] Jogador", source, "usou /admintest com permissão de admin.")
end, false)

RegisterCommand('reloadperm', function(source, args, rawCommand)
    Permissions.LoadPlayerPermission(source)
    TriggerClientEvent('chat:addMessage', source, {
        color = {0, 255, 255},
        multiline = true,
        args = {"Permissão", "Permissão recarregada do banco para seu ID!"}
    })
    print("[PERMISSIONS][DEBUG] reloadperm chamado para", source)
end, false)

print("[PERMISSIONS] Sistema de permissões com banco de dados carregado!") 
-- Teste de conexão com delay maior e teste de SELECT 1
if exports.oxmysql then
    AddEventHandler('onResourceStart', function(resourceName)
        if resourceName == GetCurrentResourceName() then
            -- Teste de SELECT 1 após 5 segundos
            CreateThread(function()
                Wait(5000)
                local success, result = pcall(function()
                    return exports.oxmysql:query_async("SELECT 1")
                end)
                print("[PERMISSIONS][DB] TESTE SELECT 1:", success, result)
                if not success then
                    print("[PERMISSIONS][DB][ERROR] Falha SELECT 1:", result)
                end
            end)
            -- Aguarda o oxmysql estar pronto e tenta acessar a tabela por até 30 segundos
            CreateThread(function()
                local tentativas = 0
                while tentativas < 30 do -- tenta por até 30 segundos
                    local success, result = pcall(function()
                        return exports.oxmysql:query_async("SHOW TABLES LIKE 'player_permissions'")
                    end)
                    if success and result and #result > 0 then
                        print("[PERMISSIONS][DB] Conexão OK! Tabela player_permissions encontrada.")
                        return
                    else
                        print("[PERMISSIONS][DB] Aguardando conexão com o banco...")
                        if not success then
                            print("[PERMISSIONS][DB][ERROR] Falha SHOW TABLES:", result)
                        end
                        Wait(1000)
                        tentativas = tentativas + 1
                    end
                end
                print("[PERMISSIONS][DB] ERRO: Tabela player_permissions NÃO encontrada ou erro de conexão!")
            end)
        end
    end)
else
    print("[PERMISSIONS][DB] ERRO: oxmysql não está disponível!")
end 

function Permissions.HasPermissionDB(playerId, permission)
    local identifier = Permissions.GetPlayerIdentifier(playerId)
    if not identifier then
        print("[PERMISSIONS][DEBUG] Nenhum identifier encontrado para o player:", playerId)
        return false
    end

    -- Consulta o grupo direto do banco
    local success, result = pcall(function()
        return exports.oxmysql:query_async("SELECT group_name FROM player_permissions WHERE identifier = ?", {identifier})
    end)
    if not success or not result or not result[1] then
        print("[PERMISSIONS][DEBUG] Não encontrou grupo no banco para:", identifier)
        return false
    end

    local group = result[1].group_name
    local groupData = Config.GetGroupPermissions(group)
    if not groupData then
        print("[PERMISSIONS][DEBUG] Grupo não existe na config:", group)
        return false
    end

    -- Admin tem todas as permissões
    if group == "admin" then return true end

    -- Verifica permissão específica
    for _, perm in ipairs(groupData.permissions) do
        if perm == permission then
            return true
        end
    end

    return false
end

RegisterCommand('verpermdb', function(source, args, rawCommand)
    local targetId = tonumber(args[1])
    local perm = args[2] or "admin"
    if not targetId then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 255, 0},
            multiline = true,
            args = {"Permissão", "Uso: /verpermdb [id] [permissao]"}
        })
        return
    end

    local temPerm = Permissions.HasPermissionDB(targetId, perm)
    if temPerm then
        TriggerClientEvent('chat:addMessage', source, {
            color = {0, 255, 0},
            multiline = true,
            args = {"Permissão", "O jogador " .. targetId .. " TEM a permissão: " .. perm}
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Permissão", "O jogador " .. targetId .. " NÃO TEM a permissão: " .. perm}
        })
    end
end, false) 

RegisterCommand('minhapermissao', function(source, args, rawCommand)
    local groups = Permissions.GetPlayerGroups(source)
    local groupNames = {}
    for _, group in ipairs(groups) do
        table.insert(groupNames, Permissions.GetGroupName(group))
    end
    TriggerClientEvent('chat:addMessage', source, {
        color = {0, 255, 255},
        multiline = true,
        args = {"Permissão", "Seus grupos: " .. table.concat(groupNames, ", ")}
    })
    print("[PERMISSIONS][LOG] PlayerId:", source, "Grupos:", groups)
end, false) 

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local playerId = source
    local identifier = Permissions.GetPlayerIdentifier(playerId)
    print("[PERMISSIONS][LOG] playerConnecting: Verificando permissão para playerId:", playerId, "identifier:", identifier)
    Permissions.LoadPlayerPermission(playerId)
end) 

RegisterCommand('forcetp', function(source, args, rawCommand)
    if source == 0 then return end
    if not Permissions.HasPermission(source, "admin.teleport") and 
       not Permissions.HasPermission(source, "mod.teleport") and
       not Permissions.HasPermission(source, "support.teleport") then
        TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
        return
    end
    local targetId = tonumber(args[1])
    if not targetId then
        TriggerClientEvent('pvp:notification', source, "ID inválido!", "error")
        return
    end
    local tentativas = 0
    local maxTentativas = 10
    local function tentarTeleport()
        tentativas = tentativas + 1
        local ped = GetPlayerPed(targetId)
        if DoesEntityExist(ped) then
            local sourcePed = GetPlayerPed(source)
            local coords = GetEntityCoords(ped)
            SetEntityCoords(sourcePed, coords.x, coords.y, coords.z, false, false, false, true)
            TriggerClientEvent('pvp:notification', source, "Teleportado para o jogador " .. targetId .. " (forcetp)", "success")
        elseif tentativas < maxTentativas then
            SetTimeout(1000, tentarTeleport)
        else
            TriggerClientEvent('pvp:notification', source, "Não foi possível teleportar: ped não existe após várias tentativas.", "error")
        end
    end
    tentarTeleport()
end, false) 

RegisterCommand('addgroup', function(source, args, rawCommand)
    local targetId = tonumber(args[1])
    local group = args[2]
    if not targetId or not group then
        if source == 0 then
            print("Uso: addgroup <player_id> <group>")
        else
            TriggerClientEvent('pvp:notification', source, "Uso: /addgroup <player_id> <group>", "error")
        end
        return
    end
    local addedBy = source == 0 and "Console" or (GetPlayerName(source) or "Admin")
    local success = Permissions.AddPlayerGroup(targetId, group, addedBy)
    if success then
        if source == 0 then
            print("Grupo " .. group .. " adicionado ao jogador " .. targetId)
        else
            TriggerClientEvent('pvp:notification', source, "Grupo " .. group .. " adicionado ao jogador " .. targetId, "success")
            TriggerClientEvent('pvp:notification', targetId, "Você recebeu o grupo: " .. Permissions.GetGroupName(group), "success")
        end
    else
        if source == 0 then
            print("Erro ao adicionar grupo")
        else
            TriggerClientEvent('pvp:notification', source, "Erro ao adicionar grupo", "error")
        end
    end
end, false) 

RegisterNetEvent('pvp:getPlayerGroups')
AddEventHandler('pvp:getPlayerGroups', function()
    local src = source
    local groups = Permissions.GetPlayerGroups(src)
    TriggerClientEvent('pvp:receivePlayerGroups', src, groups)
end) 

RegisterCommand('tptome', function(source, args, rawCommand)
    if source == 0 then return end -- Apenas jogadores
    
    if not Permissions.HasPermission(source, "admin.teleport") and 
       not Permissions.HasPermission(source, "mod.teleport") and
       not Permissions.HasPermission(source, "support.teleport") then
        TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
        return
    end
    
    local targetId = tonumber(args[1])
    if not targetId then
        TriggerClientEvent('pvp:notification', source, "ID inválido!", "error")
        return
    end
    if not DoesEntityExist(GetPlayerPed(targetId)) then
        TriggerClientEvent('pvp:notification', source, "Jogador não encontrado ou ped não existe.", "error")
        return
    end
    if not source or not DoesEntityExist(GetPlayerPed(source)) then
        TriggerClientEvent('pvp:notification', source, "Erro interno!", "error")
        return
    end
    local sourcePed = GetPlayerPed(source)
    local coords = GetEntityCoords(sourcePed)
    local targetPed = GetPlayerPed(targetId)
    SetEntityCoords(targetPed, coords.x, coords.y, coords.z, false, false, false, true)
    TriggerClientEvent('pvp:notification', source, "Você puxou o jogador " .. targetId .. " até você!", "success")
    TriggerClientEvent('pvp:notification', targetId, "Você foi puxado até o admin/mod/suporte!", "info")
end, false)

-- Comando para teleportar até um jogador específico
RegisterCommand('tpto', function(source, args, rawCommand)
    if source == 0 then return end -- Apenas jogadores
    
    if not Permissions.HasPermission(source, "admin.teleport") and 
       not Permissions.HasPermission(source, "mod.teleport") and
       not Permissions.HasPermission(source, "support.teleport") then
        TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
        return
    end
    
    local targetId = tonumber(args[1])
    if not targetId then
        TriggerClientEvent('pvp:notification', source, "Uso: /tpto <id>", "error")
        return
    end
    
    -- Verificar se o jogador alvo existe
    if not GetPlayerName(targetId) then
        TriggerClientEvent('pvp:notification', source, "Jogador com ID " .. targetId .. " não encontrado!", "error")
        return
    end
    
    -- Verificar se o ped do jogador alvo existe
    if not DoesEntityExist(GetPlayerPed(targetId)) then
        TriggerClientEvent('pvp:notification', source, "Jogador encontrado, mas ped não existe (pode estar carregando ou morto).", "error")
        return
    end
    
    -- Verificar se o jogador que está executando o comando existe
    if not source or not DoesEntityExist(GetPlayerPed(source)) then
        TriggerClientEvent('pvp:notification', source, "Erro interno!", "error")
        return
    end
    
    -- Obter coordenadas do jogador alvo
    local targetPed = GetPlayerPed(targetId)
    local sourcePed = GetPlayerPed(source)
    local coords = GetEntityCoords(targetPed)
    
    -- Teleportar o jogador que executou o comando até o alvo
    SetEntityCoords(sourcePed, coords.x, coords.y, coords.z, false, false, false, true)
    
    -- Notificar sucesso
    local targetName = GetPlayerName(targetId) or "ID " .. targetId
    TriggerClientEvent('pvp:notification', source, "Teleportado até o jogador " .. targetName .. " (ID: " .. targetId .. ")", "success")
end, false)

-- Comando para aplicar tuning máximo no veículo
RegisterCommand('tuning', function(source, args, rawCommand)
    if source == 0 then return end -- Apenas jogadores
    
    if not Permissions.HasPermission(source, "admin.tuning") and 
       not Permissions.HasPermission(source, "mod.tuning") and
       not Permissions.HasPermission(source, "premium.tuning") then
        TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
        return
    end
    
    local targetId = tonumber(args[1])
    local playerId = targetId or source
    
    -- Verificar se o jogador existe
    if not GetPlayerName(playerId) then
        TriggerClientEvent('pvp:notification', source, "Jogador com ID " .. playerId .. " não encontrado!", "error")
        return
    end
    
    -- Verificar se o ped do jogador existe
    if not DoesEntityExist(GetPlayerPed(playerId)) then
        TriggerClientEvent('pvp:notification', source, "Jogador encontrado, mas ped não existe (pode estar carregando ou morto).", "error")
        return
    end
    
    -- Enviar evento para o cliente aplicar o tuning
    TriggerClientEvent('pvp:applyMaxTuning', playerId)
    
    -- Notificar sucesso
    if targetId then
        local targetName = GetPlayerName(targetId) or "ID " .. targetId
        TriggerClientEvent('pvp:notification', source, "Tuning máximo aplicado no veículo do jogador " .. targetName .. " (ID: " .. targetId .. ")", "success")
        TriggerClientEvent('pvp:notification', targetId, "Seu veículo recebeu tuning máximo!", "success")
    else
        TriggerClientEvent('pvp:notification', source, "Tuning máximo aplicado no seu veículo!", "success")
    end
end, false) 

RegisterCommand('dv', function(source, args, rawCommand)
    if source == 0 then return end -- Apenas jogadores
    if not Permissions.HasPermission(source, "admin.cleararea") then
        TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
        return
    end
    if not source or not DoesEntityExist(GetPlayerPed(source)) then
        TriggerClientEvent('pvp:notification', source, "Erro interno!", "error")
        return
    end
    local ped = GetPlayerPed(source)
    local veh = GetVehiclePedIsIn(ped, false)
    if veh and veh ~= 0 then
        DeleteEntity(veh)
        TriggerClientEvent('pvp:notification', source, "Veículo deletado!", "success")
        return
    end
    -- Se não estiver em veículo, procurar o mais próximo
    local coords = GetEntityCoords(ped)
    local vehicles = GetGamePool('CVehicle')
    local closestVeh = nil
    local minDist = 7.0 -- só deleta se estiver bem perto
    for _, vehicle in ipairs(vehicles) do
        local vehCoords = GetEntityCoords(vehicle)
        local dist = #(coords - vehCoords)
        if dist < minDist then
            minDist = dist
            closestVeh = vehicle
        end
    end
    if closestVeh then
        DeleteEntity(closestVeh)
        TriggerClientEvent('pvp:notification', source, "Veículo próximo deletado!", "success")
    else
        TriggerClientEvent('pvp:notification', source, "Nenhum veículo próximo encontrado!", "error")
    end
end, false) 

RegisterCommand('copypreset', function(source, args, rawCommand)
    if source == 0 then return end -- Apenas jogadores
    if not Permissions.HasPermission(source, "admin.all") then
        TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
        return
    end
    local idOrigem = tonumber(args[1])
    local idDestino = tonumber(args[2])
    if not idOrigem or not idDestino then
        TriggerClientEvent('pvp:notification', source, "Uso: /copypreset [idOrigem] [idDestino]", "error")
        return
    end
    -- Buscar roupas do player origem
    TriggerEvent('skinshop:requestClothesFor', idOrigem, function(clothes)
        if not clothes then
            TriggerClientEvent('pvp:notification', source, "Não foi possível obter preset do jogador origem!", "error")
            return
        end
        -- Aplicar roupas no destino
        TriggerClientEvent('pvp:applyClothes', -1, idDestino, clothes)
        TriggerClientEvent('pvp:notification', source, "Preset copiado de "..idOrigem.." para "..idDestino.."!", "success")
        TriggerClientEvent('pvp:notification', idDestino, "Seu preset foi atualizado pelo admin!", "info")
    end)
end, false) 

RegisterNetEvent('pvp:broadcastSS')
AddEventHandler('pvp:broadcastSS', function(url)
    local src = source
    if not Permissions.HasPermission(src, "admin.all") then
        TriggerClientEvent('pvp:notification', src, "Você não tem permissão para usar este comando!", "error")
        return
    end
    TriggerClientEvent('pvp:showSS', -1, url)
    -- TriggerClientEvent('pvp:notification', src, "Tela SS enviada para todos!", "success")
end)

RegisterNetEvent('pvp:broadcastHideSS')
AddEventHandler('pvp:broadcastHideSS', function()
    local src = source
    if not Permissions.HasPermission(src, "admin.all") then
        TriggerClientEvent('pvp:notification', src, "Você não tem permissão para usar este comando!", "error")
        return
    end
    TriggerClientEvent('pvp:hideSS', -1)
    TriggerClientEvent('pvp:notification', src, "Tela SS removida de todos!", "success")
end) 

RegisterNetEvent('pvp:ssForPlayer')
AddEventHandler('pvp:ssForPlayer', function(targetId)
    local src = source
    if not Permissions.HasPermission(src, "admin.all") then
        TriggerClientEvent('pvp:notification', src, "Você não tem permissão para usar este comando!", "error")
        return
    end
    targetId = tonumber(targetId)
    if not targetId or not GetPlayerName(targetId) then
        TriggerClientEvent('pvp:notification', src, "ID de jogador inválido!", "error")
        return
    end
    -- URL local do resource NUI
    local fixedUrl = "nui://framework/html/ss.png"
    TriggerClientEvent('pvp:showSS', targetId, fixedUrl)
    TriggerClientEvent('pvp:notification', src, "Tela SS enviada para o jogador "..targetId.."!", "success")
    TriggerClientEvent('pvp:notification', targetId, "Um admin enviou uma tela SS para você!", "info")
end) 

RegisterCommand('ban', function(source, args, rawCommand)
    if not Permissions.HasPermission(source, "admin.all") then
        TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
        return
    end
    local subcmd = args[1]
    if subcmd ~= "one" then
        TriggerClientEvent('pvp:notification', source, "Uso: /ban one <id> <motivo>", "error")
        return
    end
    local targetId = tonumber(args[2])
    local reason = table.concat(args, " ", 3) or "Banido pelo admin"
    if not targetId or not GetPlayerName(targetId) then
        TriggerClientEvent('pvp:notification', source, "ID inválido!", "error")
        return
    end
    local identifiers = GetPlayerIdentifiers(targetId)
    local adminName = GetPlayerName(source) or "Console"
    local playerName = GetPlayerName(targetId) or "Desconhecido"
    for _, identifier in ipairs(identifiers) do
        exports.oxmysql:insert_async(
            "INSERT INTO bans (identifier, player_name, banned_by, reason) VALUES (?, ?, ?, ?)",
            {identifier, playerName, adminName, reason}
        )
    end
    DropPlayer(targetId, "Você foi banido! Motivo: " .. reason)
    TriggerClientEvent('pvp:notification', source, "Jogador banido e salvo no banco!", "success")
end, false) 

RegisterNetEvent('pvp:broadcastAnuncio')
AddEventHandler('pvp:broadcastAnuncio', function(text)
    local src = source
    if not Permissions.HasPermission(src, "admin.all") then
        TriggerClientEvent('pvp:notification', src, "Você não tem permissão para usar este comando!", "error")
        return
    end
    TriggerClientEvent('pvp:showAnuncio', -1, text)
    -- TriggerClientEvent('pvp:notification', src, "Anúncio enviado para todos!", "success")
end) 