-- PvP Framework - HUD Client

local HUDData = {
    kills = 0,
    deaths = 0,
    kdRatio = 0,
    money = 0,
    health = 100,
    armor = 0,
    currentZone = "Nenhuma",
    playersOnline = 0
}

-- Função para atualizar dados do HUD
function UpdateHUDData()
    local player = PlayerPedId()
    
    -- Dados básicos do jogador
    HUDData.health = GetEntityHealth(player)
    HUDData.armor = GetPedArmour(player)
    
    -- Dados do servidor (se disponível)
    if PlayerData then
        HUDData.kills = PlayerData.kills or 0
        HUDData.deaths = PlayerData.deaths or 0
        HUDData.kdRatio = PlayerData.kdRatio or 0
        HUDData.money = PlayerData.money or 0
    end
    
    -- Zona atual
    local playerPos = GetEntityCoords(player)
    local currentZone = Utils.GetPlayerZone(playerPos)
    HUDData.currentZone = currentZone and currentZone.name or "Nenhuma"
    
    -- Jogadores online
    HUDData.playersOnline = #GetActivePlayers()
end

-- Função para desenhar HUD
function DrawHUD()
    if not Config.HUD.enabled or not isHUDVisible then return end
    
    UpdateHUDData()
    
    -- Configurações de tela
    local screenW, screenH = GetActiveScreenResolution()
    local scale = screenW / 1920.0
    
    -- Cores
    local colors = {
        white = {255, 255, 255, 255},
        red = {255, 0, 0, 255},
        green = {0, 255, 0, 255},
        blue = {0, 0, 255, 255},
        yellow = {255, 255, 0, 255},
        orange = {255, 165, 0, 255}
    }
    
    -- Posições
    local x = 20 * scale
    local y = 20 * scale
    local lineHeight = 25 * scale
    
    -- Fundo do HUD
    DrawRect(x + 100, y + 80, 200 * scale, 160 * scale, 0, 0, 0, 150)
    
    -- Título
    SetTextFont(4)
    SetTextProportional(true)
    SetTextScale(0.8 * scale, 0.8 * scale)
    SetTextColour(colors.white[1], colors.white[2], colors.white[3], colors.white[4])
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString("PvP HUD")
    DrawText(x, y)
    
    y = y + lineHeight
    
    -- Kills
    if Config.HUD.showKills then
        SetTextScale(0.6 * scale, 0.6 * scale)
        SetTextColour(colors.blue[1], colors.blue[2], colors.blue[3], colors.blue[4])
        SetTextEntry("STRING")
        AddTextComponentString("Kills: " .. HUDData.kills)
        DrawText(x, y)
        y = y + lineHeight
    end
    
    -- Deaths
    if Config.HUD.showDeaths then
        SetTextScale(0.6 * scale, 0.6 * scale)
        SetTextColour(colors.red[1], colors.red[2], colors.red[3], colors.red[4])
        SetTextEntry("STRING")
        AddTextComponentString("Deaths: " .. HUDData.deaths)
        DrawText(x, y)
        y = y + lineHeight
    end
    
    -- K/D Ratio
    if Config.HUD.showKDRatio then
        SetTextScale(0.6 * scale, 0.6 * scale)
        SetTextColour(colors.yellow[1], colors.yellow[2], colors.yellow[3], colors.yellow[4])
        SetTextEntry("STRING")
        AddTextComponentString("K/D: " .. string.format("%.2f", HUDData.kdRatio))
        DrawText(x, y)
        y = y + lineHeight
    end
    
    -- Money
    SetTextScale(0.6 * scale, 0.6 * scale)
    SetTextColour(colors.orange[1], colors.orange[2], colors.orange[3], colors.orange[4])
    SetTextEntry("STRING")
    AddTextComponentString("Money: $" .. HUDData.money)
    DrawText(x, y)
    y = y + lineHeight
    
    -- Health Bar
    local healthPercent = HUDData.health / 200.0
    local healthColor = healthPercent > 0.5 and colors.blue or (healthPercent > 0.25 and colors.yellow or colors.red)
    
    DrawRect(x + 100, y + 10, 200 * scale, 15 * scale, 0, 0, 0, 200)
    DrawRect(x + 100, y + 10, 200 * healthPercent * scale, 15 * scale, healthColor[1], healthColor[2], healthColor[3], 200)
    
    SetTextScale(0.5 * scale, 0.5 * scale)
    SetTextColour(colors.white[1], colors.white[2], colors.white[3], colors.white[4])
    SetTextEntry("STRING")
    AddTextComponentString("Health: " .. HUDData.health)
    DrawText(x, y)
    y = y + lineHeight
    
    -- Armor Bar
    if HUDData.armor > 0 then
        local armorPercent = HUDData.armor / 100.0
        
        DrawRect(x + 100, y + 10, 200 * scale, 15 * scale, 0, 0, 0, 200)
        DrawRect(x + 100, y + 10, 200 * armorPercent * scale, 15 * scale, colors.blue[1], colors.blue[2], colors.blue[3], 200)
        
        SetTextScale(0.5 * scale, 0.5 * scale)
        SetTextColour(colors.white[1], colors.white[2], colors.white[3], colors.white[4])
        SetTextEntry("STRING")
        AddTextComponentString("Armor: " .. HUDData.armor)
        DrawText(x, y)
        y = y + lineHeight
    end
    
    -- Zona atual
    if Config.HUD.showZone then
        SetTextScale(0.6 * scale, 0.6 * scale)
        SetTextColour(colors.blue[1], colors.blue[2], colors.blue[3], colors.blue[4])
        SetTextEntry("STRING")
        AddTextComponentString("Zone: " .. HUDData.currentZone)
        DrawText(x, y)
        y = y + lineHeight
    end
    
    -- Jogadores online
    if Config.HUD.showPlayers then
        SetTextScale(0.6 * scale, 0.6 * scale)
        SetTextColour(colors.white[1], colors.white[2], colors.white[3], colors.white[4])
        SetTextEntry("STRING")
        AddTextComponentString("Players: " .. HUDData.playersOnline .. "/" .. Config.MaxPlayers)
        DrawText(x, y)
    end
