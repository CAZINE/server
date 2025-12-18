-- radio/server.lua
-- Script de controle de rádio integrado ao PvP Framework (sem vRP)

-- Frequências restritas (adicione aqui as frequências que quiser bloquear)
local restrictedFrequencies = {
    [911] = true, -- Exemplo: frequência da polícia
    [112] = true  -- Exemplo: frequência médica
}

-- Permite ou não o acesso à frequência
function startFrequency(frequency, source)
    frequency = tonumber(frequency)
    if not frequency or frequency <= 0 or frequency > 1000 then
        return false
    end

    -- Exemplo de permissão: só policiais podem acessar 911
    if restrictedFrequencies[frequency] then
        -- Se você tiver um sistema de permissão, adapte aqui. Caso contrário, bloqueia para todos menos admin (exemplo):
        -- return exports['framework']:HasPermission(source, "policia.permissao")
        -- Por padrão, bloqueia para todos:
        return false
    end
    return true
end

-- Expor para o client usando evento
RegisterNetEvent("radio:startFrequency", function(frequency, cbId)
    local allowed = startFrequency(frequency, source)
    TriggerClientEvent("radio:frequencyResult", source, allowed, cbId)
end)

-- Limpar/desconectar frequência ao sair
AddEventHandler("playerDropped", function(reason)
    local source = source
    -- Remove o player do canal de rádio (pma-voice)
    exports["pma-voice"].setPlayerRadio(source, 0)
end) 