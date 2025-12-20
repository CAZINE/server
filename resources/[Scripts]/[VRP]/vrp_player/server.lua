local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
local idgens = Tools.newIDGenerator()
src = {}
Tunnel.bindInterface("vrp_player",src)
vDIAGNOSTIC = Tunnel.getInterface("vrp_diagnostic")
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookgarmas = ""
local webhookgarmas250 = ""
local webhookenviardinheiro = ""
local webhookpaypal = ""
local webhookgive = ""
local webhooksaquear = ""
local webhookroubar = ""
local webhookcalladm = ""

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- /REVISTAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('revistar',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,2)
	local nuser_id = vRP.getUserId(nplayer)
	
	if nuser_id then
		local identity = vRP.getUserIdentity(user_id)
		local weapons = vRPclient.getWeapons(nplayer)
		local money = vRP.getMoney(nuser_id)
		local data = vRP.getUserDataTable(nuser_id)
		TriggerClientEvent('chatMessage',source,"",{},"^4- -  ^5M O C H I L A^4  - - - - - - - - - - - - - - - - - - - - - - - - - - -  [  ^3"..string.format("%.2f",vRP.getInventoryWeight(nuser_id)).."kg^4  /  ^3"..string.format("%.2f",vRP.getInventoryMaxWeight(nuser_id)).."kg^4  ]  - -")
		if data and data.inventory then
			for k,v in pairs(data.inventory) do
				TriggerClientEvent('chatMessage',source,"",{},"     "..vRP.format(parseInt(v.amount)).."x "..itemlist[k].nome)
			end
		end
		TriggerClientEvent('chatMessage',source,"",{},"^4- -  ^5E Q U I P A D O^4  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")
		for k,v in pairs(weapons) do
			if v.ammo < 1 then
				TriggerClientEvent('chatMessage',source,"",{},"     1x "..itemlist["wbody|"..k].nome)
			else
				TriggerClientEvent('chatMessage',source,"",{},"     1x "..itemlist["wbody|"..k].nome.." | "..vRP.format(parseInt(v.ammo)).."x Munições")
			end
		end
		TriggerClientEvent('chatMessage',source,"",{},"     $"..vRP.format(parseInt(money)).." Dólares")
		TriggerClientEvent("Notify",source,"aviso","Revistou id "..nuser_id.."</b>.")
		TriggerClientEvent("Notify",nplayer,"aviso","Revistado por <b>"..identity.name.." "..identity.firstname.."</b>.")
	
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
-- CHECK ROUPAS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkRoupas()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryItemAmount(user_id,"roupas") >= 1 or vRP.hasPermission(user_id,"platina.permissao") then
			return true 
		else
			TriggerClientEvent("Notify",source,"negado","Você não possui <b>Roupas Secundárias</b> na mochila.") 
			return false
		end
	end
