function IfTrueDraw(var, iftrue, iffalse)
	if var then
		return iftrue
	else
		return iffalse
	end
end


local weaponStock = {}

RegisterNetEvent("recieveHubStock")
AddEventHandler("recieveHubStock", function(stockType, stock)
	if stockType == "weapons" then
		weaponStock = stock
	end
end)

Citizen.CreateThread(function()
	
	WarMenu.CreateMenu('wepstore', 'Weapon Store')
	WarMenu.SetSubTitle('wepstore', 'Item Store')
	WarMenu.CreateSubMenu('buywep', 'wepstore', 'The best weapons around!')
	WarMenu.CreateSubMenu('buyattach', 'wepstore', 'Find your Combination!')
	WarMenu.CreateSubMenu('sellwep', 'wepstore', 'Sell your stuff!')
	while true do
		if WarMenu.IsMenuOpened('wepstore') then
			if WarMenu.MenuButton('Purchase Items', 'buywep') then
				weaponStock = {} -- clear itemstock table so we can check if it's filled later
				TriggerServerEvent("requestHubStock", CurrentStore,"weapons")
				
			elseif WarMenu.MenuButton('Buy Attachments', 'buyattach') then
				
			elseif WarMenu.MenuButton('Sell Items', 'sellwep') then
				
			end
			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('buywep') then
			for item,Weapon in ipairs(consumableItems) do
				if Weapon.isWeapon and Weapon.price then
					local AlreadyOwned = HasPedGotWeapon(PlayerPedId(),GetHashKey(Weapon.hash),false)
					local ExtraText = IfTrueDraw(AlreadyOwned, " ~g~[OWNED]", "x%s")
					local AmmoPrice = math.floor(Weapon.price * (0.25 + (calculateAmmoBonuses(humanity)/100) ))
					local WeaponPrice = math.floor(Weapon.price * (1+(calculateBonuses(humanity)/100) ))
					local Price = IfTrueDraw(AlreadyOwned and Weapon.hasammo, "Ammo: $"..AmmoPrice, "$"..WeaponPrice)
					if weaponStock[item] and weaponStock[item] > 0 and WarMenu.Button(Weapon.name, Price.. string.format(ExtraText, weaponStock[item])) then
						local money = consumableItems.count[17]
						if WeaponPrice <= money and not AlreadyOwned then
							TriggerEvent('showNotification', "Successfully purchased:~n~Weapon: ~g~"..Weapon.name.."~s~~n~For: ~r~$"..WeaponPrice)
							TriggerServerEvent("BuyItem", item,consumableItems.count[17],humanity)
							consumableItems.count[17] = math.round(money-WeaponPrice)
							consumableItems.count[item] = GetMaxAmmoInClip(PlayerPedId(), Weapon.hash, false)
							TriggerServerEvent("adjustHubStock", CurrentStore,"weapons", item, -1 )
							GiveWeaponToPed(PlayerPedId(), GetHashKey(Weapon.hash), GetMaxAmmoInClip(PlayerPedId(), Weapon.hash, false), false, false)
							TriggerServerEvent("requestHubStock", CurrentStore,"weapons")
						elseif WeaponPrice >= money and not AlreadyOwned then
							TriggerEvent('showNotification', "Cannot purchase:~n~Weapon: ~g~"..Weapon.name.."~s~~n~Missing: ~r~$"..WeaponPrice-money)
						end
						-- Ammo purchasing (Yes, its a different statement, BuuuUuuUut it looked nicer!) --
						local HasAmmo, MaxAmmo = GetMaxAmmo(PlayerPedId(), Weapon.hash, MaxAmmo)
						local CurAmmo = GetAmmoInPedWeapon(PlayerPedId(), Weapon.hash)
						if Weapon.price and AmmoPrice <= money and CurAmmo < MaxAmmo and Weapon.hasammo and AlreadyOwned then
							TriggerEvent('showNotification', "Successfully purchased:~n~Ammo For: ~g~"..Weapon.name.."~s~~n~For: ~r~$"..AmmoPrice)
							consumableItems.count[17] = math.round(money-AmmoPrice)
							TriggerServerEvent("AddLegitimateMoney", -AmmoPrice)
							consumableItems.count[item] = GetAmmoInPedWeapon(PlayerPedId(), Weapon.hash)+GetMaxAmmoInClip(PlayerPedId(), Weapon.hash, false)
							AddAmmoToPed(PlayerPedId(), Weapon.hash, GetMaxAmmoInClip(PlayerPedId(), Weapon.hash, false))
						elseif AmmoPrice >= money and AlreadyOwned then
							TriggerEvent('showNotification', "Cannot purchase:~n~Ammo For: ~g~"..Weapon.name.."~s~~n~Missing: ~r~$"..AmmoPrice)
						elseif CurAmmo == MaxAmmo and Weapon.hasammo and AlreadyOwned then
							TriggerEvent('showNotification', "Cannot purchase:~n~Ammo For: ~g~"..Weapon.name.."~s~~n~Ammo already ~r~Full!")
						end
					end
				end
			end
			WarMenu.Display()
			
		elseif WarMenu.IsMenuOpened('buyattach') then
			local dh,cw = GetCurrentPedWeapon(PlayerPedId(), "lol meme")
			for i,attachment in ipairs(weaponComponents) do
				if attachment.price then
					local AlreadyOwned = HasPedGotWeaponComponent(PlayerPedId(), cw, attachment.hash)
					local ExtraText = IfTrueDraw(AlreadyOwned, " ~g~[OWNED] ~c~$%s", "$%s")
					local ItemPrice = math.floor(attachment.price * (1+(calculateBonuses(humanity)/100) ))
					if dh and attachment.price and DoesWeaponTakeWeaponComponent(cw, attachment.hash) and WarMenu.Button(attachment.name, string.format(ExtraText, tostring(ItemPrice))) then
						local money = consumableItems.count[17]
						if HasPedGotWeaponComponent(PlayerPedId(), cw, attachment.hash) then 
							RemoveWeaponComponentFromPed(PlayerPedId(), cw, attachment.hash)
							local Percentage = math.floor(attachment.price * 5 / 10)
							consumableItems.count[17] = math.round(money+Percentage)
							TriggerServerEvent("AddLegitimateMoney", Percentage)
							TriggerEvent('showNotification', "Successfully sold:~n~Attachment: ~r~"..attachment.name.."~s~~n~For: ~g~$"..Percentage)
						elseif ItemPrice <= money and not HasPedGotWeaponComponent(PlayerPedId(), cw, attachment.hash) then
							GiveWeaponComponentToPed(PlayerPedId(), cw, attachment.hash)
							consumableItems.count[17] = consumableItems.count[17]-math.round(ItemPrice)
							TriggerServerEvent("AddLegitimateMoney", -math.round(ItemPrice))
							TriggerEvent('showNotification', "Successfully purchased:~n~Attachment: ~g~"..attachment.name.."~s~~n~For: ~r~$"..ItemPrice)
						else
							TriggerEvent('showNotification', "Cannot purchase:~n~Attachment: ~g~"..attachment.name.."~s~~n~Missing: ~r~$"..ItemPrice-money)
						end
					end
				end
			end
			
			WarMenu.Display()
					
		elseif WarMenu.IsMenuOpened('sellwep') then
			for item,Weapon in ipairs(consumableItems) do
				if Weapon.isWeapon and Weapon.price and HasPedGotWeapon(PlayerPedId(),GetHashKey(Weapon.hash),false) then
					local Percentage = math.floor(Weapon.price * 5 / 10)
					if Weapon.price and WarMenu.Button(Weapon.name, "$"..Percentage) then
						local money = consumableItems.count[17]
						RemoveWeaponFromPed(PlayerPedId(), Weapon.hash)
						consumableItems.count[item] = 0
						TriggerEvent('showNotification', "Successfully sold:~n~Weapon: ~r~"..Weapon.name.."~s~~n~For: ~g~$"..Percentage)
						TriggerServerEvent("adjustHubStock", CurrentStore,"weapons", item, 1 )
						consumableItems.count[17] = math.round(money+Percentage)
						TriggerServerEvent("AddLegitimateMoney", Percentage)
					end
				end
			end
			WarMenu.Display()
		end
			
		
		Citizen.Wait(0)
	end
end)