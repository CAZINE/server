/**
 * Sistema de Notificação NUI
 * Criado do zero com base na estrutura HTML/CSS existente
 */

class NotificationSystem {
    constructor() {
        this.notifications = [];
        this.container = null;
        this.notificationLocks = new Map(); // Sistema de locks simples
        this.lastNotificationTime = 0;
        this.minTimeBetweenNotifications = 100; // 100ms mínimo
        this.init();
    }

    init() {
        // Verificar se já foi inicializado
        if (this.initialized) {
            console.log('[NOTIFY] Sistema já foi inicializado, ignorando...');
            return;
        }
        
        // Criar container principal se não existir
        this.createContainer();
        
        // Escutar eventos do FiveM
        this.setupEventListeners();
        
        this.initialized = true;
        
    }

    createContainer() {
        // Verificar se já existe um container
        let existingContainer = document.querySelector('.notifies');
        
        if (!existingContainer) {
            // Criar estrutura HTML baseada no CSS
            const container = document.createElement('div');
            container.className = 'notifies';
            container.id = 'notification-container';
            
            // Adicionar ao body
            document.body.appendChild(container);
            this.container = container;
            
        } else {
            this.container = existingContainer;
       
        }
    }

    setupEventListeners() {
        // Verificar se já foram configurados os listeners
        if (this.listenersSetup) {
            console.log('[NOTIFY] Event listeners já configurados, ignorando...');
            return;
        }
        
        // Escutar eventos do FiveM
        window.addEventListener('message', (event) => {
            const data = event.data;
            
            switch (data.type) {
                case 'showNotification':
                    this.showNotification({
                        type: data.notificationType || 'info',
                        title: data.title || 'Notificação',
                        message: data.message || '',
                        duration: data.duration || 5000,
                        persistent: data.persistent || false
                    });
                    break;
                case 'hideNotification':
                    this.hideNotification(data.id);
                    break;
                case 'clearAll':
                    this.clearAll();
                    break;
                case 'clearDuplicates':
                    this.clearDuplicates();
                    break;
            }
        });
        
        this.listenersSetup = true;
        

        // Notificar que NUI está pronto
        fetch(`https://${GetParentResourceName()}/nuiReady`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({})
        }).catch(() => {});