end

-- Função para desenhar scoreboard
function DrawScoreboard()
    if not isScoreboardVisible then return end
    
    local screenW, screenH = GetActiveScreenResolution()
    local scale = screenW / 1920.0
    
    -- Fundo do scoreboard
    DrawRect(screenW / 2, screenH / 2, 600 * scale, 400 * scale, 0, 0, 0, 200)
    
    -- Título
    local x = (screenW / 2) - (300 * scale)
    local y = (screenH / 2) - (200 * scale)
    local lineHeight = 30 * scale
    
    SetTextFont(4)
    SetTextProportional(true)
    SetTextScale(1.0 * scale, 1.0 * scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString("SCOREBOARD")
    DrawText(x + 250 * scale, y)
    
    y = y + lineHeight * 2
    
    -- Cabeçalho
    SetTextScale(0.7 * scale, 0.7 * scale)
    SetTextColour(255, 255, 0, 255)
    SetTextEntry("STRING")
    AddTextComponentString("Rank | Name | Kills | Mortes | K/D | Money")
    DrawText(x + 20 * scale, y)
    
    y = y + lineHeight
    
    -- Lista de jogadores
    SetTextScale(0.6 * scale, 0.6 * scale)
    SetTextColour(255, 255, 255, 255)
    
    for i, player in ipairs(ScoreboardData) do
        if i <= 10 then -- Limitar a 10 jogadores
            local rank = i
            local name = player.name or "Unknown"
            local kills = player.kills or 0
            local deaths = player.deaths or 0
            local kd = player.kdRatio or 0
            local money = player.money or 0
            
            SetTextEntry("STRING")
            AddTextComponentString(string.format("%d | %s | %d | %d | %.2f | $%d", 
                rank, name, kills, deaths, kd, money))
            DrawText(x + 20 * scale, y)
            
            y = y + lineHeight
        end
    end
end

-- Thread principal do HUD
--[[
CreateThread(function()
    while true do
        Wait(0)
        DrawHUD()
        DrawScoreboard()
    end
end)
]]

-- Evento para notificações
RegisterNetEvent('pvp:showNotification')
AddEventHandler('pvp:showNotification', function(message, type)
    TriggerEvent('notify:show', {type = type, message = message})
end)

-- Exportar funções
exports('UpdateHUDData', UpdateHUDData)
exports('UpdateHUDData', UpdateHUDData) 