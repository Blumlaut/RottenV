TESTMODE = tobool(GetConvar("rottenv_testmode", "false"))


if TESTMODE then
	print("^1TEST MODE ENABLED, DATABASE FEATURES ARE DISABLED!^7\n")
end

local charset = {}
for i = 48,  57 do table.insert(charset, string.char(i)) end
for i = 65,  90 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end

function string.random(length)
  math.randomseed(os.time())
  if length > 0 then
    return string.random(length - 1) .. charset[math.random(1, #charset)]
  else
    return ""
  end
end


PreparedPlayerData = {}

-- this script intercepts data send by clients that want to save their data, dirty but effective


Citizen.CreateThread(function()
	AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
		local numIds = GetPlayerIdentifiers(source)
		local s = source
		local client = source
		local n = name
		local deferrals = deferrals
		local cooked=nil
		local steamid = GetPlayerSpecificIdentifier(client,"steam")
		local license = GetPlayerSpecificIdentifier(client,"license")
		local discord = GetPlayerSpecificIdentifier(client,"discord") 
		local PlayerInfo = {}
		deferrals.defer()
		deferrals.update("Loading Player Data (0/3)")
		if not GetPlayerSpecificIdentifier(client,"steam") then 
			deferrals.done("Identifier Authentication Failed. Please make sure Steam is running.")
			return 
		end

		if TESTMODE == true then
			local tint = {}
			for i, item in ipairs(consumableItems) do
				tint[i] = {item = "", count = 10}
			end
			tint[17].count = 500000
			PreparedPlayerData[steamid] = {ids = 0, name = "thisname", steamid = steamid, license = license, discord = 0, x = -276.6, y=-322.8, z=30.00, hunger = 99.9, thirst = 99.9, weapons = "[]", inv = json.encode(tint), health=200, playerkillsthislife=50,zombiekillsthislife=50,playerkills=50,zombiekills=50, humanity=500, infected="false", money = 500000, locker_money=10000, wheelspins=99, playtime="0:1", currentQuest="[]",finishedQuests="[]", customskin=""}
			cooked = true
		else
			exports['ghmattimysql']:execute('SELECT * FROM players where steamid=@steamid LIMIT 1', { steamid = steamid }, function(player)
				if player[1] then
					if player[1].steamid == GetPlayerSpecificIdentifier(client,"steam") then
						
						if discord and player[1].discord ~= string.gsub(discord, "discord:", "") then
							discord = string.gsub(discord, "discord:", "")
							exports['ghmattimysql']:execute('UPDATE players SET discord=@discord WHERE steamid=@steamid LIMIT 1', { discord = discord, steamid = steamid }, function() end)
							player[1].discord = discord
						end
						PreparedPlayerData[steamid] = player[1]
						cooked = true
					end
				else
					exports['ghmattimysql']:execute('INSERT INTO players (steamid, x, y, z, hunger, thirst, license, name, discord) VALUES(@steamid, 0.0, 0.0, 77.0, 100.0, 100.0, @license, @name, "") ', { steamid = steamid, license = license, discord = discord or "", name = GetPlayerName(client) }, function() end)
					PreparedPlayerData[steamid] = nil
					cooked = true
				end
			end)
		end


		local failtime = 0
		repeat
			deferrals.update("Loading Player Data (1/3)")
			failtime=failtime+1
			if failtime >= 40 then
				cooked=false
			end
			Wait(500)
		until (cooked == true or cooked == false)
		if cooked == false then
			deferrals.done("An Unknown Error occured while loading PlayerData 1/2.")
			return
		end
		local cooked=nil
		
		local discord = false
		if GetPlayerSpecificIdentifier(client,"discord") then
			discord = GetPlayerSpecificIdentifier(client,"discord")
		elseif PreparedPlayerData[steamid] and PreparedPlayerData[steamid].discord then
			discord = "discord:"..PreparedPlayerData[steamid].discord
		end

		local failtime = 0
		repeat
			deferrals.update("Loading Player Data (2/2)")
			failtime=failtime+1
			if failtime >= 40 then
				cooked1=false
			end
			Wait(500)
		until (cooked1 == true or cooked1 == false)



		deferrals.update("Joining...")
		Wait(500)
		if cooked1 == false then
			deferrals.done("An Unknown Error occured while loading PlayerData 2/2.")
			return
		end
		deferrals.done()
	end)
end)
		
		
				
		

Citizen.CreateThread(function()
	RegisterServerEvent('SavePlayerData')

	AddEventHandler("SavePlayerData", function(data)
		local source = source
		local pName = GetPlayerName(source)
		local pId = source
		local humanity = "Unknown"
		
		if data.humanity > 800 then
			humanity = "Hero"
		elseif data.humanity < 800 and data.humanity > 200 then
			humanity = "Neutral"
		elseif data.humanity < 200 then
			humanity = "Bandit"
		end
		local playtime = string.format("%02d:%02d", data.playtime.hour, data.playtime.minute)
		TriggerClientEvent("gtaoscoreboard:EditCell", -1, "Player Kills", pId, data.playerkillsthislife)
		TriggerClientEvent("gtaoscoreboard:EditCell", -1, "Zombie Kills", pId, data.zombiekillsthislife)
		TriggerClientEvent("gtaoscoreboard:EditCell", -1, "Status", pId, humanity)
		TriggerClientEvent("gtaoscoreboard:EditCell", -1, "Playtime", pId, playtime)
	end)
end)

function GetPlayerSpecificIdentifier(player,identifier)
	local numIds = GetNumPlayerIdentifiers(player)
	for i = 0, numIds - 1 do
		if string.find(GetPlayerIdentifier(player, i),identifier) then
			return GetPlayerIdentifier(player, i)
		end
	end
	return false
end



RegisterServerEvent('spawnPlayer')
RegisterServerEvent('SavePlayerData')
Citizen.CreateThread(function()
		AddEventHandler('spawnPlayer', function()
			Citizen.Trace("\nClient Requested Spawn!\n")
			local client = source
			if not GetPlayerSpecificIdentifier(client,"steam") then 
				DropPlayer(client, "Identifier Authentication Failed. Please make sure Steam is running and you are opted-out of Steam Beta.") --  we cant do anything without identifiers
				return 
			end

			local success, err = pcall(function()
				local steamid = GetPlayerSpecificIdentifier(client,"steam")
				local license = GetPlayerSpecificIdentifier(client,"license")
				local PlayerInfo = PreparedPlayerData[steamid]
				
				TriggerEvent("registerPlayerInv", client, PlayerInfo or {money = 0})
				if PlayerInfo then
					TriggerClientEvent("loadPlayerIn", client, PlayerInfo)
				else
					TriggerClientEvent("playerRegistered", client)
				end
				PreparedPlayerData[steamid] = nil
			end)
		if not success then
			TriggerEvent("SentryIO_Error", err, debug.traceback())
		end
	end)

	AddEventHandler("SavePlayerData", function(data)
		local client = source
		if not GetPlayerSpecificIdentifier(client,"steam") then
			print("player doesnt have steamid, cancelling save!\n")
			TriggerEvent("SentryIO_Warning", "Player Identifier Missing (save)", "Player Requested Save but steamid did not exist.\nUsername:"..GetPlayerName(source))
			return
		end
		local steamid = GetPlayerSpecificIdentifier(client,"steam")
		local license = GetPlayerSpecificIdentifier(client,"license")
		Citizen.Trace("\nClient Requested Save!\n")
		if not TESTMODE then
			exports['ghmattimysql']:execute('UPDATE players SET x=@x, y=@y, z=@z, hunger=@hunger, thirst=@thirst, inv=@inv, health=@health, playerkillsthislife=@playerkillsthislife, zombiekillsthislife=@zombiekillsthislife, playerkills=@playerkills, zombiekills=@zombiekills, humanity=@humanity, money=@money, locker_money=@locker_money, wheelspins=@wheelspins,infected=@infected, playtime=@playtime, currentQuest=@currentQuest, finishedQuests=@finishedQuests, name=@name, license=@license, steamid=@steamid WHERE steamid=@steamid', {name = GetPlayerName(client), x = data.posX, y = data.posY, z = data.posZ, hunger = data.hunger, thirst = data.thirst, inv = data.inv, health = data.health, playerkillsthislife = data.playerkillsthislife, zombiekillsthislife = data.zombiekillsthislife, playerkills = data.playerkills, zombiekills = data.zombiekills, humanity = data.humanity, money = data.money, locker_money = data.locker_money, wheelspins=data.wheelspins,infected = tostring( data.infected ), playtime = data.playtime.hour..':'..data.playtime.minute, currentQuest = data.currentQuest, finishedQuests = data.finishedQuests, license = license, steamid = steamid  }, function() end)
		end
	end)
end)
