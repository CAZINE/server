const members = [
  // Inicialmente vazio
];

// Função para criar notificações no canto da tela
function showNotification(message, type = 'info', title = 'Sistema de Gangues') {
  const container = document.getElementById('notification-container');
  const notification = document.createElement('div');
  notification.className = `notification ${type}`;
  
  notification.innerHTML = `
    <div class="notification-title">${title}</div>
    <div class="notification-message">${message}</div>
  `;
  
  container.appendChild(notification);
  
  // Remover notificação após 5 segundos
  setTimeout(() => {
    notification.classList.add('fade-out');
    setTimeout(() => {
      if (container.contains(notification)) {
        container.removeChild(notification);
      }
    }, 300);
  }, 5000);
}

// Variável global para armazenar o ID do jogador atual
let currentPlayerId = null;

// Função para gerar SVG X dourado animado
function generateGoldenXIcon() {
  const uniqueId = Math.random().toString(36).substr(2, 9);
  return `
    <svg class="golden-x-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
      <defs>
        <linearGradient id="goldenXGradient${uniqueId}" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" style="stop-color:#FFD700;stop-opacity:1" />
          <stop offset="50%" style="stop-color:#FFA500;stop-opacity:1" />
          <stop offset="100%" style="stop-color:#FF8C00;stop-opacity:1" />
        </linearGradient>
        <filter id="goldenXGlow${uniqueId}">
          <feGaussianBlur stdDeviation="2" result="coloredBlur"/>
          <feMerge> 
            <feMergeNode in="coloredBlur"/>
            <feMergeNode in="SourceGraphic"/>
          </feMerge>
        </filter>
      </defs>
      <path d="M18 6L6 18M6 6L18 18" stroke="url(#goldenXGradient${uniqueId})" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" filter="url(#goldenXGlow${uniqueId})">
        <animate attributeName="stroke-width" values="2.5;3.5;2.5" dur="2s" repeatCount="indefinite"/>
      </path>
    </svg>
  `;
}

// Função para gerar dropdown de cargos
function generateCargoDropdown(memberId, currentRole) {
  const uniqueId = Math.random().toString(36).substr(2, 9);
  const cargoOptions = [
    { value: 'Membro', label: 'Membro', icon: '👤' },
    { value: 'Vice-Líder', label: 'Vice-Líder', icon: '⭐' },
    { value: 'Líder', label: 'Líder', icon: '👑' }
  ];
  
  return `
    <div class="cargo-dropdown-container">
      <button class="cargo-dropdown-btn" title="Alterar cargo" onclick="toggleCargoDropdown('${memberId}')">
        <svg class="cargo-dropdown-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <defs>
            <linearGradient id="cargoDropdownGradient${uniqueId}" x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" style="stop-color:#FFD700;stop-opacity:1" />
              <stop offset="50%" style="stop-color:#FFA500;stop-opacity:1" />
              <stop offset="100%" style="stop-color:#FF8C00;stop-opacity:1" />
            </linearGradient>
            <filter id="cargoDropdownGlow${uniqueId}">
              <feGaussianBlur stdDeviation="2" result="coloredBlur"/>
              <feMerge> 
                <feMergeNode in="coloredBlur"/>
                <feMergeNode in="SourceGraphic"/>
              </feMerge>
            </filter>
          </defs>
          <path d="M12 2L13.09 8.26L20 9L14 14L15.18 21L12 17.77L8.82 21L10 14L4 9L10.91 8.26L12 2Z" stroke="url(#cargoDropdownGradient${uniqueId})" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" fill="none" filter="url(#cargoDropdownGlow${uniqueId})">
            <animateTransform attributeName="transform" type="rotate" values="0 12 12;360 12 12" dur="8s" repeatCount="indefinite"/>
          </path>
        </svg>
      </button>
      <div class="cargo-dropdown-menu" id="cargo-dropdown-${memberId}" style="display: none;">
        ${cargoOptions.map(cargo => 
          `<div class="cargo-option ${cargo.value === currentRole ? 'current-cargo' : ''}" 
               onclick="changeMemberCargo(${memberId}, '${cargo.value}')">
            <span class="cargo-icon">${cargo.icon}</span>
            <span class="cargo-label">${cargo.label}</span>
            ${cargo.value === currentRole ? '<span class="current-badge">Atual</span>' : ''}
          </div>`
        ).join('')}
      </div>
    </div>
  `;
}

