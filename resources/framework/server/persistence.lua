-- Sistema de Persistência de Dados
-- Este script gerencia o salvamento e carregamento de dados dos jogadores no banco de dados

-- Defina as funções primeiro
local function GetPlayerIdentifier(playerId)
    local identifiers = GetPlayerIdentifiers(playerId)
    for _, identifier in ipairs(identifiers) do
        if string.find(identifier, "license:") then
            return identifier
        end
    end
    return nil
end

-- Função para buscar o menor fixed_id disponível (1-1000)
local function GetNextAvailableFixedId()
    local result = exports.oxmysql:query_async("SELECT fixed_id FROM player_data WHERE fixed_id IS NOT NULL ORDER BY fixed_id ASC")
    local used = {}
    for _, row in ipairs(result) do
        used[row.fixed_id] = true
    end
    for i = 1, 1000 do
        if not used[i] then
            return i
        end
    end
    return nil -- Todos ocupados
end

-- Função para obter fixed_id por identifier
local function GetFixedIdByIdentifier(identifier)
    local result = exports.oxmysql:query_async("SELECT fixed_id FROM player_data WHERE identifier = ?", {identifier})
    if result and result[1] then
        return result[1].fixed_id
    end
    return nil
end

-- Atualizar SavePlayerData para atribuir fixed_id se não existir
local function SavePlayerData(playerId, playerData)
    local identifier = GetPlayerIdentifier(playerId)
    if not identifier then 
        print("[PERSISTENCE] ERRO: Não foi possível obter identifier para playerId:", playerId)
        return false 
    end
    if not exports.oxmysql then
        print("[PERSISTENCE] ERRO: oxmysql não está disponível!")
        return false
    end
    
    -- Buscar fixed_id existente
    local fixed_id = GetFixedIdByIdentifier(identifier)
    if not fixed_id then
        -- Novo jogador, atribuir menor fixed_id disponível
        fixed_id = GetNextAvailableFixedId()
        if not fixed_id then
            print("[PERSISTENCE] ERRO: Limite de 1000 jogadores atingido!")
            return false
        end
        print("[PERSISTENCE] Novo jogador recebeu fixed_id:", fixed_id)
    end
    
    local success = pcall(function()
        return exports.oxmysql:execute_async([[INSERT INTO player_data (fixed_id, identifier, player_name, kills, deaths, money, last_login)
            VALUES (?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)
            ON DUPLICATE KEY UPDATE player_name = ?, kills = ?, deaths = ?, money = ?, last_login = CURRENT_TIMESTAMP, fixed_id = ?]], {
            fixed_id, identifier, playerData.name, playerData.kills, playerData.deaths, playerData.money,
            playerData.name, playerData.kills, playerData.deaths, playerData.money, fixed_id
        })
    end)
    if success then
        print("[PERSISTENCE] Dados salvos para jogador:", playerId, "Identifier:", identifier, "FixedID:", fixed_id)
        -- Atualizar o playerData com o fixed_id
        playerData.fixed_id = fixed_id
        return true
    else
        print("[PERSISTENCE] ERRO ao salvar dados para jogador:", playerId)
        return false
    end
end

-- Atualizar LoadPlayerData para carregar fixed_id
local function LoadPlayerData(playerId)
    local identifier = GetPlayerIdentifier(playerId)
    if not identifier then 
        print("[PERSISTENCE] ERRO: Não foi possível obter identifier para playerId:", playerId)
        return nil 
    end
    if not exports.oxmysql then
        print("[PERSISTENCE] ERRO: oxmysql não está disponível!")
        return nil
    end
    local success, result = pcall(function()
        return exports.oxmysql:query_async("SELECT fixed_id, player_name, kills, deaths, money FROM player_data WHERE identifier = ?", {identifier})
    end)
    if success and result and result[1] then
        local data = result[1]
        print("[PERSISTENCE] Dados carregados para jogador:", playerId, "FixedID:", data.fixed_id, "Kills:", data.kills, "Deaths:", data.deaths, "Money:", data.money)
        return {
            id = playerId,
            fixed_id = data.fixed_id,
            identifier = identifier,
            name = data.player_name,
            kills = data.kills or 0,
            deaths = data.deaths or 0,
            money = data.money or 1000,
            spawnTime = GetGameTimer(),
            isProtected = true,
            currentZone = nil,
            lastKill = 0,
            isTokenValid = false
        }
    else
        print("[PERSISTENCE] Nenhum dado encontrado para jogador:", playerId, "Criando dados padrão")
        return nil
    end
