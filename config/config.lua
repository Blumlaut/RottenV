-- define config
config = {}

-- find item IDs in shared/inventory/items.lua
config.startItems = {
	[1]=1,
	[2]=1, 
}


-- Start Money, don't set this too high, or the Anticheat will kick in.
config.startMoney = 0 



-- how many vehicles can spawn, as a total.
config.maxVehicles = 60




-- How many Food items can be spawned, per player.
config.maxSpawnedFood = 6

-- How many Weapon Items can be spawned, per player.
config.maxSpawnedWeapons = 4



-- Skin Types for different humanity levels.
config.skins = {
	hero = "s_m_m_chemsec_01",
	neutral = "s_m_y_armymech_01",
	bandit = "s_m_y_xmech_02"
}

-- Amount of kills needed to become "hunted"
config.huntedAmount = 5


-- Weither or not to disable the weapon reticle
config.disableReticle = true


-- Do we want DynoWeather?
config.enableDynoWeather = true


-- Time in Days, how long should it take for safes to expire if they haven't been opened?
config.SafeExpirationTime = 7


-- How many days the server should unlock the safes for, until it gets deleted ( added ONTOP of SafeExpirationTime )
config.SafeUnlockTime = 1