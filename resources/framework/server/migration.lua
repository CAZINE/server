-- Script de Migração para Sistema de IDs Fixos
-- Execute este script uma vez para migrar dados existentes

local Migration = {}

-- Função para verificar se a migração já foi executada
local function IsMigrationCompleted()
    local result = exports.oxmysql:query_async("SHOW COLUMNS FROM player_data LIKE 'fixed_id'")
    return result and #result > 0
end

-- Função para criar a coluna fixed_id se não existir
local function CreateFixedIdColumn()
    local success = pcall(function()
        return exports.oxmysql:execute_async("ALTER TABLE player_data ADD COLUMN IF NOT EXISTS fixed_id INT UNIQUE AFTER id")
    end)
    
    if success then
        print("[MIGRATION] Coluna fixed_id criada/verificada com sucesso!")
        return true
    else
        print("[MIGRATION] ERRO ao criar coluna fixed_id!")
        return false
    end
end

-- Função para atribuir IDs fixos aos jogadores existentes
local function AssignFixedIdsToExistingPlayers()
    local result = exports.oxmysql:query_async("SELECT id, identifier, player_name FROM player_data WHERE fixed_id IS NULL ORDER BY id ASC")
    
    if not result or #result == 0 then
        print("[MIGRATION] Nenhum jogador sem fixed_id encontrado!")
        return 0
    end
    
    local assignedCount = 0
    local nextFixedId = 1
    
    -- Primeiro, encontrar o próximo ID fixo disponível
    local existingFixedIds = exports.oxmysql:query_async("SELECT fixed_id FROM player_data WHERE fixed_id IS NOT NULL ORDER BY fixed_id ASC")
    local usedIds = {}
    
    if existingFixedIds then
        for _, row in ipairs(existingFixedIds) do
            usedIds[row.fixed_id] = true
        end
    end
    
    -- Encontrar o próximo ID disponível
    while usedIds[nextFixedId] do
        nextFixedId = nextFixedId + 1
    end
    
    -- Atribuir IDs fixos
    for _, player in ipairs(result) do
        if nextFixedId <= Config.FixedID.maxPlayers then
            local success = pcall(function()
                return exports.oxmysql:execute_async("UPDATE player_data SET fixed_id = ? WHERE id = ?", {nextFixedId, player.id})
            end)
            
            if success then
                print(string.format("[MIGRATION] Jogador %s (ID: %s) recebeu fixed_id: %s", 
                    player.player_name or "Desconhecido", 
                    player.id, 
                    nextFixedId
                ))
                assignedCount = assignedCount + 1
                nextFixedId = nextFixedId + 1
                
                -- Encontrar o próximo ID disponível
                while usedIds[nextFixedId] do
                    nextFixedId = nextFixedId + 1
                end
            else
                print(string.format("[MIGRATION] ERRO ao atribuir fixed_id %s para jogador %s", nextFixedId, player.id))
            end
        else
            print("[MIGRATION] Limite de jogadores atingido! Não foi possível atribuir mais IDs fixos.")
            break
        end
    end
    
    return assignedCount
end

-- Função para verificar integridade dos dados
local function VerifyDataIntegrity()
    local result = exports.oxmysql:query_async([[
        SELECT 
            COUNT(*) as total_players,
            COUNT(fixed_id) as players_with_fixed_id,
            COUNT(DISTINCT fixed_id) as unique_fixed_ids,
            MIN(fixed_id) as min_fixed_id,
            MAX(fixed_id) as max_fixed_id
        FROM player_data
    ]])
    
    if result and result[1] then
        local data = result[1]
        print("[MIGRATION] Verificação de integridade:")
        print(string.format("  - Total de jogadores: %s", data.total_players))
        print(string.format("  - Jogadores com fixed_id: %s", data.players_with_fixed_id))
        print(string.format("  - IDs fixos únicos: %s", data.unique_fixed_ids))
        print(string.format("  - Menor fixed_id: %s", data.min_fixed_id or "N/A"))
        print(string.format("  - Maior fixed_id: %s", data.max_fixed_id or "N/A"))
        
        -- Verificar duplicatas
        local duplicates = exports.oxmysql:query_async([[
            SELECT fixed_id, COUNT(*) as count
            FROM player_data 
            WHERE fixed_id IS NOT NULL 
            GROUP BY fixed_id 
            HAVING COUNT(*) > 1
        ]])
        
        if duplicates and #duplicates > 0 then
            print("[MIGRATION] ATENÇÃO: Encontrados IDs fixos duplicados!")
            for _, dup in ipairs(duplicates) do
                print(string.format("  - Fixed_id %s aparece %s vezes", dup.fixed_id, dup.count))
            end
            return false
        else
            print("[MIGRATION] Nenhuma duplicata encontrada!")
            return true
        end
    end
    
    return false
end

-- Função principal de migração
function Migration.Run()
    print("[MIGRATION] Iniciando migração para sistema de IDs fixos...")
    
    -- Verificar se oxmysql está disponível
    if not exports.oxmysql then
        print("[MIGRATION] ERRO: oxmysql não está disponível!")
        return false
    end
    
    -- Verificar se a tabela player_data existe
    local tableExists = exports.oxmysql:query_async("SHOW TABLES LIKE 'player_data'")
    if not tableExists or #tableExists == 0 then
        print("[MIGRATION] Tabela player_data não encontrada! Criando...")
        local success = pcall(function()
            return exports.oxmysql:execute_async([[
                CREATE TABLE IF NOT EXISTS player_data (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    fixed_id INT UNIQUE,
                    identifier VARCHAR(50) UNIQUE NOT NULL,
                    player_name VARCHAR(50) NOT NULL,
                    kills INT DEFAULT 0,
                    deaths INT DEFAULT 0,
                    money INT DEFAULT 1000,
                    last_login TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            ]])
        end)
        
        if not success then
            print("[MIGRATION] ERRO ao criar tabela player_data!")
            return false
        end
    end
    
    -- Criar coluna fixed_id se não existir
    if not CreateFixedIdColumn() then
        return false
    end
    
    -- Atribuir IDs fixos aos jogadores existentes
    local assignedCount = AssignFixedIdsToExistingPlayers()
    print(string.format("[MIGRATION] %s jogadores receberam IDs fixos", assignedCount))
    
    -- Verificar integridade dos dados
    if VerifyDataIntegrity() then
        print("[MIGRATION] Migração concluída com sucesso!")
        return true
    else
        print("[MIGRATION] ERRO na verificação de integridade!")
        return false
    end
end

-- Comando para executar migração
RegisterCommand('migratefixedids', function(source, args)
    if source == 0 then -- Console only
        print("[MIGRATION] Executando migração...")
        local success = Migration.Run()
        if success then
            print("[MIGRATION] Migração executada com sucesso!")
        else
            print("[MIGRATION] ERRO na migração!")
        end
    else
        TriggerClientEvent('pvp:notification', source, "Comando disponível apenas no console", "error")
    end
end, false)

-- Comando para verificar status da migração
RegisterCommand('checkmigration', function(source, args)
    if source == 0 then -- Console only
        print("[MIGRATION] Verificando status da migração...")
        VerifyDataIntegrity()
    else
        TriggerClientEvent('pvp:notification', source, "Comando disponível apenas no console", "error")
    end
end, false)

-- Exportar função de migração
exports('RunMigration', Migration.Run) 