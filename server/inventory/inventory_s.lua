Citizen.CreateThread(function()
	RegisterServerEvent("s_killedZombie")
	AddEventHandler("s_killedZombie", function(player,weapon)
		if player and player ~= 0 and GetPlayerName(player) then
			TriggerClientEvent("c_killedZombie",player,weapon)
			
			Citizen.Trace(GetPlayerName(source).." Registered a ZOMBIE kill from "..GetPlayerName(player).."\n")
		end
	end)
end)


-- inventory management to prevent retard cheaters

inventories = {}

AddEventHandler("registerPlayerInv", function(client,inv)
	inventories[client] = inv
	Citizen.Trace("\nAdded Player Inventory to List\n")
end)

RegisterServerEvent("SetLegitimateMoney")
AddEventHandler("SetLegitimateMoney", function(newMoney)
	
	if not inventories[source] then
		TriggerEvent("SentryIO_Warning", "Player Inventory Data was Missing", "Player Tried Adding Legitimate Money but player didn't exist.")
		return
	end
	if newMoney == 0 then
		inventories[source].money=newMoney
	else
		TriggerEvent("RottenV:CheatingNotification", source,"Money Cheating Detected","Tried to set "..newMoney.." as their Legitimate Income!")
	end
end)

RegisterServerEvent("AddLegitimateMoney")
AddEventHandler("AddLegitimateMoney", function(addedMoney)
	if not inventories[source].money then
		TriggerEvent("SentryIO_Warning", "Player Inventory Data was Missing", "Player Tried Adding Legitimate Money but player didn't exist.")
		return
	end
	inventories[source].money=inventories[source].money+addedMoney
end)

RegisterServerEvent("BuyItem")
AddEventHandler("BuyItem", function(itemId,currentMoney,humanity)
	if not inventories[source].money then
		TriggerEvent("SentryIO_Warning", "Player Inventory Data was Missing", "Player Tried Adding Legitimate Money but player didn't exist.")
		return
	end
	local actualprice = math.floor(consumableItems[itemId].price*(1+calculateBonuses(humanity)/100))
	if currentMoney ~= inventories[source].money then
		TriggerEvent("RottenV:CheatingNotification", source,"Money Cheating Detected","Server-Side Money was "..inventories[source].money..", Client Money was "..currentMoney)
		TriggerClientEvent("SetCorrectedMoney", source, inventories[source].money-actualprice)
	end
	if inventories[source].money >= consumableItems[itemId].price then
		inventories[source].money=inventories[source].money-actualprice
	end
end)