end

-- Atualizar CreateTableIfNotExists para garantir fixed_id
local function CreateTableIfNotExists()
    if not exports.oxmysql then
        print("[PERSISTENCE] ERRO: oxmysql não está disponível!")
        return false
    end
    local success = pcall(function()
        return exports.oxmysql:execute_async([[ALTER TABLE player_data ADD COLUMN IF NOT EXISTS fixed_id INT UNIQUE AFTER id]])
    end)
    -- Ignorar erro se já existe
    local success2 = pcall(function()
        return exports.oxmysql:execute_async([[CREATE TABLE IF NOT EXISTS player_data (
            id INT AUTO_INCREMENT PRIMARY KEY,
            fixed_id INT UNIQUE,
            identifier VARCHAR(50) UNIQUE NOT NULL,
            player_name VARCHAR(50) NOT NULL,
            kills INT DEFAULT 0,
            deaths INT DEFAULT 0,
            money INT DEFAULT 1000,
            last_login TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )]])
    end)
    print("[PERSISTENCE] Tabela player_data criada/verificada com sucesso!")
    return true
end

local function FindPlayerByIdentifier(identifier)
    for playerId, playerData in pairs(Players) do
        if playerData and playerData.identifier == identifier then
            return playerId, playerData
        end
    end
    return nil, nil
end

local function CleanupOldEntries(newPlayerId, identifier)
    local oldPlayerId, oldPlayerData = FindPlayerByIdentifier(identifier)
    if oldPlayerId and oldPlayerId ~= newPlayerId then
        print("[PERSISTENCE] Limpando entrada antiga do jogador:", oldPlayerId, "para nova entrada:", newPlayerId)
        RemovePlayerData(oldPlayerId)
    end
end

local function GetAllPlayersByIdentifier()
    local playersByIdentifier = {}
    for playerId, playerData in pairs(Players) do
        if playerData and playerData.identifier then
            playersByIdentifier[playerData.identifier] = {
                playerId = playerId,
                data = playerData
            }
        end
    end
    return playersByIdentifier
end

local function CleanupAllDuplicates()
    local playersByIdentifier = GetAllPlayersByIdentifier()
    local cleanedCount = 0
    
    for identifier, playerInfo in pairs(playersByIdentifier) do
        -- Se há mais de uma entrada para o mesmo identifier, manter apenas a mais recente
        local entries = {}
        for playerId, playerData in pairs(Players) do
            if playerData and playerData.identifier == identifier then
                table.insert(entries, {playerId = playerId, data = playerData})
            end
        end
        
        if #entries > 1 then
            -- Manter apenas a entrada mais recente (com spawnTime mais alto)
            table.sort(entries, function(a, b) 
                return (a.data.spawnTime or 0) > (b.data.spawnTime or 0) 
            end)
            
            -- Remover entradas antigas
            for i = 2, #entries do
                print("[PERSISTENCE] Removendo entrada duplicada:", entries[i].playerId, "para identifier:", identifier)
                RemovePlayerData(entries[i].playerId)
                cleanedCount = cleanedCount + 1
            end
        end
    end
    
    if cleanedCount > 0 then
        print("[PERSISTENCE] Limpeza concluída:", cleanedCount, "entradas duplicadas removidas")
    end
    
    return cleanedCount
end

-- Função para obter playerId por fixed_id
local function GetPlayerIdByFixedId(fixed_id)
    for playerId, playerData in pairs(Players) do
        if playerData and playerData.fixed_id == fixed_id then
            return playerId
        end
    end
    return nil
end

-- Função para obter fixed_id por playerId
local function GetFixedIdByPlayerId(playerId)
    local playerData = GetPlayerData(playerId)
    if playerData then
        return playerData.fixed_id
    end
    return nil
end