// Função para alternar dropdown de cargos
function toggleCargoDropdown(memberId) {
  const dropdown = document.getElementById(`cargo-dropdown-${memberId}`);
  if (!dropdown) return;
  
  // Fechar todos os outros dropdowns
  document.querySelectorAll('.cargo-dropdown-menu').forEach(menu => {
    if (menu.id !== `cargo-dropdown-${memberId}`) {
      menu.style.display = 'none';
    }
  });
  
  // Alternar o dropdown atual
  dropdown.style.display = dropdown.style.display === 'none' ? 'block' : 'none';
}

// Função para mudar cargo do membro
function changeMemberCargo(memberId, newCargo) {
  console.log(`Tentando mudar cargo do membro ${memberId} para ${newCargo}`);
  
  // Prevenir múltiplas execuções
  if (window.changingCargo) {
    console.log('Mudança de cargo já em andamento, ignorando...');
    return;
  }
  
  showConfirmModal(`Tem certeza que deseja alterar o cargo do membro ID ${memberId} para ${newCargo}?`, () => {
    console.log(`Confirmado: Mudando cargo do membro ${memberId} para ${newCargo}`);
    
    // Marcar como em andamento
    window.changingCargo = true;
    
    // Enviar para o servidor Lua usando callback
    fetch(`https://${GetParentResourceName()}/changeMemberCargo`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ 
        memberId: parseInt(memberId), 
        newCargo: newCargo 
      })
    }).then(response => {
      console.log('Resposta do servidor:', response);
      if (response.ok) {
        showNotification(`Cargo do membro alterado para ${newCargo} com sucesso!`, 'success');
        
        // Não atualizar localmente, deixar o servidor fazer isso
        // updateMemberCargoLocally(memberId, newCargo);
      } else {
        showNotification('Erro ao alterar cargo do membro', 'error');
      }
    }).catch(error => {
      console.error('Erro ao enviar requisição:', error);
      showNotification('Erro de conexão ao alterar cargo', 'error');
    }).finally(() => {
      // Liberar flag após 2 segundos
      setTimeout(() => {
        window.changingCargo = false;
      }, 2000);
    });
    
    // Fechar o dropdown após a mudança
    const dropdown = document.getElementById(`cargo-dropdown-${memberId}`);
    if (dropdown) {
      dropdown.style.display = 'none';
    }
  });
}

// Função para atualizar cargo localmente na interface
function updateMemberCargoLocally(memberId, newCargo) {
  console.log(`Atualizando cargo localmente - Membro: ${memberId}, Novo cargo: ${newCargo}`);
  
  // Encontrar a linha do membro na tabela
  const memberRows = document.querySelectorAll('.org-table-row');
  let memberFound = false;
  
  memberRows.forEach(row => {
    const memberIdElement = row.querySelector('span:nth-child(2)');
    if (memberIdElement && memberIdElement.textContent.trim() === memberId.toString()) {
      memberFound = true;
      console.log(`Membro encontrado na linha: ${memberId}`);
      
      // Atualizar o cargo na interface
      const cargoElement = row.querySelector('span:nth-child(3)');
      if (cargoElement) {
        cargoElement.textContent = newCargo;
        console.log(`Cargo atualizado para: ${newCargo}`);
      }
      
      // Atualizar o avatar baseado no novo cargo
      const memberNameElement = row.querySelector('.member-name');
      if (memberNameElement) {
        const avatarElement = memberNameElement.querySelector('.role-icon');
        if (avatarElement) {
          const newAvatar = generateRoleAvatar(newCargo);
          avatarElement.outerHTML = newAvatar;
          console.log(`Avatar atualizado para cargo: ${newCargo}`);
        }
      }
      
      // Atualizar a classe da linha para destacar o nome
      const roleLower = newCargo.toLowerCase();
      row.className = 'org-table-row';
      if (roleLower.includes('dono') || roleLower.includes('owner')) {
        row.className += ' owner-member';
      } else if (roleLower.includes('vice') || roleLower.includes('lider') || roleLower.includes('leader')) {
        row.className += ' vice-member';
      } else {
        row.className += ' regular-member';
      }
      
      console.log(`Classe da linha atualizada para: ${row.className}`);
    }
  });
  
  if (!memberFound) {
    console.log(`Membro ${memberId} não encontrado na interface`);
  }
}

