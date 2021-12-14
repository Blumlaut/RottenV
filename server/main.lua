players = {}
ServerReady = false

RegisterServerEvent("Z:newplayer")
AddEventHandler("Z:newplayer", function(id)
	players[source] = id
	TriggerClientEvent("Z:playerUpdate", -1, players)
end)


local bannedNameParts = {"<script", "http:", "https:"}


RegisterServerEvent("Z:kickme")
AddEventHandler("Z:kickme", function(reason)
	DropPlayer(source, reason)
end)


Citizen.CreateThread(function()
	AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
		if not ServerReady then
			setKickReason("Server has not finished booting yet, please wait!")
			CancelEvent()
			return
		end
		if playerName:match("[^\000-\127]") then
			setKickReason("Invalid Username, please remove any non-ASCII characters from your Username.")
			CancelEvent()
		end
		for i,part in pairs(bannedNameParts) do
			if playerName:find(part) then
				setKickReason("I'm Bored.")
				CancelEvent()
				break
			end
		end
		if playerName:find("discord.gg") then
			setKickReason("Please remove any mention of 'discord.gg' from your Username.")
			CancelEvent()
		end
	end)
end)

AddEventHandler("playerDropped", function(reason)
	players[source] = nil
	TriggerClientEvent("Z:playerUpdate", -1, players)
	local pname = GetPlayerName(source)
	writeLog("\nPlayer dropped: " .. pname, 0)
	for i, pickupInfo in pairs(spawnedItems) do
		Citizen.Wait(100)
		if pname == pickupInfo.ownerName then
			TriggerEvent("removeOldItem", pickupInfo, "old client disconnected, removing their pickup\n")
		end
	end
end)

RegisterServerEvent("Z:killedPlayer")
AddEventHandler("Z:killedPlayer", function(playerId)
	TriggerClientEvent("Z:killedPlayer", playerId)
end)

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

local verFile = LoadResourceFile(GetCurrentResourceName(), "version.json")
local curVersion = json.decode(verFile).version
Citizen.CreateThread( function()
	local updatePath = "/Blumlaut/RottenV"
	local resourceName = "RottenV ("..GetCurrentResourceName()..")"
	PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/version.json", function(err, response, headers)
		local data = json.decode(response)
		
		
		if curVersion ~= data.version and tonumber(curVersion) < tonumber(data.version) then
			print("\n--------------------------------------------------------------------------")
			print("\n"..resourceName.." is outdated.\nCurrent Version: "..data.version.."\nYour Version: "..curVersion.."\nPlease update it from https://github.com"..updatePath.."")
			print("\nUpdate Changelog:\n"..data.changelog)
			print("\n--------------------------------------------------------------------------")
		elseif tonumber(curVersion) > tonumber(data.version) then
			print("Your version of "..resourceName.." seems to be higher than the current version.")
		else
			print(resourceName.." is up to date!")
		end
	end, "GET", "", {version = 'this'})
end)

-- removed for public release.
--[[

-- automatic reboot script
Citizen.CreateThread(function()
	local onehr,halfhr,fiftmin,fivmin,onemin,rebootnow = false,false,false,false,false,false


	while true do 
		Wait(10000)
		
		
		--
		
		if tonumber(os.date("%H")) == 1 and tonumber(os.date("%M")) == 0 and not onehr then
			print("[WARNING] ^1SERVER REBOOT IN ONE HOUR")
			TriggerClientEvent("chat:addMessage", -1, { templateId = "defaultAlt", args = { "[WARNING] ^1SERVER REBOOT IN ONE HOUR" } })
			onehr = true
		elseif tonumber(os.date("%H")) == 1 and tonumber(os.date("%M")) == 30 and not halfhr then
			halfhr = true
			print("[WARNING] ^1SERVER REBOOT IN 30 MINUTES")
			TriggerClientEvent("chat:addMessage", -1, { templateId = "defaultAlt", args = { "[WARNING] ^1SERVER REBOOT IN 30 MINUTES" } })
		elseif tonumber(os.date("%H")) == 1 and tonumber(os.date("%M")) == 45 and not fiftmin then
			fiftmin = true
			print("[WARNING] ^1SERVER REBOOT IN 15 MINUTES")
			TriggerClientEvent("chat:addMessage", -1, { templateId = "defaultAlt", args = { "[WARNING] ^1SERVER REBOOT IN 15 MINUTES" } })
		elseif tonumber(os.date("%H")) == 1 and tonumber(os.date("%M")) == 55 and not fivmin then
			fivmin = true
			print("[WARNING] ^1SERVER REBOOT IN 5 MINUTES")
			TriggerClientEvent("chat:addMessage", -1, { templateId = "defaultAlt", args = { "[WARNING] ^1SERVER REBOOT IN 5 MINUTES" } })
		elseif tonumber(os.date("%H")) == 1 and tonumber(os.date("%M")) == 59 and not onemin then
			onemin = true
			print("[WARNING] ^1SERVER REBOOT IN 1 MINUTE")
			TriggerClientEvent("chat:addMessage", -1, { templateId = "defaultAlt", args = { "[WARNING] ^1SERVER REBOOT IN 1 MINUTES" } })
		elseif tonumber(os.date("%H")) == 2 and tonumber(os.date("%M")) == 0 and not rebootnow then
			rebootnow = true
			print("[WARNING] ^1SERVER IS REBOOTING")
			TriggerClientEvent("chat:addMessage", -1, { templateId = "defaultAlt", args = { "[WARNING] ^1SERVER IS REBOOTING" } })
			Wait(2000)
			for i,Player in pairs(GetPlayers()) do
				DropPlayer(Player, "Server Rebooting.")
			end
			Wait(500)
			os.exit()
		end
	end
end)


--]]
