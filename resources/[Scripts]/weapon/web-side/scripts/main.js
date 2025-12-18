const app = {
  weaponsData: [],
  playerLevel: 0,
  permissions: {},
  isOpen: false,

  open: function ({ weapons, playerLevel, permissions }) {
    if (this.isOpen) return // Evitar múltiplas aberturas
    
    this.weaponsData = weapons
    this.playerLevel = playerLevel
    this.permissions = permissions
    this.isOpen = true
    
    // Mostrar interface imediatamente sem animação
    document.body.style.display = 'block'
    document.body.classList.add('show')
    
    // Carregar categoria padrão
    this.selectCategory('fuzil')
  },

  close: function () {
    if (!this.isOpen) return // Evitar múltiplos fechamentos
    
    this.isOpen = false
    document.body.classList.remove('show')
    document.querySelector('main').innerHTML = ''
    document.body.style.display = 'none'
  },

  selectCategory: function (category) {
    const buttons = document.querySelectorAll('.weapon-tabs button')
    buttons.forEach(btn => btn.classList.remove('active'))
    document.getElementById(category).classList.add('active')

    // Mapear categorias do HTML para o servidor
    const categoryMap = {
      'fuzil': 'rifle',
      'pistola': 'pistol', 
      'smg': 'smg'
    }
    
    const serverCategory = categoryMap[category] || category
    const filteredWeapons = this.weaponsData.filter(w => w.type === serverCategory)
    this.updateWeapons(filteredWeapons)
  },

  updateWeapons: function (weapons) {
    const main = document.querySelector('main')
    
    // Limpar conteúdo imediatamente sem alterar opacidade
    main.innerHTML = ''
    
    // Adicionar uma pequena transição suave usando CSS
    main.style.transition = 'opacity 0.2s ease'
    
    weapons.forEach(weapon => {
      const hasPermission = Array.isArray(weapon.permission)
        ? weapon.permission.some(perm => this.permissions[perm])
        : this.permissions[weapon.permission]

      const canUse = hasPermission || (weapon.unlocked !== undefined ? weapon.unlocked : this.playerLevel >= weapon.level)

      document.querySelector('main').innerHTML += `
      <div class="weapon ${!canUse ? 'locked-weapon' : ''}">
        <div class="image" style="background-image: url('./assets/weapon_${weapon.image}.png')">
          ${!canUse ? `
            <div class="lock-overlay">
              <svg class="animated-lock" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zM9 6c0-1.66 1.34-3 3-3s3 1.34 3 3v2H9V6z" fill="#ff4444"/>
                <path d="M12 17c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2z" fill="#ff4444"/>
              </svg>
              <div class="level-requirement">Nível ${weapon.level}</div>
            </div>
          ` : ''}
        </div>
        <div class="name">
          <img src="./assets/weapon.svg">
          <p>${weapon.name}</p>
        </div>
        ${canUse ? `
          <div class="weapon-buttons">
            <button class="equip-btn" onClick="app.spawnWeapon('${weapon.spawn}')">
              <svg class="equip-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z" fill="currentColor"/>
                <path d="M12 6l2 4h4l-3 3 1 4-4-2-4 2 1-4-3-3h4l2-4z" fill="currentColor" opacity="0.7"/>
              </svg>
              <span>Equipar</span>
            </button>
            <button class="unequip-btn" onClick="app.unequipWeapon('${weapon.spawn}')">
              <svg class="unequip-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M18 6L6 18M6 6l12 12" stroke="currentColor" stroke-width="2"/>
                <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2" fill="none"/>
              </svg>
              <span>Desequipar</span>
            </button>
          </div>` : `
          <button disabled class="locked-btn">
            <svg class="lock-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zM9 6c0-1.66 1.34-3 3-3s3 1.34 3 3v2H9V6z" fill="#ff4444"/>
              <path d="M12 17c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2z" fill="#ff4444"/>
            </svg>
            <span>Nível ${weapon.level}</span>
          </button>`}
      </div>
    `
    })
    
    // Garantir que a opacidade permaneça em 1
    main.style.opacity = '1'
  },

  spawnWeapon: function (spawn) {
    fetch('http://weapon/spawn', {
      method: 'POST',
      body: JSON.stringify({ spawn })
    })
  },

  unequipWeapon: function (spawn) {
    fetch('http://weapon/unequip', {
      method: 'POST',
      body: JSON.stringify({ spawn })
    })
  },

  updatePlayerLevel: function (newLevel) {
    console.log('Nível do jogador atualizado para:', newLevel)
    this.playerLevel = newLevel
    
    // Se o menu estiver aberto, atualizar as armas
    if (this.isOpen) {
      const currentCategory = document.querySelector('.weapon-tabs button.active')?.id || 'fuzil'
      this.selectCategory(currentCategory)
    }
  },

}

