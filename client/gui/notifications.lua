RegisterNetEvent("showNotification")

Citizen.CreateThread(function()
	AddEventHandler("showNotification", function(text)
		SetNotificationTextEntry("STRING")
		AddTextComponentString(text)
		DrawNotification(0,1)
	end)
end)

Citizen.CreateThread(function()
	local alreadyDead = false
	while true do
		Citizen.Wait(200)
		local playerPed = PlayerPedId()
		
		if IsEntityDead(playerPed) and not alreadyDead then
			local killer = GetPedSourceOfDeath(playerPed) 
			local killername = "unknown"
			local killerId = false
			local killerType = GetEntityType(killer)
			local weapon = GetPedCauseOfDeath(playerPed,1)
			local killerweapon = reverseWeaponHash( tostring(weapon) )
			if IsEntityAPed(killer) and IsPedAPlayer(killer) then
				killerId = NetworkGetPlayerIndexFromPed(killer)
				killername = GetPlayerName(NetworkGetPlayerIndexFromPed(killer))
			end
			if IsEntityAVehicle(killer) then
				local p = GetPedInVehicleSeat(killer, -1)
				if IsPedAPlayer(p) then
					killerId = NetworkGetPlayerIndexFromPed(p)
					killername = GetPlayerName(NetworkGetPlayerIndexFromPed(p))
					killerweapon = "a Vehicle"
					weapon = 69 -- doesnt really matter, this needs to be a value though
				end
			end
			
			local deathitems = {}
			for i,theItem in ipairs(consumableItems) do
				if consumableItems.count[i] > 0 then
					table.insert(deathitems, {id = i, count = consumableItems.count[i]})
				end
			end
			local deadx,deady,deadz = table.unpack(GetEntityCoords(PlayerPedId()))
			
			
			if not killerId or killerId == PlayerId() then
				local handle, ped = FindFirstPed()
				local finished = false -- FindNextPed will turn the first variable to false when it fails to find another ped in the index
				repeat
					Wait(1)
					if IsPedAPlayer(ped) and ped ~= PlayerPedId() then
						killerId = NetworkGetPlayerIndexFromPed(ped)
						killername = GetPlayerName(NetworkGetPlayerIndexFromPed(ped))
						finished = false
						weapon = 0 -- set killer weapon to 0 because this was a suicide
					end
					finished, ped = FindNextPed(handle) -- first param returns true while entities are found
				until not finished
				EndFindPed(handle)
			end
			
			local itemInfo = {
				x = deadx,
				y = deady,
				z = deadz,
				model = consumableItems[1].model,
				pickupItemData = deathitems,
				owner = GetPlayerServerId(killerId or PlayerId()), -- ideally, this should never be PlayerId(), but added it just in case.
				ownerName = GetPlayerName(killerId or PlayerId()),
				deaddrop = true,
				spawned = false
			}
			TriggerServerEvent("RegisterPickup", itemInfo)
			for i,Consumable in ipairs(consumableItems) do
				consumableItems.count[i] = 0
			end
			initiateSave(true)
			if killer == playerPed or not killerId then
				TriggerServerEvent('playerDied',0,0)
				Citizen.Trace("\nPlayer Died for no reason!")
			elseif killername and killername ~= "unknown" and weapon ~= 0 then
				TriggerServerEvent('playerDied',killername,1,killerweapon)
				Citizen.Trace("\nPlayer Died from "..killername.."!")
				TriggerServerEvent("registerKill",GetPlayerServerId(killerId), humanity,weapon)
				if IsPlayerHunted then
					TriggerServerEvent("RemovePlayerHunted")
				end
			else
				TriggerServerEvent('playerDied',0,2)
				Citizen.Trace("\nPlayer Died for unknown reason!")
			end
			alreadyDead = true
		end
		if not IsEntityDead(playerPed) then
			alreadyDead = false
		end
	end 
end)