-- Sistema de Notificação NUI - Cliente
-- Integração com o sistema JavaScript criado

local isNUIReady = false
local notificationQueue = {}
local isProcessingQueue = false

-- Aguardar NUI estar pronto
RegisterNUICallback('nuiReady', function(data, cb)
    isNUIReady = true
    -- Processar fila de notificações pendentes
    processNotificationQueue()
    cb('ok')
end)


-- Função para processar fila de notificações
function processNotificationQueue()
    if isProcessingQueue or not isNUIReady then return end
    
    isProcessingQueue = true
    
    for i = 1, #notificationQueue do
        local notification = notificationQueue[i]
        SendNUIMessage({
            type = 'showNotification',
            notificationType = notification.type or 'info',
            title = notification.title or 'Notificação',
            message = notification.message or '',
            duration = notification.duration or 5000,
            persistent = notification.persistent or false
        })
        
        -- Pequeno delay entre notificações para evitar spam
        Citizen.Wait(50)
    end
    
    -- Limpar fila
    notificationQueue = {}
    isProcessingQueue = false
end

-- Sistema de bloqueio global mais rigoroso
local notificationLocks = {}
local lockDuration = 5000 -- 5 segundos
local lastNotificationTime = 0
local minTimeBetweenNotifications = 100 -- 100ms mínimo entre notificações

-- Função para limpar locks antigos
local function cleanLocks()
    local currentTime = GetGameTimer()
    for key, timestamp in pairs(notificationLocks) do
        if currentTime - timestamp > lockDuration then
            notificationLocks[key] = nil
        end
    end
end

-- Função principal para mostrar notificações
local function ShowNotification(data)
    -- Limpar locks antigos
    cleanLocks()
    
    local currentTime = GetGameTimer()
    
    -- Verificar tempo mínimo entre notificações (anti-spam)
    if currentTime - lastNotificationTime < minTimeBetweenNotifications then
       
        return
    end
    
    -- Criar chave única para a notificação
    local notificationKey = (data.title or 'Notificação') .. '|' .. (data.message or '') .. '|' .. (data.type or 'info')
    
    -- Verificar se já existe um lock ativo para esta notificação
    if notificationLocks[notificationKey] then
        local timeDiff = currentTime - notificationLocks[notificationKey]
        if timeDiff < lockDuration then
            -- Lock ativo, ignorar notificação
            print('^3[NOTIFY]^7 Bloqueada notificação duplicada: ' .. notificationKey .. ' (tempo: ' .. timeDiff .. 'ms)')
            return
        end
    end
    
    -- Verificar se já existe uma notificação idêntica na fila
    for i = 1, #notificationQueue do
        local queuedNotification = notificationQueue[i]
        if queuedNotification.title == data.title and 
           queuedNotification.message == data.message and 
           queuedNotification.type == data.type then
            -- Notificação idêntica já está na fila, ignorar
            print('^3[NOTIFY]^7 Bloqueada notificação na fila: ' .. notificationKey)
            return
        end
    end

    -- Criar lock para esta notificação
    notificationLocks[notificationKey] = currentTime
    lastNotificationTime = currentTime


    if not isNUIReady then
        -- Adicionar à fila se NUI não estiver pronto
        table.insert(notificationQueue, data)
        return
    end

    SendNUIMessage({
        type = 'showNotification',
        notificationType = data.type or 'info',
        title = data.title or 'Notificação',
        message = data.message or '',
        duration = data.duration or 5000,
        persistent = data.persistent or false
    })
end

-- Eventos do servidor
RegisterNetEvent('notify:show')
AddEventHandler('notify:show', function(data)
    ShowNotification(data)
end)

RegisterNetEvent('notify:hide')
AddEventHandler('notify:hide', function(id)
    if isNUIReady then
        SendNUIMessage({
            type = 'hideNotification',
            id = id
        })
    end
end)

RegisterNetEvent('notify:clear')
AddEventHandler('notify:clear', function()
    if isNUIReady then
        SendNUIMessage({
            type = 'clearAll'
        })
    end
end)

-- Funções de conveniência para uso direto
function NotifySuccess(title, message, duration)
    ShowNotification({
        type = 'success',
        title = title,
        message = message,
        duration = duration or 5000
    })
end

