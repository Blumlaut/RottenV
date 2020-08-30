local whitelistedGuns = {
	100416529,
	205991906,
	-952879014,
	1785463520,
	177293209,
}

local DoesWeaponExist, Weapon, WeaponDamageType = false,0,0
local ped = 0
local currentWeaponHash = 0
Citizen.CreateThread(function() -- slow thread
	ped = PlayerPedId()
	while true do
		Wait(1000)
		ped = PlayerPedId()
		DoesWeaponExist,Weapon = GetCurrentPedWeapon(ped, true)
		WeaponDamageType = GetWeaponDamageType(Weapon)
		currentWeaponHash = GetSelectedPedWeapon(ped)
	end
end)

Citizen.CreateThread(function()
	local isSniper = false
	while config.disableReticle do
		Citizen.Wait(0)
		if isWeapon and WeaponDamageType ~= 1 then			
			SetPlayerLockon(ped, false)
			SetPlayerLockonRangeOverride(ped, 0.0)
		elseif WeaponDamageType == 1 then
			SetPlayerLockon(ped, true)
			SetPlayerLockonRangeOverride(ped, GetLockonRangeOfCurrentPedWeapon(ped))
		end
		local isSniper = false
		
		for i,hash in ipairs(whitelistedGuns) do
			if hash == currentWeaponHash then
				isSniper = true
			end
		end

		if not isSniper then
			HideHudComponentThisFrame(14)
		end
	end
end)