-- Adaptado para PvP Framework

-- Permissão: use exports['framework']:HasPermission(source, "skinshop.use")
-- Persistência: use GetPlayerData/SetPlayerData para salvar skin

src = {}

-- Função de permissão
function src.checkPermission()
    local source = source
    -- Exemplo: só permite se o jogador tiver permissão "skinshop.use"
    return exports['framework']:HasPermission(source, "skinshop.use")
end

-- Função para salvar skin
function src.updateClothes(custom)
    local source = source
    local playerData = GetPlayerData(source) or {}
    playerData.skin = custom -- Salva skin no campo 'skin'
    SetPlayerData(source, playerData)
    -- Opcional: salvar no banco imediatamente
    exports['framework']:SavePlayerData(source, playerData)
    print("[Skinshop] updateClothes salvo para jogador:", source)
end

RegisterCommand("skinshop", function(source, args, rawCommand)
    print("Comando /skinshop executado pelo jogador: " .. source)
    -- Abrir a NUI do skinshop para o jogador
    TriggerClientEvent("skinshop:open", source)
end) 

local oxmysql = exports.oxmysql

-- Salvar roupas do jogador
RegisterNetEvent("skinshop:saveClothes")
AddEventHandler("skinshop:saveClothes", function(clothes)
    local src = source
    local identifier
    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            identifier = v
            break
        end
    end
    if identifier then
        oxmysql:execute(
            "REPLACE INTO player_clothes (identifier, clothes) VALUES (?, ?)",
            {identifier, json.encode(clothes)}
        )
    end
end)

-- Carregar roupas do jogador
function loadPlayerClothes(src, cb)
    local identifier
    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            identifier = v
            break
        end
    end
    if identifier then
        oxmysql:fetch(
            "SELECT clothes FROM player_clothes WHERE identifier = ?",
            {identifier},
            function(result)
                if result and result[1] then
                    cb(json.decode(result[1].clothes))
                else
                    cb(nil)
                end
            end
        )
    else
        cb(nil)
    end
end

-- Função para buscar identifier license:
local function getIdentifier(src)
    local ids = GetPlayerIdentifiers(src)
    for _, id in ipairs(ids) do
        if string.sub(id, 1, 8) == 'license:' then
            return id
        end
    end
    return ids[1]
end

-- Salvar skin do jogador
RegisterNetEvent("skinshop:saveSkin")
AddEventHandler("skinshop:saveSkin", function(appearance)
    local src = source
    local identifier = getIdentifier(src)
    print("[Skinshop][SERVER] Salvando skin para identifier:", identifier)
    exports.oxmysql:execute('REPLACE INTO characters (identifier, appearance) VALUES (?, ?)', {identifier, appearance})
end)

-- Carregar skin do jogador
function loadPlayerSkin(src, cb)
    local identifier
    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            identifier = v
            break
        end
    end
    if identifier then
        exports.oxmysql:fetch(
            "SELECT appearance FROM characters WHERE identifier = ?",
            {identifier},
            function(result)
                if result and result[1] then
                    cb(result[1].appearance)
                else
                    cb(nil)
                end
            end
        )
    else
        cb(nil)
    end
end

-- Remover aplicação automática de roupas e skin ao spawnar
--[=[
AddEventHandler("playerSpawned", function()
    local src = source
    loadPlayerClothes(src, function(clothes)
        if clothes then
            TriggerClientEvent("skinshop:applyClothes", src, clothes)
        end
    end)
end) 

AddEventHandler("playerSpawned", function()
    local src = source
    local identifier = getIdentifier(src)
    exports.oxmysql:fetch('SELECT appearance FROM characters WHERE identifier = ?', {identifier}, function(result)
        if result and result[1] and result[1].appearance then
            TriggerClientEvent("skinshop:applySkin", src, result[1].appearance)
        end
    end)
end) 
]=]--

RegisterNetEvent("skinshop:requestSkin")
AddEventHandler("skinshop:requestSkin", function()
    local src = source
    local identifier = getIdentifier(src)
    exports.oxmysql:fetch('SELECT appearance FROM characters WHERE identifier = ?', {identifier}, function(result)
        if result and result[1] and result[1].appearance then
            TriggerClientEvent("skinshop:applySkin", src, result[1].appearance)
        end
    end)
end) 

RegisterNetEvent("skinshop:requestClothes")
AddEventHandler("skinshop:requestClothes", function()
    local src = source
    print("[Skinshop][SERVER] Jogador", src, "solicitou roupas")
    loadPlayerClothes(src, function(clothes)
        if clothes then
            print("[Skinshop][SERVER] Enviando roupas para jogador", src)
            TriggerClientEvent("skinshop:applyClothes", src, clothes)
        else
            print("[Skinshop][SERVER] Nenhuma roupa encontrada para jogador", src)
        end
    end)
end) 