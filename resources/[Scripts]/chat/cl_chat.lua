-----------------------------------------------------------------------------------------------------------------------------------------
-- Chat (PvP Framework)
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local chatInputActive = false
local chatInputActivating = false
local chatHidden = false
local chatLoaded = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- HANDLER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chatMessage")
AddEventHandler("chatMessage",function(loc,user_id,name,message,color)
	if chatHidden then  
		return
	end

	if string.len(message) > 100 then
		return
	end
	
	local lowerMessage = string.lower(message)
	local blockList = { "crush","krush","foguete","fogas","north","macaco","ghost","eulen","monster","asgard","skript","redengine","felipemenu","primata","traveco","travesti","veveco","puta","putinha","vagabunda","cadela","prostituta","negro","pretinho","chimpanze","ximpanze","baleia","escurinho","gordo","gordinho","obeso" }

	local subTable = { ["u"] = "[u$]", ["s"] = "[s$5]", ["h"] = "[h#]", ["a"] = "[a@4]", ["i"] = "[i!1]", ["e"] = "[e3]", ["o"] = "[o0]", ["t"] = "[t7]", ["g"] = "[g9]", ["z"] = "[z2]" }

	for _, blockWord in ipairs(blockList) do
		blockWord = string.lower(blockWord)
		for k, v in pairs(subTable) do
			blockWord = string.gsub(blockWord, k, v)
		end
		if string.find(lowerMessage,blockWord) then
			return
		end
	end
	
	SendNUIMessage({ type = "ON_MESSAGE", message = { color = color, multiline = true, templateId = "kush", args = { loc,user_id,name,message } } })
end)

RegisterNetEvent("chatMessage2")
AddEventHandler("chatMessage2", function(loc,name,message,color)
	if chatHidden then  
		return
	end
	SendNUIMessage({ type = "ON_MESSAGE", message = { color = color, multiline = true, templateId = "kush2", args = { loc,name,message } } })
end)

RegisterNetEvent("__cfx_internal:serverPrint")
AddEventHandler("__cfx_internal:serverPrint",function(msg,a,b)
	if msg ~= "" then
		SendNUIMessage({ type = "ON_MESSAGE", message = { color = {18,172,90}, multiline = true, templateId = "kush2", args = { "fa-solid fa-server","SERVIDOR",msg } } })
	end
end)

RegisterNetEvent("chat:addMessage")
AddEventHandler("chat:addMessage",function(message)
	SendNUIMessage({ type = "ON_MESSAGE", message = message })
end)

RegisterNetEvent("chat:addTemplate")
AddEventHandler("chat:addTemplate",function(id, html)
	SendNUIMessage({ type = "ON_TEMPLATE_ADD",template = { id = id, html = html } })
end)

RegisterNetEvent("characters:changeServer")
AddEventHandler("characters:changeServer",function(sv)
	SendNUIMessage({ type = "ON_CLEAR" })
end)

RegisterNetEvent("chat:clear")
AddEventHandler("chat:clear",function(name)
	SendNUIMessage({ type = "ON_CLEAR" })
end)

RegisterNUICallback("chatResult", function(data, cb)
	chatInputActive = false
	SetNuiFocus(false)

	if not data.canceled then
		local id = PlayerId()
		local r, g, b = 0, 0x99, 255

		if data.message:sub(1, 1) == "/" then
			ExecuteCommand(data.message:sub(2))
		else
			TriggerServerEvent("_chat:messageEntered", GetPlayerName(id), { r, g, b }, data.message)
		end
	end

	cb("ok")
end)

local function refreshThemes()
	local themes = {}

	for resIdx = 0, GetNumResources() - 1 do
		local resource = GetResourceByFindIndex(resIdx)

		if GetResourceState(resource) == "started" then
			local numThemes = GetNumResourceMetadata(resource, "chat_theme")

			if numThemes > 0 then
				local themeName = GetResourceMetadata(resource, "chat_theme")
				local themeData = json.decode(GetResourceMetadata(resource, "chat_theme_extra") or "null")

				if themeName and themeData then
					themeData.baseUrl = "nui://" .. resource .. "/"
					themes[themeName] = themeData
				end
			end
		end
	end
	SendNUIMessage({ type = "ON_UPDATE_THEMES", themes = themes })
end

AddEventHandler("onClientResourceStart",function(resName)
	Citizen.Wait(500)
	refreshThemes()
end)

RegisterNUICallback("loaded",function(data,cb)
	refreshThemes()
	chatLoaded = true
	cb("ok")
end)

RegisterKeyMapping("chatopen","chatopen","keyboard","t")

RegisterCommand("chatopen", function()
  if not chatInputActive then
		chatInputActive = true
		chatInputActivating = true

		SendNUIMessage({
			type = "ON_OPEN"
		})
  end

  if chatInputActivating then
		SetNuiFocus(true)

		chatInputActivating = false
  end
end)

RegisterCommand("ocultar",function()
	if chatHidden then
		chatHidden = false
	else
		chatHidden = true
	end

	SendNUIMessage({
		type = "ON_SCREEN_STATE_CHANGE",
		shouldHide = chatHidden
	  })
end)

exports('toggle', function(status)
	SendNUIMessage({
		type = "ON_SCREEN_STATE_CHANGE",
		shouldHide = status
	  })
end)

Citizen.CreateThread(function()
  SetTextChatEnabled(false)
  SetNuiFocus(false)
end)