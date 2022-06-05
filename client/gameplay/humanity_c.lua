
-- humanity regenerative code, there are no handlers for PlayerPed skins yet as that would require some coding magic, maybe
humanity = 500 -- make sure humanity is defined so other scripts dont break
infectionchance = {
	{humanitystart = 900, humanitystop = 9999, chance = 1},
	{humanitystart = 800, humanitystop = 900, chance = 3},
	{humanitystart = 700, humanitystop = 800, chance = 6},
	{humanitystart = 600, humanitystop = 700, chance = 8},
	{humanitystart = 400, humanitystop = 600, chance = 12},
	{humanitystart = 300, humanitystop = 400, chance = 16},
	{humanitystart = 200, humanitystop = 300, chance = 18},
	{humanitystart = 100, humanitystop = 200, chance = 23},
	{humanitystart = -9999, humanitystop = 100, chance = 26}
}

-- actually, maybe only the hunger/thirst things.
-- also weapons need to be transfered between skin changes.

possessed = false

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(300000)
		local PlayerPed = PlayerPedId()
		if humanity	< 1300 then
			if #curSquadMembers > 1 and #curSquadMembers <= 4 then
				humanity = humanity+5.0
			elseif #curSquadMembers > 4 and #curSquadMembers <= 6 then
				humanity = humanity+7.0
			elseif #curSquadMembers > 6 then
				humanity = humanity+10.0
			else
				humanity = humanity+3.0
			end
		end
	end
end)


Citizen.CreateThread(function()
	Citizen.Wait(30000)
	while true do
		Citizen.Wait(0)
		local oldPed = PlayerPedId()
		local oldHealth = GetEntityHealth(oldPed)

		Wait(100)
		local newPed = PlayerPedId()
		local newHealth = GetEntityHealth(newPed)

		if oldHealth - newHealth > 20 and newPed == oldPed then
			local c = math.random(0,100)
			for i, infection in ipairs(infectionchance) do
				if humanity >= infection.humanitystart and humanity < infection.humanitystop then
					if c <= infection.chance and not infected then
						infected = true
						TriggerEvent("showNotification", "You have been ~r~Infected~w~! \nFind ~g~Antibiotics~w~ to Cure it!")
						initiateSave(true)
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	function PossessPlayer(ped)
		possessed = true
		local veh = false
		local seat = false
		local playerped = PlayerPedId()
		if IsPedInAnyVehicle(playerped,false) then
			veh = GetVehiclePedIsIn(playerped)
			for i = -1, 16 do
					if GetPedInVehicleSeat(veh,i) == playerped then
						seat = i
					end
			end
		end


		ClearPedTasksImmediately(playerped)
		StartScreenEffect("DrugsMichaelAliensFight", 1000,true)
		SetPedFleeAttributes(ped, 0, 0)
		SetPedCombatAttributes(ped, 16, 1)
		SetPedCombatAttributes(ped, 17, 0)
		SetPedCombatAttributes(ped, 46, 1)
		SetPedCombatAttributes(ped, 1424, 0)
		SetPedCombatAttributes(ped, 5, 1)
		SetPedCombatRange(ped,2)
		SetPedAlertness(ped,3)
		SetPedIsDrunk(ped, true)
		if veh then
			SetPedIntoVehicle(ped,veh,seat)
		end
		RequestAnimSet("move_m@drunk@verydrunk")
		while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
			Wait(100)
		end
		SetPedMovementClipset(ped, "move_m@drunk@verydrunk", 1.0)
		TaskWanderStandard(ped, 1.0, 10)
		SetPedRelationshipGroupHash(ped, GetHashKey("zombeez"))
		SetCurrentPedWeapon(ped, "WEAPON_UNARMED", true)
		SetPlayerMeleeWeaponDamageModifier(-1, 3.0)
	end

	function unPossessPlayer(ped, oldhunger,oldthirst,oldhumanity)
		possessed = false
		ClearPedTasksImmediately(PlayerPedId())
		StopScreenEffect("DrugsMichaelAliensFight")
		SetPedIsDrunk(ped, false)
		ResetPedMovementClipset(ped, 0.0)
		SetPedRelationshipGroupHash(ped, GetHashKey("PLAYER"))
		SetPlayerMeleeWeaponDamageModifier(-1, 1.0)
		if oldhunger then
			LocalPlayer.state.hunger = oldhunger
			LocalPlayer.state.thirst = oldthirst
			humanity = oldhumanity-30.0
		end
	end
end)

Citizen.CreateThread(function()
	function checkPossession()
		local ped = PlayerPedId()
		if infected then
			if not possessed then
				thunger = LocalPlayer.state.hunger
				tthirst = LocalPlayer.state.thirst
				thumanity = humanity
				PossessPlayer(ped)
				initiateSave(true)
				if WarMenu.IsMenuOpened('Interaction') then
					WarMenu.CloseMenu()
				end
				local wait = math.random(10000, 40000)
				SetTimeout(wait,checkPossession)
			else
				unPossessPlayer(ped, thunger,tthirst,thumanity)
				initiateSave(true)
			end
		end
		local wait = math.random(300000, 1200000)
		SetTimeout(wait,checkPossession) -- make sure this check repeats itself
	end
	checkPossession()
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		if infected then
			if possessed then
				LocalPlayer.state.hunger = math.random(20,100)+.0
				LocalPlayer.state.thirst = math.random(20,100)+.0
				humanity = math.random(0,999)+.0
			end
		end
	end
end)
