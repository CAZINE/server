local cfg = module("cfg/inventory")

local itemlist = {
	["suspensaoar"] = { index = "suspensaoar", nome = "Kit Suspensão Ar", type = "usar" },
	["moduloneon"] = { index = "moduloneon", nome = "Kit MÓdulo Neon", type = "usar" },
	["moduloxenon"] = { index = "moduloxenon", nome = "Kit MÓdulo Xenon", type = "usar" },
	["laranja"] = { index = "laranja", nome = "Laranja", type = "usar" },	
	["tablet"] = { index = "tablet", nome = "Tablet", type = "usar" },				
	["nitro"] = { index = "nitro", nome = "Óxido Nitroso", type = "usar" },
	["agua"] = { index = "agua", nome = "agua", type = "usar" },
	["taurina"] = { index = "taurina", nome = "TAURINA", type = "usar" },
	["cafeina"] = { index = "cafeina", nome = "CAFEINA", type = "usar" },	
	["carteira"] = { index = "carteira", nome = "Dinheiro na Carteira", type = "usar" },
	["varadepesca"] = { index = "varadepesca", nome = "VARA DE PESCA", type = "usar" },		
	["lanche"] = { index = "lanche", nome = "lanche", type = "usar" },
	["laudoteoricocnh"] = { index = "laudoteoricocnh", nome = "Laudo Teórico", type = "usar" },
	["hamburger"] = { index = "hamburger", nome = "hamburger", type = "usar" },
	["tartaruga"] = { index = "tartaruga", nome = "Filhote de Tartaruga", type = "usar" },
	["carnedetartaruga"] = { index = "carnedetartaruga", nome = "Carne de Tartaruga", type = "usar" },
	["ferramenta"] = { index = "ferramenta", nome = "Ferramenta", type = "usar" },
	["encomenda"] = { index = "encomenda", nome = "Encomenda", type = "usar" },
	["sacodelixo"] = { index = "sacodelixo", nome = "Saco de Lixo", type = "usar" },
	["garrafavazia"] = { index = "garrafavazia", nome = "Garrafa Vazia", type = "usar" },
	["garrafadeleite"] = { index = "garrafadeleite", nome = "Garrafa de Leite", type = "usar" },
	["leite"] = { index = "leite", nome = "Leite", type = "usar" },
	["tora"] = { index = "tora", nome = "Tora de Madeira", type = "usar" },
	["alianca"] = { index = "alianca", nome = "Aliança", type = "usar" },
	["bandagem"] = { index = "bandagem", nome = "Bandagem", type = "usar" },
	["dorflex"] = { index = "dorflex", nome = "Dorflex", type = "usar" },
	["cicatricure"] = { index = "cicatricure", nome = "Cicatricure", type = "usar" },
	["dipiroca"] = { index = "dipiroca", nome = "Dipiroca", type = "usar" },
	["nocucedin"] = { index = "nocucedin", nome = "Nocucedin", type = "usar" },
	["paracetanal"] = { index = "paracetanal", nome = "Paracetanal", type = "usar" },
	["decupramim"] = { index = "decupramim", nome = "Decupramim", type = "usar" },
	["buscopau"] = { index = "buscopau", nome = "Buscopau", type = "usar" },
	["skate"] = { index = "skate", nome = "Skate", type = "usar" },
	["vape"] = { index = "vape", nome = "Vaper", type = "usar" },
	["navagina"] = { index = "navagina", nome = "Navagina", type = "usar" },
	["analdor"] = { index = "analdor", nome = "Analdor", type = "usar" },
	["sefodex"] = { index = "sefodex", nome = "Sefodex", type = "usar" },
	["nokusin"] = { index = "nokusin", nome = "Nokusin", type = "usar" },
	["glicoanal"] = { index = "glicoanal", nome = "Glicoanal", type = "usar" },
	["cerveja"] = { index = "cerveja", nome = "Cerveja", type = "usar" },
	["batata"] = { index = "batata", nome = "Batata", type = "usar" },
	["tequila"] = { index = "tequila", nome = "Tequila", type = "usar" },
	["vodka"] = { index = "vodka", nome = "Vodka", type = "usar" },
	["whisky"] = { index = "whisky", nome = "Whisky", type = "usar" },
	["conhaque"] = { index = "conhaque", nome = "Conhaque", type = "usar" },
	["absinto"] = { index = "absinto", nome = "Absinto", type = "usar" },
	["dinheirosujo"] = { index = "dinheirosujo", nome = "Dinheiro Sujo", type = "usar" },
	["dinheirofalso"] = { index = "dinheirofalso", nome = "Dineiro Sujo", type = "usar" },
	["repairkit"] = { index = "repairkit", nome = "Kit de Reparos", type = "usar" },
	["morfina"] = { index = "morfina", nome = "Morfina", type = "usar" },
	["placa"] = { index = "placa", nome = "Placa", type = "usar" },
	["algemas"] = { index = "algemas", nome = "Algemas", type = "usar" },
	["capuz"] = { index = "capuz", nome = "Capuz", type = "usar" },
	["lockpick"] = { index = "lockpick", nome = "Lockpick", type = "usar" },
	["identidade"] = { index = "identidade", nome = "Identidade", type = "usar" },
	["masterpick"] = { index = "masterpick", nome = "Masterpick", type = "usar" },
	["militec"] = { index = "militec", nome = "Militec-1", type = "usar" },
	["pneus"] = { index = "pneus", nome = "Pneus", type = "usar" },
	["rebite"] = { index = "rebite", nome = "Rebite", type = "usar" },
	["notebook"] = { index = "notebook", nome = "Notebook", type = "usar" },
	["roupas"] = { index = "roupas", nome = "Roupas", type = "usar" },
	["carnedecormorao"] = { index = "carnedecormorao", nome = "Carne de Cormorão", type = "usar" },
	["carnedecorvo"] = { index = "carnedecorvo", nome = "Carne de Corvo", type = "usar" },
	["carnedeaguia"] = { index = "carnedeaguia", nome = "Carne de Águia", type = "usar" },
	["carnedecervo"] = { index = "carnedecervo", nome = "Carne de Cervo", type = "usar" },
	["carnedecoelho"] = { index = "carnedecoelho", nome = "Carne de Coelho", type = "usar" },
	["carnedecoyote"] = { index = "carnedecoyote", nome = "Carne de Coyote", type = "usar" },
	["carnedelobo"] = { index = "carnedelobo", nome = "Carne de Lobo", type = "usar" },
	["carnedepuma"] = { index = "carnedepuma", nome = "Carne de Puma", type = "usar" },
	["carnedejavali"] = { index = "carnedejavali", nome = "Carne de Javali", type = "usar" },
	["amora"] = { index = "amora", nome = "Amora", type = "usar" },
	["cereja"] = { index = "cereja", nome = "Cereja", type = "usar" },
	["isca"] = { index = "isca", nome = "Isca", type = "usar" },
	["dourado"] = { index = "dourado", nome = "Dourado", type = "usar" },
	["corvina"] = { index = "corvina", nome = "Corvina", type = "usar" },
	["salmao"] = { index = "salmao", nome = "Salmão", type = "usar" },
	["pacu"] = { index = "pacu", nome = "Pacu", type = "usar" },
	["pintado"] = { index = "pintado", nome = "Pintado", type = "usar" },
	["pirarucu"] = { index = "pirarucu", nome = "Pirarucu", type = "usar" },
	["tilapia"] = { index = "tilapia", nome = "Tilápia", type = "usar" },
	["tucunare"] = { index = "tucunare", nome = "Tucunaré", type = "usar" },
	["lambari"] = { index = "lambari", nome = "Lambari", type = "usar" },
	["energetico"] = { index = "energetico", nome = "Energético", type = "usar" },
	["mochila"] = { index = "mochila", nome = "Mochila", type = "usar" },
	--- fome e sede --------------------------------------------------
	["x-tudo"] = { index = "x-tudo", nome = "Mata Fome", type = "usar" },	
	["refrigerante"] = { index = "refrigerante", nome = "Refrigerante", type = "usar" },
	["big-mec"] = { index = "big-mec", nome = "Big Mec", type = "usar" },
	["mc-cheddar"] = { index = "mc-cheddar", nome = "Mc Cheddar", type = "usar" },
	["quarterao"] = { index = "quarterao", nome = "Quarterão", type = "usar" },
	["combo"] = { index = "combo", nome = "Mc Combo", type = "usar" },
	-- FARMS ----------------------------------------------------------------------------------------------------
	["laranja"] = { index = "laranja", nome = "Laranja", type = "usar" },
	["tomate"] = { index = "tomate", nome = "Tomate", type = "usar" },
	["corpopistol"] = { index = "corpopistol", nome = "Corpo Pistol", type = "usar" },
	["placa-metal"] = { index = "placa-metal", nome = "Placa de Metal", type = "usar" },
	["gatilho"] = { index = "gatilho", nome = "Gatilho", type = "usar" },
	["molas"] = { index = "molas", nome = "Molas", type = "usar" },
	["corposub"] = { index = "corposub", nome = "Corpo Sub", type = "usar" },
	["corporifle"] = { index = "corporifle", nome = "Corpo Rifle", type = "usar" },
	["notafiscalfalsa"] = { index = "notafiscalfalsa", nome = "Nota Fiscal Falsa", type = "usar" },	

	["amido"] = { index = "amido", nome = "amido", type = "usar" },
	["composto"] = { index = "composto", nome = "composto", type = "usar" },
	["lsdembalado"] = { index = "lsdembalado", nome = "LSD Embalado", type = "usar" },
	["embalagem"] = { index = "embalagem", nome = "embalagem", type = "usar" },
	["saquinhos"] = { index = "saquinhos", nome = "saquinhos", type = "usar" },
	["cocaembalada"] = { index = "cocaembalada", nome = "coca embalada", type = "usar" },
	["balanca"] = { index = "balanca", nome = "balanca", type = "usar" },
	["tablete"] = { index = "tablete", nome = "tablete", type = "usar" },
	["couro"] = { index = "couro", nome = "couro", type = "usar" },
	["linha"] = { index = "linha", nome = "linha", type = "usar" },
	["tesoura"] = { index = "tesoura", nome = "tesoura", type = "usar" },
	["aco"] = { index = "aco", nome = "aco", type = "usar" },
	["aluminio"] = { index = "aluminio", nome = "aluminio", type = "usar" },
	["chave"] = { index = "chave", nome = "chave", type = "usar" },
	["plastico"] = { index = "plastico", nome = "plastico", type = "usar" },
	["cobre"] = { index = "cobre", nome = "cobre", type = "usar" },
	["chip"] = { index = "chip", nome = "chip", type = "usar" },
	["cordas"] = { index = "cordas", nome = "cordas", type = "usar" },
	["chip"] = { index = "chip", nome = "chip", type = "usar" },
	["tinta"] = { index = "tinta", nome = "tinta", type = "usar" },
	["co2"] = { index = "co2", nome = "co2", type = "usar" },
	["nitro"] = { index = "nitro", nome = "nitro", type = "usar" },	
	-- Maconha ----------------------------------------------------------------------------------------------------
	["maconha"] = { index = "maconha", nome = "Maconha", type = "usar" },
	["ramosdemaconha"] = { index = "ramosdemaconha", nome = "Ramo de Maconha", type = "usar" },
	["maconhanaoprocessada"] = { index = "maconhanaoprocessada", nome = "Maconha não Processada", type = "usar" },
	["maconhamisturada"] = { index = "maconhamisturada", nome = "Maconha Misturada", type = "usar" },
	["baseado"] = { index = "baseado", nome = "Baseado", type = "usar" },
	["seda"] = { index = "seda", nome = "Seda", type = "usar" },
	["receita1"] = { index = "receita1", nome = "Receita Médica", type = "usar" },
	["receita2"] = { index = "receita2", nome = "Receita Médica", type = "usar" },
	---------------------------------------------------------------------------------------------------------------
	-- Cocaína ----------------------------------------------------------------------------------------------------
	["folhadecoca"] = { index = "folhadecoca", nome = "Folha de Coca", type = "usar" },
	["pastadecoca"] = { index = "pastadecoca", nome = "Pasta de Coca", type = "usar" },
	["cocamisturada"] = { index = "cocamisturada", nome = "Cocaína Misturada", type = "usar" },
	["cocaina"] = { index = "cocaina", nome = "Cocaína", type = "usar" },
	["ziplock"] = { index = "ziplock", nome = "Saco ZipLock", type = "usar" },
	---------------------------------------------------------------------------------------------------------------
	-- Ecstasy -----------------------------------------------------------------
	["ocitocina"] = { index = "ocitocina", nome = "Ocitocina Sintética", type = "usar" },
	["ociacido"] = { index = "ociacido", nome = "Ácido Anf. Desidratado", type = "usar" },
	["primaecstasy"] = { index = "primaecstasy", nome = "Matéria Prima - Ecstasy", type = "usar" },
	["ecstasy"] = { index = "ecstasy", nome = "Ecstasy", type = "usar" },
	["glicerina"] = { index = "glicerina", nome = "Glicerina", type = "usar" },
	---------------------------------------------------------------------------------------------------------------
	-- Lavagem de Dinheiro ----------------------------------------------------------------------------------------
	["impostoderenda"] = { index = "impostoderenda", nome = "Imposto de Renda", type = "usar" },
	["impostoderendafalso"] = { index = "impostoderendafalso", nome = "Imposto de Renda Falso", type = "usar" },
	---------------------------------------------------------------------------------------------------------------
	-- Bratva Munições --------------------------------------------------------------------------------------------
	["detonador"] = { index = "detonador", nome = "Detonador", type = "usar" },
	["ferramentas"] = { index = "ferramentas", nome = "Ferramentas Pesadas", type = "usar" },
	---------------------------------------------------------------------------------------------------------------
	["adubo"] = { index = "adubo", nome = "Adubo", type = "usar" },
	["fertilizante"] = { index = "fertilizante", nome = "Fertilizante", type = "usar" },
	["capsula"] = { index = "capsula", nome = "Cápsula", type = "usar" },
	["polvora"] = { index = "polvora", nome = "Pólvora", type = "usar" },
	["orgaos"] = { index = "orgaos", nome = "Órgãos", type = "usar" },
	["etiqueta"] = { index = "etiqueta", nome = "Etiqueta", type = "usar" },
	["pendrive"] = { index = "pendrive", nome = "Pendrive", type = "usar" },
	["relogioroubado"] = { index = "relogioroubado", nome = "Relógio Roubado", type = "usar" },
	["pulseiraroubada"] = { index = "pulseiraroubada", nome = "Pulseira Roubada", type = "usar" },
	["anelroubado"] = { index = "anelroubado", nome = "Anel Roubado", type = "usar" },
	["colarroubado"] = { index = "colarroubado", nome = "Colar Roubado", type = "usar" },
	["brincoroubado"] = { index = "brincoroubado", nome = "Brinco Roubado", type = "usar" },
	["carteiraroubada"] = { index = "carteiraroubada", nome = "Carteira Roubada", type = "usar" },
	["tabletroubado"] = { index = "tabletroubado", nome = "Tablet Roubado", type = "usar" },
	["sapatosroubado"] = { index = "sapatosroubado", nome = "Sapatos Roubado", type = "usar" },
	["vibradorroubado"] = { index = "vibradorroubado", nome = "Vibrador Roubado", type = "usar" },
	["perfumeroubado"] = { index = "perfumeroubado", nome = "Perfume Roubado", type = "usar" },
	["fungo"] = { index = "fungo", nome = "Fungo", type = "usar" },
    ["dietilamina"] = { index = "dietilamina", nome = "Dietilamina", type = "usar" },
	["lsd"] = { index = "lsd", nome = "LSD", type = "usar" },
	["acidobateria"] = { index = "acidobateria", nome = "Ácido de Bateria", type = "usar" },
	["anfetamina"] = { index = "anfetamina", nome = "Anfetamina", type = "usar" },
	["cristal"] = { index = "cristal", nome = "Cristal de Metanfetamina", type = "usar" },
	["metanfetamina"] = { index = "metanfetamina", nome = "Metanfetamina", type = "usar" },
	["pipe"] = { index = "pipe", nome = "Pipe", type = "usar" },
	["armacaodearma"] = { index = "armacaodearma", nome = "Armação de Arma", type = "usar" },
	["pecadearma"] = { index = "pecadearma", nome = "Peça de Arma", type = "usar" },
	["logsinvasao"] = { index = "logsinvasao", nome = "L. Inv. Banco", type = "usar" },
	["keysinvasao"] = { index = "keysinvasao", nome = "K. Inv. Banco", type = "usar" },
	["pendriveinformacoes"] = { index = "pendriveinformacoes", nome = "P. Info.", type = "usar" },
	["acessodeepweb"] = { index = "acessodeepweb", nome = "P. DeepWeb", type = "usar" },
	["diamante"] = { index = "diamante", nome = "Min. Diamante", type = "usar" },
	["ouro"] = { index = "ouro", nome = "Min. Ouro", type = "usar" },
	["bronze"] = { index = "bronze", nome = "Min. Bronze", type = "usar" },
	["ferro"] = { index = "ferro", nome = "Min. Ferro", type = "usar" },
	["rubi"] = { index = "rubi", nome = "Min. Rubi", type = "usar" },
	["esmeralda"] = { index = "esmeralda", nome = "Min. Esmeralda", type = "usar" },
	["safira"] = { index = "safira", nome = "Min. Safira", type = "usar" },
	["colete"] = { index = "colete", nome = "Colete", type = "usar" },
	["topazio"] = { index = "topazio", nome = "Min. Topazio", type = "usar" },
	["ametista"] = { index = "ametista", nome = "Min. Ametista", type = "usar" },
	["diamante2"] = { index = "diamante2", nome = "Diamante", type = "usar" },
	["ouro2"] = { index = "ouro2", nome = "Ouro", type = "usar" },
	["bronze2"] = { index = "bronze2", nome = "Bronze", type = "usar" },
	["ferro2"] = { index = "ferro2", nome = "Ferro", type = "usar" },
	["radio"] = { index = "radio", nome = "Radio", type = "usar" },
	["c4"] = { index = "c4", nome = "C4", type = "usar" },
	["furadeira"] = { index = "furadeira", nome = "Furadeira", type = "usar" },
	["serra"] = { index = "serra", nome = "Serra", type = "usar" },
	["rubi2"] = { index = "rubi2", nome = "Rubi", type = "usar" },
	["esmeralda2"] = { index = "esmeralda2", nome = "Esmeralda", type = "usar" },
	["safira2"] = { index = "safira2", nome = "Safira", type = "usar" },
	["topazio2"] = { index = "topazio2", nome = "Topazio", type = "usar" },
	["ametista2"] = { index = "ametista2", nome = "Ametista", type = "usar" },
	["graos"] = { index = "graos", nome = "Graos", type = "usar" },
	["graosimpuros"] = { index = "graosimpuros", nome = "Graos Impuros", type = "usar" },
	["keycard"] = { index = "keycard", nome = "Keycard", type = "usar" },
	["xerelto"] = { index = "xerelto", nome = "Xerelto", type = "usar" },
	["coumadin"] = { index = "coumadin", nome = "Coumadin", type = "usar" },
	["aneldecompromisso"] = { index = "aneldecompromisso", nome = "Anel de Compromisso", type = "usar" },
	["colardeperolas"] = { index = "colardeperolas", nome = "Colar de Pérolas", type = "usar" },
	["pulseiradeouro"] = { index = "pulseiradeouro", nome = "Pulseira de Ouro", type = "usar" },
	["chocolate"] = { index = "chocolate", nome = "Chocolate", type = "usar" },
	["pirulito"] = { index = "pirulito", nome = "Pirulito", type = "usar" },
	["buque"] = { index = "buque", nome = "Buquê de Flores", type = "usar" },
	["wbody|WEAPON_DAGGER"] = { index = "adaga", nome = "Adaga", type = "equipar" },
	["wbody|WEAPON_BAT"] = { index = "beisebol", nome = "Taco de Beisebol", type = "equipar" },
	["wbody|WEAPON_BOTTLE"] = { index = "garrafa", nome = "Garrafa", type = "equipar" },
	["wbody|WEAPON_CROWBAR"] = { index = "cabra", nome = "Pé de Cabra", type = "equipar" },
	["wbody|WEAPON_FLASHLIGHT"] = { index = "lanterna", nome = "Lanterna", type = "equipar" },
	["wbody|WEAPON_GOLFCLUB"] = { index = "golf", nome = "Taco de Golf", type = "equipar" },
	["wbody|WEAPON_HAMMER"] = { index = "martelo", nome = "Martelo", type = "equipar" },
	["wbody|WEAPON_HATCHET"] = { index = "machado", nome = "Machado", type = "equipar" },
	["wbody|WEAPON_KNUCKLE"] = { index = "ingles", nome = "Soco-Inglês", type = "equipar" },
	["wbody|WEAPON_KNIFE"] = { index = "faca", nome = "Faca", type = "equipar" },
	["wbody|WEAPON_MACHETE"] = { index = "machete", nome = "Machete", type = "equipar" },
	["wbody|WEAPON_SWITCHBLADE"] = { index = "canivete", nome = "Canivete", type = "equipar" },
	["wbody|WEAPON_NIGHTSTICK"] = { index = "cassetete", nome = "Cassetete", type = "equipar" },
	["wbody|WEAPON_WRENCH"] = { index = "grifo", nome = "Chave de Grifo", type = "equipar" },
	["wbody|WEAPON_BATTLEAXE"] = { index = "batalha", nome = "Machado de Batalha", type = "equipar" },
	["wbody|WEAPON_POOLCUE"] = { index = "sinuca", nome = "Taco de Sinuca", type = "equipar" },
	["wbody|WEAPON_STONE_HATCHET"] = { index = "pedra", nome = "Machado de Pedra", type = "equipar" },
	["wbody|WEAPON_PISTOL"] = { index = "m1911", nome = "M1911", type = "equipar" },
	["wbody|WEAPON_PISTOL_MK2"] = { index = "fiveseven", nome = "FN Five Seven", type = "equipar" },
	["wbody|WEAPON_COMBATPISTOL"] = { index = "glock", nome = "Glock 19", type = "equipar" },
	["wbody|WEAPON_STUNGUN"] = { index = "taser", nome = "Taser", type = "equipar" },
	["wbody|WEAPON_SNSPISTOL"] = { index = "hkp7m10", nome = "HK P7M10", type = "equipar" },
	["wbody|WEAPON_HEAVYSNIPER"] = { index = "sniper", nome = "Sniper", type = "equipar" },
	["wbody|WEAPON_VINTAGEPISTOL"] = { index = "m1922", nome = "M1922", type = "equipar" },
	["wbody|WEAPON_REVOLVER"] = { index = "magnum44", nome = "Magnum 44", type = "equipar" },
	["wbody|WEAPON_REVOLVER_MK2"] = { index = "magnum357", nome = "Magnum 357", type = "equipar" },
	["wbody|WEAPON_MUSKET"] = { index = "winchester22", nome = "Winchester 22", type = "equipar" },
	["wbody|WEAPON_FLARE"] = { index = "sinalizador", nome = "Sinalizador", type = "equipar" },
	["wbody|GADGET_PARACHUTE"] = { index = "paraquedas", nome = "Paraquedas", type = "equipar" },
	["wbody|WEAPON_FIREEXTINGUISHER"] = { index = "extintor", nome = "Extintor", type = "equipar" },
	["wbody|WEAPON_MICROSMG"] = { index = "uzi", nome = "Uzi", type = "equipar" },
	["wbody|WEAPON_SMG"] = { index = "mp5", nome = "MP5", type = "equipar" },
	["wbody|WEAPON_ASSAULTSMG"] = { index = "mag-pdr", nome = "MAG-PDR", type = "equipar" },
	["wbody|WEAPON_COMBATPDW"] = { index = "sigsauer", nome = "Sig Sauer MPX", type = "equipar" },
	["wbody|WEAPON_PUMPSHOTGUN_MK2"] = { index = "remington", nome = "Remington 870", type = "equipar" },
	["wbody|WEAPON_CARBINERIFLE"] = { index = "m4a1", nome = "M4A1", type = "equipar" },
	["wbody|WEAPON_ASSAULTRIFLE"] = { index = "ak47", nome = "AK-47", type = "equipar" },
	["wbody|WEAPON_ASSAULTRIFLE_MK2"] = { index = "ak47mk2", nome = "AK-47 MK2", type = "equipar" },
	["wbody|WEAPON_PETROLCAN"] = { index = "gasolina", nome = "Galão de Gasolina", type = "equipar" },	
	["wbody|WEAPON_GUSENBERG"] = { index = "thompson", nome = "Thompson", type = "equipar" },		
	["wbody|WEAPON_MACHINEPISTOL"] = { index = "tec9", nome = "Tec-9", type = "equipar" },
	["wbody|WEAPON_COMPACTRIFLE"] = { index = "aks", nome = "AKS", type = "equipar" },
	["wbody|WEAPON_CARBINERIFLE_MK2"] = { index = "mpx", nome = "MPX", type = "equipar" },
	["wbody|WEAPON_SPECIALCARBINE"] = { index = "parafal", nome = "Parafal", type = "equipar" },  
	["wbody|WEAPON_SPECIALCARBINE_MK2"] = { index = "g36", nome = "G36", type = "equipar" },
	["wbody|WEAPON_BULLPUPRIFLE"] = { index = "qbz", nome = "FAMAS", type = "equipar" },
	["wbody|WEAPON_PUMPSHOTGUN"] = { index = "shotgun", nome = "Shotgun", type = "equipar" },
	["wbody|WEAPON_SAWNOFFSHOTGUN"] = { index = "sawnoffshotgun", nome = "Shotgun C.Serrado", type = "equipar" },
	-- Munições
	["wammo|WEAPON_SPECIALCARBINE"] = { index = "M-parafal", nome = "m.Parafal", type = "recarregar" },
	["wammo|WEAPON_SPECIALCARBINE_MK2"] = { index = "m-g36c", nome = "m.G36", type = "recarregar" },
	["wammo|WEAPON_SAWNOFFSHOTGUN"] = { index = "m-sawnoffshotgun", nome = "M.Shotgun C.Serrado", type = "recarregar" },
	["wammo|WEAPON_BULLPUPRIFLE"] = { index = "m-qbz", nome = "M.FAMAS", type = "recarregar" },
	["wammo|WEAPON_PISTOL"] = { index = "m-m1911", nome = "M.M1911", type = "recarregar" },
	["wammo|WEAPON_PISTOL_MK2"] = { index = "m-fiveseven", nome = "M.FN Five Seven", type = "recarregar" },
	["wammo|WEAPON_COMBATPISTOL"] = { index = "m-glock", nome = "M.Glock 19", type = "recarregar" },
	["wammo|WEAPON_STUNGUN"] = { index = "m-taser", nome = "M.Taser", type = "recarregar" },
	["wammo|WEAPON_SNSPISTOL"] = { index = "m-hkp7m10", nome = "M.HK P7M10", type = "recarregar" },
	["wammo|WEAPON_VINTAGEPISTOL"] = { index = "m-m1922", nome = "M.M1922", type = "recarregar" },
	["wammo|WEAPON_REVOLVER"] = { index = "m-magnum44", nome = "M.Magnum 44", type = "recarregar" },
	["wammo|WEAPON_REVOLVER_MK2"] = { index = "m-magnum357", nome = "M.Magnum 357", type = "recarregar" },
	["wammo|WEAPON_MUSKET"] = { index = "m-winchester22", nome = "M.Winchester 22", type = "recarregar" },
	["wammo|WEAPON_FLARE"] = { index = "m-sinalizador", nome = "M.Sinalizador", type = "recarregar" },
	["wammo|GADGET_PARACHUTE"] = { index = "m-paraquedas", nome = "M.Paraquedas", type = "recarregar" },
	["wammo|WEAPON_FIREEXTINGUISHER"] = { index = "m-extintor", nome = "M.Extintor", type = "recarregar" },
	["wammo|WEAPON_MICROSMG"] = { index = "m-uzi", nome = "M.Uzi", type = "recarregar" },
	["wammo|WEAPON_SMG"] = { index = "m-mp5", nome = "M.MP5", type = "recarregar" },
	["wammo|WEAPON_ASSAULTSMG"] = { index = "m-mag-pdr", nome = "M.MAG-PDR", type = "recarregar" },
	["wammo|WEAPON_COMBATPDW"] = { index = "m-sigsauer", nome = "M.Sig Sauer MPX", type = "recarregar" },
	["wammo|WEAPON_PUMPSHOTGUN"] = { index = "m-shotgun", nome = "M.Shotgun", type = "recarregar" },
	["wammo|WEAPON_PUMPSHOTGUN_MK2"] = { index = "m-remington", nome = "M.Remington 870", type = "recarregar" },
	["wammo|WEAPON_CARBINERIFLE"] = { index = "m-m4a1", nome = "M.M4A1", type = "recarregar" },
	["wammo|WEAPON_ASSAULTRIFLE"] = { index = "m-ak47", nome = "M.AK-47", type = "recarregar" },
	["wammo|WEAPON_ASSAULTRIFLE_MK2"] = { index = "m-ak47mk2", nome = "M.AK-47 MK2", type = "recarregar" },
	["wammo|WEAPON_GUSENBERG"] = { index = "m-thompson", nome = "M.Thompson", type = "recarregar" },
	["wammo|WEAPON_MACHINEPISTOL"] = { index = "m-tec9", nome = "M.Tec-9", type = "recarregar" },
	["wammo|WEAPON_COMPACTRIFLE"] = { index = "m-aks", nome = "M.AKS", type = "recarregar" },
	["wammo|WEAPON_CARBINERIFLE_MK2"] = { index = "m-mpx", nome = "M.MPX", type = "recarregar" },
	["wammo|WEAPON_PETROLCAN"] = { index = "combustivel", nome = "Combustível", type = "recarregar" },
	["wammo|WEAPON_HEAVYSNIPER"] = { index = "m-snipe", nome = "M.Sniper", type = "recarregar" },
	["projetoassaultrifle"] = { index = "projetoassaultrifle", nome = "Projeto Ak-47", type = "usar" },
	["projetoassaultsmg"] = { index = "projetoassaultsmg", nome = "Projeto MAG-PDR", type = "usar" },
	["projetobullpuprifle"] = { index = "projetobullpuprifle", nome = "Projeto QBZ", type = "usar" },
	["projetocarbinerifle"] = { index = "projetocarbinerifle", nome = "Projeto M4A1", type = "usar" },
	["projetocombatpdw"] = { index = "projetocombatpdw", nome = "Projeto MPX", type = "usar" },
	["projetocombatpistol"] = { index = "projetocombatpistol", nome = "Projeto Glock 19", type = "usar" },
	["projetogusenberg"] = { index = "projetogusenberg", nome = "Projeto Thompson", type = "usar" },
	["projetopistol"] = { index = "projetopistol", nome = "Projeto Fiven", type = "usar" },
	["projetopumpshotgun"] = { index = "projetopumpshotgun", nome = "Projeto Shotgun", type = "usar" },
	["projetosawnoffshotgun"] = { index = "projetosawnoffshotgun", nome = "Projeto Shot Cano Serrado", type = "usar" },
	["celular"] = { index = "celular", nome = "Celular", type = "usar" },
	["projetosmg"] = { index = "projetosmg", nome = "Projeto MP5", type = "usar" },
	["agave"] = { index = "agave", nome = "Miolo da Agave", type = "usar" },

	["maquineta"] = { index = "maquineta", nome = "Maquina de Cartão", type = "usar" },
	["cartao"] = { index = "cartao", nome = "Cartão Débito", type = "usar" }
}


