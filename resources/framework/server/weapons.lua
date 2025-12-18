-- PvP Framework - Weapons Management (Server)

local WeaponStats = {
    ["WEAPON_PISTOL"] = {
        name = "Pistol",
        damage = 25,
        range = 50,
        fireRate = 0.5,
        ammo = 100
    },
    ["WEAPON_COMBATPISTOL"] = {
        name = "Combat Pistol",
        damage = 30,
        range = 60,
        fireRate = 0.4,
        ammo = 100
    },
    ["WEAPON_ASSAULTRIFLE"] = {
        name = "Assault Rifle",
        damage = 35,
        range = 100,
        fireRate = 0.1,
        ammo = 200
    },
    ["WEAPON_CARBINERIFLE"] = {
        name = "Carbine Rifle",
        damage = 40,
        range = 120,
        fireRate = 0.08,
        ammo = 200
    },
    ["WEAPON_SMG"] = {
        name = "SMG",
        damage = 20,
        range = 80,
        fireRate = 0.05,
        ammo = 150
    }
}

-- Função para dar armas ao jogador
function GiveWeaponsToPlayer(playerId, weapons)
    print('[DEBUG][FRAMEWORK] GiveWeaponsToPlayer chamado:', playerId, weapons)
    
    -- Verificar se playerId é válido
    if not playerId or playerId == 0 then
        print('[DEBUG][FRAMEWORK] ERRO: playerId inválido:', playerId)
        return false
    end
    
    -- Verificar se o jogador existe na tabela Players
    if not Players[playerId] then 
        print('[DEBUG][FRAMEWORK] ERRO: Players[playerId] não existe para playerId:', playerId)
        print('[DEBUG][FRAMEWORK] Tabela Players atual:', json.encode(Players))
        
        -- Tentar criar o jogador se não existir
        print('[DEBUG][FRAMEWORK] Tentando criar jogador na tabela Players...')
        local playerData = {
            id = playerId,
            name = GetPlayerName(playerId) or "Unknown",
            kills = 0,
            deaths = 0,
            money = 1000,
            spawnTime = GetGameTimer(),
            isProtected = true,
            currentZone = nil,
            lastKill = 0,
            isTokenValid = false
        }
        SetPlayerData(playerId, playerData)
        print('[DEBUG][FRAMEWORK] Jogador criado na tabela Players:', playerId)
    end
    
    -- Verificar se o jogador é válido antes de chamar GetPlayerPed
    if not DoesEntityExist(GetPlayerPed(playerId)) then 
        print('[DEBUG][FRAMEWORK] ERRO: playerId inválido ou entidade não existe:', playerId)
        return false 
    end
    
    local player = GetPlayerPed(playerId)
    
    -- Remover todas as armas
    RemoveAllPedWeapons(player, true)
    
    -- Dar armas especificadas
    for _, weapon in ipairs(weapons) do
        local weaponHash = GetHashKey(weapon)
        
        -- Verificar se é uma arma customizada e obter munição apropriada
        local ammo = 100
        if WeaponSkins and WeaponSkins.IsCustomWeapon(weapon) then
            ammo = WeaponSkins.GetCustomWeaponAmmo(weapon)
            print('[DEBUG][FRAMEWORK] Arma customizada detectada:', weapon, 'Ammo:', ammo)
        else
            ammo = Config.WeaponAmmo[weapon] or 100
        end
        
        GiveWeaponToPed(player, weaponHash, ammo, false, true)
    end
    
    Utils.SendNotification(playerId, "Armas recebidas!", "success")
    return true
end