// Função para fechar dropdowns ao clicar fora
function closeAllDropdowns() {
  document.querySelectorAll('.cargo-dropdown-menu').forEach(menu => {
    menu.style.display = 'none';
  });
}

// Função para gerar avatar SVG baseado no cargo
function generateRoleAvatar(role) {
  const roleLower = (role || '').toLowerCase();
  const uniqueId = Math.random().toString(36).substr(2, 9);
  
  if (roleLower.includes('dono') || roleLower.includes('owner')) {
    return `
      <svg class="role-icon owner-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <defs>
          <linearGradient id="crownGradient${uniqueId}" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" style="stop-color:#FFD700;stop-opacity:1" />
            <stop offset="50%" style="stop-color:#FFA500;stop-opacity:1" />
            <stop offset="100%" style="stop-color:#FF8C00;stop-opacity:1" />
          </linearGradient>
          <filter id="crownGlow${uniqueId}">
            <feGaussianBlur stdDeviation="3" result="coloredBlur"/>
            <feMerge> 
              <feMergeNode in="coloredBlur"/>
              <feMergeNode in="SourceGraphic"/>
            </feMerge>
          </filter>
        </defs>
        <path d="M12 2L15.09 8.26L22 9L17 14L18.18 21L12 17.77L5.82 21L7 14L2 9L8.91 8.26L12 2Z" fill="url(#crownGradient${uniqueId})" filter="url(#crownGlow${uniqueId})"/>
        <circle cx="12" cy="12" r="1.5" fill="#FFD700" opacity="0.8">
          <animate attributeName="opacity" values="0.8;1;0.8" dur="2s" repeatCount="indefinite"/>
        </circle>
      </svg>
    `;
  } else if (roleLower.includes('vice') || roleLower.includes('lider') || roleLower.includes('leader')) {
    return `
      <svg class="role-icon vice-leader-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <defs>
          <linearGradient id="viceGradient${uniqueId}" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" style="stop-color:#073de2;stop-opacity:1" />
            <stop offset="50%" style="stop-color:#0F39BD;stop-opacity:1" />
            <stop offset="100%" style="stop-color:#07216E;stop-opacity:1" />
          </linearGradient>
          <filter id="viceGlow${uniqueId}">
            <feGaussianBlur stdDeviation="2" result="coloredBlur"/>
            <feMerge> 
              <feMergeNode in="coloredBlur"/>
              <feMergeNode in="SourceGraphic"/>
            </feMerge>
          </filter>
        </defs>
        <path d="M12 2L13.09 8.26L20 9L14 14L15.18 21L12 17.77L8.82 21L10 14L4 9L10.91 8.26L12 2Z" fill="url(#viceGradient${uniqueId})" filter="url(#viceGlow${uniqueId})">
          <animateTransform attributeName="transform" type="scale" values="1;1.1;1" dur="3s" repeatCount="indefinite"/>
        </path>
        <circle cx="12" cy="12" r="1" fill="#073de2" opacity="0.7">
          <animate attributeName="opacity" values="0.7;1;0.7" dur="2.5s" repeatCount="indefinite"/>
        </circle>
      </svg>
    `;
  } else {
    return `
      <svg class="role-icon member-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <defs>
          <linearGradient id="memberGradient${uniqueId}" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" style="stop-color:#0F39BD;stop-opacity:1" />
            <stop offset="50%" style="stop-color:#07216E;stop-opacity:1" />
            <stop offset="100%" style="stop-color:#00802A;stop-opacity:1" />
          </linearGradient>
          <filter id="memberGlow${uniqueId}">
            <feGaussianBlur stdDeviation="1.5" result="coloredBlur"/>
            <feMerge> 
              <feMergeNode in="coloredBlur"/>
              <feMergeNode in="SourceGraphic"/>
            </feMerge>
          </filter>
        </defs>
        <path d="M12 12C14.21 12 16 10.21 16 8C16 5.79 14.21 4 12 4C9.79 4 8 5.79 8 8C8 10.21 9.79 12 12 12ZM12 14C9.33 14 4 15.34 4 18V20H20V18C20 15.34 14.67 14 12 14Z" fill="url(#memberGradient${uniqueId})" filter="url(#memberGlow${uniqueId})">
          <animateTransform attributeName="transform" type="scale" values="1;1.05;1" dur="4s" repeatCount="indefinite"/>
        </path>
        <circle cx="12" cy="8" r="2" fill="#0F39BD" opacity="0.6">
          <animate attributeName="opacity" values="0.6;1;0.6" dur="3s" repeatCount="indefinite"/>
        </circle>
      </svg>
    `;
  }
}

