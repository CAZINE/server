Utils = {}

-- Função para calcular distância entre dois pontos
function Utils.GetDistance(pos1, pos2)
    return #(pos1 - pos2)
end

-- Função para verificar se um jogador está em uma zona
function Utils.IsPlayerInZone(playerPos, zoneCoords, zoneRadius)
    return Utils.GetDistance(playerPos, zoneCoords) <= zoneRadius
end

-- Função para obter zona atual do jogador
function Utils.GetPlayerZone(playerPos)
    for i, zone in ipairs(Config.PvPZones) do
        if Utils.IsPlayerInZone(playerPos, zone.coords, zone.radius) then
            return zone
        end
    end
    return nil
end

-- Função para calcular K/D Ratio
function Utils.CalculateKDRatio(kills, deaths)
    if deaths == 0 then
        return kills
    end
    return math.floor((kills / deaths) * 100) / 100
end

-- Função para formatar números
function Utils.FormatNumber(num)
    if num >= 1000000 then
        return string.format("%.1fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.1fK", num / 1000)
    else
        return tostring(num)
    end
end

-- Função para obter spawn point aleatório
function Utils.GetRandomSpawnPoint()
    return Config.SpawnPoints[math.random(#Config.SpawnPoints)]
end

-- Função para verificar se é headshot
function Utils.IsHeadshot(bone)
    local headBones = {
        31086, -- SKEL_Head
        12844, -- IK_Head
        65068, -- FACIAL_facialRoot
        31086  -- SKEL_Head
    }
    
    for _, headBone in ipairs(headBones) do
        if bone == headBone then
            return true
        end
    end
    return false
end

-- Função para obter nome da arma
function Utils.GetWeaponName(weaponHash)
    local weaponNames = {
        [453432689] = "Pistol",
        [1593441988] = "Combat Pistol",
        [961495388] = "Carbine Rifle",
        [2024373456] = "Assault Rifle",
        [736523883] = "SMG"
    }
    
    return weaponNames[weaponHash] or "Unknown Weapon"
end

-- Função para enviar notificação
function Utils.SendNotification(source, message, type)
    if IsDuplicityVersion() then -- Server side
        TriggerClientEvent('pvp:notification', source, message, type)
    else -- Client side
        -- SetNotificationTextEntry('STRING')
        -- AddTextComponentString(message)
        -- DrawNotification(false, false)
        -- Notificação padrão do GTA V desativada
    end
end

-- Função para log
function Utils.Log(message)
    print("[PvP Framework] " .. message)
end 