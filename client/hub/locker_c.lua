

Citizen.CreateThread(function()
	WarMenu.CreateMenu('locker', 'Money Locker')
	WarMenu.SetSubTitle('locker', 'Money Locker')
	while true do
		if WarMenu.IsMenuOpened('locker') then
			WarMenu.SetSubTitle('locker', 'Current Balance: $'..locker_money)
			
			if WarMenu.Button('Deposit Money') then
				
				local maxMoney = 10000
				if consumableItems.count[17] > maxMoney then
					maxMoney = maxMoney-locker_money
				elseif consumableItems.count[17] < maxMoney then
					if (maxMoney-locker_money) < consumableItems.count[17] then
						maxMoney = maxMoney-locker_money
					else
						maxMoney = consumableItems.count[17]
					end
				end 

				-- new
				local result, type = CreateAwaitedKeyboardInput("DEPOSIT_MONEY", "Deposit Money ( Up to $"..maxMoney.." )",6)

				if not tonumber(result) then
					TriggerEvent("showNotification", "Please Enter a Correct Number.")
				elseif tonumber(result) > consumableItems.count[17] then
					TriggerEvent("showNotification", "You cannot deposit more than you have, silly!")
				elseif tonumber(result) > 10000 then
					TriggerEvent("showNotification", "You cannot deposit more than $10000!")
				elseif locker_money + tonumber(result) > 10000 then
					TriggerEvent("showNotification", "You cannot deposit more than $"..10000-locker_money.."!")
				elseif tonumber(result) < 1 then
					TriggerEvent("showNotification", "Nice Try, but you gotta try harder.")
				else
					result = math.round(tonumber(result))
					locker_money = locker_money+tonumber(result)
					consumableItems.count[17] = consumableItems.count[17]-result
					TriggerServerEvent("AddLegitimateMoney", -result)
					TriggerEvent("showNotification", "Successfully Deposited $"..result.."!")
					initiateSave(true)
				end
				
				
			elseif WarMenu.Button('Withdraw Money') then

				local result, type = CreateAwaitedKeyboardInput("WITHDRAW_MONEY", "Withdraw Money ( Up to $"..locker_money.." )",6)
				
				if not tonumber(result) then
					TriggerEvent("showNotification", "Please Enter a Correct Number.")
				elseif tonumber(result) > locker_money then
					TriggerEvent("showNotification", "You cannot withdraw more than $"..locker_money.."!")
				elseif tonumber(result) > 10000 then
					TriggerEvent("showNotification", "You cannot withdraw more than $"..locker_money.."!")
				elseif tonumber(result) < 1 then
					TriggerEvent("showNotification", "Well that just sounds plain silly.")
				else
					result = math.round(tonumber(result))
					locker_money = locker_money-result
					consumableItems.count[17] = consumableItems.count[17]+result
					TriggerServerEvent("AddLegitimateMoney", result)
					TriggerEvent("showNotification", "Successfully Withdrawed $"..result.."!")
					initiateSave(true)
				end
				
				
			end
			WarMenu.Display()
		end
		Citizen.Wait(0)
	end
end)