// Função para atualizar lista de membros
function updateMembersList(members, playerId = null) {
  const membersList = document.getElementById("members-list");
  const listHeader = document.querySelector(".org-list-header span");
  
  // Atualizar ID do jogador atual se fornecido
  if (playerId !== null) {
    currentPlayerId = playerId;
  }
  
  // Atualizar o cabeçalho com número real de membros
  if (members && members.length > 0) {
    listHeader.textContent = `LISTA DE MEMBROS (${members.length}/105)`;
  } else {
    listHeader.textContent = "LISTA DE MEMBROS (0/105)";
  }
  
  membersList.innerHTML = "";
  
  if (!members || members.length === 0) {
    membersList.innerHTML = "<div class='org-table-row'><span style='grid-column: 1 / -1; color: #888;'>Nenhum membro encontrado.</span></div>";
    return;
  }
  
  members.forEach(member => {
    const row = document.createElement("div");
    
    // Adicionar classe baseada no cargo para destacar nome
    const roleLower = (member.role || '').toLowerCase();
    if (roleLower.includes('dono') || roleLower.includes('owner')) {
      row.className = "org-table-row owner-member";
    } else if (roleLower.includes('vice') || roleLower.includes('lider') || roleLower.includes('leader')) {
      row.className = "org-table-row vice-member";
    } else {
      row.className = "org-table-row regular-member";
    }
    
    // Determinar se é o jogador atual
    const isCurrentPlayer = member.id === currentPlayerId;
    
    // Gerar avatar baseado no cargo
    const roleAvatar = generateRoleAvatar(member.role);
    
    // Determinar se o jogador atual é dono
    const isOwner = members.find(m => m.id === currentPlayerId && m.role === 'Dono');
    
    row.innerHTML = `
      <span class="member-name">
        ${roleAvatar}
        <span>${member.name || 'Jogador'}</span>
      </span>
      <span>${member.id}</span>
      <span>${member.role || 'Membro'}</span>
      <span>${member.lastLogin || 'Online'}</span>
      <div class="action-buttons">
        ${member.role === 'Dono' ? 
          `<div class="owner-badge-container">
            <svg class="crown-badge" width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <defs>
                <linearGradient id="badgeGradient" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" style="stop-color:#FFD700;stop-opacity:1" />
                  <stop offset="100%" style="stop-color:#FFA500;stop-opacity:1" />
                </linearGradient>
              </defs>
              <path d="M12 2L15.09 8.26L22 9L17 14L18.18 21L12 17.77L5.82 21L7 14L2 9L8.91 8.26L12 2Z" fill="url(#badgeGradient)"/>
            </svg>
          </div>` :
          isCurrentPlayer ? 
            `<button class="leave-btn" title="Sair da gangue" onclick="leaveGang()"><i class="fas fa-sign-out-alt"></i></button>` :
            isOwner && member.role !== 'Dono' ?
              `<div class="owner-actions">
                ${generateCargoDropdown(member.id, member.role)}
                <button class="remove-btn" title="Remover membro" onclick="removeMember(${member.id})">${generateGoldenXIcon()}</button>
              </div>` :
              `<button class="remove-btn" title="Remover membro" onclick="removeMember(${member.id})">${generateGoldenXIcon()}</button>`
        }
      </div>
    `;
    membersList.appendChild(row);
  });
}

