local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookadmin = ""
local webhookblacklist = "https://discord.com/api/webhooks/855974052216569856/_2_sq0UxQ5OLVRq4GZSB7EGGyX0FPNRDvvR-UsuLwEilLZcTwwb1sEy7SRGo9Rqpf86J"
local webhookprontuario = "https://discord.com/api/webhooks/855974190620213268/SM4Mu15vLcv9_6UB3McMyMXChuGzmF0tu2HCtAE3w4jBHft4z8q4SBJQt2IDbU9pcVIB"
local logAdmStatus = "https://discord.com/api/webhooks/1069802611596869727/jFVfaRlY5UJZLLEYm0Au9kMPhknMA0TFJfYu-yEUl5IAUPrzeeiV-9cjv0iejMWDwqNC"
local webhookcds = "https://discord.com/api/webhooks/1069802611596869727/jFVfaRlY5UJZLLEYm0Au9kMPhknMA0TFJfYu-yEUl5IAUPrzeeiV-9cjv0iejMWDwqNC"
local webhooktpway = "https://discord.com/api/webhooks/1069802611596869727/jFVfaRlY5UJZLLEYm0Au9kMPhknMA0TFJfYu-yEUl5IAUPrzeeiV-9cjv0iejMWDwqNC"

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

RegisterServerEvent("adminLogs:Armamentos")
AddEventHandler("adminLogs:Armamentos",function(weapon)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
    	SendWebhookMessage(webhookblacklist,"```prolog\n[BLACKLIST ARMAS]: "..user_id.." " .. "\n[ARMA]: " .. weapon ..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```<@&641048265856647169>")  
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- VROUPAS
-----------------------------------------------------------------------------------------------------------------------------------------
local player_customs = {}
RegisterCommand('vroupas',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local custom = vRPclient.getCustomization(source)
    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
        if player_customs[source] then
            player_customs[source] = nil
            vRPclient._removeDiv(source,"customization")
        else 
            local content = ""
            for k,v in pairs(custom) do
                content = content..k.." => "..json.encode(v).."<br/>" 
            end

            player_customs[source] = true
            vRPclient._setDiv(source,"customization",".div_customization{ margin: auto; padding: 4px; width: 250px; margin-top: 200px; margin-right: 50px; background: rgba(15,15,15,0.7); color: #ffff; font-weight: bold; }",content)
        end
    end
end)
-----
function IsNumber( numero )
    return tonumber(numero) ~= nil
end

RegisterCommand('vroupas2', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local custom = vRPclient.getCustomization(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
          if player_customs[source] then
            player_customs[source] = nil
            vRPclient._removeDiv(source,"customization")
        else 
            local content = ""
            for k, v in pairs(custom) do
                if (IsNumber(k) and k <= 11) or k == "p0" or k == "p1" or k == "p2" or k == "p6" or k == "p7" then
                    if IsNumber(k) then
                        content = content .. '[' .. k .. '] = {' 
                    else
                        content = content .. '["' ..k..'"] = {'
                    end
                    local contador = 1
                    for y, x in pairs(v) do
                        if contador < #v then
                            content  = content .. x .. ',' 
                        else
                            content = content .. x 
                        end
                        contador = contador + 1
                    end
                    content = content .. "},\n"
                end
            end
            player_customs[source] = true
            vRPclient.prompt(source, 'vRoupas: ', content)
        end
    end
end)
--------------------------------------------------------
----------- DV ----------------------------------------
RegisterCommand("dv", function(source, args, rawCommand)
    local user_id = vRP.getUserId({source})
    if user_id then
        -- Verifica se o usuário tem a permissão "admin.permissao"
        if vRP.hasPermission({user_id, "admin.permissao"}) then
            TriggerClientEvent('vRP:deleteVehicle', source)
        else
            vRPclient.notify(source, {"~r~Você não tem permissão para usar este comando!"}) -- Notificação de permissão negada
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('car',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"vendedor.permissao") then
		if args[1] then
			TriggerClientEvent('spawnarveiculo',source,args[1])
			SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SPAWNOU]: "..(args[1]).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Blips
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {}
AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
    if first_spawn then
        blips[source] = { source }
       TriggerClientEvent("blips:updateBlips",-1,blips)
        if vRP.hasPermission(user_id,"blips.permissao") then
            TriggerClientEvent("blips:adminStart",source)
        end
     end
 end)

AddEventHandler("playerDropped",function()
	if blips[source] then
		blips[source] = nil
		TriggerClientEvent("blips:updateBlips",-1,blips)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SET NAME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('setname',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"fundador.permissao") then
        if user_id then
            if args[1] and args[2] and args[3] and args[4] then
                local identity = vRP.getUserIdentity(parseInt(args[1]))
                if vRP.request(source,"Deseja mudar o <b>Nome/Sobrenome/Idade</b> do Passaporte: <b>"..vRP.format(parseInt(args[1])).." "..identity.name.." "..identity.firstname.."</b> para <b>"..args[2].." "..args[3].." "..args[4].."</b> ?",30) then
                    vRP.execute("vRP/upd_user_identity",{ user_id = parseInt(args[1]), name = args[2], firstname = args[3], age = args[4] })
                    TriggerClientEvent("Notify",source,"sucesso","Você mudou o <b>Nome/Sobrenome/Idade</b> do Passaporte: <b>"..vRP.format(parseInt(args[1])).." "..identity.name.." "..identity.firstname.."</b> para <b>"..args[2].." "..args[3].." "..args[4].."</b>.")
                end
            end
        end
    end
end)
---------------------------------------------------------------------------------------------
-- RESET
---------------------------------------------------------------------------------------------
RegisterCommand('reset',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,"owner.permissao") then
            if args[1] then
                local nplayer = vRP.getUserSource(parseInt(args[1]))
                local id = vRP.getUserId(nplayer)
                if id then
                    vRP.setUData(id,"vRP:spawnController",json.encode(1))
                    TriggerClientEvent("Notify",user_id,"sucesso","Você <b>resetou</b> o personagem do passaporte <b>"..vRP.format(parseInt(args[1])).."</b>.",5000)
                end
            end
        end
    end
end)
-- COMANDOS PARA LIDERANÇA

--[[local dslider = {
    --{"Group", "Cargo", "weebhooklink"},
	{"Policia", "TenenteCoronel", "https://discord.com/api/webhooks/952424757289173052/Hq1GctnR7EpybLCRhCmITislh9h1dJp8relCaq9psUDfY6qfWqY65juzE1VEfhdBPZRZ"},
	{"PoliciaCivil", "Delegado", "https://discord.com/api/webhooks/952424757289173052/Hq1GctnR7EpybLCRhCmITislh9h1dJp8relCaq9psUDfY6qfWqY65juzE1VEfhdBPZRZ"},
	{"TOR", "TenenteCoronel", "https://discord.com/api/webhooks/952424757289173052/Hq1GctnR7EpybLCRhCmITislh9h1dJp8relCaq9psUDfY6qfWqY65juzE1VEfhdBPZRZ"},
	{"ROTA", "TenenteCoronel", "https://discord.com/api/webhooks/952424757289173052/Hq1GctnR7EpybLCRhCmITislh9h1dJp8relCaq9psUDfY6qfWqY65juzE1VEfhdBPZRZ"},
}
RegisterCommand('addlider',function(source,args,rawCommand)
    local source = source 
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao")then
	    if parseInt(args[1]) then
	        for i,v in pairs(dslider) do
		        if args[2] == v[1] then
		            local id = vRP.getUserSource(parseInt(args[1]))
	                if id then 
                        TriggerClientEvent("Notify",source,"importante","Convite enviado")					
		                local aok = vRP.request(id,"Deseja ser "..v[2].." da "..v[1].."?",20)
		                if aok then
						    TriggerClientEvent("Notify",source,"importante","Convite aceito")
		                    vRP.addUserGroup(parseInt(args[1]),v[1])
			                vRP.addUserGroup(parseInt(args[1]),v[2])
			                SendWebhookMessage(v[3],"```css\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SETOU]: "..parseInt(args[1]).." \n[GRUPO]: "..v[2].." \nData e Hora : "..os.date("%d/%m/%Y %H:%M:%S").." \r```")
                        end
				    end
			    end
			end
		end
	end
end)
local dsmembro = {
	{"Policia", "policia.permissao", "TenenteCoronel", "Soldado2", ""},
	{"PoliciaCivil", "policiacivil.permissao", "Delegado", "Agente", ""},
	{"Tor", "tor.permissao", "TenenteCoronel", "Soldado2",""},
	{"Rota", "rota.permissao", "TenenteCoronel", "Soldado2",""},
}
RegisterCommand('addmembro',function(source,args,rawCommand)
    local source = source 
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	for i,v in pairs(dsmembro) do
	    if vRP.hasPermission(user_id, v[2]) and vRP.hasGroup(user_id, v[3])then
	        if parseInt(args[1]) then
	            local id = vRP.getUserSource(parseInt(args[1]))
				TriggerClientEvent("Notify",source,"importante","Convite enviado")
				if id then 
	                local aok = vRP.request(id,"Deseja ser "..v[4].." da "..v[1].."?",20)
		            if aok then
	                    vRP.addUserGroup(parseInt(args[1]),v[4])
			            vRP.addUserGroup(parseInt(args[1]),v[1])
						TriggerClientEvent("Notify",source,"importante","Convite aceito")
						SendWebhookMessage(v[5],"```css\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SETOU]: "..args[1].." \n[GRUPO]: "..v[1].." \nData e Hora : "..os.date("%d/%m/%Y %H:%M:%S").." \r```")
					end
				end
			end
		end
	end
end)
local dscargos = {
    -- Policia Militar
    {"policia.permissao", "TenenteCoronel", "Soldado2", "Soldado1"},
	{"policia.permissao", "TenenteCoronel", "Soldado1", "Cabo"},
	{"policia.permissao", "TenenteCoronel", "Cabo", "TerceiroSargento"},
	{"policia.permissao", "TenenteCoronel", "TerceiroSargento", "SegundoSargento"},
	{"policia.permissao", "TenenteCoronel", "SegundoSargento", "PrimeiroSargento"},
	{"policia.permissao", "TenenteCoronel", "PrimeiroSargento", "SubTenente"},
	{"policia.permissao", "TenenteCoronel", "SubTenente", "AlunoOficial"},
	{"policia.permissao", "TenenteCoronel", "AlunoOficial", "SegundoTenente"},
	{"policia.permissao", "TenenteCoronel", "SegundoTenente", "PrimeiroTenente"},
	{"policia.permissao", "TenenteCoronel", "PrimeiroTenente", "Capitao"},
	{"policia.permissao", "TenenteCoronel", "Capitao", "Major"},
	{"policia.permissao", "TenenteCoronel", "Major", "TenenteCoronel"},
	-- ROTA
	{"rota.permissao", "TenenteCoronel", "Soldado2", "Soldado1"},
	{"rota.permissao", "TenenteCoronel", "Soldado1", "Cabo"},
	{"rota.permissao", "TenenteCoronel", "Cabo", "TerceiroSargento"},
	{"rota.permissao", "TenenteCoronel", "TerceiroSargento", "SegundoSargento"},
	{"rota.permissao", "TenenteCoronel", "SegundoSargento", "PrimeiroSargento"},
	{"rota.permissao", "TenenteCoronel", "PrimeiroSargento", "SubTenente"},
	{"rota.permissao", "TenenteCoronel", "SubTenente", "AlunoOficial"},
	{"rota.permissao", "TenenteCoronel", "AlunoOficial", "SegundoTenente"},
	{"rota.permissao", "TenenteCoronel", "SegundoTenente", "PrimeiroTenente"},
	{"rota.permissao", "TenenteCoronel", "PrimeiroTenente", "Capitao"},
	{"rota.permissao", "TenenteCoronel", "Capitao", "Major"},
	{"rota.permissao", "TenenteCoronel", "Major", "TenenteCoronel"},
	-- Policia Civil
	{"policiacivil.permissao", "Delegado", "Agente", "Investigador"},
	{"policiacivil.permissao", "Delegado", "Investigador", "PeritoCriminal"},
	{"policiacivil.permissao", "Delegado", "PeritoCriminal", "Inspetor"},
	{"policiacivil.permissao", "Delegado", "Inspetor", "Escrivao"},
	{"policiacivil.permissao", "Delegado", "Escrivao", "DelegadoAdjunto"},
	{"policiacivil.permissao", "Delegado", "DelegadoAdjunto", "Delegado"},
	-- TOR
	{"tor.permissao", "TenenteCoronel", "Soldado2", "Soldado1"},
	{"tor.permissao", "TenenteCoronel", "Soldado1", "Cabo"},
	{"tor.permissao", "TenenteCoronel", "Cabo", "TerceiroSargento"},
	{"tor.permissao", "TenenteCoronel", "TerceiroSargento", "SegundoSargento"},
	{"tor.permissao", "TenenteCoronel", "SegundoSargento", "PrimeiroSargento"},
	{"tor.permissao", "TenenteCoronel", "PrimeiroSargento", "SubTenente"},
	{"tor.permissao", "TenenteCoronel", "SubTenente", "AlunoOficial"},
	{"tor.permissao", "TenenteCoronel", "AlunoOficial", "SegundoTenente"},
	{"tor.permissao", "TenenteCoronel", "SegundoTenente", "PrimeiroTenente"},
	{"tor.permissao", "TenenteCoronel", "PrimeiroTenente", "Capitao"},
	{"tor.permissao", "TenenteCoronel", "Capitao", "Major"},
	{"tor.permissao", "TenenteCoronel", "Major", "TenenteCoronel"},
}
RegisterCommand('promover',function(source,args,rawCommand)
    local source = source 
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	for i,v in pairs(dscargos) do
	    if vRP.hasPermission(user_id, v[1]) and vRP.hasGroup(user_id, v[2])then
            if parseInt(args[1]) then
			    local playerid = vRP.getUserId(parseInt(args[1]))
				
			    if vRP.hasPermission(parseInt(args[1]), v[1]) and  vRP.hasGroup(parseInt(args[1]), v[3])then
				
			        vRP.addUserGroup(parseInt(args[1]),v[4])
					
					TriggerClientEvent("Notify",source,"importante","Jogador ID "..parseInt(args[1]).." promovido a "..v[4]..".")
					TriggerClientEvent("Notify",parseInt(args[1]),"importante","Voce foi promovido a "..v[4]..".")
					
					break
				end
			end
	    end
	end
end)
local dsdelete = {
    {"policia.permissao", "TenenteCoronel", "Policia"}, 
    {"rota.permissao", "TenenteCoronel", "Rota"},
	{"policiacivil.permissao", "Delegado", "PoliciaCivil"},
	{"tor.permissao", "TenenteCoronel", "Tor"},
}]]
-----------------------------------------------------------------------------------------------------------------------------------------
-- ESTOQUE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('estoque',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        if args[1] and args[2] then
            vRP.execute("creative/set_estoque",{ vehicle = args[1], quantidade = args[2] })
            TriggerClientEvent("Notify",source,"sucesso","Voce colocou mais <b>"..args[2].."</b> no estoque, para o carro <b>"..args[1].."</b>.") 
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADD CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('addcar',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local nplayer = vRP.getUserId(parseInt(args[2]))
    if vRP.hasPermission(user_id,"car.permissao") then
        if args[1] and args[2] then
            local nuser_id = vRP.getUserId(nplayer)
            local identity = vRP.getUserIdentity(user_id)
            local identitynu = vRP.getUserIdentity(nuser_id)
            vRP.execute("creative/add_vehicle",{ user_id = parseInt(args[2]), vehicle = args[1], ipva = parseInt(os.time()) }) 
            --vRP.execute("creative/set_ipva",{ user_id = parseInt(args[2]), vehicle = args[1], ipva = parseInt(os.time()) })
            TriggerClientEvent("Notify",source,"sucesso","Você adicionou o veículo <b>"..args[1].."</b> no Passaporte: <b>"..parseInt(args[2]).."</b>.") 
            SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ADICIONOU]: "..args[1].." \n[PARA O ID]: "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```") 
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REM CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('remcar',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local nplayer = vRP.getUserId(parseInt(args[2]))
    if vRP.hasPermission(user_id,"car.permissao") then
        if args[1] and args[2] then
            local nuser_id = vRP.getUserId(nplayer)
            local identity = vRP.getUserIdentity(user_id)
            local identitynu = vRP.getUserIdentity(nuser_id)
            vRP.execute("creative/rem_vehicle",{ user_id = parseInt(args[2]), vehicle = args[1], ipva = parseInt(os.time())  }) 
            TriggerClientEvent("Notify",source,"sucesso","Voce removeu o veículo <b>"..args[1].."</b> do Passaporte: <b>"..parseInt(args[2]).."</b>.") 
            SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[REMOVEU]: "..args[1].." \n[PARA O ID]: "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ESTOQUE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('estoque',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        if args[1] and args[2] then
            vRP.execute("creative/set_estoque",{ vehicle = args[1], quantidade = args[2] })
            TriggerClientEvent("Notify",source,"sucesso","Voce colocou mais <b>"..args[2].."</b> no estoque, para o veículo <b>"..args[1].."</b>.") 
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CUFF
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cuff',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
        if vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient._setHandcuffed(source,true)
			TriggerClientEvent("setalgemas",source)
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- UNCUFF
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('uncuff',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
        if vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient._setHandcuffed(source,false)
			TriggerClientEvent("removealgemas",source)
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SYNCAREA
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('limpararea',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local x,y,z = vRPclient.getPosition(source)
    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"polpar.permissao") then
        TriggerClientEvent("syncarea",-1,x,y,z)
    end
end)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TROCAR SEXO
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('skin',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
        if parseInt(args[1]) then
            local nplayer = vRP.getUserSource(parseInt(args[1]))
            if nplayer then
                TriggerClientEvent("skinmenu",nplayer,args[2])
                TriggerClientEvent("Notify",source,"sucesso","Voce setou a skin <b>"..args[2].."</b> no passaporte <b>"..parseInt(args[1]).."</b>.")
            end
        end
    end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('debug',function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		local player = vRP.getUserSource(user_id)
		if vRP.hasPermission(user_id,"admin.permissao") then
			TriggerClientEvent("ToggleDebug",player)
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Combustível
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('fuel',function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		local player = vRP.getUserSource(user_id)
		if (vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"platina.permissao")) then
			TriggerClientEvent("admfuel",player)
			TriggerClientEvent("Notify",source,"sucesso","Tanque cheio")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYDELETEOBJ
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trydeleteobj")
AddEventHandler("trydeleteobj",function(index)
    TriggerClientEvent("syncdeleteobj",-1,index)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('fix',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local vehicle = vRPclient.getNearestVehicle(source,11)
	local identity = vRP.getUserIdentity(user_id)
	if vehicle then
		--if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
		if vRP.hasPermission(user_id,"fix.permissao") then
			TriggerClientEvent('reparar',source)
			SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." " ..identity.name.." "..identity.firstname.. "\n[FIX] " ..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('god',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local player = user_id
    --if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
	if vRP.hasPermission(user_id,"god.permissao") or vRP.hasPermission(user_id,"god.permissao") then
        if args[1] and vRP.hasPermission(user_id,"god.permissao") then
            local nplayer = vRP.getUserSource(parseInt(args[1]))
            if nplayer then
                player = nplayer
                vRPclient.killGod(nplayer)
                vRPclient.setHealth(nplayer,400)
                TriggerClientEvent("resetBleeding",nplayer)
                TriggerClientEvent("resetDiagnostic",nplayer)
            end
        else
            vRPclient.killGod(source)
            vRPclient.setHealth(source,400)
            TriggerClientEvent("resetBleeding",source)
            TriggerClientEvent("resetDiagnostic",source)
            --vRPclient.setArmour(source,100)
        end
        local identity = vRP.getUserIdentity(user_id)
        SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.."  " ..identity.name.." "..identity.firstname.. "\n[GOD]: " .. player ..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GOD ALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('godall',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
    	local users = vRP.getUsers()
        for k,v in pairs(users) do
            local id = vRP.getUserSource(parseInt(k))
            if id then
            	vRPclient.killGod(id)
				vRPclient.setHealth(id,400)
				TriggerClientEvent("resetBleeding",nplayer)
                TriggerClientEvent("resetDiagnostic",nplayer)
				print(id)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tuning',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"car.permissao") then
		TriggerClientEvent('vehtuning',source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('wl',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"admin.permissao") then
        if args[1] then
            vRP.setWhitelisted(parseInt(args[1]),true)
            TriggerClientEvent("Notify",source,"sucesso","Voce aprovou o passaporte "..args[1].." na whitelist.")
            SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[APROVOU WL]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNWL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('unwl',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao")  then
		if args[1] then
			vRP.setWhitelisted(parseInt(args[1]),false)
			TriggerClientEvent("Notify",source,"sucesso","Voce retirou o passaporte <b>"..args[1].."</b> da whitelist.")
			SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU WL]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('kick',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") then
		if args[1] then
			local id = vRP.getUserSource(parseInt(args[1]))
			if id then
				vRP.kick(id,"Você foi expulso da cidade.")
				TriggerClientEvent("Notify",source,"sucesso","Voce kickou o passaporte: <b>"..args[1].."</b> da cidade.")
				SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[KICKOU]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK ALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('kickall',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
        local users = vRP.getUsers()
        for k,v in pairs(users) do
            local id = vRP.getUserSource(parseInt(k))
            if id then
                vRP.kick(id,"Você foi vitima do terremoto.")
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ban',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"ban.permissao") then
		if args[1] then
			vRP.setBanned(parseInt(args[1]),true)
			TriggerClientEvent("Notify",source,"sucesso","Voce baniu o passaporte <b>"..args[1].."</b> da cidade.")
			SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[BANIU]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNBAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('unban',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"unban.permissao") then
		if args[1] then
			vRP.setBanned(parseInt(args[1]),false)
			TriggerClientEvent("Notify",source,"sucesso","Voce desbaniu o passaporte <b>"..args[1].."</b> da cidade.")
			SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[DESBANIU]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('money',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"money.permissao") then
		if args[1] then
			vRP.giveMoney(user_id,parseInt(args[1]))
            TriggerClientEvent("Notify",source,"importante","Você recebeu <b>R$"..vRP.format(parseInt(args[1]))..",00")
			SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[FEZ]: $"..vRP.format(parseInt(args[1])).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('nc',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"noclip.permissao") or vRP.hasPermission(user_id,"noclip.permissao") or vRP.hasPermission(user_id,"noclip.permissao") then
		vRPclient.toggleNoclip(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPCDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpcds',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		local fcoords = vRP.prompt(source,"Cordenadas:","")
		if fcoords == "" then
			return
		end
		local coords = {}
		for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
			table.insert(coords,parseInt(coord))
		end
		vRPclient.teleport(source,coords[1] or 0,coords[2] or 0,coords[3] or 0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS NA TELA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cds',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		local x,y,z = vRPclient.getPosition(source)
		heading = GetEntityHeading(GetPlayerPed(-1))
		vRP.prompt(source,"Cordenadas:","['x'] = "..tD(x)..", ['y'] = "..tD(y)..", ['z'] = "..tD(z))
	end
end)

RegisterCommand('cds2',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		local x,y,z = vRPclient.getPosition(source)
		vRP.prompt(source,"Cordenadas:",tD(x)..","..tD(y)..","..tD(z))
	end
end)

RegisterCommand('cds3',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		local x,y,z = vRPclient.getPosition(source)
		vRP.prompt(source,"Cordenadas:","{name='ATM', id=277, x="..tD(x)..", y="..tD(y)..", z="..tD(z).."},")
	end
end)

function tD(n)
    n = math.ceil(n * 100) / 100
    return n
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDSH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cdsh',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		local x,y,z = vRPclient.getPosition(source)
		local lugar = vRP.prompt(source,"Lugar:","")
		if lugar == "" then
			return
		end
	    SendWebhookMessage(webhookcds,"```prolog\n[PASSAPORTE]: "..user_id.." \n[LUGAR]: "..lugar.." \n[CDSH]: ['x'] = "..tD(x)..", ['y'] = "..tD(y)..", ['z'] = "..tD(z)..", ['name'] = "..lugar..", \r```")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('group',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"admin.permissao") then
		if args[1] and args[2] then
			vRP.addUserGroup(parseInt(args[1]),args[2])
			TriggerClientEvent("Notify",source,"sucesso","Voce setou o passaporte <b>"..parseInt(args[1]).."</b> no grupo <b>"..args[2].."</b>.")
			SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SETOU]: "..args[1].." \n[GRUPO]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNGROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ungroup',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"admin.permissao") then
		if args[1] and args[2] then
			vRP.removeUserGroup(parseInt(args[1]),args[2])
			TriggerClientEvent("Notify",source,"sucesso","Voce removeu o passaporte <b>"..parseInt(args[1]).."</b> do grupo <b>"..args[2].."</b>.")
			SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[REMOVEU]: "..args[1].." \n[GRUPO]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
--[ AGROUP ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

vRP.prepare('vrpex/getdatatable', "SELECT * FROM vrp_user_data WHERE user_id = @user_id AND dkey = 'vRP:datatable'" )
vRP.prepare('vrpex/attdatatable', "UPDATE vrp_user_data SET dvalue = @datatable WHERE user_id = @user_id AND dkey = 'vRP:datatable'")

RegisterCommand('agroup',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"group.permissao") or vRP.hasPermission(user_id,"group.permissao") then
        
        local nuser_id = args[1]
        local grupo = args[2]
        if nuser_id and grupo then
            local nsource = vRP.getUserSource(nuser_id)
            if nsource then
                vRP.addUserGroup(parseInt(args[1]),args[2])
                TriggerClientEvent("Notify",source,"sucesso", 'Sucesso',"Voce setou o passaporte <b>"..parseInt(args[1]).."</b> no grupo <b>"..args[2].."</b>.",8000)
            else
                local query = vRP.query('bcn/getdatatable', { user_id = nuser_id })

                if query[1] then
                    local datatable = json.decode(query[1].dvalue)
                    if datatable['groups'][grupo] then
                        TriggerClientEvent('Notify', source, 'negado', 'Negado', 'O passaporte ' .. nuser_id .. ' já faz parte do grupo ' .. grupo)
                    else
                        datatable['groups'][grupo] = true
                        datatable = json.encode(datatable)
                        vRP.execute('bcn/attdatatable', {user_id = nuser_id, datatable = datatable})
                        TriggerClientEvent('Notify', source, 'sucesso', 'Sucesso', 'O passaporte ' .. nuser_id .. ' foi adicionado ao grupo ' .. grupo)
                    end
                else
                    TriggerClientEvent("Notify",source,"negado", 'a',"O jogador " .. nuser_id .. ' não possui registros no banco de dados.',8000)
                end
            end
        end
    end
end)
--[ RGROUP ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterCommand('rgroup',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"group.permissao") or vRP.hasPermission(user_id,"group.permissao") then
        
        local nuser_id = args[1]
        local grupo = args[2]
        if nuser_id and grupo then
            local nsource = vRP.getUserSource(nuser_id)
            if nsource then
                vRP.removeUserGroup(args[1],args[2])
                TriggerClientEvent("Notify",source,"sucesso", 'Sucesso',"Voce removeu o passaporte <b>"..parseInt(args[1]).."</b> do grupo <b>"..args[2].."</b>.",8000)
            else
                local query = vRP.query('bcn/getdatatable', { user_id = nuser_id })

                if query[1] then
                    local datatable = json.decode(query[1].dvalue)
                    if not datatable['groups'][grupo] then
                        TriggerClientEvent('Notify', source, 'negado', 'Negado', 'O passaporte ' .. nuser_id .. ' já não faz parte do grupo ' .. grupo)
                    else
                        datatable['groups'][grupo] = nil
                        datatable = json.encode(datatable)
                        vRP.execute('bcn/attdatatable', {user_id = nuser_id, datatable = datatable})
                        TriggerClientEvent('Notify', source, 'sucesso', 'Sucesso', 'O passaporte ' .. nuser_id .. ' foi removido do grupo ' .. grupo)
                    end
                else
                    TriggerClientEvent("Notify",source,"negado", 'Negado',"O jogador " .. nuser_id .. ' não possui registros no banco de dados.',8000)
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tptome',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"tp.permissao") or vRP.hasPermission(user_id,"tp.permissao") then
		if args[1] then
			local tplayer = vRP.getUserSource(parseInt(args[1]))
			local x,y,z = vRPclient.getPosition(source)
			if tplayer then
				vRPclient.teleport(tplayer,x,y,z)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpto',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"tp.permissao") or vRP.hasPermission(user_id,"tp.permissao") then
		if args[1] then
			local tplayer = vRP.getUserSource(parseInt(args[1]))
			if tplayer then
				vRPclient.teleport(source,vRPclient.getPosition(tplayer))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpway',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"tp.permissao") then
		TriggerClientEvent('tptoway',source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELNPCS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('delnpcs',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		TriggerClientEvent('delnpcs',source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('adm',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
		local mensagem = vRP.prompt(source,"Mensagem:","")
		if mensagem == "" then
			return
		end
		SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[MENSAGEM]: "..mensagem.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		vRPclient.setDiv(-1,"anuncio",".div_anuncio { background: rgba(255,50,50,0.8); font-size: 11px; font-family: arial; color: #fff; padding: 20px; bottom: 10%; right: 5%; max-width: 500px; position: absolute; -webkit-border-radius: 5px; } bold { font-size: 16px; }","<bold>"..mensagem.."</bold><br><br>Mensagem enviada por: Administrador")
		SetTimeout(60000,function()
			vRPclient.removeDiv(-1,"anuncio")
		end)
	end
end)


RegisterCommand("dv", function(source, args, rawCommand)
    local user_id = vRP.getUserId({source})
    if user_id then
        -- Verifica se o usuário tem a permissão "admin.permissao"
        if vRP.hasPermission({user_id, "admin.permissao"}) then
            TriggerClientEvent('vRP:deleteVehicle', source)
        else
            vRPclient.notify(source, {"~r~Você não tem permissão para usar este comando!"}) -- Notificação de permissão negada
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('pon',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local users = vRP.getUsers()
    local players = ""
    local quantidade = 0
    for k,v in pairs(users) do
        if k ~= #users then
            players = players..", "
        end
        players = players..k
        quantidade = quantidade + 1
    end
    TriggerClientEvent('chatMessage',source,"TOTAL ONLINE",{255,160,0},quantidade)
    if vRP.hasPermission(user_id,"comum.permissao") then
        TriggerClientEvent('chatMessage',source,"ID's ONLINE",{255,160,0},players)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAR cor
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('carcolor',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"car.permissao") or vRP.hasPermission(user_id,"car.permissao") then
        local vehicle = vRPclient.getNearestVehicle(source,7)
        if vehicle then
            local rgb = vRP.prompt(source,"RGB Color(255 255 255):","")
            rgb = sanitizeString(rgb,"\"[]{}+=?!_()#@%/\\|,.",false)
            local r,g,b = table.unpack(splitString(rgb," "))
            TriggerClientEvent('vcolorv',source,vehicle,tonumber(r),tonumber(g),tonumber(b))
            
            TriggerClientEvent('chatMessage',source,"ALERTA",{255,70,50},"Cor ^1alterada")
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- cirurgia
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cirurgia',function(source,args,rawCommand)
	local source = source
    local user_id = vRP.getUserId(source)
	local nplayer = vRP.getUserSource(parseInt(args[1]))
	local nuser_id = vRP.getUserId(nplayer)
	local identityu = vRP.getUserIdentity(nuser_id)
    if args[1] then
        if vRP.hasPermission(user_id,"paramedico.permissao") or vRP.hasPermission(user_id,"admin.permissao") then
				local id = vRP.prompt(source,"Passaporte do(a) paciente:","")
				local tipo = vRP.prompt(source,"Tipo da prontuário (Cirurgia/Laudo Médico/Consulta):","")
				local descricao = vRP.prompt(source,"Descrição:","")
				local atestado = vRP.prompt(source,"Atestado:","Não foi solicitado.")
				if id == "" or tipo == "" or descricao == "" then
					return
				end
				local paramid = vRP.getUserIdentity(user_id)
				local identity = vRP.getUserIdentity(parseInt(id))
				SendWebhookMessage(webhookprontuario,"```prolog\n[ --------------- Cirurgia --------------- ]\nParamédico: ["..user_id.."] "..paramid.name.." "..paramid.firstname.." \nPaciente: ["..id.."] "..identity.name.." "..identity.firstname.."\nDescrição: "..descricao.."\nAtestado: "..atestado.." "..os.date("\nData: %d/%m/%Y - %H:%M:%S").." \r```")
			if vRP.request(nplayer,"Deseja pagar uma cirurgia no valor de <b>R$50000</b>?",30) then
				if vRP.tryFullPayment(nuser_id,50000,(args[1])) then
					vRP.giveBankMoney(user_id,50000,(args[1]))
					TriggerClientEvent('Notify',source,"sucesso","Recebeu <b>R$50000</b> de <b>"..identityu.name.. " "..identityu.firstname.."</b>.")
					if nuser_id then
						vRP.setUData(nuser_id,"vRP:spawnController",json.encode(0))
						TriggerClientEvent("Notify",user_id,"sucesso","Você fez uma <b>Cirurgia</b> no paciente: <b>"..identityu.name.. " "..identityu.firstname.."</b>.",5000)
						vRP.kick(nplayer,"Sua cirurgia foi um sucesso parabéns.")
					end	
				end
            else    
                TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
            end   
        end
    end
end)

RegisterCommand('kill',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"owner.permissao") or vRP.hasPermission(user_id,"owner.permissao") then
        if args[1] then
            local nplayer = vRP.getUserSource(parseInt(args[1]))
            if nplayer then
                vRPclient.setHealth(nplayer,0)
                TriggerClientEvent("Notify",source,"importante","Importante","Você matou o passaporte "..args[1])
            end
        else
            args[1] = user_id
            vRPclient.setHealth(source,0)
        end
        SendWebhookMessage(webhookadmin,"prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[KILL]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r")
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARMA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('arma',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
    if user_id then
        if args[1] then
            if vRP.hasPermission(user_id,"admin.permissao") then
            	vRPclient.giveWeapons(source,{[args[1]] = { ammo = 500 }})
				TriggerClientEvent("Notify",source,"importante","Você pergou a arma "..args[1])
			end
        end
    end
end)
RegisterCommand("kit", function(source)
    local user_id = vRP.getUserId(source)
    local query = vRP.query("vRP/get_kit", { user_id = parseInt(user_id) })
    for k,v in pairs(query) do
        if v.kit == 0 then
            print("Teste")
            vRP.giveInventoryItem(user_id,"celular",1)
            vRP.giveInventoryItem(user_id,"radio",1)  
            vRP.giveInventoryItem(user_id,"roupas",1)     
            vRP.giveInventoryItem(user_id,"mochila",1)                                  
            vRP.execute("vRP/set_kit",{ user_id = user_id })
        else 
            TriggerClientEvent("Notify",source,"vermelho","Voce já resgatou o seu Kit Inicial") 
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /staff
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterCommand('staff',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
    -------------------------------------------------------------------------------------------------------------------------------------
	  -- PRESIDENTE ------------------------------------------------------------------------------------------------------------------
      -------------------------------------------------------------------------------------------------------------------------------------
	if vRP.hasPermission(user_id,"owner.permissao") then
		vRP.addUserGroup(user_id,"OFFPRESIDENTE")
        vRP.removeUserGroup(user_id,"PRESIDENTE")
		TriggerClientEvent("Notify",source,"importante","Você saiu de serviço.")
		SendWebhookMessage(logAdmStatus,"```prolog\n[PRESIDENTE]: » "..user_id.." "..identity.name.." "..identity.firstname.." \n[PONTO]: → SAIU "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

	elseif vRP.hasPermission(user_id,"offowner.permissao") then
		vRP.addUserGroup(user_id,"PRESIDENTE")
        vRP.removeUserGroup(user_id,"OFFPRESIDENTE")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
		SendWebhookMessage(logAdmStatus,"```prolog\n[PRESIDENTE]: » "..user_id.." "..identity.name.." "..identity.firstname.." \n[PONTO]: → ENTROU "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	  -------------------------------------------------------------------------------------------------------------------------------------
	  -- ADM --------------------------------------------------------------------------------------------------------------------------
      -------------------------------------------------------------------------------------------------------------------------------------
    elseif vRP.hasPermission(user_id,"admin.permissao") then
		vRP.addUserGroup(user_id,"OFFADM")
        vRP.removeUserGroup(user_id,"ADM")
		TriggerClientEvent("Notify",source,"importante","Você saiu de serviço.")
		SendWebhookMessage(logAdmStatus,"```prolog\n[ADM]: » "..user_id.." "..identity.name.." "..identity.firstname.." \n[PONTO]: → SAIU "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	
	elseif vRP.hasPermission(user_id,"offadmin.permissao") then
		vRP.addUserGroup(user_id,"ADM")
        vRP.removeUserGroup(user_id,"OFFADM")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
		SendWebhookMessage(logAdmStatus,"```prolog\n[ADM]: » "..user_id.." "..identity.name.." "..identity.firstname.." \n[PONTO]: → ENTROU "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	  -------------------------------------------------------------------------------------------------------------------------------------
	  -- MOD -------------------------------------------------------------------------------------------------------------------------
      -------------------------------------------------------------------------------------------------------------------------------------
    elseif vRP.hasPermission(user_id,"mod.permissao") then
		vRP.addUserGroup(user_id,"OFFMOD")
        vRP.removeUserGroup(user_id,"MOD")
		TriggerClientEvent("Notify",source,"importante","Você saiu de serviço.")
		SendWebhookMessage(logAdmStatus,"```prolog\n[MOD]: » "..user_id.." "..identity.name.." "..identity.firstname.." \n[PONTO]: → SAIU "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	
	elseif vRP.hasPermission(user_id,"offmod.permissao") then
		vRP.addUserGroup(user_id,"MOD")
        vRP.removeUserGroup(user_id,"OFFMOD")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
		SendWebhookMessage(logAdmStatus,"```prolog\n[MOD]: » "..user_id.." "..identity.name.." "..identity.firstname.." \n[PONTO]: → ENTROU "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	  -------------------------------------------------------------------------------------------------------------------------------------
	  -- SUPORTE -------------------------------------------------------------------------------------------------------------------------
      -------------------------------------------------------------------------------------------------------------------------------------
    elseif vRP.hasPermission(user_id,"suporte.permissao") then
		vRP.addUserGroup(user_id,"OFFSUPORTE")
        vRP.removeUserGroup(user_id,"SUPORTE")
		TriggerClientEvent("Notify",source,"importante","Você saiu de serviço.")
		SendWebhookMessage(logAdmStatus,"```prolog\n[SUPORTE]: » "..user_id.." "..identity.name.." "..identity.firstname.." \n[PONTO]: → SAIU "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	
	elseif vRP.hasPermission(user_id,"offsuporte.permissao") then
		vRP.addUserGroup(user_id,"SUPORTE")
        vRP.removeUserGroup(user_id,"OFFSUPORTE")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
		SendWebhookMessage(logAdmStatus,"```prolog\n[SUPORTE]: » "..user_id.." "..identity.name.." "..identity.firstname.." \n[PONTO]: → ENTROU "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	end
end)