-- Função para dar arma específica
function GiveWeaponToPlayer(playerId, weapon, ammo)
    print('[DEBUG][FRAMEWORK] GiveWeaponToPlayer chamado:', playerId, weapon, ammo)
    
    -- Verificar se playerId é válido
    if not playerId or playerId == 0 then
        print('[DEBUG][FRAMEWORK] ERRO: playerId inválido:', playerId)
        return false
    end
    
    -- Verificar se o jogador existe na tabela Players
    if not Players[playerId] then 
        print('[DEBUG][FRAMEWORK] ERRO: Players[playerId] não existe para playerId:', playerId)
        print('[DEBUG][FRAMEWORK] Tabela Players atual:', json.encode(Players))
        
        -- Tentar criar o jogador se não existir
        print('[DEBUG][FRAMEWORK] Tentando criar jogador na tabela Players...')
        local playerData = {
            id = playerId,
            name = GetPlayerName(playerId) or "Unknown",
            kills = 0,
            deaths = 0,
            money = 1000,
            spawnTime = GetGameTimer(),
            isProtected = true,
            currentZone = nil,
            lastKill = 0,
            isTokenValid = false
        }
        SetPlayerData(playerId, playerData)
        print('[DEBUG][FRAMEWORK] Jogador criado na tabela Players:', playerId)
    end
    
    -- Verificar se o jogador é válido antes de chamar GetPlayerPed
    if not DoesEntityExist(GetPlayerPed(playerId)) then 
        print('[DEBUG][FRAMEWORK] ERRO: playerId inválido ou entidade não existe:', playerId)
        return false 
    end
    
    local player = GetPlayerPed(playerId)
    local weaponHash = GetHashKey(weapon)
    
    -- Verificar se é uma arma customizada e obter munição apropriada
    local finalAmmo = ammo or 100
    if WeaponSkins and WeaponSkins.IsCustomWeapon(weapon) then
        finalAmmo = ammo or WeaponSkins.GetCustomWeaponAmmo(weapon)
        print('[DEBUG][FRAMEWORK] Arma customizada detectada:', weapon, 'Ammo:', finalAmmo)
    else
        finalAmmo = ammo or Config.WeaponAmmo[weapon] or 100
    end
    
    print('[DEBUG][FRAMEWORK] Dando arma ao jogador:', playerId, 'Arma:', weapon, 'Hash:', weaponHash, 'Ammo:', finalAmmo)
    
    GiveWeaponToPed(player, weaponHash, finalAmmo, false, true)
    
    -- Disparar evento para o cliente
    print('[DEBUG][FRAMEWORK] Enviando evento para cliente:', playerId, 'Arma:', weapon)
    TriggerClientEvent('pvp:giveWeapon', playerId, weapon)
    
    -- Não é possível verificar se a arma foi dada no server-side (HasPedGotWeapon é client-only)
    
    local weaponName = WeaponStats[weapon] and WeaponStats[weapon].name or weapon
    if Utils and Utils.SendNotification then
        Utils.SendNotification(playerId, "Recebeu: " .. weaponName, "success")
    else
        print('[DEBUG][FRAMEWORK] Utils.SendNotification não disponível')
    end
    
    return true
end

-- Função para remover arma do jogador
function RemoveWeaponFromPlayer(playerId, weapon)
    print('[DEBUG][FRAMEWORK] RemoveWeaponFromPlayer chamado:', playerId, weapon)
    
    -- Verificar se playerId é válido
    if not playerId or playerId == 0 then
        print('[DEBUG][FRAMEWORK] ERRO: playerId inválido:', playerId)
        return false
    end
    
    -- Verificar se o jogador existe na tabela Players
    if not Players[playerId] then 
        print('[DEBUG][FRAMEWORK] ERRO: Players[playerId] não existe para playerId:', playerId)
        return false
    end
    
    -- Verificar se o jogador é válido antes de chamar GetPlayerPed
    if not DoesEntityExist(GetPlayerPed(playerId)) then 
        print('[DEBUG][FRAMEWORK] ERRO: playerId inválido ou entidade não existe:', playerId)
        return false 
    end
    
    local player = GetPlayerPed(playerId)
    local weaponHash = GetHashKey(weapon)
    
    RemoveWeaponFromPed(player, weaponHash)
    
    local weaponName = WeaponStats[weapon] and WeaponStats[weapon].name or weapon
    Utils.SendNotification(playerId, "Arma removida: " .. weaponName, "info")
    return true
end

-- Função para obter armas do jogador
function GetPlayerWeapons(playerId)
    print('[DEBUG][FRAMEWORK] GetPlayerWeapons chamado:', playerId)
    
    -- Verificar se playerId é válido
    if not playerId or playerId == 0 then
        print('[DEBUG][FRAMEWORK] ERRO: playerId inválido:', playerId)
        return {}
    end
    
    -- Verificar se o jogador existe na tabela Players
    if not Players[playerId] then 
        print('[DEBUG][FRAMEWORK] ERRO: Players[playerId] não existe para playerId:', playerId)
        return {}
    end
    
    -- Verificar se o jogador é válido antes de chamar GetPlayerPed
    if not DoesEntityExist(GetPlayerPed(playerId)) then 
        print('[DEBUG][FRAMEWORK] ERRO: playerId inválido ou entidade não existe:', playerId)
        return {} 
    end
    
    local player = GetPlayerPed(playerId)
    local weapons = {}
    
    -- Não é possível checar armas do jogador no server-side (HasPedGotWeapon é client-only)
    
    return weapons
end

