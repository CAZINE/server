-- server.lua

local gangs = {}
local pendingInvites = {} -- {playerId = {gangId, gangName}}
local storedInvites = {} -- {playerId = gangId} para comandos
local oxmysql = exports.oxmysql

-- Função de fallback para verificar se jogador existe
local function IsPlayerOnline(playerId)
    return GetPlayerName(playerId) ~= nil
end

-- Função de fallback para obter dados do jogador
local function GetPlayerDataSafe(playerId)
    if GetPlayerData then
        return GetPlayerData(playerId)
    else
        -- Fallback: retorna dados básicos se framework não estiver disponível
        local playerName = GetPlayerName(playerId)
        if playerName then
            return {
                id = playerId,
                name = playerName
            }
        end
        return nil
    end
end

-- Carregar gangues do banco ao iniciar
AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        oxmysql:execute('SELECT * FROM gangs', {}, function(result)
            for _, row in ipairs(result) do
                local gang = json.decode(row.data)
                table.insert(gangs, gang)
            end
        end)
    end
end)

RegisterServerEvent('gang:requestGangPanel')
AddEventHandler('gang:requestGangPanel', function()
    local src = source
    local gangData = nil
    
    for gangIndex, gang in pairs(gangs) do
        for memberIndex, member in pairs(gang.members) do
            local memberId = type(member) == "table" and member.id or member
            if tonumber(memberId) == tonumber(src) then
                gangData = gang
                break
            end
        end
        if gangData then break end
    end
    
    if gangData then
        -- Adicionar informações reais dos membros
        local membersWithInfo = {}
        for _, memberId in pairs(gangData.members) do
            local memberName = GetPlayerName(memberId)
            if memberName then
                table.insert(membersWithInfo, {
                    id = memberId,
                    name = memberName,
                    role = (memberId == gangData.owner) and "Dono" or "Membro",
                    lastLogin = "Online"
                })
            end
        end
        
        -- Criar uma cópia da gangue para não modificar a original
        local gangDataCopy = {
            name = gangData.name,
            owner = gangData.owner,
            members = membersWithInfo
        }
        
        TriggerClientEvent('gang:openPanel', src, gangDataCopy)
        
        -- Enviar atualização de membros com ID do jogador atual
        TriggerClientEvent('gang:updateMembers', src, membersWithInfo, src)
        
        -- Enviar dados da gangue para o sistema de nomes
        TriggerClientEvent('gang:setPlayerGang', src, {
            name = gangData.name,
            owner = gangData.owner
        })
        
        -- Enviar jogadores próximos da gangue
        local gangMembers = {}
        for _, member in pairs(gangData.members) do
            local memberId = type(member) == "table" and member.id or member
            local memberName = GetPlayerName(memberId)
            if memberName and memberId ~= src then
                table.insert(gangMembers, {
                    id = memberId,
                    name = memberName,
                    role = (memberId == gangData.owner) and "Dono" or "Membro"
                })
            end
        end
        TriggerClientEvent('gang:updateNearbyPlayers', src, gangMembers)
    else
        -- Se não está em gangue, abrir painel de criação
        TriggerClientEvent('gang:openCreateOrgBox', src)
    end
end)

-- Ao criar uma gangue, salvar no banco
RegisterServerEvent('gang:createGang')
AddEventHandler('gang:createGang', function(gangName)
    local src = source
    for _, gang in pairs(gangs) do
        if gang.name:lower() == gangName:lower() then
            TriggerClientEvent('gang:createResult', src, false, 'Já existe uma gangue com esse nome!')
            return
        end
    end
    local gangData = {
        name = gangName,
        owner = src,
        members = {src}
    }
    table.insert(gangs, gangData)
    oxmysql:execute('INSERT INTO gangs (name, data) VALUES (?, ?)', {
        gangName, json.encode(gangData)
    })
    
    -- Adicionar informações reais do dono
    local ownerName = GetPlayerName(src)
    if ownerName then
        local gangDataCopy = {
            name = gangData.name,
            owner = gangData.owner,
            members = {{
                id = src,
                name = ownerName,
                role = "Dono",
                lastLogin = "Online"
            }}
        }
        TriggerClientEvent('gang:createResult', src, true, 'Gangue criada com sucesso!', gangDataCopy)
    else
        TriggerClientEvent('gang:createResult', src, true, 'Gangue criada com sucesso!', gangData)
    end
end) 

