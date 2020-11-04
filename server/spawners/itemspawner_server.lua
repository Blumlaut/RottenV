spawnedItems = {}
local maxFood = config.maxSpawnedFood
local maxWeapons = config.maxSpawnedWeapons



-- TODO: 
-- isPlayerInSafezone (callback?)
-- IsPlayerDead (callback?)


-- DONE:
-- make pickup z coord work clientside (done, needs testing)
-- dropped items ( Dead drops etc )



Citizen.CreateThread(function(choices, weights)
	function ForceCreateFoodPickupAtCoord(spawnPosX, spawnPosY, spawnPosZ, Pickups, PickupCounts,bool)
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
		
		writeLog("\nSpawned new Food "..spawnPosY+spawnPosX+spawnPosZ, 1)
		table.insert(spawnedItems, itemInfo)

		TriggerClientEvent("createPickup",-1, itemInfo,bool)
	end
	RegisterServerEvent("ForceCreateFoodPickupAtCoord")
	AddEventHandler("ForceCreateFoodPickupAtCoord", ForceCreateFoodPickupAtCoord)
	
	function ForceCreateWeaponPickupAtLocation(spawnPosX, spawnPosY, spawnPosZ, Pickup, AmmoCount,bool,bool2)
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

		writeLog("\nSpawned new Weapon "..spawnPosY+spawnPosX+spawnPosZ, 1)
		table.insert(spawnedItems, weaponInfo)
		TriggerClientEvent("createPickup",-1, weaponInfo,bool)
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
						if #(vector3(localx, localy, 0) - vector3(pedx,pedy,0)) < 300 then
							pir=pir+1
						end
					end
				end

				local maxFood = math.round (6+(pir*0.8))
				local maxWeapons = math.round(4+(pir*0.8))
				maxTotalItems = maxWeapons+maxFood
				
				local localFood,localWeapons = GetItemsOfTypeInRange(localx,localy,300)
					
				if not isPlayerInSafezone and not IsPlayerDead and (localWeapons < maxWeapons or localFood < maxFood) then
					local posX,posY,posZ = table.unpack(GetEntityCoords(curPlayerPed, true))
					local canSpawn = false
					local spawnX = posX+(math.random(-200,200))
					local spawnY = posY+(math.random(-200,200))
					local spawnZ = 0
					
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
					if #(vector3(pickup.x, pickup.y, 0) - vector3(px,py,0)) < 350.0 then
						CanBeDeleted = false
					end
				end
			end 
			if CanBeDeleted then
				TriggerEvent("removePickup", pickup, "too far away from any player")
			end 
		end
	end
end)


function GetItemsOfTypeInRange(rangex,rangey,range)
	local fooditems = 0
	local weaponitems = 0
	for i,pickup in pairs(spawnedItems) do
		if not pickup.deaddrop and not pickup.expires then
			if #(vector3(pickup.x, pickup.y,0) - vector3(rangex,rangey, 0)) < range then
				if not consumableItems[pickup.pickupItemData[1].id].isWeapon then
					fooditems=fooditems+1
				else
					weaponitems = weaponitems+1
				end
			end
		else
			writeLog("\npickup is a dead drop, ignoring.. "..tostring(pickup.deaddrop)..","..tostring(pickup.expires), 1)
		end
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
		local CloseItems = 0 
		local PlayerItems = 0
		local FoundCheat = false
		local src = source
		writeLog("\nClient "..GetPlayerName(source).." Requested a Pickup Creation.\n", 1)
		if not bool then
			for i,thePickup in pairs(spawnedItems) do
				--Citizen.Wait(1)
				-- not sure why this would co-relate to the other threads, but its worth a try i guess
				if #(vector3(pickupInfo.x,pickupInfo.y, 0) - vector3(thePickup.x,thePickup.y,0)) < 80.0 then
					CloseItems = CloseItems+1
				end
			end
		else
			PlayerItems = 0
			CloseItems = 0
		end
			
		if pickupInfo.deaddrop then
			pickupInfo.expires = os.time()+800
			writeLog("\nitem is a dead drop, setting time.", 1)
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
			writeLog("\nItem Request for client "..GetPlayerName(src).." Granted!\n", 1)
			TriggerClientEvent("createPickup", -1, pickupInfo)
		end
	end)
end)

-- SPECULATION:
-- Maybe there were multiple pickups? And we just accidentally deleted the wrong one? idk, removed the breaks, lets see what it does.
Citizen.CreateThread(function()
	RegisterServerEvent("removePickup")
	AddEventHandler("removePickup", function(pickupInfo, reason)
		local foundPickup = false
		writeLog("\ngot a request to delete Pickup "..pickupInfo.x+pickupInfo.y.."\n", 1)
		for i,pickup in pairs(spawnedItems) do
			if pickup.x == pickupInfo.x and pickup.y == pickupInfo.y then
				table.remove(spawnedItems, i)
				writeLog("\nRemoved Pickup "..pickupInfo.x+pickupInfo.y.." for reason "..reason, 1)
				writeLog("\nRemoving Pickup "..pickupInfo.x+pickupInfo.y.." as Requested.\n", 1)
				TriggerClientEvent("removePickup", -1, {x = pickupInfo.x, y = pickupInfo.y }, reason)
				foundPickup = true
			end
		end
		if not foundPickup then -- didnt find pickup to delete, we will have to assume that it was deleted earlier, send all clients this message
			writeLog("\nDeleting Pickup "..pickupInfo.x+pickupInfo.y.." failed, attempting to delete anyway..\n", 1)
			TriggerClientEvent("removePickup", -1, {x = pickupInfo.x, y = pickupInfo.y }, reason)
		end
	end)
end)


Citizen.CreateThread(function()
	RegisterServerEvent("collectPickup")
	AddEventHandler("collectPickup", function(pickupInfo)
		local s = source
		if not source or not GetPlayerName(source) then
			return 
		end
		local foundPickup = false
		writeLog("\nClient "..GetPlayerName(s).." Requested to collect a pickup.\n", 1)
		for i,pickup in pairs(spawnedItems) do
			if pickup.x == pickupInfo.x and pickup.y == pickupInfo.y then
				table.remove(spawnedItems, i)
				writeLog("\npickup for client "..GetPlayerName(s).." was collected\n", 1)
				TriggerClientEvent("collectPickup", s, pickupInfo)
				TriggerClientEvent("removePickup", -1, {x = pickupInfo.x, y = pickupInfo.y}, "pickup was collected\n")
				foundPickup = true
			end
		end
		if not foundPickup then -- same as above, remove this shit
			TriggerClientEvent("removePickup", -1, {x = pickupInfo.x, y = pickupInfo.y }, "pickup was collected but didnt exist\n")
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
		writeLog("\nNew Client Joined, Syncing Pickups..\n", 1)
		TriggerClientEvent("loadPickups", source, spawnedItems)
		writeLog("\nDone Syncing Pickups!\n", 1)
	end)
end)
