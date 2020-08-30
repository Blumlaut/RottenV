-- CONFIG --

-- Allows you to set if time should be frozen and what time
local freezeTime = false
local hours = 1
local minutes = 0

-- Set if first person should be forced
local forceFirstPerson = false

-- CODE --

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		_,pw = GetCurrentPedWeapon(PlayerPedId(), true)
		if GetWeaponDamageType(pw) ~= 2 then
			DisableControlAction(0, 140, true) 
			DisableControlAction(0, 142, true) 
		end
		SetFlashLightFadeDistance(30.0)
	end
end)

Citizen.CreateThread(function()
	SetBlackout(true)
	while true do
		Wait(1)

		SetPlayerWantedLevel(PlayerId(), 0, false)
		SetPlayerWantedLevelNow(PlayerId(), false)
	end
end)

local leapYear = 1


Citizen.CreateThread( function()
	RegisterNetEvent("tads:timeanddatesync")
	AddEventHandler("tads:timeanddatesync", function(time,date)
		NetworkOverrideClockTime(time.hour,time.minute,0)
		SetClockDate(date.day,date.month,date.year)
	end)
	TriggerServerEvent("tads:newplayer")

end)