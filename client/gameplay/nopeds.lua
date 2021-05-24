-- Thanks to @nobody

Citizen.CreateThread(function()
    -- Other stuff normally here, stripped for the sake of only scenario stuff
		-- These natives do not have to be called everyframe.
		SetGarbageTrucks(0)
		SetRandomBoats(0)

		for i=1,15 do
			EnableDispatchService(i,false)
		end
    local SCENARIO_TYPES = {
        "DRIVE",
        "WORLD_VEHICLE_EMPTY",
        "WORLD_VEHICLE_DRIVE_SOLO",
        "WORLD_VEHICLE_BOAT_IDLE_ALAMO",
        "WORLD_VEHICLE_PARK_PERPENDICULAR_NOSE_IN",
        "WORLD_VEHICLE_MILITARY_PLANES_SMALL",
        "WORLD_VEHICLE_MILITARY_PLANES_BIG",
    }
    local SCENARIO_GROUPS = {
        2017590552, -- LSIA planes
        2141866469, -- Sandy Shores planes
				"BLIMP",
				"ALAMO_PLANES",
				"ARMY_HELI",
				"GRAPESEED_PLANES",
				"SANDY_PLANES",
				"ng_planes",
    }
    local SUPPRESSED_MODELS = {
        "SHAMAL",
        "LUXOR",
        "LUXOR2",
        "LAZER",
        "TITAN",
        "CRUSADER",
        "RHINO",
        "AIRTUG",
        "RIPLEY",
        "SUNTRAP",
				"BLIMP",
    }
 
    while true do
        for _, sctyp in next, SCENARIO_TYPES do
            SetScenarioTypeEnabled(sctyp, false)
        end
        for _, scgrp in next, SCENARIO_GROUPS do
            SetScenarioGroupEnabled(scgrp, false)
        end
        for _, model in next, SUPPRESSED_MODELS do
            SetVehicleModelIsSuppressed(GetHashKey(model), true)
        end
		RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0);
        Wait(30000)
    end
end)

AddScenarioBlockingArea(-10000.0, -10000.0, -1000.0, 10000.0, 10000.0, 1000.0, false, true, true, true)
Citizen.CreateThread(function()
	StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE") -- this should disable city sounds
	while true do
		-- These natives has to be called every frame.
		SetVehicleDensityMultiplierThisFrame(0.0)
		SetPedDensityMultiplierThisFrame(0.0)
		SetRandomVehicleDensityMultiplierThisFrame(0.0)
		SetParkedVehicleDensityMultiplierThisFrame(0.0)
		SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)

		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))

		Citizen.Wait(1)
	end
end)

Citizen.CreateThread(function()
	while true do
		local handle, veh = FindFirstVehicle()
		local finished = false -- FindNextPed will turn the first variable to false when it fails to find another ped in the index
		repeat
			if GetVehicleEngineHealth(veh) <= 100 then
				SetEntityAsMissionEntity(veh,true,true)
				SetEntityAsNoLongerNeeded(veh)
				writeLog("\nDeleted Destroyed Vehicle", 1)
			end
			Wait(1)
			finished, veh = FindNextVehicle(handle) -- first param returns true while entities are found
		until not finished
		EndFindVehicle(handle)
		Citizen.Wait(160000)
	end
end)

Citizen.CreateThread(function()
	while true do
		local handle, ped = FindFirstPed()
		local finished = false -- FindNextPed will turn the first variable to false when it fails to find another ped in the index
		repeat
			Wait(1)
			if IsPedDeadOrDying(ped) and not IsPedAPlayer(ped) then
				SetEntityAsMissionEntity(ped,true,true)
				SetEntityAsNoLongerNeeded(ped)
				DeleteEntity(ped)
				writeLog("\nDeleted Dead Ped", 1)
			end
			finished, ped = FindNextPed(handle) -- first param returns true while entities are found
			Wait(1)
		until not finished
		EndFindPed(handle)
		Citizen.Wait(60000)
	end
end)
