-----------------------------------------------------------------------------------------------------------------------------------------
-- FRAMEWORK
-----------------------------------------------------------------------------------------------------------------------------------------
local oxmysql = exports.oxmysql
-----------------------------------------------------------------------------------------------------------------------------------------
-- IDENTIDADE - F11
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("identity:requestIdentity")
AddEventHandler("identity:requestIdentity", function()
    print("[DEBUG] Evento identity:requestIdentity chamado por", source)
    local source = source
    local identifier = nil
    for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            identifier = v
            break
        end
    end
    print("[DEBUG] Identifier:", identifier)
    if not identifier then return end

    -- Buscar dados básicos do jogador
    oxmysql:fetch('SELECT id, player_name, kills, deaths FROM player_data WHERE identifier = ?', {identifier}, function(result)
        print("[DEBUG] player_data result:", json.encode(result))
        local data = {
            name = "",
            name2 = "",
            id = source,
            vip = "Não",
            staff = "Não",
            streamer = "Não",
            booster = "Não",
            kills = 0,
            deaths = 0,
            kdr = 0,
            gang = nil,
            dominations = 0
        }
        if result and result[1] then
            local row = result[1]
            data.name = row.player_name or "?"
            data.kills = row.kills or 0
            data.deaths = row.deaths or 0
            data.kdr = (data.deaths > 0) and (data.kills / data.deaths) or data.kills
        end
        -- Buscar gangue e dominações
        oxmysql:scalar('SELECT id FROM gangue_players WHERE identifier = ?', {identifier}, function(playerId)
            print("[DEBUG] gangue_players id:", playerId)
            if playerId then
                oxmysql:scalar('SELECT t.name FROM gangue_team_members m JOIN gangue_teams t ON m.team_id = t.id WHERE m.player_id = ?', {playerId}, function(teamName)
                    print("[DEBUG] teamName:", teamName)
                    data.gang = teamName
                    -- Buscar dominações
                    oxmysql:scalar('SELECT COUNT(*) FROM gangue_domination_history WHERE team_id = (SELECT team_id FROM gangue_team_members WHERE player_id = ? LIMIT 1)', {playerId}, function(domCount)
                        print("[DEBUG] domCount:", domCount)
                        data.dominations = domCount or 0
                        -- Buscar permissões (VIP, staff, streamer, booster)
                        local perms = exports['framework']:GetPlayerGroups(source)
                        print("[DEBUG] Perms:", json.encode(perms))
                        for _, group in ipairs(perms or {}) do
                            if group == "vip_quebrada" or group == "vip_playboy" or group == "vip_milionario" then
                                local groupNames = {
                                    vip_quebrada = "Vip Quebrada",
                                    vip_playboy = "Vip PlayBoy",
                                    vip_milionario = "Vip Milionário"
                                }
                                data.vip = groupNames[group] or "Sim"
                                break
                            end
                            local staffNames = {
                                admin = "Administrador",
                                moderador = "Moderador",
                                suporte = "Suporte",
                                maneger = "Maneger",
                                owner = "Owner",
                                ceo = "CEO"
                            }
                            if staffNames[group] then
                                data.staff = staffNames[group]
                            end
                            if group == "streamer" then data.streamer = "Sim" end
                            if group == "booster" then data.booster = "Sim" end
                        end
                        print("[DEBUG] Enviando dados para client:", json.encode(data))
                        TriggerClientEvent("identity:receiveIdentity", source, data)
                    end)
                end)
            else
                print("[DEBUG] Jogador não tem gangue, enviando dados para client:", json.encode(data))
                TriggerClientEvent("identity:receiveIdentity", source, data)
            end
        end)
    end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOP DOMINAÇÕES - K
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("exit:pedirTopDominas")
AddEventHandler("exit:pedirTopDominas", function()
    print("[DEBUG] Evento exit:pedirTopDominas chamado por", source)
    local source = source
    -- Buscar top 10 gangues por dominações
    oxmysql:execute([[SELECT t.name as gang, COUNT(h.id) as count FROM gangue_domination_history h JOIN gangue_teams t ON h.team_id = t.id GROUP BY h.team_id ORDER BY count DESC LIMIT 10]], {}, function(result)
        print("[DEBUG] Top Dominações:", json.encode(result))
        local top = {}
        for _, row in ipairs(result or {}) do
            table.insert(top, { gang = row.gang, count = row.count })
        end
        TriggerClientEvent("exit:mostrarTopDominas", source, top)
    end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INFORMAÇÕES DE PLAYER PARA TALKING SCREEN
-----------------------------------------------------------------------------------------------------------------------------------------
function getPlayerInfos(playerSrc)
    local identifier = nil
    for k, v in ipairs(GetPlayerIdentifiers(playerSrc)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            identifier = v
            break
        end
    end
    if not identifier then return playerSrc, "Player"..tostring(playerSrc) end
    local name = GetPlayerName(playerSrc) or ("Player"..tostring(playerSrc))
    return playerSrc, name
end 