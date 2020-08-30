firstSpawn = true

SetManualShutdownLoadingScreenNui(true)
local weapons =
{
	"weapon_Knife",
	"weapon_Nightstick",
	"weapon_Hammer",
	"weapon_Bat",
	"weapon_GolfClub",
	"weapon_Crowbar",
	"weapon_Bottle",
	"weapon_SwitchBlade",
	"weapon_Pistol",
	"weapon_CombatPistol",
	"weapon_APPistol",
	"weapon_Pistol50",
	"weapon_FlareGun",
	"weapon_MarksmanPistol",
	"weapon_Revolver",
	"weapon_MicroSMG",
	"weapon_SMG",
	"weapon_AssaultSMG",
	"weapon_CombatPDW",
	"weapon_AssaultRifle",
	"weapon_CarbineRifle",
	"weapon_AdvancedRifle",
	"weapon_CompactRifle",
	"weapon_MG",
	"weapon_CombatMG",
	"weapon_PumpShotgun",
	"weapon_SawnOffShotgun",
	"weapon_AssaultShotgun",
	"weapon_BullpupShotgun",
	"weapon_DoubleBarrelShotgun",
	"weapon_StunGun",
	"weapon_SniperRifle",
	"weapon_HeavySniper",
	"weapon_Grenade",
	"weapon_StickyBomb",
	"weapon_SmokeGrenade",
	"weapon_Molotov",
	"weapon_FireExtinguisher",
	"weapon_PetrolCan",
	"weapon_SNSPistol",
	"weapon_SpecialCarbine",
	"weapon_HeavyPistol",
	"weapon_BullpupRifle",
	"weapon_VintagePistol",
	"weapon_Dagger",
	"weapon_Musket",
	"weapon_MarksmanRifle",
	"weapon_HeavyShotgun",
	"weapon_Gusenberg",
	"weapon_Hatchet",
	"weapon_KnuckleDuster",
	"weapon_Machete",
	"weapon_MachinePistol",
	"weapon_Flashlight",
	"weapon_SweeperShotgun",
	"weapon_BattleAxe",
	"weapon_MiniSMG",
	"weapon_PipeBomb",
	"weapon_PoolCue",
	"weapon_Wrench",
	"weapon_Pistol_Mk2",
	"weapon_AssaultRifle_Mk2",
	"weapon_CarbineRifle_Mk2",
	"weapon_CombatMG_Mk2",
	"weapon_HeavySniper_Mk2",
	"weapon_SMG_Mk2",
}


