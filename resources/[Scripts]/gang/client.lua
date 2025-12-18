-- client.lua

RegisterNUICallback('createGang', function(data, cb)
    local gangName = data.name
    if not gangName or gangName == '' then
        cb({success = false, message = 'Nome inválido'})
        return
    end
    TriggerServerEvent('gang:createGang', gangName)
    cb({success = true})
end)

RegisterNUICallback('closeGangPanel', function(data, cb)
    SetNuiFocus(false, false)
    cb({success = true})
end)

RegisterNetEvent('gang:openPanel', function(gangData)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openGangPanel',
        gang = gangData
    })
end)

RegisterNetEvent('gang:createResult', function(success, message, gangData)
    if success then
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'openGangPanel',
            gang = gangData
        })
        -- Mostrar notificação de sucesso
        SendNUIMessage({
            action = 'showNotification',
            message = message,
            type = 'success'
        })
    else
        -- Mesmo com erro, permitir abrir o painel de criação
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'openCreateOrgBox'
        })
        SendNUIMessage({
            action = 'showNotification',
            message = message,
            type = 'error'
        })
    end
end)

RegisterNUICallback('inviteMember', function(data, cb)
    local playerId = data.playerId
    if not playerId or playerId == '' then
        cb({success = false, message = 'ID inválido'})
        return
    end
    TriggerServerEvent('gang:inviteMember', playerId)
    cb({success = true})
end)

RegisterNUICallback('removeMember', function(data, cb)
    local memberId = data.memberId
    if not memberId then
        cb({success = false, message = 'ID inválido'})
        return
    end
    TriggerServerEvent('gang:removeMember', memberId)
    cb({success = true})
end)

RegisterNUICallback('leaveGang', function(data, cb)
    TriggerServerEvent('gang:leaveGang')
    cb({success = true})
end)

RegisterNUICallback('changeMemberCargo', function(data, cb)
    local memberId = data.memberId
    local newCargo = data.newCargo
    
    if not memberId or not newCargo then
        cb({success = false, message = 'Dados inválidos'})
        return
    end
    
    TriggerServerEvent('gang:changeMemberCargo', memberId, newCargo)
    cb({success = true})
end)

-- Versão simplificada sem mythic_progbar
RegisterNetEvent('gang:receiveInvite', function(gangName, gangId)
    -- Mostrar notificação para o convite
    SendNUIMessage({
        action = 'showNotification',
        message = 'Você recebeu um convite para a gangue ' .. gangName .. '! Digite /aceitar_convite para aceitar ou /rejeitar_convite para rejeitar.',
        type = 'info',
        title = 'Convite de Gangue'
    })
    -- Armazenar o convite temporariamente
    TriggerServerEvent('gang:storeInvite', gangId)
end)

RegisterCommand('aceitar_convite', function()
    TriggerServerEvent('gang:acceptInvite', 'stored')
end)

RegisterCommand('rejeitar_convite', function()
    TriggerServerEvent('gang:rejectInvite', 'stored')
end)

-- Comando para abrir painel da gangue após aceitar convite
RegisterCommand('abrir_painel', function()
    TriggerServerEvent('gang:requestGangPanel')
end)

RegisterNetEvent('gang:updateMembers', function(members, currentPlayerId)
    SendNUIMessage({
        action = 'updateMembers',
        members = members,
        currentPlayerId = currentPlayerId
    })
end)

RegisterNetEvent('gang:showMessage', function(message, type)
    SendNUIMessage({
        action = 'showNotification',
        message = message,
        type = type or 'info'
    })
end)

RegisterNetEvent('gang:openCreateOrgBox', function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openCreateOrgBox'
    })
    -- Limpar dados da gangue quando abrir painel de criação
    TriggerEvent('gang:clearPlayerGang')
end)

-- Exemplo de comando para abrir o menu de criação (pode ser alterado para seu sistema de permissão)
RegisterCommand('criar_gangue', function()
    SetNuiFocus(true, true)
    SendNUIMessage({action = 'openCreateOrgBox'})
end)

RegisterCommand('painel_gangue', function()
    TriggerServerEvent('gang:requestGangPanel')
end) 

-- Listener para fechar painel com ESC
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 322) then -- ESC key
            SetNuiFocus(false, false)
            SendNUIMessage({
                action = 'closeGangPanel'
            })
        end
    end