function NotifyError(title, message, duration)
    ShowNotification({
        type = 'error',
        title = title,
        message = message,
        duration = duration or 7000
    })
end

function NotifyWarning(title, message, duration)
    ShowNotification({
        type = 'warning',
        title = title,
        message = message,
        duration = duration or 6000
    })
end

function NotifyInfo(title, message, duration)
    ShowNotification({
        type = 'info',
        title = title,
        message = message,
        duration = duration or 5000
    })
end

-- Função para notificações customizadas
function NotifyCustom(options)
    ShowNotification(options)
end

-- Comandos de teste (remover em produção)
RegisterCommand('notifytest', function()
    NotifySuccess('Sucesso!', 'Esta é uma notificação de sucesso.')
    Citizen.Wait(1000)
    NotifyError('Erro!', 'Esta é uma notificação de erro.')
    Citizen.Wait(1000)
    NotifyWarning('Atenção!', 'Esta é uma notificação de aviso.')
    Citizen.Wait(1000)
    NotifyInfo('Informação', 'Esta é uma notificação informativa.')
end, false)

RegisterCommand('notifyclear', function()
    TriggerEvent('notify:clear')
end, false)

RegisterCommand('notifyduptest', function()
    -- Teste de duplicação - deve mostrar apenas uma notificação
    print('^2[NOTIFY]^7 Iniciando teste de duplicação...')
    NotifySuccess('NOTIFICAÇÃO', 'Teleportado para o jogador 1')
    NotifySuccess('NOTIFICAÇÃO', 'Teleportado para o jogador 1')
    NotifySuccess('NOTIFICAÇÃO', 'Teleportado para o jogador 1')
    NotifySuccess('NOTIFICAÇÃO', 'Teleportado para o jogador 1')
    NotifySuccess('NOTIFICAÇÃO', 'Teleportado para o jogador 1')
    NotifySuccess('NOTIFICAÇÃO', 'Teleportado para o jogador 1')
    NotifySuccess('NOTIFICAÇÃO', 'Teleportado para o jogador 1')
    NotifySuccess('NOTIFICAÇÃO', 'Teleportado para o jogador 1')
    print('^2[NOTIFY]^7 Teste de duplicação executado - deve mostrar apenas 1 notificação')
end, false)

RegisterCommand('notifytestrapido', function()
    -- Teste muito rápido de duplicação
    print('^2[NOTIFY]^7 Teste rápido de duplicação...')
    for i = 1, 10 do
        NotifySuccess('TESTE RÁPIDO', 'Notificação ' .. i)
    end
    print('^2[NOTIFY]^7 Teste rápido executado - deve mostrar apenas 1 notificação')
end, false)

RegisterCommand('notifyextremo', function()
    -- Teste extremo - múltiplas notificações idênticas simultâneas
    print('^2[NOTIFY]^7 Teste EXTREMO iniciado...')
    
    -- Enviar 20 notificações idênticas ao mesmo tempo
    for i = 1, 20 do
        Citizen.CreateThread(function()
            NotifySuccess('TESTE EXTREMO', 'Notificação idêntica ' .. i)
        end)
    end
    
    print('^2[NOTIFY]^7 Teste EXTREMO executado - deve mostrar apenas 1 notificação')
end, false)

RegisterCommand('notify1', function()
    -- Comando simples para testar 1 notificação
    print('^2[NOTIFY]^7 ===== INICIANDO TESTE =====')
    print('^2[NOTIFY]^7 Enviando 1 notificação de teste...')
    NotifySuccess('TESTE', 'Esta é uma notificação de teste')
    print('^2[NOTIFY]^7 Notificação enviada!')
    print('^2[NOTIFY]^7 ===== TESTE CONCLUÍDO =====')
end, false)

-- Função para limpar notificações duplicadas
function ClearDuplicateNotifications()
    if isNUIReady then
        SendNUIMessage({
            type = 'clearDuplicates'
        })
    end
end

-- Exportar funções para outros recursos
exports('NotifySuccess', NotifySuccess)
exports('NotifyError', NotifyError)
exports('NotifyWarning', NotifyWarning)
exports('NotifyInfo', NotifyInfo)
exports('NotifyCustom', NotifyCustom)
exports('ShowNotification', ShowNotification)
exports('ClearDuplicates', ClearDuplicateNotifications) 