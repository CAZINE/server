local onMenu = false
local lastEquippedWeapon = nil -- Variável para salvar a última arma equipada

-- Recebe a lista de armas e abre o menu
RegisterNetEvent("weapon:open", function(weaponList)
	openSpawn(weaponList)
end)

function openSpawn(list)
	if list and not onMenu then
		onMenu = true
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = "open",
			weapons = list.weapons,
			playerLevel = list.playerLevel,
			permissions = list.permissions
		})		
	end
end

function closeSpawn()
	onMenu = false
	SetNuiFocus(false, false)
	SendNUIMessage({ action = "close" })
end

-- NUI callbacks
RegisterNUICallback("close", function(_, cb)
	closeSpawn()
	cb({})
end)

RegisterNUICallback("spawn", function(data, cb)
	TriggerServerEvent("spawnWeapon", data)
	cb({})
end)

RegisterNUICallback("sendWeapon", function(data, cb)
	TriggerServerEvent("spawnWeapon", data)
	closeSpawn()
	cb({})
end)

-- Novo callback para desequipar todas as armas
RegisterNUICallback("unequipAll", function(data, cb)
	unequipAllWeapons()
	cb({})
end)

-- Callback para desequipar arma individual
RegisterNUICallback("unequip", function(data, cb)
	local weaponHash = data and data.spawn
	if weaponHash then
		local ped = PlayerPedId()
		if HasPedGotWeapon(ped, weaponHash, false) then
			RemoveWeaponFromPed(ped, weaponHash)
			print('[WEAPON][CLIENT] Arma desequipada:', weaponHash)
		end
	end
	cb({})
end)

-- Função para salvar a arma atual equipada
function SaveCurrentWeapon()
	local player = PlayerPedId()
	local currentWeapon = GetSelectedPedWeapon(player)
	
	if currentWeapon ~= GetHashKey("WEAPON_UNARMED") then
		lastEquippedWeapon = currentWeapon
		print('[WEAPON][CLIENT] Arma salva para respawn:', currentWeapon)
		-- Salvar no servidor também
		TriggerServerEvent("weapon:saveLastWeapon", currentWeapon)
	end
end

-- Função para reequipar a última arma
function ReequipLastWeapon()
	if lastEquippedWeapon then
		local player = PlayerPedId()
		-- Aguardar um pouco para garantir que o jogador renasceu
		Wait(1000)
		
		-- Verificar se o jogador tem a arma
		if HasPedGotWeapon(player, lastEquippedWeapon, false) then
			SetCurrentPedWeapon(player, lastEquippedWeapon, true)
			print('[WEAPON][CLIENT] ✅ Arma reequipada:', lastEquippedWeapon)
			
			-- Atualizar HUD se disponível
			if UpdateHUDWeaponSlots then
				UpdateHUDWeaponSlots()
			end
		else
			print('[WEAPON][CLIENT] ❌ Jogador não tem a arma salva:', lastEquippedWeapon)
		end
	end
end

-- Função para desequipar todas as armas com lógica real
function unequipAllWeapons()
	local player = PlayerPedId()
	
	-- Salvar a arma atual antes de desequipar
	SaveCurrentWeapon()
	
	-- Log para debug
	print('[WEAPON][CLIENT] Iniciando desequipamento de todas as armas')
	
	-- Primeiro, forçar desequipamento da arma atual
	local currentWeapon = GetSelectedPedWeapon(player)
	if currentWeapon ~= GetHashKey("WEAPON_UNARMED") then
		print('[WEAPON][CLIENT] Desequipando arma atual:', currentWeapon)
		SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)
		Wait(100)
	end
	
	-- Verificar se o framework está disponível e usar suas funções
	if ForceUnequipAllWeapons then
		print('[WEAPON][CLIENT] Usando função do framework para desequipamento forçado')
		ForceUnequipAllWeapons()
	else
		print('[WEAPON][CLIENT] Framework não disponível, usando método nativo')
		-- Método alternativo: remover todas as armas e dar novamente
		RemoveAllPedWeapons(player, true)
		Wait(200)
		
		-- Forçar desequipamento múltiplas vezes para garantir
		for i = 1, 3 do
			SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)
			Wait(50)
		end
	end
	
	-- Verificar resultado final
	local finalWeapon = GetSelectedPedWeapon(player)
	if finalWeapon == GetHashKey("WEAPON_UNARMED") then
		print('[WEAPON][CLIENT] ✅ Desequipamento bem sucedido!')
		-- Notificar o servidor sobre o desequipamento
		TriggerServerEvent("weapon:unequippedAll")
	else
		print('[WEAPON][CLIENT] ❌ Falha no desequipamento, arma atual:', finalWeapon)
	end
	
	-- Atualizar HUD se disponível
	if UpdateHUDWeaponSlots then
		UpdateHUDWeaponSlots()
	end