LoadedPlayerData = false
playtime = {}
playtime.minute = 0
playtime.hour = 0
playtime.second = 0
zombiekillsthislife = 0
playerkillsthislife = 0
zombiekills = 0
playerkills = 0
locker_money = 0

	
RegisterNetEvent("requestDaily")
AddEventHandler("requestDaily", function(a)
	Quests[97].finishrequirements = a[1].finishrequirements
	Quests[97].finishloot = a[1].finishloot
	Quests[98].finishrequirements = a[2].finishrequirements
	Quests[98].finishloot = a[2].finishloot
	Quests[99].finishrequirements = a[3].finishrequirements
	Quests[99].finishloot = a[3].finishloot
	GenerateQuestDescriptions()
	Citizen.Trace("\nrequested daily")
end) -- reqeest daily info



	
Citizen.CreateThread( function()
	SwitchOutPlayer(PlayerPedId(), 0, 1)
	RegisterNetEvent('loadPlayerIn')
	AddEventHandler('loadPlayerIn', function(data)
		local success, err = pcall(function()
			PlayerUniqueId = data.ids
			TriggerServerEvent("requestDaily")
			-- prepare our variables
			humanity = tonumber(data.humanity)
				
			local inventory = data.inv
			local hunger = data.hunger
			local thirst = data.thirst
			local isInfected = data.isInfected
			local x,y,z = tonumber(data.x), tonumber(data.y), tonumber(data.z)
			currentQuest = json.decode(data.currentQuest)
			finishedQuests = json.decode(data.finishedQuests)
			-- reset daily
			
			
			wheelspins = data.wheelspins
			local _,_,day = GetUtcTime()
			local lastLoginDay = GetResourceKvpInt("last_login_day")
			if not lastLoginDay or not type(lastLoginDay) == "number" then
				SetResourceKvpInt("last_login_day",day)
			elseif lastLoginDay == (day-1) then
				wheelspins=wheelspins+1
				TriggerEvent("showNotification", "Daily Login Reward! Get your Free Wheelspin in the Hub!")
			end
			SetResourceKvpInt("last_login_day",day)
				
			if lastLoginDay ~= day and currentQuest.id and currentQuest.id >= 97 then 
				AbortQuest(currentQuest.id)
			end
			for i,quest in pairs(finishedQuests) do
				if (quest == 97 or quest == 98 or quest == 99) and GetResourceKvpInt("quest_day") ~= day then
					table.remove(finishedQuests,i)
				end
			end
			
			-- set money values
			consumableItems.count[17] = tonumber(data.money) 
			locker_money = tonumber(data.locker_money) 

			Citizen.Trace("\nRecieving Stats...")
			local currentPlayerModel = config.skins.neutral
			customSkin = data.customskin
			
			if not customSkin or customSkin == "" then
				if humanity > 800 then -- hero skin
					currentPlayerModel = config.skins.hero
				elseif humanity < 800 and humanity > 200 then -- neutral skin
					currentPlayerModel = config.skins.neutral
				elseif humanity < 200 then -- bandit skin
					currentPlayerModel = config.skins.bandit
				end
			else
				currentPlayerModel = customSkin
			end
			if currentPlayerModel then
				if not HasModelLoaded(currentPlayerModel) then
					RequestModel(currentPlayerModel)
				end
				while not HasModelLoaded(currentPlayerModel) do
					Wait(1)
				end
				SetPlayerModel(PlayerId(), currentPlayerModel)
				SetPedRandomComponentVariation(PlayerPedId(), true)
			end
			
			
			for i,data in ipairs(mysplit(data.playtime, ":")) do
				if i == 1 then
					playtime.hour = tonumber(data)
				elseif i == 2 then
					playtime.minute = tonumber(data)
				end
			end
			RequestCollisionAtCoord(x+.0,y+.0,z+.0)
			
			local currentzcoord = z
			local L = "wtf"
			repeat -- do a basic collision request and then request cols until we got our ground z, otherwise it will be 0
				Wait(1)
				RequestCollisionAtCoord(x, y, currentzcoord)
				foundzcoord,z = GetGroundZFor_3dCoord(x, y, z+9999.0, 0)
				if foundzcoord then 
					Citizen.Trace("\nfound z coord! "..z) 
				end
				if currentzcoord < -100 then -- if we go too low, go back up
					foundzcoord = true
					Citizen.Trace("\ndidn't find zcoord :(")
					z = 500.0 -- force a high up spawn
				end
				currentzcoord = currentzcoord-5.0
			until foundzcoord
			GiveWeaponToPed(PlayerPedId(), 0xFBAB5776,1, false, true) -- force player to have a parachute

			local playerPed = PlayerPedId()
			SetEntityCoords(playerPed,x+.0,y+.0,z+1.5,1,0,0,1)
			ShutdownLoadingScreenNui()
			Citizen.Trace("\nshutting down loadscreen")
			local wt = json.decode(inventory)
			if wt[1] and not wt[1].id then
				for i,w in ipairs(wt) do
					consumableItems.count[i] = w.count
					if consumableItems[i].requiredbatteries then
						consumableItems[i].charge = (w.charge or 100)
					end
							
					if consumableItems[i].isWeapon and w.count ~= 0 and w.count ~= 1 then
						GiveWeaponToPed(PlayerPedId(), consumableItems[i].hash, w.count, false, false)
						if w.attachments then
							for _,attachment in pairs(w.attachments) do
								if DoesWeaponTakeWeaponComponent(consumableItems[i].hash, GetHashKey(attachment)) then
									GiveWeaponComponentToPed(PlayerPedId(), consumableItems[i].hash, GetHashKey(attachment))
								end
							end
						end
					end
				end
			else
				for i,w in ipairs(wt) do
					consumableItems.count[w.id] = w.count
					if consumableItems[w.id].requiredbatteries then
						consumableItems[w.id].charge = (w.charge or 100)
					end
							
					if consumableItems[w.id].isWeapon and w.count ~= 0 and w.count ~= 1 then
						GiveWeaponToPed(PlayerPedId(), consumableItems[w.id].hash, w.count, false, false)
						if w.attachments then
							for _,attachment in pairs(w.attachments) do
								if DoesWeaponTakeWeaponComponent(consumableItems[w.id].hash, GetHashKey(attachment)) then
									GiveWeaponComponentToPed(PlayerPedId(), consumableItems[w.id].hash, GetHashKey(attachment))
								end
							end
						end
					end
				end
			end

			DecorSetFloat(playerPed, "hunger", hunger)
			DecorSetFloat(playerPed, "thirst", thirst)
			if not DoesPlayerHaveCBRadio() then -- make sure player has at least the basic CB
				consumableItems.count[92] = 1
			end
			humanity = humanity+0.001
			playerkills = data.playerkills
			zombiekills = data.zombiekills
			playerkillsthislife = data.playerkillsthislife
			zombiekillsthislife = data.zombiekillsthislife
			SetEntityHealth(PlayerPedId(), data.health)
			infected = tobool(data.infected)
			Wait(500)
			N_0xd8295af639fd9cb8(PlayerPedId())
			Wait(5000)
			LoadedPlayerData = true
			Citizen.Trace("\nDone, we should spawn soon!")
		end)
		if not success then
			TriggerServerEvent("SentryIO_Error", err, debug.traceback())
		end
	end)
end)

