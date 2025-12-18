Config = {}

-- Configurações Gerais
Config.ServerName = "PvP Server"
Config.MaxPlayers = 7
Config.RespawnTime = 5000 -- 5 segundos
Config.SpawnProtection = 3000 -- 3 segundos de proteção após spawn

-- Configurações do Sistema de IDs Fixos
Config.FixedID = {
    enabled = true,           -- Habilitar sistema de IDs fixos
    maxPlayers = 1000,        -- Máximo de jogadores únicos suportados
    autoAssign = true,        -- Atribuir IDs automaticamente
    reuseIds = false,         -- Reutilizar IDs de jogadores removidos (futuro)
    showInHUD = true,         -- Mostrar ID fixo no HUD
    showInChat = true,        -- Mostrar ID fixo no chat
    showInScoreboard = true   -- Mostrar ID fixo no scoreboard
}

-- Configurações de Spawn
Config.SpawnPoints = {
    {x = -1037.74, y = -2738.04, z = 20.17, heading = 327.94},
    {x = -1037.74, y = -2738.04, z = 20.17, heading = 327.94},
    {x = -1037.74, y = -2738.04, z = 20.17, heading = 327.94},
    {x = -1037.74, y = -2738.04, z = 20.17, heading = 327.94}
}

-- Configurações de Zonas PvP
Config.PvPZones = {
    -- {
    --     id = 1,
    --     name = "Zona Central",
    --     coords = vector3(215.76, -810.12, 30.73), -- Praça Legion
    --     radius = 200.0,
    --     color = {r = 255, g = 0, b = 0, a = 100}
    -- },
    -- {
    --     id = 2,
    --     name = "Zona Norte",
    --     coords = vector3(1691.5, 3245.6, 40.0), -- Sandy Shores
    --     radius = 200.0,
    --     color = {r = 0, g = 255, b = 0, a = 100}
    -- },
    -- {
    --     id = 3,
    --     name = "Zona Sul",
    --     coords = vector3(-1100.0, -2700.0, 13.0), -- Porto
    --     radius = 200.0,
    --     color = {r = 0, g = 0, b = 255, a = 100}
    -- }
}

-- Configurações de Armas
Config.DefaultWeapons = {
    "WEAPON_PISTOL",
    "WEAPON_COMBATPISTOL",
    "WEAPON_ASSAULTRIFLE",
    "WEAPON_CARBINERIFLE",
    "WEAPON_SMG",
    -- Adicionar algumas armas customizadas por padrão
    "WEAPON_GOATROSA",
    "WEAPON_M4",
    "WEAPON_ROSA"
}

Config.WeaponAmmo = {
    ["WEAPON_PISTOL"] = 100,
    ["WEAPON_COMBATPISTOL"] = 100,
    ["WEAPON_ASSAULTRIFLE"] = 200,
    ["WEAPON_CARBINERIFLE"] = 200,
    ["WEAPON_SMG"] = 150,
    -- Adicionar munição das armas customizadas
    ["WEAPON_GOATROSA"] = 200,
    ["WEAPON_GOATRED"] = 200,
    ["WEAPON_GOATPRATA"] = 200,
    ["WEAPON_GOATGREEN"] = 200,
    ["WEAPON_GOATAZUL"] = 200,
    ["WEAPON_GOATROXA"] = 200,
    ["WEAPON_GOATAMARELA"] = 200,
    ["WEAPON_M4"] = 200,
    ["WEAPON_M4NATAL"] = 200,
    ["WEAPON_MTARRED"] = 200,
    ["WEAPON_MTARAZUL"] = 200,
    ["WEAPON_ROSA"] = 200,
    ["WEAPON_PSYCHO"] = 200,
    ["WEAPON_TANJIRO"] = 200,
    ["WEAPON_HOHO"] = 200,
    ["WEAPON_LOVE"] = 200,
    ["WEAPON_FANTASMA"] = 200,
    ["WEAPON_BRANCA"] = 200,
    ["WEAPON_ESQUELETO"] = 200,
    ["WEAPON_CHEFAO"] = 200,
    ["WEAPON_VEGAS"] = 200,
    ["WEAPON_METROPOLE"] = 200,
    ["WEAPON_MP40CHORAO"] = 200,
    ["WEAPON_ALFA"] = 200
}

-- Configurações de HUD
Config.HUD = {
    enabled = true,
    showKills = true,
    showDeaths = true,
    showKDRatio = true,
    showPlayers = true,
    showZone = true,
    showFixedId = true,       -- Mostrar ID fixo no HUD
    fixedIdColor = "#0004ffff"  -- Cor do ID fixo no HUD
}

-- Configurações de Scoreboard
Config.Scoreboard = {
    maxEntries = 10,
    updateInterval = 5000,    -- 5 segundos
    showFixedId = true,       -- Mostrar ID fixo no scoreboard
    showPlayerId = false      -- Mostrar player_id temporário no scoreboard
}

-- Configurações de Eventos
Config.Events = {
    killReward = 100, -- Dinheiro por kill
    deathPenalty = 50, -- Dinheiro perdido por morte
    headshotBonus = 50 -- Bônus por headshot
}

-- Configurações de Performance
Config.Performance = {
    maxDistance = 1000.0,
    updateInterval = 100, -- ms
    enableOptimization = true
} 

