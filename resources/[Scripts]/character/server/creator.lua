local function getIdentifier(src)
    local ids = GetPlayerIdentifiers(src)
    for _, id in ipairs(ids) do
        if string.sub(id, 1, 5) == 'steam' then
            return id
        end
    end
    return ids[1]
end

RegisterNetEvent('character:check', function()
    local src = source
    local identifier = getIdentifier(src)
    exports.oxmysql:execute('SELECT * FROM characters WHERE identifier = ?', {identifier}, function(result)
        if result and result[1] then
            TriggerClientEvent('character:alreadyCreated', src, result[1].appearance)
        else
            TriggerClientEvent('character:needCreate', src)
        end
    end)
end)

RegisterNetEvent('character:save', function(data)
    local src = source
    local identifier = getIdentifier(src)
    local appearance = json.encode(data)
    exports.oxmysql:execute('REPLACE INTO characters (identifier, appearance) VALUES (?, ?)', {identifier, appearance})
end)

RegisterNetEvent('character:setBucketSolo', function()
    local src = source
    SetPlayerRoutingBucket(src, src) -- Cada player em seu próprio bucket
end)

RegisterNetEvent('character:setBucketMain', function()
    local src = source
    SetPlayerRoutingBucket(src, 0) -- Volta para o mundo principal
end) 