end

-- Thread para monitorar morte do jogador
CreateThread(function()
	while true do
		Wait(1000)
		local player = PlayerPedId()
		
		-- Verificar se o jogador morreu
		if IsEntityDead(player) then
			-- Salvar a arma atual antes de morrer
			SaveCurrentWeapon()
			print('[WEAPON][CLIENT] Jogador morreu, arma salva para respawn')
			
			-- Aguardar o respawn
			while IsEntityDead(player) do
				Wait(500)
			end
			
			-- Jogador renasceu, reequipar a última arma
			Wait(2000) -- Aguardar um pouco mais para garantir que o respawn foi completo
			ReequipLastWeapon()
		end
	end
end)

-- Thread para monitorar mudança de arma e salvar
CreateThread(function()
	while true do
		Wait(500)
		local player = PlayerPedId()
		local currentWeapon = GetSelectedPedWeapon(player)
		
		-- Salvar a arma se ela mudou e não é unarmed
		if currentWeapon ~= GetHashKey("WEAPON_UNARMED") and currentWeapon ~= lastEquippedWeapon then
			lastEquippedWeapon = currentWeapon
			print('[WEAPON][CLIENT] Nova arma equipada salva:', currentWeapon)
		end
	end
end)

-- Comando + keybind
RegisterCommand("openWeaponMenu", function()
	TriggerServerEvent("weapon:requestWeapons")
end)

RegisterKeyMapping("openWeaponMenu", "Abrir menu de armas", "keyboard", "288")

-- Comando de teste para desequipar todas as armas
RegisterCommand("testunequipall", function()
	print('[TEST][WEAPON] Testando desequipamento de todas as armas via comando')
	unequipAllWeapons()
end, false)

-- Comando para testar reequipamento da última arma
RegisterCommand("testreequip", function()
	print('[TEST][WEAPON] Testando reequipamento da última arma')
	ReequipLastWeapon()
end, false)

RegisterNetEvent("weapon:removeWeapon")
AddEventHandler("weapon:removeWeapon", function(weaponHash)
	local ped = PlayerPedId()
	if HasPedGotWeapon(ped, weaponHash, false) then
		RemoveWeaponFromPed(ped, weaponHash)
	end
end)

RegisterNetEvent("weapon:equipNow")
AddEventHandler("weapon:equipNow", function(weaponHash)
	local ped = PlayerPedId()
	if HasPedGotWeapon(ped, weaponHash, false) then
		SetCurrentPedWeapon(ped, weaponHash, true)
		-- Salvar a arma equipada
		lastEquippedWeapon = weaponHash
	end
end)

-- Evento para receber a última arma do servidor (para sincronização)
RegisterNetEvent("weapon:receiveLastWeapon")
AddEventHandler("weapon:receiveLastWeapon", function(weaponHash)
	if weaponHash then
		lastEquippedWeapon = weaponHash
		print('[WEAPON][CLIENT] Última arma recebida do servidor:', weaponHash)
	end
end)

-- Sincronizar última arma quando o jogador se conecta
CreateThread(function()
	Wait(5000) -- Aguardar 5 segundos após conectar
	TriggerServerEvent("weapon:requestLastWeapon")
	print('[WEAPON][CLIENT] Solicitando última arma do servidor')
end)

-- Evento para receber atualização de nível
RegisterNetEvent("weapon:updateLevel")
AddEventHandler("weapon:updateLevel", function(level)
	print('[WEAPON][CLIENT] Nível atualizado para:', level)
	SendNUIMessage({ action = "updateLevel", level = level })
end)