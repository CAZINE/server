-- PvP Framework - Weapons Client

-- Verificar se Config foi carregado
if not Config then
    print('[ERROR] Config não foi carregado! Verificando em 1 segundo...')
    CreateThread(function()
        Wait(1000)
        if not Config then
            print('[ERROR] Config ainda não foi carregado após 1 segundo!')
        else
            print('[DEBUG] Config carregado com sucesso!')
        end
    end)
end

local PlayerWeapons = {}
local CurrentWeapon = nil

-- Função para obter arma atual
function GetCurrentWeapon()
    local player = PlayerPedId()
    return GetSelectedPedWeapon(player)
end

-- Função para obter nome da arma atual
function GetCurrentWeaponName()
    local weaponHash = GetCurrentWeapon()
    return Utils.GetWeaponName(weaponHash)
end

-- Função para obter munição da arma atual
function GetCurrentWeaponAmmo()
    local player = PlayerPedId()
    local weaponHash = GetSelectedPedWeapon(player)
    
    if weaponHash ~= GetHashKey("WEAPON_UNARMED") then
        return GetAmmoInPedWeapon(player, weaponHash)
    end
    
    return 0
end

-- Função para verificar se tem munição
function HasAmmo(weapon)
    local player = PlayerPedId()
    local weaponHash = GetHashKey(weapon)
    
    return GetAmmoInPedWeapon(player, weaponHash) > 0
end

-- Função para recarregar arma atual
function ReloadCurrentWeapon()
    local player = PlayerPedId()
    local weaponHash = GetSelectedPedWeapon(player)
    
    if weaponHash ~= GetHashKey("WEAPON_UNARMED") then
        local weaponName = Utils.GetWeaponName(weaponHash)
        local maxAmmo = 100
        
        -- Verificar se é uma arma customizada e obter munição apropriada
        if WeaponSkins and WeaponSkins.IsCustomWeapon(weaponName) then
            maxAmmo = WeaponSkins.GetCustomWeaponAmmo(weaponName)
            print('[DEBUG][FRAMEWORK] Recarregando arma customizada:', weaponName, 'Ammo:', maxAmmo)
        else
            maxAmmo = Config.WeaponAmmo[weaponName] or 100
        end
        
        SetPedAmmo(player, weaponHash, maxAmmo)
        
        Utils.SendNotification(nil, "Arma recarregada!", "success")
        return true
    end
    
    return false
end

-- Função para desequipar arma atual
function UnequipCurrentWeapon()
    local player = PlayerPedId()
    local currentWeapon = GetSelectedPedWeapon(player)
    
    if currentWeapon ~= GetHashKey("WEAPON_UNARMED") then
        print('[FRAMEWORK][CLIENT] Desequipando arma atual:', currentWeapon)
        
        -- Método mais agressivo para desequipar
        SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)
        Wait(100) -- Aumentar o tempo de espera
        
        -- Verificar se foi desequipada e forçar novamente se necessário
        local checkWeapon = GetSelectedPedWeapon(player)
        if checkWeapon ~= GetHashKey("WEAPON_UNARMED") then
            print('[FRAMEWORK][CLIENT] Forçando desequipamento novamente')
            SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)
            Wait(50)
        end
        
        return true
    end
    
    return false
end

-- Função para forçar desequipamento de todas as armas
function ForceUnequipAllWeapons()
    local player = PlayerPedId()
    print('[FRAMEWORK][CLIENT] Forçando desequipamento de todas as armas')
    
    -- Forçar desequipamento múltiplas vezes
    for i = 1, 3 do
        SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)
        Wait(50)
    end
    
    -- Verificar se foi bem sucedido
    local finalWeapon = GetSelectedPedWeapon(player)
    if finalWeapon == GetHashKey("WEAPON_UNARMED") then
        print('[FRAMEWORK][CLIENT] Desequipamento forçado bem sucedido')
        return true
    else
        print('[FRAMEWORK][CLIENT] Falha no desequipamento forçado, arma atual:', finalWeapon)
        return false
    end
end

