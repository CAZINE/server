-- Arquivo de servidor para o script de carro
-- Adicione sua lógica de servidor aqui 

-- Lista expandida de veículos com níveis específicos
local vehicles = {
    -- CATEGORIA GRÁTIS (Nível 1-3)
    {
        name = "sanchez2",
        spawn = "sanchez2",
        vehicleType = "Free",
        image = "./assets/sanchez2.png",
        minLevel = 1
    }, 
    {
        name = "lancer",
        spawn = "kuruma",
        vehicleType = "Free",
        image = "./assets/lancer.png",
        minLevel = 1
    }
    
    -- CATEGORIA BLINDADOS (Nível 5-8)
    {
        name = "Kuruma Blindado",
        spawn = "kuruma",
        vehicleType = "Blindados",
        image = "./assets/kuruma.png",
        minLevel = 5
    },
    {
        name = "Insurgent",
        spawn = "insurgent",
        vehicleType = "Blindados",
        image = "./assets/insurgent.png",
        minLevel = 6
    },
    {
        name = "Insurgent Pick-Up",
        spawn = "insurgent2",
        vehicleType = "Blindados",
        image = "./assets/insurgent2.png",
        minLevel = 7
    },
    
    -- CATEGORIA BOOSTER (Nível 8-12)
    {
        name = "Itali GTO",
        spawn = "italigto",
        vehicleType = "Booster",
        image = "./assets/italigto.png",
        minLevel = 8
    },
    {
        name = "Vagner",
        spawn = "vagner",
        vehicleType = "Booster",
        image = "./assets/vagner.png",
        minLevel = 10
    },
    {
        name = "X80 Proto",
        spawn = "prototipo",
        vehicleType = "Booster",
        image = "./assets/prototipo.png",
        minLevel = 12
    },
}

-- Função para buscar nível do jogador baseado no XP
local function getPlayerLevel(src, cb)
    local identifier = GetPlayerIdentifier(src, 0)
    if not identifier then 
        print("[DEBUG][CAR] Identifier não encontrado para source:", src)
        cb(1) 
        return 
    end
    
    print("[DEBUG][CAR] Consultando XP para identifier:", identifier)
    
    exports.oxmysql:execute('SELECT xp FROM player_xp WHERE identifier = ?', { identifier }, function(result)
        local xp = 0
        if result and result[1] then
            xp = tonumber(result[1].xp) or 0
            print("[DEBUG][CAR] XP encontrado:", xp)
        else
            print("[DEBUG][CAR] Nenhum XP encontrado, usando 0")
        end
        
        -- Lógica igual ao hud-go e weapon
        local level = 1
        local fator = 1.25
        local base = 300
        while level < 100 do
            local nextMeta = math.floor(base * (level ^ fator))
            if xp < nextMeta then break end
            level = level + 1
        end
        if level >= 100 then level = 100 end
        
        print("[DEBUG][CAR] Nível calculado:", level, "para XP:", xp)
        cb(level)
    end)
end

-- Evento para enviar lista de veículos
RegisterNetEvent("car:getVehicleList")
AddEventHandler("car:getVehicleList", function()
    local src = source
    
    getPlayerLevel(src, function(playerLevel)
        -- Enviar TODOS os veículos, mas marcar quais estão bloqueados
        local allVehicles = {}
        
        for _, vehicle in ipairs(vehicles) do
            local vehicleData = {
                name = vehicle.name,
                spawn = vehicle.spawn,
                vehicleType = vehicle.vehicleType,
                image = vehicle.image,
                minLevel = vehicle.minLevel,
                unlocked = vehicle.minLevel <= playerLevel
            }
            table.insert(allVehicles, vehicleData)
        end
        
        TriggerClientEvent("car:sendVehicleList", src, {
            vehicles = allVehicles,
            playerLevel = playerLevel
        })
    end)
end)

-- Evento para spawnar o último veículo (exemplo simples)
RegisterNetEvent("car:spawnLastVehicle")
AddEventHandler("car:spawnLastVehicle", function()
    local src = source
    -- Aqui você pode implementar lógica para buscar o último veículo do jogador
    -- Exemplo: sempre spawna o Adder
    TriggerClientEvent("car:doSpawnVehicle", src, "adder")
end) 

