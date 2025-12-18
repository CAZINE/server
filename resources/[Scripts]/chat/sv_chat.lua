-- Usando PvP Framework em vez de vRP; sem Tunnel/Proxy
RegisterServerEvent("_chat:messageEntered")
AddEventHandler("_chat:messageEntered", function(name, color, message)
    local _source = source
    local user_id = _source
    -- Escolher template de acordo com o grupo
    local group = exports.framework:GetPlayerGroup(_source)
    local templateId = group == "admin" and "kush_admin" or "kush"
    -- Enviar mensagem customizada para NUI
    TriggerClientEvent("chat:addMessage", -1, {
        color = color,
        multiline = true,
        templateId = templateId,
        args = {"", user_id, name, message}
    })
end) 