-- Função para obter todas as armas do jogador
function GetPlayerWeapons()
    local player = PlayerPedId()
    local weapons = {}
    
    -- Verificar armas padrão
    for _, weapon in ipairs(Config.DefaultWeapons) do
        local weaponHash = GetHashKey(weapon)
        if HasPedGotWeapon(player, weaponHash, false) then
            local ammo = GetAmmoInPedWeapon(player, weaponHash)
            table.insert(weapons, {
                weapon = weapon,
                name = Utils.GetWeaponName(weaponHash),
                ammo = ammo,
                hash = weaponHash,
                isCustom = WeaponSkins and WeaponSkins.IsCustomWeapon(weapon) or false
            })
        end
    end
    
    -- Verificar armas customizadas adicionais
    if WeaponSkins and Config.CustomWeaponSkins and Config.CustomWeaponSkins.enabled then
        for _, weapon in ipairs(Config.CustomWeaponSkins.skins) do
            local weaponHash = GetHashKey(weapon)
            if HasPedGotWeapon(player, weaponHash, false) then
                local ammo = GetAmmoInPedWeapon(player, weaponHash)
                table.insert(weapons, {
                    weapon = weapon,
                    name = WeaponSkins.GetWeaponDisplayName(weapon),
                    ammo = ammo,
                    hash = weaponHash,
                    isCustom = true
                })
            end
        end
    end
    
    return weapons
end

-- Função para mostrar informações da arma
function ShowWeaponInfo()
    local weaponHash = GetCurrentWeapon()
    local weaponName = Utils.GetWeaponName(weaponHash)
    local ammo = GetCurrentWeaponAmmo()
    
    if weaponHash ~= GetHashKey("WEAPON_UNARMED") then
        Utils.SendNotification(nil, "Arma: " .. weaponName .. " | Munição: " .. ammo, "info")
    else
        Utils.SendNotification(nil, "Nenhuma arma selecionada", "info")
    end
end

-- Evento para receber armas do servidor
RegisterNetEvent('pvp:receivePlayerWeapons')
AddEventHandler('pvp:receivePlayerWeapons', function(weapons)
    PlayerWeapons = weapons
end)

-- Evento para dar armas
RegisterNetEvent('pvp:giveWeapons')
AddEventHandler('pvp:giveWeapons', function(weapons)
    local player = PlayerPedId()
    
    -- Primeiro, desequipar a arma atual
    UnequipCurrentWeapon()
    
    -- Remover todas as armas
    RemoveAllPedWeapons(player, true)
    
    -- Dar armas
    for _, weapon in ipairs(weapons) do
        local weaponHash = GetHashKey(weapon)
        local ammo = Config.WeaponAmmo[weapon] or 100
        
        GiveWeaponToPed(player, weaponHash, ammo, false, true)
    end
    
    Utils.SendNotification(nil, "Armas recebidas!", "success")
    
    -- Atualizar slots do HUD após receber armas
    UpdateHUDWeaponSlots()
end)

RegisterNetEvent('pvp:giveWeapon')
AddEventHandler('pvp:giveWeapon', function(weapon)
    print('[FRAMEWORK][CLIENT] pvp:giveWeapon recebido:', weapon)
    local player = PlayerPedId()
    local weaponHash = GetHashKey(weapon)
    
    -- Verificar se é uma arma customizada e obter munição apropriada
    local ammo = 100
    if WeaponSkins and WeaponSkins.IsCustomWeapon(weapon) then
        ammo = WeaponSkins.GetCustomWeaponAmmo(weapon)
        print('[FRAMEWORK][CLIENT] Arma customizada detectada:', weapon, 'Ammo:', ammo)
    else
        ammo = Config.WeaponAmmo[weapon] or 100
    end
    
    print('[FRAMEWORK][CLIENT] Tentando equipar arma:', weapon, 'Hash:', weaponHash, 'Ammo:', ammo)
    
    -- Dar a arma ao jogador
        GiveWeaponToPed(player, weaponHash, ammo, false, true)
        print('[FRAMEWORK][CLIENT] Arma dada com sucesso')
    
    -- Aguardar um pouco para garantir que a arma foi dada
    Wait(200)
    
    -- Verificar se a arma foi dada
    if HasPedGotWeapon(player, weaponHash, false) then
        print('[FRAMEWORK][CLIENT] Arma confirmada no inventário')
        
        -- Equipar a arma
    SetCurrentPedWeapon(player, weaponHash, true)
        print('[FRAMEWORK][CLIENT] Arma equipada')
        
        -- Aguardar mais um pouco para garantir que foi equipada
        Wait(100)
    
        -- Verificar se foi equipada corretamente
    local currentWeapon = GetSelectedPedWeapon(player)
    print('[FRAMEWORK][CLIENT] Arma atual após equipar:', currentWeapon, 'Esperado:', weaponHash)
    
        if currentWeapon == weaponHash then
            local displayName = WeaponSkins and WeaponSkins.GetWeaponDisplayName(weapon) or weapon
            Utils.SendNotification(nil, 'Arma equipada: ' .. displayName, 'success')
            print('[FRAMEWORK][CLIENT] Arma equipada com sucesso:', displayName)
        else
            Utils.SendNotification(nil, 'Erro ao equipar arma: ' .. weapon, 'error')
            print('[FRAMEWORK][CLIENT] Erro ao equipar arma')
        end
    else
        print('[FRAMEWORK][CLIENT] ERRO: Arma não foi dada ao jogador')
        Utils.SendNotification(nil, 'Erro ao dar arma: ' .. weapon, 'error')
    end
    
    -- Atualizar slots do HUD após equipar arma (com delay para armas customizadas)
    Wait(300)
    UpdateHUDWeaponSlots()
end)

