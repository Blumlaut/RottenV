Citizen.CreateThread(function()
	-- these were never local since they are unique anyway, but you do you i guess
	local defaultHungerLoss = 0.0003
	local defaultThirstLoss = 0.00044
	local SprintingHungerLoss = 0.0005
	local SprintingThirstLoss = 0.00064
	local drivingHungerLoss = 0.0002
	local drivingThirstLoss = 0.0003
	local Saturation = 0 -- hey, this is a thing i wanted to implement, but never did, horayy
	while true do
		Citizen.Wait(0)
		local pid = PlayerId()
		local ppid = PlayerPedId()
		local thirst = DecorGetFloat(ppid,"thirst")
		local hunger = DecorGetFloat(ppid,"hunger")
		
		if infected then
			SetPlayerHealthRechargeMultiplier(pid, 0.01)
		else
			SetPlayerHealthRechargeMultiplier(pid, 0.3)
		end
		if hunger > 100.0 then
			DecorSetFloat(ppid, "hunger", 100.0)
			hunger = DecorGetFloat(ppid,"hunger")
		end
		if thirst > 100.0 then
			DecorSetFloat(ppid, "thirst", 100.0)
			thirst = DecorGetFloat(ppid,"thirst")
		end
		if IsPedSprinting(ppid) then
			DecorSetFloat(ppid, "hunger", hunger-SprintingHungerLoss)
			DecorSetFloat(ppid, "thirst", thirst-SprintingThirstLoss)
		elseif IsPedInVehicle(ppid) then
			DecorSetFloat(ppid, "hunger", hunger-drivingHungerLoss)
			DecorSetFloat(ppid, "thirst", thirst-drivingThirstLoss)
		else
			DecorSetFloat(ppid, "hunger", hunger-defaultHungerLoss)
			DecorSetFloat(ppid, "thirst", thirst-defaultThirstLoss)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		local localPlayerPed = PlayerPedId()
		local health = GetEntityHealth(localPlayerPed)
		local thirst = DecorGetFloat(localPlayerPed,"thirst")
		local hunger = DecorGetFloat(localPlayerPed,"hunger")
		if hunger < 15.0 and hunger > 2.0 then
			SetEntityHealth(localPlayerPed,health-4)
		end
		if thirst < 15.0 and thirst > 2.0 then
			SetEntityHealth(localPlayerPed,health-4)
		end
		if hunger < 2.0 then
			SetEntityHealth(localPlayerPed, health-15)
		end
		if thirst < 2.0 then
			SetEntityHealth(localPlayerPed, health-15)
		end
	end
end)