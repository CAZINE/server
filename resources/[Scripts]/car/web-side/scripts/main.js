const app = {
  vehicles: [],
  currentCategory: 'Free',
  playerLevel: 0,

  open: function ({ vehicles, playerLevel }) {
    this.vehicles = vehicles
    this.playerLevel = playerLevel
    
    // Forçar visibilidade
    document.body.style.display = 'block'
    document.body.style.opacity = '1'
    document.body.style.pointerEvents = 'auto'
    
    // Definir botão ativo padrão
    setTimeout(() => {
      this.filterVehicles('Free')
    }, 100)
  },

  close: function () {
    document.querySelector('main').innerHTML = ''
    document.body.style.display = 'none'
  },

  filterVehicles: function (type) {
    this.currentCategory = type
    
    // Remover classe active de todos os botões
    document.querySelectorAll('#app header div button').forEach(btn => {
      btn.classList.remove('active')
    })
    
    // Adicionar classe active ao botão clicado
    const buttons = document.querySelectorAll('#app header div button')
    buttons.forEach(btn => {
      if (btn.textContent.trim() === type) {
        btn.classList.add('active')
      }
    })
    
    // Mostrar TODOS os veículos da categoria, não apenas os desbloqueados
    const filtered = this.vehicles.filter(v => v.vehicleType === type)
    this.updateVehicles(filtered)
  },

  updateVehicles: function (vehicles) {
    const main = document.querySelector('main')
    
    // Limpar conteúdo imediatamente sem alterar opacidade
    main.innerHTML = ''
    
    // Garantir que a opacidade permaneça em 1
    main.style.opacity = '1'
    
    vehicles.forEach(vehicle => {
      const canUse = vehicle.unlocked !== undefined ? vehicle.unlocked : (vehicle.minLevel <= this.playerLevel)

      main.innerHTML += `
        <div class="vehicle ${!canUse ? 'locked-vehicle' : ''}">
          <div class="image" style="background-image: url('${vehicle.image}')">
            ${!canUse ? `
              <div class="lock-overlay">
                <svg class="animated-lock" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zM9 6c0-1.66 1.34-3 3-3s3 1.34 3 3v2H9V6z" fill="#ff4444"/>
                  <path d="M12 17c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2z" fill="#ff4444"/>
                </svg>
                <div class="level-requirement">Nível ${vehicle.minLevel}</div>
              </div>
            ` : ''}
          </div>
          <div class="name">
            <img src="./assets/car.svg">
            <p>${vehicle.name}</p>
          </div>
          <div class="type">
            <img src="./assets/type.svg">
            <p>${vehicle.vehicleType}</p>
          </div>
          ${canUse ? `
            <button onClick="app.spawnVehicle('${vehicle.spawn}')">
              Spawnar
              <img src="./assets/arrow.svg">
            </button>` : `
            <button disabled class="locked-btn">
              <svg class="lock-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zM9 6c0-1.66 1.34-3 3-3s3 1.34 3 3v2H9V6z" fill="#ff4444"/>
                <path d="M12 17c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2z" fill="#ff4444"/>
              </svg>
              <span>Nível ${vehicle.minLevel}</span>
            </button>`}
        </div>
      `
    })
    
    // Forçar re-renderização para garantir que as caixas apareçam corretamente
    main.offsetHeight
  },

  spawnVehicle: function (spawn) {
    fetch('http://car/spawn', {
      method: 'POST',
      body: JSON.stringify({ spawn })
    })
  },

  updatePlayerLevel: function (newLevel) {
    console.log('Nível do jogador atualizado para:', newLevel)
    this.playerLevel = newLevel
    
    // Se o menu estiver aberto, atualizar os veículos
    if (this.currentCategory) {
      this.filterVehicles(this.currentCategory)
    }
  }
}

window.addEventListener('keyup', ({ key }) => {
  if (key === 'Escape') {
    fetch('http://car/close', { method: 'POST' })
  }
})

window.addEventListener('message', ({ data }) => {
  if (data.action === 'open') {
    app.open(data)
  }
  if (data.action === 'close') {
    app.close()
  }
  if (data.action === 'updateLevel') {
    app.updatePlayerLevel(data.level)
  }
})

// Script carregado