end) 

-- Sistema para mostrar nomes de jogadores da mesma gangue
local playerGang = nil
local nearbyPlayers = {}
local gangMemberIds = {} -- Armazenar IDs dos membros da gangue
local lastHealth = nil -- Para proteção contra dano

-- Função para obter a gangue do jogador atual
RegisterNetEvent('gang:setPlayerGang')
AddEventHandler('gang:setPlayerGang', function(gangData)
    playerGang = gangData

end)

-- Função para obter jogadores próximos da mesma gangue
RegisterNetEvent('gang:updateNearbyPlayers')
AddEventHandler('gang:updateNearbyPlayers', function(players)
    nearbyPlayers = players
    gangMemberIds = {}
    
    local playerServerId = GetPlayerServerId(PlayerId())
 
    
    -- Adicionar IDs dos membros da gangue
    for _, player in pairs(players) do
        -- NÃO incluir o próprio jogador
        if player.id ~= playerServerId then
            gangMemberIds[player.id] = true
           
        end
    end
end)

-- Thread para verificar membros da gangue em tempo real
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000) -- Verificar a cada 2 segundos
        
        if playerGang then
            TriggerServerEvent('gang:requestNearbyPlayers')
        end
    end
end)

-- Proteção real contra dano de membros da gangue (baseado no sistema de gangue que funciona)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        if not lastHealth then lastHealth = GetEntityHealth(ped) end
        local health = GetEntityHealth(ped)
        if health < lastHealth then
            -- Alguém te deu dano
            local attacker = GetPedSourceOfDamage and GetPedSourceOfDamage(ped) or 0
            if attacker and attacker ~= 0 then
                local attackerId = NetworkGetPlayerIndexFromPed(attacker)
                if attackerId and attackerId ~= -1 then
                    local attackerSrc = GetPlayerServerId(attackerId)
                    if gangMemberIds[attackerSrc] then
                        SetEntityHealth(ped, lastHealth)
                        print('[DEBUG] Dano bloqueado de membro da gangue:', attackerSrc)
                        -- Mostrar notificação
                        SendNUIMessage({
                            action = 'showNotification',
                            message = 'Você não pode ser ferido por membros da sua gangue!',
                            type = 'warning'
                        })
                    end
                end
            end
        end
        lastHealth = GetEntityHealth(ped)
    end
end)

-- Bloquear dano entre membros da gangue (client-side) - baseado no sistema que funciona
AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        local victim = args[1]
        local attacker = args[2]
        if victim and attacker then
            if victim == PlayerPedId() then
                local attackerId = NetworkGetPlayerIndexFromPed(attacker)
                if attackerId and attackerId ~= -1 then
                    local attackerSrc = GetPlayerServerId(attackerId)
                    if gangMemberIds[attackerSrc] then
                        print('[DEBUG] Evento de dano cancelado de membro:', attackerSrc)
                        CancelEvent()
                        -- Restaurar vida imediatamente
                        SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
                    end
                end
            end
        end
    end
end)

-- Proteção adicional: Bloquear ataques ativos contra membros da gangue
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if playerGang and next(gangMemberIds) then
            local playerPed = PlayerPedId()
            
            -- Verificar se está mirando em alguém
            local targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId())
            if targetPed and targetPed ~= 0 then
                local targetId = NetworkGetPlayerIndexFromPed(targetPed)
                if targetId and targetId ~= -1 then
                    local targetSrc = GetPlayerServerId(targetId)
                    if gangMemberIds[targetSrc] then
                        -- Cancelar a mira
                        ClearPedTasksImmediately(playerPed)
                        print('[DEBUG] Mira cancelada em membro da gangue:', targetSrc)
                        
                        -- Mostrar notificação
                        SendNUIMessage({
                            action = 'showNotification',
                            message = 'Você não pode mirar em membros da sua gangue!',
                            type = 'warning'
                        })
                    end
                end
            end
            
            -- Verificar se está atacando corpo a corpo
            if IsPedInMeleeCombat(playerPed) then
                local targetPed = GetMeleeTargetForPed(playerPed)
                if targetPed and targetPed ~= 0 then
                    local targetId = NetworkGetPlayerIndexFromPed(targetPed)
                    if targetId and targetId ~= -1 then
                        local targetSrc = GetPlayerServerId(targetId)
                        if gangMemberIds[targetSrc] then
                            -- Cancelar ataque corpo a corpo
                            ClearPedTasksImmediately(playerPed)
                            SetEntityHealth(targetPed, GetEntityMaxHealth(targetPed))
                            print('[DEBUG] Ataque corpo a corpo cancelado em membro da gangue:', targetSrc)
                            
                            -- Mostrar notificação
                            SendNUIMessage({
                                action = 'showNotification',
                                message = 'Você não pode atacar membros da sua gangue!',
                                type = 'warning'
                            })
                        end
                    end
                end
            end
        end
    end