-- Enviar convite para jogador
RegisterServerEvent('gang:inviteMember')
AddEventHandler('gang:inviteMember', function(playerId)
    local src = source
    local targetPlayer = tonumber(playerId)
    
    if not targetPlayer then
        TriggerClientEvent('gang:showMessage', src, 'ID inválido!')
        return
    end
    
    -- Verificar se o jogador existe usando a lógica do framework
    local targetPlayerName = GetPlayerName(targetPlayer)
    
    if not targetPlayerName then
        TriggerClientEvent('gang:showMessage', src, 'Jogador não encontrado!')
        return
    end
    
    -- Encontrar a gangue do jogador que está convidando
    local playerGang = nil
    for _, gang in pairs(gangs) do
        for _, member in pairs(gang.members) do
            local memberId = type(member) == "table" and member.id or member
            if tonumber(memberId) == tonumber(src) then
                playerGang = gang
                break
            end
        end
        if playerGang then break end
    end
    
    if not playerGang then
        TriggerClientEvent('gang:showMessage', src, 'Você não está em uma gangue!')
        return
    end
    
    -- Verificar se o jogador já está na gangue
    for _, member in pairs(playerGang.members) do
        local memberId = type(member) == "table" and member.id or member
        if tonumber(memberId) == tonumber(targetPlayer) then
            TriggerClientEvent('gang:showMessage', src, 'Jogador já está na gangue!')
            return
        end
    end
    
    -- Enviar convite
    pendingInvites[targetPlayer] = {gangId = playerGang.name, gangName = playerGang.name}
    TriggerClientEvent('gang:receiveInvite', targetPlayer, playerGang.name, playerGang.name)
    TriggerClientEvent('gang:showMessage', src, 'Convite enviado para ' .. targetPlayerName .. '!')
end)

-- Armazenar convite temporariamente
RegisterServerEvent('gang:storeInvite')
AddEventHandler('gang:storeInvite', function(gangId)
    local src = source
    storedInvites[src] = gangId
end)

-- Aceitar convite (versão simplificada)
RegisterServerEvent('gang:acceptInvite')
AddEventHandler('gang:acceptInvite', function(gangId)
    local src = source
    
    -- Se gangId é 'stored', usar o convite armazenado
    if gangId == 'stored' then
        gangId = storedInvites[src]
        if not gangId then
            TriggerClientEvent('gang:showMessage', src, 'Nenhum convite pendente!')
            return
        end
    end
    
    if not pendingInvites[src] or pendingInvites[src].gangId ~= gangId then
        TriggerClientEvent('gang:showMessage', src, 'Convite inválido!')
        return
    end
    
    -- Encontrar a gangue
    local gang = nil
    for _, g in pairs(gangs) do
        if g.name == gangId then
            gang = g
            break
        end
    end
    
    if not gang then
        TriggerClientEvent('gang:showMessage', src, 'Gangue não encontrada!')
        return
    end
    
    -- Adicionar membro
    table.insert(gang.members, src)
    pendingInvites[src] = nil
    storedInvites[src] = nil
    
    -- Atualizar banco de dados
    oxmysql:execute('UPDATE gangs SET data = ? WHERE name = ?', {
        json.encode(gang), gang.name
    })
    
    TriggerClientEvent('gang:showMessage', src, 'Você entrou na gangue ' .. gang.name .. '!')
    
    -- Atualizar painel para todos os membros da gangue
    for _, member in pairs(gang.members) do
        local membersWithInfo = {}
        for _, memberId in pairs(gang.members) do
            local memberName = GetPlayerName(memberId)
            if memberName then
                table.insert(membersWithInfo, {
                    id = memberId,
                    name = memberName,
                    role = (memberId == gang.owner) and "Dono" or "Membro",
                    lastLogin = "Online"
                })
            end
        end
        TriggerClientEvent('gang:updateMembers', member, membersWithInfo, member)
        
        -- Se for o jogador que aceitou o convite, abrir o painel para ele
        if member == src then
            local gangDataCopy = {
                name = gang.name,
                owner = gang.owner,
                members = membersWithInfo
            }
            TriggerClientEvent('gang:openPanel', src, gangDataCopy)
            
            -- Enviar dados da gangue para o sistema de nomes
            TriggerClientEvent('gang:setPlayerGang', src, {
                name = gang.name,
                owner = gang.owner
            })
            
            -- Enviar jogadores próximos da gangue
            local gangMembers = {}
            for _, member in pairs(gang.members) do
                local memberId = type(member) == "table" and member.id or member
                local memberName = GetPlayerName(memberId)
                if memberName and memberId ~= src then
                    table.insert(gangMembers, {
                        id = memberId,
                        name = memberName,
                        role = (memberId == gang.owner) and "Dono" or "Membro"
                    })
                end
            end
            TriggerClientEvent('gang:updateNearbyPlayers', src, gangMembers)
        else
            -- Notificar outros membros sobre o novo membro
            TriggerClientEvent('gang:memberJoined', member, src)
        end
    end
end)

