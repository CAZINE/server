-- Exemplos de uso do Sistema de Notificação
-- Este arquivo demonstra como usar o sistema em outros recursos

-- ============================================
-- EXEMPLOS DE USO BÁSICO
-- ============================================

-- 1. Notificação simples de sucesso
RegisterCommand('test1', function()
    exports['notify']:NotifySuccess('Sucesso!', 'Operação realizada com sucesso!')
end, false)

-- 2. Notificação de erro
RegisterCommand('test2', function()
    exports['notify']:NotifyError('Erro!', 'Algo deu errado na operação.')
end, false)

-- 3. Notificação de aviso
RegisterCommand('test3', function()
    exports['notify']:NotifyWarning('Atenção!', 'Verifique suas configurações.')
end, false)

-- 4. Notificação informativa
RegisterCommand('test4', function()
    exports['notify']:NotifyInfo('Informação', 'Esta é uma informação importante.')
end, false)

-- ============================================
-- EXEMPLOS AVANÇADOS
-- ============================================

-- 5. Notificação com duração customizada
RegisterCommand('test5', function()
    exports['notify']:NotifySuccess('Temporária', 'Esta notificação desaparecerá em 2 segundos.', 2000)
end, false)

-- 6. Notificação persistente (não desaparece automaticamente)
RegisterCommand('test6', function()
    exports['notify']:NotifyCustom({
        type = 'warning',
        title = 'Persistente',
        message = 'Esta notificação não desaparece automaticamente.',
        persistent = true
    })
end, false)

-- 7. Múltiplas notificações em sequência
RegisterCommand('test7', function()
    exports['notify']:NotifyInfo('Processo', 'Iniciando processo...')
    Citizen.Wait(1000)
    exports['notify']:NotifySuccess('Processo', 'Processo concluído!')
end, false)

-- ============================================
-- EXEMPLOS DE INTEGRAÇÃO COM OUTROS SISTEMAS
-- ============================================

-- 8. Exemplo com sistema de inventário
RegisterCommand('test8', function()
    local itemName = 'Pão'
    local quantity = 5
    
    exports['notify']:NotifySuccess('Inventário', 'Você recebeu ' .. quantity .. 'x ' .. itemName)
end, false)

-- 9. Exemplo com sistema de dinheiro
RegisterCommand('test9', function()
    local amount = 1000
    
    exports['notify']:NotifySuccess('Banco', 'Você recebeu $' .. amount .. ' na sua conta')
end, false)

-- 10. Exemplo com sistema de veículos
RegisterCommand('test10', function()
    local vehicleName = 'Adder'
    
    exports['notify']:NotifyInfo('Veículo', 'Você spawnou um ' .. vehicleName)
end, false)

-- ============================================
-- EXEMPLOS DE USO EM EVENTOS
-- ============================================

-- 11. Evento de login
RegisterNetEvent('player:login')
AddEventHandler('player:login', function(playerName)
    exports['notify']:NotifySuccess('Login', 'Bem-vindo, ' .. playerName .. '!')
end)

-- 12. Evento de logout
RegisterNetEvent('player:logout')
AddEventHandler('player:logout', function()
    exports['notify']:NotifyInfo('Logout', 'Até logo!')
end)

-- 13. Evento de morte
RegisterNetEvent('player:died')
AddEventHandler('player:died', function()
    exports['notify']:NotifyError('Morte', 'Você morreu!')
end)

-- ============================================
-- EXEMPLOS DE USO EM CALLBACKS
-- ============================================

-- 14. Exemplo com callback de banco
RegisterNetEvent('bank:deposit')
AddEventHandler('bank:deposit', function(success, amount)
    if success then
        exports['notify']:NotifySuccess('Banco', 'Depósito de $' .. amount .. ' realizado!')
    else
        exports['notify']:NotifyError('Banco', 'Falha no depósito!')
    end
end)

-- 15. Exemplo com callback de trabalho
RegisterNetEvent('job:completed')
AddEventHandler('job:completed', function(jobName, payment)
    exports['notify']:NotifySuccess('Trabalho', 'Trabalho "' .. jobName .. '" concluído! Pagamento: $' .. payment)
end)

-- ============================================
-- COMANDOS DE TESTE GERAL
-- ============================================

-- Comando para testar todos os tipos
RegisterCommand('notifyall', function()
    exports['notify']:NotifySuccess('Sucesso', 'Esta é uma notificação de sucesso!')
    Citizen.Wait(500)
    exports['notify']:NotifyError('Erro', 'Esta é uma notificação de erro!')
    Citizen.Wait(500)
    exports['notify']:NotifyWarning('Aviso', 'Esta é uma notificação de aviso!')
    Citizen.Wait(500)
    exports['notify']:NotifyInfo('Info', 'Esta é uma notificação informativa!')
end, false)

-- Comando para limpar todas as notificações
RegisterCommand('notifyclear', function()
    TriggerEvent('notify:clear')
end, false)

-- ============================================
-- DOCUMENTAÇÃO DE USO
-- ============================================

--[[
COMO USAR EM OUTROS RECURSOS:

1. Adicione 'notify' às dependências do seu fxmanifest.lua:
   dependencies = {
       'notify'
   }

2. Use as funções exportadas:
   exports['notify']:NotifySuccess(title, message, duration)
   exports['notify']:NotifyError(title, message, duration)
   exports['notify']:NotifyWarning(title, message, duration)
   exports['notify']:NotifyInfo(title, message, duration)
   exports['notify']:NotifyCustom(options)

3. Ou use os eventos:
   TriggerEvent('notify:show', {type = 'success', title = 'Título', message = 'Mensagem'})
   TriggerEvent('notify:hide', notificationId)
   TriggerEvent('notify:clear')

PARÂMETROS:
- title: Título da notificação (string)
- message: Mensagem da notificação (string)
- duration: Duração em milissegundos (number, opcional)
- persistent: Se a notificação é persistente (boolean, opcional)

TIPOS DISPONÍVEIS:
- 'success' ou 'green': Notificação de sucesso (verde)
- 'error' ou 'red': Notificação de erro (vermelho)
- 'warning' ou 'yellow': Notificação de aviso (amarelo)
- 'info' ou 'blue': Notificação informativa (azul)
--]]