end)

-- Godmode sempre ativo enquanto estiver em gangue (baseado no sistema que funciona)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local myId = PlayerId()
        local myPed = PlayerPedId()
        if playerGang then
            SetPlayerInvincible(myId, true)
            SetEntityInvincible(myPed, true)
           
        else
            SetPlayerInvincible(myId, false)
            SetEntityInvincible(myPed, false)
            
        end
    end
end)

-- Proteção adicional: Desabilitar dano entre membros da gangue
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if playerGang and next(gangMemberIds) then
            local playerPed = PlayerPedId()
            
            -- Desabilitar dano para membros da gangue
            for memberSrc, _ in pairs(gangMemberIds) do
                local memberId = GetPlayerFromServerId(memberSrc)
                if memberId and memberId ~= -1 then
                    local memberPed = GetPlayerPed(memberId)
                    if DoesEntityExist(memberPed) then
                        -- Desabilitar colisão entre membros
                        SetEntityNoCollisionEntity(playerPed, memberPed, true)
                        SetEntityNoCollisionEntity(memberPed, playerPed, true)
                        
                        -- Desabilitar dano entre membros
                        SetEntityCanBeDamaged(memberPed, false)
                        SetPedCanRagdoll(memberPed, false)
                    end
                end
            end
            
            -- Reabilitar dano para outros jogadores
            for i = 0, 255 do
                if NetworkIsPlayerActive(i) then
                    local otherPed = GetPlayerPed(i)
                    local otherSrc = GetPlayerServerId(i)
                    
                    if not gangMemberIds[otherSrc] and DoesEntityExist(otherPed) then
                        SetEntityNoCollisionEntity(playerPed, otherPed, false)
                        SetEntityCanBeDamaged(otherPed, true)
                        SetPedCanRagdoll(otherPed, true)
                    end
                end
            end
        end
    end
end)

-- Proteção adicional: Bloquear tiros em membros da gangue
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if playerGang and next(gangMemberIds) then
            local playerPed = PlayerPedId()
            
            -- Verificar se está atirando
            if IsPedShooting(playerPed) then
                local targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId())
                if targetPed and targetPed ~= 0 then
                    local targetId = NetworkGetPlayerIndexFromPed(targetPed)
                    if targetId and targetId ~= -1 then
                        local targetSrc = GetPlayerServerId(targetId)
                        if gangMemberIds[targetSrc] then
                            -- Cancelar o tiro
                            ClearPedTasksImmediately(playerPed)
                            SetEntityHealth(targetPed, GetEntityMaxHealth(targetPed))
                            print('[DEBUG] Tiro cancelado em membro da gangue:', targetSrc)
                            
                            -- Mostrar notificação
                            SendNUIMessage({
                                action = 'showNotification',
                                message = 'Você não pode atirar em membros da sua gangue!',
                                type = 'warning'
                            })
                        end
                    end
                end
            end
        end
    end
end)

-- Proteção adicional: Verificar se está sendo atacado por membros da gangue
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if playerGang and next(gangMemberIds) then
            local playerPed = PlayerPedId()
            
            -- Verificar se está sendo atacado
            if IsPedBeingStunned(playerPed, 0) or IsPedBeingStunned(playerPed, 1) then
                local attacker = GetPedSourceOfDamage(playerPed)
                if attacker and attacker ~= 0 then
                    local attackerId = NetworkGetPlayerIndexFromPed(attacker)
                    if attackerId and attackerId ~= -1 then
                        local attackerSrc = GetPlayerServerId(attackerId)
                        if gangMemberIds[attackerSrc] then
                            -- Restaurar vida e cancelar dano
                            SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
                            ClearPedTasksImmediately(playerPed)
                            print('[DEBUG] Ataque cancelado de membro da gangue:', attackerSrc)
                            
                            -- Mostrar notificação
                            SendNUIMessage({
                                action = 'showNotification',
                                message = 'Você não pode ser atacado por membros da sua gangue!',
                                type = 'warning'
                            })
                        end
                    end
                end
            end
        end
    end