-- Rejeitar convite (versão simplificada)
RegisterServerEvent('gang:rejectInvite')
AddEventHandler('gang:rejectInvite', function(gangId)
    local src = source
    
    -- Se gangId é 'stored', usar o convite armazenado
    if gangId == 'stored' then
        gangId = storedInvites[src]
        if not gangId then
            TriggerClientEvent('gang:showMessage', src, 'Nenhum convite pendente!')
            return
        end
    end
    
    pendingInvites[src] = nil
    storedInvites[src] = nil
    TriggerClientEvent('gang:showMessage', src, 'Convite rejeitado!')
end)

-- Remover membro
RegisterServerEvent('gang:removeMember')
AddEventHandler('gang:removeMember', function(memberId)
    local src = source
    
    -- Encontrar a gangue do jogador
    local playerGang = nil
    for _, gang in pairs(gangs) do
        for _, member in pairs(gang.members) do
            local memberId = type(member) == "table" and member.id or member
            if tonumber(memberId) == tonumber(src) then
                playerGang = gang
                break
            end
        end
        if playerGang then break end
    end
    
    if not playerGang then
        TriggerClientEvent('gang:showMessage', src, 'Você não está em uma gangue!')
        return
    end
    
    -- Verificar se é o dono da gangue
    local playerGangOwnerId = type(playerGang.owner) == "table" and playerGang.owner.id or playerGang.owner
    if tonumber(playerGangOwnerId) ~= tonumber(src) then
        TriggerClientEvent('gang:showMessage', src, 'Apenas o dono pode remover membros!')
        return
    end
    
    -- Remover membro
    for i, member in ipairs(playerGang.members) do
        local currentMemberId = type(member) == "table" and member.id or member
        if tonumber(currentMemberId) == tonumber(memberId) then
            table.remove(playerGang.members, i)
            break
        end
    end
    
    -- Atualizar banco de dados
    oxmysql:execute('UPDATE gangs SET data = ? WHERE name = ?', {
        json.encode(playerGang), playerGang.name
    })
    
    TriggerClientEvent('gang:showMessage', src, 'Membro removido!')
    
    -- Atualizar painel para todos os membros da gangue
    for _, member in pairs(playerGang.members) do
        local membersWithInfo = {}
        for _, memberId in pairs(playerGang.members) do
            local memberName = GetPlayerName(memberId)
            if memberName then
                table.insert(membersWithInfo, {
                    id = memberId,
                    name = memberName,
                    role = (memberId == playerGang.owner) and "Dono" or "Membro",
                    lastLogin = "Online"
                })
            end
        end
        TriggerClientEvent('gang:updateMembers', member, membersWithInfo, member)
        
        -- Notificar sobre a remoção do membro
        TriggerClientEvent('gang:memberLeft', member, memberId)
    end
end) 

