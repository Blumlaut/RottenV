airdropStarts = {
	{x= -2100.0, y = -4300.0, r = 0},
	{x= 2910.0, y = -3801.0, r = 49.0},
	
	{x= 5216.0, y = -2576.0, r = 80.0},
	{x= 5378.0, y = -69.0, r = 94.0},
	{x= 5880.0, y = 1814.0, r = 86.0},
	{x= 6470.0, y = 4604.0, r = 111.0},
	{x= 5775.0, y = 7297.0, r = 130.0},
	{x= 1665.0, y = 8799.0, r = 171.0},
	{x= -2136.0, y = 6768.0, r = 226.0},
	
	{x= -3562.0, y = 4815.0, r = 224.0},
	{x= -4134.0, y = 2031.0, r = 211.0},
	{x= -4403.0, y = -926.0, r = 301.0},
	{x= -2726.0, y = -4302.0, r = 306.0},
	{x= -3257.0, y = -2301.0, r = 300.0},

	{x= -49.0, y = -3544.0, r = 250.0},
	{x= 833.0, y = 4038.0, r = 190.0},
}


Citizen.CreateThread(function()
	airdropLaunched = false
	function AirdropEntity(cargoPos,oldx,oldy,oldz)
		RequestModel("p_parachute1_mp_s")
		RequestModel("xm_prop_rsply_crate04b")
		while not HasModelLoaded("p_parachute1_mp_s") or not HasModelLoaded("xm_prop_rsply_crate04b") do
			Wait(1)
		end
		local para = CreateObjectNoOffset(GetHashKey("p_parachute1_mp_s"), cargoPos.x, cargoPos.y, cargoPos.z - 5.0, true, true, true)
		local crate = CreateObjectNoOffset(GetHashKey("xm_prop_rsply_crate04b"), cargoPos.x, cargoPos.y, cargoPos.z - 5.0, true, true, true)
		SetEntityAsMissionEntity(para, 1, 1)
		SetEntityAsMissionEntity(crate, 1, 1)
		AttachEntityToEntity(para, crate, "SKEL_ROOT", 0.0, 0.0, 3.2, 0.0, 0.0, 0.0, 0, false, false, false, 1, 1)
		AttachEntityToEntity(entity1, entity2, boneIndex, xPos, yPos, zPos, xRot, yRot, zRot, p9, useSoftPinning, collision, isPed, vertexIndex, fixedRot)
		SetEntityDynamic(para, true)
		SetEntityDynamic(crate, true)
		while true do
			Wait(100)
			if GetEntityHeightAboveGround(para) < 5.0 then
				local r = GetEntityHeading(crate)
				DeleteEntity(crate)
				DeleteEntity(para)
				airdropLaunched = false
				local minItems = math.random(3,10)
				local minGuns = math.random(1,3)
				local items = {}

					
				for i=1,minItems do
						local chance = itemChances[ math.random( #itemChances ) ]
						local count = math.round(math.random( consumableItems[chance].randomFinds[1], consumableItems[chance].randomFinds[2]   ))+0.0
						table.insert(items, {id = chance, count = count})
				end
				for i=1,minGuns do
						local chance = weaponChances[math.random(1, #weaponChances)]
						local count = 1
						if consumableItems[chance].hasammo then
							count = math.random(20,60)
						end
						table.insert(items, {id = chance, count = count})
				end
				local x,y = cargoPos.x, cargoPos.y
				_,z = GetGroundZFor_3dCoord(cargoPos.x, cargoPos.y, cargoPos.z+100.0, 0)
				
				TriggerServerEvent("CreateCustomSafe", x,y,z,r,"xm_prop_rsply_crate04b",items,false,"0000",94)
				TriggerEvent("showNotification", "Airdrop has ~g~landed~s~.")
				TriggerServerEvent("AirdropLanded", oldx,oldy,oldz)
				break
			end
		end
	end

	function BeginAirdrop(x,y,z)
		Wait(3000)
		local tdist = 999999999
		local smallestdrop = 1
		for i,drop in pairs(airdropStarts) do
			local d = #(vector3(drop.x, drop.y, 0) - vector3(x, y, 0))
			if tdist > d then
				tdist = d
				smallestdrop = i
			end
		end

		
		local startx,starty = airdropStarts[smallestdrop].x, airdropStarts[smallestdrop].y
		local dropdone = false
		local endx,endy = x,y
		local height = z+300
		RequestModel("titan")
		RequestModel("IG_RussianDrunk")
		while not HasModelLoaded("titan") or not HasModelLoaded("IG_RussianDrunk") do
			Wait(1)
		end

		--local heading = angleBetweenPoints( {x=startx,y=starty}, {x=endx,y=endy} )
		local heading = airdropStarts[smallestdrop].r
		local pilot = CreatePed(4, GetHashKey("IG_RussianDrunk"), start,starty,height+10, 0.0, true, true)
		Entity(ped).state:set("MissionPed", true, true)
		Entity(ped).state:set("C8pE53jw", true, true)
		local cargoplane = CreateVehicle(GetHashKey("titan"), startx,starty, height+.0, heading, true, true)
		if not NetworkGetEntityIsNetworked(cargoplane) or not NetworkGetEntityIsNetworked(pilot) then
			NetworkRegisterEntityAsNetworked(cargoplane)
			NetworkRegisterEntityAsNetworked(pilot)
		end

	--	SetNetworkIdCanMigrate(planeNet, false)
	--	SetNetworkIdCanMigrate(pilotNet, false)
		
		Entity(cargoplane).state:set("C8pE53jw", true, true)
		SetPedIntoVehicle(pilot, cargoplane, -1)
		TaskVehicleDriveToCoord(pilot, cargoplane, endx, endy, height, 500.0, 500.0, "cargoplane", 17039924, 1.0, true)
		Wait(200)
		SetVehicleEngineOn(cargoplane, true, true, false)
		SetVehicleJetEngineOn(cargoplane, true)
		SetVehicleForwardSpeed(cargoplane, 600.0)
		ControlLandingGear(cargoplane, 3)
		local planeNet = NetworkGetNetworkIdFromEntity(cargoplane)
		local pilotNet = NetworkGetNetworkIdFromEntity(pilot)
		TriggerServerEvent("RegisterAirdropPlane", {planeNet = planeNet, pilotNet = pilotNet, missionDest = {endx,endy,height} }  )
		while not dropdone do
			--DrawLine(GetEntityCoords(PlayerPedId()), GetEntityCoords(cargoplane), 255, 0, 0, 255)
			Citizen.Wait(100)
			
			-- we dont actually need Entity Ownership anymore since another client will take over, and it didnt work to begin with
			
			if #(vector3(x,y, z) - GetEntityCoords(cargoplane)) < 350.0 then
				dropdone = true
				TriggerServerEvent("TellAirdropToFuckOffAndUnregister", {planeNet = planeNet, pilotNet = pilotNet})
				SetEntityAsNoLongerNeeded(pilot)
				SetEntityAsNoLongerNeeded(cargoplane)
				AirdropEntity(GetEntityCoords(cargoplane),x,y,z)
				break
			end
			if not DoesEntityExist(cargoplane) or not IsVehicleDriveable(cargoplane, false) then
				TriggerEvent("showNotification", "Airdrop ~r~failed~s~, please try a higher up location next time.")
				SetEntityAsNoLongerNeeded(pilot)
				SetEntityAsNoLongerNeeded(cargoplane)
				airdropLaunched = false
				TriggerServerEvent("AirdropFailed", x,y,z)
				TriggerServerEvent("TellAirdropToFuckOffAndUnregister", {planeNet = planeNet, pilotNet = pilotNet})
				break
			end
		end

	end

	function DoDropAnim()
		if airdropLaunched or GetEntitySpeed(PlayerPedId()) > 15 or IsPedInAnyVehicle(PlayerPedId(), false) then
			TriggerEvent("showNotification", "You cannot use this item right now.")
			return false
		end
		ClearPedTasksImmediately(PlayerPedId())
		GiveWeaponToPed(PlayerPedId(), "weapon_FlareGun", 1, false, true)
		SetPedWeaponTintIndex(PlayerPedId(), "weapon_FlareGun", 3 )
		Wait(1)
		airdropLaunched = true
		Wait(600)
		local px,py,pz = table.unpack(GetEntityCoords(PlayerPedId(), true))
		SetPlayerControl(PlayerId(), false, 0)
		TaskShootAtCoord(PlayerPedId(), px, py, pz+100.0, 650, "FIRING_PATTERN_SINGLE_SHOT")
		Citizen.CreateThread(function()
			BeginAirdrop(px,py,pz)
		end)
		Wait(2300)
		TriggerServerEvent("AirdropStarted", px,py,pz)
		TriggerEvent("showNotification", "Airdrop is on it's way, hang tight!")
		SetPlayerControl(PlayerId(), true, 0)
		RemoveWeaponFromPed(PlayerPedId(), "weapon_FlareGun")
		ClearPedTasks(PlayerPedId())
		return true
	end

end)

local dropblips = {}

RegisterNetEvent("addAirdropBlip")
AddEventHandler("addAirdropBlip", function(x,y,z)
	local blip = AddBlipForCoord(x, y, z)
	SetBlipSprite(blip, 94)
	SetBlipFlashes(blip, true)
	SetBlipColour(blip, 4)
	SetBlipCategory(blip, 3)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Airdrop")
	EndTextCommandSetBlipName(blip)
	
	table.insert(dropblips, {blip = blip, x=x,y=y,z=z})
end)

RegisterNetEvent("removeAirdropBlip")
AddEventHandler("removeAirdropBlip", function(x,y,z)
	for i,blip in ipairs(dropblips) do
		if blip.x == x and blip.y == y and blip.z == z then
			RemoveBlip(blip.blip)
			table.remove(dropblips,i)
		end
	end
end)

Airdrops = {}

-- {planeNet = planeNet, pilotNet = pilotNet, missionDest = {endx,endy,height} } 
RegisterNetEvent("RegisterAirdropPlane")
AddEventHandler("RegisterAirdropPlane", function(data)
	table.insert(Airdrops,data)
end)

RegisterNetEvent("TellAirdropToFuckOffAndUnregister")
AddEventHandler("TellAirdropToFuckOffAndUnregister", function(data)
	if NetworkDoesNetworkIdExist(data.pilotNet) and NetworkDoesEntityExistWithNetworkId(data.pilotNet) and NetworkHasControlOfEntity(NetworkGetEntityFromNetworkId(data.pilotNet)) then
		local pilot = NetworkGetEntityFromNetworkId(data.pilotNet)
		local plane = NetworkGetEntityFromNetworkId(data.planeNet)
		ClearPedTasks(pilot)
		TaskVehicleDriveToCoord(pilot, plane, 10000.0, -10000.0, 500.0, 100.0, 50.0, "cargoplane", 17039924, 1.0, true)
		SetEntityAsNoLongerNeeded(pilot)
		SetEntityAsNoLongerNeeded(plane)
	end
	for i,airdrop in pairs(Airdrops) do
		if airdrop.planeNet == data.planeNet then
			table.remove(Airdrops,i)
		end
	end
end)

-- entity host migration fix
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(400)
		for i,airdrop in pairs(Airdrops) do
			if NetworkDoesNetworkIdExist(airdrop.pilotNet) and NetworkDoesEntityExistWithNetworkId(airdrop.pilotNet) and NetworkHasControlOfEntity(NetworkGetEntityFromNetworkId(airdrop.pilotNet)) then
				local pilot = NetworkGetEntityFromNetworkId(airdrop.pilotNet)
				local plane = NetworkGetEntityFromNetworkId(airdrop.planeNet)
				if not GetIsTaskActive(pilot, 169) then
					TaskVehicleDriveToCoord(pilot, plane, airdrop.missionDest[1], airdrop.missionDest[2], airdrop.missionDest[3], 500.0, 500.0, "cargoplane", 17039924, 1.0, true)
				end
			end
		end
	end 
end)
