

Config.Groups = {
    -- Grupos padrão que serão criados automaticamente
    DefaultGroups = {
        "admin",
        "moderador", 
        "suporte",
        "maneger",
        "owner",
        "ceo",
        "premium",
        "premium_outro",
        "premium_diario",
        "premium_bronze",
        "vip_quebrada",
        "vip_playboy",
        "vip_milionario"
    },
    
    -- Permissões por grupo (máximo 3 por grupo conforme solicitado)
    GroupPermissions = {
        ["admin"] = {
            "admin.all",           -- Todas as permissões
            "admin.kick",          -- Kickar jogadores
            "admin.ban",           -- Banir jogadores
            "wall"                 -- Sistema de Wall
        },
        ["moderador"] = {
            "mod.kick",            -- Kickar jogadores
            "mod.teleport",        -- Teleportar
            "mod.heal"             -- Curar jogadores
        },
        ["suporte"] = {
            "support.teleport",    -- Teleportar
            "support.heal",        -- Curar
            "support.revive"       -- Reviver
        },
        ["maneger"] = {
            "maneger.manage",      -- Gerenciar configurações
            "maneger.kick",        -- Kickar jogadores
            "maneger.announce"     -- Fazer anúncios
        },
        ["owner"] = {
            "owner.all",           -- Todas as permissões de owner
            "owner.manage",        -- Gerenciar servidores
            "owner.announce"       -- Fazer anúncios
        },
        ["ceo"] = {
            "ceo.all",             -- Todas as permissões de CEO
            "ceo.manage",          -- Gerenciar tudo
            "ceo.announce"         -- Fazer anúncios
        },
        ["premium"] = {
            "premium.heal",        -- Curar a si mesmo
            "premium.vehicles",    -- Spawnar veículos
            "premium.weather"      -- Alterar clima
        },
        ["premium_outro"] = {
            "premium.heal",        -- Curar a si mesmo
            "premium.vehicles",    -- Spawnar veículos
            "premium.weather"      -- Alterar clima
        },
        ["premium_diario"] = {
            "premium.heal",        -- Curar a si mesmo
            "premium.vehicles",    -- Spawnar veículos
            "premium.weather"      -- Alterar clima
        },
        ["premium_bronze"] = {
            "premium.heal",        -- Curar a si mesmo
            "premium.vehicles",    -- Spawnar veículos
            "premium.weather"      -- Alterar clima
        },
        ["vip_quebrada"] = {
            "vip.quebrada.heal",   -- Curar a si mesmo
            "vip.quebrada.vehicle",-- Spawnar veículo especial
            "vip.quebrada.skin"    -- Skin exclusiva
        },
        ["vip_playboy"] = {
            "vip.playboy.heal",    -- Curar a si mesmo
            "vip.playboy.vehicle", -- Spawnar veículo especial
            "vip.playboy.skin"     -- Skin exclusiva
        },
        ["vip_milionario"] = {
            "vip.milionario.heal", -- Curar a si mesmo
            "vip.milionario.vehicle",-- Spawnar veículo especial
            "vip.milionario.skin"  -- Skin exclusiva
        }
    },
    
    -- Cores dos grupos
    GroupColors = {
        ["admin"] = "^1",         -- Vermelho
        ["moderador"] = "^3",     -- Amarelo
        ["suporte"] = "^5",       -- Azul
        ["maneger"] = "^2",       -- Verde
        ["owner"] = "^4",         -- Roxo
        ["ceo"] = "^8",           -- Laranja
        ["premium"] = "^6",       -- Dourado
        ["premium_outro"] = "^6", -- Dourado
        ["premium_diario"] = "^6", -- Dourado
        ["premium_bronze"] = "^6", -- Dourado
        ["vip_quebrada"] = "^9",   -- Rosa
        ["vip_playboy"] = "^0",    -- Branco
        ["vip_milionario"] = "^2"  -- Verde
    },
    
    -- Nomes dos grupos
    GroupNames = {
        ["admin"] = "Administrador",
        ["moderador"] = "Moderador",
        ["suporte"] = "Suporte",
        ["maneger"] = "Maneger",
        ["owner"] = "Owner",
        ["ceo"] = "CEO",
        ["premium"] = "Premium",
        ["premium_outro"] = "Premium Outro",
        ["premium_diario"] = "Premium Diário",
        ["premium_bronze"] = "Premium Bronze",
        ["vip_quebrada"] = "Vip Quebrada",
        ["vip_playboy"] = "Vip PlayBoy",
        ["vip_milionario"] = "Vip Milionário"
    }
}

-- Função para obter permissões de um grupo
function Config.GetGroupPermissions(group)
    return Config.Groups.GroupPermissions[group] or {}
end

-- Função para obter cor de um grupo
function Config.GetGroupColor(group)
    return Config.Groups.GroupColors[group] or "^7"
end

-- Função para obter nome de um grupo
function Config.GetGroupName(group)
    return Config.Groups.GroupNames[group] or "Usuário"
end

-- Função para verificar se um grupo existe
function Config.GroupExists(group)
    return Config.Groups.GroupPermissions[group] ~= nil
end

print("[GROUPS_CONFIG] Configuração de grupos carregada!") 