-- Sair da gangue
RegisterServerEvent('gang:leaveGang')
AddEventHandler('gang:leaveGang', function()
    local src = source
    
    -- Encontrar a gangue do jogador
    local playerGang = nil
    local playerIndex = nil
    for gangIndex, gang in pairs(gangs) do
        for memberIndex, member in pairs(gang.members) do
            local memberId = type(member) == "table" and member.id or member
            if tonumber(memberId) == tonumber(src) then
                playerGang = gang
                playerIndex = memberIndex
                break
            end
        end
        if playerGang then break end
    end
    
    if not playerGang then
        TriggerClientEvent('gang:showMessage', src, 'Você não está em uma gangue!', 'error')
        return
    end
    
    -- Verificar se é o dono da gangue
    if tonumber(playerGang.owner) == tonumber(src) then
        TriggerClientEvent('gang:showMessage', src, 'O dono não pode sair da gangue! Transfira a liderança primeiro.', 'warning')
        return
    end
    
    -- Remover jogador da gangue
    table.remove(playerGang.members, playerIndex)
    
    -- Atualizar banco de dados
    oxmysql:execute('UPDATE gangs SET data = ? WHERE name = ?', {
        json.encode(playerGang), playerGang.name
    })
    
    TriggerClientEvent('gang:showMessage', src, 'Você saiu da gangue ' .. playerGang.name .. '!', 'info')
    
    -- Limpar dados da gangue do sistema de nomes
    TriggerClientEvent('gang:clearPlayerGang', src)
    
    -- Fechar painel para o jogador que saiu
    TriggerClientEvent('gang:openCreateOrgBox', src)
    
    -- Atualizar painel para todos os membros restantes da gangue
    for _, member in pairs(playerGang.members) do
        local membersWithInfo = {}
        for _, memberId in pairs(playerGang.members) do
            local memberName = GetPlayerName(memberId)
            if memberName then
                table.insert(membersWithInfo, {
                    id = memberId,
                    name = memberName,
                    role = (memberId == playerGang.owner) and "Dono" or "Membro",
                    lastLogin = "Online"
                })
            end
        end
        TriggerClientEvent('gang:updateMembers', member, membersWithInfo, member)
        
        -- Notificar sobre a saída do membro
        TriggerClientEvent('gang:memberLeft', member, src)
    end
end) 