function vRP.itemNameList(item)
	if itemlist[item] ~= nil then
		return itemlist[item].nome
	end
end

function vRP.EnviarItens()
    return itemlist
end

function vRP.itemIndexList(item)
	if itemlist[item] ~= nil then
		return itemlist[item].index
	end
end

function vRP.itemTypeList(item)
	if itemlist[item] ~= nil then
		return itemlist[item].type
	end
end

function vRP.itemBodyList(item)
	if itemlist[item] ~= nil then
		return itemlist[item]
	end
end

vRP.items = {}
function vRP.defInventoryItem(idname,name,weight)
	if weight == nil then
		weight = 0
	end
	local item = { name = name, weight = weight }
	vRP.items[idname] = item
end

function vRP.computeItemName(item,args)
	if type(item.name) == "string" then
		return item.name
	else
		return item.name(args)
	end
end

function vRP.computeItemWeight(item,args)
	if type(item.weight) == "number" then
		return item.weight
	else
		return item.weight(args)
	end
end

function vRP.parseItem(idname)
	return splitString(idname,"|")
end

function vRP.getItemDefinition(idname)
	local args = vRP.parseItem(idname)
	local item = vRP.items[args[1]]
	if item then
		return vRP.computeItemName(item,args),vRP.computeItemWeight(item,args)
	end
	return nil,nil
end

function vRP.getItemWeight(idname)
	local args = vRP.parseItem(idname)
	local item = vRP.items[args[1]]
	if item then
		return vRP.computeItemWeight(item,args)
	end
	return 0
end

function vRP.computeItemsWeight(items)
	local weight = 0
	for k,v in pairs(items) do
		local iweight = vRP.getItemWeight(k)
		weight = weight+iweight*v.amount
	end
	return weight
end

function vRP.giveInventoryItem(user_id,idname,amount)
	local amount = parseInt(amount)
	local data = vRP.getUserDataTable(user_id)
	if data and amount > 0 then
		local entry = data.inventory[idname]
		if entry then
			entry.amount = entry.amount + amount
		else
			data.inventory[idname] = { amount = amount }
		end
	end
end

--local creative_itens = "https://discordapp.com/api/webhooks/604945979023687691/8XKL0ByvuyQxjnW5JtWVb8FdtDyPYa0mKcP2wcifM2LGzMGSHpFchQhD8-PAdYG-QfQq"

function vRP.tryGetInventoryItem(user_id,idname,amount)
	local amount = parseInt(amount)
	local data = vRP.getUserDataTable(user_id)
	if data and amount > 0 then
		--if idname == "tora" or idname == "carnedepuma" or idname == "etiqueta" then
			--creativeLogs(creative_itens,"**USER_ID:** "..user_id.." **ITEM:** "..idname.." - **QUANTIDADE:** "..parseInt(amount).." - "..os.date("%H:%M:%S"))
		--end
		local entry = data.inventory[idname]
		if entry and entry.amount >= amount then
			entry.amount = entry.amount - amount

			if entry.amount <= 0 then
				data.inventory[idname] = nil
			end
			return true
		end
	end
	return false
end

function vRP.getInventoryItemAmount(user_id,idname)
	local data = vRP.getUserDataTable(user_id)
	if data and data.inventory then
		local entry = data.inventory[idname]
		if entry then
			return entry.amount
		end
	end
	return 0
end

function vRP.getInventory(user_id)
	local data = vRP.getUserDataTable(user_id)
	if data then
		return data.inventory
	end
end

function vRP.getInventoryWeight(user_id)
	local data = vRP.getUserDataTable(user_id)
	if data and data.inventory then
		return vRP.computeItemsWeight(data.inventory)
	end
	return 0
end

function vRP.getInventoryMaxWeight(user_id)
	return math.floor(vRP.expToLevel(vRP.getExp(user_id,"physical","strength")))*3
end

RegisterServerEvent("clearInventory")
AddEventHandler("clearInventory",function()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local data = vRP.getUserDataTable(user_id)
        if data then
            data.inventory = {}
        end

        vRP.setMoney(user_id,0)
        vRPclient._clearWeapons(source)
        vRPclient._setHandcuffed(source,false)

        if not vRP.hasPermission(user_id,"mochila.permissao") then
            vRP.setExp(user_id,"physical","strength",20)
        end
    end
end)
AddEventHandler("vRP:playerJoin", function(user_id,source,name)
	local data = vRP.getUserDataTable(user_id)
	if not data.inventory then
		data.inventory = {}
	end
end)

local chests = {}
local function build_itemlist_menu(name,items,cb)
	local menu = { name = name }
	local kitems = {}

	local choose = function(player,choice)
		local idname = kitems[choice]
		if idname then
			cb(idname)
		end
	end

	for k,v in pairs(items) do 
		local name,weight = vRP.getItemDefinition(k)
		if name then
			kitems[name] = k
			menu[name] = { choose,"<text01>Quantidade:</text01> <text02>"..v.amount.."</text02><text01>Peso:</text01> <text02>"..string.format("%.2f",weight).."kg</text02>" }
		end
	end

	return menu
end

function vRP.openChest(source,name,max_weight,cb_close,cb_in,cb_out)
	local user_id = vRP.getUserId(source)
	if user_id then
		local data = vRP.getUserDataTable(user_id)
		local identity = vRP.getUserIdentity(user_id)
		if data.inventory then
			if not chests[name] then
				local close_count = 0
				local chest = { max_weight = max_weight }
				chests[name] = chest 
				local cdata = vRP.getSData("chest:"..name)
				chest.items = json.decode(cdata) or {}

				local menu = { name = "Baú" }
				local cb_take = function(idname)
					local citem = chest.items[idname]
					local amount = vRP.prompt(source,"Quantidade:","")
					if parseInt(amount) > 0 and parseInt(amount) <= citem.amount then
						local new_weight = vRP.getInventoryWeight(user_id)+vRP.getItemWeight(idname)*parseInt(amount)
						if new_weight <= vRP.getInventoryMaxWeight(user_id) then
							vRP.giveInventoryItem(user_id,idname,parseInt(amount))
							
							citem.amount = citem.amount - parseInt(amount)

							if citem.amount <= 0 then
								chest.items[idname] = nil
							end

							if cb_out then
								cb_out(idname,parseInt(amount))
							end
							vRP.closeMenu(source)
						else
							TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
						end
					else
						TriggerClientEvent("Notify",source,"negado","Valor inválido.",8000)
					end
				end

				local ch_take = function(player,choice)
					local weight = vRP.computeItemsWeight(chest.items)
					local submenu = build_itemlist_menu(string.format("%.2f",weight).." / "..max_weight.."kg",chest.items,cb_take)

					submenu.onclose = function()
						close_count = close_count - 1
						vRP.openMenu(player,menu)
					end
					close_count = close_count + 1
					vRP.openMenu(player,submenu)
				end

				local cb_put = function(idname)
					if string.match(idname,"identidade") then
						TriggerClientEvent("Notify",source,"importante","Não pode guardar a <b>Identidade</b> em veículos.",8000)
						return
					end

					local amount = vRP.prompt(source,"Quantidade:","")
					local new_weight = vRP.computeItemsWeight(chest.items)+vRP.getItemWeight(idname)*parseInt(amount)
					if new_weight <= max_weight then
						if parseInt(amount) > 0 and vRP.tryGetInventoryItem(user_id,idname,parseInt(amount)) then
							
							local citem = chest.items[idname]

							if citem ~= nil then
								citem.amount = citem.amount + parseInt(amount)
							else
								chest.items[idname] = { amount = parseInt(amount) }
							end

							if cb_in then
								cb_in(idname,parseInt(amount))
							end
							vRP.closeMenu(source)
						end
					else
						TriggerClientEvent("Notify",source,"negado","Baú cheio.",8000)
					end
				end

				local ch_put = function(player,choice)
					local weight = vRP.computeItemsWeight(data.inventory)
					local submenu = build_itemlist_menu(string.format("%.2f",weight).." / "..max_weight.."kg",data.inventory,cb_put)

					submenu.onclose = function()
						close_count = close_count-1
						vRP.openMenu(player,menu)
					end

					close_count = close_count + 1
					vRP.openMenu(player,submenu)
				end

				menu["Retirar"] = { ch_take }
				menu["Colocar"] = { ch_put }

				menu.onclose = function()
					if close_count == 0 then
						vRP.setSData("chest:"..name,json.encode(chest.items))
						chests[name] = nil
						if cb_close then
							cb_close()
						end
					end
				end
				vRP.openMenu(source,menu)
			else
				TriggerClientEvent("Notify",source,"importante","Está sendo utilizado no momento.",8000)
			end
		end
	end
end

local function build_client_static_chests(source)
	local user_id = vRP.getUserId(source)
	if user_id then
		for k,v in pairs(cfg.static_chests) do
			local mtype,x,y,z = table.unpack(v)
			local schest = cfg.static_chest_types[mtype]

			if schest then
				local function schest_enter(source)
					local user_id = vRP.getUserId(source)
					if user_id and vRP.hasPermissions(user_id,schest.permissions or {}) then
						vRP.openChest(source,"static:"..k,schest.weight or 0)
					end
				end

				local function schest_leave(source)
					vRP.closeMenu(source)
				end

				vRP.setArea(source,"vRP:static_chest:"..k,x,y,z,1,1,schest_enter,schest_leave)
			end
		end
	end
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	if first_spawn then
		build_client_static_chests(source)
	end