-- Evento para equipar attachments
RegisterNetEvent('pvp:equipAttachments')
AddEventHandler('pvp:equipAttachments', function()
    local player = PlayerPedId()
    print('[FRAMEWORK][CLIENT] Equipando attachments...')
    
    -- Lista de armas para equipar attachments
    local weapons = {"WEAPON_PISTOL", "WEAPON_COMBATPISTOL", "WEAPON_ASSAULTRIFLE", "WEAPON_CARBINERIFLE", "WEAPON_SMG"}
    local attachmentsEquipped = 0
    
    for _, weapon in ipairs(weapons) do
        local weaponHash = GetHashKey(weapon)
        if HasPedGotWeapon(player, weaponHash, false) then
            print('[FRAMEWORK][CLIENT] Equipando attachments em:', weapon)
            
            -- Tentar equipar silenciador
            if HasPedGotWeaponComponent(player, weaponHash, GetHashKey("COMPONENT_AT_PI_SUPP")) then
                GiveWeaponComponentToPed(player, weaponHash, GetHashKey("COMPONENT_AT_PI_SUPP"))
                print('[FRAMEWORK][CLIENT] Silenciador equipado em:', weapon)
            elseif HasPedGotWeaponComponent(player, weaponHash, GetHashKey("COMPONENT_AT_AR_SUPP")) then
                GiveWeaponComponentToPed(player, weaponHash, GetHashKey("COMPONENT_AT_AR_SUPP"))
                print('[FRAMEWORK][CLIENT] Silenciador equipado em:', weapon)
            end
            
            -- Tentar equipar mira
            if HasPedGotWeaponComponent(player, weaponHash, GetHashKey("COMPONENT_AT_SCOPE_MACRO")) then
                GiveWeaponComponentToPed(player, weaponHash, GetHashKey("COMPONENT_AT_SCOPE_MACRO"))
                print('[FRAMEWORK][CLIENT] Mira equipada em:', weapon)
            end
            
            -- Definir cor dourada
            SetPedWeaponTintIndex(player, weaponHash, 2)
            print('[FRAMEWORK][CLIENT] Cor definida para dourado em:', weapon)
            
            attachmentsEquipped = attachmentsEquipped + 1
        end
    end
    
    if attachmentsEquipped > 0 then
        Utils.SendNotification(nil, "Attachments equipados em " .. attachmentsEquipped .. " armas!", "success")
    else
        Utils.SendNotification(nil, "Nenhuma arma encontrada para equipar attachments!", "error")
    end
end)

-- Evento para equipar attachments simples
RegisterNetEvent('pvp:equipSimpleAttachments')
AddEventHandler('pvp:equipSimpleAttachments', function()
    local player = PlayerPedId()
    print('[FRAMEWORK][CLIENT] Equipando attachments simples...')
    
    -- Tentar equipar silenciador na pistola
    local weaponHash = GetHashKey("WEAPON_PISTOL")
    if HasPedGotWeapon(player, weaponHash, false) then
        print('[FRAMEWORK][CLIENT] Jogador tem pistola')
        
        -- Tentar equipar silenciador
        local suppressorHash = GetHashKey("COMPONENT_AT_PI_SUPP")
        if HasPedGotWeaponComponent(player, weaponHash, suppressorHash) then
            GiveWeaponComponentToPed(player, weaponHash, suppressorHash)
            print('[FRAMEWORK][CLIENT] Silenciador equipado!')
            Utils.SendNotification(nil, "Silenciador equipado na pistola!", "success")
        else
            print('[FRAMEWORK][CLIENT] Silenciador não disponível para pistola')
            Utils.SendNotification(nil, "Silenciador não disponível para pistola!", "error")
        end
    else
        print('[FRAMEWORK][CLIENT] Jogador não tem pistola')
        Utils.SendNotification(nil, "Você não tem uma pistola!", "error")
    end
end)