-- Função para mudar cargo de membro
RegisterServerEvent('gang:changeMemberCargo')
AddEventHandler('gang:changeMemberCargo', function(memberId, newCargo)
    local src = source
    print('[DEBUG] Mudança de cargo solicitada - Jogador:', src, 'Membro:', memberId, 'Novo cargo:', newCargo)
    
    -- Encontrar a gangue do jogador que está solicitando
    local playerGang = nil
    local isOwner = false
    
    for _, gang in pairs(gangs) do
        for _, member in pairs(gang.members) do
            local memberIdCheck = type(member) == "table" and member.id or member
            if tonumber(memberIdCheck) == tonumber(src) then
                playerGang = gang
                -- Verificar se é o dono
                if tonumber(gang.owner) == tonumber(src) then
                    isOwner = true
                end
                break
            end
        end
        if playerGang then break end
    end
    
    if not playerGang then
        TriggerClientEvent('gang:showMessage', src, 'Você não está em uma gangue!', 'error')
        return
    end
    
    if not isOwner then
        TriggerClientEvent('gang:showMessage', src, 'Apenas o dono pode alterar cargos!', 'error')
        return
    end
    
    -- Verificar se o membro está na mesma gangue
    local targetMemberFound = false
    for _, member in pairs(playerGang.members) do
        local memberIdCheck = type(member) == "table" and member.id or member
        if tonumber(memberIdCheck) == tonumber(memberId) then
            targetMemberFound = true
            break
        end
    end
    
    if not targetMemberFound then
        TriggerClientEvent('gang:showMessage', src, 'Membro não encontrado na gangue!', 'error')
        return
    end
    
    -- Não permitir mudar cargo do próprio dono
    if tonumber(memberId) == tonumber(playerGang.owner) then
        TriggerClientEvent('gang:showMessage', src, 'Não é possível alterar o cargo do dono!', 'error')
        return
    end
    
    -- Atualizar cargo do membro na gangue
    print('[DEBUG] Membros antes da atualização:')
    for i, member in pairs(playerGang.members) do
        local memberIdCheck = type(member) == "table" and member.id or member
        print('[DEBUG] Membro', i, ':', memberIdCheck, 'Tipo:', type(member))
    end
    
    for memberIndex, member in pairs(playerGang.members) do
        local memberIdCheck = type(member) == "table" and member.id or member
        if tonumber(memberIdCheck) == tonumber(memberId) then
            print('[DEBUG] Encontrado membro para atualizar:', memberIdCheck)
            -- Atualizar o cargo
            if type(member) == "table" then
                member.role = newCargo
                print('[DEBUG] Cargo atualizado para:', member.role)
            else
                -- Se member é apenas um ID, converter para tabela
                playerGang.members[memberIndex] = {
                    id = member,
                    role = newCargo
                }
                print('[DEBUG] Membro convertido para tabela com cargo:', newCargo)
            end
            break
        end
    end
    
    print('[DEBUG] Membros após atualização:')
    for i, member in pairs(playerGang.members) do
        local memberIdCheck = type(member) == "table" and member.id or member
        print('[DEBUG] Membro', i, ':', memberIdCheck, 'Tipo:', type(member))
    end
    
    -- Atualizar banco de dados
    oxmysql:execute('UPDATE gangs SET data = ? WHERE name = ?', {
        json.encode(playerGang), playerGang.name
    })
    
    -- Notificar sucesso
    TriggerClientEvent('gang:showMessage', src, 'Cargo alterado com sucesso!', 'success')
    
    -- Atualizar painel para todos os membros da gangue
    local membersWithInfo = {}
    for _, memberData in pairs(playerGang.members) do
        local memberDataId = type(memberData) == "table" and memberData.id or memberData
        local memberDataName = GetPlayerName(memberDataId)
        if memberDataName then
            local memberRole = "Membro"
            if memberDataId == playerGang.owner then
                memberRole = "Dono"
            elseif type(memberData) == "table" and memberData.role then
                memberRole = memberData.role
            end
            
            table.insert(membersWithInfo, {
                id = memberDataId,
                name = memberDataName,
                role = memberRole,
                lastLogin = "Online"
            })
        end
    end
    
    -- Enviar atualização para todos os membros da gangue
    for _, member in pairs(playerGang.members) do
        local memberIdCheck = type(member) == "table" and member.id or member
        if GetPlayerName(memberIdCheck) then
            TriggerClientEvent('gang:updateMembers', memberIdCheck, membersWithInfo, memberIdCheck)
            print('[DEBUG] Enviando atualização para membro:', memberIdCheck)
        end
    end
    
    print('[DEBUG] Cargo alterado com sucesso para:', newCargo)
    print('[DEBUG] Total de membros na lista:', #membersWithInfo)
end)

-- Sistema para jogadores próximos da mesma gangue
RegisterServerEvent('gang:requestNearbyPlayers')
AddEventHandler('gang:requestNearbyPlayers', function()
    local src = source
    
    -- Encontrar a gangue do jogador
    local playerGang = nil
    for _, gang in pairs(gangs) do
        for _, member in pairs(gang.members) do
            local memberId = type(member) == "table" and member.id or member
            if tonumber(memberId) == tonumber(src) then
                playerGang = gang
                break
            end
        end
        if playerGang then break end
    end
    
    if playerGang then
        -- Encontrar todos os jogadores da mesma gangue
        local gangMembers = {}
        for _, member in pairs(playerGang.members) do
            local memberId = type(member) == "table" and member.id or member
            local memberName = GetPlayerName(memberId)
            if memberName and memberId ~= src then -- Não incluir o próprio jogador
                table.insert(gangMembers, {
                    id = memberId,
                    name = memberName,
                    role = (memberId == playerGang.owner) and "Dono" or "Membro"
                })
            end
        end

        
        -- Enviar lista de jogadores da gangue para o client
        TriggerClientEvent('gang:updateNearbyPlayers', src, gangMembers)
        
        -- Enviar dados da gangue para o client
        TriggerClientEvent('gang:setPlayerGang', src, {
            name = playerGang.name,
            owner = playerGang.owner
        })
    else
        -- Se não está em gangue, limpar dados
        TriggerClientEvent('gang:clearPlayerGang', src)
    end
end)

-- Thread para atualizar membros automaticamente
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3000) -- Atualizar a cada 3 segundos
        
        -- Atualizar membros para todos os jogadores em gangues
        for _, gang in pairs(gangs) do
            for _, member in pairs(gang.members) do
                local memberId = type(member) == "table" and member.id or member
                if GetPlayerName(memberId) then -- Se o jogador está online
                    TriggerClientEvent('gang:requestNearbyPlayers', memberId)
                end
            end
        end
    end