end)

-- Proteção adicional: Verificar se está sendo atacado por veículos de membros da gangue
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if playerGang and next(gangMemberIds) then
            local playerPed = PlayerPedId()
            
            -- Verificar se está sendo atropelado
            if IsPedBeingStunned(playerPed, 0) then
                local vehicle = GetVehiclePedIsIn(playerPed, false)
                if vehicle and vehicle ~= 0 then
                    local driver = GetPedInVehicleSeat(vehicle, -1)
                    if driver and driver ~= 0 then
                        local driverId = NetworkGetPlayerIndexFromPed(driver)
                        if driverId and driverId ~= -1 then
                            local driverSrc = GetPlayerServerId(driverId)
                            if gangMemberIds[driverSrc] then
                                -- Restaurar vida e cancelar dano
                                SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
                                ClearPedTasksImmediately(playerPed)
                                print('[DEBUG] Atropelamento cancelado de membro da gangue:', driverSrc)
                                
                                -- Mostrar notificação
                                SendNUIMessage({
                                    action = 'showNotification',
                                    message = 'Você não pode ser atropelado por membros da sua gangue!',
                                    type = 'warning'
                                })
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Proteção adicional: Manter godmode sempre ativo quando em gangue
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100) -- Verificar a cada 100ms
        
        if playerGang then
            local myId = PlayerId()
            local myPed = PlayerPedId()
            
            -- Forçar godmode sempre ativo
            SetPlayerInvincible(myId, true)
            SetEntityInvincible(myPed, true)
            
            -- Restaurar vida se estiver danificado
            local health = GetEntityHealth(myPed)
            local maxHealth = GetEntityMaxHealth(myPed)
            if health < maxHealth then
                SetEntityHealth(myPed, maxHealth)
                print('[DEBUG] Vida restaurada forçadamente no cliente')
            end
        end
    end
end)

-- Proteção adicional: Bloquear morte entre membros da gangue
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if playerGang then
            local playerPed = PlayerPedId()
            
            -- Verificar se está morto
            if IsEntityDead(playerPed) then
                -- Verificar se foi morto por um membro da gangue
                local attacker = GetPedSourceOfDamage(playerPed)
                if attacker and attacker ~= 0 then
                    local attackerId = NetworkGetPlayerIndexFromPed(attacker)
                    if attackerId and attackerId ~= -1 then
                        local attackerSrc = GetPlayerServerId(attackerId)
                        if gangMemberIds[attackerSrc] then
                            -- Reviver imediatamente
                            NetworkResurrectLocalPlayer(GetEntityCoords(playerPed), GetEntityHeading(playerPed), true, false)
                            SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
                            ClearPedBloodDamage(playerPed)
                            ClearPedTasksImmediately(playerPed)
                            
                            print('[DEBUG] Morte cancelada de membro da gangue:', attackerSrc)
                            
                            -- Mostrar notificação
                            SendNUIMessage({
                                action = 'showNotification',
                                message = 'Você foi revivido! Membros da gangue não podem te matar!',
                                type = 'success'
                            })
                        end
                    end
                end
            end
        end
    end
end)

-- Evento para restaurar vida quando servidor detecta dano entre membros
RegisterNetEvent('gang:restoreHealth')
AddEventHandler('gang:restoreHealth', function()
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
    
end)

