-- server/server.lua

local playerLastWeapons = {} -- Tabela para salvar a última arma de cada jogador

local function getPlayerLevel(src, cb)
    local identifier = GetPlayerIdentifier(src, 0)
    if not identifier then 
        print("[DEBUG][WEAPON] Identifier não encontrado para source:", src)
        cb(1) 
        return 
    end
    
    print("[DEBUG][WEAPON] Consultando XP para identifier:", identifier)
    
    exports.oxmysql:execute('SELECT xp FROM player_xp WHERE identifier = ?', { identifier }, function(result)
        local xp = 0
        if result and result[1] then
            xp = tonumber(result[1].xp) or 0
            print("[DEBUG][WEAPON] XP encontrado:", xp)
        else
            print("[DEBUG][WEAPON] Nenhum XP encontrado, usando 0")
        end
        
        -- Lógica igual ao hud-go
        local level = 1
        local fator = 1.25
        local base = 300
        while level < 100 do
            local nextMeta = math.floor(base * (level ^ fator))
            if xp < nextMeta then break end
            level = level + 1
        end
        if level >= 100 then level = 100 end
        
        print("[DEBUG][WEAPON] Nível calculado:", level, "para XP:", xp)
        cb(level)
    end)
end

RegisterNetEvent('weapon:requestWeapons')
AddEventHandler('weapon:requestWeapons', function()
    local src = source
    print("[DEBUG][WEAPON] Player", src, "solicitou menu de armas")
    
    getPlayerLevel(src, function(playerLevel)
        print("[DEBUG][WEAPON] Nível do player", src, ":", playerLevel)
        -- Lista de armas hardcoded baseada na configuração do framework
        local weapons = {
            -- Pistolas
            { name = "Pistol", hash = "WEAPON_PISTOL", type = "pistol", level = 1, image = "pistol", permission = nil, spawn = "WEAPON_PISTOL" },
            { name = "Combat Pistol", hash = "WEAPON_COMBATPISTOL", type = "pistol", level = 2, image = "combatpistol", permission = nil, spawn = "WEAPON_COMBATPISTOL" },
            { name = "AP Pistol", hash = "WEAPON_APPISTOL", type = "pistol", level = 3, image = "appistol", permission = nil, spawn = "WEAPON_APPISTOL" },
            { name = "Pistol .50", hash = "WEAPON_PISTOL50", type = "pistol", level = 4, image = "pistol50", permission = nil, spawn = "WEAPON_PISTOL50" },
            { name = "SNS Pistol", hash = "WEAPON_SNSPISTOL", type = "pistol", level = 2, image = "snspistol", permission = nil, spawn = "WEAPON_SNSPISTOL" },
            { name = "Heavy Pistol", hash = "WEAPON_HEAVYPISTOL", type = "pistol", level = 5, image = "heavypistol", permission = nil, spawn = "WEAPON_HEAVYPISTOL" },
            { name = "Vintage Pistol", hash = "WEAPON_VINTAGEPISTOL", type = "pistol", level = 3, image = "vintagepistol", permission = nil, spawn = "WEAPON_VINTAGEPISTOL" },
            { name = "Flare Gun", hash = "WEAPON_FLAREGUN", type = "pistol", level = 1, image = "flaregun", permission = nil, spawn = "WEAPON_FLAREGUN" },
            { name = "Marksman Pistol", hash = "WEAPON_MARKSMANPISTOL", type = "pistol", level = 6, image = "marksmanpistol", permission = nil, spawn = "WEAPON_MARKSMANPISTOL" },
            { name = "Revolver", hash = "WEAPON_REVOLVER", type = "pistol", level = 4, image = "revolver", permission = nil, spawn = "WEAPON_REVOLVER" },
            { name = "Double Action", hash = "WEAPON_DOUBLEACTION", type = "pistol", level = 3, image = "doubleaction", permission = nil, spawn = "WEAPON_DOUBLEACTION" },
            { name = "Ceramic Pistol", hash = "WEAPON_CERAMICPISTOL", type = "pistol", level = 4, image = "ceramicpistol", permission = nil, spawn = "WEAPON_CERAMICPISTOL" },
            { name = "Navy Revolver", hash = "WEAPON_NAVYREVOLVER", type = "pistol", level = 5, image = "navyrevolver", permission = nil, spawn = "WEAPON_NAVYREVOLVER" },
            { name = "Gadget Pistol", hash = "WEAPON_GADGETPISTOL", type = "pistol", level = 6, image = "gadgetpistol", permission = nil, spawn = "WEAPON_GADGETPISTOL" },
            
            -- SMGs
            { name = "Micro SMG", hash = "WEAPON_MICROSMG", type = "smg", level = 3, image = "microsmg", permission = nil, spawn = "WEAPON_MICROSMG" },
            { name = "SMG", hash = "WEAPON_SMG", type = "smg", level = 5, image = "smg", permission = nil, spawn = "WEAPON_SMG" },
            { name = "SMG MK2", hash = "WEAPON_SMG_MK2", type = "smg", level = 6, image = "smg_mk2", permission = nil, spawn = "WEAPON_SMG_MK2" },
            { name = "Assault SMG", hash = "WEAPON_ASSAULTSMG", type = "smg", level = 7, image = "assaultsmg", permission = nil, spawn = "WEAPON_ASSAULTSMG" },
            { name = "Combat PDW", hash = "WEAPON_COMBATPDW", type = "smg", level = 6, image = "combatpdw", permission = nil, spawn = "WEAPON_COMBATPDW" },
            { name = "Machine Pistol", hash = "WEAPON_MACHINEPISTOL", type = "smg", level = 4, image = "machinepistol", permission = nil, spawn = "WEAPON_MACHINEPISTOL" },
            { name = "Mini SMG", hash = "WEAPON_MINISMG", type = "smg", level = 3, image = "minismg", permission = nil, spawn = "WEAPON_MINISMG" },
            { name = "Ray Carbine", hash = "WEAPON_RAYCARBINE", type = "smg", level = 8, image = "raycarbine", permission = nil, spawn = "WEAPON_RAYCARBINE" },
            
            -- Rifles (níveis ajustados para nível 7)
            { name = "Assault Rifle", hash = "WEAPON_ASSAULTRIFLE", type = "rifle", level = 5, image = "assaultrifle", permission = nil, spawn = "WEAPON_ASSAULTRIFLE" },
            { name = "Assault Rifle MK2", hash = "WEAPON_ASSAULTRIFLE_MK2", type = "rifle", level = 7, image = "assaultrifle_mk2", permission = nil, spawn = "WEAPON_ASSAULTRIFLE_MK2" },
            { name = "Carbine Rifle", hash = "WEAPON_CARBINERIFLE", type = "rifle", level = 6, image = "carbinerifle", permission = nil, spawn = "WEAPON_CARBINERIFLE" },
            { name = "Carbine Rifle MK2", hash = "WEAPON_CARBINERIFLE_MK2", type = "rifle", level = 7, image = "carbinerifle_mk2", permission = nil, spawn = "WEAPON_CARBINERIFLE_MK2" },
            { name = "Advanced Rifle", hash = "WEAPON_ADVANCEDRIFLE", type = "rifle", level = 7, image = "advancedrifle", permission = nil, spawn = "WEAPON_ADVANCEDRIFLE" },
            { name = "Special Carbine", hash = "WEAPON_SPECIALCARBINE", type = "rifle", level = 6, image = "specialcarbine", permission = nil, spawn = "WEAPON_SPECIALCARBINE" },
            { name = "Special Carbine MK2", hash = "WEAPON_SPECIALCARBINE_MK2", type = "rifle", level = 7, image = "specialcarbine_mk2", permission = nil, spawn = "WEAPON_SPECIALCARBINE_MK2" },
            { name = "Bullpup Rifle", hash = "WEAPON_BULLPUPRIFLE", type = "rifle", level = 6, image = "bullpuprifle", permission = nil, spawn = "WEAPON_BULLPUPRIFLE" },
            { name = "Bullpup Rifle MK2", hash = "WEAPON_BULLPUPRIFLE_MK2", type = "rifle", level = 7, image = "bullpuprifle_mk2", permission = nil, spawn = "WEAPON_BULLPUPRIFLE_MK2" },
            { name = "Compact Rifle", hash = "WEAPON_COMPACTRIFLE", type = "rifle", level = 5, image = "compactrifle", permission = nil, spawn = "WEAPON_COMPACTRIFLE" },
            { name = "Military Rifle", hash = "WEAPON_MILITARYRIFLE", type = "rifle", level = 7, image = "militaryrifle", permission = nil, spawn = "WEAPON_MILITARYRIFLE" },
            { name = "Heavy Rifle", hash = "WEAPON_HEAVYRIFLE", type = "rifle", level = 7, image = "heavyrifle", permission = nil, spawn = "WEAPON_HEAVYRIFLE" },
            
            -- Shotguns
            { name = "Pump Shotgun", hash = "WEAPON_PUMPSHOTGUN", type = "shotgun", level = 6, image = "pumpshotgun", permission = nil, spawn = "WEAPON_PUMPSHOTGUN" },
            { name = "Pump Shotgun MK2", hash = "WEAPON_PUMPSHOTGUN_MK2", type = "shotgun", level = 8, image = "pumpshotgun_mk2", permission = nil, spawn = "WEAPON_PUMPSHOTGUN_MK2" },
            { name = "Sawed-Off Shotgun", hash = "WEAPON_SAWNOFFSHOTGUN", type = "shotgun", level = 4, image = "sawnoffshotgun", permission = nil, spawn = "WEAPON_SAWNOFFSHOTGUN" },
            { name = "Assault Shotgun", hash = "WEAPON_ASSAULTSHOTGUN", type = "shotgun", level = 9, image = "assaultshotgun", permission = nil, spawn = "WEAPON_ASSAULTSHOTGUN" },
            { name = "Bullpup Shotgun", hash = "WEAPON_BULLPUPSHOTGUN", type = "shotgun", level = 8, image = "bullpupshotgun", permission = nil, spawn = "WEAPON_BULLPUPSHOTGUN" },
            { name = "Musket", hash = "WEAPON_MUSKET", type = "shotgun", level = 5, image = "musket", permission = nil, spawn = "WEAPON_MUSKET" },
            { name = "Heavy Shotgun", hash = "WEAPON_HEAVYSHOTGUN", type = "shotgun", level = 10, image = "heavyshotgun", permission = nil, spawn = "WEAPON_HEAVYSHOTGUN" },
            { name = "Double Barrel Shotgun", hash = "WEAPON_DBSHOTGUN", type = "shotgun", level = 7, image = "dbshotgun", permission = nil, spawn = "WEAPON_DBSHOTGUN" },
            { name = "Auto Shotgun", hash = "WEAPON_AUTOSHOTGUN", type = "shotgun", level = 11, image = "autoshotgun", permission = nil, spawn = "WEAPON_AUTOSHOTGUN" },
            { name = "Combat Shotgun", hash = "WEAPON_COMBATSHOTGUN", type = "shotgun", level = 9, image = "combatshotgun", permission = nil, spawn = "WEAPON_COMBATSHOTGUN" },
            
            -- Melee
            { name = "Knife", hash = "WEAPON_KNIFE", type = "melee", level = 1, image = "knife", permission = nil, spawn = "WEAPON_KNIFE" },
            { name = "Nightstick", hash = "WEAPON_NIGHTSTICK", type = "melee", level = 1, image = "nightstick", permission = nil, spawn = "WEAPON_NIGHTSTICK" },
            { name = "Hammer", hash = "WEAPON_HAMMER", type = "melee", level = 1, image = "hammer", permission = nil, spawn = "WEAPON_HAMMER" },
            { name = "Bat", hash = "WEAPON_BAT", type = "melee", level = 1, image = "bat", permission = nil, spawn = "WEAPON_BAT" },
            { name = "Crowbar", hash = "WEAPON_CROWBAR", type = "melee", level = 1, image = "crowbar", permission = nil, spawn = "WEAPON_CROWBAR" },
            { name = "Golf Club", hash = "WEAPON_GOLFCLUB", type = "melee", level = 1, image = "golfclub", permission = nil, spawn = "WEAPON_GOLFCLUB" },
            { name = "Bottle", hash = "WEAPON_BOTTLE", type = "melee", level = 1, image = "bottle", permission = nil, spawn = "WEAPON_BOTTLE" },
            { name = "Dagger", hash = "WEAPON_DAGGER", type = "melee", level = 2, image = "dagger", permission = nil, spawn = "WEAPON_DAGGER" },
            { name = "Hatchet", hash = "WEAPON_HATCHET", type = "melee", level = 2, image = "hatchet", permission = nil, spawn = "WEAPON_HATCHET" },
            { name = "Knuckle Duster", hash = "WEAPON_KNUCKLE", type = "melee", level = 1, image = "knuckle", permission = nil, spawn = "WEAPON_KNUCKLE" },
            { name = "Machete", hash = "WEAPON_MACHETE", type = "melee", level = 2, image = "machete", permission = nil, spawn = "WEAPON_MACHETE" },
            { name = "Switchblade", hash = "WEAPON_SWITCHBLADE", type = "melee", level = 2, image = "switchblade", permission = nil, spawn = "WEAPON_SWITCHBLADE" },
            { name = "Wrench", hash = "WEAPON_WRENCH", type = "melee", level = 1, image = "wrench", permission = nil, spawn = "WEAPON_WRENCH" },
            { name = "Battle Axe", hash = "WEAPON_BATTLEAXE", type = "melee", level = 3, image = "battleaxe", permission = nil, spawn = "WEAPON_BATTLEAXE" },
            { name = "Pool Cue", hash = "WEAPON_POOLCUE", type = "melee", level = 1, image = "poolcue", permission = nil, spawn = "WEAPON_POOLCUE" },
            { name = "Stone Hatchet", hash = "WEAPON_STONE_HATCHET", type = "melee", level = 2, image = "stonehatchet", permission = nil, spawn = "WEAPON_STONE_HATCHET" }
        }
        
        -- Enviar TODAS as armas, mas marcar quais estão bloqueadas
        local allWeapons = {}
        local unlockedWeapons = 0
        
        for _, weapon in ipairs(weapons) do
            local weaponData = {
                name = weapon.name,
                hash = weapon.hash,
                type = weapon.type,
                level = weapon.level,
                image = weapon.image,
                permission = weapon.permission,
                spawn = weapon.spawn,
                unlocked = weapon.level <= playerLevel -- Adicionar flag de desbloqueado
            }
            table.insert(allWeapons, weaponData)
            
            if weapon.level <= playerLevel then
                unlockedWeapons = unlockedWeapons + 1
            end
        end
        
        print("[DEBUG][WEAPON] Total de armas:", #weapons, "| Desbloqueadas:", unlockedWeapons, "| Nível necessário:", playerLevel)
        
        TriggerClientEvent('weapon:open', src, {
            weapons = allWeapons,
            playerLevel = playerLevel,
            permissions = {}
        })
    end)
end)

RegisterNetEvent('spawnWeapon')
AddEventHandler('spawnWeapon', function(data)
    local source = source
    local weaponHash = data and (data.hash or data.spawn)
    if weaponHash then
        print('[DEBUG][WEAPON] Equipando arma:', weaponHash, 'para o player:', source)
        exports['framework']:GiveWeaponToPlayer(source, weaponHash, 50)
        
        -- Salvar a arma como última equipada
        playerLastWeapons[source] = weaponHash
        print('[DEBUG][WEAPON] Última arma salva para player', source, ':', weaponHash)
        
        TriggerClientEvent('pvp:notification', source, 'Você recebeu a arma: ' .. (weaponHash or 'desconhecida'), 'success')
    else
        print('[DEBUG][WEAPON] Nenhum hash de arma recebido!')
    end
end)

-- Novo evento para salvar a última arma equipada
RegisterNetEvent('weapon:saveLastWeapon')
AddEventHandler('weapon:saveLastWeapon', function(weaponHash)
    local source = source
    if weaponHash then
        playerLastWeapons[source] = weaponHash
        print('[DEBUG][WEAPON] Última arma salva para player', source, ':', weaponHash)
    end
end)

-- Novo evento para desequipar todas as armas
RegisterNetEvent('weapon:unequippedAll')
AddEventHandler('weapon:unequippedAll', function()
    local source = source
    print('[DEBUG][WEAPON] Player', source, 'desequipou todas as armas')
    
    -- Log para auditoria
    local playerName = GetPlayerName(source) or "Desconhecido"
    local playerIdentifier = GetPlayerIdentifier(source, 0) or "Desconhecido"
    
    print('[AUDIT][WEAPON] Player:', playerName, '(', playerIdentifier, ') desequipou todas as armas')
    
    -- Notificar o jogador
    TriggerClientEvent('pvp:notification', source, 'Todas as armas foram desequipadas!', 'info')
end)

-- Evento para quando o jogador se conecta (enviar última arma se existir)
RegisterNetEvent('weapon:requestLastWeapon')
AddEventHandler('weapon:requestLastWeapon', function()
    local source = source
    local lastWeapon = playerLastWeapons[source]
    
    if lastWeapon then
        TriggerClientEvent('weapon:receiveLastWeapon', source, lastWeapon)
        print('[DEBUG][WEAPON] Última arma enviada para player', source, ':', lastWeapon)
    end
end)

-- Comando para resetar XP do jogador (teste de bloqueio)
RegisterCommand("resetxp", function(source, args)
    local identifier = GetPlayerIdentifier(source, 0)
    
    if not identifier then
        print("[DEBUG][WEAPON] Identifier não encontrado para source:", source)
        return
    end
    
    print("[DEBUG][WEAPON] Resetando XP para player", source)
    
    exports.oxmysql:execute('UPDATE player_xp SET xp = 0 WHERE identifier = ?', { identifier }, function(rowsChanged)
        if rowsChanged then
            print("[DEBUG][WEAPON] XP resetado com sucesso!")
            TriggerClientEvent('pvp:notification', source, 'XP resetado! Agora você está no nível 1.', 'info')
        else
            print("[DEBUG][WEAPON] Erro ao resetar XP")
        end
    end)
end)

-- Comando para dar XP ao jogador (teste)
RegisterCommand("givexpweapon", function(source, args)
    local amount = tonumber(args[1]) or 100
    local identifier = GetPlayerIdentifier(source, 0)
    
    if not identifier then
        print("[DEBUG][WEAPON] Identifier não encontrado para source:", source)
        return
    end
    
    print("[DEBUG][WEAPON] Dando", amount, "XP para player", source)
    
    exports.oxmysql:execute('SELECT xp FROM player_xp WHERE identifier = ?', { identifier }, function(result)
        local currentXP = 0
        if result and result[1] then
            currentXP = tonumber(result[1].xp) or 0
        end
        
        local newXP = currentXP + amount
        print("[DEBUG][WEAPON] XP atual:", currentXP, "| Novo XP:", newXP)
        
        exports.oxmysql:execute('UPDATE player_xp SET xp = ? WHERE identifier = ?', { newXP, identifier }, function(rowsChanged)
            if rowsChanged then
                print("[DEBUG][WEAPON] XP atualizado com sucesso!")
                TriggerClientEvent('pvp:notification', source, 'Você recebeu ' .. amount .. ' XP!', 'success')
            else
                print("[DEBUG][WEAPON] Erro ao atualizar XP")
            end
        end)
    end)
end)

-- Comando para verificar nível atual
RegisterCommand("checklevel", function(source, args)
    local identifier = GetPlayerIdentifier(source, 0)
    
    if not identifier then
        print("[DEBUG][WEAPON] Identifier não encontrado para source:", source)
        return
    end
    
    exports.oxmysql:execute('SELECT xp FROM player_xp WHERE identifier = ?', { identifier }, function(result)
        local xp = 0
        if result and result[1] then
            xp = tonumber(result[1].xp) or 0
        end
        
        -- Calcular nível
        local level = 1
        local fator = 1.25
        local base = 300
        while level < 100 do
            local nextMeta = math.floor(base * (level ^ fator))
            if xp < nextMeta then break end
            level = level + 1
        end
        if level >= 100 then level = 100 end
        
        print("[DEBUG][WEAPON] Player", source, "| XP:", xp, "| Nível:", level)
        TriggerClientEvent('pvp:notification', source, 'Seu nível: ' .. level .. ' | XP: ' .. xp, 'info')
    end)
end)

-- Comando para atualizar nível em tempo real
RegisterCommand("updatelevel", function(source, args)
    local identifier = GetPlayerIdentifier(source, 0)
    
    if not identifier then
        print("[DEBUG][WEAPON] Identifier não encontrado para source:", source)
        return
    end
    
    exports.oxmysql:execute('SELECT xp FROM player_xp WHERE identifier = ?', { identifier }, function(result)
        local xp = 0
        if result and result[1] then
            xp = tonumber(result[1].xp) or 0
        end
        
        -- Calcular nível
        local level = 1
        local fator = 1.25
        local base = 300
        while level < 100 do
            local nextMeta = math.floor(base * (level ^ fator))
            if xp < nextMeta then break end
            level = level + 1
        end
        if level >= 100 then level = 100 end
        
        print("[DEBUG][WEAPON] Enviando atualização de nível:", level, "para player", source)
        
        -- Enviar atualização para o cliente
        TriggerClientEvent('weapon:updateLevel', source, level)
    end)
end)

-- Limpar dados quando o jogador desconecta
AddEventHandler('playerDropped', function()
    local source = source
    if playerLastWeapons[source] then
        print('[DEBUG][WEAPON] Dados de última arma limpos para player', source)
        playerLastWeapons[source] = nil
    end
end) 