Citizen.CreateThread(function()
	AddEventHandler("playerSpawned", function()
		if firstSpawn then
			TriggerServerEvent("spawnPlayer", GetPlayerServerId(PlayerId()))

			Citizen.Trace("\nRequesting Spawn!")
			Citizen.Trace("\nSent!")
			firstSpawn = false
		end
		Wait(500)
		SetPedRandomComponentVariation(PlayerPedId(), true)
		SetNightvision(false)
		SetSeethrough(false)
	end)

	RegisterNetEvent('Z:killedPlayer')
	AddEventHandler("Z:killedPlayer", function(phumanity,weapon)
		local playerPed = PlayerPedId()
		playerkills = playerkills+1
		playerkillsthislife = playerkillsthislife+1
		if phumanity <= 300 and phumanity >= 200 then
			humanity = humanity+20
		elseif phumanity < 200 and phumanity >= 100 then 
			humanity = humanity+30
		elseif phumanity < 100 and phumanity >= 0 then
			humanity = humanity+45
		elseif phumanity < 0 then
			humanity = humanity+50
		else
			humanity = humanity-50
		end
		
		if currentQuest.active then
			if phumanity <= 300 then
				if Quests[currentQuest.id].finishrequirements.withweapon then
					if weapon == Quests[currentQuest.id].finishrequirements.withweapon then
						currentQuest.progress.banditkills = currentQuest.progress.banditkills+1
					end
				else
					currentQuest.progress.banditkills = currentQuest.progress.banditkills+1
				end
			elseif phumanity >= 700 then 
				if Quests[currentQuest.id].finishrequirements.withweapon then
					if weapon == Quests[currentQuest.id].finishrequirements.withweapon then
						currentQuest.progress.herokills = currentQuest.progress.herokills+1
					end
				else
					currentQuest.progress.herokills = currentQuest.progress.herokills+1
				end
			end
		end
	end)
end)


RegisterNetEvent("c_killedZombie")
AddEventHandler("c_killedZombie", function(weapon)
	if LoadedPlayerData then 
		consumableItems.count[17] = consumableItems.count[17]+1
		TriggerServerEvent("AddLegitimateMoney", 1)
		zombiekillsthislife = zombiekillsthislife+1
		zombiekills = zombiekills+1
		
		if currentQuest.active then
			if Quests[currentQuest.id].finishrequirements.withweapon then
				if weapon == Quests[currentQuest.id].finishrequirements.withweapon then
					currentQuest.progress.zombiekills = currentQuest.progress.zombiekills+1
				end
			else
				currentQuest.progress.zombiekills = currentQuest.progress.zombiekills+1
			end
		end
	end
end)

