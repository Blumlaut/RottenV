spawnedCars = {}
maxCars = config.maxVehicles

vehPollResults = {}


RegisterServerEvent("registerNewVehicle")
RegisterServerEvent("removeOldVehicle")
RegisterServerEvent("vehiclePoll")

AddEventHandler("registerNewVehicle", function(netid)
	local t = {netid = netid, id = #spawnedCars+1}
	table.insert(spawnedCars,t)
	TriggerClientEvent("registerNewVehicle", -1, t)
	writeLog("\nRegistering Vehicle "..t.id, 1)
end)

AddEventHandler("removeOldVehicle", function(vehicle)
	for i,veh in ipairs(spawnedCars) do
		if veh.id == vehicle then
			table.remove(spawnedCars,i)
		end
	end
	TriggerClientEvent("removedOldVehicle", -1, vehicle)
end)


AddEventHandler("vehiclePoll", function(cars)
	table.insert(vehPollResults, cars)
end)

Citizen.CreateThread(function()
	while true do
		Wait(20000)
		local players = GetPlayers()
		if #spawnedCars < maxCars and #players > 0 then
			TriggerClientEvent("GenerateRandomVehicle", players[ math.random( #players ) ], maxCars ) -- ask a random player to generate a vehicle
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(60000) -- polling thread
		if #GetPlayers() ~= 0 then
			vehPollResults = {}
			TriggerClientEvent("vehiclePoll", -1, spawnedCars)
			Wait(3000)
			for i,spawnedCar in ipairs(spawnedCars) do
				thisCarExists = false
				for i, pollresult in ipairs(vehPollResults) do
					for d,car in ipairs(pollresult) do
						if car.id == spawnedCar.id then
							if car.exists then
								thisCarExists=true
							end
						end
					end
				end
				if not thisCarExists then
					writeLog("\nDeleting Vehicle "..spawnedCar.id, 1)
					table.remove(spawnedCars, i)
					TriggerClientEvent("removedOldVehicle", -1, spawnedCar.id)
				end
			end
		else
			spawnedCars = {}
		end
	end
end)


Citizen.CreateThread(function()
	RegisterServerEvent("Z:newplayerID")
	AddEventHandler("Z:newplayerID", function(playerid)
		TriggerClientEvent("loadVehicles", source, spawnedCars)
	end)
end)
