spawnedPickups = {}
localPickups = {}
local localFood = 0
local localWeapons = 0
local isThreadActive = false
local threadCheckAttempts = 0
local maxFood = 3
local maxWeapons = 2

-- Function init thread
Citizen.CreateThread(function(choices, weights)
	function DeletePickup(pickup)
		if (pickup and DoesEntityExist(pickup)) then
			SetEntityAsMissionEntity(pickup, true, true)
			writeLog("\ndeleting pickup "..pickup.."\n", 1)
			--RemovePickup(pickup)
			DeleteObject(pickup)
			
			if DoesEntityExist(pickup) then
				SetEntityAsNoLongerNeeded(pickup)
			end
			return true
		end
	end
end)

-- Network handlers
Citizen.CreateThread(function()
	RegisterNetEvent("createPickup")
	AddEventHandler("createPickup", function(pickup)
		pickup.spawned = false
		if pickup.item then
			if GetWeaponDamageType(pickup.hash) == 2 then
				pickup.data.count = 1
			end
		end
		table.insert(spawnedPickups, pickup)
	end)
end)

Citizen.CreateThread(function()
	pickupsPendingDeletion = {}
	RegisterNetEvent("removePickup")
	AddEventHandler("removePickup", function(pickupInfo,rsn)
		-- Remove the pickup...
		writeLog("\ngot a deletion request ("..rsn or "none"..")", 1)
		local DeletedThisPickup = false
		for i, pickup in ipairs(spawnedPickups) do
			if pickup.x == pickupInfo.x and pickup.y == pickupInfo.y then
				writeLog("\n.. item deleted!", 1)
				table.remove(spawnedPickups, i)
				DeletedThisPickup = true
				if pickup.pickup then
					writeLog("\nfound pickup, sending deletion request\n", 1)
					TriggerEvent("DeletePickup", pickup.pickup)
				end
			end
		end
		if not DeletedThisPickup then
			table.insert(pickupsPendingDeletion, pickupInfo)
			writeLog("\n^1PICKUP DIDNT GET DELETED!!! "..pickupInfo.x+pickupInfo.y.. " N "..#pickupsPendingDeletion, 1)
		end
			
	end)
end)

Citizen.CreateThread(function()
	RegisterNetEvent("collectPickup")
	AddEventHandler("collectPickup", function(pickupInfo) -- if the pickup has been collected and is valid
		if not pickupInfo.x then return end
		writeLog("\nCollecting pickup: " .. table.tostring(pickupInfo) .. "\n", 1)
		for i,theItem in pairs(spawnedPickups) do
			if pickupInfo.x == theItem.x and pickupInfo.y == theItem.y then
				
				local pickupString = ""
				pickupString = "You Found:"
				for i, pickupData in pairs(theItem.pickupItemData) do
					local itemCount = math.round(pickupData.count)
					consumableItems.count[pickupData.id] = consumableItems.count[pickupData.id] + itemCount
					if pickupData.id == 17 then
						TriggerServerEvent("AddLegitimateMoney", itemCount)
					end
					if consumableItems[pickupData.id].isWeapon and itemCount > 0 and (not pickupData.dontAddWeapon or GetWeapontypeGroup(GetHashKey(Consumable.hash)) == 1548507267) then
						GiveWeaponToPed(PlayerPedId(), consumableItems[pickupData.id].hash, math.round(itemCount), false, false)
					elseif consumableItems[pickupData.id].isWeapon and itemCount > 0 and pickupData.dontAddWeapon then 
						SetPedAmmo(PlayerPedId(), consumableItems[pickupData.id].hash, math.round(itemCount))
					end
					if itemCount > 1 and not consumableItems[pickupData.id].isWeapon then
						pickupString = pickupString.."\n~g~" .. itemCount .." " .. consumableItems[pickupData.id].multipleCase
					elseif itemCount == 1 and not consumableItems[pickupData.id].isWeapon then
						pickupString = pickupString.."\n~g~" .. itemCount .." " .. consumableItems[pickupData.id].name
					elseif itemCount >= 1 and consumableItems[pickupData.id].isWeapon then
						pickupString = pickupString.."\n~g~" .. consumableItems[pickupData.id].name .. " (x"..itemCount..")"
					end
				end
				for i = 0, #pickupString,100 do
					TriggerEvent('showNotification', string.sub(pickupString,i,i+99))
				end
				local soundId = GetSoundId()
				PlaySoundFrontend(soundId, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
				while not HasSoundFinished(soundId) do
					Wait(1)
				end
				ReleaseSoundId(soundId)
				break
			end
		end
	end)
end)


Citizen.CreateThread(function()
	RegisterNetEvent("loadPickups")
	AddEventHandler("loadPickups", function(pickupTable)
		for i,pickup in pairs(pickupTable) do
			pickup.spawned = false
			table.insert(spawnedPickups, pickup)
		end
	end)


	RegisterNetEvent("DeletePickup")
	AddEventHandler("DeletePickup", function(pickup)
		DeletePickup(pickup)
	end)

	RegisterNetEvent("createLootThread")
	AddEventHandler("createLootThread", function()
		createLootThread(true)
	end)
end)

-- Spawn items thread
--[[
Citizen.CreateThread(function()
	while loaded == true do
		Citizen.Wait(6000)
		
		local pir = GetPlayersInRadius(150)
		local maxFood = math.round((6/pir)*1.2)
		local maxWeapons = math.round((4/pir)*1.2)
		maxTotalItems = maxWeapons+maxFood
		
		localWeapons = 0
		localFood = 0
		localPickups = {}
		for i,theItem in pairs(spawnedPickups) do
			if theItem.owner == GetPlayerServerId(PlayerId()) then
				
				if not theItem.pickupItemData[2] then -- since it could be anything, ignore, this isnt as bad as it looks
					if not consumableItems[theItem.pickupItemData[1].id].isWeapon then
						localFood=localFood+1
					else
						localWeapons = localWeapons+1
					end
				end
				table.insert(localPickups, theItem)
			end
		end

		if not isPlayerInSafezone and not IsPlayerDead(PlayerId()) and (localWeapons < maxWeapons or localFood < maxFood) then
			--writeLog("\nSpawning pickups: Weapons: " .. localWeapons .. ", Food: " .. localFood, 1)
			local posX,posY,posZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
			local canSpawn = false
			local spawnX = posX
			local spawnY = posY
			local spawnZ = 0

			repeat
				repeat
					posX,posY,posZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
					Citizen.Wait(1)
					spawnX = posX + math.random(-250, 250)
					spawnY = posY + math.random(-250, 250)
					_,spawnZ = GetGroundZFor_3dCoord(spawnX+.0, spawnY+.0, 99999.0, 1)
					--writeLog("\nPlayer cords: [" .. posX .. "," .. posY .. "," .. posZ .. "]", 1)
					--writeLog("\nPickup cords: [" .. spawnX .. "," .. spawnY .. "," .. spawnZ .. "]", 1)
				until spawnZ ~= 0

				spawnZ = spawnZ + 1

				if spawnZ >= posZ-12 and spawnZ <= posZ+12 then
					for player, _ in pairs(players) do
						local playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(player), true))
						if DistanceBetweenCoords2D(spawnX, spawnY, playerX, playerY) < 60 then
							canSpawn = false
							--writeLog("\nPickup is within 60 meters of: " .. GetPlayerName(player), 1)
							break
						else
							canSpawn = true
						end
					end
				else
					canSpawn = false
					--writeLog("\nPickup height is out of limit!", 1)
				end
			until canSpawn

			if localFood < maxFood then
				ForceCreateFoodPickupAtCoord(spawnX, spawnY, spawnZ)
				localFood = localFood + 1
			elseif localWeapons < maxWeapons then
				ForceCreateWeaponPickupAtLocation(spawnX, spawnY, spawnZ)
				localWeapons = localWeapons + 1
			end
		end
	end
end)
]]