-- Thread para monitorar mudança de arma
CreateThread(function()
    local lastWeapon = nil
    
    while true do
        Wait(100)
        
        local currentWeapon = GetCurrentWeapon()
        if currentWeapon ~= lastWeapon then
            lastWeapon = currentWeapon
            
            if currentWeapon ~= GetHashKey("WEAPON_UNARMED") then
                local weaponName = Utils.GetWeaponName(currentWeapon)
                local ammo = GetCurrentWeaponAmmo()
                
                -- Mostrar informações da arma
                Utils.SendNotification(nil, "Arma: " .. weaponName .. " (" .. ammo .. ")", "info")
            end
        end
    end
end)

-- Thread para verificar munição baixa
CreateThread(function()
    while true do
        Wait(1000)
        
        local ammo = GetCurrentWeaponAmmo()
        if ammo > 0 and ammo <= 10 then
            Utils.SendNotification(nil, "Munição baixa! (" .. ammo .. ")", "warning")
        end
    end
end)

-- Comandos do cliente
RegisterCommand('reload', function(source, args, rawCommand)
    ReloadCurrentWeapon()
end, false)

RegisterCommand('ammo', function(source, args, rawCommand)
    local ammo = GetCurrentWeaponAmmo()
    Utils.SendNotification(nil, "Munição atual: " .. ammo, "info")
end, false)

RegisterCommand('myweapons', function(source, args, rawCommand)
    local weapons = GetPlayerWeapons()
    
    if #weapons > 0 then
        Utils.SendNotification(nil, "Suas armas:", "info")
        for _, weapon in ipairs(weapons) do
            Utils.SendNotification(nil, weapon.name .. " - " .. weapon.ammo .. " munições", "info")
        end
    else
        Utils.SendNotification(nil, "Você não tem armas!", "error")
    end
end, false)

RegisterCommand('weaponlist', function(source, args, rawCommand)
    Utils.SendNotification(nil, "Armas disponíveis:", "info")
    for _, weapon in ipairs(Config.DefaultWeapons) do
        local weaponName = Utils.GetWeaponName(GetHashKey(weapon))
        Utils.SendNotification(nil, weaponName, "info")
    end
end, false)

-- Função para obter estatísticas da arma
function GetWeaponStats(weapon)
    local weaponHash = GetHashKey(weapon)
    local player = PlayerPedId()
    
    if HasPedGotWeapon(player, weaponHash, false) then
        local ammo = GetAmmoInPedWeapon(player, weaponHash)
        local weaponName = Utils.GetWeaponName(weaponHash)
        
        return {
            name = weaponName,
            ammo = ammo,
            hash = weaponHash
        }
    end
    
    return nil
end

-- Função para verificar se jogador tem arma específica
function HasWeapon(weapon)
    local player = PlayerPedId()
    local weaponHash = GetHashKey(weapon)
    
    return HasPedGotWeapon(player, weaponHash, false)
end

-- Função para obter arma com mais munição
function GetWeaponWithMostAmmo()
    local weapons = GetPlayerWeapons()
    local bestWeapon = nil
    local maxAmmo = 0
    
    for _, weapon in ipairs(weapons) do
        if weapon.ammo > maxAmmo then
            maxAmmo = weapon.ammo
            bestWeapon = weapon
        end
    end
    
    return bestWeapon
end

-- Comando para testar atualização dos slots do HUD
RegisterCommand('updateslots', function(source, args, rawCommand)
    UpdateHUDWeaponSlots()
    Utils.SendNotification(nil, "Slots do HUD atualizados!", "success")
end, false)

-- Comando para testar desequipamento forçado
RegisterCommand('testunequip', function(source, args, rawCommand)
    print('[TEST] Testando desequipamento forçado')
    local player = PlayerPedId()
    local currentWeapon = GetSelectedPedWeapon(player)
    print('[TEST] Arma atual antes do desequipamento:', currentWeapon)
    
    ForceUnequipAllWeapons()
    
    local finalWeapon = GetSelectedPedWeapon(player)
    print('[TEST] Arma atual após desequipamento:', finalWeapon)
    
    if finalWeapon == GetHashKey("WEAPON_UNARMED") then
        Utils.SendNotification(nil, "Desequipamento forçado bem sucedido!", "success")
    else
        Utils.SendNotification(nil, "Falha no desequipamento forçado!", "error")
    end
end, false)