-- Evento para desabilitar dano entre membros da gangue
RegisterNetEvent('gang:disableDamageBetweenMembers')
AddEventHandler('gang:disableDamageBetweenMembers', function(gangMembers)
    local playerPed = PlayerPedId()
    local playerServerId = GetPlayerServerId(PlayerId())
    
    -- Criar tabela de IDs dos membros da gangue
    local memberIds = {}
    for _, member in pairs(gangMembers) do
        local memberId = type(member) == "table" and member.id or member
        if tonumber(memberId) ~= tonumber(playerServerId) then -- Não incluir o próprio jogador
            memberIds[memberId] = true
        end
    end
    
    -- Desabilitar dano para membros da gangue
    for memberId, _ in pairs(memberIds) do
        local memberPlayerId = GetPlayerFromServerId(memberId)
        if memberPlayerId and memberPlayerId ~= -1 then
            local memberPed = GetPlayerPed(memberPlayerId)
            if DoesEntityExist(memberPed) then
                -- Desabilitar colisão entre membros
                SetEntityNoCollisionEntity(playerPed, memberPed, true)
                SetEntityNoCollisionEntity(memberPed, playerPed, true)
                
                -- Desabilitar dano entre membros
                SetEntityCanBeDamaged(memberPed, false)
                SetPedCanRagdoll(memberPed, false)
                
              
            end
        end
    end
end)

-- Evento para tornar o jogador invencível
RegisterNetEvent('gang:setInvincible')
AddEventHandler('gang:setInvincible', function(invincible)
    local myId = PlayerId()
    local myPed = PlayerPedId()
    
    if invincible then
        SetPlayerInvincible(myId, true)
        SetEntityInvincible(myPed, true)
     
    else
        SetPlayerInvincible(myId, false)
        SetEntityInvincible(myPed, false)
      
    end
end)

-- Evento para reviver o jogador
RegisterNetEvent('gang:revivePlayer')
AddEventHandler('gang:revivePlayer', function()
    local playerPed = PlayerPedId()
    
    -- Reviver o jogador
    NetworkResurrectLocalPlayer(GetEntityCoords(playerPed), GetEntityHeading(playerPed), true, false)
    SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
    ClearPedBloodDamage(playerPed)
    ClearPedTasksImmediately(playerPed)
    
    print('[DEBUG] Jogador revivido pelo servidor')
    
    -- Mostrar notificação
    SendNUIMessage({
        action = 'showNotification',
        message = 'Você foi revivido! Membros da gangue não podem te matar!',
        type = 'success'
    })
end)

RegisterNetEvent('gang:clearPlayerGang')
AddEventHandler('gang:clearPlayerGang', function()
    playerGang = nil
    nearbyPlayers = {}
    gangMemberIds = {}
    lastHealth = nil
end)

-- Thread para desenhar nomes dos jogadores da mesma gangue
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if playerGang then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local playerServerId = GetPlayerServerId(PlayerId())
            
            for _, nearbyPlayer in pairs(nearbyPlayers) do
                -- NÃO mostrar nome do próprio jogador
                if nearbyPlayer.id ~= playerServerId then
                    local targetPed = GetPlayerPed(GetPlayerFromServerId(nearbyPlayer.id))
                    if DoesEntityExist(targetPed) and targetPed ~= playerPed then
                        local targetCoords = GetEntityCoords(targetPed)
                        local distance = #(playerCoords - targetCoords)
                        
                        -- Mostrar nome sempre (sem limite de distância)
                        if distance < 100.0 then -- Apenas para não sobrecarregar muito longe
                            local x, y, z = table.unpack(targetCoords)
                            z = z + 1.0 -- Posição acima da cabeça
                            
                            -- Cor baseada no cargo
                            local r, g, b = 255, 255, 255 -- Branco padrão
                            if nearbyPlayer.role == "Dono" then
                                r, g, b = 255, 215, 0 -- Dourado para dono
                            elseif nearbyPlayer.role == "Membro" then
                                r, g, b = 0, 255, 0 -- Verde para membros
                            end
                            
                            -- Desenhar texto 3D
                            SetDrawOrigin(x, y, z, 0)
                            SetTextFont(4)
                            SetTextProportional(1)
                            SetTextScale(0.0, 0.35)
                            SetTextColour(r, g, b, 255)
                            SetTextDropshadow(0, 0, 0, 0, 255)
                            SetTextEdge(2, 0, 0, 0, 150)
                            SetTextDropShadow()
                            SetTextOutline()
                            SetTextEntry("STRING")
                            SetTextCentre(1)
                            AddTextComponentString(nearbyPlayer.name .. " [" .. playerGang.name .. "]")
                            DrawText(0.0, 0.0)
                            ClearDrawOrigin()
                        end
                    end
                end
            end
        end
    end
end) 