        // Eventos de teclado para debug (opcional)
        document.addEventListener('keydown', (event) => {
            if (event.key === 'F1') {
                this.showNotification({
                    type: 'success',
                    title: 'Teste',
                    message: 'Notificação de teste criada!',
                    duration: 3000
                });
            }
        });
    }

    showNotification(options) {
        const currentTime = Date.now();
        const lockDuration = 5000; // 5 segundos
        
        // Verificar tempo mínimo entre notificações (anti-spam)
        if (currentTime - this.lastNotificationTime < this.minTimeBetweenNotifications) {
            console.log('[NOTIFY] Bloqueada por tempo mínimo entre notificações');
            return null;
        }
        
        // Criar chave única para verificação de duplicatas
        const notificationKey = `${options.title || 'Notificação'}|${options.message || ''}|${options.type || 'info'}`;
        
        // Limpar locks antigos
        for (const [key, timestamp] of this.notificationLocks.entries()) {
            if (currentTime - timestamp > lockDuration) {
                this.notificationLocks.delete(key);
            }
        }
        
        // Verificar se já existe um lock ativo para esta notificação
        if (this.notificationLocks.has(notificationKey)) {
            const timeDiff = currentTime - this.notificationLocks.get(notificationKey);
            if (timeDiff < lockDuration) {
                console.log('[NOTIFY] Bloqueada notificação duplicada no JavaScript:', notificationKey, 'tempo:', timeDiff + 'ms');
                return null;
            }
        }
        
        // Verificar se já existe uma notificação idêntica ativa
        const existingNotification = this.notifications.find(n => 
            n.title === options.title && 
            n.message === options.message && 
            n.type === options.type
        );

        if (existingNotification) {
            console.log('[NOTIFY] Notificação idêntica já existe, ignorando:', notificationKey);
            return existingNotification.id;
        }
        


        const notification = {
            id: this.generateId(),
            type: options.type || 'info',
            title: options.title || 'Notificação',
            message: options.message || '',
            duration: options.duration || 5000,
            persistent: options.persistent || false,
            element: null,
            timeoutId: null
        };

        // Criar elemento da notificação
        const notificationElement = this.createNotificationElement(notification);
        notification.element = notificationElement;

        // Adicionar ao container
        this.container.appendChild(notificationElement);

        // Adicionar à lista
        this.notifications.push(notification);

        // Trigger animação de entrada
        setTimeout(() => {
            notificationElement.classList.add('notifies-enter-active');
        }, 10);

        // Auto-remover se não for persistente
        if (!notification.persistent && notification.duration > 0) {
            notification.timeoutId = setTimeout(() => {
                this.hideNotification(notification.id);
            }, notification.duration);
        }

        // Criar lock para esta notificação
        this.notificationLocks.set(notificationKey, currentTime);
        this.lastNotificationTime = currentTime;

        return notification.id;
    }

    createNotificationElement(notification) {
        const element = document.createElement('div');
        element.className = `notifies__notification notifies__notification--${notification.type}`;
        element.setAttribute('data-id', notification.id);

        // Criar header com ícone e título
        const header = document.createElement('div');
        header.className = 'notifies__header';

        // Criar ícone
        const icon = this.createIcon(notification.type, notification.duration);
        header.appendChild(icon);

        // Criar título
        const title = document.createElement('div');
        title.className = 'notifies__title';
        title.textContent = notification.title;
        header.appendChild(title);

        element.appendChild(header);

        // Criar mensagem se existir
        if (notification.message) {
            const messageContainer = document.createElement('div');
            messageContainer.className = 'notifies__message';
            
            const messageText = document.createElement('div');
            messageText.className = 'notifies__text';
            messageText.textContent = notification.message;
            
            messageContainer.appendChild(messageText);
            element.appendChild(messageContainer);
        }

        return element;
    }

    createIcon(type, duration) {
        const iconContainer = document.createElement('div');
        iconContainer.className = `notifies__icon notifies__icon--${type}`;

        // Criar SVG do ícone baseado no tipo
        const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
        svg.setAttribute('width', '24');
        svg.setAttribute('height', '24');
        svg.setAttribute('viewBox', '0 0 24 24');
        svg.setAttribute('fill', 'none');

        // Definir ícone baseado no tipo
        let iconPath = '';
        switch (type) {
            case 'success':
            case 'green':
                iconPath = 'M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z';
                break;
            case 'error':
            case 'red':
                iconPath = 'M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z';
                break;
            case 'warning':
            case 'yellow':
                iconPath = 'M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z';
                break;
            case 'info':
            case 'blue':
            default:
                iconPath = 'M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z';
                break;
        }

        const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
        path.setAttribute('stroke', 'currentColor');
        path.setAttribute('stroke-width', '2');
        path.setAttribute('stroke-linecap', 'round');
        path.setAttribute('stroke-linejoin', 'round');
        path.setAttribute('d', iconPath);

        svg.appendChild(path);
        iconContainer.appendChild(svg);

        // Adicionar barra de progresso se tiver duração
        if (duration > 0) {
            const progressContainer = document.createElement('div');
            progressContainer.className = 'notifies__icon__progress';
            
            const progressSvg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
            progressSvg.setAttribute('width', '26');
            progressSvg.setAttribute('height', '26');
            progressSvg.setAttribute('viewBox', '0 0 26 26');
            
            const circle = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
            circle.setAttribute('cx', '13');
            circle.setAttribute('cy', '13');
            circle.setAttribute('r', '10');
            circle.setAttribute('fill', 'none');
            circle.setAttribute('stroke', 'currentColor');
            circle.setAttribute('stroke-width', '2');
            circle.setAttribute('stroke-dasharray', '62.83');
            circle.setAttribute('stroke-dashoffset', '62.83');
            circle.style.animation = `progress ${duration}ms linear forwards`;
            
            progressSvg.appendChild(circle);
            progressContainer.appendChild(progressSvg);
            iconContainer.appendChild(progressContainer);
        }

        return iconContainer;
    }

    hideNotification(id) {
        const notification = this.notifications.find(n => n.id === id);
        if (!notification) return;

        const element = notification.element;
        if (!element) return;

        // Limpar timeout se existir
        if (notification.timeoutId) {
            clearTimeout(notification.timeoutId);
            notification.timeoutId = null;
        }

        // Adicionar classe de saída
        element.classList.add('notifies-leave-active');

        // Remover após animação
        setTimeout(() => {
            if (element.parentNode) {
                element.parentNode.removeChild(element);
            }
            
            // Remover da lista
            const index = this.notifications.findIndex(n => n.id === id);
            if (index > -1) {
                this.notifications.splice(index, 1);
            }
        }, 100);
    }

    clearAll() {
        this.notifications.forEach(notification => {
            this.hideNotification(notification.id);
        });
    }

    clearDuplicates() {
        const seen = new Set();
        const duplicates = [];
        
        // Identificar duplicatas
        this.notifications.forEach(notification => {
            const key = `${notification.title}|${notification.message}|${notification.type}`;
            if (seen.has(key)) {
                duplicates.push(notification.id);
            } else {
                seen.add(key);
            }
        });
        
        // Remover duplicatas
        duplicates.forEach(id => {
            this.hideNotification(id);
        });
    }

    generateId() {
        return 'notification_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
    }

    // Métodos públicos para uso externo
    success(title, message, duration = 5000) {
        return this.showNotification({
            type: 'success',
            title,
            message,
            duration
        });
    }

    error(title, message, duration = 7000) {
        return this.showNotification({
            type: 'error',
            title,
            message,
            duration
        });
    }

    warning(title, message, duration = 6000) {
        return this.showNotification({
            type: 'warning',
            title,
            message,
            duration
        });
    }

    info(title, message, duration = 5000) {
        return this.showNotification({
            type: 'info',
            title,
            message,
            duration
        });
    }

    // Método para notificações customizadas
    custom(options) {
        return this.showNotification(options);
    }
}

