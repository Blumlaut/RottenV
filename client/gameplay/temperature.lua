local baseTemp = 37.0 -- base body heat
local isLosingBlood = false
local curWeatherTemp = 37.0
local curWeather = 0

local weatherTemps = {
	{weather = "CLEAR", temp = 37.0}, -- weather name and avg body temp
	{weather = "EXTRASUNNY", temp = 38.3},
	{weather = "CLOUDS", temp = 36.6},
	{weather = "OVERCAST", temp = 37.0},
	{weather = "RAIN", temp = 35.6},
	{weather = "CLEARING", temp = 37.0},
	{weather = "THUNDER", temp = 35.6},
	{weather = "SMOG", temp = 37.0},
	{weather = "FOGGY", temp = 36.3},
	{weather = "XMAS", temp = 33.0},
	{weather = "SNOWLIGHT", temp = 33.6},
	{weather = "BLIZZARD", temp = 33.0},
}

Citizen.CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		if IsPedSprinting(playerPed) then
			baseTemp = baseTemp+0.02
		elseif IsPedInVehicle(playerPed) then
			curWeatherTemp = 37.0
		end
		if baseTemp > curWeatherTemp then
			baseTemp = baseTemp-0.1
		elseif baseTemp < curWeatherTemp then
			 baseTemp = baseTemp+0.1
		end
		Wait(5000)
	end
end)

Citizen.CreateThread(function()
	while true do
		curWeather = GetPrevWeatherTypeHashName()
		for i,e in pairs(weatherTemps) do
			if GetHashKey(e.weather) == curWeather then
				curWeatherTemp = e.temp
			end
		end
		Wait(20000)
	end
end)

Citizen.CreateThread(function()
	while true do
		local localPlayerPed = PlayerPedId()
		local health = GetEntityHealth(localPlayerPed)
		if(baseTemp<=35.6 or baseTemp>=37.1) then
			SetEntityHealth(localPlayerPed,health-2)
		end
		Wait(10000)
	end
end)