// Função para mostrar modal de confirmação personalizado
function showConfirmModal(message, onConfirm, onCancel) {
  const modal = document.getElementById('confirm-modal');
  const messageElement = document.getElementById('confirm-message');
  const confirmBtn = document.getElementById('confirm-ok');
  const cancelBtn = document.getElementById('confirm-cancel');
  
  // Definir mensagem
  messageElement.textContent = message;
  
  // Mostrar modal
  modal.style.display = 'flex';
  
  // Event listeners para os botões
  const handleConfirm = () => {
    hideModal();
    if (onConfirm) onConfirm();
  };
  
  const handleCancel = () => {
    hideModal();
    if (onCancel) onCancel();
  };
  
  // Remover listeners antigos e adicionar novos
  confirmBtn.removeEventListener('click', handleConfirm);
  cancelBtn.removeEventListener('click', handleCancel);
  
  confirmBtn.addEventListener('click', handleConfirm);
  cancelBtn.addEventListener('click', handleCancel);
  
  // Fechar modal ao clicar fora dele
  modal.addEventListener('click', (e) => {
    if (e.target === modal) {
      handleCancel();
    }
  });
}

// Função para esconder modal
function hideModal() {
  const modal = document.getElementById('confirm-modal');
  modal.classList.add('fade-out');
  setTimeout(() => {
    modal.style.display = 'none';
    modal.classList.remove('fade-out');
  }, 300);
}

// Função para sair da gangue
function leaveGang() {
  showConfirmModal('Tem certeza que deseja sair da gangue?', () => {
    fetch(`https://${GetParentResourceName()}/leaveGang`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({})
    });
  });
}

// Função para remover membro
function removeMember(memberId) {
  showConfirmModal(`Tem certeza que deseja remover o membro ID ${memberId}?`, () => {
    fetch(`https://${GetParentResourceName()}/removeMember`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ memberId: memberId })
    });
  });
}

// Função para fechar o painel
function closePanel() {
  fetch(`https://${GetParentResourceName()}/closeGangPanel`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({})
  });
  document.getElementById('org-panel').style.display = 'none';
  document.getElementById('create-org-box').style.display = 'none';
}

// Event listeners com verificações de segurança
const inviteBtn = document.getElementById("invite-btn");
const invitePassport = document.getElementById("invite-passport");

if (inviteBtn) {
  inviteBtn.addEventListener("click", () => {
    const passport = invitePassport ? invitePassport.value.trim() : '';
    if (passport) {
      try {
        fetch(`https://${GetParentResourceName()}/inviteMember`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ playerId: passport })
        });
        if (invitePassport) invitePassport.value = "";
        inviteBtn.disabled = true;
      } catch (error) {
        console.error('Erro ao enviar convite:', error);
      }
    }
  });
}

if (invitePassport) {
  invitePassport.addEventListener("input", (e) => {
    if (inviteBtn) {
      inviteBtn.disabled = !e.target.value.trim();
    }
  });
}

// Campo de busca removido - não há mais referência

// Criação de organização
const createOrgBtn = document.getElementById("create-org-btn");
const orgNameInput = document.getElementById("org-name-input");
const createOrgBox = document.getElementById("create-org-box");
const orgPanel = document.getElementById("org-panel");

if (createOrgBtn) {
  createOrgBtn.addEventListener("click", () => {
    const name = orgNameInput ? orgNameInput.value.trim() : '';
    if (name) {
      try {
        // Envia para o Lua
        fetch(`https://${GetParentResourceName()}/createGang`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ name })
        });
        const createOrgBox = document.getElementById('create-org-box');
        if (createOrgBox) createOrgBox.style.display = 'none';
        // O painel principal só será aberto quando o Lua responder com openGangPanel
      } catch (error) {
        console.error('Erro ao criar organização:', error);
      }
    }
  });
}

