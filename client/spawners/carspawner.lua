RegisterNetEvent("spawnNewVehicle")

cars = {}

Citizen.CreateThread(function()
	while true do
		Wait(1)
		
		--[[
		if #cars < 2 then
			x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))

			local newVehicleX = x
			local NewVehicleY = y
			local NewVehicleZ = 0

			repeat
				Wait(1)
				newVehicleX = x + math.random(-1000, 1000)
				NewVehicleY = y + math.random(-1000, 1000)
				_,NewVehicleZ = GetGroundZFor_3dCoord(newVehicleX+.0,NewVehicleY+.0,z+999.0, 1)
			until NewVehicleZ ~= 0

			choosenCar = spawnableCars[carChances[ math.random( #carChances ) ] ].model
			RequestModel(choosenCar)
			while not HasModelLoaded(choosenCar) or not HasCollisionForModelLoaded(choosenCar) do
				Wait(200)
			end

			car = CreateVehicle(choosenCar, newVehicleX, NewVehicleY, NewVehicleZ, math.random(0,360)+.0, true, false)
			DecorSetBool(car, "C8pE53jw", true)
			SetVehicleFuelLevel(car, math.random() + math.random(10, 80))
			SetVehicleEngineHealth(car, math.random(400,1000)+0.0)
			PlaceObjectOnGroundProperly(car)
			if not NetworkGetEntityIsNetworked(car) then
				NetworkRegisterEntityAsNetworked(car)
			end
			TriggerServerEvent("registerNewVehicle", NetworkGetNetworkIdFromEntity(car))
			Wait(5000)
		end
		
		
		for i, car in pairs(cars) do
			if GetEntityHealth(car.id) < 10.0 then
				SetEntityAsNoLongerNeeded(car.localid)
				writeLog("\ndeleting car", 1)
				TriggerServerEvent("removeOldVehicle", car.id)
				Wait(5000)
			end
		end
		--]]
	end
end)


function GenerateRandomVehicle(maxVehicles)
	if #cars < maxVehicles then --make sure we dont spawn too many cars for some reason 
		x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))

		local newVehicleX = x
		local NewVehicleY = y
		local NewVehicleZ = 0

		repeat
			newVehicleX = x + math.random(-1000, 1000)
			NewVehicleY = y + math.random(-1000, 1000)
			RequestCollisionAtCoord(newVehicleX, NewVehicleY, z)
			Wait(500)
			_,NewVehicleZ = GetGroundZFor_3dCoord(newVehicleX+.0,NewVehicleY+.0,z+999.0, 1)
		until NewVehicleZ ~= 0

		choosenCar = spawnableCars[carChances[ math.random( #carChances ) ]].model
		RequestModel(choosenCar)
		while not HasModelLoaded(choosenCar) or not HasCollisionForModelLoaded(choosenCar) do
			Wait(200)
		end

		car = CreateVehicle(choosenCar, newVehicleX, NewVehicleY, NewVehicleZ, math.random(0,360)+.0, true, false)
		Entity(car).state:set("C8pE53jw", true, true)
		SetVehicleFuelLevel(car, math.random() + math.random(10, 80))
		SetVehicleEngineHealth(car, math.random(300,1000)+0.0)
		PlaceObjectOnGroundProperly(car)
		Wait(500)
		if not NetworkGetEntityIsNetworked(car) then
			NetworkRegisterEntityAsNetworked(car)
			Wait(500)
		end
		
		TriggerServerEvent("registerNewVehicle", NetworkGetNetworkIdFromEntity(car))
		writeLog("\nGenerated New Car, NetId: "..NetworkGetNetworkIdFromEntity(car), 1)
	end
end
RegisterNetEvent("GenerateRandomVehicle")
AddEventHandler("GenerateRandomVehicle", GenerateRandomVehicle)

function isVehicleLocal(vehid)
	for i, car in ipairs(cars) do
		if car.id == vehid then
			return true
		end
	end
	return false
end

function isVehicleUsable(veh)
	if not DoesEntityExist(veh) then
		return false
	elseif GetEntityHealth(veh) < 10.0 then
		return false
	end
	return IsVehicleDriveable(veh, 0)
end

RegisterNetEvent("vehiclePoll")
AddEventHandler("vehiclePoll", function()
	local pollcars = {}
	for i, car in ipairs(cars) do
		local t = {id = car.id, exists = isVehicleUsable(car.localid)}
		table.insert(pollcars, t)
	end
	TriggerServerEvent("vehiclePoll", pollcars)
end)

RegisterNetEvent("registerNewVehicle")
AddEventHandler("registerNewVehicle", function(veh)
	-- {netid = netid, id = #spawnedCars+1}
	veh.localid = NetworkGetEntityFromNetworkId(veh.netid)
	table.insert(cars, veh )
end)

RegisterNetEvent("removedOldVehicle")
AddEventHandler("removedOldVehicle", function(veh)
	for i, car in ipairs(cars) do
		if car.id == veh then
			if DoesEntityExist(car.localid) then
				DeleteEntity(car.localid)
			end
			table.remove(cars,i)
			break
		end
	end
end)

function GetVehicleFromServerId(serverid)
	for i,car in ipairs(cars) do
		if car.id == serverid then
			return car.localid
		end
	end
	return false
end

--[[

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for i, car in pairs(cars) do
			c = car.localid
			playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
			carX, carY, carZ = table.unpack(GetEntityCoords(c, false))
			DrawLine(playerX,playerY, playerZ, carX, carY, carZ, 255.0,0.0,0.0,255.0)
			
			SetTextScale(0.2, 0.2)
			SetTextFont(0)
			SetTextProportional(1)
			-- SetTextScale(0.0, 0.55)
			SetTextColour(255, 255, 255, 255)
			SetTextDropshadow(0, 0, 0, 0, 55)
			SetTextEdge(2, 0, 0, 0, 150)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			SetTextCentre(1)
			AddTextComponentString("CAR INFO: \nHP:"..GetEntityHealth(c).. " \nENG:"..GetVehicleEngineHealth(c).." \nNETID:".. car.netid)
			local _,screenx,screeny = World3dToScreen2d(carX,carY,carZ)
			DrawText(screenx,screeny)
		end
	end
end)

]]

RegisterNetEvent("Z:cleanup")
AddEventHandler("Z:cleanup", function()
	for i, car in pairs(cars) do
		-- Set car as no longer needed for despawning
		SetEntityAsNoLongerNeeded(car.localid)
	end
	cars = {}
end)

RegisterNetEvent("loadVehicles")
AddEventHandler("loadVehicles", function(servercars)
	for i,veh in pairs(servercars) do
		veh.localid = NetworkGetEntityFromNetworkId(veh.netid)
		table.insert(cars, veh)
	end
end)