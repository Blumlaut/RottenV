local metricEvent = "prometheus:addMetric"

Citizen.CreateThread(function()
	TriggerEvent(metricEvent, "Gauge", "fxs_rottenv_items", "RottenV: Items", function(cb)
		while true do
			Wait(5000)
			  cb("set", #spawnedItems)
		end
	end)
end)


Citizen.CreateThread(function()
	TriggerEvent(metricEvent, "Gauge", "fxs_rottenv_huntedplayers", "RottenV: Hunted Players", function(cb)
		while true do
			Wait(5000)
			  cb("set", #huntedPlayers)
		end
	end)
end)

Citizen.CreateThread(function()
	TriggerEvent(metricEvent, "Gauge", "fxs_rottenv_squads", "RottenV: Squads", function(cb)
		while true do
			Wait(5000)
			  cb("set", #Squads)
		end
	end)
end)

Citizen.CreateThread(function()
	TriggerEvent(metricEvent, "Gauge", "fxs_rottenv_cars", "RottenV: Cars", function(cb)
		while true do
			Wait(5000)
			  cb("set", #spawnedCars)
		end
	end)
end)


Citizen.CreateThread(function()
	TriggerEvent(metricEvent, "Gauge", "fxs_rottenv_safes", "RottenV: Safes", function(cb)
		while true do
			Wait(8000)
			cb("set", #safes)
		end
	end)
end)


Citizen.CreateThread(function()
	TriggerEvent(metricEvent, "Gauge", "fxs_rottenv_power", "RottenV: Power Generator Status", function(cb)
		while true do
			Wait(10000)
			local pwr = 0
			if blackoutEnabled then 
				pwr = 0
			else
				pwr = 1
			end
			cb("set", pwr)
		end
	end)
end)

Citizen.CreateThread(function()
	TriggerEvent(metricEvent, "Gauge", "fxs_rottenv_banditcamps", "RottenV: Bandit Camps", function(cb)
		while true do
			Wait(8000)
			cb("set", #BanditCamps)
		end
	end)
end)


Citizen.CreateThread(function()
	TriggerEvent(metricEvent, "Gauge", "fxs_rottenv_activeweathersystems", "RottenV: Weather Systems", function(cb)
		while true do
			Wait(8000)
			cb("set", #activeWeatherSystems)
		end
	end)
end)