if (orgNameInput) {
  orgNameInput.addEventListener("input", (e) => {
    if (createOrgBtn) {
      createOrgBtn.disabled = !e.target.value.trim();
    }
  });
}

window.addEventListener('message', function(event) {
  try {
    const data = event.data;
    if (!data || !data.action) return;
    
    if (data.action === 'openGangPanel') {
      const orgPanel = document.getElementById('org-panel');
      const createOrgBox = document.getElementById('create-org-box');
      
      if (orgPanel) orgPanel.style.display = 'flex';
      if (createOrgBox) createOrgBox.style.display = 'none';
      
      if (data.gang && data.gang.name) {
        const orgTitle = document.querySelector('.org-title');
        if (orgTitle) orgTitle.textContent = data.gang.name;
      }
      if (data.gang && data.gang.members) {
        updateMembersList(data.gang.members);
      }
    }
    
    if (data.action === 'closeGangPanel') {
      const orgPanel = document.getElementById('org-panel');
      const createOrgBox = document.getElementById('create-org-box');
      
      if (orgPanel) orgPanel.style.display = 'none';
      if (createOrgBox) createOrgBox.style.display = 'none';
    }
    
    if (data.action === 'openCreateOrgBox') {
      const orgPanel = document.getElementById('org-panel');
      const createOrgBox = document.getElementById('create-org-box');
      
      if (orgPanel) orgPanel.style.display = 'none';
      if (createOrgBox) createOrgBox.style.display = 'flex';
    }
    
    if (data.action === 'updateMembers') {
      updateMembersList(data.members, data.currentPlayerId);
    }
    
    if (data.action === 'showNotification') {
      showNotification(data.message, data.type || 'info', data.title || 'Sistema de Gangues');
    }
  } catch (error) {
    console.error('Erro no message listener:', error);
  }
});

window.onload = () => {
  try {
    updateMembersList([]);
    if (createOrgBtn) createOrgBtn.disabled = true;
    
    // Garantir que os painéis estejam ocultos inicialmente
    const orgPanel = document.getElementById('org-panel');
    const createOrgBox = document.getElementById('create-org-box');
    
    if (orgPanel) orgPanel.style.display = 'none';
    if (createOrgBox) createOrgBox.style.display = 'none';
    
    // Forçar habilitação de todos os elementos interativos
    const allInputs = document.querySelectorAll('input, button, select, textarea');
    allInputs.forEach(element => {
      element.style.pointerEvents = 'auto';
      element.style.cursor = element.type === 'text' || element.type === 'number' ? 'text' : 'pointer';
    });
    
    // Garantir que o overlay não bloqueie interações
    const overlay = document.getElementById('nui-overlay');
    if (overlay) {
      overlay.style.pointerEvents = 'none';
    }
    
    // Adicionar event listener para fechar dropdowns ao clicar fora
    document.addEventListener('click', (e) => {
      if (!e.target.closest('.cargo-dropdown-container')) {
        closeAllDropdowns();
      }
    });
    
    console.log('NUI inicializada com sucesso');
  } catch (error) {
    console.error('Erro ao inicializar NUI:', error);
  }
};

// Fechar painel com ESC
window.addEventListener('keydown', function(event) {
  if (event.key === 'Escape') {
    try {
      // Fechar modal se estiver aberto
      const modal = document.getElementById('confirm-modal');
      if (modal && modal.style.display === 'flex') {
        hideModal();
        return;
      }
      
      // Esconde ambos os painéis
      const orgPanel = document.getElementById('org-panel');
      const createOrgBox = document.getElementById('create-org-box');
      
      if (orgPanel) orgPanel.style.display = 'none';
      if (createOrgBox) createOrgBox.style.display = 'none';
      
      // Notifica o Lua
      fetch(`https://${GetParentResourceName()}/closeGangPanel`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
      });
    } catch (error) {
      console.error('Erro ao fechar painel:', error);
    }
  }
}); 