Citizen.CreateThread(function()
	function initiateSave(disallowTimer)
		local success, err = pcall(function()
			if not LoadedPlayerData then 
				Citizen.Trace("\nPlayer Data not Ready, Cancelling Save...")
				return 
			end
			local playerPed = PlayerPedId()
			local posX,posY,posZ = table.unpack(GetEntityCoords(playerPed,true))
			local hunger = DecorGetFloat(PlayerPedId(),"hunger")
			local thirst = DecorGetFloat(PlayerPedId(),"thirst")
			local playerkills = playerkills
			local zombiekills = zombiekills
			local playerkillsthislife = playerkillsthislife
			local zombiekillsthislife = zombiekillsthislife
			local wheelspins = wheelspins
			local money = consumableItems.count[17]
			if money > 500000000 then
				money = 0 -- naughty cheater protection
			end
			if locker_money > 10000 then
				locker_money = 0
			end

			local PedItems = {}
			for i,theItem in ipairs(consumableItems) do
				local attachments = {}
				local count = consumableItems.count[i]
				if i ~= 17 and count > 1000 and not consumableItems[i].isWeapon then 
					TriggerServerEvent("AntiCheese:CustomFlag", "Item Cheating", "had "..consumableItems.count[i].." "..(consumableItems[i].multipleCase or consumableItems[i].name)..".")	
					count = 0 --naughty cheater protection
					consumableItems[i].count = 0
				end
				if consumableItems[i].isWeapon then
					if HasPedGotWeapon(PlayerPedId(), consumableItems[i].hash, false) then
						if consumableItems[i].hasammo == false then 
							consumableItems.count[i] = 1
							count = 1
						else
							consumableItems.count[i] = GetAmmoInPedWeapon(PlayerPedId(), consumableItems[i].hash)
							count = GetAmmoInPedWeapon(PlayerPedId(), consumableItems[i].hash)
						end
						for _,attachment in ipairs(weaponComponents) do
							if DoesWeaponTakeWeaponComponent(consumableItems[i].hash, GetHashKey(attachment.hash)) and HasPedGotWeaponComponent(PlayerPedId(), consumableItems[i].hash, GetHashKey(attachment.hash)) then
								table.insert(attachments, attachment.hash)
							end
						end
					else
						consumableItems.count[i] = 0
						count = 0
					end
				end
				if #attachments == 0 then
					attachments = nil
				end
				local charge = consumableItems[i].charge
				if consumableItems.count[i] > 0 then
					table.insert(PedItems, {id = i, count = count, attachments = attachments, charge = charge})
				end
			end
			local PedItems = json.encode(PedItems)
			local quest = {}
			local finquests = json.encode(finishedQuests)
			if currentQuest.active then
				quest = json.encode(currentQuest)
			else
				quest = json.encode({})
			end
			local data = { posX = posX, posY = posY, posZ = posZ, hunger = hunger, thirst = thirst, inv = PedItems, health = GetEntityHealth(PlayerPedId()), playerkillsthislife = playerkillsthislife, zombiekillsthislife = zombiekillsthislife, playerkills = playerkills, zombiekills = zombiekills, humanity = humanity, money = money, infected = infected, playtime = playtime, currentQuest = quest, finishedQuests = finquests, locker_money = locker_money, wheelspins = wheelspins }
			TriggerServerEvent("SavePlayerData",data)
			Citizen.Trace("\nSaving PlayerData!")
		end)
		if not success then
			TriggerServerEvent("SentryIO_Error", err, debug.traceback())
		end
		if disallowTimer ~= true then
			SetTimeout(60000, initiateSave)
		end
	end
	SetTimeout(60000, initiateSave)
end)


-- playtime calculation
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if playtime.second then
			playtime.second = playtime.second+1
			if playtime.second >= 60 then
				playtime.second = 0
				playtime.minute = playtime.minute+1
			end
			if playtime.minute >= 60 then
				playtime.minute = 0
				playtime.hour = playtime.hour+1
			end
		end
	end
end)

RegisterNetEvent('playerRegistered')
AddEventHandler("playerRegistered", function()
	local success, err = pcall(function()
		Citizen.Trace("\nplayer registered")
		TriggerServerEvent("requestDaily")
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
		local currentzcoord = z
		repeat -- do a basic collision request and then request cols until we got our ground z, otherwise it will be 0
			Wait(1)
			RequestCollisionAtCoord(x, y, currentzcoord)
			foundzcoord,z = GetGroundZFor_3dCoord(x, y, z+9999.0, 0)
			if foundzcoord then Citizen.Trace("\nfound z coord! "..z) end
			if currentzcoord < -100 then -- if we go too low, go back up
				foundzcoord = true
				Citizen.Trace("\ndidn't find zcoord :(")
				z = 500.0 -- force a high up spawn
			end
			currentzcoord = currentzcoord-5.0
		until foundzcoord
		ShutdownLoadingScreenNui() -- shut down loading screen
		Citizen.Trace("\nshutting down loadscreen")
		SetEntityCoords(PlayerPedId(), x, y, z+1.0, 0, 0, 0, false) -- teleport player to ground
		playerkillsthislife = 0
		zombiekillsthislife = 0
		wheelspins = 1
		infected = false
		for i, count in pairs(config.startItems) do
			consumableItems.count[i] = count
		end
		TriggerServerEvent("SetLegitimateMoney", config.startMoney)
		consumableItems.count[17] = config.startMoney


		Wait(300)
		N_0xd8295af639fd9cb8(PlayerPedId()) -- move camera back to player
		Wait(8000)
		Citizen.Trace("\nplayer registered ")
		LoadedPlayerData = true
	end)
	if not success then
		TriggerServerEvent("SentryIO_Error", err, debug.traceback())
	end
	
	
end)


RegisterNetEvent('SetCorrectedMoney')
AddEventHandler("SetCorrectedMoney", function(value)
	consumableItems.count[17] = value
end)

Citizen.CreateThread(function()
	local last = 0
	repeat
		if DoesEntityExist(PlayerPedId()) then
			FreezeEntityPosition(PlayerPedId(), true)
			SetEntityProofs(PlayerPedId(), true, true, true, true, true, true, true, true)
		end
		HideHUDThisFrame()
		Wait(0)
	until LoadedPlayerData
	FreezeEntityPosition(PlayerPedId(),false)
	SetEntityProofs(PlayerPedId(), false, false, false, false, false, false, false, false)
	
end)