-- Função para obter todas as armas do jogador (incluindo as que não estão no Config)
function GetAllPlayerWeapons(playerId)
    -- Verificar se o jogador é válido antes de chamar GetPlayerPed
    if not playerId or not DoesEntityExist(GetPlayerPed(playerId)) then return {} end
    local player = GetPlayerPed(playerId)
    local weapons = {}
    
    -- Lista de todas as armas possíveis para verificar
    local allWeapons = {
        "WEAPON_PISTOL", "WEAPON_COMBATPISTOL", "WEAPON_ASSAULTRIFLE", "WEAPON_CARBINERIFLE", "WEAPON_SMG",
        "WEAPON_PUMPSHOTGUN", "WEAPON_SNIPERRIFLE", "WEAPON_HEAVYSNIPER", "WEAPON_RPG", "WEAPON_MINIGUN",
        "WEAPON_KNIFE", "WEAPON_BAT", "WEAPON_CROWBAR", "WEAPON_GOLFCLUB", "WEAPON_BOTTLE",
        "WEAPON_DAGGER", "WEAPON_HATCHET", "WEAPON_KNUCKLE", "WEAPON_MACHETE", "WEAPON_SWITCHBLADE",
        "WEAPON_WRENCH", "WEAPON_BATTLEAXE", "WEAPON_POOLCUE", "WEAPON_STONE_HATCHET", "WEAPON_CANDYCANE",
        "WEAPON_ANTIQUE_CARBINERIFLE", "WEAPON_BASICBAT", "WEAPON_BROOM", "WEAPON_CAR_WASH", "WEAPON_BRICK",
        "WEAPON_FLASHLIGHT", "WEAPON_HAMMER", "WEAPON_HATCHET_01", "WEAPON_KNUCKLE_01", "WEAPON_LAUNCHER_01",
        "WEAPON_MACHETE_01", "WEAPON_SLEDGEHAMMER", "WEAPON_SNOWBALL", "WEAPON_TORCH", "WEAPON_WRENCH_01",
        "WEAPON_ASSAULTRIFLE_MK2", "WEAPON_CARBINERIFLE_MK2", "WEAPON_COMBATMG_MK2", "WEAPON_HEAVYSNIPER_MK2",
        "WEAPON_PISTOL_MK2", "WEAPON_SMG_MK2", "WEAPON_SNSPISTOL_MK2", "WEAPON_SPECIALCARBINE_MK2",
        "WEAPON_BULLPUPRIFLE_MK2", "WEAPON_PUMPSHOTGUN_MK2", "WEAPON_REVOLVER_MK2", "WEAPON_SNSPISTOL_MK2",
        "WEAPON_SPECIALCARBINE_MK2", "WEAPON_BULLPUPRIFLE_MK2", "WEAPON_PUMPSHOTGUN_MK2", "WEAPON_REVOLVER_MK2"
    }
    
    -- Não é possível checar armas do jogador no server-side (HasPedGotWeapon é client-only)
    
    return weapons
end

-- Função para recarregar munição
function ReloadPlayerAmmo(playerId)
    print('[DEBUG][FRAMEWORK] ReloadPlayerAmmo chamado:', playerId)
    
    -- Verificar se playerId é válido
    if not playerId or playerId == 0 then
        print('[DEBUG][FRAMEWORK] ERRO: playerId inválido:', playerId)
        return false
    end
    
    -- Verificar se o jogador existe na tabela Players
    if not Players[playerId] then 
        print('[DEBUG][FRAMEWORK] ERRO: Players[playerId] não existe para playerId:', playerId)
        return false
    end
    
    -- Verificar se o jogador é válido antes de chamar GetPlayerPed
    if not DoesEntityExist(GetPlayerPed(playerId)) then 
        print('[DEBUG][FRAMEWORK] ERRO: playerId inválido ou entidade não existe:', playerId)
        return false 
    end
    
    local player = GetPlayerPed(playerId)
    
    -- Não é possível checar armas do jogador no server-side (HasPedGotWeapon é client-only)
    
    Utils.SendNotification(playerId, "Munição recarregada!", "success")
    return true
end

-- Evento para dar armas
RegisterNetEvent('pvp:giveWeapons')
AddEventHandler('pvp:giveWeapons', function(weapons)
    local source = source
    GiveWeaponsToPlayer(source, weapons or Config.DefaultWeapons)
end)

-- Evento para dar arma específica
RegisterNetEvent('pvp:giveWeapon')
AddEventHandler('pvp:giveWeapon', function(weapon, ammo)
    local source = source
    ammo = ammo or 100
    print('[DEBUG][FRAMEWORK] pvp:giveWeapon', source, weapon, ammo)
    GiveWeaponToPlayer(source, weapon, ammo)
end)

-- Evento para equipar arma (chamado pelo cliente)
RegisterNetEvent('pvp:equipWeapon')
AddEventHandler('pvp:equipWeapon', function(weapon, ammo)
    local source = source
    ammo = ammo or 100
    print('[DEBUG][FRAMEWORK] pvp:equipWeapon', source, weapon, ammo)
    
    -- Verificar se o jogador existe
    if not source or source == 0 then
        print('[DEBUG][FRAMEWORK] ERRO: source inválido:', source)
        return
    end
    
    -- Verificar se a arma é válida
    if not weapon or weapon == "" then
        print('[DEBUG][FRAMEWORK] ERRO: weapon inválida:', weapon)
        return
    end
    
    -- Verificar se o jogador está na tabela Players
    print('[DEBUG][FRAMEWORK] Verificando Players[source]:', Players[source])
    print('[DEBUG][FRAMEWORK] Tabela Players:', json.encode(Players))
    
    print('[DEBUG][FRAMEWORK] Chamando GiveWeaponToPlayer...')
    local result = GiveWeaponToPlayer(source, weapon, ammo)
    print('[DEBUG][FRAMEWORK] Resultado GiveWeaponToPlayer:', result)
    
    -- Disparar evento para o cliente após dar a arma
    TriggerClientEvent('pvp:giveWeapon', source, weapon)
end)