end)
----------------------------------------------------------------------------------------------------------------------------------------
-- block (morrer puxar o cabo e apertar E)
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("clearInventoryAfterDie",function()
    local source = source
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    local x,y,z = vRPclient.getPosition(source)
    if user_id then
    local data = vRP.getUserDataTable(user_id)
    if data then
     data.inventory = {}
    end

    vRP.setMoney(user_id,0)
    vRPclient._clearWeapons(source)
    vRPclient._setHandcuffed(source,false)

    vRP.setExp(user_id,"physical","strength",20)
    TriggerClientEvent("respawnPlayerAfterDie",source)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHGLOBAL
-----------------------------------------------------------------------------------------------------------------------------------------
local vehglobal = {
	------------------------------------CARROS-------------------------------------------
	["civic2016"] = { ['name'] = "civic2016", ['price'] =  71778, ['tipo'] = "sedan" },
	["jetta2017"] = { ['name'] = "jetta2017", ['price'] =  81350, ['tipo'] = "sedan" },
	["saveiro"] = { ['name'] = "saveiro", ['price'] =  53000, ['tipo'] = "sedan" },
	["sportage16"] = { ['name'] = "sportage16", ['price'] =  77999, ['tipo'] = "sedan" },
	["sonata18"] = { ['name'] = "sonata18", ['price'] =  71460, ['tipo'] = "sedan" },
	["bmwx1"] = { ['name'] = "bmwx1", ['price'] =  1000000, ['tipo'] = "sedan" },
	------------------------------------SUVS-------------------------------------------
	["l200civil"] = { ['name'] = "l200", ['price'] =  56400, ['tipo'] = "suv" },
	["schafter6"] = { ['name'] = "Schafter", ['price'] =  48900, ['tipo'] = "suv" },
	["baller3"] = { ['name'] = "baller3", ['price'] =  42000, ['tipo'] = "suv" },
	["dubsta2"] = { ['name'] = "dubsta2", ['price'] =  71460, ['tipo'] = "suv" },
	["dubsta "] = { ['name'] = "dubsta ", ['price'] =  65000, ['tipo'] = "suv" },
	["everon "] = { ['name'] = "everon ", ['price'] =  50000, ['tipo'] = "suv" },
	["amarok"] = { ['name'] = "VW Amarok", ['price'] = 160000, ['tipo'] = "suv" },
	------------------------------------IMPORTADOS-------------------------------------------
	["rumpo3"] = { ['name'] = "rumpo 3", ['price'] =  195000, ['tipo'] = "utility" },
	["cog552"] = { ['name'] = "cog 552", ['price'] =  187450, ['tipo'] = "utility" },
	------------------------------------MOTOS-------------------------------------------
	["150"] = { ['name'] = "Cg 150", ['price'] =  6500, ['tipo'] = "motos" },
	["450crf"] = { ['name'] = "450crf", ['price'] =  33700, ['tipo'] = "motos" },
	["biz25"] = { ['name'] = "biz 25", ['price'] =  4600, ['tipo'] = "motos" },
	["bros60"] = { ['name'] = "bros 160", ['price'] =  11850, ['tipo'] = "motos" },
	["dm1200"] = { ['name'] = "dm 1200", ['price'] =  89950, ['tipo'] = "motos" },
	["zombieb"] = { ['name'] = "zombieb", ['price'] =  23450, ['tipo'] = "motos" },
	["nightblade"] = { ['name'] = "night blade", ['price'] =  25500, ['tipo'] = "motos" },
	["deathbike"] = { ['name'] = "deathbike", ['price'] =  25000, ['tipo'] = "motos" },
	["verus"] = { ['name'] = "verus", ['price'] =  30250, ['tipo'] = "motos" },

	["chevette"] = { ['name'] = "Chevette", ['price'] = 36750, ['tipo'] = "import" },
	["fusca"] = { ['name'] = "Fusca", ['price'] = 28990, ['tipo'] = "import" },
	["golcopa"] = { ['name'] = "Gol copa", ['price'] = 23500, ['tipo'] = "import" },
	["polo2018"] = { ['name'] = "Polo 2018", ['price'] = 58900, ['tipo'] = "import" },
	["space"] = { ['name'] = "Space", ['price'] = 36750, ['tipo'] = "import" },
	["celta"] = { ['name'] = "Celta", ['price'] = 15845, ['tipo'] = "import" },
	["fiat"] = { ['name'] = "Fiat", ['price'] = 20000, ['tipo'] = "import" },
	["fiatuno"] = { ['name'] = "Fiat Uno", ['price'] = 15845, ['tipo'] = "import" },
	["golg7"] = { ['name'] = "Gol g7", ['price'] = 34740, ['tipo'] = "import" },
	["upzinho"] = { ['name'] = "Upzinho", ['price'] = 35400, ['tipo'] = "import" },


	---------------------[vtr]---------------
	["basePM"] = { ['name'] = "basePM", ['price'] = 10000, ['tipo'] = "work" }, 
	["samu1"] = { ['name'] = "samu1", ['price'] = 10000, ['tipo'] = "work" }, 
	["sw4grau1"] = { ['name'] = "sw4grau1", ['price'] = 10000, ['tipo'] = "work" },
	["sprinter"] = { ['name'] = "sprinter", ['price'] = 10000, ['tipo'] = "work" },
	["sw4pm"] = { ['name'] = "sw4pm", ['price'] = 10000, ['tipo'] = "work" },
	["dusterrp1"] = { ['name'] = "dusterrp1", ['price'] = 10000, ['tipo'] = "work" },
	["spinaegis"] = { ['name'] = "spinaegis", ['price'] = 10000, ['tipo'] = "work" },
	["spineng"] = { ['name'] = "spineng", ['price'] = 10000, ['tipo'] = "work" },
	["spinlegion"] = { ['name'] = "spinlegion", ['price'] = 10000, ['tipo'] = "work" },
	["spinpmesp"] = { ['name'] = "spinpmesp", ['price'] = 10000, ['tipo'] = "work" },
	["tral21pm"] = { ['name'] = "tral21pm", ['price'] = 10000, ['tipo'] = "work" },
	["tral17pm"] = { ['name'] = "tral17pm", ['price'] = 10000, ['tipo'] = "work" },
	["xre19rpm"] = { ['name'] = "xre19rpm", ['price'] = 10000, ['tipo'] = "work" },
	["outlandersap"] = { ['name'] = "outlandersap", ['price'] = 10000, ['tipo'] = "work" },
	["trail20pm"] = { ['name'] = "trail20pm", ['price'] = 10000, ['tipo'] = "work" },
	["sw4tor"] = { ['name'] = "sw4tor", ['price'] = 10000, ['tipo'] = "work" },
	["dusterrp1"] = { ['name'] = "dusterrp1", ['price'] = 10000, ['tipo'] = "work" },
	["corollarod"] = { ['name'] = "corollarod", ['price'] = 10000, ['tipo'] = "work" },
	["xt2017pm"] = { ['name'] = "xt2017pm", ['price'] = 10000, ['tipo'] = "work" },
	["trail20pm"] = { ['name'] = "trail20pm", ['price'] = 10000, ['tipo'] = "work" },
	["trail21pm"] = { ['name'] = "trail21pm", ['price'] = 10000, ['tipo'] = "work" },
	["golpm"] = { ['name'] = "golpm", ['price'] = 10000, ['tipo'] = "work" },
	["trail17pm"] = { ['name'] = "trail17pm", ['price'] = 10000, ['tipo'] = "work" },
	["sw4pm"] = { ['name'] = "sw4pm", ['price'] = 10000, ['tipo'] = "work" },
	["s10sap"] = { ['name'] = "s10sap", ['price'] = 10000, ['tipo'] = "work" },
	["trail19iope1"] = { ['name'] = "trail19iope1", ['price'] = 10000, ['tipo'] = "work" },
	["duster21gcm1"] = { ['name'] = "duster21gcm1", ['price'] = 10000, ['tipo'] = "work" },
	["basepm"] = { ['name'] = "basepm", ['price'] = 10000, ['tipo'] = "work" },
	["xregcm"] = { ['name'] = "xregcm", ['price'] = 10000, ['tipo'] = "work" },
	["trail21pc"] = { ['name'] = "trail21pc", ['price'] = 10000, ['tipo'] = "work" },
	["sw4pm"] = { ['name'] = "sw4pm", ['price'] = 10000, ['tipo'] = "work" },
	["dusterrp1"] = { ['name'] = "dusterrp1", ['price'] = 10000, ['tipo'] = "work" },
	["trailcivileie"] = { ['name'] = "trailcivileie", ['price'] = 10000, ['tipo'] = "work" },
	["dusterrp1"] = { ['name'] = "dusterrp1", ['price'] = 10000, ['tipo'] = "work" },
	["tral20pm"] = { ['name'] = "tral20pm", ['price'] = 10000, ['tipo'] = "work" },
	["traildope3"] = { ['name'] = "traildope3", ['price'] = 10000, ['tipo'] = "work" },
	["traildope3"] = { ['name'] = "issi6", ['price'] = 10000, ['tipo'] = "work" },
	["s10"] = { ['name'] = "s10", ['price'] = 320000, ['tipo'] = "exclusive" }, 
	["enladder"] = { ['name'] = "Enladder", ['price'] = 320000, ['tipo'] = "exclusive" },   

	
	-- -------------------[fim vtr]------
	-- ["150"] = { ['name'] = "CG 150", ['price'] = 10000, ['tipo'] = "motos" },
	-- ["450crf"] = { ['name'] = "450 CRF", ['price'] = 15000, ['tipo'] = "motos" },
	-- ["biz25"] = { ['name'] = "Biz 25", ['price'] = 5000, ['tipo'] = "motos" },
	-- ["bros60"] = { ['name'] = "Bros60", ['price'] = 12500, ['tipo'] = "motos" },
	-- ["civic"] = { ['name'] = "Civic", ['price'] = 35000, ['tipo'] = "carros" 
	-- ["dm1200"] = { ['name'] = "Ducati", ['price'] = 70000, ['tipo'] = "motos" },
	-- ["ds4"] = { ['name'] = "Citroen", ['price'] = 35000, ['tipo'] = "carros" },
	-- ["eletran17"] = { ['name'] = "Honda Eletran", ['price'] = 60000, ['tipo'] = "carros" },
	-- ["evoq"] = { ['name'] = "Range Rover", ['price'] = 150000, ['tipo'] = "carros" },
	-- ["f150"] = { ['name'] = "Ford Raptor", ['price'] = 120000, ['tipo'] = "carros" },
	-- ["fiat"] = { ['name'] = "Fiat", ['price'] = 20000, ['tipo'] = "carros" },
	-- ["fiatstilo"] = { ['name'] = "Fiat Stilo", ['price'] = 25000, ['tipo'] = "carros" },
	-- ["fiattoro"] = { ['name'] = "Fiat Ttoro", ['price'] = 40000, ['tipo'] = "carros" },
	-- ["fordka"] = { ['name'] = "Ford Ka", ['price'] = 35000, ['tipo'] = "carros" },
	-- ["fusion"] = { ['name'] = "Fusion", ['price'] = 40000, ['tipo'] = "carros" },
	-- ["golg7"] = { ['name'] = "Gol G7", ['price'] = 25000, ['tipo'] = "carros" },
	-- ["l200civil"] = { ['name'] = "Citroen 4x4", ['price'] = 104900, ['tipo'] = "suv" },
	-- ["monza"] = { ['name'] = "Monza", ['price'] = 20000, ['tipo'] = "carros" },
	-- ["p207"] = { ['name'] = "Peugeot 2007", ['price'] = 10000, ['tipo'] = "carros" },
	-- ["palio"] = { ['name'] = "Palio", ['price'] = 35000, ['tipo'] = "carros" },
	-- ["punto"] = { ['name'] = "Fiat Punto", ['price'] = 50000, ['tipo'] = "carros" },
	-- ["r1250"] = { ['name'] = "GS 150", ['price'] = 150000, ['tipo'] = "motos" },
	-- ["santafe"] = { ['name'] = "Honda Santafe", ['price'] = 100000, ['tipo'] = "carros" },
	-- ["upzinho"] = { ['name'] = "Up", ['price'] = 35000, ['tipo'] = "carros" },
	-- ["veloster"] = { ['name'] = "Veloster", ['price'] = 100000, ['tipo'] = "carros" },
	-- ["voyage"] = { ['name'] = "Voyage", ['price'] = 60000, ['tipo'] = "carros" },
	-- ["vwgolf"] = { ['name'] = "Golfzada 1.6 Peita", ['price'] = 25000, ['tipo'] = "carros" },
	-- ["vwpolo"] = { ['name'] = "Palo", ['price'] = 35000, ['tipo'] = "carros" },
	-- ["xj"] = { ['name'] = "XJ6", ['price'] = 100000, ['tipo'] = "motos" },
	-- ["xt66"] = { ['name'] = "XT66", ['price'] = 40000, ['tipo'] = "motos" },
	-- ["z1000"] = { ['name'] = "Z1000", ['price'] = 120000, ['tipo'] = "motos" },
	-- ["trailbrazer"] = { ['name'] = "TrailBrazer", ['price'] = 120000, ['tipo'] = "carros" },
	-- ["schafter6"] = { ['name'] = "schafter6", ['price'] = 120000, ['tipo'] = "carros" },

	
	-- ["blista"] = { ['name'] = "Blista", ['price'] = 60000, ['tipo'] = "carros" },
	-- ["brioso"] = { ['name'] = "Brioso", ['price'] = 35000, ['tipo'] = "carros" },
	-- ["emperor"] = { ['name'] = "Emperor", ['price'] = 50000, ['tipo'] = "carros" },
	-- ["emperor2"] = { ['name'] = "Emperor 2", ['price'] = 50000, ['tipo'] = "carros" },
	-- ["dilettante"] = { ['name'] = "Dilettante", ['price'] = 60000, ['tipo'] = "carros" },
	-- ["issi2"] = { ['name'] = "Issi2", ['price'] = 90000, ['tipo'] = "carros" },
	-- ["panto"] = { ['name'] = "Panto", ['price'] = 5000, ['tipo'] = "carros" },
	-- ["prairie"] = { ['name'] = "Prairie", ['price'] = 1000, ['tipo'] = "carros" },
	-- ["rhapsody"] = { ['name'] = "Rhapsody", ['price'] = 7000, ['tipo'] = "carros" },
	-- ["cogcabrio"] = { ['name'] = "Cogcabrio", ['price'] = 130000, ['tipo'] = "carros" },
	-- ["exemplar"] = { ['name'] = "Exemplar", ['price'] = 80000, ['tipo'] = "carros" },
	-- ["f620"] = { ['name'] = "F620", ['price'] = 55000, ['tipo'] = "carros" },
	-- ["felon"] = { ['name'] = "Felon", ['price'] = 70000, ['tipo'] = "carros" },
	-- ["ingot"] = { ['name'] = "Ingot", ['price'] = 160000, ['tipo'] = "carros" },
	-- ["jackal"] = { ['name'] = "Jackal", ['price'] = 60000, ['tipo'] = "carros" },
	-- ["oracle"] = { ['name'] = "Oracle", ['price'] = 60000, ['tipo'] = "carros" },
	-- ["oracle2"] = { ['name'] = "Oracle2", ['price'] = 80000, ['tipo'] = "carros" },
	-- ["sentinel"] = { ['name'] = "Sentinel", ['price'] = 50000, ['tipo'] = "carros" },
	-- ["sentinel2"] = { ['name'] = "Sentinel2", ['price'] = 60000, ['tipo'] = "carros" },
	-- ["windsor"] = { ['name'] = "Windsor", ['price'] = 150000, ['tipo'] = "carros" },
	-- ["windsor2"] = { ['name'] = "Windsor2", ['price'] = 170000, ['tipo'] = "carros" },
	-- ["zion"] = { ['name'] = "Zion", ['price'] = 50000, ['tipo'] = "carros" },
	-- ["zion2"] = { ['name'] = "Zion2", ['price'] = 60000, ['tipo'] = "carros" },
	-- ["blade"] = { ['name'] = "Blade", ['price'] = 110000, ['tipo'] = "carros" },
	-- ["buccaneer"] = { ['name'] = "Buccaneer", ['price'] = 130000, ['tipo'] = "carros" },
	-- ["buccaneer2"] = { ['name'] = "Buccaneer2", ['price'] = 260000, ['tipo'] = "carros" },
	-- ["primo"] = { ['name'] = "Primo", ['price'] = 130000, ['tipo'] = "carros" },
	-- ["chino"] = { ['name'] = "Chino", ['price'] = 130000, ['tipo'] = "carros" },
	-- ["coquette3"] = { ['name'] = "Coquette3", ['price'] = 195000, ['tipo'] = "carros" },
	-- ["dukes"] = { ['name'] = "Dukes", ['price'] = 150000, ['tipo'] = "carros" },
	-- ["faction"] = { ['name'] = "Faction", ['price'] = 150000, ['tipo'] = "carros" },
	-- ["faction3"] = { ['name'] = "Faction3", ['price'] = 350000, ['tipo'] = "carros" },
	-- ["gauntlet"] = { ['name'] = "Gauntlet", ['price'] = 165000, ['tipo'] = "carros" },
	-- ["gauntlet2"] = { ['name'] = "Gauntlet2", ['price'] = 165000, ['tipo'] = "carros" },
	-- ["hermes"] = { ['name'] = "Hermes", ['price'] = 280000, ['tipo'] = "carros" },
	-- ["hotknife"] = { ['name'] = "Hotknife", ['price'] = 180000, ['tipo'] = "carros" },
	-- ["moonbeam"] = { ['name'] = "Moonbeam", ['price'] = 220000, ['tipo'] = "carros" },
	-- ["moonbeam2"] = { ['name'] = "Moonbeam2", ['price'] = 250000, ['tipo'] = "carros" },
	-- ["nightshade"] = { ['name'] = "Nightshade", ['price'] = 270000, ['tipo'] = "carros" },
	-- ["picador"] = { ['name'] = "Picador", ['price'] = 150000, ['tipo'] = "carros" },
	-- ["ruiner"] = { ['name'] = "Ruiner", ['price'] = 150000, ['tipo'] = "carros" },
	-- ["sabregt"] = { ['name'] = "Sabregt", ['price'] = 260000, ['tipo'] = "carros" },
	-- ["sabregt2"] = { ['name'] = "Sabregt2", ['price'] = 150000, ['tipo'] = "carros" },
	-- ["slamvan"] = { ['name'] = "Slamvan", ['price'] = 180000, ['tipo'] = "carros" },
	-- ["slamvan3"] = { ['name'] = "Slamvan3", ['price'] = 230000, ['tipo'] = "carros" },
	-- ["stalion"] = { ['name'] = "Stalion", ['price'] = 150000, ['tipo'] = "carros" },
	-- ["stalion2"] = { ['name'] = "Stalion2", ['price'] = 150000, ['tipo'] = "carros" },
	-- ["tampa"] = { ['name'] = "Tampa", ['price'] = 170000, ['tipo'] = "carros" },
	-- ["vigero"] = { ['name'] = "Vigero", ['price'] = 170000, ['tipo'] = "carros" },
	-- ["virgo"] = { ['name'] = "Virgo", ['price'] = 150000, ['tipo'] = "carros" },
	-- ["virgo2"] = { ['name'] = "Virgo2", ['price'] = 250000, ['tipo'] = "carros" },
	-- ["virgo3"] = { ['name'] = "Virgo3", ['price'] = 180000, ['tipo'] = "carros" },
	-- ["voodoo"] = { ['name'] = "Voodoo", ['price'] = 220000, ['tipo'] = "carros" },
	-- ["voodoo2"] = { ['name'] = "Voodoo2", ['price'] = 220000, ['tipo'] = "carros" },
	-- ["yosemite"] = { ['name'] = "Yosemite", ['price'] = 350000, ['tipo'] = "carros" },
	-- ["bfinjection"] = { ['name'] = "Bfinjection", ['price'] = 80000, ['tipo'] = "carros" },
	-- ["bifta"] = { ['name'] = "Bifta", ['price'] = 190000, ['tipo'] = "carros" },
	-- ["bodhi2"] = { ['name'] = "Bodhi2", ['price'] = 170000, ['tipo'] = "carros" },
	-- ["brawler"] = { ['name'] = "Brawler", ['price'] = 250000, ['tipo'] = "carros" },
	-- ["trophytruck"] = { ['name'] = "Trophytruck", ['price'] = 400000, ['tipo'] = "carros" },
	-- ["trophytruck2"] = { ['name'] = "Trophytruck2", ['price'] = 400000, ['tipo'] = "carros" },
	-- ["dubsta3"] = { ['name'] = "Dubsta3", ['price'] = 300000, ['tipo'] = "carros" },
	-- ["mesa3"] = { ['name'] = "Mesa3", ['price'] = 200000, ['tipo'] = "carros" },
	-- ["rancherxl"] = { ['name'] = "Rancherxl", ['price'] = 220000, ['tipo'] = "carros" },
	-- ["rebel2"] = { ['name'] = "Rebel2", ['price'] = 250000, ['tipo'] = "carros" },
	-- ["riata"] = { ['name'] = "Riata", ['price'] = 250000, ['tipo'] = "carros" },
	-- ["dloader"] = { ['name'] = "Dloader", ['price'] = 150000, ['tipo'] = "carros" },
	-- ["sandking"] = { ['name'] = "Sandking", ['price'] = 400000, ['tipo'] = "carros" },
	-- ["sandking2"] = { ['name'] = "Sandking2", ['price'] = 370000, ['tipo'] = "carros" },
	-- ["baller"] = { ['name'] = "Baller", ['price'] = 150000, ['tipo'] = "carros" },
	-- ["baller2"] = { ['name'] = "Baller2", ['price'] = 160000, ['tipo'] = "carros" },
	-- ["baller3"] = { ['name'] = "Baller3", ['price'] = 175000, ['tipo'] = "carros" },
	-- ["baller4"] = { ['name'] = "Baller4", ['price'] = 185000, ['tipo'] = "carros" },
	-- ["baller5"] = { ['name'] = "Baller5", ['price'] = 270000, ['tipo'] = "carros" },
	-- ["baller6"] = { ['name'] = "Baller6", ['price'] = 280000, ['tipo'] = "carros" },
	-- ["bjxl"] = { ['name'] = "Bjxl", ['price'] = 110000, ['tipo'] = "carros" },
	-- ["cavalcade"] = { ['name'] = "Cavalcade", ['price'] = 110000, ['tipo'] = "carros" },
	-- ["cavalcade2"] = { ['name'] = "Cavalcade2", ['price'] = 130000, ['tipo'] = "carros" },
	-- ["contender"] = { ['name'] = "Contender", ['price'] = 300000, ['tipo'] = "carros" },
	-- ["dubsta"] = { ['name'] = "Dubsta", ['price'] = 210000, ['tipo'] = "carros" },
	-- ["dubsta2"] = { ['name'] = "Dubsta2", ['price'] = 240000, ['tipo'] = "carros" },
	-- ["fq2"] = { ['name'] = "Fq2", ['price'] = 110000, ['tipo'] = "carros" },
	-- ["granger"] = { ['name'] = "Granger", ['price'] = 345000, ['tipo'] = "carros" },
	-- ["gresley"] = { ['name'] = "Gresley", ['price'] = 150000, ['tipo'] = "carros" },
	-- ["habanero"] = { ['name'] = "Habanero", ['price'] = 110000, ['tipo'] = "carros" },
	-- ["seminole"] = { ['name'] = "Seminole", ['price'] = 110000, ['tipo'] = "carros" },
	-- ["serrano"] = { ['name'] = "Serrano", ['price'] = 150000, ['tipo'] = "carros" },
	-- ["xls"] = { ['name'] = "Xls", ['price'] = 150000, ['tipo'] = "carros" },
	-- ["xls2"] = { ['name'] = "Xls2", ['price'] = 350000, ['tipo'] = "carros" },
	-- ["asea"] = { ['name'] = "Asea", ['price'] = 55000, ['tipo'] = "carros" },
	-- ["asterope"] = { ['name'] = "Asterope", ['price'] = 65000, ['tipo'] = "carros" },
	-- ["cog552"] = { ['name'] = "Cog552", ['price'] = 400000, ['tipo'] = "carros" },
	-- ["cognoscenti"] = { ['name'] = "Cognoscenti", ['price'] = 280000, ['tipo'] = "carros" },
	-- ["cognoscenti2"] = { ['name'] = "Cognoscenti2", ['price'] = 400000, ['tipo'] = "carros" },
	-- ["stanier"] = { ['name'] = "Stanier", ['price'] = 60000, ['tipo'] = "carros" },
	-- ["stratum"] = { ['name'] = "Stratum", ['price'] = 90000, ['tipo'] = "carros" },
	-- ["surge"] = { ['name'] = "Surge", ['price'] = 110000, ['tipo'] = "carros" },
	-- ["tailgater"] = { ['name'] = "Tailgater", ['price'] = 110000, ['tipo'] = "carros" },
	-- ["warrener"] = { ['name'] = "Warrener", ['price'] = 90000, ['tipo'] = "carros" },
	-- ["washington"] = { ['name'] = "Washington", ['price'] = 130000, ['tipo'] = "carros" },
	-- ["alpha"] = { ['name'] = "Alpha", ['price'] = 230000, ['tipo'] = "carros" },
	-- ["banshee"] = { ['name'] = "Banshee", ['price'] = 300000, ['tipo'] = "carros" },
	-- ["bestiagts"] = { ['name'] = "Bestiagts", ['price'] = 290000, ['tipo'] = "carros" },
	-- ["blista2"] = { ['name'] = "Blista2", ['price'] = 55000, ['tipo'] = "carros" },
	-- ["blista3"] = { ['name'] = "Blista3", ['price'] = 80000, ['tipo'] = "carros" },
	-- ["buffalo"] = { ['name'] = "Buffalo", ['price'] = 300000, ['tipo'] = "carros" },
	-- ["buffalo2"] = { ['name'] = "Buffalo2", ['price'] = 300000, ['tipo'] = "carros" },
	-- ["buffalo3"] = { ['name'] = "Buffalo3", ['price'] = 300000, ['tipo'] = "carros" },
	-- ["carbonizzare"] = { ['name'] = "Carbonizzare", ['price'] = 290000, ['tipo'] = "carros" },
	-- ["comet2"] = { ['name'] = "Comet2", ['price'] = 250000, ['tipo'] = "carros" },
	-- ["comet3"] = { ['name'] = "Comet3", ['price'] = 290000, ['tipo'] = "carros" },
	-- ["comet5"] = { ['name'] = "Comet5", ['price'] = 300000, ['tipo'] = "carros" },
	-- ["coquette"] = { ['name'] = "Coquette", ['price'] = 250000, ['tipo'] = "carros" },
	-- ["elegy"] = { ['name'] = "Elegy", ['price'] = 350000, ['tipo'] = "carros" },
	-- ["elegy2"] = { ['name'] = "Elegy2", ['price'] = 355000, ['tipo'] = "carros" },
	-- ["feltzer2"] = { ['name'] = "Feltzer2", ['price'] = 255000, ['tipo'] = "carros" },
	-- ["furoregt"] = { ['name'] = "Furoregt", ['price'] = 290000, ['tipo'] = "carros" },
	-- ["fusilade"] = { ['name'] = "Fusilade", ['price'] = 210000, ['tipo'] = "carros" },
	-- ["futo"] = { ['name'] = "Futo", ['price'] = 170000, ['tipo'] = "carros" },
	-- ["jester"] = { ['name'] = "Jester", ['price'] = 150000, ['tipo'] = "carros" },
	-- ["khamelion"] = { ['name'] = "Khamelion", ['price'] = 210000, ['tipo'] = "carros" },
	-- ["kuruma"] = { ['name'] = "Kuruma", ['price'] = 330000, ['tipo'] = "carros" },
	-- ["massacro"] = { ['name'] = "Massacro", ['price'] = 330000, ['tipo'] = "carros" },
	-- ["massacro2"] = { ['name'] = "Massacro2", ['price'] = 330000, ['tipo'] = "carros" },
	-- ["ninef"] = { ['name'] = "Ninef", ['price'] = 290000, ['tipo'] = "carros" },
	-- ["ninef2"] = { ['name'] = "Ninef2", ['price'] = 290000, ['tipo'] = "carros" },
	-- ["omnis"] = { ['name'] = "Omnis", ['price'] = 240000, ['tipo'] = "carros" },
	-- ["pariah"] = { ['name'] = "Pariah", ['price'] = 500000, ['tipo'] = "carros" },
	-- ["penumbra"] = { ['name'] = "Penumbra", ['price'] = 150000, ['tipo'] = "carros" },
	-- ["raiden"] = { ['name'] = "Raiden", ['price'] = 240000, ['tipo'] = "carros" },
	-- ["rapidgt"] = { ['name'] = "Rapidgt", ['price'] = 250000, ['tipo'] = "carros" },
	-- ["rapidgt2"] = { ['name'] = "Rapidgt2", ['price'] = 300000, ['tipo'] = "carros" },
	-- ["ruston"] = { ['name'] = "Ruston", ['price'] = 370000, ['tipo'] = "carros" },
	-- ["schafter3"] = { ['name'] = "Schafter3", ['price'] = 275000, ['tipo'] = "carros" },
	-- ["schafter4"] = { ['name'] = "Schafter4", ['price'] = 275000, ['tipo'] = "carros" },
	-- ["schafter5"] = { ['name'] = "Schafter5", ['price'] = 275000, ['tipo'] = "carros" },
	-- ["schwarzer"] = { ['name'] = "Schwarzer", ['price'] = 170000, ['tipo'] = "carros" },
	-- ["sentinel3"] = { ['name'] = "Sentinel3", ['price'] = 170000, ['tipo'] = "carros" },
	-- ["seven70"] = { ['name'] = "Seven70", ['price'] = 370000, ['tipo'] = "carros" },
	-- ["specter"] = { ['name'] = "Specter", ['price'] = 320000, ['tipo'] = "carros" },
	-- ["specter2"] = { ['name'] = "Specter2", ['price'] = 355000, ['tipo'] = "carros" },
	-- ["streiter"] = { ['name'] = "Streiter", ['price'] = 250000, ['tipo'] = "carros" },
	-- ["sultan"] = { ['name'] = "Sultan", ['price'] = 210000, ['tipo'] = "carros" },
	-- ["surano"] = { ['name'] = "Surano", ['price'] = 310000, ['tipo'] = "carros" },
	-- ["tampa2"] = { ['name'] = "Tampa2", ['price'] = 200000, ['tipo'] = "carros" },
	-- ["tropos"] = { ['name'] = "Tropos", ['price'] = 170000, ['tipo'] = "carros" },
	-- ["verlierer2"] = { ['name'] = "Verlierer2", ['price'] = 380000, ['tipo'] = "carros" },
	-- ["btype2"] = { ['name'] = "Btype2", ['price'] = 460000, ['tipo'] = "carros" },
	-- ["btype3"] = { ['name'] = "Btype3", ['price'] = 390000, ['tipo'] = "carros" },
	-- ["casco"] = { ['name'] = "Casco", ['price'] = 355000, ['tipo'] = "carros" },
	-- ["cheetah"] = { ['name'] = "Cheetah", ['price'] = 425000, ['tipo'] = "carros" },
	-- ["coquette2"] = { ['name'] = "Coquette2", ['price'] = 285000, ['tipo'] = "carros" },
	-- ["feltzer3"] = { ['name'] = "Feltzer3", ['price'] = 220000, ['tipo'] = "carros" },
	-- ["gt500"] = { ['name'] = "Gt500", ['price'] = 250000, ['tipo'] = "carros" },
	-- ["infernus2"] = { ['name'] = "Infernus2", ['price'] = 250000, ['tipo'] = "carros" },
	-- ["jb700"] = { ['name'] = "Jb700", ['price'] = 220000, ['tipo'] = "carros" },
	-- ["mamba"] = { ['name'] = "Mamba", ['price'] = 300000, ['tipo'] = "carros" },
	-- ["manana"] = { ['name'] = "Manana", ['price'] = 130000, ['tipo'] = "carros" },
	-- ["monroe"] = { ['name'] = "Monroe", ['price'] = 260000, ['tipo'] = "carros" },
	-- ["peyote"] = { ['name'] = "Peyote", ['price'] = 150000, ['tipo'] = "carros" },
	-- ["pigalle"] = { ['name'] = "Pigalle", ['price'] = 250000, ['tipo'] = "carros" },
	-- ["rapidgt3"] = { ['name'] = "Rapidgt3", ['price'] = 220000, ['tipo'] = "carros" },
	-- ["retinue"] = { ['name'] = "Retinue", ['price'] = 150000, ['tipo'] = "carros" },
	-- ["stinger"] = { ['name'] = "Stinger", ['price'] = 220000, ['tipo'] = "carros" },
	-- ["stingergt"] = { ['name'] = "Stingergt", ['price'] = 230000, ['tipo'] = "carros" },
	-- ["torero"] = { ['name'] = "Torero", ['price'] = 160000, ['tipo'] = "carros" },
	-- ["tornado"] = { ['name'] = "Tornado", ['price'] = 150000, ['tipo'] = "carros" },
	-- ["tornado2"] = { ['name'] = "Tornado2", ['price'] = 160000, ['tipo'] = "carros" },
	-- ["tornado6"] = { ['name'] = "Tornado6", ['price'] = 250000, ['tipo'] = "carros" },
	-- ["turismo2"] = { ['name'] = "Turismo2", ['price'] = 250000, ['tipo'] = "carros" },
	-- ["ztype"] = { ['name'] = "Ztype", ['price'] = 400000, ['tipo'] = "carros" },
	-- ["adder"] = { ['name'] = "Adder", ['price'] = 620000, ['tipo'] = "carros" },
	-- ["autarch"] = { ['name'] = "Autarch", ['price'] = 760000, ['tipo'] = "carros" },
	-- ["banshee2"] = { ['name'] = "Banshee2", ['price'] = 370000, ['tipo'] = "carros" },
	-- ["bullet"] = { ['name'] = "Bullet", ['price'] = 400000, ['tipo'] = "carros" },
	-- ["cheetah2"] = { ['name'] = "Cheetah2", ['price'] = 240000, ['tipo'] = "carros" },
	-- ["entityxf"] = { ['name'] = "Entityxf", ['price'] = 460000, ['tipo'] = "carros" },
	-- ["fmj"] = { ['name'] = "Fmj", ['price'] = 520000, ['tipo'] = "carros" },
	-- ["gp1"] = { ['name'] = "Gp1", ['price'] = 495000, ['tipo'] = "carros" },
	-- ["infernus"] = { ['name'] = "Infernus", ['price'] = 470000, ['tipo'] = "carros" },
	-- ["nero"] = { ['name'] = "Nero", ['price'] = 450000, ['tipo'] = "carros" },
	-- ["nero2"] = { ['name'] = "Nero2", ['price'] = 480000, ['tipo'] = "carros" },
	-- ["osiris"] = { ['name'] = "Osiris", ['price'] = 460000, ['tipo'] = "carros" },
	-- ["penetrator"] = { ['name'] = "Penetrator", ['price'] = 480000, ['tipo'] = "carros" },
	-- ["pfister811"] = { ['name'] = "Pfister811", ['price'] = 530000, ['tipo'] = "carros" },
	-- ["reaper"] = { ['name'] = "Reaper", ['price'] = 620000, ['tipo'] = "carros" },
	-- ["sc1"] = { ['name'] = "Sc1", ['price'] = 495000, ['tipo'] = "carros" },
	-- ["sultanrs"] = { ['name'] = "Sultan RS", ['price'] = 450000, ['tipo'] = "carros" },
	-- ["t20"] = { ['name'] = "T20", ['price'] = 670000, ['tipo'] = "carros" },
	-- ["tempesta"] = { ['name'] = "Tempesta", ['price'] = 600000, ['tipo'] = "carros" },
	-- ["turismor"] = { ['name'] = "Turismor", ['price'] = 620000, ['tipo'] = "carros" },
	-- ["tyrus"] = { ['name'] = "Tyrus", ['price'] = 620000, ['tipo'] = "carros" },
	-- ["vacca"] = { ['name'] = "Vacca", ['price'] = 620000, ['tipo'] = "carros" },
	-- ["visione"] = { ['name'] = "Visione", ['price'] = 690000, ['tipo'] = "carros" },
	-- ["voltic"] = { ['name'] = "Voltic", ['price'] = 440000, ['tipo'] = "carros" },
	-- ["zentorno"] = { ['name'] = "Zentorno", ['price'] = 920000, ['tipo'] = "carros" },
	-- ["sadler"] = { ['name'] = "Sadler", ['price'] = 180000, ['tipo'] = "carros" },
	-- ["bison"] = { ['name'] = "Bison", ['price'] = 220000, ['tipo'] = "carros" },
	-- ["bison2"] = { ['name'] = "Bison2", ['price'] = 180000, ['tipo'] = "carros" },
	-- ["bobcatxl"] = { ['name'] = "Bobcatxl", ['price'] = 260000, ['tipo'] = "carros" },
	-- ["burrito"] = { ['name'] = "Burrito", ['price'] = 260000, ['tipo'] = "carros" },
	-- ["burrito2"] = { ['name'] = "Burrito2", ['price'] = 260000, ['tipo'] = "carros" },
	-- ["burrito3"] = { ['name'] = "Burrito3", ['price'] = 260000, ['tipo'] = "carros" },
	-- ["burrito4"] = { ['name'] = "Burrito4", ['price'] = 260000, ['tipo'] = "carros" },
	-- ["mule4"] = { ['name'] = "Burrito4", ['price'] = 260000, ['tipo'] = "carros" },
	-- ["mule"] = { ['name'] = "Burrito4", ['price'] = 260000, ['tipo'] = "carros" },
	-- ["rallytruck"] = { ['name'] = "Burrito4", ['price'] = 260000, ['tipo'] = "carros" },
	-- ["minivan"] = { ['name'] = "Minivan", ['price'] = 110000, ['tipo'] = "carros" },
	-- ["minivan2"] = { ['name'] = "Minivan2", ['price'] = 220000, ['tipo'] = "carros" },
	-- ["paradise"] = { ['name'] = "Paradise", ['price'] = 260000, ['tipo'] = "carros" },
	-- ["pony"] = { ['name'] = "Pony", ['price'] = 260000, ['tipo'] = "carros" },
	-- ["pony2"] = { ['name'] = "Pony2", ['price'] = 260000, ['tipo'] = "carros" },
	-- ["rumpo"] = { ['name'] = "Rumpo", ['price'] = 260000, ['tipo'] = "carros" },
	-- ["rumpo2"] = { ['name'] = "Rumpo2", ['price'] = 260000, ['tipo'] = "carros" },
	-- ["rumpo3"] = { ['name'] = "Rumpo3", ['price'] = 350000, ['tipo'] = "carros" },
	-- ["surfer"] = { ['name'] = "Surfer", ['price'] = 55000, ['tipo'] = "carros" },
	-- ["youga"] = { ['name'] = "Youga", ['price'] = 260000, ['tipo'] = "carros" },
	-- ["huntley"] = { ['name'] = "Huntley", ['price'] = 110000, ['tipo'] = "carros" },
	-- ["landstalker"] = { ['name'] = "Landstalker", ['price'] = 130000, ['tipo'] = "carros" },
	-- ["mesa"] = { ['name'] = "Mesa", ['price'] = 90000, ['tipo'] = "carros" },
	-- ["patriot"] = { ['name'] = "Patriot", ['price'] = 250000, ['tipo'] = "carros" },
	-- ["radi"] = { ['name'] = "Radi", ['price'] = 110000, ['tipo'] = "carros" },
	-- ["rocoto"] = { ['name'] = "Rocoto", ['price'] = 110000, ['tipo'] = "carros" },
	-- ["tyrant"] = { ['name'] = "Tyrant", ['price'] = 690000, ['tipo'] = "carros" },
	-- ["entity2"] = { ['name'] = "Entity2", ['price'] = 550000, ['tipo'] = "carros" },
	-- ["cheburek"] = { ['name'] = "Cheburek", ['price'] = 170000, ['tipo'] = "carros" },
	-- ["hotring"] = { ['name'] = "Hotring", ['price'] = 300000, ['tipo'] = "carros" },
	-- ["jester3"] = { ['name'] = "Jester3", ['price'] = 345000, ['tipo'] = "carros" },
	-- ["flashgt"] = { ['name'] = "Flashgt", ['price'] = 370000, ['tipo'] = "carros" },
	-- ["ellie"] = { ['name'] = "Ellie", ['price'] = 320000, ['tipo'] = "carros" },
	-- ["michelli"] = { ['name'] = "Michelli", ['price'] = 160000, ['tipo'] = "carros" },
	-- ["fagaloa"] = { ['name'] = "Fagaloa", ['price'] = 320000, ['tipo'] = "carros" },
	-- ["dominator"] = { ['name'] = "Dominator", ['price'] = 230000, ['tipo'] = "carros" },
	-- ["dominator2"] = { ['name'] = "Dominator2", ['price'] = 230000, ['tipo'] = "carros" },
	-- ["dominator3"] = { ['name'] = "Dominator3", ['price'] = 370000, ['tipo'] = "carros" },
	-- ["issi3"] = { ['name'] = "Issi3", ['price'] = 190000, ['tipo'] = "carros" },
	-- ["taipan"] = { ['name'] = "Taipan", ['price'] = 620000, ['tipo'] = "carros" },
	-- ["gb200"] = { ['name'] = "Gb200", ['price'] = 195000, ['tipo'] = "carros" },
	-- ["stretch"] = { ['name'] = "Stretch", ['price'] = 520000, ['tipo'] = "carros" },
	-- ["guardian"] = { ['name'] = "Guardian", ['price'] = 540000, ['tipo'] = "carros" },
	-- ["kamacho"] = { ['name'] = "Kamacho", ['price'] = 460000, ['tipo'] = "carros" },
	-- ["neon"] = { ['name'] = "Neon", ['price'] = 370000, ['tipo'] = "carros" },
	-- ["cyclone"] = { ['name'] = "Cyclone", ['price'] = 920000, ['tipo'] = "carros" },
	-- ["italigtb"] = { ['name'] = "Italigtb", ['price'] = 600000, ['tipo'] = "carros" },
	-- ["italigtb2"] = { ['name'] = "Italigtb2", ['price'] = 610000, ['tipo'] = "carros" },
	-- ["vagner"] = { ['name'] = "Vagner", ['price'] = 680000, ['tipo'] = "carros" },
	-- ["xa21"] = { ['name'] = "Xa21", ['price'] = 630000, ['tipo'] = "carros" },
	-- ["tezeract"] = { ['name'] = "Tezeract", ['price'] = 920000, ['tipo'] = "carros" },
	-- ["prototipo"] = { ['name'] = "Prototipo", ['price'] = 1030000, ['tipo'] = "carros" },
	-- ["patriot2"] = { ['name'] = "Patriot2", ['price'] = 550000, ['tipo'] = "carros" },
	-- ["swinger"] = { ['name'] = "Swinger", ['price'] = 250000, ['tipo'] = "carros" },
	-- ["clique"] = { ['name'] = "Clique", ['price'] = 360000, ['tipo'] = "carros" },
	-- ["deveste"] = { ['name'] = "Deveste", ['price'] = 920000, ['tipo'] = "carros" },
	-- ["deviant"] = { ['name'] = "Deviant", ['price'] = 370000, ['tipo'] = "carros" },
	-- ["impaler"] = { ['name'] = "Impaler", ['price'] = 320000, ['tipo'] = "carros" },
	-- ["italigto"] = { ['name'] = "Italigto", ['price'] = 800000, ['tipo'] = "carros" },
	-- ["schlagen"] = { ['name'] = "Schlagen", ['price'] = 690000, ['tipo'] = "carros" },
	-- ["toros"] = { ['name'] = "Toros", ['price'] = 520000, ['tipo'] = "carros" },
	-- ["tulip"] = { ['name'] = "Tulip", ['price'] = 320000, ['tipo'] = "carros" },
	-- ["vamos"] = { ['name'] = "Vamos", ['price'] = 320000, ['tipo'] = "carros" },
	-- ["freecrawler"] = { ['name'] = "Freecrawler", ['price'] = 350000, ['tipo'] = "carros" },
	-- ["fugitive"] = { ['name'] = "Fugitive", ['price'] = 50000, ['tipo'] = "carros" },
	-- ["glendale"] = { ['name'] = "Glendale", ['price'] = 70000, ['tipo'] = "carros" },
	-- ["intruder"] = { ['name'] = "Intruder", ['price'] = 60000, ['tipo'] = "carros" },
	-- ["le7b"] = { ['name'] = "Le7b", ['price'] = 700000, ['tipo'] = "carros" },
	-- ["lurcher"] = { ['name'] = "Lurcher", ['price'] = 150000, ['tipo'] = "carros" },
	-- ["lynx"] = { ['name'] = "Lynx", ['price'] = 370000, ['tipo'] = "carros" },
	-- ["phoenix"] = { ['name'] = "Phoenix", ['price'] = 250000, ['tipo'] = "carros" },
	-- ["premier"] = { ['name'] = "Premier", ['price'] = 35000, ['tipo'] = "carros" },
	-- ["raptor"] = { ['name'] = "Raptor", ['price'] = 300000, ['tipo'] = "carros" },
	-- ["sheava"] = { ['name'] = "Sheava", ['price'] = 700000, ['tipo'] = "carros" },
	-- ["z190"] = { ['name'] = "Z190", ['price'] = 350000, ['tipo'] = "carros" },
	


	





	




	-- --MOTOS
	
	-- ["akuma"] = { ['name'] = "Akuma", ['price'] = 500000, ['tipo'] = "motos" },
	-- ["avarus"] = { ['name'] = "Avarus", ['price'] = 440000, ['tipo'] = "motos" },
	-- ["bagger"] = { ['name'] = "Bagger", ['price'] = 300000, ['tipo'] = "motos" },
	-- ["bati"] = { ['name'] = "Bati", ['price'] = 370000, ['tipo'] = "motos" },
	-- ["bati2"] = { ['name'] = "Bati2", ['price'] = 300000, ['tipo'] = "motos" },
	-- ["bf400"] = { ['name'] = "Bf400", ['price'] = 450000, ['tipo'] = "motos" },
	-- ["carbonrs"] = { ['name'] = "Carbonrs", ['price'] = 370000, ['tipo'] = "motos" },
	-- ["chimera"] = { ['name'] = "Chimera", ['price'] = 345000, ['tipo'] = "motos" },
	-- ["cliffhanger"] = { ['name'] = "Cliffhanger", ['price'] = 310000, ['tipo'] = "motos" },
	-- ["daemon2"]  = { ['name'] = "Daemon2", ['price'] = 240000, ['tipo'] = "motos" },
	-- ["defiler"] = { ['name'] = "Defiler", ['price'] = 460000, ['tipo'] = "motos" },
	-- ["diablous"] = { ['name'] = "Diablous", ['price'] = 430000, ['tipo'] = "motos" },
	-- ["diablous2"] = { ['name'] = "Diablous2", ['price'] = 460000, ['tipo'] = "motos" },
	-- ["double"] = { ['name'] = "Double", ['price'] = 370000, ['tipo'] = "motos" },
	-- ["enduro"] = { ['name'] = "Enduro", ['price'] = 195000, ['tipo'] = "motos" },
	-- ["esskey"] = { ['name'] = "Esskey", ['price'] = 320000, ['tipo'] = "motos" },
	-- ["faggio"] = { ['name'] = "Faggio", ['price'] = 4000, ['tipo'] = "motos" },
	-- ["faggio2"] = { ['name'] = "Faggio2", ['price'] = 5000, ['tipo'] = "motos" },
	-- ["faggio3"] = { ['name'] = "Faggio3", ['price'] = 5000, ['tipo'] = "motos" },
	-- ["fcr"] = { ['name'] = "Fcr", ['price'] = 390000, ['tipo'] = "motos" },
	-- ["fcr2"] = { ['name'] = "Fcr2", ['price'] = 390000, ['tipo'] = "motos" },
	-- ["gargoyle"] = { ['name'] = "Gargoyle", ['price'] = 345000, ['tipo'] = "motos" },
	-- ["hakuchou"] = { ['name'] = "Hakuchou", ['price'] = 380000, ['tipo'] = "motos" },
	-- ["hakuchou2"] = { ['name'] = "Hakuchou2", ['price'] = 550000, ['tipo'] = "motos" },
	-- ["hexer"] = { ['name'] = "Hexer", ['price'] = 250000, ['tipo'] = "motos" },
	-- ["innovation"] = { ['name'] = "Innovation", ['price'] = 250000, ['tipo'] = "motos" },
	-- ["lectro"] = { ['name'] = "Lectro", ['price'] = 380000, ['tipo'] = "motos" },
	-- ["manchez"] = { ['name'] = "Manchez", ['price'] = 355000, ['tipo'] = "motos" },
	-- ["nemesis"] = { ['name'] = "Nemesis", ['price'] = 345000, ['tipo'] = "motos" },
	-- ["nightblade"] = { ['name'] = "Nightblade", ['price'] = 415000, ['tipo'] = "motos" },
	-- ["pcj"] = { ['name'] = "Pcj", ['price'] = 230000, ['tipo'] = "motos" },
	-- ["ruffian"] = { ['name'] = "Ruffian", ['price'] = 345000, ['tipo'] = "motos" },
	-- ["sanchez"] = { ['name'] = "Sanchez", ['price'] = 185000, ['tipo'] = "motos" },
	-- ["sanchez2"] = { ['name'] = "Sanchez2", ['price'] = 185000, ['tipo'] = "motos" },
	-- ["sovereign"] = { ['name'] = "Sovereign", ['price'] = 285000, ['tipo'] = "motos" },
	-- ["thrust"] = { ['name'] = "Thrust", ['price'] = 375000, ['tipo'] = "motos" },
	-- ["vader"] = { ['name'] = "Vader", ['price'] = 345000, ['tipo'] = "motos" },
	-- ["vindicator"] = { ['name'] = "Vindicator", ['price'] = 340000, ['tipo'] = "motos" },
	-- ["vortex"] = { ['name'] = "Vortex", ['price'] = 375000, ['tipo'] = "motos" },
	-- ["wolfsbane"] = { ['name'] = "Wolfsbane", ['price'] = 290000, ['tipo'] = "motos" },
	-- ["zombiea"] = { ['name'] = "Zombiea", ['price'] = 290000, ['tipo'] = "motos" },
	-- ["zombieb"] = { ['name'] = "Zombieb", ['price'] = 300000, ['tipo'] = "motos" },
	-- ["shotaro"] = { ['name'] = "Shotaro", ['price'] = 1000000, ['tipo'] = "motos" },
	-- ["ratbike"] = { ['name'] = "Ratbike", ['price'] = 230000, ['tipo'] = "motos" },
	-- ["blazer"] = { ['name'] = "Blazer", ['price'] = 230000, ['tipo'] = "motos" },
	-- ["blazer4"] = { ['name'] = "Blazer4", ['price'] = 370000, ['tipo'] = "motos" },

	-- --TRABALHO
	-- ["pbus"] = { ['name'] = "Onibus Militar", ['price'] = 1000, ['tipo'] = "work" },
	-- ["mi4"] = { ['name'] = "Onibus", ['price'] = 1000, ['tipo'] = "work" },
	-- ["bus"] = { ['name'] = "Onibus", ['price'] = 1000, ['tipo'] = "work" },
	-- ["hiluxbaep"] = { ['name'] = "Hilux BAEP", ['price'] = 1000, ['tipo'] = "work" },
	-- ["trail15baep"] = { ['name'] = "Trail BAEP", ['price'] = 1000, ['tipo'] = "work" },
	-- ["blazerft"] = { ['name'] = "Blazer FT", ['price'] = 1000, ['tipo'] = "work" },
	-- ["sw4ft"] = { ['name'] = "SW4 FT", ['price'] = 1000, ['tipo'] = "work" },
	-- ["sw4tatico"] = { ['name'] = "SW4 Tatico", ['price'] = 1000, ['tipo'] = "work" },
	-- ["sw4ft2019"] = { ['name'] = "SW4 Op. FT", ['price'] = 1000, ['tipo'] = "work" },
	-- ["as350"] = { ['name'] = "Helicóptero Aguia", ['price'] = 1000, ['tipo'] = "work" },
	-- ["as350pc"] = { ['name'] = "Helicóptero Pelicano", ['price'] = 1000, ['tipo'] = "work" },
	-- ["rocammoto"] = { ['name'] = "XT ROCAM", ['price'] = 1000, ['tipo'] = "work" },
	-- ["spacerp"] = { ['name'] = "Space PMESP", ['price'] = 1000, ['tipo'] = "work" },
	-- ["police"] = { ['name'] = "Spin PMESP", ['price'] = 1000, ['tipo'] = "work" },
	-- ["xrer"] = { ['name'] = "XRE ROCAM", ['price'] = 1000, ['tipo'] = "work" },
	-- ["tigerrocam"] = { ['name'] = "Tiger ROCAM", ['price'] = 1000, ['tipo'] = "work" },
	-- ["blazer07"] = { ['name'] = "Blazer ROTA", ['price'] = 1000, ['tipo'] = "work" },
	-- ["hiluxrota"] = { ['name'] = "Hilux ROTA", ['price'] = 1000, ['tipo'] = "work" },
	-- ["riot"] = { ['name'] = "Blindado ROTA", ['price'] = 1000, ['tipo'] = "work" },
    -- ["Blazerr"] = { ['name'] = "Blazer PC", ['price'] = 1000, ['tipo'] = "work" },
    -- ["trailpc"] = { ['name'] = "Trail Garra", ['price'] = 1000, ['tipo'] = "work" },
    -- ["as350prf"] = { ['name'] = "Helicóptero PRF", ['price'] = 1000, ['tipo'] = "work" },
    -- ["corollaprf"] = { ['name'] = "Corolla PRF", ['price'] = 1000, ['tipo'] = "work" },
    -- ["trailprf"] = { ['name'] = "Trail PRF", ['price'] = 1000, ['tipo'] = "work" },
    -- ["xreprf"] = { ['name'] = "XRE PRF", ['price'] = 1000, ['tipo'] = "work" },
    -- ["ambulance"] = { ['name'] = "Ambulância SAMU", ['price'] = 1000, ['tipo'] = "work" },
    -- ["samumav"] = { ['name'] = "Helicóptero SAMU", ['price'] = 1000, ['tipo'] = "work" },
	-- ["samu1"] = { ['name'] = "Ambulância Samu", ['price'] = 1000, ['tipo'] = "work" },
    -- ["motosamu"] = { ['name'] = "MOTO SAMU", ['price'] = 1000, ['tipo'] = "work" },

	-- ["paramedicoambu"] = { ['name'] = "Ambulância", ['price'] = 1000, ['tipo'] = "work" },
	-- ["paramedicocharger2014"] = { ['name'] = "Dodge Charger 2014", ['price'] = 1000, ['tipo'] = "work" },
	-- ["paramedicoheli"] = { ['name'] = "Paramédico Helicóptero", ['price'] = 1000, ['tipo'] = "work" },

	-- ["ballas"] = { ['name'] = "Dodge Charger Roxos", ['price'] = 1000, ['tipo'] = "work" },
	-- ["groove"] = { ['name'] = "Dodge Charger Verdes", ['price'] = 1000, ['tipo'] = "work" },
	-- ["varros"] = { ['name'] = "Dodge Charger Azul", ['price'] = 1000, ['tipo'] = "work" },
	-- ["aztecas"] = { ['name'] = "Dodge Charger Vermelhos", ['price'] = 1000, ['tipo'] = "work" },

	-- ["coach"] = { ['name'] = "Coach", ['price'] = 1000, ['tipo'] = "work" },
	-- ["tug"] = { ['name'] = "Tug", ['price'] = 1000, ['tipo'] = "work" },
	-- ["bus"] = { ['name'] = "Ônibus", ['price'] = 1000, ['tipo'] = "work" },
	-- ["flatbed"] = { ['name'] = "Reboque", ['price'] = 1000, ['tipo'] = "work" },
	-- ["towtruck"] = { ['name'] = "Towtruck", ['price'] = 1000, ['tipo'] = "work" },
	-- ["towtruck2"] = { ['name'] = "Towtruck2", ['price'] = 1000, ['tipo'] = "work" },
	-- ["ratloader"] = { ['name'] = "Caminhão", ['price'] = 1000, ['tipo'] = "work" },
	-- ["ratloader2"] = { ['name'] = "Ratloader2", ['price'] = 1000, ['tipo'] = "work" },
	-- ["rubble"] = { ['name'] = "Caminhão", ['price'] = 1000, ['tipo'] = "work" },
	-- ["taxi"] = { ['name'] = "Taxi", ['price'] = 1000, ['tipo'] = "work" },
	-- ["boxville4"] = { ['name'] = "Caminhão", ['price'] = 1000, ['tipo'] = "work" },
	-- ["trash2"] = { ['name'] = "Caminhão", ['price'] = 1000, ['tipo'] = "work" },
	-- ["tiptruck"] = { ['name'] = "Tiptruck", ['price'] = 1000, ['tipo'] = "work" },
	-- ["scorcher"] = { ['name'] = "Scorcher", ['price'] = 1000, ['tipo'] = "work" },
	-- ["tribike"] = { ['name'] = "Tribike", ['price'] = 1000, ['tipo'] = "work" },
	-- ["tribike2"] = { ['name'] = "Tribike2", ['price'] = 1000, ['tipo'] = "work" },
	-- ["tribike3"] = { ['name'] = "Tribike3", ['price'] = 1000, ['tipo'] = "work" },
	-- ["fixter"] = { ['name'] = "Fixter", ['price'] = 1000, ['tipo'] = "work" },
	-- ["cruiser"] = { ['name'] = "Cruiser", ['price'] = 1000, ['tipo'] = "work" },
	-- ["bmx"] = { ['name'] = "Bmx", ['price'] = 1000, ['tipo'] = "work" },
	-- ["dinghy"] = { ['name'] = "Dinghy", ['price'] = 1000, ['tipo'] = "work" },
	-- ["jetmax"] = { ['name'] = "Jetmax", ['price'] = 1000, ['tipo'] = "work" },
	-- ["marquis"] = { ['name'] = "Marquis", ['price'] = 1000, ['tipo'] = "work" },
	-- ["seashark3"] = { ['name'] = "Seashark3", ['price'] = 1000, ['tipo'] = "work" },
	-- ["speeder"] = { ['name'] = "Speeder", ['price'] = 1000, ['tipo'] = "work" },
	-- ["speeder2"] = { ['name'] = "Speeder2", ['price'] = 1000, ['tipo'] = "work" },
	-- ["squalo"] = { ['name'] = "Squalo", ['price'] = 1000, ['tipo'] = "work" },
	-- ["suntrap"] = { ['name'] = "Suntrap", ['price'] = 1000, ['tipo'] = "work" },
	-- ["toro"] = { ['name'] = "Toro", ['price'] = 1000, ['tipo'] = "work" },
	-- ["toro2"] = { ['name'] = "Toro2", ['price'] = 1000, ['tipo'] = "work" },
	-- ["tropic"] = { ['name'] = "Tropic", ['price'] = 1000, ['tipo'] = "work" },
	-- ["tropic2"] = { ['name'] = "Tropic2", ['price'] = 1000, ['tipo'] = "work" },
	-- ["phantom"] = { ['name'] = "Phantom", ['price'] = 1000, ['tipo'] = "work" },
	-- ["packer"] = { ['name'] = "Packer", ['price'] = 1000, ['tipo'] = "work" },
	-- ["supervolito"] = { ['name'] = "Supervolito", ['price'] = 1000, ['tipo'] = "work" },
	-- ["supervolito2"] = { ['name'] = "Supervolito2", ['price'] = 1000, ['tipo'] = "work" },
	-- ["cuban800"] = { ['name'] = "Cuban800", ['price'] = 1000, ['tipo'] = "work" },
	-- ["mammatus"] = { ['name'] = "Mammatus", ['price'] = 1000, ['tipo'] = "work" },
	-- ["vestra"] = { ['name'] = "Vestra", ['price'] = 1000, ['tipo'] = "work" },
	-- ["velum2"] = { ['name'] = "Velum2", ['price'] = 1000, ['tipo'] = "work" },
	-- ["buzzard2"] = { ['name'] = "Buzzard2", ['price'] = 1000, ['tipo'] = "work" },
	-- ["frogger"] = { ['name'] = "Frogger", ['price'] = 1000, ['tipo'] = "work" },
	-- ["swift"] = { ['name'] = "Swift", ['price'] = 1000, ['tipo'] = "work" },
	-- ["maverick"] = { ['name'] = "Maverick", ['price'] = 1000, ['tipo'] = "work" },
	-- ["tanker2"] = { ['name'] = "Gas", ['price'] = 1000, ['tipo'] = "work" },
	-- ["armytanker"] = { ['name'] = "Diesel", ['price'] = 1000, ['tipo'] = "work" },
	-- ["tvtrailer"] = { ['name'] = "Show", ['price'] = 1000, ['tipo'] = "work" },
	-- ["trailerlogs"] = { ['name'] = "Woods", ['price'] = 1000, ['tipo'] = "work" },
	-- ["tr4"] = { ['name'] = "Cars", ['price'] = 1000, ['tipo'] = "work" },
	-- ["speedo"] = { ['name'] = "Speedo", ['price'] = 200000, ['tipo'] = "work" },
	-- ["primo2"] = { ['name'] = "Primo2", ['price'] = 200000, ['tipo'] = "work" },
	-- ["faction2"] = { ['name'] = "Faction2", ['price'] = 200000, ['tipo'] = "work" },
	-- ["chino2"] = { ['name'] = "Chino2", ['price'] = 200000, ['tipo'] = "work" },
	-- ["tornado5"] = { ['name'] = "Tornado5", ['price'] = 200000, ['tipo'] = "work" },
	-- ["daemon"] = { ['name'] = "Daemon", ['price'] = 200000, ['tipo'] = "work" },
	-- ["sanctus"] = { ['name'] = "Sanctus", ['price'] = 200000, ['tipo'] = "work" },
	-- ["gburrito"] = { ['name'] = "GBurrito", ['price'] = 200000, ['tipo'] = "work" },
	-- ["slamvan2"] = { ['name'] = "Slamvan2", ['price'] = 200000, ['tipo'] = "work" },
	-- ["stafford"] = { ['name'] = "Stafford", ['price'] = 200000, ['tipo'] = "work" },
	-- ["cog55"] = { ['name'] = "Cog55", ['price'] = 200000, ['tipo'] = "work" },
	-- ["superd"] = { ['name'] = "Superd", ['price'] = 200000, ['tipo'] = "work" },
	-- ["btype"] = { ['name'] = "Btype", ['price'] = 200000, ['tipo'] = "work" },
	-- ["tractor2"] = { ['name'] = "Tractor2", ['price'] = 1000, ['tipo'] = "work" },
	-- ["rebel"] = { ['name'] = "Rebel", ['price'] = 1000, ['tipo'] = "work" },
	-- ["flatbed3"] = { ['name'] = "flatbed3", ['price'] = 1000, ['tipo'] = "work" },
	-- ["volatus"] = { ['name'] = "Volatus", ['price'] = 1000000, ['tipo'] = "work" },
	-- ["cargobob2"] = { ['name'] = "Cargo Bob", ['price'] = 1000000, ['tipo'] = "work" },
	-- ["dinghy4"] = { ['name'] = "Superd", ['price'] = 200000, ['tipo'] = "work" },
	-- ["revolter"] = { ['name'] = "Revolter", ['price'] = 200000, ['tipo'] = "work" },
    -- ["frogger2"] = { ['name'] = "Frogger2", ['price'] = 200000, ['tipo'] = "work" },
	
	--IMPORTADOS

	-- ["dodgechargersrt"] = { ['name'] = "Dodge Charger SRT", ['price'] = 2000000, ['tipo'] = "import" },
	-- ["audirs6"] = { ['name'] = "Audi RS6", ['price'] = 1500000, ['tipo'] = "import" },
	-- ["bmwm3f80"] = { ['name'] = "BMW M3 F80", ['price'] = 1000000, ['tipo'] = "import" },
	-- ["bmwm4gts"] = { ['name'] = "BMW M4 GTS", ['price'] = 1300000, ['tipo'] = "import" },
	-- ["mazdarx7"] = { ['name'] = "Mazda RX7", ['price'] = 2000000, ['tipo'] = "import" },
	-- ["fordmustang"] = { ['name'] = "Ford Mustang", ['price'] = 1700000, ['tipo'] = "import" },
	-- ["lancerevolution9"] = { ['name'] = "Lancer Evolution 9", ['price'] = 1500000, ['tipo'] = "import" },
	-- ["lancerevolutionx"] = { ['name'] = "Lancer Evolution X", ['price'] = 1700000, ['tipo'] = "import" },
	-- ["focusrs"] = { ['name'] = "Ford Focus", ['price'] = 60000, ['tipo'] = "import" },
	-- ["nissangtr"] = { ['name'] = "Nissan GTR", ['price'] = 2200000, ['tipo'] = "exclusive" },
	-- ["lamborghinihuracan"] = { ['name'] = "Lamborghini Huracan", ['price'] = 2500000, ['tipo'] = "import" },
	-- ["ferrariitalia"] = { ['name'] = "Ferrari Italia 478", ['price'] = 3000000, ['tipo'] = "import" },
	-- ["mercedesa45"] = { ['name'] = "Mercedes A45", ['price'] = 1200000, ['tipo'] = "import" },
	-- ["nissangtrnismo"] = { ['name'] = "Nissan GTR Nismo", ['price'] = 2500000, ['tipo'] = "exclusive" },
	-- ["audirs7"] = { ['name'] = "Audi RS7", ['price'] = 1076000, ['tipo'] = "import" },
	-- ["nissanskyliner34"] = { ['name'] = "Nissan Skyline R34", ['price'] = 2500000, ['tipo'] = "import" },
	-- ["nissan370z"] = { ['name'] = "Nissan 370Z", ['price'] = 1500000, ['tipo'] = "import" },
	-- ["hondafk8"] = { ['name'] = "Honda FK8", ['price'] = 950000, ['tipo'] = "import" },
	-- ["mustangmach1"] = { ['name'] = "Mustang Mach 1", ['price'] = 850000, ['tipo'] = "import" },
	-- ["porsche930"] = { ['name'] = "Porsche 930", ['price'] = 1300000, ['tipo'] = "import" },
	-- ["teslaprior"] = { ['name'] = "Tesla Prior", ['price'] = 3500000, ['tipo'] = "import" },
	-- ["type263"] = { ['name'] = "Kombi 63", ['price'] = 500000, ['tipo'] = "import" },
	-- ["beetle74"] = { ['name'] = "Fusca 74", ['price'] = 500000, ['tipo'] = "import" },
	-- ["fe86"] = { ['name'] = "Escorte", ['price'] = 500000, ['tipo'] = "import" },		

	--EXCLUSIVE 
	
	-- ["i8"] = { ['name'] = "BMW i8", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["raptor2017"] = { ['name'] = "Ford Raptor 2017", ['price'] = 1000000, ['tipo'] = "exclusive" },	
	-- ["bc"] = { ['name'] = "Pagani Huayra", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["toyotasupra"] = { ['name'] = "Toyota Supra", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["488gtb"] = { ['name'] = "Ferrari 488 GTB", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["fxxkevo"] = { ['name'] = "Ferrari FXXK Evo", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["m2"] = { ['name'] = "BMW M2", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["p1"] = { ['name'] = "Mclaren P1", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["bme6tun"] = { ['name'] = "BMW M5", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["aperta"] = { ['name'] = "La Ferrari", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["bettle"] = { ['name'] = "New Bettle", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["senna"] = { ['name'] = "Mclaren Senna", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["rmodx6"] = { ['name'] = "BMW X6", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["bnteam"] = { ['name'] = "Bentley", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["rmodlp770"] = { ['name'] = "Lamborghini Centenario", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["divo"] = { ['name'] = "Buggati Divo", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["s15"] = { ['name'] = "Nissan Silvia S15", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["amggtr"] = { ['name'] = "Mercedes AMG", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["slsamg"] = { ['name'] = "Mercedes SLS", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["lamtmc"] = { ['name'] = "Lamborghini Terzo", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["vantage"] = { ['name'] = "Aston Martin Vantage", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["urus"] = { ['name'] = "Lamborghini Urus", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["amarok"] = { ['name'] = "VW Amarok", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["g65amg"] = { ['name'] = "Mercedes G65", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["celta"] = { ['name'] = "Celta Paredão", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["palameila"] = { ['name'] = "Porsche ", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["rsvr16"] = { ['name'] = "Ranger Rover", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["veneno"] = { ['name'] = "Lamborghini Veneno", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["eleanor"] = { ['name'] = "Mustang Eleanor", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["rmodamgc63"] = { ['name'] = "Mercedes AMG C63", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["19ramdonk"] = { ['name'] = "Dodge Ram Donk", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["silv86"] = { ['name'] = "Silverado Donk", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["ninjah2"] = { ['name'] = "Ninja H2", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["70camarofn"] = { ['name'] = "camaro Z28 1970", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["agerars"] = { ['name'] = "Koenigsegg Agera RS", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["fc15"] = { ['name'] = "Ferrari California", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["msohs"] = { ['name'] = "Mclaren 688 HS", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["gt17"] = { ['name'] = "Ford GT 17", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["19ftype"] = { ['name'] = "Jaguar F-Type", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["bbentayga"] = { ['name'] = "Bentley Bentayga", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["nissantitan17"] = { ['name'] = "Nissan Titan 2017", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["911r"] = { ['name'] = "Porsche 911R", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["trr"] = { ['name'] = "KTM TRR", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["bmws"] = { ['name'] = "BMW S1000", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["cb500x"] = { ['name'] = "Honda CB500", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["hcbr17"] = { ['name'] = "Honda CBR17", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["defiant"] = { ['name'] = "AMC Javelin 72", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["f12tdf"] = { ['name'] = "Ferrari F12 TDF", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["71gtx"] = { ['name'] = "Plymouth 71 GTX", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["porsche992"] = { ['name'] = "Porsche 992", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["18macan"] = { ['name'] = "Porsche Macan", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["m6e63"] = { ['name'] = "BMW M6 E63", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["africat"] = { ['name'] = "Honda CRF 1000", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["regera"] = { ['name'] = "Koenigsegg Regera", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["180sx"] = { ['name'] = "Nissan 180SX", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["filthynsx"] = { ['name'] = "Honda NSX", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["2018zl1"] = { ['name'] = "Camaro ZL1", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["eclipse"] = { ['name'] = "Mitsubishi Eclipse", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["lp700r"] = { ['name'] = "Lamborghini LP700R", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["db11"] = { ['name'] = "Aston Martin DB11", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["SVR14"] = { ['name'] = "Ranger Rover", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["evoque"] = { ['name'] = "Ranger Rover Evoque", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["Bimota"] = { ['name'] = "Ducati Bimota", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["r8ppi"] = { ['name'] = "Audi R8 PPI Razor", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["20r1"] = { ['name'] = "Yamaha YZF R1", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["mt03"] = { ['name'] = "Yamaha MT 03", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["yzfr125"] = { ['name'] = "Yamaha YZF R125", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["pistas"] = { ['name'] = "Ferrari Pista", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["bobbes2"] = { ['name'] = "Harley D. Bobber S", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["bobber"] = { ['name'] = "Harley D. Bobber ", ['price'] = 1000000, ['tipo'] = "exclusive" },
	-- ["911tbs"] = { ['name'] = "Porsche 911S", ['price'] = 1000000, ['tipo'] = "exclusive" },		
	-- ["rc"] = { ['name'] = "KTM RC", ['price'] = 1000000, ['tipo'] = "exclusive" },		
	-- ["zx10r"] = { ['name'] = "Kawasaki ZX10R", ['price'] = 1000000, ['tipo'] = "exclusive" },		
	-- ["fox600lt"] = { ['name'] = "McLaren 600LT", ['price'] = 1000000, ['tipo'] = "exclusive" },		
	-- ["foxbent1"] = { ['name'] = "Bentley Liter 1931", ['price'] = 1000000, ['tipo'] = "exclusive" },		
	-- ["foxevo"] = { ['name'] = "Lamborghini EVO", ['price'] = 1000000, ['tipo'] = "exclusive" },		
	-- ["jeepg"] = { ['name'] = "Jeep Gladiator", ['price'] = 1000000, ['tipo'] = "exclusive" },		
	-- ["foxharley1"] = { ['name'] = "Harley-Davidson Softail F.B.", ['price'] = 1000000, ['tipo'] = "exclusive" },		
	-- ["foxharley2"] = { ['name'] = "2016 Harley-Davidson Road Glide", ['price'] = 1000000, ['tipo'] = "exclusive" },		
	-- ["foxleggera"] = { ['name'] = "Aston Martin Leggera", ['price'] = 1000000, ['tipo'] = "exclusive" },		
	-- ["foxrossa"] = { ['name'] = "Ferrari Rossa", ['price'] = 1000000, ['tipo'] = "exclusive" },		
	-- ["foxshelby"] = { ['name'] = "Ford Shelby GT500", ['price'] = 1000000, ['tipo'] = "exclusive" },		
	-- ["foxsian"] = { ['name'] = "Lamborghini Sian", ['price'] = 1000000, ['tipo'] = "exclusive" },		
	-- ["foxsterrato"] = { ['name'] = "Lamborghini Sterrato", ['price'] = 1000000, ['tipo'] = "exclusive" },		
	-- ["foxsupra"] = { ['name'] = "Toyota Supra", ['price'] = 1000000, ['tipo'] = "exclusive" },		
	-- ["m6x6"] = { ['name'] = "Mercedes Benz 6x6", ['price'] = 1000000, ['tipo'] = "exclusive" },		
	-- ["m6gt3"] = { ['name'] = "BMW M6 GT3", ['price'] = 1000000, ['tipo'] = "exclusive" },		
	-- ["w900"] = { ['name'] = "Kenworth W900", ['price'] = 1000000, ['tipo'] = "exclusive" },

	-- ["pounder"] = { ['name'] = "Pounder", ['price'] = 1000000, ['tipo'] = "work" },
}

--[[local vehglobal = {
    ["Boxville"] = { ['name'] = "Boxville", ['price'] = 0, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/2/29/Boxville4.png"},
	["blista"] = { ['name'] = "Blista", ['price'] = 60000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/58/Blista.png"},
	["brioso"] = { ['name'] = "Brioso", ['price'] = 40000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/6/6f/Brioso.png"},
	["emperor"] = { ['name'] = "Emperor", ['price'] = 50000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/c/c5/Emperor.png"},
	["emperor2"] = { ['name'] = "Emperor 2", ['price'] = 50000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/1/16/Emperor2.png"},
	["dilettante"] = { ['name'] = "Dilettante", ['price'] = 60000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/b/b9/Dilettante.png"},
	["issi2"] = { ['name'] = "Issi2", ['price'] = 200000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/0/0b/Issi2.png"},
	["panto"] = { ['name'] = "Panto", ['price'] = 15000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/e/e5/Panto.png"},
	["prairie"] = { ['name'] = "Prairie", ['price'] = 1000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/3/3d/Prairie.png"},
	["rhapsody"] = { ['name'] = "Rhapsody", ['price'] = 10000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/e/e2/Rhapsody.png"},
	["cogcabrio"] = { ['name'] = "Cogcabrio", ['price'] = 130000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/1/1b/CogCabrio.png"},
	["exemplar"] = { ['name'] = "Exemplar", ['price'] = 80000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/a/a4/Exemplar.png"},
	["f620"] = { ['name'] = "F620", ['price'] = 55000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/2/21/F620.png"},
	["felon"] = { ['name'] = "Felon", ['price'] = 70000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/0/04/Felon.png"},
	["ingot"] = { ['name'] = "Ingot", ['price'] = 160000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/7/74/Ingot.png"},
	["jackal"] = { ['name'] = "Jackal", ['price'] = 60000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/7/70/Jackal.png"},
	["oracle"] = { ['name'] = "Oracle", ['price'] = 60000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/1/17/Oracle.png"},
	["oracle2"] = { ['name'] = "Oracle2", ['price'] = 80000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/4/4d/Oracle2.png"},
	["sentinel"] = { ['name'] = "Sentinel", ['price'] = 50000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/9/91/Sentinel.png"},
	["sentinel2"] = { ['name'] = "Sentinel2", ['price'] = 60000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/d/dd/Sentinel2.png"},
	["windsor"] = { ['name'] = "Windsor", ['price'] = 150000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/2/2d/Windsor.png"},
	["windsor2"] = { ['name'] = "Windsor2", ['price'] = 170000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/57/Windsor2.png"},
	["zion"] = { ['name'] = "Zion", ['price'] = 50000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/51/Zion.png"},
	["zion2"] = { ['name'] = "Zion2", ['price'] = 60000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/f/f2/Zion2.png"},
	["blade"] = { ['name'] = "Blade", ['price'] = 110000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/a/ad/Blade.png"},
	["buccaneer"] = { ['name'] = "Buccaneer", ['price'] = 130000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/d/de/Buccaneer.png"},
	["buccaneer2"] = { ['name'] = "Buccaneer2", ['price'] = 260000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/1/16/Buccaneer2.png"},
	["primo"] = { ['name'] = "Primo", ['price'] = 130000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/4/45/Primo.png"},
	["chino"] = { ['name'] = "Chino", ['price'] = 100000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/4/4d/Chino.png"},
	["coquette3"] = { ['name'] = "Coquette3", ['price'] = 195000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/6/67/Coquette3.png"},
	["dukes"] = { ['name'] = "Dukes", ['price'] = 150000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/6/6e/Dukes.png"},
	["faction"] = { ['name'] = "Faction", ['price'] = 150000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/55/Faction.png"},
	["faction3"] = { ['name'] = "Faction3", ['price'] = 350000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/a/a8/Faction3.png"},
	["gauntlet"] = { ['name'] = "Gauntlet", ['price'] = 165000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/7/71/Gauntlet.png"},
	["gauntlet2"] = { ['name'] = "Gauntlet2", ['price'] = 165000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/b/b0/Gauntlet2.png"},
	["hermes"] = { ['name'] = "Hermes", ['price'] = 280000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/0/0d/Hermes.png"},
	["hotknife"] = { ['name'] = "Hotknife", ['price'] = 180000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/1/16/Hotknife.png"},
	["moonbeam"] = { ['name'] = "Moonbeam", ['price'] = 220000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/5d/Moonbeam.png"},
	["moonbeam2"] = { ['name'] = "Moonbeam2", ['price'] = 250000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/c/c1/Moonbeam2.png"},
	["nightshade"] = { ['name'] = "Nightshade", ['price'] = 270000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/e/ec/Nightshade.png"},
	["picador"] = { ['name'] = "Picador", ['price'] = 150000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/1/15/Picador.png"},
	["ruiner"] = { ['name'] = "Ruiner", ['price'] = 150000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/b/b4/Ruiner.png"},
	["sabregt"] = { ['name'] = "Sabregt", ['price'] = 260000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/0/04/Sabregt.png"},
	["sabregt2"] = { ['name'] = "Sabregt2", ['price'] = 150000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/b/ba/Sabregt2.png"},
	["slamvan"] = { ['name'] = "Slamvan", ['price'] = 180000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/9/96/Slamvan.png"},
	["slamvan3"] = { ['name'] = "Slamvan3", ['price'] = 230000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/f/fe/Slamvan3.png"},
	["stalion"] = { ['name'] = "Stalion", ['price'] = 150000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/c/ce/Stalion.png"},
	["stalion2"] = { ['name'] = "Stalion2", ['price'] = 150000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/4/4a/Stalion2.png"},
	["tampa"] = { ['name'] = "Tampa", ['price'] = 170000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/3/30/Tampa.png"},
	["vigero"] = { ['name'] = "Vigero", ['price'] = 170000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/2/22/Vigero.png"},
	["virgo"] = { ['name'] = "Virgo", ['price'] = 150000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/4/41/Virgo.png"},
	["virgo2"] = { ['name'] = "Virgo2", ['price'] = 250000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/8/81/Virgo2.png"},
	["virgo3"] = { ['name'] = "Virgo3", ['price'] = 180000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/4/4d/Virgo3.png"},
	["voodoo"] = { ['name'] = "Voodoo", ['price'] = 220000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/1/1e/Voodoo.png"},
	["voodoo2"] = { ['name'] = "Voodoo2", ['price'] = 220000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/5e/Voodoo2.png"},
	["yosemite"] = { ['name'] = "Yosemite", ['price'] = 350000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/7/7a/Yosemite.png"},
	["bfinjection"] = { ['name'] = "Bfinjection", ['price'] = 80000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://static.wikia.nocookie.net/gtawiki/images/8/80/Injection-GTAV-front.png/revision/latest?cb=20160626144335"},
	["bifta"] = { ['name'] = "Bifta", ['price'] = 190000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/b/b7/Bifta.png"},
	["bodhi2"] = { ['name'] = "Bodhi2", ['price'] = 170000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/c/ce/Bodhi2.png"},
	["brawler"] = { ['name'] = "Brawler", ['price'] = 250000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/f/fa/Brawler.png"},
	["trophytruck"] = { ['name'] = "Trophytruck", ['price'] = 400000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/1/18/Trophytruck.png"},
	["trophytruck2"] = { ['name'] = "Trophytruck2", ['price'] = 400000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/8/85/Trophytruck2.png"},
	["dubsta3"] = { ['name'] = "Dubsta3", ['price'] = 300000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/d/d6/Dubsta3.png"},
	["mesa3"] = { ['name'] = "Mesa3", ['price'] = 200000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/c/c6/Mesa3.png"},
	["rancherxl"] = { ['name'] = "Rancherxl", ['price'] = 220000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/e/ef/Rancherxl.png"},
	["rebel2"] = { ['name'] = "Rebel2", ['price'] = 250000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/9/90/Rebel2.png"},
	["riata"] = { ['name'] = "Riata", ['price'] = 250000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/4/4d/Riata.png"},
	["dloader"] = { ['name'] = "Dloader", ['price'] = 150000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/1/1a/Dloader.png"},
	["sandking"] = { ['name'] = "Sandking", ['price'] = 400000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/6/64/Sandking.png"},
	["sandking2"] = { ['name'] = "Sandking2", ['price'] = 370000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/d/d1/Sandking2.png"},
	["baller"] = { ['name'] = "Baller", ['price'] = 150000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/7/79/Baller.png"},
	["baller2"] = { ['name'] = "Baller2", ['price'] = 160000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/9/98/Baller2.png"},
	["baller3"] = { ['name'] = "Baller3", ['price'] = 175000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/9/9b/Baller3.png"},
	["baller4"] = { ['name'] = "Baller4", ['price'] = 185000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/e/e8/Baller4.png"},
	["baller5"] = { ['name'] = "Baller5", ['price'] = 270000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/3/34/Baller5.png"},
	["baller6"] = { ['name'] = "Baller6", ['price'] = 280000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/8/81/Baller6.png"},
	["bjxl"] = { ['name'] = "Bjxl", ['price'] = 110000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/d/da/Bjxl.png"},
	["cavalcade"] = { ['name'] = "Cavalcade", ['price'] = 110000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/9/9e/Cavalcade.png"},
	["cavalcade2"] = { ['name'] = "Cavalcade2", ['price'] = 130000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/b/bc/Cavalcade2.png"},
	["contender"] = { ['name'] = "Contender", ['price'] = 300000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/2/2e/Contender.png"},
	["dubsta"] = { ['name'] = "Dubsta", ['price'] = 210000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/e/ec/Dubsta.png"},
	["dubsta2"] = { ['name'] = "Dubsta2", ['price'] = 240000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/3/36/Dubsta2.png"},
	["fq2"] = { ['name'] = "Fq2", ['price'] = 110000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/a/a4/Fq2.png"},
	["granger"] = { ['name'] = "Granger", ['price'] = 345000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/4/4d/Granger.png"},
	["gresley"] = { ['name'] = "Gresley", ['price'] = 150000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/d/d6/Gresley.png"},
	["habanero"] = { ['name'] = "Habanero", ['price'] = 110000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/1/1e/Habanero.png"},
	["seminole"] = { ['name'] = "Seminole", ['price'] = 110000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/c/cc/Seminole.png"},
	["serrano"] = { ['name'] = "Serrano", ['price'] = 150000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/a/ac/Serrano.png"},
	["xls"] = { ['name'] = "Xls", ['price'] = 150000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/0/0f/Xls.png"},
	["xls2"] = { ['name'] = "Xls2", ['price'] = 350000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/3/35/Xls2.png"},
	["asea"] = { ['name'] = "Asea", ['price'] = 55000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/c/ce/Asea.png"},
	["asterope"] = { ['name'] = "Asterope", ['price'] = 65000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/0/05/Asterope.png"},
	["cog552"] = { ['name'] = "Cog552", ['price'] = 400000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/7/79/Cog552.png"},
	["cognoscenti"] = { ['name'] = "Cognoscenti", ['price'] = 280000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/51/Cognoscenti.png"},
	["cognoscenti2"] = { ['name'] = "Cognoscenti2", ['price'] = 400000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/2/2e/Cognoscenti2.png"},
	["stanier"] = { ['name'] = "Stanier", ['price'] = 105000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/57/Stanier.png"},
	["stratum"] = { ['name'] = "Stratum", ['price'] = 90000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/b/ba/Stratum.png"},
	["surge"] = { ['name'] = "Surge", ['price'] = 110000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/1/1a/Surge.png"},
	["tailgater"] = { ['name'] = "Tailgater", ['price'] = 110000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/a/af/Tailgater.png"},
	["warrener"] = { ['name'] = "Warrener", ['price'] = 90000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/2/22/Warrener.png"},
	["washington"] = { ['name'] = "Washington", ['price'] = 130000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/e/e2/Washington.png"},
	["alpha"] = { ['name'] = "Alpha", ['price'] = 230000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/a/a8/Alpha.png"},
	["banshee"] = { ['name'] = "Banshee", ['price'] = 300000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/d/d3/Banshee.png"},
	["bestiagts"] = { ['name'] = "Bestiagts", ['price'] = 290000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/5c/Bestiagts.png"},
	["blista2"] = { ['name'] = "Blista2", ['price'] = 55000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/0/0c/Blista2.png"},
	["blista3"] = { ['name'] = "Blista3", ['price'] = 80000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/8/8c/Blista3.png"},
	["buffalo"] = { ['name'] = "Buffalo", ['price'] = 300000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/0/0a/Buffalo.png"},
	["buffalo2"] = { ['name'] = "Buffalo2", ['price'] = 300000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/2/2c/Buffalo2.png"},
	["buffalo3"] = { ['name'] = "Buffalo3", ['price'] = 300000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/6/68/Buffalo3.png"},
	["carbonizzare"] = { ['name'] = "Carbonizzare", ['price'] = 290000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/4/43/Carbonizzare.png"},
	["comet2"] = { ['name'] = "Comet2", ['price'] = 250000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/c/cb/Comet2.png"},
	["comet3"] = { ['name'] = "Comet3", ['price'] = 290000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/b/b6/Comet3.png"},
	["comet5"] = { ['name'] = "Comet5", ['price'] = 300000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/c/ca/Comet5.png"},
	["coquette"] = { ['name'] = "Coquette", ['price'] = 250000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/d/d6/Coquette.png"},
	["elegy"] = { ['name'] = "Elegy", ['price'] = 350000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/e/ea/Elegy.png"},
	["elegy2"] = { ['name'] = "Elegy2", ['price'] = 355000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/3/33/Elegy2.png"},
	["feltzer2"] = { ['name'] = "Feltzer2", ['price'] = 255000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/7/7c/Feltzer2.png"},
	["furoregt"] = { ['name'] = "Furoregt", ['price'] = 290000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/c/cb/Furoregt.png"},
	["fusilade"] = { ['name'] = "Fusilade", ['price'] = 210000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/56/Fusilade.png"},
	["futo"] = { ['name'] = "Futo", ['price'] = 170000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/0/04/Futo.png"},
	["jester"] = { ['name'] = "Jester", ['price'] = 150000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/e/e0/Jester.png"},
	["khamelion"] = { ['name'] = "Khamelion", ['price'] = 210000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/2/2e/Khamelion.png"},
	["kuruma"] = { ['name'] = "Kuruma", ['price'] = 330000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/8/8f/Kuruma.png"},
	["massacro"] = { ['name'] = "Massacro", ['price'] = 330000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/7/78/Massacro.png"},
	["massacro2"] = { ['name'] = "Massacro2", ['price'] = 330000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/b/be/Massacro2.png"},
	["ninef"] = { ['name'] = "Ninef", ['price'] = 290000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/59/Ninef.png"},
	["ninef2"] = { ['name'] = "Ninef2", ['price'] = 290000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/f/f6/Ninef2.png"},
	["omnis"] = { ['name'] = "Omnis", ['price'] = 240000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/1/12/Omnis.png"},
	["pariah"] = { ['name'] = "Pariah", ['price'] = 500000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/d/df/Pariah.png"},
	["penumbra"] = { ['name'] = "Penumbra", ['price'] = 150000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/9/93/Penumbra.png"},
	["raiden"] = { ['name'] = "Raiden", ['price'] = 240000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/5f/Raiden.png"},
	["rapidgt"] = { ['name'] = "Rapidgt", ['price'] = 250000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/e/e9/Rapidgt.png"},
	["rapidgt2"] = { ['name'] = "Rapidgt2", ['price'] = 300000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/3/3e/Rapidgt2.png"},
	["ruston"] = { ['name'] = "Ruston", ['price'] = 370000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/b/ba/Ruston.png"},
	["schafter3"] = { ['name'] = "Schafter3", ['price'] = 275000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/a/a9/Schafter3.png"},
	["schafter4"] = { ['name'] = "Schafter4", ['price'] = 420000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/2/29/Schafter4.png"},
	["schafter5"] = { ['name'] = "Schafter5", ['price'] = 275000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/2/28/Schafter5.png"},
	["schwarzer"] = { ['name'] = "Schwarzer", ['price'] = 170000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/1/19/Schwarzer.png"},
	["sentinel3"] = { ['name'] = "Sentinel3", ['price'] = 230000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/0/0f/Sentinel3.png"},
	["seven70"] = { ['name'] = "Seven70", ['price'] = 370000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/6/60/Seven70.png"},
	["specter"] = { ['name'] = "Specter", ['price'] = 320000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/f/f1/Specter.png"},
	["specter2"] = { ['name'] = "Specter2", ['price'] = 355000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/9/9f/Specter2.png"},
	["streiter"] = { ['name'] = "Streiter", ['price'] = 250000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/8/81/Streiter.png"},
	["sultan"] = { ['name'] = "Sultan", ['price'] = 210000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/f/f4/Sultan.png"},
	["surano"] = { ['name'] = "Surano", ['price'] = 310000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/9/96/Surano.png"},
	["tampa2"] = { ['name'] = "Tampa2", ['price'] = 200000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/a/af/Tampa2.png"},
	["tropos"] = { ['name'] = "Tropos", ['price'] = 170000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/7/71/Tropos.png"},
	["verlierer2"] = { ['name'] = "Verlierer2", ['price'] = 380000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/8/81/Verlierer2.png"},
	["btype2"] = { ['name'] = "Btype2", ['price'] = 460000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/9/98/Btype2.png"},
	["btype3"] = { ['name'] = "Btype3", ['price'] = 390000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/3/34/Btype3.png"},
	["casco"] = { ['name'] = "Casco", ['price'] = 355000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/d/d7/Casco.png"},
	["cheetah"] = { ['name'] = "Cheetah", ['price'] = 425000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/9/9e/Cheetah.png"},
	["coquette2"] = { ['name'] = "Coquette2", ['price'] = 285000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/8/8a/Coquette2.png"},
	["feltzer3"] = { ['name'] = "Feltzer3", ['price'] = 220000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/0/0b/Feltzer3.png"},
	["gt500"] = { ['name'] = "Gt500", ['price'] = 250000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/8/84/Gt500.png"},
	["infernus2"] = { ['name'] = "Infernus2", ['price'] = 250000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/9/91/Infernus2.png"},
	["jb700"] = { ['name'] = "Jb700", ['price'] = 220000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/9/97/Jb700.png"},
	["mamba"] = { ['name'] = "Mamba", ['price'] = 300000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/c/c0/Mamba.png"},
	["manana"] = { ['name'] = "Manana", ['price'] = 130000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/50/Manana.png"},
	["monroe"] = { ['name'] = "Monroe", ['price'] = 260000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/6/64/Monroe.png"},
	["peyote"] = { ['name'] = "Peyote", ['price'] = 150000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/2/21/Peyote.png"},
	["pigalle"] = { ['name'] = "Pigalle", ['price'] = 250000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/7/76/Pigalle.png"},
	["rapidgt3"] = { ['name'] = "Rapidgt3", ['price'] = 220000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/0/09/Rapidgt3.png"},
	["retinue"] = { ['name'] = "Retinue", ['price'] = 150000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/53/Retinue.png"},
	["stinger"] = { ['name'] = "Stinger", ['price'] = 220000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/b/b6/Stinger.png"},
	["stingergt"] = { ['name'] = "Stingergt", ['price'] = 230000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/8/8d/Stingergt.png"},
	["torero"] = { ['name'] = "Torero", ['price'] = 160000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/5f/Torero.png"},
	["tornado"] = { ['name'] = "Tornado", ['price'] = 150000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/4/40/Tornado.png"},
	["tornado2"] = { ['name'] = "Tornado2", ['price'] = 160000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/0/05/Tornado2.png"},
	["tornado6"] = { ['name'] = "Tornado6", ['price'] = 250000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/6/69/Tornado6.png"},
	["turismo2"] = { ['name'] = "Turismo2", ['price'] = 250000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/f/fa/Turismo2.png"},
	["ztype"] = { ['name'] = "Ztype", ['price'] = 400000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/56/Ztype.png"},
	["adder"] = { ['name'] = "Adder", ['price'] = 620000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/c/c2/Adder.png"},
	["autarch"] = { ['name'] = "Autarch", ['price'] = 760000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/3/38/Autarch.png"},
	["banshee2"] = { ['name'] = "Banshee2", ['price'] = 370000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/9/9b/Banshee2.png"},
	["bullet"] = { ['name'] = "Bullet", ['price'] = 400000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/7/7a/Bullet.png"},
	["cheetah2"] = { ['name'] = "Cheetah2", ['price'] = 240000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/d/dd/Cheetah2.png"},
	["entityxf"] = { ['name'] = "Entityxf", ['price'] = 460000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/6/61/Entityxf.png"},
	["fmj"] = { ['name'] = "Fmj", ['price'] = 520000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/d/d2/Fmj.png"},
	["gp1"] = { ['name'] = "Gp1", ['price'] = 495000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/a/a4/Gp1.png"},
	["infernus"] = { ['name'] = "Infernus", ['price'] = 470000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/d/d2/Infernus.png"},
	["nero"] = { ['name'] = "Nero", ['price'] = 450000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/e/ed/Nero.png"},
	["nero2"] = { ['name'] = "Nero2", ['price'] = 480000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/e/ec/Nero2.png"},
	["osiris"] = { ['name'] = "Osiris", ['price'] = 460000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/e/e3/Osiris.png"},
	["penetrator"] = { ['name'] = "Penetrator", ['price'] = 480000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/d/d9/Penetrator.png"},
	["pfister811"] = { ['name'] = "Pfister811", ['price'] = 530000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/8/8e/Pfister811.png"},
	["reaper"] = { ['name'] = "Reaper", ['price'] = 620000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/6/6a/Reaper.png"},
	["sc1"] = { ['name'] = "Sc1", ['price'] = 495000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/59/Sc1.png"},
	["sultanrs"] = { ['name'] = "Sultan RS", ['price'] = 450000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/8/88/Sultanrs.png"},
	["t20"] = { ['name'] = "T20", ['price'] = 670000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/7/7d/T20.png"},
	["tempesta"] = { ['name'] = "Tempesta", ['price'] = 600000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/8/8a/Tempesta.png"},
	["turismor"] = { ['name'] = "Turismor", ['price'] = 620000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/7/7f/Turismor.png"},
	["tyrus"] = { ['name'] = "Tyrus", ['price'] = 620000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/e/e4/Tyrus.png"},
	["vacca"] = { ['name'] = "Vacca", ['price'] = 620000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/1/14/Vacca.png"},
	["visione"] = { ['name'] = "Visione", ['price'] = 690000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/0/01/Visione.png"},
	["voltic"] = { ['name'] = "Voltic", ['price'] = 440000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/e/ef/Voltic.png"},
	["zentorno"] = { ['name'] = "Zentorno", ['price'] = 920000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/2/2b/Zentorno.png"},
	["sadler"] = { ['name'] = "Sadler", ['price'] = 180000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/3/37/Sadler.png"},
	["bison"] = { ['name'] = "Bison", ['price'] = 220000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/f/f6/Bison.png"},
	["bison2"] = { ['name'] = "Bison2", ['price'] = 180000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/4/44/Bison2.png"},
	["bobcatxl"] = { ['name'] = "Bobcatxl", ['price'] = 260000, ['tipo'] = "import",['mala'] = 10, ['andress'] = ""},
	["burrito"] = { ['name'] = "Burrito", ['price'] = 260000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/e/e0/Burrito.png"},
	["burrito2"] = { ['name'] = "Burrito2", ['price'] = 260000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/52/Burrito2.png"},
	["burrito3"] = { ['name'] = "Burrito3", ['price'] = 260000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/8/89/Burrito3.png"},
	["burrito4"] = { ['name'] = "Burrito4", ['price'] = 260000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/f/f6/Burrito4.png"},
	["mule4"] = { ['name'] = "Burrito4", ['price'] = 260000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/2/2e/Mule4.png"},
	["mule"] = { ['name'] = "Burrito4", ['price'] = 260000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/e/e7/Mule.png"},
	["rallytruck"] = { ['name'] = "Burrito4", ['price'] = 260000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/a/a5/Rallytruck.png"},
	["minivan"] = { ['name'] = "Minivan", ['price'] = 110000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/1/12/Minivan.png"},
	["minivan2"] = { ['name'] = "Minivan2", ['price'] = 220000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/2/21/Minivan2.png"},
	["paradise"] = { ['name'] = "Paradise", ['price'] = 260000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/b/b3/Paradise.png"},
	["pony"] = { ['name'] = "Pony", ['price'] = 260000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/b/b1/Pony.png"},
	["pony2"] = { ['name'] = "Pony2", ['price'] = 260000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/c/c6/Pony2.png"},
	["rumpo"] = { ['name'] = "Rumpo", ['price'] = 260000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/9/9f/Rumpo.png"},
	["rumpo2"] = { ['name'] = "Rumpo2", ['price'] = 260000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/2/20/Rumpo2.png"},
	["rumpo3"] = { ['name'] = "Rumpo3", ['price'] = 350000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/7/7a/Rumpo3.png"},
	["surfer"] = { ['name'] = "Surfer", ['price'] = 55000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/d/d7/Surfer.png"},
	["youga"] = { ['name'] = "Youga", ['price'] = 260000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/d/d5/Youga.png"},
	["huntley"] = { ['name'] = "Huntley", ['price'] = 110000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/1/1c/Huntley.png"},
	["landstalker"] = { ['name'] = "Landstalker", ['price'] = 130000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/7/70/Landstalker.png"},
	["mesa"] = { ['name'] = "Mesa", ['price'] = 90000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/c/cc/Mesa.png"},
	["patriot"] = { ['name'] = "Patriot", ['price'] = 250000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/1/12/Patriot.png"},
	["radi"] = { ['name'] = "Radi", ['price'] = 110000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/9/9c/Radi.png"},
	["rocoto"] = { ['name'] = "Rocoto", ['price'] = 110000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/2/23/Rocoto.png"},
	["tyrant"] = { ['name'] = "Tyrant", ['price'] = 690000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/0/0a/Tyrant.png"},
	["entity2"] = { ['name'] = "Entity2", ['price'] = 550000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/f/f3/Entity2.png"},
	["cheburek"] = { ['name'] = "Cheburek", ['price'] = 170000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/4/4f/Cheburek.png"},
	["hotring"] = { ['name'] = "Hotring", ['price'] = 300000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/2/26/Hotring.png"},
	["jester3"] = { ['name'] = "Jester3", ['price'] = 345000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/1/19/Jester3.png"},
	["flashgt"] = { ['name'] = "Flashgt", ['price'] = 370000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/8/80/Flashgt.png"},
	["ellie"] = { ['name'] = "Ellie", ['price'] = 320000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/e/ef/Ellie.png"},
	["michelli"] = { ['name'] = "Michelli", ['price'] = 160000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/1/15/Michelli.png"},
	["fagaloa"] = { ['name'] = "Fagaloa", ['price'] = 320000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/1/15/Fagaloa.png"},
	["lwgtr"] = { ['name'] = "GTR Liberty Walker", ['price'] = 320000, ['tipo'] = "carros",['mala'] = 30, ['andress'] = ""},
	["lwgtr2"] = { ['name'] = "GTR Liberty Walker 2", ['price'] = 320000, ['tipo'] = "carros",['mala'] = 30, ['andress'] = ""},
	["dominator"] = { ['name'] = "Dominator", ['price'] = 230000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/6/6e/Dominator.png"},
	["dominator2"] = { ['name'] = "Dominator2", ['price'] = 230000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/57/Dominator2.png"},
	["dominator3"] = { ['name'] = "Dominator3", ['price'] = 370000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/b/ba/Dominator3.png"},
	["issi3"] = { ['name'] = "Issi3", ['price'] = 190000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/7/73/Issi3.png"},
	["taipan"] = { ['name'] = "Taipan", ['price'] = 620000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/8/8a/Taipan.png"},
	["gb200"] = { ['name'] = "Gb200", ['price'] = 195000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/3/35/Gb200.png"},
	["stretch"] = { ['name'] = "Stretch", ['price'] = 520000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/8/8a/Stretch.png"},
	["guardian"] = { ['name'] = "Guardian", ['price'] = 540000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/d/d0/Kamacho.png"},
	["kamacho"] = { ['name'] = "Kamacho", ['price'] = 460000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/1/17/Neon.png"},
	["neon"] = { ['name'] = "Neon", ['price'] = 370000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/7/79/Cyclone.png"},
	["cyclone"] = { ['name'] = "Cyclone", ['price'] = 920000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/7/79/Cyclone.png"},
	["italigtb"] = { ['name'] = "Italigtb", ['price'] = 600000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/d/dd/Italigtb.png"},
	["italigtb2"] = { ['name'] = "Italigtb2", ['price'] = 610000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/57/Italigtb2.png"},
	["vagner"] = { ['name'] = "Vagner", ['price'] = 680000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/9/92/Vagner.png"},
	["xa21"] = { ['name'] = "Xa21", ['price'] = 630000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/4/4d/Xa21.png"},
	["tezeract"] = { ['name'] = "Tezeract", ['price'] = 920000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/a/ab/Tezeract.png"},
	["prototipo"] = { ['name'] = "Prototipo", ['price'] = 1030000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/f/fb/Prototipo.png"},
	["patriot2"] = { ['name'] = "Patriot2", ['price'] = 550000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/8/83/Patriot2.png"},
	["swinger"] = { ['name'] = "Swinger", ['price'] = 250000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/8/86/Swinger.png"},
	["clique"] = { ['name'] = "Clique", ['price'] = 360000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/3/3c/Clique.png"},
	["deveste"] = { ['name'] = "Deveste", ['price'] = 920000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/3/3f/Deveste.png"},
	["deviant"] = { ['name'] = "Deviant", ['price'] = 370000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/d/d5/Deviant.png"},
	["impaler"] = { ['name'] = "Impaler", ['price'] = 320000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/3/31/Impaler.png"},
	["italigto"] = { ['name'] = "Italigto", ['price'] = 800000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://static.wikia.nocookie.net/gtawiki/images/e/ec/ItaliGTO-GTAO-front.png/revision/latest?cb=20181214181625"},
	["schlagen"] = { ['name'] = "Schlagen", ['price'] = 690000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/9/97/Schlagen.png"},
	["toros"] = { ['name'] = "Toros", ['price'] = 600000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/f/f1/Toros.png"},
	["tulip"] = { ['name'] = "Tulip", ['price'] = 320000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/c/cf/Tulip.png"},
	["vamos"] = { ['name'] = "Vamos", ['price'] = 320000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/0/07/Vamos.png"},
	["freecrawler"] = { ['name'] = "Freecrawler", ['price'] = 350000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/56/Freecrawler.png"},
	["fugitive"] = { ['name'] = "Fugitive", ['price'] = 50000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/7/73/Fugitive.png"},
	["glendale"] = { ['name'] = "Glendale", ['price'] = 70000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/b/b2/Glendale.png"},
	["intruder"] = { ['name'] = "Intruder", ['price'] = 60000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/9/92/Intruder.png"},
	["le7b"] = { ['name'] = "Le7b", ['price'] = 700000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/e/ee/Le7b.png"},
	["lurcher"] = { ['name'] = "Lurcher", ['price'] = 150000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/0/03/Lurcher.png"},
	["lynx"] = { ['name'] = "Lynx", ['price'] = 370000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/b/b8/Lynx.png"},
	["phoenix"] = { ['name'] = "Phoenix", ['price'] = 250000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/c/c1/Phoenix.png"},
	["premier"] = { ['name'] = "Premier", ['price'] = 35000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/9/9d/Premier.png"},
	["raptor"] = { ['name'] = "Raptor", ['price'] = 300000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/0/08/Raptor.png"},
	["sheava"] = { ['name'] = "Sheava", ['price'] = 700000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/0/06/Sheava.png"},
	["z190"] = { ['name'] = "Z190", ['price'] = 350000, ['tipo'] = "carros",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/e/e1/Z190.png"},

	--MOTOS
	
	["akuma"] = { ['name'] = "Akuma", ['price'] = 500000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/1/16/Akuma.png"},
	["avarus"] = { ['name'] = "Avarus", ['price'] = 440000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/1/13/Avarus.png"},
	["bagger"] = { ['name'] = "Bagger", ['price'] = 300000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/6/64/Bagger.png"},
	["bati"] = { ['name'] = "Bati", ['price'] = 370000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/c/ce/Bati.png"},
	["bati2"] = { ['name'] = "Bati2", ['price'] = 300000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/6/60/Bati2.png"},
	["bf400"] = { ['name'] = "Bf400", ['price'] = 320000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://static.wikia.nocookie.net/gtawiki/images/0/00/BF400-GTAO-front.png/revision/latest?cb=20161014164436"},
	["carbonrs"] = { ['name'] = "Carbonrs", ['price'] = 370000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://static.wikia.nocookie.net/gtawiki/images/2/2d/CarbonRS-GTAV-front.png/revision/latest?cb=20160130214329"},
	["chimera"] = { ['name'] = "Chimera", ['price'] = 345000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/3/36/Chimera.png"},
	["cliffhanger"] = { ['name'] = "Cliffhanger", ['price'] = 310000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/1/12/Cliffhanger.png"},
	["daemon2"]  = { ['name'] = "Daemon2", ['price'] = 240000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/8/86/Daemon2.png"},
	["defiler"] = { ['name'] = "Defiler", ['price'] = 460000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/4/41/Defiler.png"},
	["diablous"] = { ['name'] = "Diablous", ['price'] = 430000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/4/48/Diablous.png"},
	["diablous2"] = { ['name'] = "Diablous2", ['price'] = 460000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/3/3e/Diablous2.png"},
	["double"] = { ['name'] = "Double", ['price'] = 370000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/0/01/Double.png"},
	["enduro"] = { ['name'] = "Enduro", ['price'] = 195000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/f/f3/Enduro.png"},
	["esskey"] = { ['name'] = "Esskey", ['price'] = 320000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/2/24/Esskey.png"},
	["faggio"] = { ['name'] = "Faggio", ['price'] = 4000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/4/4d/Faggio.png"},
	["faggio2"] = { ['name'] = "Faggio2", ['price'] = 5000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/2/25/Faggio2.png"},
	["faggio3"] = { ['name'] = "Faggio3", ['price'] = 5000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/a/a6/Faggio3.png"},
	["fcr"] = { ['name'] = "Fcr", ['price'] = 390000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/4/46/Fcr.png"},
	["fcr2"] = { ['name'] = "Fcr2", ['price'] = 390000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/d/d5/Fcr2.png"},
	["gargoyle"] = { ['name'] = "Gargoyle", ['price'] = 345000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/4/44/Gargoyle.png"},
	["hakuchou"] = { ['name'] = "Hakuchou", ['price'] = 380000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/2/23/Hakuchou.png"},
	["hakuchou2"] = { ['name'] = "Hakuchou2", ['price'] = 550000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/8/87/Hakuchou2.png"},
	["hexer"] = { ['name'] = "Hexer", ['price'] = 250000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/56/Hexer.png"},
	["innovation"] = { ['name'] = "Innovation", ['price'] = 250000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/4/42/Innovation.png"},
	["lectro"] = { ['name'] = "Lectro", ['price'] = 380000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/0/00/Lectro.png"},
	["manchez"] = { ['name'] = "Manchez", ['price'] = 355000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/3/3c/Manchez.png"},
	["nemesis"] = { ['name'] = "Nemesis", ['price'] = 345000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/e/e3/Nemesis.png"},
	["nightblade"] = { ['name'] = "Nightblade", ['price'] = 415000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/c/c1/Nightblade.png"},
	["pcj"] = { ['name'] = "Pcj", ['price'] = 230000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/9/99/Pcj.png"},
	["ruffian"] = { ['name'] = "Ruffian", ['price'] = 345000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/f/f6/Ruffian.png"},
	["sanchez"] = { ['name'] = "Sanchez", ['price'] = 185000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/52/Sanchez.png"},
	["sanchez2"] = { ['name'] = "Sanchez2", ['price'] = 185000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/6/6d/Sanchez2.png"},
	["sovereign"] = { ['name'] = "Sovereign", ['price'] = 285000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/a/ae/Sovereign.png"},
	["thrust"] = { ['name'] = "Thrust", ['price'] = 375000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/9/90/Thrust.png"},
	["vader"] = { ['name'] = "Vader", ['price'] = 345000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/d/dc/Vader.png"},
	["vindicator"] = { ['name'] = "Vindicator", ['price'] = 340000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/b/bb/Vindicator.png"},
	["vortex"] = { ['name'] = "Vortex", ['price'] = 375000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/52/Vortex.png"},
	["wolfsbane"] = { ['name'] = "Wolfsbane", ['price'] = 290000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/c/c6/Wolfsbane.png"},
	["zombiea"] = { ['name'] = "Zombiea", ['price'] = 290000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/7/7f/Zombiea.png"},
	["zombieb"] = { ['name'] = "Zombieb", ['price'] = 300000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/2/2c/Zombieb.png"},
	["shotaro"] = { ['name'] = "Shotaro", ['price'] = 1000000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/e/e3/Shotaro.png"},
	["ratbike"] = { ['name'] = "Ratbike", ['price'] = 230000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/4/49/Ratbike.png"},
	["blazer"] = { ['name'] = "Blazer", ['price'] = 230000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/3/3e/Blazer.png"},
	["blazer4"] = { ['name'] = "Blazer4", ['price'] = 370000, ['tipo'] = "motos",['mala'] = 10, ['andress'] = "https://wiki.rage.mp/images/5/5f/Blazer4.png"},
	["swift"] = { ['name'] = "Heli Unimed", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	
	-- policia
	
	["pajerocivil"] = { ['name'] = "Pajero Civil", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
    ["frontierpolicia"] = { ['name'] = "Frontier Civil", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["amarokcivil1"] = { ['name'] = "Amarok Civil", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["trailcivil1"] = { ['name'] = "TrailCivil", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["trailcivil2"] = { ['name'] = "TrailCivil", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},	
		
		
	["polmav"] = { ['name'] = "Aguia", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["maverick"] = { ['name'] = "Aguia", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["cb1000"] = { ['name'] = "CB1000", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["corprf"] = { ['name'] = "Corrola PRF", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["l200prf"] = { ['name'] = "L200 PRF", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["cruzeprf2"] = { ['name'] = "Cruze PRF", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["xtrocam"] = { ['name'] = "XT660 ROCAM", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["basepm1"] = { ['name'] = "Base RPA", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["trailprf"] = { ['name'] = "Trail PRF", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["ambulance"] = { ['name'] = "Ambulancia UNIMED", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["tigerunimed"] = { ['name'] = "Tiger UNIMED", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["africaprf"] = { ['name'] = "Africa PRF", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["amarokcivil1"] = { ['name'] = "Amarock Civil", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["amarokrotam1"] = { ['name'] = "Amarock Rotam", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["pajeropm"] = { ['name'] = "Pajero Rone", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["paliopm"] = { ['name'] = "Palio PMPR", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["trailcivil1"] = { ['name'] = "Trail Civil", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["trailcivil2"] = { ['name'] = "Descaracterizado", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["trailrone1"] = { ['name'] = "Trail Rone", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["trailrotam1"] = { ['name'] = "Trail Rotam", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["voyagepm1"] = { ['name'] = "Voyage PMPR", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["cruzepm"] = { ['name'] = "Cruze PMPR", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
    ["trash"] = { ['name'] = "trash", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	
    ["as350"] = { ['name'] = "Aguia PM", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["hiluxsw4rota"] = { ['name'] = "Hilux SW4 ROTA", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["mi4"] = { ['name'] = "Onibus", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["palioadv"] = { ['name'] = "Palio PM", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["policet"] = { ['name'] = "Base PM", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["police2"] = { ['name'] = "Gol PM", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["spinrp3"] = { ['name'] = "Spin PM", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""}, 
	["sw4tatico"] = { ['name'] = "SW4 TATICO", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["trailft"] = { ['name'] = "Trail TATICO", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["trailrota"] = { ['name'] = "Trail ROTA", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["xre2019"] = { ['name'] = "XRE 2019", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["xtrocam"] = { ['name'] = "XT ROCAM", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	
	["corollapc"] = { ['name'] = "Corolla PC", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["voyagepc"] = { ['name'] = "Voyage PC", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["dusterpc"] = { ['name'] = "Duster PC", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["oroch"] = { ['name'] = "Oroch PM", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	
	--TRABALHO
	["69charger"] = { ['name'] = "Youga2", ['price'] = 1000, ['tipo'] = "exclusive",['mala'] = 60, ['andress'] = ""},
	["trx"] = { ['name'] = "Felon2", ['price'] = 1000, ['tipo'] = "exclusive",['mala'] = 60, ['andress'] = ""},
	["rs6c8"] = { ['name'] = "Felon2", ['price'] = 1000, ['tipo'] = "exclusive",['mala'] = 60, ['andress'] = ""},

	["youga2"] = { ['name'] = "Youga2", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["felon2"] = { ['name'] = "Felon2", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["pbus"] = { ['name'] = "PBus", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["policiacharger2018"] = { ['name'] = "Dodge Charger 2018", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["policiamustanggt"] = { ['name'] = "Mustang GT", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["policiacapricesid"] = { ['name'] = "GM Caprice SID", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["policiaschaftersid"] = { ['name'] = "GM Schafter SID", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["policiasilverado"] = { ['name'] = "Chevrolet Silverado", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["policiatahoe"] = { ['name'] = "Chevrolet Tahoe", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["policiaexplorer"] = { ['name'] = "Ford Explorer", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["policiataurus"] = { ['name'] = "Ford Taurus", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["policiavictoria"] = { ['name'] = "Ford Victoria", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["policiabmwr1200"] = { ['name'] = "BMW R1200", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["policiaheli"] = { ['name'] = "Policia Helicóptero", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["fbi2"] = { ['name'] = "Granger SOG", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["policeb"] = { ['name'] = "Harley Davidson", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["riot"] = { ['name'] = "Blindado", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["paramedicoambu"] = { ['name'] = "Ambulância", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["paramedicocharger2014"] = { ['name'] = "Dodge Charger 2014", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["paramedicoheli"] = { ['name'] = "Paramédico Helicóptero", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["seasparrow"] = { ['name'] = "Paramédico Helicóptero Água", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["coach"] = { ['name'] = "Coach", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["bus"] = { ['name'] = "Ônibus", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["flatbed"] = { ['name'] = "Reboque", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["towtruck"] = { ['name'] = "Towtruck", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["towtruck2"] = { ['name'] = "Towtruck2", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["rwnoader"] = { ['name'] = "Caminhão", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["rwnoader2"] = { ['name'] = "Rwnoader2", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["rubble"] = { ['name'] = "Caminhão", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["taxi"] = { ['name'] = "Taxi", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["boxville4"] = { ['name'] = "Caminhão", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["trash2"] = { ['name'] = "Caminhão", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["tiptruck"] = { ['name'] = "Tiptruck", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["scorcher"] = { ['name'] = "Scorcher", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["tribike"] = { ['name'] = "Tribike", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["tribike2"] = { ['name'] = "Tribike2", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["tribike3"] = { ['name'] = "Tribike3", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["fixter"] = { ['name'] = "Fixter", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["cruiser"] = { ['name'] = "Cruiser", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["bmx"] = { ['name'] = "Bmx", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["dinghy"] = { ['name'] = "Dinghy", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["jetmax"] = { ['name'] = "Jetmax", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["marquis"] = { ['name'] = "Marquis", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["seashark3"] = { ['name'] = "Seashark3", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["speeder"] = { ['name'] = "Speeder", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["speeder2"] = { ['name'] = "Speeder2", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["squalo"] = { ['name'] = "Squalo", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["suntrap"] = { ['name'] = "Suntrap", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["toro"] = { ['name'] = "Toro", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["toro2"] = { ['name'] = "Toro2", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["tropic"] = { ['name'] = "Tropic", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["tropic2"] = { ['name'] = "Tropic2", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["phantom"] = { ['name'] = "Phantom", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["packer"] = { ['name'] = "Packer", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["supervolito"] = { ['name'] = "Supervolito", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["supervolito2"] = { ['name'] = "Supervolito2", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["cuban800"] = { ['name'] = "Cuban800", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["mammatus"] = { ['name'] = "Mammatus", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["vestra"] = { ['name'] = "Vestra", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["velum2"] = { ['name'] = "Velum2", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["buzzard2"] = { ['name'] = "Buzzard2", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["frogger"] = { ['name'] = "Frogger", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["tanker2"] = { ['name'] = "Gas", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["armytanker"] = { ['name'] = "Diesel", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["tvtrailer"] = { ['name'] = "Show", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["trailerlogs"] = { ['name'] = "Woods", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["tr4"] = { ['name'] = "Cars", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["speedo"] = { ['name'] = "Speedo", ['price'] = 200000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["primo2"] = { ['name'] = "Primo2", ['price'] = 250000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["faction2"] = { ['name'] = "Faction2", ['price'] = 200000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["chino2"] = { ['name'] = "Chino2", ['price'] = 200000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["tornado5"] = { ['name'] = "Tornado5", ['price'] = 200000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["daemon"] = { ['name'] = "Daemon", ['price'] = 200000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["sanctus"] = { ['name'] = "Sanctus", ['price'] = 200000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["gburrito"] = { ['name'] = "GBurrito", ['price'] = 200000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["slamvan2"] = { ['name'] = "Slamvan2", ['price'] = 200000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["stafford"] = { ['name'] = "Stafford", ['price'] = 200000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["cog55"] = { ['name'] = "Cog55", ['price'] = 200000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["superd"] = { ['name'] = "Superd", ['price'] = 200000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["btype"] = { ['name'] = "Btype", ['price'] = 200000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["tractor2"] = { ['name'] = "Tractor2", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["rebel"] = { ['name'] = "Rebel", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["flatbed3"] = { ['name'] = "flatbed3", ['price'] = 1000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["volatus"] = { ['name'] = "Volatus", ['price'] = 1000000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},	
	["cargobob2"] = { ['name'] = "Cargo Bob 2", ['price'] = 1000000, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},		
	["cargobob"] = { ['name'] = "Cargo Bob", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	
	--IMPORTADOS

	["dodgechargersrt"] = { ['name'] = "Dodge Charger SRT", ['price'] = 2000000, ['tipo'] = "import",['mala'] = 10, ['andress'] = ""},
	["audirs6"] = { ['name'] = "Audi RS6", ['price'] = 1500000, ['tipo'] = "import",['mala'] = 10, ['andress'] = ""},
	["bmwm3f80"] = { ['name'] = "BMW M3 F80", ['price'] = 1350000, ['tipo'] = "import",['mala'] = 10, ['andress'] = ""},
	["fordmustang"] = { ['name'] = "Ford Mustang", ['price'] = 1900000, ['tipo'] = "import",['mala'] = 10, ['andress'] = ""},
	["lancerevolution9"] = { ['name'] = "Lancer Evolution 9", ['price'] = 1400000, ['tipo'] = "import",['mala'] = 10, ['andress'] = ""},
	["lancerevolutionx"] = { ['name'] = "Lancer Evolution X", ['price'] = 1700000, ['tipo'] = "import",['mala'] = 10, ['andress'] = ""},
	["focusrs"] = { ['name'] = "Focus RS", ['price'] = 1000000, ['tipo'] = "import",['mala'] = 10, ['andress'] = ""},
	["mercedesa45"] = { ['name'] = "Mercedes A45", ['price'] = 1200000, ['tipo'] = "import",['mala'] = 10, ['andress'] = ""},
	["audirs7"] = { ['name'] = "Audi RS7", ['price'] = 1800000, ['tipo'] = "import",['mala'] = 10, ['andress'] = ""},
	["hondafk8"] = { ['name'] = "Honda FK8", ['price'] = 1700000, ['tipo'] = "import",['mala'] = 10, ['andress'] = ""},
	["mustangmach1"] = { ['name'] = "Mustang Mach 1", ['price'] = 1100000, ['tipo'] = "import",['mala'] = 10, ['andress'] = ""},
	["porsche930"] = { ['name'] = "Porsche 930", ['price'] = 1300000, ['tipo'] = "import",['mala'] = 10, ['andress'] = ""},
	["teslaprior"] = { ['name'] = "Tesla Prior", ['price'] = 1750000, ['tipo'] = "import",['mala'] = 10, ['andress'] = ""},
	["type263"] = { ['name'] = "Kombi 63", ['price'] = 500000, ['tipo'] = "import",['mala'] = 10, ['andress'] = ""},
	["beetle74"] = { ['name'] = "Fusca 74", ['price'] = 500000, ['tipo'] = "import",['mala'] = 10, ['andress'] = ""},
	["fe86"] = { ['name'] = "Escorte", ['price'] = 500000, ['tipo'] = "import",['mala'] = 10, ['andress'] = ""},		
    ["jeepreneg"] = { ['name'] = "Jeep Renegede", ['price'] = 2000000, ['tipo'] = "import",['mala'] = 60, ['andress'] = "https://img.gta5-mods.com/q95/images/jeep-renegade-add-on/c8a718-PGTA5851615326.jpg"},
	--EXCLUSIVE 
	
	["i8"] = { ['name'] = "BMW i8", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["nissangtrnismo"] = { ['name'] = "Nissan GTR Nismo", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["nissan370z"] = { ['name'] = "Nissan 370Z", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["raptor2017"] = { ['name'] = "Ford Raptor 2017", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},	
	["ferrariitalia"] = { ['name'] = "Ferrari Italia 478", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["lamborghinihuracan"] = { ['name'] = "Lamborghini Huracan", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["nissangtr"] = { ['name'] = "Nissan GTR", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["bmwm4gts"] = { ['name'] = "BMW M4 GTS", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["mazdarx7"] = { ['name'] = "Mazda RX7", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["nissanskyliner34"] = { ['name'] = "Nissan Skyline R34", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["bc"] = { ['name'] = "Pagani Huayra", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["toyotasupra"] = { ['name'] = "Toyota Supra", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["488gtb"] = { ['name'] = "Ferrari 488 GTB", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["fxxkevo"] = { ['name'] = "Ferrari FXXK Evo", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["m2"] = { ['name'] = "BMW M2", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["p1"] = { ['name'] = "Mclaren P1", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["bme6tun"] = { ['name'] = "BMW M5", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["aperta"] = { ['name'] = "La Ferrari", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["bettle"] = { ['name'] = "New Bettle", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["senna"] = { ['name'] = "Mclaren Senna", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["rmodx6"] = { ['name'] = "BMW X6", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["bnteam"] = { ['name'] = "Bentley", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["rmodlp770"] = { ['name'] = "Lamborghini Centenario", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["divo"] = { ['name'] = "Buggati Divo", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["s15"] = { ['name'] = "Nissan Silvia S15", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["amggtr"] = { ['name'] = "Mercedes AMG", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["slsamg"] = { ['name'] = "Mercedes SLS", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["lamtmc"] = { ['name'] = "Lamborghini Terzo", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["vantage"] = { ['name'] = "Aston Martin Vantage", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["urus"] = { ['name'] = "Lamborghini Urus", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["amarok"] = { ['name'] = "VW Amarok", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["g65amg"] = { ['name'] = "Mercedes G65", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["celta"] = { ['name'] = "Celta Paredão", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["palameila"] = { ['name'] = "Porsche Panamera", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["rsvr16"] = { ['name'] = "Ranger Rover", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["veneno"] = { ['name'] = "Lamborghini Veneno", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["f4rr"] = { ['name'] = "Augusta", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["rcbandito"] = { ['name'] = "RC", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["ghispo3"] = { ['name'] = "Ghispo Xeriff", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["r1custom"] = { ['name'] = "R1 Xeriff", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["polsrt10"] = { ['name'] = "Xeriff SRT10", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["tr22"] = { ['name'] = "Tesla", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["kuruma2"] = { ['name'] = "Kuruma do Torres", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["18jeep"] = { ['name'] = "Jeep Xerife", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["polgt500"] = { ['name'] = "GT 500 Xerife", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["17raptorpd"] = { ['name'] = "Raptor 17 Xerife", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["can"] = { ['name'] = "Can", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["cam8tun"] = { ['name'] = "Toyota XSE", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["mt03"] = { ['name'] = "Augusta", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["bmws"] = { ['name'] = "Augusta", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["ghispo2"] = { ['name'] = "Maserati", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["polgs350"] = { ['name'] = "GS350", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["bmpos8"] = { ['name'] = "BMW OS8", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["z419"] = { ['name'] = "BMW Z4", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["r8ppi"] = { ['name'] = "Audi R8", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["zondar"] = { ['name'] = "Pagani Zonda R", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["sspres"] = { ['name'] = "Suburban", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["laferrari17"] = { ['name'] = "LaFerrari", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["2020silv"] = { ['name'] = "Silverado2020", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["eleanor"] = { ['name'] = "Mustang Eleanor", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["rmodamgc63"] = { ['name'] = "Mercedes AMG C63", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["19ramdonk"] = { ['name'] = "Dodge Ram Donk", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["silv86"] = { ['name'] = "Silverado Donk", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["ninjah2"] = { ['name'] = "Ninja H2", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["70camarofn"] = { ['name'] = "camaro Z28 1970", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["agerars"] = { ['name'] = "Koenigsegg Agera RS", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["fc15"] = { ['name'] = "Ferrari California", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["msohs"] = { ['name'] = "Mclaren 688 HS", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["gt17"] = { ['name'] = "Ford GT 17", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["19ftype"] = { ['name'] = "Jaguar F-Type", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["bbentayga"] = { ['name'] = "Bentley Bentayga", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["nissantitan17"] = { ['name'] = "Nissan Titan 2017", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["911r"] = { ['name'] = "Porsche 911R", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["trr"] = { ['name'] = "KTM TRR", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["bmws"] = { ['name'] = "BMW S1000", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["cb500x"] = { ['name'] = "Honda CB500", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["hcbr17"] = { ['name'] = "Honda CBR17", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["defiant"] = { ['name'] = "AMC Javelin 72", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["f12tdf"] = { ['name'] = "Ferrari F12 TDF", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["71gtx"] = { ['name'] = "Plymouth 71 GTX", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["lykan"] = { ['name'] = "Plymouth 71 GTX", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["porsche992"] = { ['name'] = "Porsche 992", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["18macan"] = { ['name'] = "Porsche Macan", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["m6e63"] = { ['name'] = "BMW M6 E63", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["africat"] = { ['name'] = "Honda CRF 1000", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["regera"] = { ['name'] = "Koenigsegg Regera", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["180sx"] = { ['name'] = "Nissan 180SX", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["filthynsx"] = { ['name'] = "Honda NSX", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["2018zl1"] = { ['name'] = "Camaro ZL1", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["eclipse"] = { ['name'] = "Mitsubishi Eclipse", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["lp700r"] = { ['name'] = "Lamborghini LP700R", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["db11"] = { ['name'] = "Aston Martin DB11", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["SVR14"] = { ['name'] = "Ranger Rover", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	
	["evoque"] = { ['name'] = "Ranger Rover Evoque", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},
	["evoq"] = { ['name'] = "Ranger Rover Evoque", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},
	["fiattoro"] = { ['name'] = "Fiat Toro", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},
	
	["Bimota"] = { ['name'] = "Ducati Bimota", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["20r1"] = { ['name'] = "Yamaha YZF R1", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["mt03"] = { ['name'] = "Yamaha MT 03", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["yzfr125"] = { ['name'] = "Yamaha YZF R125", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["pistas"] = { ['name'] = "Ferrari Pista", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["bobbes2"] = { ['name'] = "Harley D. Bobber S", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["bobber"] = { ['name'] = "Harley D. Bobber ", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
	["911tbs"] = { ['name'] = "Porsche 911S", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},		
	["rc"] = { ['name'] = "KTM RC", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},		
	["zx10r"] = { ['name'] = "Kawasaki ZX10R", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},		
	["fox600lt"] = { ['name'] = "McLaren 600LT", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},		
	["foxbent1"] = { ['name'] = "Bentley Liter 1931", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},		
	["foxevo"] = { ['name'] = "Lamborghini EVO", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},		
	["jeepg"] = { ['name'] = "Jeep Gladiator", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},		
	["foxharley1"] = { ['name'] = "Harley-Davidson Softail F.B.", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},		
	["foxharley2"] = { ['name'] = "2016 Harley-Davidson Road Glide", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},		
	["foxleggera"] = { ['name'] = "Aston Martin Leggera", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},		
	["foxrossa"] = { ['name'] = "Ferrari Rossa", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},		
	["foxshelby"] = { ['name'] = "Ford Shelby GT500", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},		
	["foxsian"] = { ['name'] = "Lamborghini Sian", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},		
	["foxsterrato"] = { ['name'] = "Lamborghini Sterrato", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},		
	["foxsupra"] = { ['name'] = "Toyota Supra", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},		
	["m6x6"] = { ['name'] = "Mercedes Benz 6x6", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},		
	["m6gt3"] = { ['name'] = "BMW M6 GT3", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},		
	["w900"] = { ['name'] = "Kenworth W900", ['price'] = 1000000, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},	


    ["tr22"] = { ['name'] = "Tesla Roadster", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 60, ['andress'] = ""},
    ["fiat"] = { ['name'] = "Fiat 147", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["monza"] = { ['name'] = "Monza", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["fiatuno"] = { ['name'] = "Fiat Uno", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["palio"] = { ['name'] = "Palio", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["saveiro"] = { ['name'] = "Saveiro", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["p207"] = { ['name'] = "p207", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["civic"] = { ['name'] = "Honda Civic", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["eletran17"] = { ['name'] = "Elantra", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["evoq"] = { ['name'] = "Evoq", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["fiattoro"] = { ['name'] = "Fiat Toro", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["fiatstilo"] = { ['name'] = "Stilo", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["fordka"] = { ['name'] = "Ka", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["fusion"] = { ['name'] = "Fusion", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["golg7"] = { ['name'] = "golg7", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["sonata18"] = { ['name'] = "sonata18", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["upzinho"] = { ['name'] = "UP", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["veloster"] = { ['name'] = "veloster", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["vwgolf"] = { ['name'] = "vwgolf", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["vwpolo"] = { ['name'] = "vwpolo", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["amarok"] = { ['name'] = "amarok", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["civic2016"] = { ['name'] = "civic2016", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["ds4"] = { ['name'] = "ds4", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["jetta2017"] = { ['name'] = "jetta2017", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["l200civil"] = { ['name'] = "l200civil", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["santafe"] = { ['name'] = "santafe", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["voyage"] = { ['name'] = "voyage", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["biz25"] = { ['name'] = "biz25", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["150"] = { ['name'] = "150", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["450crf"] = { ['name'] = "450crf", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["bros60"] = { ['name'] = "bros60", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["dm1200"] = { ['name'] = "dm1200", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["hornet"] = { ['name'] = "hornet", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["xj"] = { ['name'] = "xj", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["xt66"] = { ['name'] = "xt66", ['price'] =1000000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["z1000"] = { ['name'] = "z1000", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["r1250"] = { ['name'] = "BMW R1250", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 20, ['andress'] = ""},
    ["policeb"] = { ['name'] = "Moto BMW", ['price'] = 0, ['tipo'] = "work",['mala'] = 10, ['andress'] = ""},
	["pounder"] = { ['name'] = "Caminhao", ['price'] = 0, ['tipo'] = "exclusive",['mala'] = 10, ['andress'] = ""},
    ["teslax"] = { ['name'] = "xt66", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["gt17"] = { ['name'] = "z1000", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["m5f90"] = { ['name'] = "m5f90", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 50, ['andress'] = ""},	
	["600lt"] = { ['name'] = "600lt", ['price'] = 100000, ['tipo'] = "exclusive",['mala'] = 60, ['andress'] = ""},	

    ["20xmax"] = { ['name'] = "20xmax", ['price'] = 50000, ['tipo'] = "import",['mala'] = 50, ['andress'] = "https://img.gta5-mods.com/q85-w800/images/honda-pcx-150-grom-thailand-style-replace/82980b-2021.02.19-09.29.png"},
    ["diplomata92"] = { ['name'] = "diplomata92", ['price'] = 500000, ['tipo'] = "import",['mala'] = 50, ['andress'] = "https://img.gta5-mods.com/q85-w800/images/chevrolet-opala-diplomata-1992/2bdc1d-comsuama.png"},	
	["golfgti7"] = { ['name'] = "golfgti7", ['price'] = 1000000, ['tipo'] = "import",['mala'] = 50, ['andress'] = "https://img.gta5-mods.com/q95/images/volkswagen-golf-mk7-gti-wipers-digitalracedials-motors-garage-razor/64cfa5-y9XwKg0.jpg"},	
	["cb650r"] = { ['name'] = "cb650r", ['price'] = 2000000, ['tipo'] = "import",['mala'] = 50, ['andress'] = "https://img.gta5-mods.com/q85-w800/images/2019-honda-cb650r/a441e8-20210208222225_1.jpg"},
	
}]]

local actived = {}
local activedAmount = {}
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(actived) do
			if actived[k] > 0 then
				actived[k] = v - 1
				if actived[k] <= 0 then
					actived[k] = nil
					activedAmount[k] = nil
				end
			end
		end
		Citizen.Wait(100)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEGLOBAL
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.vehicleGlobal()
	return vehglobal
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLENAME
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.vehicleName(vname)
	return vehglobal[vname].name
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEPRICE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.vehiclePrice(vname)
	return vehglobal[vname].price
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLETYPE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.vehicleType(vname)
	return vehglobal[vname].tipo
end


function vRP.storeChestItem(user_id,chestData,itemName,amount,chestWeight)
	if actived[user_id] == nil then
		actived[user_id] = 1
		local data = vRP.getSData(chestData)
		local items = json.decode(data) or {}
		if data and items ~= nil then

			if parseInt(amount) > 0 then
				activedAmount[user_id] = parseInt(amount)
			else
				return false
			end

			local new_weight = vRP.computeItemsWeight(items) + vRP.getItemWeight(itemName) * parseInt(activedAmount[user_id])
			if new_weight <= parseInt(chestWeight) then
				if vRP.tryGetInventoryItem(parseInt(user_id),itemName,parseInt(activedAmount[user_id])) then
					if items[itemName] ~= nil then
						items[itemName].amount = parseInt(items[itemName].amount) + parseInt(activedAmount[user_id])
					else
						items[itemName] = { amount = parseInt(activedAmount[user_id]) }
					end

					vRP.setSData(chestData,json.encode(items))
					return true
				end
			end
		end
	end
	return false
end

function vRP.tryChestItem(user_id,chestData,itemName,amount)
	if actived[user_id] == nil then
		actived[user_id] = 1
		local data = vRP.getSData(chestData)
		local items = json.decode(data) or {}
		if data and items ~= nil then
			if items[itemName] ~= nil and parseInt(items[itemName].amount) >= parseInt(amount) then

				if parseInt(amount) > 0 then
					activedAmount[user_id] = parseInt(amount)
				else
					return false
				end

				local new_weight = vRP.getInventoryWeight(parseInt(user_id)) + vRP.getItemWeight(itemName) * parseInt(activedAmount[user_id])
				if new_weight <= vRP.getInventoryMaxWeight(parseInt(user_id)) then
					vRP.giveInventoryItem(parseInt(user_id),itemName,parseInt(activedAmount[user_id]))

					items[itemName].amount = parseInt(items[itemName].amount) - parseInt(activedAmount[user_id])

					if parseInt(items[itemName].amount) <= 0 then
						items[itemName] = nil
					end

					vRP.setSData(chestData,json.encode(items))
					return true
				end
			end
		end
	end
	return false
end

function vRP.openChest2(source,name,max_weight,cb_close,cb_in,cb_out)
	local user_id = vRP.getUserId(source)
	if user_id then
		local data = vRP.getUserDataTable(user_id)
		local identity = vRP.getUserIdentity(user_id)
		if data.inventory then
			if not chests[name] then
				local close_count = 0
				local chest = { max_weight = max_weight }
				chests[name] = chest 
				local cdata = vRP.getSData("chest:"..name)
				chest.items = json.decode(cdata) or {}

				local menu = { name = "Baú" }
				local cb_take = function(idname)
					local citem = chest.items[idname]
					local amount = vRP.prompt(source,"Quantidade:","")
					amount = parseInt(amount)
					if amount > 0 and amount <= citem.amount then
						local new_weight = vRP.getInventoryWeight(user_id)+vRP.getItemWeight(idname)*amount
						if new_weight <= vRP.getInventoryMaxWeight(user_id) then
							vRP.giveInventoryItem(user_id,idname,amount)
							SendWebhookMessage(webhookbaucasa,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU]: "..vRP.itemNameList(idname).." \n[QUANTIDADE]: "..vRP.format(parseInt(amount)).." \n[BAU]: "..name.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
							citem.amount = citem.amount - amount

							if citem.amount <= 0 then
								chest.items[idname] = nil
							end

							if cb_out then
								cb_out(idname,amount)
							end
							vRP.closeMenu(source)
						else
							TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.")
						end
					else
						TriggerClientEvent("Notify",source,"negado","Valor inválido.")
					end
				end

				local ch_take = function(player,choice)
					local weight = vRP.computeItemsWeight(chest.items)
					local submenu = build_itemlist_menu(string.format("%.2f",weight).." / "..max_weight.."kg",chest.items,cb_take)

					submenu.onclose = function()
						close_count = close_count - 1
						vRP.openMenu(player,menu)
					end
					close_count = close_count + 1
					vRP.openMenu(player,submenu)
				end

				local cb_put = function(idname)
					local amount = vRP.prompt(source,"Quantidade:","")
					amount = parseInt(amount)
					local new_weight = vRP.computeItemsWeight(chest.items)+vRP.getItemWeight(idname)*amount
					if new_weight <= max_weight then
						if amount > 0 and vRP.tryGetInventoryItem(user_id,idname,amount) then
							SendWebhookMessage(webhookbaucasa,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[GUARDOU]: "..vRP.itemNameList(idname).." \n[QUANTIDADE]: "..vRP.format(parseInt(amount)).." \n[BAU]: "..name.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
							local citem = chest.items[idname]

							if citem ~= nil then
								citem.amount = citem.amount + amount
							else
								chest.items[idname] = { amount = amount }
							end

							if cb_in then
								cb_in(idname,amount)
							end
							vRP.closeMenu(source)
						end
					else
						TriggerClientEvent("Notify",source,"negado","Baú cheio.")
					end
				end

				local ch_put = function(player,choice)
					local weight = vRP.computeItemsWeight(data.inventory)
					local submenu = build_itemlist_menu(string.format("%.2f",weight).." / "..max_weight.."kg",data.inventory,cb_put)

					submenu.onclose = function()
						close_count = close_count-1
						vRP.openMenu(player,menu)
					end

					close_count = close_count+1
					vRP.openMenu(player,submenu)
				end

				menu["Retirar"] = { ch_take }
				menu["Colocar"] = { ch_put }

				menu.onclose = function()
					if close_count == 0 then
						vRP.setSData("chest:"..name,json.encode(chest.items))
						chests[name] = nil
						if cb_close then
							cb_close()
						end
					end
				end
				vRP.openMenu(source,menu)
			else
				TriggerClientEvent("Notify",source,"importante","O baú está sendo utilizado no momento.")
			end
		end
	end
end