-- Função para atualizar slots do HUD
function UpdateHUDWeaponSlots()
    print('[FRAMEWORK][CLIENT] UpdateHUDWeaponSlots chamado')
    
    -- Verificar se o resource hud-go está disponível
    if GetResourceState('hud-go') == 'started' then
        -- Usar a função de atualização em tempo real do hud-go
        local updateFunction = exports['hud-go'].UpdateWeaponSlotsRealTime
        if updateFunction then
            updateFunction()
            print('[FRAMEWORK][CLIENT] Slots atualizados usando função do hud-go')
            
            -- Forçar atualização adicional para armas customizadas
            Wait(200)
            updateFunction()
            print('[FRAMEWORK][CLIENT] Segunda atualização forçada para armas customizadas')
        else
            print('[FRAMEWORK][CLIENT] Função UpdateWeaponSlotsRealTime não encontrada no hud-go')
        end
    else
        print('[FRAMEWORK][CLIENT] Resource hud-go não está disponível')
    end
end

-- Comando para verificar configuração
RegisterCommand('checkconfig', function(source, args, rawCommand)
    print('[DEBUG] Verificando configuração:')
    print('[DEBUG] Config existe:', Config ~= nil)
    if Config then
        print('[DEBUG] Config.DefaultWeapons existe:', Config.DefaultWeapons ~= nil)
        if Config.DefaultWeapons then
            print('[DEBUG] Config.DefaultWeapons count:', #Config.DefaultWeapons)
            for i, weapon in ipairs(Config.DefaultWeapons) do
                print('[DEBUG] Weapon', i, ':', weapon)
            end
        end
        print('[DEBUG] Config.WeaponAmmo existe:', Config.WeaponAmmo ~= nil)
        if Config.WeaponAmmo then
            print('[DEBUG] Config.WeaponAmmo entries:')
            for weapon, ammo in pairs(Config.WeaponAmmo) do
                print('[DEBUG] Weapon:', weapon, 'Ammo:', ammo)
            end
        end
    end
    print('[DEBUG] Utils existe:', Utils ~= nil)
    if Utils then
        print('[DEBUG] Utils.GetWeaponName existe:', Utils.GetWeaponName ~= nil)
    end
end, false) 

RegisterCommand('attachs', function(source, args, rawCommand)
    local player = PlayerPedId()
    local weaponHash = GetSelectedPedWeapon(player)
    if weaponHash == GetHashKey("WEAPON_UNARMED") then
        Utils.SendNotification(nil, "Equipe uma arma primeiro!", "error")
        return
    end
    -- Lista de componentes comuns para armas populares (pode ser expandida)
    local allComponents = {
        -- Pistolas
        [GetHashKey("WEAPON_PISTOL")] = {
            "COMPONENT_PISTOL_CLIP_02", "COMPONENT_AT_PI_FLSH", "COMPONENT_AT_PI_SUPP_02"
        },
        [GetHashKey("WEAPON_COMBATPISTOL")] = {
            "COMPONENT_COMBATPISTOL_CLIP_02", "COMPONENT_AT_PI_FLSH", "COMPONENT_AT_PI_SUPP"
        },
        [GetHashKey("WEAPON_APPISTOL")] = {
            "COMPONENT_APPISTOL_CLIP_02", "COMPONENT_AT_PI_FLSH", "COMPONENT_AT_PI_SUPP"
        },
        [GetHashKey("WEAPON_PISTOL50")] = {
            "COMPONENT_PISTOL50_CLIP_02", "COMPONENT_AT_PI_FLSH", "COMPONENT_AT_AR_SUPP_02"
        },
        [GetHashKey("WEAPON_HEAVYPISTOL")] = {
            "COMPONENT_HEAVYPISTOL_CLIP_02", "COMPONENT_AT_PI_FLSH", "COMPONENT_AT_PI_SUPP"
        },
        [GetHashKey("WEAPON_SNSPISTOL")] = {
            "COMPONENT_SNSPISTOL_CLIP_02", "COMPONENT_AT_PI_SUPP"
        },
        [GetHashKey("WEAPON_SNSPISTOL_MK2")] = {
            "COMPONENT_SNSPISTOL_MK2_CLIP_02", "COMPONENT_AT_PI_FLSH_03", "COMPONENT_AT_PI_SUPP_02"
        },
        [GetHashKey("WEAPON_PISTOL_MK2")] = {
            "COMPONENT_PISTOL_MK2_CLIP_02", "COMPONENT_AT_PI_FLSH_02", "COMPONENT_AT_PI_SUPP_02", "COMPONENT_AT_PI_COMP"
        },
        -- SMGs
        [GetHashKey("WEAPON_MICROSMG")] = {
            "COMPONENT_MICROSMG_CLIP_02", "COMPONENT_AT_PI_FLSH", "COMPONENT_AT_SCOPE_MACRO", "COMPONENT_AT_AR_SUPP_02"
        },
        [GetHashKey("WEAPON_SMG")] = {
            "COMPONENT_SMG_CLIP_02", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_SCOPE_MACRO_02", "COMPONENT_AT_PI_SUPP"
        },
        [GetHashKey("WEAPON_SMG_MK2")] = {
            "COMPONENT_SMG_MK2_CLIP_02", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_SCOPE_SMALL_SMG_MK2", "COMPONENT_AT_PI_SUPP", "COMPONENT_AT_MUZZLE_01"
        },
        [GetHashKey("WEAPON_ASSAULTSMG")] = {
            "COMPONENT_ASSAULTSMG_CLIP_02", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_SCOPE_MACRO", "COMPONENT_AT_AR_SUPP_02"
        },
        -- Rifles
        [GetHashKey("WEAPON_ASSAULTRIFLE")] = {
            "COMPONENT_ASSAULTRIFLE_CLIP_02", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_SCOPE_MACRO", "COMPONENT_AT_AR_SUPP_02", "COMPONENT_AT_AR_AFGRIP"
        },
        [GetHashKey("WEAPON_CARBINERIFLE")] = {
            "COMPONENT_CARBINERIFLE_CLIP_02", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_SCOPE_MEDIUM", "COMPONENT_AT_AR_SUPP", "COMPONENT_AT_AR_AFGRIP"
        },
        [GetHashKey("WEAPON_ADVANCEDRIFLE")] = {
            "COMPONENT_ADVANCEDRIFLE_CLIP_02", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_SCOPE_SMALL", "COMPONENT_AT_AR_SUPP"
        },
        [GetHashKey("WEAPON_SPECIALCARBINE")] = {
            "COMPONENT_SPECIALCARBINE_CLIP_02", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_SCOPE_MEDIUM", "COMPONENT_AT_AR_SUPP_02", "COMPONENT_AT_AR_AFGRIP"
        },
        [GetHashKey("WEAPON_BULLPUPRIFLE")] = {
            "COMPONENT_BULLPUPRIFLE_CLIP_02", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_SCOPE_SMALL", "COMPONENT_AT_AR_SUPP", "COMPONENT_AT_AR_AFGRIP"
        },
        [GetHashKey("WEAPON_COMPACTRIFLE")] = {
            "COMPONENT_COMPACTRIFLE_CLIP_02"
        },
        -- Shotguns
        [GetHashKey("WEAPON_PUMPSHOTGUN")] = {
            "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_SR_SUPP"
        },
        [GetHashKey("WEAPON_SAWNOFFSHOTGUN")] = {
            "COMPONENT_AT_AR_SUPP_02"
        },
        [GetHashKey("WEAPON_BULLPUPSHOTGUN")] = {
            "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_AR_SUPP_02"
        },
        [GetHashKey("WEAPON_HEAVYSHOTGUN")] = {
            "COMPONENT_HEAVYSHOTGUN_CLIP_02", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_AR_SUPP_02"
        },
        -- Snipers
        [GetHashKey("WEAPON_SNIPERRIFLE")] = {
            "COMPONENT_AT_SCOPE_LARGE", "COMPONENT_AT_AR_SUPP_02"
        },
        [GetHashKey("WEAPON_HEAVYSNIPER")] = {
            "COMPONENT_AT_SCOPE_LARGE"
        },
        [GetHashKey("WEAPON_MARKSMANRIFLE")] = {
            "COMPONENT_MARKSMANRIFLE_CLIP_02", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_SCOPE_LARGE", "COMPONENT_AT_AR_SUPP"
        },
        -- LMGs
        [GetHashKey("WEAPON_MG")] = {
            "COMPONENT_MG_CLIP_02", "COMPONENT_AT_SCOPE_SMALL_02"
        },
        [GetHashKey("WEAPON_COMBATMG")] = {
            "COMPONENT_COMBATMG_CLIP_02", "COMPONENT_AT_SCOPE_MEDIUM"
        },
        -- Outras armas podem ser adicionadas seguindo o mesmo padrão
        [GetHashKey("WEAPON_SPECIALCARBINE_MK2")] = {
            "COMPONENT_SPECIALCARBINE_MK2_CLIP_02",
            "COMPONENT_AT_AR_FLSH",
            "COMPONENT_AT_SIGHTS",
            "COMPONENT_AT_SCOPE_MEDIUM_MK2",
            "COMPONENT_AT_AR_SUPP_02",
            "COMPONENT_AT_MUZZLE_01",
            "COMPONENT_AT_AR_AFGRIP_02"
        },
    }
    local components = allComponents[weaponHash]
    if not components then
        Utils.SendNotification(nil, "Esta arma não tem attachs automáticos cadastrados!", "error")
        return
    end
    local count = 0
    for _, comp in ipairs(components) do
        local compHash = GetHashKey(comp)
        if not HasPedGotWeaponComponent(player, weaponHash, compHash) then
            GiveWeaponComponentToPed(player, weaponHash, compHash)
            count = count + 1
        end
    end
    if count > 0 then
        Utils.SendNotification(nil, "Todos os attachs equipados!", "success")
    else
        Utils.SendNotification(nil, "Sua arma já está com todos os attachs!", "info")
    end
end, false) 

-- Comandos para testar efeitos de partículas de morte
RegisterCommand('testdeatheffect', function(source, args, rawCommand)
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)
    
    -- Simular efeito de morte na posição atual
    if _G.CreateDeathParticleEffect then
        _G.CreateDeathParticleEffect(player, player)
        Utils.SendNotification(nil, "Efeito de morte testado!", "success")
    else
        Utils.SendNotification(nil, "Função de efeito de morte não encontrada!", "error")
    end
end, false)

