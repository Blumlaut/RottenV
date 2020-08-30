local baseTemp = 37.0 -- base body heat
local isLosingBlood = false
local curWeatherTemp = 37.0
local curWeather, curWeatherTemp = 0, 0

local weatherTemps = {
	{weather = "CLEAR", temp = 37.0}, -- weather name and avg body temp
	{weather = "EXTRASUNNY", temp = 37.3},
	{weather = "CLOUDS", temp = 37.0},
	{weather = "OVERCAST", temp = 37.0},
	{weather = "RAIN", temp = 36.6},
	{weather = "CLEARING", temp = 37.0},
	{weather = "THUNDER", temp = 36.6},
	{weather = "SMOG", temp = 37.0},
	{weather = "FOGGY", temp = 36.5},
	{weather = "XMAS", temp = 34.0},
	{weather = "XMAS", temp = 34.0},
	{weather = "SNOWLIGHT", temp = 34.0},
	{weather = "BLIZZARD", temp = 34.0},
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
			baseTemp = baseTemp-0.01
		elseif baseTemp < curWeatherTemp then
			 baseTemp = baseTemp+0.01
		end
		Wait(10000)
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