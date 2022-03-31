-- CONFIG --

local spawnWithFlashlight = true
local displayRadar = true
local bool = true
local firstSpawn = true
-- CODE --
AddRelationshipGroup("PLAYER")

Citizen.CreateThread(function()
	Wait(1)
	if bool then
		TriggerServerEvent("Z:newplayer", PlayerId())
		TriggerServerEvent("Z:newplayerID", GetPlayerServerId(PlayerId()))
		bool = false
		SetBlackout(true)
	end
end)

local welcomed = false
DecorRegister("hunger",1)
DecorRegister("thirst",1)

Citizen.CreateThread(function()
	
	AddEventHandler("playerSpawned", function(spawn,pid)
		SetPedRelationshipGroupHash(PlayerPedId(), GetHashKey("PLAYER"))
		if firstSpawn then
			firstSpawn = false
			local players = {}
			for i,player in pairs(GetPlayers()) do
				table.insert(players,"Recieving..")
			end
			TriggerEvent("gtaoscoreboard:AddColumn", "Player Kills",players)
			TriggerEvent("gtaoscoreboard:AddColumn", "Zombie Kills",players)
			TriggerEvent("gtaoscoreboard:AddColumn", "Status",players)
			TriggerEvent("gtaoscoreboard:AddColumn", "Playtime",players)
		end
	end)
	AddEventHandler('baseevents:onPlayerKilled', function(killerId)
    local player = NetworkGetPlayerIndexFromPed(PlayerPedId())
    local attacker = killerId

		if GetPlayerFromServerId(attacker) and attacker ~= GetPlayerServerId(PlayerId()) then

			-- this is concept code for the "dropping loot when dying", no idea if it works, needs testing, hence, it hasn't been implemented yet
			-- NEEDS MUTLI ITEM PICKUP SUPPORT
			--[[
			for item,Consumable in ipairs(consumableItems) do
				if consumableItems.count[item] > 0.0 then
					local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), not IsEntityDead(PlayerPedId()) ))
					ForceCreateFoodPickupAtCoord(playerX + 1, playerY, playerZ, item, consumableItems.count[item])
				end
			end
			--]]
		end
		playerkillsthislife = 0
		zombiekillsthislife = 0
		if possessed then
			unPossessPlayer(PlayerPedId())
			possessed = false
		end
	end)

	AddEventHandler('baseevents:onPlayerWasted', function()
		playerkillsthislife = 0
		zombiekillsthislife = 0
		if possessed then
			unPossessPlayer(PlayerPedId())
			possessed = false
		end
	end)

	AddEventHandler('baseevents:onPlayerDied', function()
		playerkillsthislife = 0
		zombiekillsthislife = 0
		if possessed then
			unPossessPlayer(PlayerPedId())
			possessed = false
		end
	end)
end)

Citizen.CreateThread(function()
	AddEventHandler("playerSpawned", function(spawn,pid)
		
		if spawnWithFlashlight then
			for i,Consumable in ipairs(consumableItems) do
				consumableItems.count[i] = 0.0
			end
			if not humanity then humanity = 500.0 end
			playerkillsthislife = 0
			zombiekillsthislife = 0
			infected = false
			for i, count in pairs(config.startItems) do
				consumableItems.count[i] = count
			end
			TriggerServerEvent("SetLegitimateMoney", config.startMoney)
			consumableItems.count[17] = config.startMoney
			StatSetInt("MP0_STAMINA", 40,1)
			consumableItems.count[92] = 1 -- cb radio
			-- set CB back to what we were on before dying
			VoiceType = true
			if cbType == "FM" then
				cbType = "AM"
				cbChannel = 9
				cbChannelIndex = 6
			end
			NetworkSetVoiceActive(false)
			NetworkSetVoiceChannel(cbChannel)
			NetworkSetTalkerProximity(GetHighestVoiceProximity())
			NetworkSetVoiceActive(true)
			--
			if LoadedPlayerData then
				TriggerServerEvent("SetLegitimateMoney", config.startMoney)
			end
			if possessed then
				
				unPossessPlayer(PlayerPedId())
				possessed = false
			end

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
			end
			SetPlayerParachuteTintIndex(PlayerId(), 6)
			Wait(300)
			DecorSetFloat(PlayerPedId(), "hunger", 100.0)
			DecorSetFloat(PlayerPedId(), "thirst", 100.0)
			GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLASHLIGHT"), 1, false, false)
			GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_BAT"), 1, false, false)
			GiveWeaponToPed(PlayerPedId(), 0xFBAB5776, true)
			DisplayRadar(displayRadar)
			SetPedDropsWeaponsWhenDead(PlayerPedId(),true)
			NetworkSetFriendlyFireOption(true)
			SetCanAttackFriendly(PlayerPedId(), true, true)
			TriggerEvent('showNotification', "Press 'M' to open your Interaction Menu!")
			Wait(5000)
			if pid == PlayerId() then
				initiateSave(true)
			end
		end
	end)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)
		if GetEntityHeightAboveGround(PlayerPedId()) < 80 and IsPedInParachuteFreeFall(PlayerPedId()) then
			ForcePedToOpenParachute(PlayerPedId())
		end
	end
end)