RegisterCommand('testheadshot', function(source, args, rawCommand)
    local player = PlayerPedId()
    
    -- Simular efeito de headshot
    if _G.CreateHeadshotEffect then
        _G.CreateHeadshotEffect(player, player)
        Utils.SendNotification(nil, "Efeito de headshot testado!", "success")
    else
        Utils.SendNotification(nil, "Função de headshot não encontrada!", "error")
    end
end, false)

RegisterCommand('cleareffects', function(source, args, rawCommand)
    -- Limpar todos os efeitos de partículas
    if _G.ClearAllDeathEffects then
        _G.ClearAllDeathEffects()
        Utils.SendNotification(nil, "Todos os efeitos foram limpos!", "success")
    else
        Utils.SendNotification(nil, "Função de limpeza não encontrada!", "error")
    end
end, false)

RegisterCommand('toggleeffects', function(source, args, rawCommand)
    -- Ativar/desativar efeitos de partículas
    if Config and Config.DeathEffects then
        Config.DeathEffects.enabled = not Config.DeathEffects.enabled
        local status = Config.DeathEffects.enabled and "ativados" or "desativados"
        Utils.SendNotification(nil, "Efeitos de partículas " .. status .. "!", "success")
        print("[DEATH EFFECTS] Efeitos " .. status)
    else
        Utils.SendNotification(nil, "Configuração de efeitos não encontrada!", "error")
    end
end, false)

