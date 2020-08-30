--[[
_____  _         __          __        _   _
|  __ \(_)        \ \        / /       | | | |
| |  | |_ _ __   __\ \  /\  / /__  __ _| |_| |__   ___ _ __
| |  | | | '_ \ / _ \ \/  \/ / _ \/ _` | __| '_ \ / _ \ '__|
| |__| | | | | | (_) \  /\  /  __/ (_| | |_| | | |  __/ |
|_____/|_|_| |_|\___/ \/  \/ \___|\__,_|\__|_| |_|\___|_|

FiveM-DinoWeather
A Weather System that enhances realism by using GTA Natives relating to Zones.
Copyright (C) 2019  Jarrett Boice

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

]]

Citizen.CreateThread(function()
	while config.enableDynoWeather do
		Citizen.Wait(0)
		randomizeSystems()
		Citizen.Wait(WeatherConfig.randomizeTime)
	end
end)

RegisterServerEvent("dinoweather:syncWeather")
AddEventHandler("dinoweather:syncWeather", function()
	local _source = source
	TriggerClientEvent("dinoweather:syncWeather", _source, activeWeatherSystems)
end)

RegisterServerEvent("dinoweather:setWeatherInZone")
AddEventHandler("dinoweather:setWeatherInZone", function(zoneName, weatherType)
	local _source = source
	if IsPlayerAceAllowed(_source, "dinoweather.cmds") then
		local zoneArea = findZoneBySubZone(zoneName)
		for _, weatherZone in ipairs(WeatherConfig.weatherSystems[zoneArea][1]) do
			local foundInterval = nil
			for i, activeZone in ipairs(activeWeatherSystems) do
				if activeZone[1] == weatherZone then
					foundInterval = i 
				end
			end
			if foundInterval ~= nil then
				activeWeatherSystems[foundInterval] = {zoneName, weatherType}
			else
				table.insert(activeWeatherSystems, {zoneName, weatherType})
			end
		end
		TriggerClientEvent("dinoweather:syncWeather", -1, activeWeatherSystems)
		TriggerClientEvent("chatMessage", _source, "^2Weather set to ^3" .. weatherType .. "^2.")
	else
		TriggerClientEvent("chatMessage", _source, "^3No Permission.")
	end
end)