RegisterNetEvent('car:spawnVehicle')
AddEventHandler('car:spawnVehicle', function(vehicleModel)
    local src = source
    
    -- Validar se o modelo está na lista de veículos permitidos
    local isValidModel = false
    for _, vehicle in ipairs(vehicles) do
        if vehicle.spawn == vehicleModel then
            isValidModel = true
            break
        end
    end
    
    if not isValidModel then
        TriggerClientEvent('Notify', src, 'Modelo de veículo inválido.', 'vermelho', 4000)
        return
    end
    
    -- Verificar nível do jogador antes de spawnar
    getPlayerLevel(src, function(playerLevel)
        local vehicleData = nil
        for _, vehicle in ipairs(vehicles) do
            if vehicle.spawn == vehicleModel then
                vehicleData = vehicle
                break
            end
        end
        
        if vehicleData and vehicleData.minLevel <= playerLevel then
            TriggerClientEvent('car:doSpawnVehicle', src, vehicleModel)
        else
            TriggerClientEvent('Notify', src, 'Você não tem nível suficiente para este veículo.', 'vermelho', 4000)
        end
    end)
end)

-- Comando para dar XP ao jogador (teste)
RegisterCommand("givexpcar", function(source, args)
    local amount = tonumber(args[1]) or 100
    local identifier = GetPlayerIdentifier(source, 0)
    
    if not identifier then
        print("[DEBUG][CAR] Identifier não encontrado para source:", source)
        return
    end
    
    print("[DEBUG][CAR] Dando", amount, "XP para player", source)
    
    exports.oxmysql:execute('SELECT xp FROM player_xp WHERE identifier = ?', { identifier }, function(result)
        local currentXP = 0
        if result and result[1] then
            currentXP = tonumber(result[1].xp) or 0
        end
        
        local newXP = currentXP + amount
        print("[DEBUG][CAR] XP atual:", currentXP, "| Novo XP:", newXP)
        
        exports.oxmysql:execute('UPDATE player_xp SET xp = ? WHERE identifier = ?', { newXP, identifier }, function(rowsChanged)
            if rowsChanged then
                print("[DEBUG][CAR] XP atualizado com sucesso!")
                TriggerClientEvent('pvp:notification', source, 'Você recebeu ' .. amount .. ' XP!', 'success')
            else
                print("[DEBUG][CAR] Erro ao atualizar XP")
            end
        end)
    end)
end)

-- Comando para resetar XP do jogador (teste de bloqueio)
RegisterCommand("resetxpcar", function(source, args)
    local identifier = GetPlayerIdentifier(source, 0)
    
    if not identifier then
        print("[DEBUG][CAR] Identifier não encontrado para source:", source)
        return
    end
    
    print("[DEBUG][CAR] Resetando XP para player", source)
    
    exports.oxmysql:execute('UPDATE player_xp SET xp = 0 WHERE identifier = ?', { identifier }, function(rowsChanged)
        if rowsChanged then
            print("[DEBUG][CAR] XP resetado com sucesso!")
            TriggerClientEvent('pvp:notification', source, 'XP resetado! Agora você está no nível 1.', 'info')
        else
            print("[DEBUG][CAR] Erro ao resetar XP")
        end
    end)
end)

-- Comando para atualizar nível em tempo real
RegisterCommand("updatelevelcar", function(source, args)
    local identifier = GetPlayerIdentifier(source, 0)
    
    if not identifier then
        print("[DEBUG][CAR] Identifier não encontrado para source:", source)
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
        
        print("[DEBUG][CAR] Enviando atualização de nível:", level, "para player", source)
        
        -- Enviar atualização para o cliente
        TriggerClientEvent('car:updateLevel', source, level)
    end)
end)

-- Comando para testar spawn de veículos específicos
RegisterCommand("testspawncar", function(source, args)
    local vehicleModel = args[1] or "adder"
    print("[DEBUG][CAR] Testando spawn do veículo:", vehicleModel, "para player", source)
    TriggerClientEvent('car:doSpawnVehicle', source, vehicleModel)
end)

-- Comando para testar múltiplos modelos
RegisterCommand("testallcars", function(source, args)
    local testModels = {"adder", "zentorno", "t20", "kuruma", "insurgent"}
    print("[DEBUG][CAR] Testando múltiplos modelos para player", source)
    
    for i, model in ipairs(testModels) do
        SetTimeout(i * 2000, function() -- 2 segundos entre cada teste
            print("[DEBUG][CAR] Testando modelo", i, ":", model)
            TriggerClientEvent('car:doSpawnVehicle', source, model)
        end)
    end
end) 