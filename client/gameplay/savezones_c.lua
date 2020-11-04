local safezones = {
	-- sandy shores methlab
	{label = "safe1", x = 1396.21 , y = 3613.28, z = 34.98, r = 50.0},
	-- downtown
	{label = "safe2", x = 199.2 , y = -934.37, z = 30.0, r = 175.0, xr = 100.0},
	-- Mount Chilliad
	{label = "safe3", x = 1487.7 , y = 6348.1, z = 23.0, r = 95.0, xr = 40.0},
}

local gracePeriod = 0
isPlayerInSafezone = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if gracePeriod > 0 then
			gracePeriod = gracePeriod - 1
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(20)
		for k,v in pairs(safezones) do
			local pCoords = GetEntityCoords(PlayerPedId(), true)
			local pdist = #(pCoords - vector3(v.x,v.y,v.z))
			if pdist < 180 then
				if not v.xr then v.xr = v.r end
				local handle, ped = FindFirstPed()
				local finished = false -- FindNextPed will turn the first variable to false when it fails to find another ped in the index
				repeat
					local pCoords = GetEntityCoords(PlayerPedId(), true)
					v.zd = #(vector3(0.0,0.0,pCoords.z) - vector3(0.0,0.0,v.z))
					if not IsPedAPlayer(ped) and #(pCoords - vector3(v.x,v.y,v.z)) < v.r-math.pi and v.zd < v.xr then
						SetEntityAsMissionEntity(ped,true,true)
						SetEntityHealth(ped,0.0)
						SetEntityAsNoLongerNeeded(ped)
					end
					Wait(1)
					finished, ped = FindNextPed(handle) -- first param returns true while entities are found
				until not finished
				EndFindPed(handle)
			end
		end
	end
end)

function denyveh(veh,toggle)
	if toggle then
		SetEntityMaxSpeed(veh, 2.0)
	else
		SetEntityMaxSpeed(veh, 99999.0)
	end
end


Citizen.CreateThread(function()

	while true do
		Citizen.Wait(0)
		local playerped = PlayerPedId()
		local PedInSeat = GetPedInVehicleSeat(GetVehiclePedIsUsing(playerped), -1) 
		local IsPedInVeh = IsPedInAnyVehicle(playerped, true)
		local VehPedIsUsing = GetVehiclePedIsUsing(playerped)
		local pCoords = GetEntityCoords(playerped, true)
		for k,v in pairs(safezones) do
			v.distance = #(pCoords - vector3(v.x,v.y,v.z))

			if not v.xr then v.xr = v.r end

			v.heightDistance = #(vector3(0.0,0.0,z) - vector3(0.0,0.0,v.z))
			
			if v.distance < v.r-math.pi and v.heightDistance < v.xr then
				DrawMissonText("You are in a ~g~Safezone!",0.25,0.96)
				DisablePlayerFiring(playerped, true)
				NetworkSetFriendlyFireOption(false)
				
				
				SetEntityProofs(playerped, true, true, true, true, true, true, 1, true)
				gracePeriod = 10
				isPlayerInSafezone = true
				if IsPedInVeh and not (IsPedInAnyHeli(playerped) or IsPedInAnyPlane(playerped)) and PedInSeat == playerped then
					denyveh(VehPedIsUsing,true)
				end
				break
			elseif v.distance > v.r-math.pi and (v.distance < v.r or v.heightDistance > v.xr) then
				NetworkSetFriendlyFireOption(true)
				
				isPlayerInSafezone = false
				if IsPedInVeh and PedInSeat == playerped then
					denyveh(VehPedIsUsing,false)
				end
				SetEntityProofs(playerped, false, false, false, false, false, false, 0, false)
			elseif IsEntityDead(playerped) then
				NetworkSetFriendlyFireOption(true)
				
				gracePeriod = 0
				isPlayerInSafezone = false
				SetEntityProofs(playerped, false, false, false, false, false, false, 0, false)
			elseif gracePeriod > 0 and not isPlayerInSafezone then
				DrawMissonText("Exited Safezone, grace period lasts for ~r~"..gracePeriod.."~s~ seconds!",100,true)
				NetworkSetFriendlyFireOption(false)
				
				SetEntityProofs(playerped, true, true, true, true, true, true, 1, true)
			elseif gracePeriod == 0 and not isPlayerInSafezone then
				NetworkSetFriendlyFireOption(true)
				
				SetEntityProofs(playerped, false, false, false, false, false, false, 0, false)
			end
		end
	end
end)
	


function DrawMissonText(text, duration, drawImmediately)
	BeginTextCommandPrint("STRING")
	AddTextComponentString(text)
	EndTextCommandPrint(duration, drawImmediately)
end

Citizen.CreateThread(function()
	for k,v in pairs(safezones) do
		local blip = AddBlipForRadius(v.x, v.y, v.z, v.r) --Creates the circle on the map
		local blip2 = AddBlipForCoord(v.x, v.y, v.z) -- Creates the name of the blip on the list in the pause menu
		SetBlipSprite(blip, 9)
		SetBlipAlpha(blip, 100)
		SetBlipColour(blip, 2)
		SetBlipSprite(blip2, 305)
		SetBlipColour(blip2, 3)
		SetBlipAlpha(blip2, 255)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Safezone")
		EndTextCommandSetBlipName(blip2)
	end
end)