// Sistema Singleton para evitar inicialização dupla
let notificationSystemInstance = null;

function initializeNotificationSystem() {
    if (notificationSystemInstance) {
   
        return notificationSystemInstance;
    }
    
    notificationSystemInstance = new NotificationSystem();
    
    // Expor métodos globais para facilitar uso
    window.showNotification = (options) => notificationSystemInstance.showNotification(options);
    window.hideNotification = (id) => notificationSystemInstance.hideNotification(id);
    window.clearNotifications = () => notificationSystemInstance.clearAll();
    
    // Métodos de conveniência
    window.notifySuccess = (title, message, duration) => notificationSystemInstance.success(title, message, duration);
    window.notifyError = (title, message, duration) => notificationSystemInstance.error(title, message, duration);
    window.notifyWarning = (title, message, duration) => notificationSystemInstance.warning(title, message, duration);
    window.notifyInfo = (title, message, duration) => notificationSystemInstance.info(title, message, duration);
    
    return notificationSystemInstance;
}

// Inicializar sistema quando o DOM estiver pronto
document.addEventListener('DOMContentLoaded', () => {
    initializeNotificationSystem();
});

// Fallback para caso o DOM já esteja carregado
if (document.readyState === 'loading') {
    // DOM ainda carregando, aguardar evento
} else {
    // DOM já carregado, inicializar imediatamente
    initializeNotificationSystem();
}