-- Evento para remover arma
RegisterNetEvent('pvp:removeWeapon')
AddEventHandler('pvp:removeWeapon', function(weapon)
    local source = source
    RemoveWeaponFromPlayer(source, weapon)
end)

-- Evento para recarregar munição
RegisterNetEvent('pvp:reloadAmmo')
AddEventHandler('pvp:reloadAmmo', function()
    local source = source
    ReloadPlayerAmmo(source)
end)

-- Evento para obter armas do jogador
RegisterNetEvent('pvp:getPlayerWeapons')
AddEventHandler('pvp:getPlayerWeapons', function()
    local source = source
    local weapons = GetPlayerWeapons(source)
    TriggerClientEvent('pvp:receivePlayerWeapons', source, weapons)
end)

-- Comandos de armas
RegisterCommand('weapons', function(source, args, rawCommand)
    if source == 0 then -- Console
        local targetId = tonumber(args[1])
        if targetId and Players[targetId] then
            GiveWeaponsToPlayer(targetId, Config.DefaultWeapons)
            print("Armas dadas para jogador " .. targetId)
        else
            print("Uso: weapons <player_id>")
        end
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local targetId = tonumber(args[1])
        if targetId and Players[targetId] then
            GiveWeaponsToPlayer(targetId, Config.DefaultWeapons)
            TriggerClientEvent('pvp:notification', source, "Armas dadas para jogador " .. targetId, "success")
        else
            TriggerClientEvent('pvp:notification', source, "Uso: /weapons <player_id>", "error")
        end
    end
end, false)

RegisterCommand('reload', function(source, args, rawCommand)
    if source == 0 then -- Console
        local targetId = tonumber(args[1])
        if targetId and Players[targetId] then
            ReloadPlayerAmmo(targetId)
            print("Munição recarregada para jogador " .. targetId)
        else
            print("Uso: reload <player_id>")
        end
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local targetId = tonumber(args[1])
        if targetId and Players[targetId] then
            ReloadPlayerAmmo(targetId)
            TriggerClientEvent('pvp:notification', source, "Munição recarregada para jogador " .. targetId, "success")
        else
            TriggerClientEvent('pvp:notification', source, "Uso: /reload <player_id>", "error")
        end
    end
end, false)

RegisterCommand('giveweapon', function(source, args, rawCommand)
    if source == 0 then -- Console
        if #args < 2 then
            print("Uso: giveweapon <player_id> [arma] [munição]")
        return
    end
    
        local targetId = tonumber(args[1])
        local weapon = args[2]
        local ammo = tonumber(args[3]) or 100
        
        if targetId and WeaponStats[weapon] then
            GiveWeaponToPlayer(targetId, weapon, ammo)
            print("Arma " .. weapon .. " dada para jogador " .. targetId)
        else
            print("Parâmetros inválidos!")
        end
    else
        -- Verificar permissão para jogadores (temporariamente desabilitado)
        -- if not exports['framework']:HasPermission(source, "admin.giveweapon") then
        --     Utils.SendNotification(source, "Sem permissão!", "error")
        --     return
        -- end
        
        if #args < 2 then
            TriggerClientEvent('pvp:notification', source, "Uso: /giveweapon <player_id> [arma] [munição]", "error")
            return
        end
        
        local targetId = tonumber(args[1])
        local weapon = args[2]
        local ammo = tonumber(args[3]) or 100
        
        if targetId and WeaponStats[weapon] then
            GiveWeaponToPlayer(targetId, weapon, ammo)
            TriggerClientEvent('pvp:notification', source, "Arma " .. weapon .. " dada para jogador " .. targetId, "success")
        else
            TriggerClientEvent('pvp:notification', source, "Parâmetros inválidos!", "error")
        end
    end
end, false)

RegisterCommand('removeweapon', function(source, args, rawCommand)
    if source == 0 then -- Console
        if #args < 2 then
            print("Uso: removeweapon <player_id> [arma]")
            return
        end
        
        local targetId = tonumber(args[1])
        local weapon = args[2]
        
        if targetId then
            RemoveWeaponFromPlayer(targetId, weapon)
            print("Arma " .. weapon .. " removida do jogador " .. targetId)
        else
            print("Parâmetros inválidos!")
        end
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        if #args < 2 then
            TriggerClientEvent('pvp:notification', source, "Uso: /removeweapon <player_id> [arma]", "error")
        return
    end
    
        local targetId = tonumber(args[1])
        local weapon = args[2]
        
        if targetId then
            RemoveWeaponFromPlayer(targetId, weapon)
            TriggerClientEvent('pvp:notification', source, "Arma " .. weapon .. " removida do jogador " .. targetId, "success")
        else
            TriggerClientEvent('pvp:notification', source, "Parâmetros inválidos!", "error")
        end
    end
end, false)