Citizen.CreateThread(function() --medThread
	while loaded == true do
		Citizen.Wait(200)

		local playerCoords = GetEntityCoords(PlayerPedId(), true)
		for i, pickupInfo in pairs(spawnedPickups) do
			if pickupInfo.spawned then
				if #(vector3(playerCoords.x, playerCoords.y, 0) - vector3(pickupInfo.x,pickupInfo.y, 0)) < 2.5 and not IsPlayerDead(PlayerId()) and not IsPedInAnyVehicle(PlayerPedId(), false) and not IsEntityDead(PlayerPedId()) and not spawnedPickups[i].RequestedDeletion then
					TriggerServerEvent("collectPickup", pickupInfo)
					spawnedPickups[i].RequestedDeletion = true
					writeLog("\nRemoving Pickup at 265\n", 1)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while loaded == true do
		Citizen.Wait(1)

		-- Light
		for i, pickupInfo in pairs(spawnedPickups) do
			local playerCoords = GetEntityCoords(PlayerPedId(), true)
			if #(playerCoords - vector3(pickupInfo.x, pickupInfo.y, pickupInfo.z)) < 300.0 then
				-- DrawLine(posX,posY,posZ, pickupInfo.x, pickupInfo.y, pickupInfo.z, 255, 255, 255, 255)
				DrawLightWithRangeAndShadow(pickupInfo.x, pickupInfo.y, pickupInfo.z + 0.1, 255, 255, 255, 3.0, 50.0, 5.0)
			end
		end

	end
end)