RegisterCommand('effectstatus', function(source, args, rawCommand)
    -- Mostrar status dos efeitos de partículas
    if Config and Config.DeathEffects then
        local status = Config.DeathEffects.enabled and "ATIVADOS" or "DESATIVADOS"
        Utils.SendNotification(nil, "Efeitos de partículas: " .. status, "info")
        
        -- Mostrar configurações
        print("[DEATH EFFECTS] Status: " .. status)
        print("[DEATH EFFECTS] Durações:")
        for effect, duration in pairs(Config.DeathEffects.duration) do
            print("  " .. effect .. ": " .. duration .. "ms")
        end
        print("[DEATH EFFECTS] Escalas:")
        for effect, scale in pairs(Config.DeathEffects.scale) do
            print("  " .. effect .. ": " .. scale)
        end
    else
        Utils.SendNotification(nil, "Configuração de efeitos não encontrada!", "error")
    end
end, false) 

RegisterCommand('effectdebug', function(source, args, rawCommand)
    -- Mostrar informações detalhadas dos efeitos
    print("[DEBUG] === STATUS DOS EFEITOS ===")
    print("[DEBUG] Config.DeathEffects existe:", Config.DeathEffects ~= nil)
    if Config.DeathEffects then
        print("[DEBUG] Efeitos habilitados:", Config.DeathEffects.enabled)
        print("[DEBUG] Durações:", json.encode(Config.DeathEffects.duration))
    end
    
    print("[DEBUG] deathParticleEffects count:", #deathParticleEffects)
    for i, effect in pairs(deathParticleEffects) do
        print("[DEBUG] Efeito", i, ":", json.encode(effect))
    end
    
    -- Verificar se as funções globais existem
    print("[DEBUG] Funções globais:")
    print("  - CreateDeathParticleEffect:", _G.CreateDeathParticleEffect ~= nil)
    print("  - CreateKillMarkEffect:", _G.CreateKillMarkEffect ~= nil)
    print("  - CreateHeadshotEffect:", _G.CreateHeadshotEffect ~= nil)
    print("  - ClearAllDeathEffects:", _G.ClearAllDeathEffects ~= nil)
    
    Utils.SendNotification(nil, "Debug dos efeitos mostrado no console!", "info")
end, false)

RegisterCommand('testlight', function(source, args, rawCommand)
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)
    
    print("[TEST] Testando DrawLightWithRange em:", coords.x, coords.y, coords.z)
    
    -- Teste simples de luz
    CreateThread(function()
        local startTime = GetGameTimer()
        local duration = 5000 -- 5 segundos
        
        while GetGameTimer() - startTime < duration do
            local currentTime = GetGameTimer()
            local pulse = math.sin((currentTime - startTime) * 0.005) * 0.5 + 0.5
            
            -- Luz vermelha forte para teste
            DrawLightWithRange(
                coords.x, coords.y, coords.z + 2.0,
                255, 0, 0, -- Vermelho forte
                5.0 * pulse, -- Intensidade alta
                5.0 -- Raio grande
            )
            
            print("[TEST] Luz ativa - Intensidade:", 5.0 * pulse, "Pulse:", pulse)
            Wait(100)
        end
        
        print("[TEST] Teste de luz concluído")
    end)
    
    Utils.SendNotification(nil, "Teste de luz iniciado! Verifique o console.", "info")
end, false) 

