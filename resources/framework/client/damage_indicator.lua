local damageIndicators = {}
local lastHealth = {}

-- Função para desenhar texto 3D
function DrawDamageText3D(x, y, z, text, color)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(color.r, color.g, color.b, color.a)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

-- Adiciona indicador de dano com cor conforme a quantidade
function AddDamageIndicator(ped, damage)
    local bone = 31086 -- Head bone
    local boneCoords = GetPedBoneCoords(ped, bone, 0.25, 0.0, 0.0)
    local color

    if damage >= 50 then
        color = {r = 255, g = 0, b = 0, a = 255} -- Vermelho
    elseif damage >= 20 then
        color = {r = 255, g = 255, b = 0, a = 255} -- Amarelo
    else
        color = {r = 255, g = 255, b = 255, a = 255} -- Branco
    end

    table.insert(damageIndicators, {
        x = boneCoords.x,
        y = boneCoords.y,
        z = boneCoords.z + 0.25,
        damage = damage,
        time = GetGameTimer(),
        duration = 900, -- ms
        color = color
    })
end

-- Loop para desenhar os indicadores
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local now = GetGameTimer()
        for i = #damageIndicators, 1, -1 do
            local ind = damageIndicators[i]
            local elapsed = now - ind.time
            if elapsed < ind.duration then
                -- Sobe o texto com o tempo
                DrawDamageText3D(ind.x, ind.y, ind.z + (elapsed / ind.duration) * 0.3, tostring(ind.damage), ind.color)
            else
                table.remove(damageIndicators, i)
            end
        end
    end
end)

-- Detecta dano em outros players e calcula a diferença de vida
AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        local victim = args[1]
        local attacker = args[2]
        if attacker == PlayerPedId() and IsPedAPlayer(victim) then
            local pedHealth = GetEntityHealth(victim)
            local prevHealth = lastHealth[victim] or pedHealth
            local damage = prevHealth - pedHealth
            if damage > 0 then
                AddDamageIndicator(victim, damage)
            end
            lastHealth[victim] = pedHealth
        end
    end
end)

-- Atualiza a vida dos peds periodicamente
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        for _, player in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(player)
            lastHealth[ped] = GetEntityHealth(ped)
        end
    end
end) 