end
---------------------------------------------------------
-- /EAT
---------------------------------------------------------
RegisterCommand("eat",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        vRP.varyThirst(user_id, -100)
        vRP.varyHunger(user_id, -100)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK CORDAS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkitemcordas()
    local user_id = vRP.getUserId(source)
    local source = source
    if user_id then
        if vRP.getInventoryItemAmount(user_id,"cordas") >= 1 then
            return true
        else
            TriggerClientEvent("Notify",source,"Negado","Você não possui item <b>CORDAS</b>")
            return false
        end
    end
end
---------------------------------------------------------------------------------
--  CARREGAR NO OMBRO------------------------------------------------------------
---------------------------------------------------------------------------------
RegisterServerEvent('cmg2_animations:sync')
AddEventHandler('cmg2_animations:sync', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
    --print("got to srv cmg2_animations:sync")
    TriggerClientEvent('cmg2_animations:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
    --print("triggering to target: " .. tostring(targetSrc))
    TriggerClientEvent('cmg2_animations:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('cmg2_animations:stop')
AddEventHandler('cmg2_animations:stop', function(targetSrc)
    TriggerClientEvent('cmg2_animations:cl_stop', targetSrc)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRATAMENTO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tratamento',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"paramedico.permissao") then
        local nplayer = vRPclient.getNearestPlayer(source,3)
        if nplayer then
            if not vRPclient.isComa(nplayer) then
                TriggerClientEvent("tratamento",nplayer)
                TriggerClientEvent("Notify",source,"sucesso","Tratamento no paciente iniciado com sucesso.",10000)
				vRP.giveMoney(user_id, 500)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local itemlist = {
	["suspensaoar"] = { index = "suspensaoar", nome = "Kit Suspensão Ar" },
	["moduloneon"] = { index = "moduloneon", nome = "Kit MÓdulo Neon" },
	["moduloxenon"] = { index = "moduloxenon", nome = "Kit MÓdulo Xenon" },
	["tablet"] = { index = "tablet", nome = "Tablet" },
	["agua"] = { index = "agua", nome = "agua" },		
	["taurina"] = { index = "taurina", nome = "taurina" },	
	["cafeina"] = { index = "cafeina", nome = "cafeina" },				
	["lanche"] = { index = "lanche", nome = "lanche" },
	["hamburger"] = { index = "hamburger", nome = "hamburger" },
	["combo1"] = { index = "combo1", nome = "combo1" },
	["cafe"] = { index = "cafe", nome = "cafe" },
	["donut"] = { index = "donut", nome = "donut" },
	["sanduiche"] = { index = "sanduiche", nome = "sanduiche" },
	["colete"] = { index = "colete", nome = "Colete Balístico" },
	["nitro"] = { index = "nitro", nome = "Óxido Nitroso" },
	["tartaruga"] = { index = "tartaruga", nome = "Filhote de Tartaruga" },
	["carnedetartaruga"] = { index = "carnedetartaruga", nome = "Carne de Tartaruga" },
	["ferramenta"] = { index = "ferramenta", nome = "Ferramenta" },
	["encomenda"] = { index = "encomenda", nome = "Encomenda" },
	["sacodelixo"] = { index = "sacodelixo", nome = "Saco de Lixo" },
	["garrafavazia"] = { index = "garrafavazia", nome = "Garrafa Vazia" },
	["garrafadeleite"] = { index = "garrafadeleite", nome = "Garrafa de Leite" },
	["tora"] = { index = "tora", nome = "Tora de Madeira" },
	["alianca"] = { index = "alianca", nome = "Aliança" },
	["bandagem"] = { index = "bandagem", nome = "Bandagem" },
	["dorflex"] = { index = "dorflex", nome = "Dorflex" },
	["cicatricure"] = { index = "cicatricure", nome = "Cicatricure" },
	["batata"] = { index = "batata", nome = "Batata" },
	["cerveja"] = { index = "cerveja", nome = "Cerveja" },
	["tequila"] = { index = "tequila", nome = "Tequila" },
	["vodka"] = { index = "vodka", nome = "Vodka" },
	["whisky"] = { index = "whisky", nome = "Whisky" },
	["conhaque"] = { index = "conhaque", nome = "Conhaque" },
	["absinto"] = { index = "absinto", nome = "Absinto" },
	["dinheirosujo"] = { index = "dinheirosujo", nome = "Dinheiro Sujo" },
	["dinheirofalso"] = { index = "dinheirofalso", nome = "Dineiro Sujo" },
	["repairkit"] = { index = "repairkit", nome = "Kit de Reparos" },
	["algemas"] = { index = "algemas", nome = "Algemas" },
	["capuz"] = { index = "capuz", nome = "Capuz" },
	["lockpick"] = { index = "lockpick", nome = "Lockpick" },
	["pneus"] = { index = "pneus", nome = "Pneus", type = "usar" },
	["masterpick"] = { index = "masterpick", nome = "Masterpick" },
	["militec"] = { index = "militec", nome = "Militec-1" },
	["carnedecormorao"] = { index = "carnedecormorao", nome = "Carne de Cormorão" },
	["carnedecorvo"] = { index = "carnedecorvo", nome = "Carne de Corvo" },
	["carnedeaguia"] = { index = "carnedeaguia", nome = "Carne de Águia" },
	["carnedecervo"] = { index = "carnedecervo", nome = "Carne de Cervo" },
	["carnedecoelho"] = { index = "carnedecoelho", nome = "Carne de Coelho" },
	["carnedecoyote"] = { index = "carnedecoyote", nome = "Carne de Coyote" },
	["carnedelobo"] = { index = "carnedelobo", nome = "Carne de Lobo" },
	["carnedepuma"] = { index = "carnedepuma", nome = "Carne de Puma" },
	["carnedejavali"] = { index = "carnedejavali", nome = "Carne de Javali" },
	["amora"] = { index = "amora", nome = "Amora" },
	["cereja"] = { index = "cereja", nome = "Cereja" },
	["graos"] = { index = "graos", nome = "Graos" },
	["graosimpuros"] = { index = "graosimpuros", nome = "Graos Impuros" },
	["keycard"] = { index = "keycard", nome = "Keycard" },
	["isca"] = { index = "isca", nome = "Isca" },
	["dourado"] = { index = "dourado", nome = "Dourado" },
	["corvina"] = { index = "corvina", nome = "Corvina" },
	["salmao"] = { index = "salmao", nome = "Salmão" },
	["pacu"] = { index = "pacu", nome = "Pacu" },
	["pintado"] = { index = "pintado", nome = "Pintado" },
	["pirarucu"] = { index = "pirarucu", nome = "Pirarucu" },
	["tilapia"] = { index = "tilapia", nome = "Tilápia" },
	["tucunare"] = { index = "tucunare", nome = "Tucunaré" },
	["lambari"] = { index = "lambari", nome = "Lambari" },
	["energetico"] = { index = "energetico", nome = "Energético" },
	["mochila"] = { index = "mochila", nome = "Mochila" },
	["varadepesca"] = { index = "varadepesca", nome = "VARA DE PESCA" },
	---- fome e sede -----------------------------------------
	["x-tudo"] = { index = "x-tudo", nome = "Mata Fome" },
	["refrigerante"] = { index = "refrigerante", nome = "Refrigerante" },
	["big-mec"] = { index = "big-mec", nome = "BIG KING" },
	["mc-cheddar"] = { index = "mc-cheddar", nome = "MEGA STACKER" },
	["quarterao"] = { index = "quarterao", nome = "CHEESEBURGER" },
	["combo"] = { index = "combo", nome = "COMBO KING" },
	-- Maconha ------------------------------------------------------------------------------------------------------
	["maconha"] = { index = "maconha", nome = "Maconha" },
	["ramosdemaconha"] = { index = "ramosdemaconha", nome = "Ramo de Maconha" },
	["maconhanaoprocessada"] = { index = "maconhanaoprocessada", nome = "Maconha não Processada" },
	["maconhamisturada"] = { index = "maconhamisturada", nome = "Maconha Misturada" },
	["baseado"] = { index = "baseado", nome = "Baseado" },
	["seda"] = { index = "seda", nome = "Seda" },
	["receita1"] = { index = "receita1", nome = "Receita Médica" },
	["receita2"] = { index = "receita2", nome = "Receita Médica" },
	-- Ecstasy ----------------------------------------------------------------------------------------------------
	["ocitocina"] = { index = "ocitocina", nome = "Ocitocina Sintética" },
	["ociacido"] = { index = "ociacido", nome = "Ácido Anf. Desidratado" },
	["primaecstasy"] = { index = "primaecstasy", nome = "Matéria Prima - Ecstasy" },
	["ecstasy"] = { index = "ecstasy", nome = "Ecstasy" },
	["glicerina"] = { index = "glicerina", nome = "Glicerina" },
	-----------------------------------------------------------------------------------------------------------------
	-- Lavagem de Dinheiro ------------------------------------------------------------------------------------------
	["impostoderenda"] = { index = "impostoderenda", nome = "Imposto de Renda" },
	["impostoderendafalso"] = { index = "impostoderendafalso", nome = "Imposto de Renda Falso" },
	-----------------------------------------------------------------------------------------------------------------
	["adubo"] = { index = "adubo", nome = "Adubo" },
	["fertilizante"] = { index = "fertilizante", nome = "Fertilizante" },
	["capsula"] = { index = "capsula", nome = "Cápsula" },
	["polvora"] = { index = "polvora", nome = "Pólvora" },
	["orgaos"] = { index = "orgaos", nome = "Órgãos" },
	["etiqueta"] = { index = "etiqueta", nome = "Etiqueta" },
	["pendrive"] = { index = "pendrive", nome = "Pendrive" },
	["notebook"] = { index = "notebook", nome = "Notebook" },
	["placa"] = { index = "placa", nome = "Placa" },
	["relogioroubado"] = { index = "relogioroubado", nome = "Relógio Roubado" },
	["pulseiraroubada"] = { index = "pulseiraroubada", nome = "Pulseira Roubada" },
	["anelroubado"] = { index = "anelroubado", nome = "Anel Roubado" },
	["colarroubado"] = { index = "colarroubado", nome = "Colar Roubado" },
	["brincoroubado"] = { index = "brincoroubado", nome = "Brinco Roubado" },
	["carteiraroubada"] = {  index = "carteiraroubada", nome = "Carteira Roubada"  },
	["tabletroubado"] = {  index = "tabletroubado", nome = "Tablet Roubado"  },
	["sapatosroubado"] = {  index = "sapatosroubado", nome = "Sapatos Roubado"  },
	["vibradorroubado"] = { index = "vibradorroubado", nome = "Vibrador Roubado" },
	["perfumeroubado"] = { index = "perfumeroubado", nome = "Perfume Roubado" },
	["folhadecoca"] = { index = "folhadecoca", nome = "Folha de Coca" },
	["pastadecoca"] = { index = "pastadecoca", nome = "Pasta de Coca" },
	["cocamisturada"] = { index = "cocamisturada", nome = "Cocaína Misturada" },
	["cocaina"] = { index = "cocaina", nome = "Cocaína" },
	["ziplock"] = { index = "ziplock", nome = "Saco ZipLock" },
	["fungo"] = { index = "fungo", nome = "Fungo" },
	["dietilamina"] = { index = "dietilamina", nome = "Dietilamina" },
	["lsd"] = { index = "lsd", nome = "LSD" },
	["acidobateria"] = { index = "acidobateria", nome = "Ácido de Bateria" },
	["anfetamina"] = { index = "anfetamina", nome = "Anfetamina" },
	["metanfetamina"] = { index = "metanfetamina", nome = "Metanfetamina" },
	["cristal"] = { index = "cristal", nome = "Cristal de Metanfetamina" },
	["pipe"] = { index = "pipe", nome = "Pipe" },
	["armacaodearma"] = { index = "armacaodearma", nome = "Armação de Arma" },
	["pecadearma"] = { index = "pecadearma", nome = "Peça de Arma" },
	["logsinvasao"] = { index = "logsinvasao", nome = "L. Inv. Banco" },
	["keysinvasao"] = { index = "keysinvasao", nome = "K. Inv. Banco" },
	["pendriveinformacoes"] = { index = "pendriveinformacoes", nome = "P. com Info." },
	["acessodeepweb"] = { index = "acessodeepweb", nome = "P. DeepWeb" },
	["diamante"] = { index = "diamante", nome = "Min. Diamante" },
	["ouro"] = { index = "ouro", nome = "Min. Ouro" },
	["bronze"] = { index = "bronze", nome = "Min. Bronze" },
	["ferro"] = { index = "ferro", nome = "Min. Ferro" },
	["rubi"] = { index = "rubi", nome = "Min. Rubi" },
	["esmeralda"] = { index = "esmeralda", nome = "Min. Esmeralda" },
	["safira"] = { index = "safira", nome = "Min. Safira" },
	["topazio"] = { index = "topazio", nome = "Min. Topazio" },
	["ametista"] = { index = "ametista", nome = "Min. Ametista" },
	["diamante2"] = { index = "diamante2", nome = "Diamante" },
	["ouro2"] = { index = "ouro2", nome = "Ouro" },
	["bronze2"] = { index = "bronze2", nome = "Bronze" },
	["ferro2"] = { index = "ferro2", nome = "Ferro" },
	["rubi2"] = { index = "rubi2", nome = "Rubi" },
	["esmeralda2"] = { index = "esmeralda2", nome = "Esmeralda" },
	["safira2"] = { index = "safira2", nome = "Safira" },
	["topazio2"] = { index = "topazio2", nome = "Topazio" },
	["ametista2"] = { index = "ametista2", nome = "Ametista" },
	["ingresso"] = { index = "ingresso", nome = "Ingresso Eventos" },
	["radio"] = { index = "radio", nome = "Radio" },
	["celular"] = { index = "celular", nome = "Radio" },
	["serra"] = { index = "serra", nome = "Serra" },
	["furadeira"] = { index = "furadeira", nome = "Furadeira" },
	["c4"] = { index = "c4", nome = "C-4" },
	["roupas"] = { index = "roupas", nome = "Roupas" },
	["xerelto"] = { index = "xerelto", nome = "Xerelto" },
	["coumadin"] = { index = "coumadin", nome = "Coumadin" },
	["detonador"] = { index = "detonador", nome = "Detonador" },
	["ferramentas"] = { index = "ferramentas", nome = "Ferramentas Pesadas" },
	["projetoassaultrifle"] = { index = "projetoassaultrifle", nome = "Projeto Ak-47" },
	["projetoassaultsmg"] = { index = "projetoassaultsmg", nome = "Projeto MAG-PDR" },
	["projetobullpuprifle"] = { index = "projetobullpuprifle", nome = "Projeto QBZ" },
	["projetocarbinerifle"] = { index = "projetocarbinerifle", nome = "Projeto M4A1" },
	["projetocombatpdw"] = { index = "projetocombatpdw", nome = "Projeto MPX" },
	["projetocombatpistol"] = { index = "projetocombatpistol", nome = "Projeto Glock 19" },
	["projetogusenberg"] = { index = "projetogusenberg", nome = "Projeto Thompson" },
	["projetopistol"] = { index = "projetopistol", nome = "Projeto Fiven" },
	["projetopumpshotgun"] = { index = "projetopumpshotgun", nome = "Projeto Shotgun" },
	["projetosawnoffshotgun"] = { index = "projetosawnoffshotgun", nome = "Projeto Shot Cano Serrado" },
	["projetosmg"] = { index = "projetosmg", nome = "Projeto MP5" },
	["wbody|WEAPON_DAGGER"] = { index = "adaga", nome = "Adaga" },
	["wbody|WEAPON_BAT"] = { index = "beisebol", nome = "Taco de Beisebol" },
	["wbody|WEAPON_BOTTLE"] = { index = "garrafa", nome = "Garrafa" },
	["wbody|WEAPON_CROWBAR"] = { index = "cabra", nome = "Pé de Cabra" },
	["wbody|WEAPON_FLASHLIGHT"] = { index = "lanterna", nome = "Lanterna" },
	["wbody|WEAPON_GOLFCLUB"] = { index = "golf", nome = "Taco de Golf" },
	["wbody|WEAPON_HAMMER"] = { index = "martelo", nome = "Martelo" },
	["wbody|WEAPON_HATCHET"] = { index = "machado", nome = "Machado" },
	["wbody|WEAPON_KNUCKLE"] = { index = "ingles", nome = "Soco-Inglês" },
	["wbody|WEAPON_KNIFE"] = { index = "faca", nome = "Faca" },
	["wbody|WEAPON_MACHETE"] = { index = "machete", nome = "Machete" },
	["wbody|WEAPON_SWITCHBLADE"] = { index = "canivete", nome = "Canivete" },
	["wbody|WEAPON_NIGHTSTICK"] = { index = "cassetete", nome = "Cassetete" },
	["wbody|WEAPON_WRENCH"] = { index = "grifo", nome = "Chave de Grifo" },
	["wbody|WEAPON_BATTLEAXE"] = { index = "batalha", nome = "Machado de Batalha" },
	["wbody|WEAPON_POOLCUE"] = { index = "sinuca", nome = "Taco de Sinuca" },
	["wbody|WEAPON_STONE_HATCHET"] = { index = "pedra", nome = "Machado de Pedra" },
	["wbody|WEAPON_PISTOL"] = { index = "m1911", nome = "M1911" }, -- WEAPON_PISTOL
	["wbody|WEAPON_PISTOL_MK2"] = { index = "fiveseven", nome = "FN Five Seven" },
	["wbody|WEAPON_HEAVYSNIPER"] = { index = "sniper", nome = "Sniper" },
	["wbody|WEAPON_COMBATPISTOL"] = { index = "glock", nome = "Glock 19" },  -- WEAPON_COMBATPISTOL
	["wbody|WEAPON_STUNGUN"] = { index = "taser", nome = "Taser" },
	["wbody|WEAPON_SNSPISTOL"] = { index = "hkp7m10", nome = "HK P7M10" },
	["wbody|WEAPON_VINTAGEPISTOL"] = { index = "m1922", nome = "M1922" },
	["wbody|WEAPON_REVOLVER"] = { index = "magnum44", nome = "Magnum 44" },
	["wbody|WEAPON_REVOLVER_MK2"] = { index = "magnum357", nome = "Magnum 357" },
	["wbody|WEAPON_MUSKET"] = { index = "winchester22", nome = "Winchester 22" },
	["wbody|WEAPON_FLARE"] = { index = "sinalizador", nome = "Sinalizador" },
	["wbody|GADGET_PARACHUTE"] = { index = "paraquedas", nome = "Paraquedas" },
	["wbody|WEAPON_FIREEXTINGUISHER"] = { index = "extintor", nome = "Extintor" },
	["wbody|WEAPON_MICROSMG"] = { index = "uzi", nome = "Uzi" },
	["wbody|WEAPON_SMG"] = { index = "smg", nome = "SMG" }, -- WEAPON_SMG
	["wbody|WEAPON_ASSAULTSMG"] = { index = "mag-pdr", nome = "MAG-PDR" }, -- WEAPON_ASSAULTSMG
	["wbody|WEAPON_COMBATPDW"] = { index = "sigsauer", nome = "Sig Sauer MPX" }, -- WEAPON_COMBATPDW
	["wbody|WEAPON_PUMPSHOTGUN_MK2"] = { index = "remington", nome = "Remington 870" },
	["wbody|WEAPON_CARBINERIFLE"] = { index = "m4a1", nome = "M4A1" }, -- WEAPON_CARBINERIFLE
	["wbody|WEAPON_SPECIALCARBINE"] = { index = "parafal", nome = "Parafal" },
	["wbody|WEAPON_SPECIALCARBINE_MK2"] = { index = "g36", nome = "G36" },
	["wbody|WEAPON_ASSAULTRIFLE"] = { index = "ak47", nome = "AK-47" }, -- WEAPON_ASSAULTRIFLE
	["wbody|WEAPON_ASSAULTRIFLE_MK2"] = { index = "ak47mk2", nome = "AK-47 MK2" }, -- WEAPON_ASSAULTRIFLE_MK2
	["wbody|WEAPON_BULLPUPRIFLE"] = { index = "qbz", nome = "FAMAS" }, -- WEAPON_BULLPUPRIFLE
	["wammo|WEAPON_BULLPUPRIFLE"] = { index = "m-qbz", nome = "M.FAMAS" }, -- WEAPON_BULLPUPRIFLE
	["wbody|WEAPON_GUSENBERG"] = { index = "thompson", nome = "Thompson" }, -- WEAPON_GUSENBERG
	["wbody|WEAPON_MACHINEPISTOL"] = { index = "tec9", nome = "Tec-9" },
	["wbody|WEAPON_CARBINERIFLE_MK2"] = { index = "mpx", nome = "MPX" },
	["wbody|WEAPON_COMPACTRIFLE"] = { index = "aks", nome = "AKS-74U" },
	["wbody|WEAPON_PETROLCAN"] = { index = "gasolina", nome = "Galão de Gasolina" },
	["wbody|WEAPON_PUMPSHOTGUN"] = { index = "shotgun", nome = "Shotgun" }, -- WEAPON_PUMPSHOTGUN
	["wbody|WEAPON_SAWNOFFSHOTGUN"] = { index = "sawnoffshotgun", nome = "Shotgun C.Serrado" }, -- WEAPON_SAWNOFFSHOTGUN
	["wammo|WEAPON_SAWNOFFSHOTGUN"] = { index = "m-sawnoffshotgun", nome = "M.Shotgun C.Serrado" }, -- WEAPON_SAWNOFFSHOTGUN
	["wammo|WEAPON_SPECIALCARBINE"] = { index = "m-parafal", nome = "m.Parafal" },
	["wammo|WEAPON_SPECIALCARBINE_MK2"] = { index = "m-g36c", nome = "m.G36" },
	["wammo|WEAPON_PISTOL"] = { index = "m-m1911", nome = "M.M1911" }, -- WEAPON_PISTOL
	["wammo|WEAPON_PISTOL_MK2"] = { index = "m-fiveseven", nome = "M.Five Seven" },
	["wammo|WEAPON_HEAVYSNIPER"] = { index = "m-sniper", nome = "M.Sniper" },
	["wammo|WEAPON_COMBATPISTOL"] = { index = "m-glock", nome = "M.Glock 19" }, -- WEAPON_COMBATPISTOL
	["wammo|WEAPON_STUNGUN"] = { index = "m-taser", nome = "M.Taser" },
	["wammo|WEAPON_SNSPISTOL"] = { index = "m-hkp7m10", nome = "M.HK P7M10" },
	["wammo|WEAPON_VINTAGEPISTOL"] = { index = "m-m1922", nome = "M.M1922" },
	["wammo|WEAPON_REVOLVER"] = { index = "m-magnum44", nome = "M.Magnum 44" },
	["wammo|WEAPON_REVOLVER_MK2"] = { index = "m-magnum357", nome = "M.Magnum 357" },
	["wammo|WEAPON_MUSKET"] = { index = "m-winchester22", nome = "M.Winchester 22" },
	["wammo|WEAPON_FLARE"] = { index = "m-sinalizador", nome = "M.Sinalizador" },
	["wammo|GADGET_PARACHUTE"] = { index = "m-paraquedas", nome = "M.Paraquedas" },
	["wammo|WEAPON_FIREEXTINGUISHER"] = { index = "m-extintor", nome = "M.Extintor" },
	["wammo|WEAPON_MICROSMG"] = { index = "m-uzi", nome = "M.Uzi" },
	["wammo|WEAPON_SMG"] = { index = "m-smg", nome = "M.SMG" }, -- WEAPON_SMG
	["wammo|WEAPON_ASSAULTSMG"] = { index = "m-mag-pdr", nome = "M.MAG-PDR" },  -- WEAPON_ASSAULTSMG
	["wammo|WEAPON_COMBATPDW"] = { index = "m-sigsauer", nome = "M.Sig Sauer MPX" }, -- WEAPON_COMBATPDW
	["wammo|WEAPON_PUMPSHOTGUN"] = { index = "m-shotgun", nome = "M.Shotgun" }, -- WEAPON_PUMPSHOTGUN
	["wammo|WEAPON_PUMPSHOTGUN_MK2"] = { index = "m-remington", nome = "M.Remington 870" },
	["wammo|WEAPON_CARBINERIFLE"] = { index = "m-m4a1", nome = "M.M4A1" },  -- WEAPON_CARBINERIFLE
	["wammo|WEAPON_ASSAULTRIFLE"] = { index = "m-ak47", nome = "M.AK-47" }, -- WEAPON_ASSAULTRIFLE
	["wammo|WEAPON_ASSAULTRIFLE_MK2"] = { index = "m-ak47mk2", nome = "M.AK-47 MK2" }, -- WEAPON_ASSAULTRIFLE_MK2
	["wammo|WEAPON_MACHINEPISTOL"] = { index = "m-tec9", nome = "M.Tec-9" },
	["wammo|WEAPON_CARBINERIFLE_MK2"] = { index = "m-mpx", nome = "M.MPX" },
	["wammo|WEAPON_COMPACTRIFLE"] = { index = "m-aks", nome = "M.AKS-74U" },
	["wammo|WEAPON_GUSENBERG"] = { index = "m-thompson", nome = "M.Thompson" },  -- WEAPON_GUSENBERG
	["wammo|WEAPON_PETROLCAN"] = { index = "combustivel", nome = "Combustível" },
	["colete"] = { index = "colete", nome = "Colete" },

	----------- FARMS -----------------------------------------------------------------------------
	["laranja"] = { index = "laranja", nome = "Laranja" },
	["tomate"] = { index = "tomate", nome = "Tomate" },
	["corpopistol"] = { index = "corpopistol", nome = "Corpo Pistol" },
	["placa-metal"] = { index = "placa-metal", nome = "Placa de Metal" },
	["gatilho"] = { index = "gatilho", nome = "Gatilho" },
	["molas"] = { index = "molas", nome = "Molas" },
	["corposub"] = { index = "corposub", nome = "Corpo Sub" },
	["corporifle"] = { index = "corporifle", nome = "Corpo Rifle" },  
	["notafiscalfalsa"] = { index = "notafiscalfalsa", nome = "Nota Fiscal Falsa" },
	
	["amido"] = { index = "amido", nome = "amido" },
	["composto"] = { index = "composto", nome = "composto" },
	["lsdembalado"] = { index = "lsdembalado", nome = "LSD Embalado" },
	["embalagem"] = { index = "embalagem", nome = "embalagem" },
	["saquinhos"] = { index = "saquinhos", nome = "saquinhos" },
	["cocaembalada"] = { index = "cocaembalada", nome = "Coca Embalada" },
	["balanca"] = { index = "balanca", nome = "balanca" },
	["tablete"] = { index = "tablete", nome = "tablete" },
	["couro"] = { index = "couro", nome = "couro" },
	["linha"] = { index = "linha", nome = "linha" },
	["tesoura"] = { index = "tesoura", nome = "tesoura" },
	["aco"] = { index = "aco", nome = "aco" },
	["aluminio"] = { index = "aluminio", nome = "aluminio" },
	["chave"] = { index = "chave", nome = "chave" },
	["plastico"] = { index = "plastico", nome = "plastico" },
	["cobre"] = { index = "cobre", nome = "cobre" },
	["chip"] = { index = "chip", nome = "chip" },
	["cordas"] = { index = "cordas", nome = "cordas" },
	["chip"] = { index = "chip", nome = "chip" },
	["tinta"] = { index = "tinta", nome = "tinta" },
	["co2"] = { index = "co2", nome = "co2" },
	["nitro"] = { index = "nitro", nome = "nitro" },

	
	["maquineta"] = { index = "maquineta", nome = "Maquina de Cartão" },
	["cartao"] = { index = "cartao", nome = "Cartão Débito" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('item',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"owner.permissao") then
		if args[1] and args[2] and itemlist[args[1]] ~= nil then
			if args[1] ~= "carteira" then
				vRP.giveInventoryItem(user_id,args[1],parseInt(args[2]))
                TriggerClientEvent("Notify",source,"importante","Você pegou  "..args[1].."  "..vRP.format(parseInt(args[2])).."x")

				local nomeItem = itemlist[args[1]]
				local quantItem = parseInt(args[2])
				SendWebhookMessage(webhookgive,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[PEGOU]: "..args[1].." \n[QUANTIDADE]: "..vRP.format(parseInt(args[2])).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)	
RegisterCommand('ip',function(source,args,rawCommand)
	if args[1] then
		local message = rawCommand:sub(3)
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		fal = identity.name.. " " .. identity.firstname
		local permission = "suporte.permissao"
		if vRP.hasPermission(user_id,permission) then
			local soldado = vRP.getUsersByPermission(permission)
			for l,w in pairs(soldado) do
				local player = vRP.getUserSource(parseInt(w))
				if player then
					async(function()
						TriggerClientEvent('chat:addMessage', player, {
						template = '<div style="padding: 0.5vw; margin: 0.5vw; background-image: linear-gradient(to right, rgba(255, 1, 1,0.9) 3%, rgba(0, 0, 0,0) 95%); border-radius: 15px 50px 30px 5px;"> Staff @{0}: {1}</div>',
						args = { fal, message }
						})
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /ADESIVOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('adesivos',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setadesivos",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- USER VEHS [ADMIN]
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('uservehs',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,"admin.permissao") then
        	local nuser_id = parseInt(args[1])
            if nuser_id > 0 then 
                local vehicle = vRP.query("creative/get_vehicle",{ user_id = parseInt(nuser_id) })
                local car_names = {}
                for k,v in pairs(vehicle) do
                	table.insert(car_names, "<b>" .. vRP.vehicleName(v.vehicle) .. "</b>")
                    --TriggerClientEvent("Notify",source,"importante","<b>Modelo:</b> "..v.vehicle,10000)
                end
                car_names = table.concat(car_names, ", ")
                local identity = vRP.getUserIdentity(nuser_id)
                TriggerClientEvent("Notify",source,"importante","Veículos de <b>"..identity.name.." " .. identity.firstname.. " ("..#vehicle..")</b>: "..car_names,10000)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- reskin
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('reskin',function(source,rawCommand)
	local user_id = vRP.getUserId(source)		
	vRPclient._setCustomization(vRPclient.getCustomization(source))		
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVASAO
-----------------------------------------------------------------------------------------------------------------------------------------
local guetos = {}
RegisterCommand('invasao',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local uplayer = vRP.getUserSource(user_id)
	local x,y,z = vRPclient.getPosition(source)
	if vRPclient.getHealth(source) > 100 then
		if vRP.hasPermission(user_id,"ada.permissao") or vRP.hasPermission(user_id,"tcp.permissao") or vRP.hasPermission(user_id,"cv.permissao") or vRP.hasPermission(user_id,"milicia.permissao") or vRP.hasPermission(user_id,"ada.permissao") then	
			local soldado = vRP.getUsersByPermission("policia.permissao")
			for l,w in pairs(soldado) do
				local player = vRP.getUserSource(parseInt(w))
				if player and player ~= uplayer then
					async(function()
						local id = idgens:gen()
						if vRP.hasPermission(user_id,"ada.permissao") then
							guetos[id] = vRPclient.addBlip(player,x,y,z,437,27,"Localização da invasão",0.8,false)
							TriggerClientEvent("Notify",player,"negado","Localização da invasão entre gangues recebida de <b>Ballas</b>.")
						elseif vRP.hasPermission(user_id,"milicia.permissao") then
							guetos[id] = vRPclient.addBlip(player,x,y,z,437,46,"Localização da invasão",0.8,false)
							TriggerClientEvent("Notify",player,"negado","Localização da invasão entre gangues recebida de <b>Milícia</b>.")
						elseif vRP.hasPermission(user_id,"cv.permissao") then
							guetos[id] = vRPclient.addBlip(player,x,y,z,437,25,"Localização da invasão",0.8,false)
							TriggerClientEvent("Notify",player,"negado","Localização da invasão entre gangues recebida de <b>CV</b>.")
						elseif vRP.hasPermission(user_id,"tcp.permissao") then
							guetos[id] = vRPclient.addBlip(player,x,y,z,437,38,"Localização da invasão",0.8,false)
							TriggerClientEvent("Notify",player,"negado","Localização da invasão entre gangues recebida de <b>TCP</b>.")
						end
						vRPclient._playSound(player,"5s_To_Event_Start_Countdown","GTAO_FM_Events_Soundset")
						vRPclient._playSound(source,"5s_To_Event_Start_Countdown","GTAO_FM_Events_Soundset")
						SetTimeout(60000,function() vRPclient.removeBlip(player,guetos[id]) idgens:free(id) end)
					end)
				end
			end
			TriggerClientEvent("Notify",source,"sucesso","Localização enviada com sucesso.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ID
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('id',function(source,rawCommand)	
	local nplayer = vRPclient.getNearestPlayer(source,2)
	local nuser_id = vRP.getUserId(nplayer)
	if nuser_id then
		local identity = vRP.getUserIdentity(nuser_id)
		vRPclient.setDiv(source,"completerg",".div_completerg { background-color: rgba(0,0,0,0.60); font-size: 13px; font-family: arial; color: #fff; width: 420px; padding: 20px 20px 5px; bottom: 8%; right: 2.5%; position: absolute; border: 1px solid rgba(255,255,255,0.2); letter-spacing: 0.5px; } .local { width: 220px; padding-bottom: 15px; float: left; } .local2 { width: 200px; padding-bottom: 15px; float: left; } .local b, .local2 b { color: #d1257d; }","<div class=\"local\"><b>Passaporte:</b> ( "..vRP.format(identity.user_id).." )</div>")
		vRP.request(source,"Você deseja fechar o registro geral?",1000)
		vRPclient.removeDiv(source,"completerg")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SALÁRIO
-----------------------------------------------------------------------------------------------------------------------------------------
local salarios = {
	-- Vips --------------------------------------------------------------------------------
	{ ['permissao'] = "bronze.permissao", ['nome'] = "Bronze", ['payment'] = 5000 },
	{ ['permissao'] = "ouro.permissao", ['nome'] = "Ouro", ['payment'] = 10000 },
	{ ['permissao'] = "platina.permissao", ['nome'] = "Platina", ['payment'] = 15000 },
	{ ['permissao'] = "diamante.permissao", ['nome'] = "Diamante", ['payment'] = 20000 },
	{ ['permissao'] = "esmeralda.permissao", ['nome'] = "Esmeralda", ['payment'] = 25000 },
	{ ['permissao'] = "patrocinador.permissao", ['nome'] = "Patrocinador", ['payment'] = 30000 },
	-- Polícia -----------------------------------------------------------------------------
	{ ['permissao'] = "soldado2.permissao", ['payment'] = 4000 },
	{ ['permissao'] = "soldado1.permissao", ['payment'] = 4000 },
	{ ['permissao'] = "cabo.permissao", ['payment'] = 4350 },
	{ ['permissao'] = "terceirosargento.permissao", ['payment'] = 4600 },
	{ ['permissao'] = "segundosargento.permissao", ['payment'] = 4700 },
	{ ['permissao'] = "primeirosargento.permissao", ['payment'] = 4800 },
	{ ['permissao'] = "subtenente.permissao", ['payment'] = 8200 },
	{ ['permissao'] = "alunooficial.permissao", ['payment'] = 3000 },
	{ ['permissao'] = "segundotenente.permissao", ['payment'] = 10000 },
	{ ['permissao'] = "primeirotenente.permissao", ['payment'] = 16300 },
	{ ['permissao'] = "capitao.permissao", ['payment'] = 17000 },
	{ ['permissao'] = "major.permissao", ['payment'] = 17550 },
	{ ['permissao'] = "tenentecoronel.permissao", ['payment'] = 18200 },
	{ ['permissao'] = "coronel.permissao", ['payment'] = 19000 },
	{ ['permissao'] = "comandantegeral.permissao", ['payment'] = 49000 },
	{ ['permissao'] = "generaleb.permissao", ['payment'] = 49000 },
	
	-- civil
	{ ['permissao'] = "agente.permissao", ['payment'] = 4350 },
	{ ['permissao'] = "investigador.permissao", ['payment'] = 4400 },
	{ ['permissao'] = "peritocriminal.permissao", ['payment'] = 5200 },
	{ ['permissao'] = "inspetor.permissao", ['payment'] = 5600 },
	{ ['permissao'] = "escrivao.permissao", ['payment'] = 6000 },
	{ ['permissao'] = "delegadoadjunto.permissao", ['payment'] = 7500 },
	{ ['permissao'] = "delegado.permissao", ['payment'] = 8500 },
	-- Hospital -----------------------------------------------------------------------------
	{ ['permissao'] = "enfermeiro.servico", ['nome'] = "Enfermeiro", ['payment'] = 6500 },
	{ ['permissao'] = "paramedico.servico", ['nome'] = "Paramedico", ['payment'] = 8000 },
	{ ['permissao'] = "medico.servico", ['nome'] = "Medico", ['payment'] = 10500 },
	{ ['permissao'] = "diretor.servico", ['nome'] = "Diretor", ['payment'] = 13000 },
	-- Mecanico -----------------------------------------------------------------------------
	{ ['permissao'] = "mecanico.permissao", ['nome'] = "Mecanico", ['payment'] = 6200 },
   -----------------------------------------------------------------------------------------
	{ ['permissao'] = "seguranca.permissao", ['nome'] = "Seguranca", ['payment'] = 6500 },
	{ ['permissao'] = "motoristabus.permissao", ['nome'] = "Motorista de Onibus", ['payment'] = 10500 },
}

local intervaloSalario = 30 -- Em minutos

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(intervaloSalario*60000)
        local players = vRP.getUsers()
        for user_id, src in pairs(players) do
            for k,v in pairs(salarios) do
                if vRP.hasPermission(user_id,v.permissao) then
                    TriggerClientEvent("vrp_sound:source",src,'coins',0.5)
                    TriggerClientEvent("Notify",src,"importante","Obrigado por colaborar com a cidade, seu salario de <b>$"..vRP.format(parseInt(v.payment)).." dólares</b> foi depositado.")
                    vRP.giveBankMoney(user_id,parseInt(v.payment))
                end
            end
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUGA FAVELA
-----------------------------------------------------------------------------------------------------------------------------------------
--[[RegisterServerEvent('indicar:fugaFavela')
AddEventHandler('indicar:fugaFavela',function()
	local source = source
	--TriggerClientEvent("Notify",source,"importante","Indique 5 amigos ativos e ganhe os veículos do <b>VIP OURO</b>.")
	TriggerClientEvent("Notify",source,"negado","<b>FUGA PARA SAFE OU FAVELA ESTÁ PROIBIDO. CASO ACONTEÇA A POLICIA IRÁ SUBIR E SEM CHORO.</b> .")
end)]]--
-----------------------------------------------------------------------------------------------------------------------------------------
-- HORÁRIO ASSALTOS
-----------------------------------------------------------------------------------------------------------------------------------------
--RegisterServerEvent('indicar:horarioAssalto')
--AddEventHandler('indicar:horarioAssalto',function()
--	local source = source
--	TriggerClientEvent("Notify",source,"negado","<b>SÓ PODERÁ ASSALTAR E SEQUESTRAR DAS 22:00 AS 06:00 DA MANHA. HORÁRIO DO RP. APROVEITE PRA RESENHAR.</b> .")
--end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BOOST DISCORD
-----------------------------------------------------------------------------------------------------------------------------------------
--[[RegisterServerEvent('boost:boostDiscord')
AddEventHandler('boost:boostDiscord',function()
	local source = source
	TriggerClientEvent("Notify",source,"importante","Boost em nosso servidor = <b>RECOMPENSA</b>.")
end)]]--
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOCARJACK
-----------------------------------------------------------------------------------------------------------------------------------------
local veiculos = {}
RegisterServerEvent("TryDoorsEveryone")
AddEventHandler("TryDoorsEveryone",function(veh,doors,placa)
	if not veiculos[placa] then
		TriggerClientEvent("SyncDoorsEveryone",-1,veh,doors)
		veiculos[placa] = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /SEQUESTRO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('sequestro',function(source,args,rawCommand)
	local nplayer = vRPclient.getNearestPlayer(source,5)
	if nplayer then
		if vRPclient.isHandcuffed(nplayer) then
			if not vRPclient.getNoCarro(source) then
				local vehicle = vRPclient.getNearestVehicle(source,7)
				if vehicle then
					if vRPclient.getCarroClass(source,vehicle) then
						vRPclient.setMalas(nplayer)
					end
				end
			elseif vRPclient.isMalas(nplayer) then
				vRPclient.setMalas(nplayer)
			end
		else
			TriggerClientEvent("Notify",source,"aviso","A pessoa precisa estar algemada para colocar ou retirar do Porta-Malas.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOTOR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('motor',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if not vRPclient.isInVehicle(source) then
		local vehicle = vRPclient.getNearestVehicle(source,7)
		if vRP.tryGetInventoryItem(user_id,"militec",1) then
			TriggerClientEvent('cancelando',source,true)
			vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
			TriggerClientEvent("progress",source,30000,"reparando")
			SetTimeout(30000,function()
				TriggerClientEvent('cancelando',source,false)
				TriggerClientEvent('repararmotor',source,vehicle)
				vRPclient._stopAnim(source,false)
			end)
		else
			TriggerClientEvent("Notify",source,"negado","Precisa de um <b>Militec-1</b> para reparar o motor.")
		end
	else
		TriggerClientEvent("Notify",source,"negado","Precisa estar próximo ou fora do veículo para efetuar os reparos.")
	end
end)

RegisterServerEvent("trymotor")
AddEventHandler("trymotor",function(nveh)
	TriggerClientEvent("syncmotor",-1,nveh)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REPARAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('reparar',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if not vRPclient.isInVehicle(source) then
        local vehicle = vRPclient.getNearestVehicle(source,7)
		if vRP.tryGetInventoryItem(user_id,"repairkit",1) and vRP.hasPermission(user_id,"mecanico.permissao") or vRP.tryGetInventoryItem(user_id,"repairkit",1) and vRP.hasPermission(user_id,"mecanico.permissao") then
            TriggerClientEvent('cancelando',source,true)
            vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
            TriggerClientEvent("progress",source,20000,"reparando veículo")
            SetTimeout(20000,function()
                TriggerClientEvent('cancelando',source,false)
                TriggerClientEvent('reparar',source,vehicle)
                vRPclient._stopAnim(source,false)
            end)
        else
			TriggerClientEvent("Notify",source,"negado","Ops, você não pode utilizar este comando.")
        end
    else
        TriggerClientEvent("Notify",source,"negado","Precisa estar próximo ou fora do veículo para efetuar os reparos.")
    end
end)

RegisterServerEvent("tryreparar")
AddEventHandler("tryreparar",function(nveh)
    TriggerClientEvent("syncreparar",-1,nveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENVIAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('enviar',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,2)
	local nuser_id = vRP.getUserId(nplayer)
	local identity = vRP.getUserIdentity(user_id)
  	local identitynu = vRP.getUserIdentity(nuser_id)
	if nuser_id and parseInt(args[1]) > 0 then
		if vRP.tryPayment(user_id,parseInt(args[1])) then
			vRP.giveMoney(nuser_id,parseInt(args[1]))
			vRPclient._playAnim(source,true,{{"mp_common","givetake1_a"}},false)
			TriggerClientEvent("Notify",source,"sucesso","Enviou <b>$"..vRP.format(parseInt(args[1])).." dólares</b>.",8000)
			vRPclient._playAnim(nplayer,true,{{"mp_common","givetake1_a"}},false)
			TriggerClientEvent("Notify",nplayer,"sucesso","Recebeu <b>$"..vRP.format(parseInt(args[1])).." dólares</b>.",8000)
			SendWebhookMessage(webhookenviardinheiro,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ENVIOU]: $"..vRP.format(parseInt(args[1])).." \n[PARA O ID]: "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		else
			TriggerClientEvent("Notify",source,"negado","Não tem a quantia que deseja enviar.",8000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARMAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('garmas',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"policia.permissao") then
		TriggerClientEvent("Notify",source,"negado","Você não pode fazer isso em serviço.")
	elseif user_id then
		local weapons = vRPclient.replaceWeapons(source,{})
		for k,v in pairs(weapons) do
			vRP.giveInventoryItem(user_id,"wbody|"..k,1)
			if v.ammo > 0 then
				vRP.giveInventoryItem(user_id,"wammo|"..k,v.ammo)
			end
			SendWebhookMessage(webhookgarmas,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[GUARDOU]: "..vRP.itemNameList("wbody|"..k).." \n[QUANTIDADE]: "..v.ammo.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			if v.ammo == 250 then 
				SendWebhookMessage(webhookgarmas250,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[TENTOU USAR MONSTERMENU E FOI PEGO NO PULO] \n>>>> [GUARDOU]: "..vRP.itemNameList("wbody|"..k).." \n[QUANTIDADE]: "..v.ammo.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```<@&641048265856647169>")
			end
		end
		TriggerClientEvent("Notify",source,"sucesso","Guardou seu armamento na mochila.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYTOW
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trytow")
AddEventHandler("trytow",function(nveh,rveh)
	TriggerClientEvent("synctow",-1,nveh,rveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trytrunk")
AddEventHandler("trytrunk",function(nveh)
	TriggerClientEvent("synctrunk",-1,nveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WINS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trywins")
AddEventHandler("trywins",function(nveh)
	TriggerClientEvent("syncwins",-1,nveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("tryhood")
AddEventHandler("tryhood",function(nveh)
	TriggerClientEvent("synchood",-1,nveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trydoors")
AddEventHandler("trydoors",function(nveh,door)
	TriggerClientEvent("syncdoors",-1,nveh,door)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /SNIPER
-----------------------------------------------------------------------------------------------------------------------------------------
local timesniper = {}
RegisterCommand('sniper',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"sniper.permissao") then
		if timesniper[user_id] == nil or timesniper[user_id] == 0 then
			timesniper[user_id] = 1800
			vRP.giveInventoryItem(user_id,"wbody|WEAPON_HEAVYSNIPER",1) --Nome do item que recebe
		else
			TriggerClientEvent("Notify",source,"negado","Voce precisa esperar "..timesniper[user_id].." segundos para usar novamente!")
		end
	end
end)
Citizen.CreateThread(function()
	while true do
		Wait(1000)
		for k,v in pairs(timesniper) do
			if timesniper[k] > 0 then
				timesniper[k] = timesniper[k] - 1
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CALL
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {}
local timechamar = {}
RegisterCommand('chamar',function(source,args,rawCommand)
	local source = source
	local answered = false
	local user_id = vRP.getUserId(source)
	local uplayer = vRP.getUserSource(user_id)
	vida = vRPclient.getHealth(source)
	if timechamar[user_id] == nil or timechamar[user_id] == 0 then
		timechamar[user_id] = 120
		vRPclient._CarregarObjeto(source,"cellphone@","cellphone_call_to_text","prop_amb_phone",50,28422)
		if user_id then
			local descricao = vRP.prompt(source,"Descrição:","")
			if descricao == "" then
				vRPclient._stopAnim(source,false)
				vRPclient._DeletarObjeto(source)
				return
			end

			local x,y,z = vRPclient.getPosition(source)
			local players = {}
			vRPclient._stopAnim(source,false)
			vRPclient._DeletarObjeto(source)
			local especialidade = false
			if args[1] == "911" then
				players = vRP.getUsersByPermission("policia.permissao")
				especialidade = "policiais"
			elseif args[1] == "190" then
				players = vRP.getUsersByPermission("policia.permissao")
				especialidade = "policiais"
			elseif args[1] == "112" then
				players = vRP.getUsersByPermission("paramedico.permissao")
				especialidade = "paramédicos"
			elseif args[1] == "192" then
				players = vRP.getUsersByPermission("paramedico.permissao")
				especialidade = "paramédicos"
			elseif args[1] == "mec" then
				players = vRP.getUsersByPermission("mecanico.permissao")
				especialidade = "mecânicos"
			elseif args[1] == "taxi" then
				players = vRP.getUsersByPermission("taxista.permissao")
				especialidade = "taxistas"
			elseif args[1] == "adm" then
				players = vRP.getUsersByPermission("suporte.permissao")	
				especialidade = "Administradores"
			end
			local adm = ""
			if especialidade == "Administradores" then
				adm = "[^8ADMINISTRAÇÃO^0] "
			elseif especialidade == "taxistas" then
				adm = "[^3TAXI^0] "
			elseif especialidade == "policiais" then
				adm = "[^5POLICIA^0] "
			elseif especialidade == "Advogados" then
				adm = "[^6ADVOGADOS^0] "
			elseif especialidade == "paramédicos" then
				adm = "[^3EMS^0] "
			elseif especialidade == "mecânicos" then
				adm = "[^3MECANICO^0] "
			end
			
			vRPclient.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
			if #players == 0  and especialidade ~= "policiais" then
				TriggerClientEvent("Notify",source,"importante","Não há "..especialidade.." em serviço.")
			else
				local identitys = vRP.getUserIdentity(user_id)
				TriggerClientEvent("Notify",source,"sucesso","Chamado enviado com sucesso.")
				aceitopor = nil
				for l,w in pairs(players) do
					local player = vRP.getUserSource(parseInt(w))
					local nuser_id = vRP.getUserId(player)
					if player and player ~= uplayer then
						async(function()
							vRPclient.playSound(player,"Out_Of_Area","DLC_Lowrider_Relay_Race_Sounds")
							TriggerClientEvent('chatMessage',player,"CHAMADO",{19,197,43},adm.."Enviado por ^1"..identitys.name.." "..identitys.firstname.."^0 ["..user_id.."], "..descricao)
							local ok = vRP.request(player,"Aceitar o chamado de <b>"..identitys.name.." "..identitys.firstname.."</b>?",120)
							if ok then
								if not answered then
									answered = true
									local identity = vRP.getUserIdentity(nuser_id)
									aceitopor = nuser_id
									TriggerClientEvent("Notify",source,"importante","Chamado atendido por <b>"..identity.name.." "..identity.firstname.."</b>, aguarde no local.")
									TriggerClientEvent("Notify",player,"sucesso","CHAMADO","Chamado atendido, vá até o local.")
									vRPclient.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
									vRPclient.playSound(player,"Event_Message_Purple","GTAO_FM_Events_Soundset")
									vRPclient._setGPS(player,x,y)
									if especialidade == "Administradores" then
									SendWebhookMessage(webhookcalladm,"```prolog\n[PASSAPORTE]: "..nuser_id.." \n[ATENDEU]: "..descricao.." \n[DE]:"..user_id.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
									vRPclient.teleport(player,vRPclient.getPosition(source))
									end
								else
									TriggerClientEvent("Notify",player,"importante","Chamado ja foi atendido por outra pessoa.")
									vRPclient.playSound(player,"CHECKPOINT_MISSED","HUD_MINI_GAME_SOUNDSET")
									local identity = vRP.getUserIdentity(aceitopor)
									TriggerClientEvent('chatMessage',player,"CHAMADO JÁ ACEITO POR",{19,197,43}," "..identity.name.." "..identity.firstname.." ID: ["..aceitopor.."]")
								end
							end
							local id = idgens:gen()
							blips[id] = vRPclient.addBlip(player,x,y,z,358,71,"Chamado",0.6,false)
							SetTimeout(300000,function() vRPclient.removeBlip(player,blips[id]) idgens:free(id) end)
						end)
					end
				end
			end
		end
	else
		TriggerClientEvent("Notify",source,"negado","Voce precisa esperar "..timechamar[user_id].." segundos pra usar novamente!")
	end
end)
Citizen.CreateThread(function()
	while true do
		Wait(1000)
		for k,v in pairs(timechamar) do
			if timechamar[k] > 0 then
				timechamar[k] = timechamar[k] - 1
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MEC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('mec',function(source,args,rawCommand)
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if vRP.hasPermission(user_id,"mecanico.permissao") then
			if user_id then
				TriggerClientEvent('chatMessage',-1,"Central Mecânica",{255,128,0},rawCommand:sub(4))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('mr',function(source,args,rawCommand)
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		local permission = "mecanico.permissao"
		if vRP.hasPermission(user_id,permission) then
			local mec = vRP.getUsersByPermission(permission)
			for l,w in pairs(mec) do
				local player = vRP.getUserSource(parseInt(w))
				if player then
					async(function()
						TriggerClientEvent('chatMessage',player,identity.name.." "..identity.firstname,{255,191,128},rawCommand:sub(3))
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /radio
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('radio',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.getInventoryItemAmount(user_id,"radio",1) then
		TriggerClientEvent("vrp_radio:toggleNui",source,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CARTAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('card',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		local cd = math.random(1,13)
		local naipe = math.random(1,4)
		TriggerClientEvent('CartasMe',-1,source,identity.name,cd,naipe)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ME
-----------------------------------------------------------------------------------------------------------------------------------------
--[[RegisterServerEvent('ChatMe')
AddEventHandler('ChatMe',function(text)
	local user_id = vRP.getUserId(source)
	if user_id then
		TriggerClientEvent('DisplayMe',-1,text,source)
	end
end)--]]
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROLL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('ChatRoll')
AddEventHandler('ChatRoll',function(text)
	local user_id = vRP.getUserId(source)
	if user_id then
		TriggerClientEvent('DisplayRoll',-1,text,source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /card
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('card',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		local cd = math.random(1,13)
		local naipe = math.random(1,4)
		TriggerClientEvent('CartasMe',-1,source,identity.name,cd,naipe)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /mascara
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('mascara',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setmascara",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /blusa
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('blusa',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setblusa",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /colete
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('colete',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setcolete",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /jaqueta
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('jaqueta',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setjaqueta",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /maos
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('maos',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setmaos",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /calca
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('calca',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setcalca",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /acessorios
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('acessorios',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setacessorios",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /sapatos
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('sapatos',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setsapatos",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /chapeu
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('chapeu',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setchapeu",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /oculos
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('oculos',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if user_id then
					TriggerClientEvent("setoculos",source,args[1],args[2])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROUPAS
-----------------------------------------------------------------------------------------------------------------------------------------
local roupas = {
    ["mecanico"] = {
		[1885233650] = {                                      
			[1] = { -1,0 },
			[3] = { 12,0 },
			[4] = { 39,0 },
			[5] = { -1,0 },
			[6] = { 24,0 },
			[7] = { 109,0 },
			[8] = { 89,0 },
			[9] = { 14,0 },
			[10] = { -1,0 },
			[11] = { 66,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[3] = { 14,0 },
			[4] = { 38,0 },
			[5] = { -1,0 },
			[6] = { 24,0 },
			[7] = { 2,0 },
			[8] = { 56,0 },
			[9] = { 35,0 },
			[10] = { -1,0 },
			[11] = { 59,0 }
		}
	},
	["minerador"] = {
		[1885233650] = {                                      
			[1] = { -1,0 },
			[3] = { 99,1 },
			[4] = { 89,20 },
			[5] = { -1,0 },
			[6] = { 82,2 },
			[7] = { -1,0 },
			[8] = { 90,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 273,0 },
			["p1"] = { 23,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[3] = { 114,1 },
			[4] = { 92,20 },
			[5] = { -1,0 },
			[6] = { 86,2 },
			[7] = { -1,0 },
			[8] = { 54,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 286,0 },
			["p1"] = { 25,0 }
		}
	},
    ["lixeiro"] = {
		[1885233650] = {                                      
			[1] = { -1,0 },
			[3] = { 17,0 },
			[4] = { 36,0 },
			[5] = { -1,0 },
			[6] = { 27,0 },
			[7] = { -1,0 },
			[8] = { 59,0 },
			[10] = { -1,0 },
			[11] = { 57,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[3] = { 18,0 },
			[4] = { 35,0 },
			[5] = { -1,0 },
			[6] = { 26,0 },
			[7] = { -1,0 },
			[8] = { 36,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 50,0 }
		}
	},
	["carteiro"] = {
		[1885233650] = {                                      
			[1] = { -1,0 },
			[3] = { 0,0 },
			[4] = { 17,10 },
			[5] = { 40,0 },
			[6] = { 7,0 },
			[7] = { -1,0 },
			[8] = { 15,0 },
			[10] = { -1,0 },
			[11] = { 242,3 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[3] = { 14,0 },
			[4] = { 14,1 },
			[5] = { 40,0 },
			[6] = { 10,1 },
			[7] = { -1,0 },
			[8] = { 6,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 250,3 }
		}
	},
	["fazendeiro"] = {
		[1885233650] = {                                      
			[1] = { -1,0 },
			[3] = { 37,0 },
			[4] = { 7,0 },
			[5] = { -1,0 },
			[6] = { 15,6 },
			[7] = { -1,0 },
			[8] = { 15,0 },
			[10] = { -1,0 },
			[11] = { 95,2 },
			["p0"] = { 105,23 },
			["p1"] = { 5,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[3] = { 45,0 },
			[4] = { 25,10 },
			[5] = { -1,0 },
			[6] = { 21,1 },
			[7] = { -1,0 },
			[8] = { 6,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 171,4 },
			["p0"] = { 104,23 },
			["p1"] = { 11,2 }
		}
	},
	["lenhador"] = {
		[1885233650] = {                                      
			[1] = { -1,0 },
			[3] = { 62,0 },
			[4] = { 89,23 },
			[5] = { -1,0 },
			[6] = { 12,0 },
			[7] = { -1,0 },
			[8] = { 15,0 },
			[10] = { -1,0 },
			[11] = { 15,0 },
			["p0"] = { 77,13 },
			["p1"] = { 23,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[3] = { 71,0 },
			[4] = { 92,23 },
			[5] = { -1,0 },
			[6] = { 69,0 },
			[7] = { -1,0 },
			[8] = { 6,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 15,0 },
			["p1"] = { 25,0 }
		}
	},
	["taxista"] = {
		[1885233650] = {                                      
			[1] = { -1,0 },
			[3] = { 11,0 },
			[4] = { 35,0 },
			[5] = { -1,0 },
			[6] = { 10,0 },
			[7] = { -1,0 },
			[8] = { 15,0 },
			[10] = { -1,0 },
			[11] = { 13,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[3] = { 0,0 },
			[4] = { 112,0 },
			[5] = { -1,0 },
			[6] = { 6,0 },
			[7] = { -1,0 },
			[8] = { 6,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 27,0 }
		}
	},
	["caminhoneiro"] = {
		[1885233650] = {                                      
			[1] = { -1,0 },
			[3] = { 0,0 },
			[4] = { 63,0 },
			[5] = { -1,0 },
			[6] = { 27,0 },
			[7] = { -1,0 },
			[8] = { 81,0 },
			[10] = { -1,0 },
			[11] = { 173,3 },
			["p1"] = { 8,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[3] = { 14,0 },
			[4] = { 74,5 },
			[5] = { -1,0 },
			[6] = { 9,0 },
			[7] = { -1,0 },
			[8] = { 92,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 175,3 },
			["p1"] = { 11,0 }
		}
	},
	["motocross"] = {
		[1885233650] = {                                      
			[1] = { -1,0 },
			[3] = { 111,0 },
			[4] = { 67,3 },
			[5] = { -1,0 },
			[6] = { 47,3 },
			[7] = { -1,0 },
			[8] = { 15,0 },
			[10] = { -1,0 },
			[11] = { 152,0 },
			["p1"] = { 25,5 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[3] = { 128,0 },
			[4] = { 69,3 },
			[5] = { -1,0 },
			[6] = { 48,3 },
			[7] = { -1,0 },
			[8] = { 6,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 149,0 },
			["p1"] = { 27,5 }
		}
	},
	["mergulho"] = {
		[1885233650] = {
			[1] = { 122,0 },
			[3] = { 31,0 },
			[4] = { 94,0 },
			[5] = { -1,0 },
			[6] = { 67,0 },
			[7] = { -1,0 },
			[8] = { 123,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 243,0 },			
			["p0"] = { -1,0 },
			["p1"] = { 26,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		[-1667301416] = {
			[1] = { 122,0 },
			[3] = { 18,0 },
			[4] = { 97,0 },
			[5] = { -1,0 },
			[6] = { 70,0 },
			[7] = { -1,0 },
			[8] = { 153,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 251,0 },
			["p0"] = { -1,0 },
			["p1"] = { 28,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	},
	["pelado"] = {
		[1885233650] = {                                      
			[1] = { -1,0 },
			[3] = { 15,0 },
			[4] = { 21,0 },
			[5] = { -1,0 },
			[6] = { 34,0 },
			[7] = { -1,0 },
			[8] = { 15,0 },
			[10] = { -1,0 },
			[11] = { 15,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[3] = { 15,0 },
			[4] = { 21,0 },
			[5] = { -1,0 },
			[6] = { 35,0 },
			[7] = { -1,0 },
			[8] = { 6,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 82,0 }
		}
	},
	["paciente"] = {
		[1885233650] = {
			[1] = { -1,0 },
			[3] = { 15,0 },
			[4] = { 61,0 },
			[5] = { -1,0 },
			[6] = { 16,0 },
			[7] = { -1,0 },			
			[8] = { 15,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 104,0 },			
			["p0"] = { -1,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[3] = { 0,0 },
			[4] = { 57,0 },
			[5] = { -1,0 },
			[6] = { 16,0 },
			[7] = { -1,0 },		
			[8] = { 7,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 105,0 },
			["p0"] = { -1,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	},
	["gesso"] = {
		[1885233650] = {
			[1] = { -1,0 },
			[3] = { 1,0 },
			[4] = { 84,9 },
			[5] = { -1,0 },
			[6] = { 13,0 },
			[7] = { -1,0 },			
			[8] = { -1,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 186,9 },			
			["p0"] = { -1,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[3] = { 3,0 },
			[4] = { 86,9 },
			[5] = { -1,0 },
			[6] = { 12,0 },
			[7] = { -1,0 },		
			[8] = { -1,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 188,9 },
			["p0"] = { -1,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	},
	["leiteiro"] = {
		[1885233650] = {
			[1] = { -1,0 }, -- máscara
			[3] = { 74,0 }, -- maos
			[4] = { 89,22 }, -- calça
			[5] = { -1,0 }, -- mochila
			[6] = { 51,0 }, -- sapato
			[7] = { -1,0 }, -- acessorios		
			[8] = { -1,0 }, -- blusa
			[9] = { -1,0 }, -- colete
			[10] = { -1,0 }, -- adesivo
			[11] = { 271,0 }, -- jaqueta		
			["p0"] = { 105,22 }, -- chapeu
			["p1"] = { 23,0 }, -- oculos
		},
		[-1667301416] = {
			[1] = { -1,0 }, -- máscara
			[3] = { 85,0 }, -- maos
			[4] = { 92,22 }, -- calça
			[5] = { -1,0 }, -- mochila
			[6] = { 52,0 }, -- sapato
			[7] = { -1,0 },  -- acessorios		
			[8] = { -1,0 }, -- blusa
			[9] = { -1,0 }, -- colete
			[10] = { -1,0 }, -- adesivo
			[11] = { 141,0 }, -- jaqueta
			["p0"] = { -1,0 }, -- chapeu
			["p1"] = { 3,9 }, -- oculos
		}
	},
	["motorista"] = {
		[1885233650] = {
			[1] = { -1,0 }, -- máscara
			[3] = { 0,0 }, -- maos
			[4] = { 10,0 }, -- calça
			[5] = { -1,0 }, -- mochila
			[6] = { 21,0 }, -- sapato
			[7] = { -1,0 }, -- acessorios		
			[8] = { -1,0 }, -- blusa
			[9] = { -1,0 }, -- colete
			[10] = { -1,0 }, -- adesivo
			[11] = { 242,1 }, -- jaqueta		
			["p0"] = { -1,0 }, -- chapeu
			["p1"] = { 7,0 }, -- oculos
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 }, -- máscara
			[3] = { 14,0 }, -- maos
			[4] = { 37,0 }, -- calça
			[5] = { -1,0 }, -- mochila
			[6] = { 27,0 }, -- sapato
			[7] = { -1,0 },  -- acessorios		
			[8] = { -1,0 }, -- blusa
			[9] = { -1,0 }, -- colete
			[10] = { -1,0 }, -- adesivo
			[11] = { 250,1 }, -- jaqueta
			["p0"] = { -1,0 }, -- chapeu
			["p1"] = { -1,0 }, -- oculos
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	},
	["cacador"] = {
		[1885233650] = {
			[1] = { -1,0 }, -- máscara
			[3] = { 20,0 }, -- maos
			[4] = { 97,18 }, -- calça
			[5] = { -1,0 }, -- mochila
			[6] = { 24,0 }, -- sapato
			[7] = { -1,0 }, -- acessorios		
			[8] = { 2,2 }, -- blusa
			[9] = { -1,0 }, -- colete
			[10] = { -1,0 }, -- adesivo
			[11] = { 244,19 }, -- jaqueta		
			["p0"] = { -1,0 }, -- chapeu
			["p1"] = { 5,0 }, -- oculos
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 }, -- máscara
			[3] = { 20,0 }, -- maos
			[4] = { 100,18 }, -- calça
			[5] = { -1,0 }, -- mochila
			[6] = { 24,0 }, -- sapato
			[7] = { -1,0 },  -- acessorios		
			[8] = { 44,1 }, -- blusa
			[9] = { -1,0 }, -- colete
			[10] = { -1,0 }, -- adesivo
			[11] = { 252,19 }, -- jaqueta
			["p0"] = { -1,0 }, -- chapeu
			["p1"] = { -1,0 }, -- oculos
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	},
	["pescador"] = {
		[1885233650] = {
			[1] = { -1,0 }, -- máscara
			[3] = { 0,0 }, -- maos
			[4] = { 98,19 }, -- calça
			[5] = { -1,0 }, -- mochila
			[6] = { 24,0 }, -- sapato
			[7] = { -1,0 }, -- acessorios		
			[8] = { 85,2 }, -- blusa
			[9] = { -1,0 }, -- colete
			[10] = { -1,0 }, -- adesivo
			[11] = { 247,12 }, -- jaqueta		
			["p0"] = { 104,20 }, -- chapeu
			["p1"] = { 5,0 }, -- oculos
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 }, -- máscara
			[3] = { 14,0 }, -- maos
			[4] = { 101,19 }, -- calça
			[5] = { -1,0 }, -- mochila
			[6] = { 24,0 }, -- sapato
			[7] = { -1,0 },  -- acessorios		
			[8] = { 88,1 }, -- blusa
			[9] = { -1,0 }, -- colete
			[10] = { -1,0 }, -- adesivo
			[11] = { 255,13 }, -- jaqueta
			["p0"] = { -1,0 }, -- chapeu
			["p1"] = { 11,0 }, -- oculos
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	}
}
function src.checarPermissao()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if  vRP.hasPermission(user_id,"attachs.permissao") or vRP.hasPermission(user_id,"policia.permissao") then
			return true 
		else
			return false
		end
	end
end

RegisterCommand('roupas',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if not vRP.searchReturn(source,user_id) then
				if args[1] then
					local custom = roupas[tostring(args[1])]
					if custom then
						local old_custom = vRPclient.getCustomization(source)
						local idle_copy = {}

						idle_copy = vRP.save_idle_custom(source,old_custom)
						idle_copy.modelhash = nil

						for l,w in pairs(custom[old_custom.modelhash]) do
							idle_copy[l] = w
						end
						vRPclient._playAnim(source,true,{{"clothingshirt","try_shirt_positive_d"}},false)
						Citizen.Wait(2500)
						vRPclient._stopAnim(source,true)
						vRPclient._setCustomization(source,idle_copy)
					end
				else
					vRPclient._playAnim(source,true,{{"clothingshirt","try_shirt_positive_d"}},false)
					Citizen.Wait(2500)
					vRPclient._stopAnim(source,true)
					vRP.removeCloak(source)
				end
			end
		end
	end
end)

RegisterCommand('roupas2',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) > 101 then
		if not vRPclient.isHandcuffed(source) then
			if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"paramedico.permissao") then
				local nplayer = vRPclient.getNearestPlayer(source,2)
				if not vRP.searchReturn(nplayer,user_id) then
					if nplayer then
						if args[1] then
							local custom = roupas[tostring(args[1])]
							if custom then
								local old_custom = vRPclient.getCustomization(nplayer)
								local idle_copy = {}

								idle_copy = vRP.save_idle_custom(nplayer,old_custom)
								idle_copy.modelhash = nil

								for l,w in pairs(custom[old_custom.modelhash]) do
									idle_copy[l] = w
								end
								vRPclient._setCustomization(nplayer,idle_copy)
							end
						else
							vRP.removeCloak(nplayer)
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATUS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('status',function(source,args,rawCommand)
    local onlinePlayers = GetNumPlayerIndices()
    local policia = vRP.getUsersByPermission("policia.permissao")
    local paramedico = vRP.getUsersByPermission("paramedico.permissao")
    local staff = vRP.getUsersByPermission("suporte.permissao")
    local mecanico = vRP.getUsersByPermission("mecanico.permissao")
    local ilegal = vRP.getUsersByPermission("ilegal.permissao")
    local user_id = vRP.getUserId(source)
    --if vRP.hasPermission(user_id,"suporte.permissao") then
        TriggerClientEvent("Notify",source,"importante","<bold><b>Jogadores</b>: <b>"..onlinePlayers..
        "<br>Administração</b>: <b>"..#staff..
        "<br>Policiais</b>: <b>"..#policia..
        "<br>Paramédicos</b>: <b>"..#paramedico..
        "<br>Mecanicos</b>: <b>"..#mecanico..
        "<br>Ilegal</b>: <b>"..#ilegal..
        "</b></bold>") 
    --end
end)
--------------------------------------------------------------------------------------------------
-------------------------- /cavalinho ------------------------------------------------------------
--------------------------------------------------------------------------------------------------
RegisterServerEvent('cmg2_animations:sync')
AddEventHandler('cmg2_animations:sync', function(target, animationLib, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
	print("got to srv cmg2_animations:sync")
	TriggerClientEvent('cmg2_animations:syncTarget', targetSrc, source, animationLib, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
	print("triggering to target: " .. tostring(targetSrc))
	TriggerClientEvent('cmg2_animations:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('cmg2_animations:stop')
AddEventHandler('cmg2_animations:stop', function(targetSrc)
	TriggerClientEvent('cmg2_animations:cl_stop', targetSrc)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Carregar
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('cmg2_animations:sync')
AddEventHandler('cmg2_animations:sync', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
	print("got to srv cmg2_animations:sync")
	TriggerClientEvent('cmg2_animations:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
	print("triggering to target: " .. tostring(targetSrc))
	TriggerClientEvent('cmg2_animations:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('cmg2_animations:stop')
AddEventHandler('cmg2_animations:stop', function(targetSrc)
	TriggerClientEvent('cmg2_animations:cl_stop', targetSrc)
end)
----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÃO
----------------------------------------------------------------------------------------------------------------------------------------
local cooldown = 0
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if cooldown > 0 then
			cooldown = cooldown - 1
		end
	end
end)
--- kickar player com ping alto
RegisterServerEvent("kickPing")
AddEventHandler("kickPing",function()
    local source = source
    local user_id = vRP.getUserId(source)
    ping = GetPlayerPing(source)
    if ping >= 200 then
        DropPlayer(source,"Voce foi kickado por estar com ping alto(Limite: 200ms. Seu Ping: "..ping.."ms)")
    end
end)
----------------------------------------------------------------------------------------------------------------------------------------
-- /COBRAR
----------------------------------------------------------------------------------------------------------------------------------------
--[[local webhookpaypal = ""

RegisterCommand('cobrar',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local consulta = vRPclient.getNearestPlayer(source,2)
	local nuser_id = vRP.getUserId(consulta)
	local resultado = json.decode(consulta) or 0
	local banco = vRP.getBankMoney(nuser_id)
	local identity =  vRP.getUserIdentity(user_id)
	local identityu = vRP.getUserIdentity(nuser_id)
	if cooldown < 1 then
		cooldown = 20
		if vRP.getInventoryItemAmount(user_id,"maquineta") >= 1 then
			if vRP.getInventoryItemAmount(nuser_id,"cartao") >= 1 then
				if vRP.request(consulta,"Deseja pagar <b>R$"..vRP.format(parseInt(args[1])).."</b> reais para <b>"..identity.name.." "..identity.firstname.."</b>?",15) then	
					if banco >= parseInt(args[1]) then
						vRP.setBankMoney(nuser_id,parseInt(banco-args[1]))
						vRP.giveBankMoney(user_id,parseInt(args[1]))
						TriggerClientEvent("Notify",source,"sucesso","Recebeu <b>R$"..vRP.format(parseInt(args[1])).." reais</b> de <b>"..identityu.name.. " "..identityu.firstname.."</b>.")
						SendWebhookMessage(webhookpaypal,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COBROU]: R$"..vRP.format(parseInt(args[1])).." \n[DO ID]: "..parseInt(nuser_id).." "..identityu.name.." "..identityu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						local player = vRP.getUserSource(parseInt(args[2]))
						if player == nil then
							return
						else
							local identity = vRP.getUserIdentity(user_id)
							TriggerClientEvent("Notify",player,"importante","<b>"..identity.name.." "..identity.firstname.."</b> transferiu <b>R$"..vRP.format(parseInt(args[1])).." Reais</b> para sua conta.")
						end
					else
						TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
					end
				else
					TriggerClientEvent("Notify",source,"negado","A pessoa negou.")	
				end
			else
				TriggerClientEvent("Notify",source,"negado","A pessoa não possui cartão.")
			end
		else
			TriggerClientEvent("Notify",source,"negado","Não possui maquineta.")
		end
	else
		TriggerClientEvent("Notify",source,"negado","Espere 20 segundos até que a maquininha se conectar novamente.")
	end
end)--]]

RegisterCommand('limparinv',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local player = vRP.getUserSource(user_id)
    if vRP.hasPermission(user_id,"admin.permissao") then
        local tuser_id = tonumber(args[1])
        local tplayer = vRP.getUserSource(tonumber(tuser_id))
        local tplayerID = vRP.getUserId (tonumber(tplayer))
            if tplayerID ~= nil then
            local identity = vRP.getUserIdentity(user_id)
            	vRP.clearInventory(tuser_id)
                TriggerClientEvent("Notify",source,"sucesso","Limpou inventario do <id>"..args[1].."</b>.")
            else
                TriggerClientEvent("Notify",source,"negado","O usuário não foi encontrado ou está offline.")
        end
    end
end)

RegisterCommand('gcolete',function(source,args,rawCommand)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local ssssd = vRP.prompt(source, "Deseja guardar o seu colete ? (Sim ou Não)","Sim")     
        local tempog = math.random(5000,10000)
		local colete = vRPclient.getArmour(source)
        if string.upper(ssssd) == "SIM" then
			if colete <= 10 then
				return  TriggerClientEvent("Notify", source, 'negado', 'Não foi possível guardar o colete.')
			else
				TriggerClientEvent("progress",source,tempog,"guardando")
				vRPclient._playAnim(source, true,{{"clothingshirt","try_shirt_positive_d"}},false)
				SetTimeout(tempog, function()
					if colete == 100 then
						vRPclient.setArmour(source,0)
						vRP.giveInventoryItem(user_id,"colete", 1)
					elseif colete <= 99 and colete >= 49 then
						vRPclient.setArmour(source,0)
						vRP.giveInventoryItem(user_id,"colete2", 1)
					elseif colete <= 49 and colete >= 10 then
						vRPclient.setArmour(source,0)
						vRP.giveInventoryItem(user_id,"colete3", 1)		
					end
					TriggerClientEvent('Notify', source, 'sucesso', 'Colete guardado na mochila')
					TriggerClientEvent('Creative:Update',source,'updateMochila')
				end)
			end	
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMS
----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('adms', function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	local oficiais = vRP.getUsersByPermission("comum.permissao")
	local paramedicos = 0
	local oficiais_nomes = ""
	if vRP.hasPermission(user_id,"suporte.permissao") then
		for k,v in ipairs(oficiais) do
			local identity = vRP.getUserIdentity(parseInt(v))
			oficiais_nomes = oficiais_nomes .. "<b>" .. v .. "</b>: " .. identity.name .. " " .. identity.firstname .. "<br>"
			paramedicos = paramedicos + 1
		end
		TriggerClientEvent("Notify",source,"importante", "Atualmente <b>"..paramedicos.." Administradores</b> em serviço.")
		if parseInt(paramedicos) > 0 then
			TriggerClientEvent("Notify",source,"importante", oficiais_nomes)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /me
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('ChatMe')
AddEventHandler('ChatMe',function(text)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if user_id then
		local players = vRPclient.getNearestPlayers(source,10)
		TriggerClientEvent('DisplayMe',source,text,source)
		for k,v in pairs(players) do
			TriggerClientEvent('DisplayMe',k,text,source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VER DIAMANTE
----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('verdiamante', function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	local oficiais = vRP.getUsersByPermission("diamante.permissao")
	local paramedicos = 0
	local oficiais_nomes = ""
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
		for k,v in ipairs(oficiais) do
			local identity = vRP.getUserIdentity(parseInt(v))
			oficiais_nomes = oficiais_nomes .. "<b>" .. v .. "</b>: " .. identity.name .. " " .. identity.firstname .. "<br>"
			paramedicos = paramedicos + 1
		end
		TriggerClientEvent("Notify",source,"importante", "Atualmente <b>"..paramedicos.." Daiamante</b> online.")
		if parseInt(paramedicos) > 0 then
			TriggerClientEvent("Notify",source,"importante", oficiais_nomes)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- VER PLATINA
----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('verplatina', function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	local oficiais = vRP.getUsersByPermission("platina.permissao")
	local paramedicos = 0
	local oficiais_nomes = ""
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
		for k,v in ipairs(oficiais) do
			local identity = vRP.getUserIdentity(parseInt(v))
			oficiais_nomes = oficiais_nomes .. "<b>" .. v .. "</b>: " .. identity.name .. " " .. identity.firstname .. "<br>"
			paramedicos = paramedicos + 1
		end
		TriggerClientEvent("Notify",source,"importante", "Atualmente <b>"..paramedicos.." Platina</b> online.")
		if parseInt(paramedicos) > 0 then
			TriggerClientEvent("Notify",source,"importante", oficiais_nomes)
		end
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- VER Ouro
----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('verouro', function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	local oficiais = vRP.getUsersByPermission("ouro.permissao")
	local paramedicos = 0
	local oficiais_nomes = ""
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
		for k,v in ipairs(oficiais) do
			local identity = vRP.getUserIdentity(parseInt(v))
			oficiais_nomes = oficiais_nomes .. "<b>" .. v .. "</b>: " .. identity.name .. " " .. identity.firstname .. "<br>"
			paramedicos = paramedicos + 1
		end
		TriggerClientEvent("Notify",source,"importante", "Atualmente <b>"..paramedicos.." Ouro</b> online.")
		if parseInt(paramedicos) > 0 then
			TriggerClientEvent("Notify",source,"importante", oficiais_nomes)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- VER Prata
----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('verprata', function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	local oficiais = vRP.getUsersByPermission("prata.permissao")
	local paramedicos = 0
	local oficiais_nomes = ""
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
		for k,v in ipairs(oficiais) do
			local identity = vRP.getUserIdentity(parseInt(v))
			oficiais_nomes = oficiais_nomes .. "<b>" .. v .. "</b>: " .. identity.name .. " " .. identity.firstname .. "<br>"
			paramedicos = paramedicos + 1
		end
		TriggerClientEvent("Notify",source,"importante", "Atualmente <b>"..paramedicos.." Prata</b> online.")
		if parseInt(paramedicos) > 0 then
			TriggerClientEvent("Notify",source,"importante", oficiais_nomes)
		end
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- VER Bronze
----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('verbronze', function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	local oficiais = vRP.getUsersByPermission("bronze.permissao")
	local paramedicos = 0
	local oficiais_nomes = ""
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
		for k,v in ipairs(oficiais) do
			local identity = vRP.getUserIdentity(parseInt(v))
			oficiais_nomes = oficiais_nomes .. "<b>" .. v .. "</b>: " .. identity.name .. " " .. identity.firstname .. "<br>"
			paramedicos = paramedicos + 1
		end
		TriggerClientEvent("Notify",source,"importante", "Atualmente <b>"..paramedicos.." Bronze</b> online.")
		if parseInt(paramedicos) > 0 then
			TriggerClientEvent("Notify",source,"importante", oficiais_nomes)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- /use
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('use',function(source,args,rawCommand)
    if args[1] == nil then
        return
    end
    local user_id = vRP.getUserId(source)
        if args[1] == "energetico" then
        if vRP.tryGetInventoryItem(user_id,"energetico",1) then
            TriggerClientEvent('cancelando',source,true)
            vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_energy_drink",49,28422)
            TriggerClientEvent("progress",source,10000,"bebendo")
            SetTimeout(10000,function()
                TriggerClientEvent('energeticos',source,true)
                TriggerClientEvent('cancelando',source,false)
                vRPclient._DeletarObjeto(source)
                TriggerClientEvent("Notify",source,"sucesso","Sucesso","Energético utilizado com sucesso.")
            end)
            SetTimeout(60000,function()
                TriggerClientEvent('energeticos',source,false)
                TriggerClientEvent("Notify",source,"aviso","Aviso","O efeito do energético passou e o coração voltou a bater normalmente.")
            end)
        else
            TriggerClientEvent("Notify",source,"negado","Negado","Energético não encontrado na mochila.")
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNKIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("trunkin",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRPclient.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) then
            TriggerClientEvent("vrp_player:EnterTrunk",source)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /mochila
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('mochila',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRPclient.getHealth(source) > 101 then
        if not vRPclient.isHandcuffed(source) then
            if not vRP.searchReturn(source,user_id) then
                if user_id then
                    TriggerClientEvent("setmochila",source,args[1],args[2])
                end
            end
        end
    end
end)

---- rgbcar ----

RegisterCommand('rgbcar',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"speed.permissao") then
        TriggerClientEvent('rgbcar',source)
        TriggerClientEvent("Notify",source,"sucesso","Você tunou o <b>veículo</b> RGB com sucesso.")
    end
end)

--- SETAR MEMBROS FACS E ORGS ----
RegisterCommand('addvermelho',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"lidervermelhos.permissao") then
		if args[1] then
			vRP.addUserGroup(nplayer,"Vermelhos")
		end
	end
end)

RegisterCommand('removervermelho',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"lidervermelhos.permissao") then
		if args[1] then
			vRP.removeUserGroup(nplayer,"Vermelhos")
		end
	end
end)
----------------------------------------------------------------
RegisterCommand('addverde',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"liderverdes.permissao") then
		if args[1] then
			vRP.addUserGroup(nplayer,"Verdes")
		end
	end
end)

RegisterCommand('remoververde',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"liderverdes.permissao") then
		if args[1] then
			vRP.removeUserGroup(nplayer,"Verdes")
		end
	end
end)
-----------------------------------------------------------
RegisterCommand('addazul',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"liderazul.permissao") then
		if args[1] then
			vRP.addUserGroup(nplayer,"Azul")
		end
	end
end)

RegisterCommand('removerazul',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"liderazul.permissao") then
		if args[1] then
			vRP.removeUserGroup(nplayer,"Azul")
		end
	end
end)
-------------------------------------------------------------
RegisterCommand('addamarelo',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"lideramarelo.permissao") then
		if args[1] then
			vRP.addUserGroup(nplayer,"Amarelos")
		end
	end
end)
RegisterCommand('removeramarelo',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"lideramarelo.permissao") then
		if args[1] then
			vRP.removeUserGroup(nplayer,"Amarelos")
		end
	end
end)
---------------------------------------------------------------
RegisterCommand('addbranco',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"liderbrancos.permissao") then
		if args[1] then
			vRP.addUserGroup(nplayer,"Brancos")
		end
	end
end)
RegisterCommand('removerbranco',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"liderbrancos.permissao") then
		if args[1] then
			vRP.removeUserGroup(nplayer,"Brancos")
		end
	end
end)
-------------------------------------------------------------------
RegisterCommand('addmafia',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"lidermafia.permissao") then
		if args[1] then
			vRP.addUserGroup(nplayer,"Mafia")
		end
	end
end)
RegisterCommand('removermafia',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"lidermafia.permissao") then
		if args[1] then
			vRP.removeUserGroup(nplayer,"Mafia")
		end
	end
end)
----------------------------------------------------------------
RegisterCommand('addyakuza',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"lideryakuza.permissao") then
		if args[1] then
			vRP.addUserGroup(nplayer,"Yakuza")
		end
	end
end)
RegisterCommand('removeryakuza',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"lideryakuza.permissao") then
		if args[1] then
			vRP.removeUserGroup(nplayer,"Yakuza")
		end
	end
end)
---------------------------------------------------------------
RegisterCommand('addmotoclub',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"lidermotoclub.permissao") then
		if args[1] then
			vRP.addUserGroup(nplayer,"Motoclub")
		end
	end
end)
RegisterCommand('removermotoclub',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"lidermotoclub.permissao") then
		if args[1] then
			vRP.removeUserGroup(nplayer,"Motoclub")
		end
	end
end)
----------------------------------------------------------------
RegisterCommand('addmercenario',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"lidermercenarios.permissao") then
		if args[1] then
			vRP.addUserGroup(nplayer,"Mercenarios")
		end
	end
end)
RegisterCommand('removermercenario',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"lidermercenarios.permissao") then
		if args[1] then
			vRP.removeUserGroup(nplayer,"Mercenarios")
		end
	end
end)
------------------------------------------------------------------
RegisterCommand('addvanilla',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"lidervanilla.permissao") then
		if args[1] then
			vRP.addUserGroup(nplayer,"Vanilla")
		end
	end
end)
RegisterCommand('removervanilla',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"lidervanilla.permissao") then
		if args[1] then
			vRP.removeUserGroup(nplayer,"Vanilla")
		end
	end
end)
-------------------------------------------------------------------
RegisterCommand('addbahamas',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"liderbahamas.permissao") then
		if args[1] then
			vRP.addUserGroup(nplayer,"Bahamas")
		end
	end
end)
RegisterCommand('removerbahamas',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"liderbahamas.permissao") then
		if args[1] then
			vRP.removeUserGroup(nplayer,"Bahamas")
		end
	end
end)
-------------------------------------------------------------------
RegisterCommand('addgalaxy',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"lidergalaxy.permissao") then
		if args[1] then
			vRP.addUserGroup(nplayer,"Galaxy")
		end
	end
end)
RegisterCommand('removergalaxy',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"lidergalaxy.permissao") then
		if args[1] then
			vRP.removeUserGroup(nplayer,"Galaxy")
		end
	end
end)
--------------------------------------------------------------------
RegisterCommand('addspeed',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"liderspeed.permissao") then
		if args[1] then
			vRP.addUserGroup(nplayer,"Speed")
		end
	end
end)
RegisterCommand('removerspeed',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"liderspeed.permissao") then
		if args[1] then
			vRP.removeUserGroup(nplayer,"Paisanaspeed")
		end
	end
end)
--------------------------------------------------------------------
RegisterCommand('addcivil',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"lidercivil.permissao") then
		if args[1] then
			vRP.addUserGroup(nplayer,"PolicialCivil")
		end
	end
end)
RegisterCommand('removercivil',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"lidercivil.permissao") then
		if args[1] then
			vRP.removeUserGroup(nplayer,"PolicialCivil") 
		end
	end
end)
-------------------------------------------------------------------
RegisterCommand('addrota',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"liderbope.permissao") then
		if args[1] then
			vRP.addUserGroup(nplayer,"ROTA")
		end
	end
end)
RegisterCommand('removerrota',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"liderbope.permissao") then
		if args[1] then
			vRP.removeUserGroup(nplayer,"ROTA") 
		end
	end
end)
------------------------------------------------------------------
RegisterCommand('addsoldado',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"liderpolicia.permissao") then
		if args[1] then
			vRP.addUserGroup(nplayer,"Soldado")
		end
	end
end)
RegisterCommand('removersoldado',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"liderpolicia.permissao") then
		if args[1] then
			vRP.removeUserGroup(nplayer,"Soldado") 
		end
	end
end)
------------------------------------------------------------------
RegisterCommand('addmed',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"diretor.servico") then
		if args[1] then
			vRP.addUserGroup(nplayer,"Medico")
		end
	end
end)
RegisterCommand('removermed',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"diretor.servico") then
		if args[1] then
			vRP.removeUserGroup(nplayer,"Medico") 
		end
	end
end)
------------------------------------------------------------------
------------------------------------------------------------------
RegisterCommand('addenfermeiro',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"diretor.servico") then
		if args[1] then
			vRP.addUserGroup(nplayer,"Enfermeiro")
		end
	end
end)
RegisterCommand('removerenfermeiro',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"diretor.servico") then
		if args[1] then
			vRP.removeUserGroup(nplayer,"Enfermeiro") 
		end
	end
end)
------------------------------------------------------------------
RegisterCommand('addparamedico',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"diretor.servico") then
		if args[1] then
			vRP.addUserGroup(nplayer,"Paramedico")
		end
	end
end)
RegisterCommand('removerparamedico',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"diretor.servico") then
		if args[1] then
			vRP.removeUserGroup(nplayer,"Paramedico") 
		end
	end
end)
------------------------------------------------------------------
RegisterCommand('addmec',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"mecanico-chefe.permissao") then
		if args[1] then
			vRP.addUserGroup(nplayer,"Mecanico") 
		end
	end
end)
RegisterCommand('removermec',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = parseInt(args[1])
	if vRP.hasPermission(user_id,"mecanico-chefe.permissao") then
		if args[1] then
			vRP.removeUserGroup(nplayer,"Mecanico") 
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ROUBAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('roubar',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,2)
	if nplayer then
		local nuser_id = vRP.getUserId(nplayer)
		local policia = vRP.getUsersByPermission("policia.permissao")
		if #policia >= 0 then
			if vRP.request(nplayer,"Você está sendo roubado, deseja passar tudo?",30) then
				local vida = vRPclient.getHealth(nplayer)
				if vida <= 100 then
					TriggerClientEvent('cancelando',source,true)
					vRPclient._playAnim(source,false,{{"amb@medic@standing@kneel@idle_a","idle_a"}},true)
					TriggerClientEvent("progress",source,30000,"roubando")
					SetTimeout(30000,function()
						local ndata = vRP.getUserDataTable(nuser_id)
						if ndata ~= nil then
							if ndata.inventory ~= nil then
								for k,v in pairs(ndata.inventory) do
									if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(k)*v.amount <= vRP.getInventoryMaxWeight(user_id) then
										if vRP.tryGetInventoryItem(nuser_id,k,v.amount) then
											vRP.giveInventoryItem(user_id,k,v.amount)
										end
									else
										TriggerClientEvent("Notify",source,"negado","Mochila não suporta <b>"..vRP.format(parseInt(v.amount)).."x "..itemlist[k].nome.."</b> por causa do peso.")
									end
								end
							end
						end
						local weapons = vRPclient.replaceWeapons(nplayer,{})
						for k,v in pairs(weapons) do
							vRP.giveInventoryItem(nuser_id,"wbody|"..k,1)
							if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("wbody|"..k) <= vRP.getInventoryMaxWeight(user_id) then
								if vRP.tryGetInventoryItem(nuser_id,"wbody|"..k,1) then
									vRP.giveInventoryItem(user_id,"wbody|"..k,1)
								end
							else
								TriggerClientEvent("Notify",source,"negado","Mochila não suporta <b>1x "..itemlist["wbody"..k].nome.."</b> por causa do peso.")
							end
							if v.ammo > 0 then
								vRP.giveInventoryItem(nuser_id,"wammo|"..k,v.ammo)
								if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("wammo|"..k)*v.ammo <= vRP.getInventoryMaxWeight(user_id) then
									if vRP.tryGetInventoryItem(nuser_id,"wammo|"..k,v.ammo) then
										vRP.giveInventoryItem(user_id,"wammo|"..k,v.ammo)
									end
								else
									TriggerClientEvent("Notify",source,"negado","Mochila não suporta <b>"..vRP.format(parseInt(v.ammo)).."x "..itemlist["wammo|"..k].nome.."</b> por causa do peso.")
								end
							end
						end
						local nmoney = vRP.getMoney(nuser_id)
						if vRP.tryPayment(nuser_id,nmoney) then
							vRP.giveMoney(user_id,nmoney)
						end
						vRPclient.setStandBY(source,parseInt(600))
						vRPclient._stopAnim(source,false)
						TriggerClientEvent('cancelando',source,false)
						TriggerClientEvent("Notify",source,"importante","Roubo concluido com sucesso.")
						TriggerEvent('logs:ToDiscord', discord_webhook1 , "ROUBO", "```Player "..user_id.." roubou o ID: "..nuser_id.."```", "https://www.tumarcafacil.com/wp-content/uploads/2017/06/RegistroDeMarca-01-1.png", false, false)
					end)
				else
					local ndata = vRP.getUserDataTable(nuser_id)
					if ndata ~= nil then
						if ndata.inventory ~= nil then
							for k,v in pairs(ndata.inventory) do
								if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(k)*v.amount <= vRP.getInventoryMaxWeight(user_id) then
									if vRP.tryGetInventoryItem(nuser_id,k,v.amount) then
										vRP.giveInventoryItem(user_id,k,v.amount)
									end
								else
									TriggerClientEvent("Notify",source,"negado","Mochila não suporta <b>"..vRP.format(parseInt(v.amount)).."x "..itemlist[k].nome.."</b> por causa do peso.")
								end
							end
						end
					end
					local weapons = vRPclient.replaceWeapons(nplayer,{})
					for k,v in pairs(weapons) do
						vRP.giveInventoryItem(nuser_id,"wbody|"..k,1)
						if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("wbody|"..k) <= vRP.getInventoryMaxWeight(user_id) then
							if vRP.tryGetInventoryItem(nuser_id,"wbody|"..k,1) then
								vRP.giveInventoryItem(user_id,"wbody|"..k,1)
							end
						else
							TriggerClientEvent("Notify",source,"negado","Mochila não suporta <b>1x "..itemlist["wbody|"..k].nome.."</b> por causa do peso.")
						end
						if v.ammo > 0 then
							vRP.giveInventoryItem(nuser_id,"wammo|"..k,v.ammo)
							if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("wammo|"..k)*v.ammo <= vRP.getInventoryMaxWeight(user_id) then
								if vRP.tryGetInventoryItem(nuser_id,"wammo|"..k,v.ammo) then
									vRP.giveInventoryItem(user_id,"wammo|"..k,v.ammo)
								end
							else
								TriggerClientEvent("Notify",source,"negado","Mochila não suporta <b>"..vRP.format(parseInt(v.ammo)).."x "..itemlist["wammo|"..k].nome.."</b> por causa do peso.")
							end
						end
					end
					local nmoney = vRP.getMoney(nuser_id)
					if vRP.tryPayment(nuser_id,nmoney) then
						vRP.giveMoney(user_id,nmoney)
					end
					vRPclient.setStandBY(source,parseInt(600))
					TriggerClientEvent("Notify",source,"importante","Roubo concluido com sucesso.")
					TriggerEvent('logs:ToDiscord', discord_webhook1 , "ROUBO", "```Player "..user_id.." roubou o ID: "..nuser_id.."```", "https://www.tumarcafacil.com/wp-content/uploads/2017/06/RegistroDeMarca-01-1.png", false, false)
				end
			else
				TriggerClientEvent("Notify",source,"aviso","A pessoa está resistindo ao roubo.")
			end
		else
			TriggerClientEvent("Notify",source,"negado","Número insuficiente de policiais no momento.")
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- Saquear
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('saquear',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,2)
	if nplayer then
		if vRPclient.isInComa(nplayer) then
			local identity_user = vRP.getUserIdentity(user_id)
			local nuser_id = vRP.getUserId(nplayer)
			local nidentity = vRP.getUserIdentity(nuser_id)
			local policia = vRP.getUsersByPermission("policia.permissao")
			local itens_saque = {}
			if #policia > 0 then
				TriggerClientEvent('cancelando',source,true)
				vRPclient._playAnim(source,false,{{"amb@medic@standing@kneel@idle_a","idle_a"}},true)
				TriggerClientEvent("progress",source,20000,"saqueando")
				SetTimeout(20000,function()
					local ndata = vRP.getUserDataTable(nuser_id)
					if ndata ~= nil then
						if ndata.inventory ~= nil then
							for k,v in pairs(ndata.inventory) do
								if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(k)*v.amount <= vRP.getInventoryMaxWeight(user_id) then
									if vRP.tryGetInventoryItem(nuser_id,k,v.amount) then
										vRP.giveInventoryItem(user_id,k,v.amount)
										table.insert(itens_saque, "[ITEM]: "..vRP.itemNameList(k).." [QUANTIDADE]: "..v.amount)
									end
								else
									TriggerClientEvent("Notify",source,"negado","Mochila não suporta <b>"..vRP.format(parseInt(v.amount)).."x "..vRP.itemNameList(k).."</b> por causa do peso.")
								end
							end
						end
					end
					local weapons = vRPclient.replaceWeapons(nplayer,{})
					for k,v in pairs(weapons) do
						vRP.giveInventoryItem(nuser_id,"wbody|"..k,1)
						if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("wbody|"..k) <= vRP.getInventoryMaxWeight(user_id) then
							if vRP.tryGetInventoryItem(nuser_id,"wbody|"..k,1) then
								vRP.giveInventoryItem(user_id,"wbody|"..k,1)
								table.insert(itens_saque, "[ITEM]: "..vRP.itemNameList("wbody|"..k).." [QUANTIDADE]: "..1)
							end
						else
							TriggerClientEvent("Notify",source,"negado","Mochila não suporta <b>1x "..vRP.itemNameList("wbody|"..k).."</b> por causa do peso.")
						end
						if v.ammo > 0 then
							vRP.giveInventoryItem(nuser_id,"wammo|"..k,v.ammo)
							if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("wammo|"..k)*v.ammo <= vRP.getInventoryMaxWeight(user_id) then
								if vRP.tryGetInventoryItem(nuser_id,"wammo|"..k,v.ammo) then
									vRP.giveInventoryItem(user_id,"wammo|"..k,v.ammo)
									table.insert(itens_saque, "[ITEM]: "..vRP.itemNameList("wammo|"..k).." [QTD]: "..v.ammo)
								end
							else
								TriggerClientEvent("Notify",source,"negado","Mochila não suporta <b>"..vRP.format(parseInt(v.ammo)).."x "..vRP.itemNameList("wammo|"..k).."</b> por causa do peso.")
							end
						end
					end
					local nmoney = vRP.getMoney(nuser_id)
					if vRP.tryPayment(nuser_id,nmoney) then
						vRP.giveMoney(user_id,nmoney)
					end
					vRPclient.setStandBY(source,parseInt(600))
					vRPclient._stopAnim(source,false)
					TriggerClientEvent('cancelando',source,false)
					local apreendidos = table.concat(itens_saque, "\n")
					TriggerClientEvent("Notify",source,"importante","Saque concluido com sucesso.")
					SendWebhookMessage(webhooksaquear,"```prolog\n[ID]: "..user_id.." "..identity_user.name.." "..identity_user.firstname.."\n[SAQUEOU]: "..nuser_id.." "..nidentity.name.." " ..nidentity.firstname .. "\n" .. apreendidos ..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				end)
			else
				TriggerClientEvent("Notify",source,"aviso","Número insuficiente de policiais no momento.")
			end
		else
			TriggerClientEvent("Notify",source,"negado","Você só pode saquear quem está em coma. Tente usar o /roubar")
		end
	end
end)

--- RESET
RegisterCommand('resetar',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,"admin.permissao") then
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