-- Agora monte a tabela
local PlayerPersistence = {
    GetPlayerIdentifier = GetPlayerIdentifier,
    SavePlayerData = SavePlayerData,
    LoadPlayerData = LoadPlayerData,
    CreateTableIfNotExists = CreateTableIfNotExists,
    FindPlayerByIdentifier = FindPlayerByIdentifier,
    CleanupOldEntries = CleanupOldEntries,
    GetAllPlayersByIdentifier = GetAllPlayersByIdentifier,
    CleanupAllDuplicates = CleanupAllDuplicates,
    GetPlayerIdByFixedId = GetPlayerIdByFixedId,
    GetFixedIdByPlayerId = GetFixedIdByPlayerId,
    GetFixedIdByIdentifier = GetFixedIdByIdentifier
}

-- Inicialização do sistema de persistência
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    print("[PERSISTENCE] Sistema de persistência iniciado!")
    
    -- Criar tabela se não existir
    PlayerPersistence.CreateTableIfNotExists()
    
    -- Limpar entradas duplicadas na inicialização
    SetTimeout(5000, function()
        local cleanedCount = PlayerPersistence.CleanupAllDuplicates()
        if cleanedCount > 0 then
            print("[PERSISTENCE] Limpeza inicial concluída:", cleanedCount, "entradas duplicadas removidas")
        end
    end)
end)

