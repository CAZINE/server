-- Removido script customizado de agachamento para restaurar comportamento padrão do GTA V
-- O agachamento padrão funciona automaticamente com Ctrl esquerdo (INPUT_DUCK)
-- Este arquivo pode ser removido ou deixado vazio 

local crouched = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        DisableControlAction(0, 36, true) -- Bloqueia padrão
        if IsControlJustPressed(0, 36) then
            crouched = not crouched
            Citizen.Wait(10)
            Citizen.InvokeNative(0x0C8DB0F9D745836D, playerPed, crouched, crouched, crouched)
        end
    end
end) 