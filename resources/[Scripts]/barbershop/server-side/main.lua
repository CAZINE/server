-- Adaptado para PvP Framework (sem Tunnel/Proxy)

local oxmysql = exports.oxmysql

src = {}

RegisterNetEvent('barbershop:checkPermission', function()
    local source = source
    TriggerClientEvent('barbershop:checkPermissionResult', source, true)
end)

RegisterNetEvent('barbershop:updateSkin', function(custom)
    local source = source
    local playerData = exports['framework']:GetPlayerData(source) or {}
    playerData.barberskin = custom -- Salva skin do barbershop em campo separado
    exports['framework']:SavePlayerData(source, playerData)
end)

-- Salvar dados do barbershop
RegisterNetEvent("barbershop:saveData")
AddEventHandler("barbershop:saveData", function(data)
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
            "REPLACE INTO player_barbershop (identifier, barbershop_data) VALUES (?, ?)",
            {identifier, json.encode(data)}
        )
    end
end)

-- Carregar dados do barbershop
function loadBarbershopData(src, cb)
    local identifier
    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            identifier = v
            break
        end
    end
    if identifier then
        oxmysql:fetch(
            "SELECT barbershop_data FROM player_barbershop WHERE identifier = ?",
            {identifier},
            function(result)
                if result and result[1] then
                    cb(json.decode(result[1].barbershop_data))
                else
                    cb(nil)
                end
            end
        )
    else
        cb(nil)
    end
end

-- Evento para enviar dados ao client ao spawnar/conectar
RegisterNetEvent("barbershop:requestData")
AddEventHandler("barbershop:requestData", function()
    local src = source
    loadBarbershopData(src, function(data)
        if data then
            TriggerClientEvent("barbershop:applyData", src, data)
        end
    end)
end) 