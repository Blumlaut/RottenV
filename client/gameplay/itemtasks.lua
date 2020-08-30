Citizen.CreateThread(function()
	while true do
		Wait(1000)
		if LoadedPlayerData then
			if IsSeethroughActive() then
				if consumableItems[89].charge <= 0 then
					consumableItems[89].charge = 0
					TriggerEvent("showNotification", "There is no Battery Charge left.")
					SetSeethrough(false)
				elseif consumableItems[89].charge == 10 then
					TriggerEvent("showNotification", "My Infrared Goggles are running out of Charge.")
				end
				consumableItems[89].charge = math.round(consumableItems[89].charge-0.1,3)
			end
			if IsNightvisionActive() then
				if consumableItems[90].charge <= 0 then
					consumableItems[90].charge = 0
					TriggerEvent("showNotification", "There is no Battery Charge left.")
					SetSeethrough(false)
				elseif consumableItems[90].charge == 10 then
					TriggerEvent("showNotification", "My Night Vision Goggles are running out of Charge.")
				end
				consumableItems[90].charge = math.round(consumableItems[90].charge-0.1,3)
			end
		end
	end
end)