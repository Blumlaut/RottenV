local safes = {}
safeContents = {}
safeContents.count = {}
currentSafe = {}
for i,Consumable in ipairs(consumableItems) do
	safeContents.count[i] = 0.0
end

RegisterNetEvent("loadSafes")
RegisterNetEvent("loadSafe")
RegisterNetEvent("GetSafeContents")
RegisterNetEvent("removeSafe")
RegisterNetEvent("addSafe")
RegisterNetEvent("addCustomSafe")


local isNearSafe = false

local safemenus = {'safe','safeinventory','safeadditem','safetakeitem'}

AddEventHandler("loadSafes", function(tt)
	safes = tt
	updateAllSafes()
	writeLog("\nSafes Recieved!\n", 1)
end)

AddEventHandler("loadSafe", function(t)
	table.insert(safes,t)
	updateAllSafes()
end)


Citizen.CreateThread(function()
	if not HasModelLoaded("prop_ld_int_safe_01") then
		RequestModel('prop_ld_int_safe_01')
	end
	function updateAllSafes()
		for i,theSafe in pairs(safes) do
			if theSafe.visible and not theSafe.blip then
				local blip = AddBlipForCoord(theSafe.x,theSafe.y,theSafe.z) -- Creates the name of the blip on the list in the pause menu
				SetBlipSprite(blip, theSafe.blipicon or 181)
				SetBlipColour(blip, 6)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				if theSafe.blipicon then
					AddTextComponentString("Airdrop")
				else
					AddTextComponentString("Unlocked Safe. Passcode: 0000")
				end 
				EndTextCommandSetBlipName(blip)
				safes[i].blip = blip
			end

			if not theSafe.obj then
				if not HasModelLoaded(theSafe.model or "prop_ld_int_safe_01") then
					RequestModel(theSafe.model or 'prop_ld_int_safe_01')
				end
				while not HasModelLoaded(theSafe.model or 'prop_ld_int_safe_01') do
					Citizen.Wait(1)
				end

				local obj = CreateObjectNoOffset(theSafe.model or "prop_ld_int_safe_01", theSafe.x,theSafe.y,theSafe.z,false,true,true)
				SetEntityRotation(obj,0.0,0.0,theSafe.r,1,true)
				PlaceObjectOnGroundProperly(obj)
				FreezeEntityPosition(obj,true)
				safes[i].obj = obj
			end
		end
	end

	function SaveCurrentSafe()
		TriggerServerEvent("SetSafeContents", currentSafe.id,currentSafe.x, currentSafe.y, currentSafe.z, currentSafe.r, currentSafe.passcode, safeContents)
	end

	AddEventHandler("GetSafeContents", function(id,x,y,z,r,passcode,inventory)
		if passcode then
			currentSafe = {id=id,x=x,y=y,z=z,r=r,passcode=passcode,inventory=inventory }
			safeContents = inventory
			WarMenu.OpenMenu("safeinventory")
		end
	end)


	AddEventHandler("addSafe", function(id,x,y,z,r)
		table.insert(safes, {id = id,x = x,y = y,z = z,r = r} )
		updateAllSafes()
	end)
	
	AddEventHandler("addCustomSafe", function(id,x,y,z,r,model,blip)
		table.insert(safes, {id = id,x = x,y = y,z = z,r = r, model=model,blipicon=blip,visible=true} )
		updateAllSafes()
	end)

	AddEventHandler("removeSafe", function(id)
		for i,theSafe in pairs(safes) do
			if theSafe.id == id then
				if theSafe.obj then
					DeleteObject(theSafe.obj)
				end
				if theSafe.blip then
					RemoveBlip(theSafe.blip)
				end
				table.remove(safes,i)
			end
		end
	end)

end)

Citizen.CreateThread(function() -- this thread will loop our local table to see if we are near a safe and then add it to the interaction menu
	while true do
		Citizen.Wait(1)
		isNearSafe = false
		local pxx,pyy,pzz = table.unpack(GetEntityCoords(PlayerPedId(), true))
		for i,theSafe in pairs(safes) do
			if GetDistanceBetweenCoords(pxx,pyy,pzz, theSafe.x,theSafe.y,theSafe.z,true) < 2.5 then
				isNearSafe = true
				DrawMissonText("Press E to Open. ("..theSafe.id..")",100,true)
				if IsControlJustPressed(1, 51) then
					WarMenu.OpenMenu('safe')
				end
				if WarMenu.IsMenuOpened('Interaction') then
					if WarMenu.MenuButton('Safe', 'safe') then
						
					end
				elseif WarMenu.IsMenuOpened('safe') then
					if WarMenu.Button('Open') then
						if not theSafe.visible then
							local result, type = CreateAwaitedKeyboardInput("FMMC_KEY_TIP1", "Enter Passcode",4)
							if result then
								TriggerServerEvent("GetSafeContents", theSafe.id,result)
								safeContents = {}
								safeContents.count = {}
								for i,Consumable in ipairs(consumableItems) do
									safeContents.count[i] = 0.0
								end
							end
						else
							TriggerServerEvent("GetSafeContents", theSafe.id,"0000")
							safeContents = {}
							safeContents.count = {}
							for i,Consumable in ipairs(consumableItems) do
								safeContents.count[i] = 0.0
							end
						end
					elseif not theSafe.visible and WarMenu.Button('Destroy') then
						local result, type = CreateAwaitedKeyboardInput("FMMC_KEY_TIP1", "Enter Passcode ( WARNING: THIS WILL DESTROY EVERYTHING INSIDE! )",4)
						if result then
							TriggerServerEvent("removeSafe", theSafe.id,result)
						end
					end
				end
			end
		end
		if not isNearSafe then
			for i,menu in pairs(safemenus) do
				if WarMenu.IsMenuOpened(menu) then 
					WarMenu.CloseMenu(menu)
					if currentSafe.id then
						TriggerServerEvent("ExitSafe", currentSafe.id)
					end
					initiateSave(true)
				end
			end
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Wait(1000)
		local isInSafeMenu = false
		for i,menu in pairs(safemenus) do
			if WarMenu.IsMenuOpened(menu) then 
				isInSafeMenu = true
			end
		end
		
		if not isInSafeMenu and currentSafe.id then
			TriggerServerEvent("ExitSafe", currentSafe.id)
			currentSafe = {}
			initiateSave(true)
		end
	end
end)