RegisterCommand('myweapons', function(source, args, rawCommand)
    if source == 0 then -- Console
        local targetId = tonumber(args[1])
        if targetId and Players[targetId] then
            local weapons = GetPlayerWeapons(targetId)
            print("=== ARMAS DO JOGADOR " .. targetId .. " ===")
            for _, weapon in ipairs(weapons) do
                print(weapon.name .. " - Munição: " .. weapon.ammo)
            end
        else
            print("Uso: myweapons <player_id>")
        end
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        local targetId = tonumber(args[1])
        if targetId and Players[targetId] then
            local weapons = GetPlayerWeapons(targetId)
            TriggerClientEvent('pvp:notification', source, "Armas do jogador " .. targetId .. ":", "info")
            for _, weapon in ipairs(weapons) do
                TriggerClientEvent('pvp:notification', source, weapon.name .. " - Munição: " .. weapon.ammo, "info")
            end
        else
            TriggerClientEvent('pvp:notification', source, "Uso: /myweapons <player_id>", "error")
        end
    end
end, false)

-- Comando para adicionar jogador à tabela Players
RegisterCommand('addplayer', function(source, args, rawCommand)
    if source == 0 then
        local targetId = tonumber(args[1])
        if targetId then
            SetPlayerData(targetId, { name = GetPlayerName(targetId), id = targetId })
            print('[DEBUG] Jogador adicionado à tabela Players:', targetId)
        else
            print("Uso: addplayer <player_id>")
        end
    else
        SetPlayerData(source, { name = GetPlayerName(source), id = source })
        print('[DEBUG] Jogador adicionado à tabela Players:', source)
    end
end, false)

-- Comando para listar armas disponíveis
RegisterCommand('weaponlist', function(source, args, rawCommand)
    if source == 0 then -- Console
        Utils.Log("=== ARMAS DISPONÍVEIS ===")
        for weapon, stats in pairs(WeaponStats) do
            Utils.Log(string.format("%s - Dano: %d | Alcance: %d | Taxa: %.2f", 
                stats.name, stats.damage, stats.range, stats.fireRate))
        end
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        TriggerClientEvent('pvp:notification', source, "Armas disponíveis:", "info")
        for weapon, stats in pairs(WeaponStats) do
            TriggerClientEvent('pvp:notification', source, stats.name .. " - Dano: " .. stats.damage, "info")
        end
    end
end, false)

-- Comando para mudar cor da arma
RegisterCommand('weaponcolor', function(source, args, rawCommand)
    if source == 0 then -- Console
        if #args < 2 then
            print("Uso: weaponcolor <player_id> <color>")
            print("Cores disponíveis: 0-7")
            return
        end
        
        local targetId = tonumber(args[1])
        local color = tonumber(args[2])
        
        if targetId and color and color >= 0 and color <= 7 then
            TriggerClientEvent('pvp:setAllWeaponColors', targetId, color)
            print("Cor de todas as armas alterada para " .. color .. " no jogador " .. targetId)
        else
            print("Parâmetros inválidos!")
        end
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        if #args < 2 then
            TriggerClientEvent('pvp:notification', source, "Uso: /weaponcolor <player_id> <color>", "error")
            TriggerClientEvent('pvp:notification', source, "Cores disponíveis: 0-7", "info")
            return
        end
        
        local targetId = tonumber(args[1])
        local color = tonumber(args[2])
        
        if targetId and color and color >= 0 and color <= 7 then
            TriggerClientEvent('pvp:setAllWeaponColors', targetId, color)
            TriggerClientEvent('pvp:notification', source, "Cor de todas as armas alterada para " .. color .. " no jogador " .. targetId, "success")
            TriggerClientEvent('pvp:notification', targetId, "Cor de todas as suas armas foi alterada para " .. color, "success")
        else
            TriggerClientEvent('pvp:notification', source, "Parâmetros inválidos!", "error")
        end
    end
end, false)

-- Comando para listar cores de armas
RegisterCommand('weaponcolors', function(source, args, rawCommand)
    if source == 0 then -- Console
        print("=== CORES DE ARMAS DISPONÍVEIS ===")
        print("0 - Preto")
        print("1 - Verde")
        print("2 - Dourado")
        print("3 - Rosa")
        print("4 - Laranja")
        print("5 - Roxo")
        print("6 - Azul")
        print("7 - Vermelho")
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        TriggerClientEvent('pvp:notification', source, "=== CORES DE ARMAS DISPONÍVEIS ===", "info")
        TriggerClientEvent('pvp:notification', source, "0 - Preto | 1 - Verde | 2 - Dourado | 3 - Rosa", "info")
        TriggerClientEvent('pvp:notification', source, "4 - Laranja | 5 - Roxo | 6 - Azul | 7 - Vermelho", "info")
    end
end, false)