end)

-- Proteção adicional: Bloquear dano entre jogadores da mesma gangue
AddEventHandler('playerDamage', function(victim, attacker, damage, weapon)
    if victim and attacker and victim ~= attacker then
        print('[DEBUG] Player damage detectado - Vítima:', victim, 'Atacante:', attacker)
        
        -- Verificar se ambos estão na mesma gangue
        local victimGang = nil
        local attackerGang = nil
        
        for _, gang in pairs(gangs) do
            for _, member in pairs(gang.members) do
                local memberId = type(member) == "table" and member.id or member
                if tonumber(memberId) == tonumber(victim) then
                    victimGang = gang
                    print('[DEBUG] Vítima encontrada na gangue:', gang.name)
                end
                if tonumber(memberId) == tonumber(attacker) then
                    attackerGang = gang
                    print('[DEBUG] Atacante encontrado na gangue:', gang.name)
                end
            end
        end
        
        -- Se ambos estão na mesma gangue, cancelar o dano
        if victimGang and attackerGang and victimGang.name == attackerGang.name then
            print('[DEBUG] Player damage bloqueado entre membros da gangue:', victimGang.name)
            CancelEvent()
            -- Notificar o atacante
            TriggerClientEvent('gang:showMessage', attacker, 'Você não pode atacar membros da sua gangue!', 'warning')
            return
        end
    end
end)

-- Proteção adicional: Bloquear dano de armas entre membros da gangue
AddEventHandler('weaponDamageEvent', function(source, data)
    local attacker = source
    local victim = data.hitEntity
    
    if victim and IsPedAPlayer(victim) then
        local victimId = NetworkGetPlayerIndexFromPed(victim)
        if victimId and victimId ~= -1 then
            local victimSrc = GetPlayerServerId(victimId)
            
            print('[DEBUG] Weapon damage detectado - Vítima:', victimSrc, 'Atacante:', attacker)
            
            -- Verificar se ambos estão na mesma gangue
            local victimGang = nil
            local attackerGang = nil
            
            for _, gang in pairs(gangs) do
                for _, member in pairs(gang.members) do
                    local memberId = type(member) == "table" and member.id or member
                    if tonumber(memberId) == tonumber(victimSrc) then
                        victimGang = gang
                        print('[DEBUG] Vítima encontrada na gangue:', gang.name)
                    end
                    if tonumber(memberId) == tonumber(attacker) then
                        attackerGang = gang
                        print('[DEBUG] Atacante encontrado na gangue:', gang.name)
                    end
                end
            end
            
            -- Se ambos estão na mesma gangue, cancelar o dano
            if victimGang and attackerGang and victimGang.name == attackerGang.name then
                print('[DEBUG] Weapon damage bloqueado entre membros da gangue:', victimGang.name)
                CancelEvent()
                -- Restaurar vida da vítima
                TriggerClientEvent('gang:restoreHealth', victimSrc)
                -- Notificar o atacante
                TriggerClientEvent('gang:showMessage', attacker, 'Você não pode atacar membros da sua gangue!', 'warning')
                return
            end
        end
    end
end)