-- Configurações de Movimento do Jogador
Config.PlayerMovement = {
    walkSpeed = 1.5,      -- Velocidade de andar (rápido)
    runSpeed = 1.7,       -- Velocidade de corrida (rápido)
    sprintSpeed = 1.49    -- Máximo permitido pelo FiveM/GTA
}

-- Configurações de Respawn
Config.Respawn = {
    saveWeaponsOnDeath = false, -- Salvar armas quando morrer
    restoreWeaponsOnRespawn = false, -- Restaurar armas no respawn
    fallbackToDefaultWeapons = false -- Usar armas padrão se não houver armas salvas
}

-- Configurações de Efeitos de Partículas de Morte
Config.DeathEffects = {
    enabled = true, -- Ativar/desativar efeitos de partículas
    duration = {
        blood = 3000, -- Duração do raio roxo (ms)
        headshot = 3500 -- Duração do raio roxo (ms)
    },
    scale = {
        blood = 1.5, -- Intensidade do raio roxo
        headshot = 2.5 -- Intensidade do raio roxo
    },
    height = {
        blood = 0.5, -- Altura do raio roxo
        headshot = 1.5 -- Altura do raio roxo
    },
    effects = {
        blood = {
            color = {r = 128, g = 0, b = 255} -- Roxo
        },
        headshot = {
            color = {r = 128, g = 0, b = 255}, -- Roxo
            intensity = 2.5,
            range = 2.5
        }
    }
} 

-- Configurações de Skins de Armas Customizadas
Config.CustomWeaponSkins = {
    enabled = true, -- Habilitar sistema de skins customizadas
    
    -- Lista de skins disponíveis
    skins = {
        -- GOAT Series
        "WEAPON_GOATROSA",
        "WEAPON_GOATRED", 
        "WEAPON_GOATPRATA",
        "WEAPON_GOATGREEN",
        "WEAPON_GOATAZUL",
        "WEAPON_GOATROXA",
        "WEAPON_GOATAMARELA",
        
        -- M4 Series
        "WEAPON_M4",
        "WEAPON_M4NATAL",
        
        -- MTAR Series
        "WEAPON_MTARRED",
        "WEAPON_MTARAZUL",
        
        -- Other Weapons
        "WEAPON_ROSA",
        "WEAPON_PSYCHO",
        "WEAPON_TANJIRO",
        "WEAPON_HOHO",
        "WEAPON_LOVE",
        "WEAPON_FANTASMA",
        "WEAPON_BRANCA",
        "WEAPON_ESQUELETO",
        "WEAPON_CHEFAO",
        "WEAPON_VEGAS",
        "WEAPON_METROPOLE",
        "WEAPON_MP40CHORAO",
        "WEAPON_ALFA"
    },
    
    -- Configurações de munição para armas customizadas
    customWeaponAmmo = {
        ["WEAPON_GOATROSA"] = 200,
        ["WEAPON_GOATRED"] = 200,
        ["WEAPON_GOATPRATA"] = 200,
        ["WEAPON_GOATGREEN"] = 200,
        ["WEAPON_GOATAZUL"] = 200,
        ["WEAPON_GOATROXA"] = 200,
        ["WEAPON_GOATAMARELA"] = 200,
        ["WEAPON_M4"] = 200,
        ["WEAPON_M4NATAL"] = 200,
        ["WEAPON_MTARRED"] = 200,
        ["WEAPON_MTARAZUL"] = 200,
        ["WEAPON_ROSA"] = 200,
        ["WEAPON_PSYCHO"] = 200,
        ["WEAPON_TANJIRO"] = 200,
        ["WEAPON_HOHO"] = 200,
        ["WEAPON_LOVE"] = 200,
        ["WEAPON_FANTASMA"] = 200,
        ["WEAPON_BRANCA"] = 200,
        ["WEAPON_ESQUELETO"] = 200,
        ["WEAPON_CHEFAO"] = 200,
        ["WEAPON_VEGAS"] = 200,
        ["WEAPON_METROPOLE"] = 200,
        ["WEAPON_MP40CHORAO"] = 200,
        ["WEAPON_ALFA"] = 200
    },
    
    -- Configurações de dano para armas customizadas (opcional - usar padrão se não especificado)
    customWeaponDamage = {
        ["WEAPON_GOATROSA"] = 35,
        ["WEAPON_GOATRED"] = 35,
        ["WEAPON_GOATPRATA"] = 35,
        ["WEAPON_GOATGREEN"] = 35,
        ["WEAPON_GOATAZUL"] = 35,
        ["WEAPON_GOATROXA"] = 35,
        ["WEAPON_GOATAMARELA"] = 35,
        ["WEAPON_M4"] = 40,
        ["WEAPON_M4NATAL"] = 40,
        ["WEAPON_MTARRED"] = 38,
        ["WEAPON_MTARAZUL"] = 38,
        ["WEAPON_ROSA"] = 35,
        ["WEAPON_PSYCHO"] = 35,
        ["WEAPON_TANJIRO"] = 35,
        ["WEAPON_HOHO"] = 35,
        ["WEAPON_LOVE"] = 35,
        ["WEAPON_FANTASMA"] = 35,
        ["WEAPON_BRANCA"] = 35,
        ["WEAPON_ESQUELETO"] = 35,
        ["WEAPON_CHEFAO"] = 35,
        ["WEAPON_VEGAS"] = 35,
        ["WEAPON_METROPOLE"] = 35,
        ["WEAPON_MP40CHORAO"] = 30,
        ["WEAPON_ALFA"] = 35
    }
} 