-- Creating the pickup thread
function createLootThread(crashed)
	if crashed ~= nil then
		TriggerEvent('showNotification', "Loot fixed...")
	end
	Citizen.CreateThread(function()
		while loaded == true do
			Citizen.Wait(50)
			isThreadActive = true

			local posX,posY,posZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
			for i, pickupInfo in pairs(spawnedPickups) do
				if pickupInfo.spawned == false and not pickupInfo.RequestedDeletion then
					if #(vector3(posX, posY, 0) - vector3(pickupInfo.x, pickupInfo.y, 0)) < 60.0 then
						if not IsModelInCdimage(pickupInfo.model) then
							writeLog("\nitem "..pickupInfo.model.." can't spawn, removing...\n", 1)
							--TriggerServerEvent("removePickup", pickupInfo, "invalid cd image\n")
							break
						end
						
						RequestModel(GetHashKey(pickupInfo.model))
						while not HasModelLoaded(GetHashKey(pickupInfo.model)) do
							writeLog(pickupInfo.model.." not loaded\n", 1)
							Wait(300)
						end
						
						if not pickupInfo.z or pickupInfo.z == 0 then
							repeat
								posX,posY,posZ = pickupInfo.x,pickupInfo.y,0
								RequestCollisionAtCoord(pickupInfo.x, pickupInfo.y, GetEntityCoords(PlayerPedId(), true).z)
								Citizen.Wait(1)
								_,spawnZ = GetGroundZFor_3dCoord(posX+.0, posY+.0, 99999.0, 1)
							until spawnZ ~= 0
							pickupInfo.z = spawnZ+1.0
							writeLog("\nzcoord for item generated: "..pickupInfo.z, 1)
						end
							
							
						pickup = CreateObject(GetHashKey(pickupInfo.model), pickupInfo.x, pickupInfo.y, pickupInfo.z, false, false, false)
						if DoesEntityExist(pickup) then
							SetEntityAsMissionEntity(pickup, true, true) -- this crashes sometimes, no idea why, needs further testing
							SetEntityHasGravity(pickup, false)
							SetEntityDynamic(pickup, false)
							SetEntityCollision(pickup, false, false)
							
							pickupInfo.pickup = pickup
							pickupInfo.spawned = true
							spawnedPickups[i] = pickupInfo
							writeLog(pickupInfo.pickup .. " Items " .. table.tostring(pickupInfo.pickupItemData) .. " Spawned!\n", 1)
						end
					end
				elseif pickupInfo.spawned == true then
					if #(vector3(posX, posY, 0) - vector3(pickupInfo.x, pickupInfo.y, 0)) > 80.0 and not pickupInfo.RequestedDeletion then
						TriggerEvent("DeletePickup", pickupInfo.pickup)
						pickupInfo.spawned = false
						spawnedPickups[i] = pickupInfo
						writeLog("\nRemoved pickup(too far away)\n", 1)
					end
				end
			end
		end
	end)
end


Citizen.CreateThread(function() -- slow thread
	while true do 
		Wait(10000)
		local posX,posY,posZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
		for i,pickupInfo in ipairs(spawnedPickups) do
			Wait(10)
			if #(vector3(posX, posY, 0) - vector3(pickupInfo.x, pickupInfo.y, 0)) < 300.0 then
				if not pickupInfo.z or pickupInfo.z == 0 then
					RequestCollisionAtCoord(pickupInfo.x, pickupInfo.y, posZ)
					repeat
						posX,posY,posZ = pickupInfo.x,pickupInfo.y,0
						Citizen.Wait(1)
						_,spawnZ = GetGroundZFor_3dCoord(posX+.0, posY+.0, 99999.0, 1)
					until spawnZ ~= 0
					pickupInfo.z = spawnZ+1.0
					writeLog("\nzcoord for item generated: "..pickupInfo.z, 1)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while loaded == true do
		Citizen.Wait(1)
		if isThreadActive then
			threadCheckAttempts = 0
			isThreadActive = false
		else
			threadCheckAttempts = threadCheckAttempts + 1
			if threadCheckAttempts >= 100 then
				threadCheckAttempts = 0
				TriggerEvent("createLootThread")
			end
		end
	end
end)

loaded = true
createLootThread()
