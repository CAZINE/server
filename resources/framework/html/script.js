let respawnInterval = null;
let respawnTime = 0;
let canRespawn = false;

function showSpectateHUD(data) {
    document.getElementById('spectate-hud').style.display = 'block';
    document.querySelector('.spectate-viewers').textContent = data.viewers;
    document.querySelector('.spectate-name').textContent = data.name;
    document.querySelector('.level-label').textContent = 'LEVEL';
    document.querySelector('.level-value').textContent = data.level ? data.level : '';
    document.querySelector('.spectate-id').textContent = '#' + data.id;
    document.querySelector('.spectate-health-fill').style.width = data.health + '%';
    
    // Atualizar ping do player
    if (data.ping !== undefined) {
        updatePlayerPing(data.ping);
    }
    
    startRespawnCounter();
}

function updateSpectateHealth(data) {
    document.querySelector('.spectate-name').textContent = data.name;
    document.querySelector('.spectate-id').textContent = '#' + data.id;
    document.querySelector('.spectate-health-fill').style.width = data.health + '%';
    
    // Atualizar ping se fornecido
    if (data.ping !== undefined) {
        updatePlayerPing(data.ping);
    }
}

function updatePlayerPing(ping) {
    const pingElement = document.querySelector('.ping-value');
    if (pingElement) {
        pingElement.textContent = ping + 'ms';
        
        // Mudar cor baseada no ping
        const pingInfo = document.querySelector('.ping-info');
        if (ping < 50) {
            pingInfo.style.borderColor = 'rgba(16, 47, 185, 0.5)';
            pingElement.style.color = '#0A48F7';
        } else if (ping < 100) {
            pingInfo.style.borderColor = 'rgba(245, 158, 11, 0.5)';
            pingElement.style.color = '#F59E0B';
        } else {
            pingInfo.style.borderColor = 'rgba(239, 68, 68, 0.5)';
            pingElement.style.color = '#EF4444';
        }
    }
}

function hideSpectateHUD() {
    document.getElementById('spectate-hud').style.display = 'none';
    stopRespawnCounter();
}

function startRespawnCounter() {
    respawnTime = 1;
    canRespawn = false;
    updateRespawnKey();
    if (respawnInterval) clearInterval(respawnInterval);
    respawnInterval = setInterval(() => {
        if (respawnTime < 10) {
            respawnTime++;
            updateRespawnKey();
        } else {
            canRespawn = true;
            updateRespawnKey();
            clearInterval(respawnInterval);
        }
    }, 1000);
}

function stopRespawnCounter() {
    if (respawnInterval) clearInterval(respawnInterval);
    respawnInterval = null;
    canRespawn = false;
}

function updateRespawnKey() {
    const keySpan = document.querySelector('.spectate-respawn-key');
    if (!canRespawn) {
        keySpan.textContent = respawnTime;
    } else {
        keySpan.textContent = 'E';
    }
}


// Listener para eventos NUI do FiveM
window.addEventListener('message', function(event) {
    if (event.data.action === 'spectateKiller') {
        showSpectateHUD(event.data.payload);
    }
    if (event.data.action === 'updateSpectateHealth') {
        updateSpectateHealth(event.data.payload);
    }
    if (event.data.action === 'updatePing') {
        updatePlayerPing(event.data.ping);
    }
    if (event.data.action === 'stopSpectate') {
        hideSpectateHUD();
    }
    // NOVO: Mostrar overlay de SS
    if (event.data.action === 'showSS') {
        const overlay = document.getElementById('ss-overlay');
        const img = document.getElementById('ss-image');
        img.src = event.data.url;
        overlay.style.display = 'flex';
    }
    if (event.data.action === 'hideSS') {
        const overlay = document.getElementById('ss-overlay');
        const img = document.getElementById('ss-image');
        img.src = '';
        overlay.style.display = 'none';
    }
    if (event.data.action === 'showAnuncio') {
        const toast = document.getElementById('anuncio-toast');
        const toastText = document.getElementById('anuncio-toast-text');
        toastText.textContent = event.data.text;
        toast.style.display = 'flex';
        toast.style.animation = 'toastIn 0.5s cubic-bezier(.68,-0.55,.27,1.55)';
        clearTimeout(window._anuncioToastTimeout);
        window._anuncioToastTimeout = setTimeout(() => {
            toast.style.animation = 'toastOut 0.5s cubic-bezier(.68,-0.55,.27,1.55)';
            setTimeout(() => { toast.style.display = 'none'; toast.style.animation = ''; }, 500);
        }, 5000);
    }
});


// Captura a tecla E para respawn
window.addEventListener('keydown', function(event) {
    if (canRespawn && (event.key === 'e' || event.key === 'E')) {
        fetch('https://framework/respawnPlayer', { method: 'POST' });
        hideSpectateHUD();
    }
});

