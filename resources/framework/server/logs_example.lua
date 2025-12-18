-- Exemplo de como usar o sistema de logs em outros recursos
-- Este arquivo demonstra como integrar o sistema de logs em outros scripts

-- Para usar o sistema de logs em outros recursos, você pode:

-- 1. Importar o sistema de logs
local Logs = exports['framework']:GetLogs()

-- 2. Exemplos de uso:

-- Log de kill
-- Logs.logKill(killerId, victimId, weaponName)

-- Log de spawn
-- Logs.logSpawn(playerId, location)

-- Log de conexão (automático)
-- Logs.logConnect(playerId)

-- Log de desconexão (automático)
-- Logs.logDisconnect(playerId, reason)

-- Log de ação administrativa
-- Logs.logAdmin(playerId, "BAN", targetName, "Motivo do ban")

-- Log genérico
-- Logs.log("EVENTO", "Mensagem do evento", playerId)

-- Exemplo de integração em um comando de ban:
--[[
RegisterCommand('ban', function(source, args)
    local targetId = tonumber(args[1])
    local reason = table.concat(args, " ", 2) or "Sem motivo"
    
    if targetId then
        local targetName = GetPlayerName(targetId)
        -- Executar ban...
        
        -- Log da ação
        if Logs and Logs.logAdmin then
            Logs.logAdmin(source, "BAN", targetName, reason)
        end
    end
end)
--]]

-- Exemplo de integração em um sistema de zonas:
--[[
RegisterNetEvent('playerEnteredZone')
AddEventHandler('playerEnteredZone', function(zoneName)
    local playerId = source
    
    -- Lógica da zona...
    
    -- Log da entrada na zona
    if Logs and Logs.log then
        Logs.log("ZONE_ENTER", "Jogador entrou na zona: " .. zoneName, playerId)
    end
end)
--]]

-- Exemplo de integração em um sistema de armas:
--[[
RegisterNetEvent('weaponPurchased')
AddEventHandler('weaponPurchased', function(weaponName, price)
    local playerId = source
    
    -- Lógica da compra...
    
    -- Log da compra
    if Logs and Logs.log then
        Logs.log("WEAPON_PURCHASE", "Comprou " .. weaponName .. " por $" .. price, playerId)
    end
end)
--]]

print("^2[LOGS] Sistema de logs carregado com sucesso!^0")
print("^3[LOGS] Use exports['framework']:GetLogs() para acessar o sistema^0") 