-- Comando para testar armas customizadas
RegisterCommand('testcustomweapon', function(source, args, rawCommand)
    local weapon = args[1] or "WEAPON_GOATROSA"
    print('[FRAMEWORK][CLIENT] Testando arma customizada:', weapon)
    
    local player = PlayerPedId()
    local weaponHash = GetHashKey(weapon)
    
    -- Verificar se é uma arma customizada
    if WeaponSkins and WeaponSkins.IsCustomWeapon(weapon) then
        local ammo = WeaponSkins.GetCustomWeaponAmmo(weapon)
        print('[FRAMEWORK][CLIENT] Arma customizada detectada, ammo:', ammo)
        
        -- Dar a arma
        GiveWeaponToPed(player, weaponHash, ammo, false, true)
        Wait(200)
        
        -- Verificar se foi dada
        if HasPedGotWeapon(player, weaponHash, false) then
            print('[FRAMEWORK][CLIENT] Arma dada com sucesso')
            
            -- Equipar
            SetCurrentPedWeapon(player, weaponHash, true)
            Wait(100)
            
            -- Verificar se foi equipada
            local currentWeapon = GetSelectedPedWeapon(player)
            if currentWeapon == weaponHash then
                print('[FRAMEWORK][CLIENT] Arma equipada com sucesso')
                Utils.SendNotification(nil, 'Arma customizada testada: ' .. weapon, 'success')
            else
                print('[FRAMEWORK][CLIENT] Erro ao equipar arma')
                Utils.SendNotification(nil, 'Erro ao equipar arma customizada', 'error')
            end
        else
            print('[FRAMEWORK][CLIENT] Erro ao dar arma')
            Utils.SendNotification(nil, 'Erro ao dar arma customizada', 'error')
        end
        
        -- Atualizar slots
        Wait(300)
        UpdateHUDWeaponSlots()
    else
        print('[FRAMEWORK][CLIENT] Arma não é customizada:', weapon)
        Utils.SendNotification(nil, 'Arma não é customizada: ' .. weapon, 'error')
    end
end, false) 