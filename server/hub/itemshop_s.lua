

-- default stock for all items was moved to the item definitions file.

itemStock = {}

weaponStock = {}


function stockShops(stockAll)
	for i,theStore in ipairs(Stores) do 
		if theStore.itemStock then
			for i,theConsumable in ipairs(consumableItems) do
				if stockAll or theStore.itemStock[i] == 0 and not theConsumable.isWeapon then
					if type(theConsumable.stockAmount) == "table" then
						theStore.itemStock[i] = math.random(theConsumable.stockAmount[1],theConsumable.stockAmount[2])
					elseif type(theConsumable.stockAmount) == "number" then
						theStore.itemStock[i] = theConsumable.stockAmount
					else
						theStore.itemStock[i] = 0
					end
				end
			end
		end
	end
	
	for i,theStore in ipairs(Stores) do
		if theStore.weaponStock then
			for i,theWeapon in ipairs(consumableItems) do
				if stockAll or weaponStock[i] == 0 and theWeapon.isWeapon then
					if type(theWeapon.stockAmount) == "table" then
						theStore.weaponStock[i] = math.random(theWeapon.stockAmount[1],theWeapon.stockAmount[2])
					elseif type(theWeapon.stockAmount) == "number" then
						theStore.weaponStock[i] = theWeapon.stockAmount
					else
						theStore.weaponStock[i] = 0
					end
				end
			end
		end
	end
end
stockShops(true)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(21600000)
		stockShops()
	end
end)

Citizen.CreateThread(function()

	
	RegisterServerEvent("requestHubStock")
	AddEventHandler("requestHubStock", function(shop,stockType)
		writeLog("\nPlayer Requested Hub Stock\n", 1)
		if stockType == "weapons" then
			TriggerClientEvent("recieveHubStock", source, stockType,Stores[shop].weaponStock)
		elseif stockType == "items" then
			TriggerClientEvent("recieveHubStock", source, stockType,Stores[shop].itemStock)
		end
	end)
	
	RegisterServerEvent("adjustHubStock")
	AddEventHandler("adjustHubStock", function(shop,stockType,item,count) -- we dont need seperate functions for this, just make sure we pass a negative or positive value to "count"
		writeLog("\nPlayer Adjusted Hub Stock\n", 1)
		if count > 1 or count < -1 then -- make sure the values actually make sense, otherwise we are most likely dealing with a cheeser
			TriggerEvent("RottenV:FuckCheaters", source, "Hub Alert!","Tried Adding "..count.." Items to the Hub")
			return
		end
		if stockType == "weapons" then
			Stores[shop].weaponStock[item] = Stores[shop].weaponStock[item]+count 
			if Stores[shop].weaponStock[item] <= 0 then
				Stores[shop].weaponStock[item] = 0
			end
		elseif stockType == "items" then
			Stores[shop].itemStock[item] = Stores[shop].itemStock[item]+count 
			if Stores[shop].itemStock[item] <= 0 then
				Stores[shop].itemStock[item] = 0
			end
		end
	end)
	
end)