-- Comando para mudar cor de todas as armas
RegisterCommand('allweaponcolor', function(source, args, rawCommand)
    if source == 0 then -- Console
        if #args < 2 then
            print("Uso: allweaponcolor <player_id> <color>")
            print("Cores disponíveis: 0-7")
            return
        end
        
        local targetId = tonumber(args[1])
        local color = tonumber(args[2])
        
        if targetId and color and color >= 0 and color <= 7 then
            TriggerClientEvent('pvp:setAllWeaponColors', targetId, color)
            print("Cor de todas as armas alterada para " .. color .. " no jogador " .. targetId)
        else
            print("Parâmetros inválidos!")
        end
    else
        -- Verificar permissão admin
        if not exports['framework']:HasPermission(source, "admin.all") then
            TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
            return
        end
        
        if #args < 2 then
            TriggerClientEvent('pvp:notification', source, "Uso: /allweaponcolor <player_id> <color>", "error")
            TriggerClientEvent('pvp:notification', source, "Cores disponíveis: 0-7", "info")
            return
        end
        
        local targetId = tonumber(args[1])
        local color = tonumber(args[2])
        
        if targetId and color and color >= 0 and color <= 7 then
            TriggerClientEvent('pvp:setAllWeaponColors', targetId, color)
            TriggerClientEvent('pvp:notification', source, "Cor de todas as armas alterada para " .. color .. " no jogador " .. targetId, "success")
            TriggerClientEvent('pvp:notification', targetId, "Cor de todas as suas armas foi alterada para " .. color, "success")
        else
            TriggerClientEvent('pvp:notification', source, "Parâmetros inválidos!", "error")
        end
    end
end, false)

-- Função para verificar se jogador tem arma
function HasPlayerWeapon(playerId, weapon)
    print('[DEBUG][FRAMEWORK] HasPlayerWeapon chamado:', playerId, weapon)
    
    -- Verificar se playerId é válido
    if not playerId or playerId == 0 then
        print('[DEBUG][FRAMEWORK] ERRO: playerId inválido:', playerId)
        return false
    end
    
    -- Verificar se o jogador existe na tabela Players
    if not Players[playerId] then 
        print('[DEBUG][FRAMEWORK] ERRO: Players[playerId] não existe para playerId:', playerId)
        return false
    end
    
    -- Verificar se o jogador é válido antes de chamar GetPlayerPed
    if not DoesEntityExist(GetPlayerPed(playerId)) then 
        print('[DEBUG][FRAMEWORK] ERRO: playerId inválido ou entidade não existe:', playerId)
        return false 
    end
    
    -- Não é possível verificar armas no server-side (HasPedGotWeapon é client-only)
    print('[DEBUG][FRAMEWORK] HasPedGotWeapon não disponível no servidor')
    return false
end

-- Função para obter munição de uma arma
function GetPlayerWeaponAmmo(playerId, weapon)
    print('[DEBUG][FRAMEWORK] GetPlayerWeaponAmmo chamado:', playerId, weapon)
    
    -- Verificar se playerId é válido
    if not playerId or playerId == 0 then
        print('[DEBUG][FRAMEWORK] ERRO: playerId inválido:', playerId)
        return 0
    end
    
    -- Verificar se o jogador existe na tabela Players
    if not Players[playerId] then 
        print('[DEBUG][FRAMEWORK] ERRO: Players[playerId] não existe para playerId:', playerId)
        return 0
    end
    
    -- Verificar se o jogador é válido antes de chamar GetPlayerPed
    if not DoesEntityExist(GetPlayerPed(playerId)) then 
        print('[DEBUG][FRAMEWORK] ERRO: playerId inválido ou entidade não existe:', playerId)
        return 0 
    end
    
    -- Não é possível verificar munição no server-side (HasPedGotWeapon é client-only)
    print('[DEBUG][FRAMEWORK] GetAmmoInPedWeapon não disponível no servidor')
    return 0
end

-- Função para definir munição de uma arma
function SetPlayerWeaponAmmo(playerId, weapon, ammo)
    print('[DEBUG][FRAMEWORK] SetPlayerWeaponAmmo chamado:', playerId, weapon, ammo)
    
    -- Verificar se playerId é válido
    if not playerId or playerId == 0 then
        print('[DEBUG][FRAMEWORK] ERRO: playerId inválido:', playerId)
        return false
    end
    
    -- Verificar se o jogador existe na tabela Players
    if not Players[playerId] then 
        print('[DEBUG][FRAMEWORK] ERRO: Players[playerId] não existe para playerId:', playerId)
        return false
    end
    
    -- Verificar se o jogador é válido antes de chamar GetPlayerPed
    if not DoesEntityExist(GetPlayerPed(playerId)) then 
        print('[DEBUG][FRAMEWORK] ERRO: playerId inválido ou entidade não existe:', playerId)
        return false 
    end
    
    -- Não é possível definir munição no server-side (SetPedAmmo é client-only)
    print('[DEBUG][FRAMEWORK] SetPedAmmo não disponível no servidor')
    return false
end

-- Função para equipar todos os attachments em todas as armas do jogador
function EquipAllAttachments(playerId)
    print("[DEBUG] EquipAllAttachments chamado para jogador:", playerId)
    
    -- Verificar se o jogador é válido antes de chamar GetPlayerPed
    if not playerId or not DoesEntityExist(GetPlayerPed(playerId)) then 
        print("[DEBUG] Jogador inválido ou não existe")
        return false 
    end
    
    -- Funções de attachments não estão disponíveis no servidor
    print("[DEBUG] Funções de attachments não disponíveis no servidor")
    Utils.SendNotification(playerId, "Attachments devem ser equipados no cliente!", "info")
    return false
