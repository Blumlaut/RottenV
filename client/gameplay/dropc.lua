RegisterNetEvent("dropweapon")
AddEventHandler('dropweapon', function()
	local ped = PlayerPedId()
	if DoesEntityExist(ped) and not IsEntityDead(ped) then
		local x,y,z = table.unpack(GetEntityCoords(ped,true))
		local weaponHash = GetSelectedPedWeapon(ped)
		local ammo = GetAmmoInPedWeapon(ped, weapon)
		local _,clipammo = GetAmmoInClip(ped, weapon)
		--RemoveWeaponFromPed(ped, weapon)
		local weapon = tostring(weaponHash)
		local weapon = reverseWeaponHash(weapon,2)
		if weapon then
			RemoveWeaponFromPed(ped, weaponHash)
			ForceCreateWeaponPickupAtCoord(x+4,y,z, weapon, ammo-(clipammo*2))
		end
	end
end)