-- Evento quando jogador entra no servidor
AddEventHandler('playerJoining', function(source)
    local src = source
    if not src then return end
    
    print("[DEBUG] playerJoining chamado para source:", src)
    
    -- Obter identifier do jogador
    local identifier = PlayerPersistence.GetPlayerIdentifier(src)
    if not identifier then
        print("[DEBUG] ERRO: Não foi possível obter identifier para jogador:", src)
        return
    end
    
    -- Limpar entradas antigas do mesmo jogador
    PlayerPersistence.CleanupOldEntries(src, identifier)
    
    -- Tentar carregar dados do banco primeiro
    local playerData = PlayerPersistence.LoadPlayerData(src)
    
    if not playerData then
        -- Se não há dados no banco, criar dados padrão e CADASTRAR IMEDIATAMENTE
        playerData = {
            id = src,
            identifier = identifier, -- Adicionar identifier aos dados
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
        print("[DEBUG] Cadastrando jogador no banco:", src)
        PlayerPersistence.SavePlayerData(src, playerData)
        print("[DEBUG] Jogador cadastrado com sucesso no banco:", src)
        
        print("[DEBUG] Dados padrão criados e cadastrados para jogador:", src)
    else
        print("[DEBUG] Dados carregados do banco para jogador:", src)
    end
    
    -- Adicionar à tabela Players
    SetPlayerData(src, playerData)
    print("[DEBUG] Jogador " .. playerData.name .. " (ID: " .. src .. ", FixedID: " .. (playerData.fixed_id or "N/A") .. ") adicionado à tabela Players")
    print("[DEBUG] Tabela Players agora tem " .. GetTableSize(Players) .. " jogadores")
end)

-- Evento quando jogador sai do servidor
AddEventHandler('playerDropped', function(reason)
    local src = source
    if src then
        print("[DEBUG] playerDropped chamado para source:", src, "Razão:", reason)
        
        -- Salvar dados do jogador antes de remover
        local playerData = GetPlayerData(src)
        if playerData then
            print("[DEBUG] Salvando dados do jogador antes de sair:", src)
            PlayerPersistence.SavePlayerData(src, playerData)
        end
        
        -- Remover jogador da tabela Players
        RemovePlayerData(src)
        local playerName = GetPlayerName(src) or 'Desconhecido'
        Utils.Log("Jogador " .. playerName .. " saiu do servidor (Razão: " .. (reason or "Desconhecida") .. ")")
        print("[DEBUG] Tabela Players agora tem " .. GetTableSize(Players) .. " jogadores")
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
                if PlayerPersistence.SavePlayerData(playerId, playerData) then
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
                if PlayerPersistence.SavePlayerData(playerId, playerData) then
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
                if PlayerPersistence.SavePlayerData(playerId, playerData) then
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
        
        local playerData = PlayerPersistence.LoadPlayerData(targetId)
        if playerData then
            print("Dados do jogador", targetId, ":")
            print("- Nome:", playerData.name)
            print("- Kills:", playerData.kills)
            print("- Deaths:", playerData.deaths)
            print("- Money:", playerData.money)
            print("- Identifier:", playerData.identifier)
        else
            print("Nenhum dado encontrado para jogador", targetId)
        end
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local targetId = tonumber(args[1])
        if not targetId then
            TriggerClientEvent('pvp:notification', source, "Uso: /checkdata <player_id>", "error")
            return
        end
        
        local playerData = PlayerPersistence.LoadPlayerData(targetId)
        if playerData then
            local message = string.format("Dados do jogador %d:\nNome: %s\nKills: %d\nDeaths: %d\nMoney: %d\nIdentifier: %s", 
                targetId, playerData.name, playerData.kills, playerData.deaths, playerData.money, playerData.identifier)
            TriggerClientEvent('pvp:notification', source, message, "info")
        else
            TriggerClientEvent('pvp:notification', source, "Nenhum dado encontrado para jogador " .. targetId, "error")
        end
    end
end, false)

-- Comando para limpar entradas duplicadas
RegisterCommand('cleanup', function(source, args, rawCommand)
    if source == 0 then -- Console
        local cleanedCount = PlayerPersistence.CleanupAllDuplicates()
        print("[PERSISTENCE] Limpeza concluída:", cleanedCount, "entradas duplicadas removidas")
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local cleanedCount = PlayerPersistence.CleanupAllDuplicates()
        TriggerClientEvent('pvp:notification', source, "Limpeza concluída: " .. cleanedCount .. " entradas duplicadas removidas", "success")
    end
end, false)

-- Comando para listar todos os jogadores na tabela Players
RegisterCommand('listplayers', function(source, args, rawCommand)
    if source == 0 then -- Console
        print("Jogadores na tabela Players:")
        for playerId, playerData in pairs(Players) do
            if playerData then
                print(string.format("- ID: %d, Nome: %s, Identifier: %s", 
                    playerId, playerData.name, playerData.identifier or "N/A"))
            end
        end
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local message = "Jogadores na tabela Players:\n"
        local count = 0
        for playerId, playerData in pairs(Players) do
            if playerData then
                count = count + 1
                message = message .. string.format("- ID: %d, Nome: %s, Identifier: %s\n", 
                    playerId, playerData.name, playerData.identifier or "N/A")
            end
        end
        
        if count == 0 then
            message = "Nenhum jogador na tabela Players"
        end
        
        TriggerClientEvent('pvp:notification', source, message, "info")
    end
end, false)

-- Comando para listar todos os jogadores com seus fixed_ids
RegisterCommand('listplayers', function(source, args)
    if source == 0 then -- Console only
        print("[DEBUG] Listando todos os jogadores:")
        for playerId, playerData in pairs(Players) do
            if playerData then
                print(string.format("PlayerID: %s, FixedID: %s, Name: %s, Identifier: %s", 
                    playerId, 
                    playerData.fixed_id or "N/A", 
                    playerData.name or "N/A",
                    playerData.identifier or "N/A"
                ))
            end
        end
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        TriggerClientEvent('pvp:notification', source, "Comando disponível apenas no console", "info")
    end
end, false)

-- Comando para buscar jogador por fixed_id
RegisterCommand('findplayer', function(source, args)
    if source == 0 then -- Console only
        local fixed_id = tonumber(args[1])
        if not fixed_id then
            print("Uso: findplayer <fixed_id>")
            return
        end
        
        local playerId = PlayerPersistence.GetPlayerIdByFixedId(fixed_id)
        if playerId then
            local playerData = GetPlayerData(playerId)
            print(string.format("FixedID %s encontrado: PlayerID %s, Name: %s", 
                fixed_id, playerId, playerData.name or "N/A"
            ))
        else
            print("FixedID " .. fixed_id .. " não encontrado")
        end
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local fixed_id = tonumber(args[1])
        if not fixed_id then
            TriggerClientEvent('pvp:notification', source, "Uso: /findplayer <fixed_id>", "error")
            return
        end
        
        local playerId = PlayerPersistence.GetPlayerIdByFixedId(fixed_id)
        if playerId then
            local playerData = GetPlayerData(playerId)
            TriggerClientEvent('pvp:notification', source, 
                string.format("FixedID %s: PlayerID %s, Name: %s", fixed_id, playerId, playerData.name or "N/A"), 
                "info"
            )
        else
            TriggerClientEvent('pvp:notification', source, "FixedID " .. fixed_id .. " não encontrado", "error")
        end
    end
end, false)

-- Comando para obter fixed_id do jogador atual
RegisterCommand('myid', function(source, args)
    if source == 0 then -- Console only
        print("Comando myid não disponível para console")
        return
    end
    
    local playerData = GetPlayerData(source)
    if playerData and playerData.fixed_id then
        TriggerClientEvent('pvp:notification', source, 
            string.format("Seu FixedID: %s, PlayerID: %s", playerData.fixed_id, source), 
            "info"
        )
    else
        TriggerClientEvent('pvp:notification', source, "FixedID não encontrado", "error")
    end
end, false)

-- Função auxiliar para obter tamanho da tabela
function GetTableSize(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

-- Exportar funções para uso em outros scripts
exports('LoadPlayerData', function(playerId)
    return PlayerPersistence.LoadPlayerData(playerId)
end)

exports('SavePlayerData', function(playerId, playerData)
    return PlayerPersistence.SavePlayerData(playerId, playerData)
end)

exports('GetPlayerIdentifier', function(playerId)
    return PlayerPersistence.GetPlayerIdentifier(playerId)
end)

exports('FindPlayerByIdentifier', function(identifier)
    return PlayerPersistence.FindPlayerByIdentifier(identifier)
end)

exports('CleanupOldEntries', function(newPlayerId, identifier)
    return PlayerPersistence.CleanupOldEntries(newPlayerId, identifier)
end)

exports('CleanupAllDuplicates', function()
    return PlayerPersistence.CleanupAllDuplicates()
end) 

-- Export extra: mostrar fixed_id do jogador
RegisterNetEvent('pvp:showMyFixedId')
AddEventHandler('pvp:showMyFixedId', function()
    local src = source
    local identifier = GetPlayerIdentifier(src)
    if not identifier then return end
    local result = exports.oxmysql:query_async("SELECT fixed_id FROM player_data WHERE identifier = ?", {identifier})
    if result[1] and result[1].fixed_id then
        TriggerClientEvent('chat:addMessage', src, { args = { '^2Seu ID fixo:', tostring(result[1].fixed_id) } })
    else
        TriggerClientEvent('chat:addMessage', src, { args = { '^1Erro ao buscar seu ID fixo!' } })
    end
end) 

-- Evento para quando o jogador spawna (após playerJoining)
AddEventHandler('playerSpawned', function()
    local src = source
    local playerData = GetPlayerData(src)
    
    if playerData then
        print("[DEBUG] playerSpawned para jogador:", src, "FixedID:", playerData.fixed_id or "N/A")
        
        -- Enviar fixed_id para o cliente
        TriggerClientEvent('pvp:setFixedId', src, playerData.fixed_id)
        
        -- Atualizar HUD com fixed_id
        TriggerClientEvent('pvp:updateHUD', src, {
            fixed_id = playerData.fixed_id,
            name = playerData.name,
            kills = playerData.kills,
            deaths = playerData.deaths,
            money = playerData.money
        })
    end
end)

-- Evento para quando o jogador morre
AddEventHandler('playerDeath', function(killerId, deathReason)
    local src = source
    local playerData = GetPlayerData(src)
    
    if playerData then
        print("[DEBUG] playerDeath para jogador:", src, "FixedID:", playerData.fixed_id or "N/A", "Killer:", killerId or "N/A")
        
        -- Incrementar deaths
        playerData.deaths = playerData.deaths + 1
        
        -- Salvar dados
        PlayerPersistence.SavePlayerData(src, playerData)
        
        -- Atualizar HUD
        TriggerClientEvent('pvp:updateHUD', src, {
            fixed_id = playerData.fixed_id,
            name = playerData.name,
            kills = playerData.kills,
            deaths = playerData.deaths,
            money = playerData.money
        })
    end
end)

-- Evento para quando o jogador mata outro
AddEventHandler('playerKill', function(victimId)
    local src = source
    local playerData = GetPlayerData(src)
    
    if playerData then
        print("[DEBUG] playerKill para jogador:", src, "FixedID:", playerData.fixed_id or "N/A", "Victim:", victimId or "N/A")
        
        -- Incrementar kills
        playerData.kills = playerData.kills + 1
        
        -- Salvar dados
        PlayerPersistence.SavePlayerData(src, playerData)
        
        -- Atualizar HUD
        TriggerClientEvent('pvp:updateHUD', src, {
            fixed_id = playerData.fixed_id,
            name = playerData.name,
            kills = playerData.kills,
            deaths = playerData.deaths,
            money = playerData.money
        })
    end
end) 