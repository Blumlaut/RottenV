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

WeatherConfig = {}
WeatherConfig = setmetatable(WeatherConfig, {})

activeWeatherSystems = {}

WeatherConfig.decemberSnowDays = { 10,11, 12, 13, 14, 15, 17, 18, 21, 22, 23, 24, 25, 26, 27, 28 }

WeatherConfig.weatherTypes = {
	"CLEAR",
	"EXTRASUNNY",
	"CLOUDS",
	"OVERCAST",
	"RAIN",
	"CLEARING",
	"THUNDER",
	"SMOG",
	"FOGGY",
	"XMAS",
	"SNOWLIGHT",
	"BLIZZARD"
}

-- winter 

WeatherConfig.randomizeTime = 900000 -- 15 Minutes (TIME TO RANDOMIZE WEATHER SYSTEMS IN MILLISECONDS)

WeatherConfig.weatherSystems = {
	{
		{ "TERMINA", "ELYSIAN", "AIRP", "BANNING", "DELSOL", "RANCHO", "STRAW", "CYPRE", "SANAND" },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] }, -- Spring
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] }, -- Summer
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] }, -- Fall
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9], WeatherConfig.weatherTypes[12], WeatherConfig.weatherTypes[11] } -- Winter
	}, -- South LS
	{
		{ "MURRI", "LMESA", "SKID", "LEGSQU", "TEXTI", "PBOX", "KOREAT" },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9], WeatherConfig.weatherTypes[12], WeatherConfig.weatherTypes[11] }
	}, -- Central LS
	{
		{ "MIRR", "EAST_V", "DTVINE", "ALTA", "HAWICK", "BURTON", "ROCKF", "MOVIE", "DELPE", "MORN", "RICHM", "GOLF", "WVINE", "DTVINE", "HORS", "LACT", "LDAM" },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9], WeatherConfig.weatherTypes[12], WeatherConfig.weatherTypes[11] }
	}, -- North LS
	{
		{ "BEACH", "VESP", "VCANA", "DELBE", "PBLUFF" },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9], WeatherConfig.weatherTypes[12], WeatherConfig.weatherTypes[11] }
	}, -- LS Beaches
	{
		{ "EBURO", "PALHIGH", "NOOSE", "TATAMO" },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9], WeatherConfig.weatherTypes[12], WeatherConfig.weatherTypes[11] }
	}, -- Eastern Valley
	{
		{ "BANHAMC", "BANHAMCA", "CHU", "TONGVAH" },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9], WeatherConfig.weatherTypes[12], WeatherConfig.weatherTypes[11] }
	}, -- Coastal Beaches
	{
		{ "CHIL", "GREATC", "RGLEN", "TONGVAV"},
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9], WeatherConfig.weatherTypes[12], WeatherConfig.weatherTypes[11] }
	}, -- North LS Hills
	{
		{ "PALMPOW", "WINDF", "RTRACK", "JAIL", "HARMO", "DESRT", "SANDY", "ZQ_UAR", "HUMLAB", "SANCHIA", "GRAPES", "ALAMO", "SLAB", "CALAFAB" },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[9], WeatherConfig.weatherTypes[12], WeatherConfig.weatherTypes[11] }
	}, -- Grand Senora Desert
	{
		{ "MTGORDO", "ELGORL", "BRADP", "BRADT", "MTCHIL", "GALFISH" },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9], WeatherConfig.weatherTypes[12], WeatherConfig.weatherTypes[11] }
	}, -- Northern Moutains
	{
		{ "LAGO", "ARMYB", "NCHU", "CANNY", "MTJOSE" },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9], WeatherConfig.weatherTypes[12], WeatherConfig.weatherTypes[11] }
	}, -- Zancudo
	{
		{ "CMSW", "PALCOV", "OCEANA", "PALFOR", "PALETO", "PROCOB" },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9] },
		{ WeatherConfig.weatherTypes[1], WeatherConfig.weatherTypes[2], WeatherConfig.weatherTypes[3], WeatherConfig.weatherTypes[4], WeatherConfig.weatherTypes[5], WeatherConfig.weatherTypes[6], WeatherConfig.weatherTypes[7], WeatherConfig.weatherTypes[8], WeatherConfig.weatherTypes[9], WeatherConfig.weatherTypes[12], WeatherConfig.weatherTypes[11] }
	}, -- Palteo
}

WeatherConfig.timesOfYear = {
	{ 3, 4, 5 }, --SPRING 1
	{ 6, 7, 8 }, --SUMMER 2
	{ 9, 10, 11 }, --FALL 3
	{ 12, 1, 2 } --WINTER 4
}

function getCurrentSeason()
	for i, timeOfYear in ipairs(WeatherConfig.timesOfYear) do
		for k, month in ipairs(WeatherConfig.timesOfYear[i]) do
			if month == os.date("*t").month then
				return i
			end
		end
	end
end

function isSnowDay()
	for i, decemberSnowDay in ipairs(WeatherConfig.decemberSnowDays) do
		if decemberSnowDay == os.date("*t").day then
			return true
		end
	end
	return false
end

function findZoneBySubZone(zoneName)
	for i, weatherSystem in ipairs(WeatherConfig.weatherSystems) do
		for _, weatherZone in ipairs(weatherSystem[1]) do
			if weatherZone == zoneName then
				return i
			end
		end
	end
end

function randomizeSystems()
	activeWeatherSystems = nil
	collectgarbage()
	activeWeatherSystems = {}
	for i, weatherSystem in ipairs(WeatherConfig.weatherSystems) do
		local currentSeason = getCurrentSeason()
		local availableWeathers = weatherSystem[currentSeason + 1]
		local pickedWeather = availableWeathers[math.random(1, #availableWeathers)]
		for _, weatherZone in ipairs(weatherSystem[1]) do
			if os.date("*t").month == 12 and isSnowDay() and WeatherConfig.snowEnabled then
				table.insert(activeWeatherSystems, {weatherZone, "XMAS"})
			else
				table.insert(activeWeatherSystems, {weatherZone, pickedWeather})
			end
		end
	end
end