-- PvP Framework - Weapon Skins Management

WeaponSkins = {}

-- Função para verificar se uma arma é customizada
function WeaponSkins.IsCustomWeapon(weaponName)
    if not Config.CustomWeaponSkins or not Config.CustomWeaponSkins.enabled then
        return false
    end
    
    for _, customWeapon in ipairs(Config.CustomWeaponSkins.skins) do
        if customWeapon == weaponName then
            return true
        end
    end
    
    return false
end

-- Função para obter munição de uma arma customizada
function WeaponSkins.GetCustomWeaponAmmo(weaponName)
    if not Config.CustomWeaponSkins or not Config.CustomWeaponSkins.enabled then
        return Config.WeaponAmmo[weaponName] or 100
    end
    
    return Config.CustomWeaponSkins.customWeaponAmmo[weaponName] or Config.WeaponAmmo[weaponName] or 100
end

-- Função para obter dano de uma arma customizada
function WeaponSkins.GetCustomWeaponDamage(weaponName)
    if not Config.CustomWeaponSkins or not Config.CustomWeaponSkins.enabled then
        return nil -- Usar dano padrão do jogo
    end
    
    return Config.CustomWeaponSkins.customWeaponDamage[weaponName]
end

-- Função para obter lista de todas as armas customizadas
function WeaponSkins.GetAllCustomWeapons()
    if not Config.CustomWeaponSkins or not Config.CustomWeaponSkins.enabled then
        return {}
    end
    
    return Config.CustomWeaponSkins.skins
end

-- Função para obter lista de armas por categoria
function WeaponSkins.GetWeaponsByCategory()
    local categories = {
        GOAT = {},
        M4 = {},
        MTAR = {},
        Other = {}
    }
    
    if not Config.CustomWeaponSkins or not Config.CustomWeaponSkins.enabled then
        return categories
    end
    
    for _, weapon in ipairs(Config.CustomWeaponSkins.skins) do
        if string.find(weapon, "GOAT") then
            table.insert(categories.GOAT, weapon)
        elseif string.find(weapon, "M4") then
            table.insert(categories.M4, weapon)
        elseif string.find(weapon, "MTAR") then
            table.insert(categories.MTAR, weapon)
        else
            table.insert(categories.Other, weapon)
        end
    end
    
    return categories
end

-- Função para validar se uma arma customizada existe
function WeaponSkins.ValidateCustomWeapon(weaponName)
    if not Config.CustomWeaponSkins or not Config.CustomWeaponSkins.enabled then
        return false
    end
    
    for _, customWeapon in ipairs(Config.CustomWeaponSkins.skins) do
        if customWeapon == weaponName then
            return true
        end
    end
    
    return false
end

-- Função para obter informações completas de uma arma customizada
function WeaponSkins.GetWeaponInfo(weaponName)
    if not WeaponSkins.IsCustomWeapon(weaponName) then
        return nil
    end
    
    return {
        name = weaponName,
        ammo = WeaponSkins.GetCustomWeaponAmmo(weaponName),
        damage = WeaponSkins.GetCustomWeaponDamage(weaponName),
        hash = GetHashKey(weaponName)
    }
end

-- Função para obter nome amigável da arma
function WeaponSkins.GetWeaponDisplayName(weaponName)
    if not WeaponSkins.IsCustomWeapon(weaponName) then
        return weaponName
    end
    
    -- Remover prefixo WEAPON_ e formatar
    local displayName = string.gsub(weaponName, "WEAPON_", "")
    
    -- Formatação especial para algumas armas
    if displayName == "GOATROSA" then
        return "GOAT Rosa"
    elseif displayName == "GOATRED" then
        return "GOAT Red"
    elseif displayName == "GOATPRATA" then
        return "GOAT Prata"
    elseif displayName == "GOATGREEN" then
        return "GOAT Green"
    elseif displayName == "GOATAZUL" then
        return "GOAT Azul"
    elseif displayName == "GOATROXA" then
        return "GOAT Roxa"
    elseif displayName == "GOATAMARELA" then
        return "GOAT Amarela"
    elseif displayName == "MTARRED" then
        return "MTAR Red"
    elseif displayName == "MTARAZUL" then
        return "MTAR Azul"
    elseif displayName == "M4NATAL" then
        return "M4 Natal"
    elseif displayName == "MP40CHORAO" then
        return "MP40 Chorão"
    elseif displayName == "ALFA" then
        return "ALFA"
    end
    
    return displayName
end 