-- Proteção adicional: Bloquear qualquer tipo de dano entre membros da gangue
AddEventHandler('entityDamage', function(victim, attacker, damage, weapon)
    if victim and attacker and IsPedAPlayer(victim) and IsPedAPlayer(attacker) then
        local victimId = NetworkGetPlayerIndexFromPed(victim)
        local attackerId = NetworkGetPlayerIndexFromPed(attacker)
        
        if victimId and attackerId and victimId ~= -1 and attackerId ~= -1 then
            local victimSrc = GetPlayerServerId(victimId)
            local attackerSrc = GetPlayerServerId(attackerId)
            
            print('[DEBUG] Entity damage detectado - Vítima:', victimSrc, 'Atacante:', attackerSrc)
            
            -- Verificar se ambos estão na mesma gangue
            local victimGang = nil
            local attackerGang = nil
            
            for _, gang in pairs(gangs) do
                for _, member in pairs(gang.members) do
                    local memberId = type(member) == "table" and member.id or member
                    if tonumber(memberId) == tonumber(victimSrc) then
                        victimGang = gang
                        print('[DEBUG] Vítima encontrada na gangue:', gang.name)
                    end
                    if tonumber(memberId) == tonumber(attackerSrc) then
                        attackerGang = gang
                        print('[DEBUG] Atacante encontrado na gangue:', gang.name)
                    end
                end
            end
            
            -- Se ambos estão na mesma gangue, cancelar o dano
            if victimGang and attackerGang and victimGang.name == attackerGang.name then
                print('[DEBUG] Entity damage bloqueado entre membros da gangue:', victimGang.name)
                CancelEvent()
                -- Restaurar vida da vítima
                TriggerClientEvent('gang:restoreHealth', victimSrc)
                -- Notificar o atacante
                TriggerClientEvent('gang:showMessage', attackerSrc, 'Você não pode atacar membros da sua gangue!', 'warning')
                return
            end
        end
    end
end)

-- Proteção adicional: Bloquear eventos de dano de rede entre membros da gangue
AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        local victim = args[1]
        local attacker = args[2]
        
        if victim and attacker and IsPedAPlayer(victim) and IsPedAPlayer(attacker) then
            local victimId = NetworkGetPlayerIndexFromPed(victim)
            local attackerId = NetworkGetPlayerIndexFromPed(attacker)
            
            if victimId and attackerId and victimId ~= -1 and attackerId ~= -1 then
                local victimSrc = GetPlayerServerId(victimId)
                local attackerSrc = GetPlayerServerId(attackerId)
                
                print('[DEBUG] Network damage detectado - Vítima:', victimSrc, 'Atacante:', attackerSrc)
                
                -- Verificar se ambos estão na mesma gangue
                local victimGang = nil
                local attackerGang = nil
                
                for _, gang in pairs(gangs) do
                    for _, member in pairs(gang.members) do
                        local memberId = type(member) == "table" and member.id or member
                        if tonumber(memberId) == tonumber(victimSrc) then
                            victimGang = gang
                            print('[DEBUG] Vítima encontrada na gangue:', gang.name)
                        end
                        if tonumber(memberId) == tonumber(attackerSrc) then
                            attackerGang = gang
                            print('[DEBUG] Atacante encontrado na gangue:', gang.name)
                        end
                    end
                end
                
                -- Se ambos estão na mesma gangue, cancelar o dano
                if victimGang and attackerGang and victimGang.name == attackerGang.name then
                    print('[DEBUG] Network damage bloqueado entre membros da gangue:', victimGang.name)
                    CancelEvent()
                    -- Restaurar vida da vítima
                    TriggerClientEvent('gang:restoreHealth', victimSrc)
                    -- Notificar o atacante
                    TriggerClientEvent('gang:showMessage', attackerSrc, 'Você não pode atacar membros da sua gangue!', 'warning')
                    return
                end
            end
        end
    end
end)

-- Proteção adicional: Desabilitar dano entre membros da gangue no servidor
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) -- Verificar a cada segundo
        
        for _, gang in pairs(gangs) do
            for _, member in pairs(gang.members) do
                local memberId = type(member) == "table" and member.id or member
                if GetPlayerName(memberId) then -- Se o jogador está online
                    -- Enviar comando para desabilitar dano entre membros
                    TriggerClientEvent('gang:disableDamageBetweenMembers', memberId, gang.members)
                end
            end
        end
    end