window.addEventListener('keyup', (event) => {
  const { key, code } = event
  
  // Debug: mostrar todas as teclas pressionadas
  console.log('Tecla pressionada:', key, 'Código:', code)
  
  // Prevenir comportamento padrão para F1 e F2
  if (code === 'F1' || code === 'F2') {
    event.preventDefault()
  }
  
  if (key === 'Escape') {
    fetch('http://weapon/close', { method: 'POST' })
  }
  
  // F2 para abrir/fechar o painel
  if (code === 'F2') {
    console.log('F2 pressionado, isOpen:', app.isOpen)
    if (!app.isOpen) {
      // Simular dados de teste com nível baixo para testar bloqueio
      const testData = {
        weapons: [
          // Pistolas (5 armas)
          { name: "Pistol", hash: "WEAPON_PISTOL", type: "pistol", level: 1, image: "pistol", permission: null, spawn: "WEAPON_PISTOL", unlocked: true },
          { name: "Combat Pistol", hash: "WEAPON_COMBATPISTOL", type: "pistol", level: 2, image: "combatpistol", permission: null, spawn: "WEAPON_COMBATPISTOL", unlocked: true },
          { name: "AP Pistol", hash: "WEAPON_APPISTOL", type: "pistol", level: 3, image: "appistol", permission: null, spawn: "WEAPON_APPISTOL", unlocked: false },
          { name: "Pistol .50", hash: "WEAPON_PISTOL50", type: "pistol", level: 4, image: "pistol50", permission: null, spawn: "WEAPON_PISTOL50", unlocked: false },
          { name: "Heavy Pistol", hash: "WEAPON_HEAVYPISTOL", type: "pistol", level: 5, image: "heavypistol", permission: null, spawn: "WEAPON_HEAVYPISTOL", unlocked: false },
          
          // SMGs (5 armas)
          { name: "Micro SMG", hash: "WEAPON_MICROSMG", type: "smg", level: 3, image: "microsmg", permission: null, spawn: "WEAPON_MICROSMG", unlocked: false },
          { name: "SMG", hash: "WEAPON_SMG", type: "smg", level: 5, image: "smg", permission: null, spawn: "WEAPON_SMG", unlocked: false },
          { name: "SMG MK2", hash: "WEAPON_SMG_MK2", type: "smg", level: 6, image: "smg_mk2", permission: null, spawn: "WEAPON_SMG_MK2", unlocked: false },
          { name: "Assault SMG", hash: "WEAPON_ASSAULTSMG", type: "smg", level: 7, image: "assaultsmg", permission: null, spawn: "WEAPON_ASSAULTSMG", unlocked: false },
          { name: "Combat PDW", hash: "WEAPON_COMBATPDW", type: "smg", level: 6, image: "combatpdw", permission: null, spawn: "WEAPON_COMBATPDW", unlocked: false },
          
          // Rifles (5 armas) - Níveis mais baixos para teste
          { name: "Assault Rifle", hash: "WEAPON_ASSAULTRIFLE", type: "rifle", level: 5, image: "assaultrifle", permission: null, spawn: "WEAPON_ASSAULTRIFLE", unlocked: false },
          { name: "Carbine Rifle", hash: "WEAPON_CARBINERIFLE", type: "rifle", level: 6, image: "carbinerifle", permission: null, spawn: "WEAPON_CARBINERIFLE", unlocked: false },
          { name: "Advanced Rifle", hash: "WEAPON_ADVANCEDRIFLE", type: "rifle", level: 8, image: "advancedrifle", permission: null, spawn: "WEAPON_ADVANCEDRIFLE", unlocked: false },
          { name: "Special Carbine", hash: "WEAPON_SPECIALCARBINE", type: "rifle", level: 7, image: "specialcarbine", permission: null, spawn: "WEAPON_SPECIALCARBINE", unlocked: false },
          { name: "Bullpup Rifle", hash: "WEAPON_BULLPUPRIFLE", type: "rifle", level: 6, image: "bullpuprifle", permission: null, spawn: "WEAPON_BULLPUPRIFLE", unlocked: false }
        ],
        playerLevel: 2, // Nível baixo para testar bloqueio
        permissions: {}
      }
      console.log('Teste com nível baixo:', testData.playerLevel)
      app.open(testData)
    } else {
      app.close()
    }
  }
  
  // F1 agora funciona normalmente para abrir o menu de armas
  // Removido o bloqueio para permitir funcionamento correto
})

window.addEventListener('message', ({ data }) => {
  if (data.action === 'open') app.open(data)
  if (data.action === 'close') app.close()
  if (data.action === 'updateLevel') app.updatePlayerLevel(data.level)
})

// A interface agora só abre com F2 ou comando do servidor