end

-- Comando simplificado para equipar attachments
RegisterCommand('attachments', function(source, args, rawCommand)
    print("[DEBUG] Comando attachments chamado por:", source, "args:", json.encode(args))
    
    if source == 0 then -- Console
        local targetId = tonumber(args[1])
        if targetId and Players[targetId] then
            print("[DEBUG] Executando attachments para jogador:", targetId)
            -- Enviar evento para o cliente equipar attachments
            TriggerClientEvent('pvp:equipAttachments', targetId)
            print("Evento de attachments enviado para jogador " .. targetId)
        else
            print("Uso: attachments <player_id>")
        end
    else
        local targetId = tonumber(args[1])
        print("[DEBUG] TargetId:", targetId)
        
        if targetId then
            -- Equipar attachments em outro jogador (requer permissão admin)
            if not exports['framework']:HasPermission(source, "admin.all") then
                print("[DEBUG] Sem permissão admin")
                TriggerClientEvent('pvp:notification', source, "Você não tem permissão para usar este comando!", "error")
                return
            end
            
            if Players[targetId] then
                print("[DEBUG] Executando attachments para jogador:", targetId)
                TriggerClientEvent('pvp:equipAttachments', targetId)
                TriggerClientEvent('pvp:notification', source, "Attachments equipados para jogador " .. targetId, "success")
            else
                print("[DEBUG] Jogador não encontrado:", targetId)
                TriggerClientEvent('pvp:notification', source, "Jogador não encontrado!", "error")
            end
        else
            -- Equipar attachments em si mesmo
            print("[DEBUG] Executando attachments para si mesmo:", source)
            TriggerClientEvent('pvp:equipAttachments', source)
            TriggerClientEvent('pvp:notification', source, "Equipando attachments...", "info")
        end
    end
end, false)

-- Comando muito simples para testar
RegisterCommand('simpleattachments', function(source, args, rawCommand)
    print("[DEBUG] Comando simpleattachments chamado por:", source)
    
    if source == 0 then return end -- Apenas jogadores
    
    -- Enviar evento para o cliente equipar attachments
    TriggerClientEvent('pvp:equipSimpleAttachments', source)
    TriggerClientEvent('pvp:notification', source, "Equipando attachments simples...", "info")
end, false)

-- Comando de teste para verificar se está funcionando
RegisterCommand('testattachments', function(source, args, rawCommand)
    print("[DEBUG] Comando testattachments chamado por:", source)
    TriggerClientEvent('pvp:notification', source, "Comando de teste funcionando!", "success")
end, false)

