

local itemStock = {}

RegisterNetEvent("recieveHubStock")
AddEventHandler("recieveHubStock", function(stockType, stock)
	if stockType == "weapons" then
		-- do nothing
	else
		itemStock = stock
	end
end)

Citizen.CreateThread(function()
	
	WarMenu.CreateMenu('itemstore', 'Store')
	WarMenu.SetSubTitle('itemstore', 'Item Store')
	WarMenu.CreateSubMenu('buyitem', 'itemstore', 'The best items around!')
	WarMenu.CreateSubMenu('sellitem', 'itemstore', 'Sell your stuff!')
	while true do
		if WarMenu.IsMenuOpened('itemstore') then
			
			if WarMenu.MenuButton('Purchase Items', 'buyitem') then
				itemStock = {} -- clear itemstock table so we can check if it's filled later
				TriggerServerEvent("requestHubStock", CurrentStore, "items")
				
			elseif WarMenu.MenuButton('Sell Items', 'sellitem') then
			end
			WarMenu.Display()
			
		elseif WarMenu.IsMenuOpened('buyitem') then
			for item,Consumable in ipairs(consumableItems) do
				if Consumable.price and itemStock[1] and itemStock[item] > 0 and not Consumable.isWeapon and WarMenu.Button(Consumable.name, "$"..math.floor(Consumable.price*(1+calculateBonuses(humanity)/100)).." x"..itemStock[item]) then
					local cPrice = math.floor(Consumable.price*(1+calculateBonuses(humanity)/100))
					local money = consumableItems.count[17]
					if cPrice <= money then
						TriggerServerEvent("BuyItem", item,consumableItems.count[17],humanity)
						consumableItems.count[17] = math.round(money-cPrice)
						consumableItems.count[item] = consumableItems.count[item] + 1
						TriggerServerEvent("adjustHubStock", CurrentStore, "items", item, -1 )
						TriggerEvent('showNotification', "Successfully purchased:~n~Item: ~g~"..Consumable.name.."~s~~n~For: ~r~$"..cPrice.."~n~~s~You now have: ~y~"..math.floor(consumableItems.count[item]))
						TriggerServerEvent("requestHubStock", CurrentStore,"items")
					else
						TriggerEvent('showNotification', "Cannot purchase:~n~Item: ~g~"..Consumable.name.."~s~~n~Missing: ~r~$"..cPrice-money)
					end
				end
			end
			WarMenu.Display()
			
		elseif WarMenu.IsMenuOpened('sellitem') then
			for item,Consumable in ipairs(consumableItems) do
				if Consumable.price and consumableItems.count[item] > 0.0 and not Consumable.isWeapon and WarMenu.Button(Consumable.name, "$"..math.floor(Consumable.price * (Consumable.sellloss or 0.35)).." x"..math.floor(consumableItems.count[item])) then
					local Percentage = math.floor(Consumable.price * (Consumable.sellloss or 0.35))
					local money = consumableItems.count[17]
					if consumableItems.count[item] >= 1 then
						consumableItems.count[item] = consumableItems.count[item] - 1
						TriggerServerEvent("adjustHubStock", CurrentStore,"items", item, 1 )
						consumableItems.count[17] = math.round(money+Percentage)
						TriggerServerEvent("AddLegitimateMoney", Percentage)
						TriggerEvent('showNotification', "Successfully sold:~n~Item: "..Consumable.name.."~s~~n~For: ~g~$"..Percentage)
					else
						TriggerEvent('showNotification', "Cannot Sell:~n~Item: ~r~"..Consumable.name.."~s~~n~Missing: ~y~"..math.floor(consumableItems.count[item]))
					end
				end
			end
			WarMenu.Display()
		end
		
		Citizen.Wait(0)
	end
end)