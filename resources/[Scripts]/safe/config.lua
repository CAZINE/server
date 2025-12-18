print("^2[SAFE ZONE]^7 Config carregado")
Config = {}

-- Configurações das Safe Zones
Config.SafeZones = {
    {
        name = "Aeroporto",
        coords = vector3(1476.818, -6554.745, 13.447),
        radius = 100.0,
        height = 20.0, -- Altura do cilindro (muito mais baixo)
        color = {r = 0, g = 255, b = 0, a = 45}, -- Verde com alta opacidade
        heading = 450.0
    },
    {
        name = "Paleto Bay", 
        coords = vector3(1368.329, -584.030, 74.380),
        radius = 100.0,
        height = 200.0,
        color = {r = 0, g = 255, b = 0, a = 45}, -- Verde com alta opacidade
        heading = 450.0
    },
    {
        name = "Sandy Shores",
        coords = vector3(-1645.916, -1001.173, 13.017),
        radius = 100.0,
        height = 200.0,
        color = {r = 0, g = 255, b = 0, a = 45}, -- Verde com alta opacidade
        heading = 450.0
    },
    {
        name = "Zona Norte",
        coords = vector3(1290.530, 3066.014, 40.534),
        radius = 100.0,
        height = 200.0,
        color = {r = 0, g = 255, b = 0, a = 45}, -- Verde com alta opacidade
        heading = 450.0
    }
}

-- Configurações gerais
Config.DrawDistance = 500.0 -- Distância máxima para desenhar as zonas
Config.UpdateInterval = 0 -- Intervalo de atualização em ms (0 = a cada frame)
Config.ShowBlips = false -- Mostrar blips no mapa (DESATIVADO)
Config.BlipSprite = 1 -- Sprite do blip (círculo)
Config.BlipScale = 1.5 -- Escala do blip
Config.BlipColor = 2 -- Cor do blip (verde)
Config.BlipAlpha = 20 -- Opacidade do blip

-- Configurações da progressbar ao sair da safezone
Config.ProgressBarOnExit = {
    enabled = true, -- Ativar progressbar quando sair da safezone
    duration = 10000, -- Duração em milissegundos (10 segundos)
    showPercentage = true, -- Mostrar porcentagem
    type = "circular" -- Tipo: "circular" ou "linear"
}