end)

-- Proteção adicional: Bloquear dano usando SetEntityHealth
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100) -- Verificar a cada 100ms
        
        for _, gang in pairs(gangs) do
            for _, member in pairs(gang.members) do
                local memberId = type(member) == "table" and member.id or member
                if GetPlayerName(memberId) then -- Se o jogador está online
                    -- Enviar comando para restaurar vida no cliente
                    TriggerClientEvent('gang:restoreHealth', memberId)
                end
            end
        end
    end
end)

-- Proteção adicional: Manter godmode sempre ativo no servidor
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100) -- Verificar a cada 100ms
        
        for _, gang in pairs(gangs) do
            for _, member in pairs(gang.members) do
                local memberId = type(member) == "table" and member.id or member
                if GetPlayerName(memberId) then -- Se o jogador está online
                    -- Enviar comando para tornar invencível no cliente
                    TriggerClientEvent('gang:setInvincible', memberId, true)
                    
                    -- Enviar comando para restaurar vida no cliente
                    TriggerClientEvent('gang:restoreHealth', memberId)
                end
            end
        end
    end
end)

-- Proteção adicional: Bloquear dano usando baseevents:onPlayerDamaged
RegisterNetEvent('baseevents:onPlayerDamaged')
AddEventHandler('baseevents:onPlayerDamaged', function(attacker, weapon, bodypart)
    local victim = source
    
    if victim and attacker and victim ~= attacker then
        print('[DEBUG] Baseevents damage detectado - Vítima:', victim, 'Atacante:', attacker)
        
        -- Verificar se ambos estão na mesma gangue
        local victimGang = nil
        local attackerGang = nil
        
        for _, gang in pairs(gangs) do
            for _, member in pairs(gang.members) do
                local memberId = type(member) == "table" and member.id or member
                if tonumber(memberId) == tonumber(victim) then
                    victimGang = gang
                    print('[DEBUG] Vítima encontrada na gangue:', gang.name)
                end
                if tonumber(memberId) == tonumber(attacker) then
                    attackerGang = gang
                    print('[DEBUG] Atacante encontrado na gangue:', gang.name)
                end
            end
        end
        
        -- Se ambos estão na mesma gangue, cancelar o dano
        if victimGang and attackerGang and victimGang.name == attackerGang.name then
            print('[DEBUG] Baseevents damage bloqueado entre membros da gangue:', victimGang.name)
            -- Restaurar vida da vítima via cliente
            TriggerClientEvent('gang:restoreHealth', victim)
            -- Notificar o atacante
            TriggerClientEvent('gang:showMessage', attacker, 'Você não pode atacar membros da sua gangue!', 'warning')
            return
        end
    end
end)

-- Proteção adicional: Bloquear morte entre membros da gangue
AddEventHandler('playerDeath', function(victim, attacker, weapon)
    if victim and attacker and victim ~= attacker then
        print('[DEBUG] Player death detectado - Vítima:', victim, 'Atacante:', attacker)
        
        -- Verificar se ambos estão na mesma gangue
        local victimGang = nil
        local attackerGang = nil
        
        for _, gang in pairs(gangs) do
            for _, member in pairs(gang.members) do
                local memberId = type(member) == "table" and member.id or member
                if tonumber(memberId) == tonumber(victim) then
                    victimGang = gang
                    print('[DEBUG] Vítima encontrada na gangue:', gang.name)
                end
                if tonumber(memberId) == tonumber(attacker) then
                    attackerGang = gang
                    print('[DEBUG] Atacante encontrado na gangue:', gang.name)
                end
            end
        end
        
        -- Se ambos estão na mesma gangue, cancelar a morte
        if victimGang and attackerGang and victimGang.name == attackerGang.name then
            print('[DEBUG] Player death bloqueado entre membros da gangue:', victimGang.name)
            CancelEvent()
            -- Reviver a vítima via cliente
            TriggerClientEvent('gang:revivePlayer', victim)
            -- Notificar o atacante
            TriggerClientEvent('gang:showMessage', attacker, 'Você não pode matar membros da sua gangue!', 'warning')
            return
        end
    end
end) 