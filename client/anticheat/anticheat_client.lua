-- this should delete peds that are not created by us
Citizen.CreateThread(function()
	while true do
		local handle, ped = FindFirstPed()
		local finished = false -- FindNextPed will turn the first variable to false when it fails to find another ped in the index
		repeat
			Wait(1)
			if not IsPedAPlayer(ped) then
				if not DecorGetBool(ped,"C8pE53jw") then
					NetworkRequestControlOfEntity(ped)
					Wait(3000)
					SetEntityAsMissionEntity(ped,true,true)
					DeletePed(ped)
				end
			end
			finished, ped = FindNextPed(handle) -- first param returns true while entities are found
		until not finished
		EndFindPed(handle)
		Citizen.Wait(2000)
		if IsPedInAnyVehicle(PlayerPedId(), false) then 
			local veh = GetVehiclePedIsIn(PlayerPedId(), false)
			if not DecorGetBool(veh,"C8pE53jw") then
				NetworkRequestControlOfEntity(veh)
				SetVehicleOilLevel(veh, 0.0)
				for i=0,8 do
					SetVehicleTyreBurst(veh, i, true, 1000)
					Wait(1)
				end
				SetVehicleEngineHealth(veh, 1)
				SetVehicleNumberPlateText(veh, "CHEATED")
				writeLog("\nRemoving Cheated Vehicle.",1)
				SetEntityVelocity(veh, 0.0, 0.0, 0.0)
				TaskLeaveVehicle(PlayerPedId(), veh, 0)
				SetVehicleDoorsLocked(veh, 2)
				SetEntityAsNoLongerNeeded(veh)
				Wait(4000)
				SetEntityVelocity(veh, 0.0, 0.0, 30.0)
				Wait(500)
				DeleteVehicle(veh)
			else
				DecorSetBool(veh, "C8pE53jw", true)
			end
		end
	end
end)

-- prevent money / safe cheats
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		local money = consumableItems.count[17]
		consumableItems.count[17] = money
		local safes = consumableItems.count[18]
		if safes > 30 then 
			consumableItems.count[18] = 3.0
			TriggerServerEvent("AntiCheese:CustomFlag", "Safe Cheating", "had "..safes.." safes.")	
		end
		if money > 200000000 then 
			consumableItems.count[17] = 0
			TriggerServerEvent("AntiCheese:CustomFlag", "Money Cheating", "had $"..money)
		end
		local money = consumableItems.count[17]
	end
end)

-- prevent hunger/thirst cheats
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)
		local curPed = PlayerPedId()
		local curHunger = LocalPlayer.state.hunger
		local curThirst = LocalPlayer.state.thirst
		LocalPlayer.state.hunger = curHunger-2
		LocalPlayer.state.thirst = curThirst-2
		
		local curWait = math.random(10,50)
		
		Citizen.Wait(curWait)

		if not IsPlayerDead(PlayerId()) then
			if PlayerPedId() == curPed and LocalPlayer.state.hunger == curHunger and GetEntityHealth(curPed) ~= 0 then
				TriggerServerEvent("AntiCheese:CustomFlag", "Hunger Cheating", "has regenerated "..LocalPlayer.state.hunger-curHunger.."% Hunger in "..curWait.."ms")
			elseif LocalPlayer.state.hunger <= curHunger-2 then
				LocalPlayer.state.hunger = LocalPlayer.state.hunger+2
			end 
			
			if PlayerPedId() == curPed and LocalPlayer.state.thirst == curThirst and GetEntityHealth(curPed) ~= 0 then
				TriggerServerEvent("AntiCheese:CustomFlag", "Thirst Cheating", "has regenerated "..LocalPlayer.state.thirst-curThirst.."% Thirst in "..curWait.."ms")
			elseif LocalPlayer.state.thirst <= curThirst-2 then
				LocalPlayer.state.thirst = LocalPlayer.state.thirst+2
			end 
			
		end
	end
end)




Citizen.CreateThread(function()
	function DetectedCheat(eventname,args)
		TriggerServerEvent("BaitEvents:DetectedCheat", nil,eventname, "CLIENT", args)
	end

	RegisterNetEvent("BaitEvents:RecieveEvents")
	AddEventHandler("BaitEvents:RecieveEvents", function(events)
		for i,event in pairs(events) do
			RegisterNetEvent(event)
			AddEventHandler(event, function(...)
				local arg = {...}
				DetectedCheat(event, arg)
			end)
		end
	end)
	TriggerServerEvent("BaitEvents:RequestEvents")
end)