-- Comando para testar o sistema de armas salvas
RegisterCommand('testweapons', function(source, args, rawCommand)
    if source == 0 then return end -- Apenas jogadores
    
    local playerData = GetPlayerData(source)
    if not playerData then
        TriggerClientEvent('pvp:notification', source, "Dados do jogador não encontrados!", "error")
        return
    end
    
    if playerData.lastWeapons and #playerData.lastWeapons > 0 then
        local weaponList = ""
        for i, weaponData in ipairs(playerData.lastWeapons) do
            weaponList = weaponList .. weaponData.weapon
            if i < #playerData.lastWeapons then
                weaponList = weaponList .. ", "
            end
        end
        TriggerClientEvent('pvp:notification', source, "Armas salvas: " .. weaponList, "success")
        Utils.Log("Jogador " .. playerData.name .. " tem " .. #playerData.lastWeapons .. " armas salvas")
    else
        TriggerClientEvent('pvp:notification', source, "Nenhuma arma salva encontrada!", "info")
        Utils.Log("Jogador " .. playerData.name .. " não tem armas salvas")
    end
end, false)

-- Comando para limpar armas salvas
RegisterCommand('clearweapons', function(source, args, rawCommand)
    if source == 0 then return end -- Apenas jogadores
    
    local playerData = GetPlayerData(source)
    if not playerData then
        TriggerClientEvent('pvp:notification', source, "Dados do jogador não encontrados!", "error")
        return
    end
    
    if playerData.lastWeapons then
        playerData.lastWeapons = nil
        TriggerClientEvent('pvp:notification', source, "Armas salvas limpas!", "success")
        Utils.Log("Armas salvas limpas para jogador " .. playerData.name)
    else
        TriggerClientEvent('pvp:notification', source, "Nenhuma arma salva para limpar!", "info")
    end
end, false)

-- Exportar funções
exports('GiveWeaponsToPlayer', GiveWeaponsToPlayer)
exports('GiveWeaponToPlayer', GiveWeaponToPlayer)
exports('RemoveWeaponFromPlayer', RemoveWeaponFromPlayer)
exports('GetPlayerWeapons', GetPlayerWeapons)
exports('ReloadPlayerAmmo', ReloadPlayerAmmo)
exports('HasPlayerWeapon', HasPlayerWeapon)
exports('GetPlayerWeaponAmmo', GetPlayerWeaponAmmo)
exports('SetPlayerWeaponAmmo', SetPlayerWeaponAmmo)
exports('EquipAllAttachments', EquipAllAttachments) 

-- Comandos para armas customizadas
RegisterCommand("givecustomweapon", function(source, args, rawCommand)
    if source == 0 then -- Console
        local targetId = tonumber(args[1])
        local weaponName = args[2]
        local ammo = tonumber(args[3]) or 200
        
        if not targetId or not weaponName then
            print("Uso: givecustomweapon <player_id> <weapon_name> [ammo]")
            return
        end
        
        if WeaponSkins and WeaponSkins.ValidateCustomWeapon(weaponName) then
            GiveWeaponToPlayer(targetId, weaponName, ammo)
            print("Arma customizada dada ao jogador:", targetId, weaponName)
        else
            print("Arma customizada inválida:", weaponName)
        end
    else
        -- Verificar permissão para jogadores (temporariamente desabilitado)
        -- if not exports['framework']:HasPermission(source, "admin.giveweapon") then
        --     Utils.SendNotification(source, "Sem permissão!", "error")
        --     return
        -- end
        
        local targetId = tonumber(args[1])
        local weaponName = args[2]
        local ammo = tonumber(args[3]) or 200
        
        if not targetId or not weaponName then
            Utils.SendNotification(source, "Uso: /givecustomweapon <player_id> <weapon_name> [ammo]", "error")
            return
        end
        
        if WeaponSkins and WeaponSkins.ValidateCustomWeapon(weaponName) then
            GiveWeaponToPlayer(targetId, weaponName, ammo)
            Utils.SendNotification(source, "Arma customizada dada ao jogador " .. targetId, "success")
        else
            Utils.SendNotification(source, "Arma customizada inválida: " .. weaponName, "error")
        end
    end
end, false)

-- Comando para listar armas customizadas disponíveis
RegisterCommand("listcustomweapons", function(source, args, rawCommand)
    if not WeaponSkins or not Config.CustomWeaponSkins or not Config.CustomWeaponSkins.enabled then
        if source == 0 then
            print("Sistema de armas customizadas desabilitado")
        else
            Utils.SendNotification(source, "Sistema de armas customizadas desabilitado", "error")
        end
        return
    end
    
    local categories = WeaponSkins.GetWeaponsByCategory()
    local message = "Armas customizadas disponíveis:\n"
    
    for category, weapons in pairs(categories) do
        if #weapons > 0 then
            message = message .. "\n" .. category .. ":\n"
            for _, weapon in ipairs(weapons) do
                local displayName = WeaponSkins.GetWeaponDisplayName(weapon)
                local ammo = WeaponSkins.GetCustomWeaponAmmo(weapon)
                message = message .. "  - " .. displayName .. " (" .. weapon .. ") - " .. ammo .. " munição\n"
            end
        end
    end
    
    if source == 0 then
        print(message)
    else
        Utils.SendNotification(source, message, "info")
    end
end, false)

-- Comando para dar todas as armas customizadas
RegisterCommand("giveallcustomweapons", function(source, args, rawCommand)
    if source == 0 then -- Console
        local targetId = tonumber(args[1])
        
        if not targetId then
            print("Uso: giveallcustomweapons <player_id>")
            return
        end
        
        if WeaponSkins and Config.CustomWeaponSkins and Config.CustomWeaponSkins.enabled then
            GiveWeaponsToPlayer(targetId, Config.CustomWeaponSkins.skins)
            print("Todas as armas customizadas dadas ao jogador:", targetId)
        else
            print("Sistema de armas customizadas desabilitado")
        end
    else
        -- Verificar permissão para jogadores (temporariamente desabilitado)
        -- if not exports['framework']:HasPermission(source, "admin.giveweapon") then
        --     Utils.SendNotification(source, "Sem permissão!", "error")
        --     return
        -- end
        
        local targetId = tonumber(args[1])
        
        if not targetId then
            Utils.SendNotification(source, "Uso: /giveallcustomweapons <player_id>", "error")
            return
        end
        
        if WeaponSkins and Config.CustomWeaponSkins and Config.CustomWeaponSkins.enabled then
            GiveWeaponsToPlayer(targetId, Config.CustomWeaponSkins.skins)
            Utils.SendNotification(source, "Todas as armas customizadas dadas ao jogador " .. targetId, "success")
        else
            Utils.SendNotification(source, "Sistema de armas customizadas desabilitado", "error")
        end
    end
end, false) 

-- Comando de teste para armas customizadas
RegisterCommand("testcustomweapon", function(source, args, rawCommand)
    if source == 0 then return end -- Apenas jogadores
    
    local weaponName = "WEAPON_GOATROSA" -- Arma de teste
    

    
    if WeaponSkins and Config.CustomWeaponSkins then

    end
    
    -- Testar dar a arma
    GiveWeaponToPlayer(source, weaponName, 200)
    
    Utils.SendNotification(source, "Teste de arma customizada executado! Verifique o console.", "info")
end, false) 