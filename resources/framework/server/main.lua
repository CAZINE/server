-- PvP Framework - Server Main
-- Players and Scoreboard are now defined in shared.lua

-- Importar sistema de logs
local Logs = LoadResourceFile(GetCurrentResourceName(), 'server/logs.lua')
if Logs then
    Logs = load(Logs)()
else
    Logs = {}
    print("^1[ERRO] Sistema de logs não encontrado!^0")
end

local function GenerateToken()
    local letters = {}
    for i = 65, 90 do table.insert(letters, string.char(i)) end -- A-Z
    local numbers = {}
    for i = 48, 57 do table.insert(numbers, string.char(i)) end -- 0-9
    local token = ""
    -- 3 letras
    for i = 1, 3 do
        token = token .. letters[math.random(1, #letters)]
    end
    token = token .. "-"
    -- 3 letras ou números
    local charset = {}
    for i = 1, #letters do table.insert(charset, letters[i]) end
    for i = 1, #numbers do table.insert(charset, numbers[i]) end
    for i = 1, 3 do
        token = token .. charset[math.random(1, #charset)]
    end
    return token
end

local allowedToSpawn = {}

-- Sistema de persistência de dados (movido para persistence.lua)

-- Inicialização do framework
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    Utils.Log("PvP Framework iniciado com sucesso!")
    Utils.Log("Configurações carregadas:")
    Utils.Log("- Máximo de jogadores: " .. Config.MaxPlayers)
    Utils.Log("- Zonas PvP: " .. #Config.PvPZones)
    Utils.Log("- Armas padrão: " .. #Config.DefaultWeapons)
    
    -- Criar tabela de persistência (gerenciado em persistence.lua)
end)

-- Evento quando jogador entra no servidor (ANTES do spawn)
-- Este evento é gerenciado pelo sistema de persistência em persistence.lua

-- Função auxiliar para obter tamanho da tabela
function GetTableSize(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

-- playerConnecting: busca token usando steam pelo nome do player
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    deferrals.defer()
    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    local banned = false
    for _, identifier in ipairs(identifiers) do
        local result = exports.oxmysql:query_async("SELECT * FROM bans WHERE identifier = ?", {identifier})
        if result and #result > 0 then
            banned = true
            break
        end
    end
    if banned then
        deferrals.done("Você está banido deste servidor.")
    else
        deferrals.done()
    end
end)

-- Comando para validar token
RegisterCommand('token', function(source, args)
    if source == 0 then -- Console
        print("Comando token não disponível para console")
        return
    end
    
    -- Verificar permissão admin
    if not exports['framework']:HasPermission(source, "admin.all") then
        TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
        return
    end
    
    -- Busca o identificador 'license:' de forma robusta
    local identifier = nil
    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local id = GetPlayerIdentifier(source, i)
        if string.sub(id, 1, string.len("license:")) == "license:" then
            identifier = id
            break
        end
    end
    if not identifier then
        TriggerClientEvent('chat:addMessage', source, { args = {"Token", "Erro ao identificar sua licença Rockstar."}})
        return
    end

    local token = args[1]
    if not token then
        TriggerClientEvent('chat:addMessage', source, { args = {"Token", "Use: /token SEUTOKEN"}})
        return
    end
    exports.oxmysql:execute('SELECT token FROM player_tokens WHERE identifier = ?', {identifier}, function(result)
        if result[1] and result[1].token == token then
            allowedToSpawn[identifier] = true
            -- Marcar jogador como token válido
            local playerData = GetPlayerData(source)
            if playerData then
                playerData.isTokenValid = true
                print("[DEBUG] Token validado para jogador:", source)
            end
            TriggerClientEvent('chat:addMessage', source, { args = {"Token", "Token válido! Aguarde o spawn..."}})
            TriggerClientEvent('pvp:allowSpawn', source)
        else
            TriggerClientEvent('chat:addMessage', source, { args = {"Token", "Token inválido!"}})
        end
    end)
end, false)

-- Evento quando jogador spawna
AddEventHandler('playerSpawned', function(spawn)
    local src = source
    if not src then return end
    
    print("[DEBUG] playerSpawned chamado para source:", src)
    
    -- Busca o identificador 'license:' de forma robusta
    local identifier = nil
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.sub(id, 1, string.len("license:")) == "license:" then
            identifier = id
            break
        end
    end
    
    -- Verificar se o jogador está na tabela Players
    local playerData = GetPlayerData(src)
    if not playerData then
        print("[DEBUG] Jogador não encontrado na tabela Players, criando e cadastrando...")
        playerData = {
            id = src,
            name = GetPlayerName(src),
            kills = 0,
            deaths = 0,
            money = 1000,
            spawnTime = GetGameTimer(),
            isProtected = true,
            currentZone = nil,
            lastKill = 0,
            isTokenValid = false
        }
        
        -- CADASTRAR IMEDIATAMENTE NO BANCO
        print("[DEBUG] Cadastrando jogador no banco durante spawn:", src)
        exports['framework']:SavePlayerData(src, playerData)
        print("[DEBUG] Jogador cadastrado com sucesso no banco durante spawn:", src)
        
        SetPlayerData(src, playerData)
        print("[DEBUG] Jogador " .. playerData.name .. " (ID: " .. src .. ") criado na tabela Players e cadastrado no banco")
        print("[DEBUG] Tabela Players agora tem " .. GetTableSize(Players) .. " jogadores")
        print("[DEBUG] Verificando se dados foram carregados:")
        print("[DEBUG] GetPlayerData(" .. src .. ") existe:", GetPlayerData(src) ~= nil)
    end
    
    -- Verificar token apenas se o sistema de token estiver ativo
    if identifier and not allowedToSpawn[identifier] then
        print("[DEBUG] Token não validado para jogador:", src)
        -- Não kickar o jogador, apenas marcar como não validado
        playerData.isTokenValid = false
        TriggerClientEvent('chat:addMessage', src, { args = {"Sistema", "Use /token SEUTOKEN para validar seu acesso."}})
    else
        print("[DEBUG] Token validado para jogador:", src)
        playerData.isTokenValid = true
    end
    
    -- Verificar se o jogador é válido antes de chamar GetPlayerPed
    if not src or not DoesEntityExist(GetPlayerPed(src)) then 
        print("[DEBUG] Jogador inválido ou entidade não existe:", src)
        return 
    end
    local player = GetPlayerPed(src)

    print("[DEBUG] Jogador " .. playerData.name .. " entrou no servidor (ID: " .. src .. ")")
    print("[DEBUG] Tabela Players agora tem " .. GetTableSize(Players) .. " jogadores")
    
    -- Sempre spawnar o jogador ao entrar
    SpawnPlayer(src)
    
    -- Log de spawn
    if Logs and Logs.logSpawn then
        local coords = GetEntityCoords(GetPlayerPed(src))
        local location = string.format("X: %.2f, Y: %.2f, Z: %.2f", coords.x, coords.y, coords.z)
        Logs.logSpawn(src, location)
    end
    
    -- Remover proteção após tempo definido
    SetTimeout(Config.SpawnProtection, function()
        local currentPlayerData = GetPlayerData(src)
        if currentPlayerData then
            currentPlayerData.isProtected = false
            Utils.SendNotification(src, "Proteção de spawn removida!", "info")
        end
    end)
end)

-- Evento quando jogador sai do servidor
-- Este evento é gerenciado pelo sistema de persistência em persistence.lua

-- Evento de morte
AddEventHandler('baseevents:onPlayerKilled', function(killedBy, reason)
    local source = source
    if not source then return end
    
    -- Verificar se o jogador é válido antes de chamar GetPlayerPed
    if not DoesEntityExist(GetPlayerPed(source)) then return end
    local player = GetPlayerPed(source)
    local playerData = GetPlayerData(source)
    
    if playerData and not playerData.isProtected then
        playerData.deaths = playerData.deaths + 1
        playerData.money = playerData.money - Config.Events.deathPenalty
        
        -- Salvar dados após morte usando o sistema de persistência
        exports['framework']:SavePlayerData(source, playerData)
        print("[DEBUG] Dados salvos após morte do jogador:", source)
        
        -- Enviar notificação de meta perdido para a interface do gangue
        print('[DEBUG] Enviando gangue:metaLost para source:', source, 'metaLost:', Config.Events.deathPenalty)
        TriggerClientEvent("gangue:metaLost", source, { metaLost = Config.Events.deathPenalty })
        
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
        
        Utils.SendNotification(source, deathMessage, "error")
        
        -- Respawn após tempo definido
        -- SetTimeout(Config.RespawnTime, function()
        --     if GetPlayerData(source) then
        --         TriggerClientEvent('pvp:respawn', source)
        --     end
        -- end)
    end
end)

-- Evento de kill
RegisterNetEvent('pvp:playerKilled')
AddEventHandler('pvp:playerKilled', function(victimServerId, weaponHash, isHeadshot)
    print("[DEBUG] Handler pvp:playerKilled chamado no servidor!")
    print("[DEBUG] victimServerId:", victimServerId)
    print("[DEBUG] weaponHash:", weaponHash)
    print("[DEBUG] isHeadshot:", isHeadshot)
    
    local source = source
    if not source then return end
    
    -- Sistema de cooldown para evitar duplicatas
    local killKey = source .. "_" .. victimServerId
    if not _G.recentKills then _G.recentKills = {} end
    
    local currentTime = GetGameTimer()
    if _G.recentKills[killKey] and (currentTime - _G.recentKills[killKey]) < 5000 then
        print("[DEBUG] Kill ignorado - cooldown ativo para:", killKey)
        return
    end
    
    _G.recentKills[killKey] = currentTime
    print("[DEBUG] Kill registrado:", killKey)
    
    print("[DEBUG] Source válido:", source)
    
    -- Verificar se os jogadores são válidos antes de chamar GetPlayerPed
    if not victimServerId or not DoesEntityExist(GetPlayerPed(source)) or not DoesEntityExist(GetPlayerPed(victimServerId)) then 
        print("[DEBUG] Validação de entidades falhou!")
        print("[DEBUG] victimServerId:", victimServerId)
        print("[DEBUG] DoesEntityExist(GetPlayerPed(source)):", DoesEntityExist(GetPlayerPed(source)))
        print("[DEBUG] DoesEntityExist(GetPlayerPed(victimServerId)):", DoesEntityExist(GetPlayerPed(victimServerId)))
        return 
    end
    
    print("[DEBUG] Entidades válidas!")
    
    local killer = GetPlayerPed(source)
    local victim = GetPlayerPed(victimServerId)
    local killerData = GetPlayerData(source)
    local victimData = GetPlayerData(victimServerId)
    
    print("[DEBUG] killerData existe:", killerData ~= nil)
    print("[DEBUG] victimData existe:", victimData ~= nil)
    
    -- Se os dados não existem, criar temporariamente
    if not killerData then
        killerData = {
            id = source,
            name = GetPlayerName(source) or "Desconhecido",
            kills = 0,
            deaths = 0,
            money = 0,
            fixed_id = source
        }
    end
    
    if not victimData then
        victimData = {
            id = victimServerId,
            name = GetPlayerName(victimServerId) or "Desconhecido",
            kills = 0,
            deaths = 0,
            money = 0,
            fixed_id = victimServerId
        }
    end
    
    if killerData and victimData then
        print("[DEBUG] Dados válidos!")
        
        if source ~= victimServerId then
            print("[DEBUG] Não é suicídio!")
            killerData.kills = killerData.kills + 1
            killerData.money = killerData.money + Config.Events.killReward
            killerData.lastKill = GetGameTimer()
            
            -- Salvar dados após kill usando o sistema de persistência
            exports['framework']:SavePlayerData(source, killerData)
            print("[DEBUG] Dados salvos após kill do jogador:", source)
            
            -- Enviar notificação de meta ganho para a interface do gangue
            print('[DEBUG] Enviando gangue:metaGained para source:', source, 'metaGained:', Config.Events.killReward)
            TriggerClientEvent("gangue:metaGained", source, { metaGained = Config.Events.killReward })
            
            -- Bônus por headshot
            if isHeadshot then
                killerData.money = killerData.money + Config.Events.headshotBonus
                Utils.SendNotification(source, "Headshot! +" .. Config.Events.headshotBonus .. " bônus", "success")
                            -- Enviar notificação de meta ganho por headshot para a interface do gangue
            print('[DEBUG] Enviando gangue:metaGained (headshot) para source:', source, 'metaGained:', Config.Events.headshotBonus)
            TriggerClientEvent("gangue:metaGained", source, { metaGained = Config.Events.headshotBonus })
            end
            
            -- Notificar kill
            local weaponName = Utils.GetWeaponName(weaponHash)
          
            
            -- Atualizar scoreboard
            exports[GetCurrentResourceName()]:UpdateScoreboard()

            -- Trigger para killfeed do resource kill - ENVIAR PARA TODOS OS PLAYERS
            print("[FRAMEWORK DEBUG] Disparando kill:showKill para TODOS os players")
            print("[FRAMEWORK DEBUG] Killer Name:", killerData.name)
            print("[FRAMEWORK DEBUG] Victim Name:", victimData.name)
            print("[FRAMEWORK DEBUG] Victim ID:", victimData.id)
            print("[FRAMEWORK DEBUG] Weapon Name:", weaponName)
            
            -- Adicionar delay pequeno para evitar duplicação
            Citizen.Wait(100)
            TriggerClientEvent('kill:showKill', -1, killerData.name, victimData.name, victimData.id, weaponName)
            
            -- Trigger para o killmark do framework
            print("[FRAMEWORK DEBUG] Disparando pvp:playerKilled para o client!")
            print("[FRAMEWORK DEBUG] Source:", source)
            print("[FRAMEWORK DEBUG] Victim Name:", victimData.name)
            print("[FRAMEWORK DEBUG] Victim ID:", victimData.id)
            print("[FRAMEWORK DEBUG] Weapon Name:", weaponName)
            TriggerClientEvent('pvp:playerKilled', source, victimData.name, victimData.id, weaponName)
            
            -- NOVO: Disparar evento de efeitos de partículas para todos os clientes
            print("[FRAMEWORK DEBUG] Disparando pvp:playerKilledByOther para todos os clientes!")
            TriggerClientEvent('pvp:playerKilledByOther', -1, victimServerId, source, isHeadshot)
            
            -- Log de kill
            if Logs and Logs.logKill then
                Logs.logKill(source, victimServerId, weaponName)
            end
        end
    end
end)

-- Sistema de salvamento periódico
CreateThread(function()
    while true do
        Wait(300000) -- Salvar a cada 5 minutos (300 segundos)
        
        local players = GetPlayers()
        local savedCount = 0
        
        for _, playerId in ipairs(players) do
            local playerData = GetPlayerData(playerId)
            if playerData then
                if exports['framework']:SavePlayerData(playerId, playerData) then
                    savedCount = savedCount + 1
                end
            end
        end
        
        if savedCount > 0 then
            print("[PERSISTENCE] Salvamento periódico: " .. savedCount .. " jogadores salvos")
        end
    end
end)

-- Comando para forçar salvamento de dados
RegisterCommand('savedata', function(source, args, rawCommand)
    if source == 0 then -- Console
        local players = GetPlayers()
        local savedCount = 0
        
        for _, playerId in ipairs(players) do
            local playerData = GetPlayerData(playerId)
            if playerData then
                if exports['framework']:SavePlayerData(playerId, playerData) then
                    savedCount = savedCount + 1
                end
            end
        end
        
        print("[PERSISTENCE] Salvamento forçado: " .. savedCount .. " jogadores salvos")
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local players = GetPlayers()
        local savedCount = 0
        
        for _, playerId in ipairs(players) do
            local playerData = GetPlayerData(playerId)
            if playerData then
                if exports['framework']:SavePlayerData(playerId, playerData) then
                    savedCount = savedCount + 1
                end
            end
        end
        
        TriggerClientEvent('pvp:notification', source, "Salvamento forçado: " .. savedCount .. " jogadores salvos", "success")
    end
end, false)

-- Comando para verificar dados de um jogador no banco
RegisterCommand('checkdata', function(source, args, rawCommand)
    if source == 0 then -- Console
        local targetId = tonumber(args[1])
        if not targetId then
            print("Uso: checkdata <player_id>")
            return
        end
        
        local playerData = exports['framework']:LoadPlayerData(targetId)
        if playerData then
            print("[PERSISTENCE] Dados do jogador", targetId, "no banco:")
            print("  Nome:", playerData.name)
            print("  Kills:", playerData.kills)
            print("  Deaths:", playerData.deaths)
            print("  Money:", playerData.money)
        else
            print("[PERSISTENCE] Nenhum dado encontrado para jogador", targetId)
        end
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local targetId = tonumber(args[1]) or source
        local playerData = exports['framework']:LoadPlayerData(targetId)
        if playerData then
            local info = string.format("Dados do jogador %s: Nome: %s, Kills: %s, Deaths: %s, Money: %s", 
                targetId, playerData.name, playerData.kills, playerData.deaths, playerData.money)
            TriggerClientEvent('pvp:notification', source, info, "info")
        else
            TriggerClientEvent('pvp:notification', source, "Nenhum dado encontrado para jogador " .. targetId, "error")
        end
    end
end, false)

-- Timer para atualizar scoreboard
CreateThread(function()
    while true do
        Wait(Config.Scoreboard.updateInterval)
        exports[GetCurrentResourceName()]:UpdateScoreboard()
    end
end)

-- Comandos do servidor
RegisterCommand('pvp', function(source, args, rawCommand)
    if source == 0 then -- Console
        if args[1] == 'players' then
            Utils.Log("Jogadores online: " .. #GetPlayers())
            local allPlayers = GetAllPlayers()
            for id, player in pairs(allPlayers) do
                Utils.Log(string.format("ID: %s | Nome: %s | Kills: %s | Deaths: %s | K/D: %s", 
                    id, player.name, player.kills, player.deaths, Utils.CalculateKDRatio(player.kills, player.deaths)))
            end
        elseif args[1] == 'restart' then
            Utils.Log("Reiniciando servidor...")
            ExecuteCommand('restart')
        end
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        if args[1] == 'players' then
            local allPlayers = GetAllPlayers()
            TriggerClientEvent('pvp:notification', source, "Jogadores online: " .. #GetPlayers(), "info")
            for id, player in pairs(allPlayers) do
                TriggerClientEvent('pvp:notification', source, string.format("ID: %s | Nome: %s | Kills: %s | Deaths: %s | K/D: %s", 
                    id, player.name, player.kills, player.deaths, Utils.CalculateKDRatio(player.kills, player.deaths)), "info")
            end
        elseif args[1] == 'restart' then
            TriggerClientEvent('pvp:notification', source, "Reiniciando servidor...", "info")
            ExecuteCommand('restart')
        else
            TriggerClientEvent('pvp:notification', source, "Uso: /pvp [players|restart]", "error")
        end
    end
end, false)

-- Comando de teste para killfeed
RegisterCommand('testkillfeed', function(source, args, rawCommand)
    if source == 0 then return end -- Apenas jogadores
    
    print("[DEBUG] Comando testkillfeed executado por:", source)
    
    -- Simular um kill
    local killerData = GetPlayerData(source)
    if killerData then
        print("[DEBUG] Simulando kill para killfeed")
        print("[DEBUG] Killer Name:", killerData.name)
        print("[DEBUG] Victim Name: JogadorTeste")
        print("[DEBUG] Weapon: AK47")
        
        -- Trigger para killfeed do resource kill
        TriggerClientEvent('kill:showKill', -1, killerData.name, "JogadorTeste", "AK47")
        TriggerClientEvent('pvp:notification', source, "Killfeed de teste enviado!", "success")
    else
        TriggerClientEvent('pvp:notification', source, "Erro: Dados do jogador não encontrados!", "error")
    end
end, false)

-- Comando para adicionar jogador à tabela Players (teste)
RegisterCommand('addplayer', function(source, args, rawCommand)
    if source == 0 then -- Console
        local targetId = tonumber(args[1])
        if not targetId then
            print("Uso: addplayer <player_id>")
            return
        end
        
        if not GetPlayerData(targetId) then
            local playerData = {
                id = targetId,
                name = GetPlayerName(targetId),
                kills = 0,
                deaths = 0,
                money = 1000,
                spawnTime = GetGameTimer(),
                isProtected = false,
                currentZone = nil,
                lastKill = 0
            }
            SetPlayerData(targetId, playerData)
            print("Jogador " .. targetId .. " adicionado à tabela Players")
        else
            print("Jogador " .. targetId .. " já está na tabela Players")
        end
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local targetId = tonumber(args[1])
        if not targetId then
            TriggerClientEvent('pvp:notification', source, "Uso: /addplayer <player_id>", "error")
            return
        end
        
        if not GetPlayerData(targetId) then
            local playerData = {
                id = targetId,
                name = GetPlayerName(targetId),
                kills = 0,
                deaths = 0,
                money = 1000,
                spawnTime = GetGameTimer(),
                isProtected = false,
                currentZone = nil,
                lastKill = 0
            }
            SetPlayerData(targetId, playerData)
            TriggerClientEvent('pvp:notification', source, "Jogador " .. targetId .. " adicionado à tabela Players", "success")
        else
            TriggerClientEvent('pvp:notification', source, "Jogador " .. targetId .. " já está na tabela Players", "info")
        end
    end
end, false)

-- Comandos de debug para verificar Players
RegisterCommand('checkplayer', function(source, args, rawCommand)
    if source == 0 then -- Console
        local targetId = tonumber(args[1])
        if targetId then
            print('[DEBUG] Verificando jogador ID:', targetId)
            print('[DEBUG] Players[targetId]:', Players[targetId])
            if Players[targetId] then
                print('[DEBUG] Dados do jogador:', json.encode(Players[targetId]))
            else
                print('[DEBUG] Jogador não encontrado na tabela Players')
            end
        else
            print("Uso: checkplayer <player_id>")
        end
    else
        local targetId = tonumber(args[1]) or source
        print('[DEBUG] Verificando jogador ID:', targetId)
        print('[DEBUG] Players[targetId]:', Players[targetId])
        if Players[targetId] then
            print('[DEBUG] Dados do jogador:', json.encode(Players[targetId]))
            TriggerClientEvent('chat:addMessage', source, { args = {"DEBUG", "Jogador encontrado na tabela Players"}})
        else
            print('[DEBUG] Jogador não encontrado na tabela Players')
            TriggerClientEvent('chat:addMessage', source, { args = {"DEBUG", "Jogador NÃO encontrado na tabela Players"}})
        end
    end
end, false)

RegisterCommand('listplayers', function(source, args, rawCommand)
    if source == 0 then -- Console
        print('[DEBUG] Listando todos os jogadores na tabela Players:')
        for id, player in pairs(Players) do
            print('[DEBUG] ID:', id, 'Nome:', player.name)
        end
    else
        TriggerClientEvent('chat:addMessage', source, { args = {"DEBUG", "Listando jogadores na tabela Players:"}})
        for id, player in pairs(Players) do
            TriggerClientEvent('chat:addMessage', source, { args = {"DEBUG", "ID: " .. id .. " Nome: " .. player.name}})
        end
    end
end, false)

RegisterCommand('testequip', function(source, args, rawCommand)
    if source == 0 then -- Console
        local targetId = tonumber(args[1])
        local weapon = args[2] or "WEAPON_PISTOL"
        if targetId then
            print('[DEBUG] Testando equipamento de arma para jogador:', targetId, 'Arma:', weapon)
            TriggerClientEvent('pvp:giveWeapon', targetId, weapon)
        else
            print("Uso: testequip <player_id> [weapon]")
        end
    else
        local weapon = args[1] or "WEAPON_PISTOL"
        print('[DEBUG] Testando equipamento de arma para jogador:', source, 'Arma:', weapon)
        TriggerClientEvent('pvp:giveWeapon', source, weapon)
        TriggerClientEvent('chat:addMessage', source, { args = {"DEBUG", "Testando equipamento de arma: " .. weapon}})
    end
end, false)

-- Comando de debug para verificar tabela Players
RegisterCommand('debugplayers', function(source, args, rawCommand)
    if source == 0 then -- Console
        print("[DEBUG] === TABELA PLAYERS ===")
        print("[DEBUG] Total de jogadores na tabela:", GetTableSize(Players))
        for playerId, playerData in pairs(Players) do
            print(string.format("[DEBUG] ID: %s | Nome: %s | Token Valid: %s | Protected: %s", 
                playerId, playerData.name, tostring(playerData.isTokenValid), tostring(playerData.isProtected)))
        end
        print("[DEBUG] === FIM TABELA PLAYERS ===")
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        TriggerClientEvent('chat:addMessage', source, { args = {"Debug", "Verificando tabela Players..."}})
        print("[DEBUG] === TABELA PLAYERS (via comando) ===")
        print("[DEBUG] Total de jogadores na tabela:", GetTableSize(Players))
        for playerId, playerData in pairs(Players) do
            local info = string.format("ID: %s | Nome: %s | Token Valid: %s | Protected: %s", 
                playerId, playerData.name, tostring(playerData.isTokenValid), tostring(playerData.isProtected))
            print("[DEBUG] " .. info)
            TriggerClientEvent('chat:addMessage', source, { args = {"Debug", info}})
        end
        print("[DEBUG] === FIM TABELA PLAYERS ===")
    end
end, false)

-- Comando para forçar criação de jogador na tabela
RegisterCommand('forceplayer', function(source, args, rawCommand)
    if source == 0 then -- Console
        local targetId = tonumber(args[1])
        if targetId then
            if not GetPlayerData(targetId) then
                local playerData = {
                    id = targetId,
                    name = GetPlayerName(targetId) or "Unknown",
                    kills = 0,
                    deaths = 0,
                    money = 1000,
                    spawnTime = GetGameTimer(),
                    isProtected = true,
                    currentZone = nil,
                    lastKill = 0,
                    isTokenValid = false
                }
                SetPlayerData(targetId, playerData)
                print("[DEBUG] Jogador forçado na tabela Players:", targetId)
            else
                print("[DEBUG] Jogador já existe na tabela Players:", targetId)
            end
        else
            print("Uso: forceplayer <player_id>")
        end
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local targetId = tonumber(args[1])
        if targetId then
            if not GetPlayerData(targetId) then
                local playerData = {
                    id = targetId,
                    name = GetPlayerName(targetId) or "Unknown",
                    kills = 0,
                    deaths = 0,
                    money = 1000,
                    spawnTime = GetGameTimer(),
                    isProtected = true,
                    currentZone = nil,
                    lastKill = 0,
                    isTokenValid = false
                }
                SetPlayerData(targetId, playerData)
                TriggerClientEvent('pvp:notification', source, "Jogador forçado na tabela Players: " .. targetId, "success")
            else
                TriggerClientEvent('pvp:notification', source, "Jogador já existe na tabela Players: " .. targetId, "info")
            end
        else
            TriggerClientEvent('pvp:notification', source, "Uso: /forceplayer <player_id>", "error")
        end
    end
end, false)

-- Comando para forçar cadastro de jogador
RegisterCommand('cadastrar', function(source, args, rawCommand)
    if source == 0 then -- Console
        local targetId = tonumber(args[1])
        if not targetId then
            print("Uso: cadastrar <player_id>")
            return
        end
        
        local playerData = GetPlayerData(targetId)
        if not playerData then
            playerData = {
                id = targetId,
                name = GetPlayerName(targetId) or "Unknown",
                kills = 0,
                deaths = 0,
                money = 1000,
                spawnTime = GetGameTimer(),
                isProtected = true,
                currentZone = nil,
                lastKill = 0,
                isTokenValid = false
            }
            SetPlayerData(targetId, playerData)
        end
        
        -- Forçar cadastro no banco
        if exports['framework']:SavePlayerData(targetId, playerData) then
            print("[DEBUG] Jogador", targetId, "cadastrado com sucesso no banco!")
        else
            print("[DEBUG] ERRO ao cadastrar jogador", targetId, "no banco!")
        end
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local targetId = tonumber(args[1]) or source
        local playerData = GetPlayerData(targetId)
        if not playerData then
            playerData = {
                id = targetId,
                name = GetPlayerName(targetId) or "Unknown",
                kills = 0,
                deaths = 0,
                money = 1000,
                spawnTime = GetGameTimer(),
                isProtected = true,
                currentZone = nil,
                lastKill = 0,
                isTokenValid = false
            }
            SetPlayerData(targetId, playerData)
        end
        
        -- Forçar cadastro no banco
        if exports['framework']:SavePlayerData(targetId, playerData) then
            TriggerClientEvent('pvp:notification', source, "Jogador " .. targetId .. " cadastrado com sucesso no banco!", "success")
        else
            TriggerClientEvent('pvp:notification', source, "ERRO ao cadastrar jogador " .. targetId .. " no banco!", "error")
        end
    end
end, false)

-- Comando para verificar se jogador está cadastrado
RegisterCommand('verificarcadastro', function(source, args, rawCommand)
    if source == 0 then -- Console
        local targetId = tonumber(args[1])
        if not targetId then
            print("Uso: verificarcadastro <player_id>")
            return
        end
        
        local playerData = exports['framework']:LoadPlayerData(targetId)
        if playerData then
            print("[DEBUG] Jogador", targetId, "está cadastrado no banco!")
            print("  Nome:", playerData.name)
            print("  Kills:", playerData.kills)
            print("  Deaths:", playerData.deaths)
            print("  Money:", playerData.money)
        else
            print("[DEBUG] Jogador", targetId, "NÃO está cadastrado no banco!")
        end
    else
        local targetId = tonumber(args[1]) or source
        local playerData = exports['framework']:LoadPlayerData(targetId)
        if playerData then
            local info = string.format("Jogador %s está cadastrado! Nome: %s, Kills: %s, Deaths: %s, Money: %s", 
                targetId, playerData.name, playerData.kills, playerData.deaths, playerData.money)
            TriggerClientEvent('pvp:notification', source, info, "success")
        else
            TriggerClientEvent('pvp:notification', source, "Jogador " .. targetId .. " NÃO está cadastrado no banco!", "error")
        end
    end
end, false)

-- Exportar funções
exports('GetPlayers', function()
    return GetAllPlayers()
end)

exports('GetScoreboard', function()
    return GetScoreboardData()
end)

exports('GetPlayerData', function(playerId)
    return GetPlayerData(playerId)
end) 

RegisterNetEvent('pvp:syncClothes')
AddEventHandler('pvp:syncClothes', function(clothesData)
    local src = source
    TriggerClientEvent('pvp:applyClothes', -1, src, clothesData)
end) 

RegisterNetEvent('pvp:showMyIdentifier')
AddEventHandler('pvp:showMyIdentifier', function()
    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    for _, id in ipairs(identifiers) do
        if string.find(id, "license:") then
            TriggerClientEvent('chat:addMessage', src, { args = { '^2Seu identifier:', id } })
            break
        end
    end
end) 