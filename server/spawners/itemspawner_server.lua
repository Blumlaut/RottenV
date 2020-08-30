spawnedItems = {}
local maxFood = 6
local maxWeapons = 4



-- TODO: 
-- isPlayerInSafezone (callback?)
-- IsPlayerDead (callback?)


-- DONE:
-- make pickup z coord work clientside (done, needs testing)
-- dropped items ( Dead drops etc )



Citizen.CreateThread(function(choices, weights)
	function ForceCreateFoodPickupAtCoord(spawnPosX, spawnPosY, spawnPosZ, Pickups, PickupCounts,bool)
		local success, err = pcall(function()
			local RandomPickup = itemChances[ math.random( #itemChances ) ]
			if Pickups == nil then
				local chance = math.random(0,100)
				Pickups = RandomPickup
				if chance > 60 or consumableItems[Pickups].infinite then
					PickupCounts = math.round(math.random( consumableItems[Pickups].randomFinds[1], consumableItems[Pickups].randomFinds[2]  ))+0.0
				else
					PickupCounts = 1.0
				end
			end
			
			local data = {{id = Pickups, count = PickupCounts}}

			local itemInfo = {
				model = consumableItems[Pickups].model,
				x = spawnPosX,
				y = spawnPosY,
				z = spawnPosZ,
				pickupItemData = data,
				spawned = false
			}
			
			Citizen.Trace("\nSpawned new Food "..spawnPosY+spawnPosX+spawnPosZ)
			table.insert(spawnedItems, itemInfo)

			TriggerClientEvent("createPickup",-1, itemInfo,bool)
		end)
		if not success then
			TriggerEvent("SentryIO_Error", err, debug.traceback())
		end
	end
	RegisterServerEvent("ForceCreateFoodPickupAtCoord")
	AddEventHandler("ForceCreateFoodPickupAtCoord", ForceCreateFoodPickupAtCoord)
	
	function ForceCreateWeaponPickupAtLocation(spawnPosX, spawnPosY, spawnPosZ, Pickup, AmmoCount,bool,bool2)
		local success, err = pcall(function()
			local randomWeapon = weaponChances[ math.random(#weaponChances) ]
			if not Pickup then
				local hash = consumableItems[randomWeapon].model
				Pickup = GetHashKey(hash)
				AmmoCount = math.random(10,50)
			else
				randomWeapon = Pickup
				local hash = consumableItems[randomWeapon].model
				Pickup = GetHashKey(hash)
				AmmoCount = AmmoCount
			end
		
			
			local data = {{id = randomWeapon, count = AmmoCount}}
			
			local weaponInfo = {
				weapon = Pickup,
				item = consumableItems[randomWeapon].hash,
				model = consumableItems[randomWeapon].model,
				name = consumableItems[randomWeapon].name,
				x = spawnPosX,
				y = spawnPosY,
				z = spawnPosZ,
				pickupItemData = data,
				spawned = false
			}
			if bool2 then 
				weaponInfo.dontAddWeapon = true 
			end

			Citizen.Trace("\nSpawned new Weapon "..spawnPosY+spawnPosX+spawnPosZ)
			table.insert(spawnedItems, weaponInfo)
			TriggerClientEvent("createPickup",-1, weaponInfo,bool)
		end)
		if not success then
			TriggerEvent("SentryIO_Error", err, debug.traceback())
		end
	end
	RegisterServerEvent("ForceCreateWeaponPickupAtLocation")
	AddEventHandler("ForceCreateWeaponPickupAtLocation", ForceCreateWeaponPickupAtLocation)
end)



--[[
Citizen.CreateThread(function()
	RegisterNetEvent("removePickup")
	AddEventHandler("removePickup", function(pickupInfo)
		-- Remove the pickup...
		return false
		for i, pickup in pairs(spawnedItems) do
			if pickup.x == pickupInfo.x and pickup.y == pickupInfo.y and pickup.z == pickupInfo.z then
				table.remove(spawnedPickups, i)
			end
		end
	end)
end)

]]

Citizen.CreateThread(function()
	while true do
		Wait(2000)
		local success, err = pcall(function()
			allPlayers = GetPlayers()
			for i,player in ipairs(allPlayers) do
				Wait(1)
				if player and GetPlayerName(player) and GetPlayerPed(player) then
					local isPlayerInSafezone = false
					local IsPlayerDead = false
					
					local pir = 1
					local curPlayerPed = GetPlayerPed(player)
					local localx,localy,localz = table.unpack(GetEntityCoords(curPlayerPed, true))	
					for _,p in pairs(allPlayers) do
						if DoesEntityExist(GetPlayerPed(p)) then
							local pedx,pedy,pedz = table.unpack(GetEntityCoords(GetPlayerPed(p), true))
							if DistanceBetweenCoords2D(localx, localy, pedx,pedy) < 300 then
								pir=pir+1
							end
						end
					end

					local maxFood = math.round (6+(pir*0.8))
					local maxWeapons = math.round(4+(pir*0.8))
					maxTotalItems = maxWeapons+maxFood
					
					local localFood,localWeapons = GetItemsOfTypeInRange(localx,localy,300)
						
					if not isPlayerInSafezone and not IsPlayerDead and (localWeapons < maxWeapons or localFood < maxFood) then
						--Citizen.Trace("\nSpawning pickups: Weapons: " .. localWeapons .. ", Food: " .. localFood)
						local posX,posY,posZ = table.unpack(GetEntityCoords(curPlayerPed, true))
						local canSpawn = false
						local spawnX = posX+(math.random(-200,200))
						local spawnY = posY+(math.random(-200,200))
						local spawnZ = 0
						
						
						--[[
						repeat
							for _, player in pairs(GetPlayers()) do
								local playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(player), true))
								if DistanceBetweenCoords2D(spawnX, spawnY, playerX, playerY) < 60 then
									canSpawn = false
									--Citizen.Trace("\nPickup is within 60 meters of: " .. GetPlayerName(player))
									break
								else
									canSpawn = true
								end
							end
						until canSpawn
						]]
			
			
						if localFood < maxFood then
							ForceCreateFoodPickupAtCoord(spawnX, spawnY, spawnZ)
							localFood = localFood + 1
						elseif localWeapons < maxWeapons then
							ForceCreateWeaponPickupAtLocation(spawnX, spawnY, spawnZ)
							localWeapons = localWeapons + 1
						end
					end
				end
			end
			
			for i, pickup in pairs(spawnedItems) do
				Wait(1)
				local CanBeDeleted = true
				for i,player in ipairs(allPlayers) do
					if player and GetPlayerName(player) and GetPlayerPed(player) then
						local px,py,pz = table.unpack(GetEntityCoords(GetPlayerPed(player), true))
						if DistanceBetweenCoords2D(pickup.x, pickup.y, px,py) < 350.0 then
							CanBeDeleted = false
						end
					end
				end 
				if CanBeDeleted then
					TriggerEvent("removePickup", pickup, "too far away from any player")
				end 
			end
		end)
		if not success then
			TriggerEvent("SentryIO_Error", err, debug.traceback())
		end
	end
end)


function GetItemsOfTypeInRange(rangex,rangey,range)
	local fooditems = 0
	local weaponitems = 0
	local success, err = pcall(function()
		for i,pickup in pairs(spawnedItems) do
			if not pickup.deaddrop and not pickup.expires then
				if DistanceBetweenCoords2D(pickup.x, pickup.y, rangex,rangey) < range then
					if not consumableItems[pickup.pickupItemData[1].id].isWeapon then
						fooditems=fooditems+1
					else
						weaponitems = weaponitems+1
					end
				end
			else
				Citizen.Trace("\npickup is a dead drop, ignoring.. "..tostring(pickup.deaddrop)..","..tostring(pickup.expires))
			end
		end
	end)
	if not success then
		TriggerEvent("SentryIO_Error", err, debug.traceback())
	end
	return fooditems,weaponitems
end


Citizen.CreateThread(function()	 
	RegisterServerEvent("RegisterNewPickup")
	AddEventHandler("RegisterNewPickup", function(pickupInfo,bool)
		TriggerEvent("RottenV:FuckCheaters",source, "Triggering RegisterNewPickup", ".")
	end)

	RegisterServerEvent("RegisterPickup")
	AddEventHandler("RegisterPickup", function(pickupInfo,bool)
		local success, err = pcall(function()
			local CloseItems = 0 
			local PlayerItems = 0
			local FoundCheat = false
			local src = source
			Citizen.Trace("\nClient "..GetPlayerName(source).." Requested a Pickup Creation.\n")
			if not bool then
				for i,thePickup in pairs(spawnedItems) do
					--Citizen.Wait(1)
					-- not sure why this would co-relate to the other threads, but its worth a try i guess
					if DistanceBetweenCoords2D(pickupInfo.x,pickupInfo.y,thePickup.x,thePickup.y) < 80.0 then
						CloseItems = CloseItems+1
					end
				end
			else
				PlayerItems = 0
				CloseItems = 0
			end
				
			if pickupInfo.deaddrop then
				pickupInfo.expires = os.time()+800
				Citizen.Trace("\nitem is a dead drop, setting time.")
			end

			if type(pickupInfo.pickupItemData) == "table" then
				for loop,theThing in pairs(pickupInfo.pickupItemData) do
					local i = theThing.id
					if theThing.count < 0 then
						theThing.count = 0
					end
					if i ~= 17 and theThing.count > 600 and not consumableItems[i].isWeapon then
						FoundCheat = true
						TriggerEvent("RottenV:FuckCheaters",src, "Spawning Invalid Amount of items", "Tried to spawn "..theThing.count.." items of "..(consumableItems[i].multipleCase or consumableItems[i].name)..".")
					end
					if i == 17 and theThing.count > 8000000 then
						FoundCheat = true
						TriggerEvent("RottenV:FuckCheaters",src, "Spawning Invalid Amount of Money", "Tried to spawn "..theThing.count.." items of "..(consumableItems[i].multipleCase or consumableItems[i].name)..".")
					end
				end
			else
				if (pickupInfo.pickupItemData.count) and pickupInfo.pickupItemData.count < 0 then
					pickupInfo.pickupItemData.count = 0
				end
				if (pickupInfo.pickupItemData.count) and i ~= 17 and pickupInfo.pickupItemData.count > 600 and not consumableItems[pickupInfo.pickupItem].isWeapon then 
						TriggerEvent("RottenV:FuckCheaters",src, "Spawning Invalid Amount of items", "Tried to spawn "..pickupInfo.pickupItemData.count.." items of "..(consumableItems[i].multipleCase or consumableItems[i].name)..".")
						FoundCheat = true
				end
				if (pickupInfo.pickupItemData.count) and i == 17 and pickupInfo.pickupItemData.count > 8000000 then
						FoundCheat = true
						TriggerEvent("RottenV:FuckCheaters",src, "Spawning Invalid Amount of Money", "Tried to spawn "..pickupInfo.pickupItemData.count.." items of "..(consumableItems[i].multipleCase or consumableItems[i].name)..".")
				end
			end
			if FoundCheat then return end
			
			if (CloseItems < 8 and PlayerItems < 8) and (not FoundCheat) then
				table.insert(spawnedItems, pickupInfo)
				Citizen.Trace("\nItem Request for client "..GetPlayerName(src).." Granted!\n")
				TriggerClientEvent("createPickup", -1, pickupInfo)
			end
		end)
		if not success then
			TriggerEvent("SentryIO_Error", err, debug.traceback())
		end
	end)
end)

-- SPECULATION:
-- Maybe there were multiple pickups? And we just accidentally deleted the wrong one? idk, removed the breaks, lets see what it does.
Citizen.CreateThread(function()
	RegisterServerEvent("removePickup")
	AddEventHandler("removePickup", function(pickupInfo, reason)
		local success, err = pcall(function()
			local foundPickup = false
			Citizen.Trace("\ngot a request to delete Pickup "..pickupInfo.x+pickupInfo.y.."\n")
			for i,pickup in pairs(spawnedItems) do
				if pickup.x == pickupInfo.x and pickup.y == pickupInfo.y then
					table.remove(spawnedItems, i)
					Citizen.Trace("\nRemoved Pickup "..pickupInfo.x+pickupInfo.y.." for reason "..reason)
					Citizen.Trace("\nRemoving Pickup "..pickupInfo.x+pickupInfo.y.." as Requested.\n")
					TriggerClientEvent("removePickup", -1, {x = pickupInfo.x, y = pickupInfo.y }, reason)
					foundPickup = true
				end
			end
			if not foundPickup then -- didnt find pickup to delete, we will have to assume that it was deleted earlier, send all clients this message
				Citizen.Trace("\nDeleting Pickup "..pickupInfo.x+pickupInfo.y.." failed, attempting to delete anyway..\n")
				TriggerClientEvent("removePickup", -1, {x = pickupInfo.x, y = pickupInfo.y }, reason)
			end
		end)
		if not success then
			TriggerEvent("SentryIO_Error", err, debug.traceback())
		end
	end)
end)


Citizen.CreateThread(function()
	RegisterServerEvent("collectPickup")
	AddEventHandler("collectPickup", function(pickupInfo)
		local s = source
		local success, err = pcall(function()
			if not source or not GetPlayerName(source) then
				return 
			end
			local foundPickup = false
			Citizen.Trace("\nClient "..GetPlayerName(s).." Requested to collect a pickup.\n")
			for i,pickup in pairs(spawnedItems) do
				if pickup.x == pickupInfo.x and pickup.y == pickupInfo.y then
					table.remove(spawnedItems, i)
					Citizen.Trace("\npickup for client "..GetPlayerName(s).." was collected\n")
					TriggerClientEvent("collectPickup", s, pickupInfo)
					TriggerClientEvent("removePickup", -1, {x = pickupInfo.x, y = pickupInfo.y}, "pickup was collected\n")
					foundPickup = true
				end
			end
			if not foundPickup then -- same as above, remove this shit
				TriggerClientEvent("removePickup", -1, {x = pickupInfo.x, y = pickupInfo.y }, "pickup was collected but didnt exist\n")
			end
		end)
		if not success then
			TriggerEvent("SentryIO_Error", err, debug.traceback())
		end
	end)
end)

Citizen.CreateThread(function()
	AddEventHandler("playerDropped", function(reason)
		local src = source
	end)
end)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(30000)
		if #GetPlayers() == 0 then
			spawnedItems = {}
		end

		for i,item in  pairs(spawnedItems) do
			Wait(1)
			if item.expires then
				if item.expires < os.time() then
					TriggerEvent("removePickup", item, "Expired")
				end
			end
		end

	end
end)



Citizen.CreateThread(function()
	RegisterServerEvent("Z:newplayerID")
	AddEventHandler("Z:newplayerID", function(playerid)
		Citizen.Trace("\nNew Client Joined, Syncing Pickups..\n")
		TriggerClientEvent("loadPickups", source, spawnedItems)
		Citizen.Trace("\nDone Syncing Pickups!\n")
	end)
end)
