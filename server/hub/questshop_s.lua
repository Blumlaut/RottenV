
dailies = {
	
	 {
		 {banditkills = 0, herokills = 0, zombiekills = 500, items = {}, withweapon = 453432689  },
		 {humanity = 100, loot = {{id = 17, count = 2000}}},
	 },
	 {
		 {banditkills = 0, herokills = 0, zombiekills = 500, items = {}, withweapon = 453432689  },
		 {humanity = 100, loot = {{id = 17, count = 2000}}},
	 },
	 {
		 {banditkills = 0, herokills = 0, zombiekills = 500, items = {}, withweapon = 453432689  },
		 {humanity = 100, loot = {{id = 17, count = 2000}}},
	 },
	
}
function GenerateDaily()
	local type = math.random(0,1) -- daily type
	local bonusitem = math.random(0,1)
	local bonusitemtype = math.random(0,1)
	local items = {}
	local killtype = math.random(1,4)
	local killamount = 0
	local useWeapon = math.random(0,1)
	local withweapon = nil
	local banditkills = 0
	local herokills = 0
	local zombiekills = 0
	local stopCamps = 0
	local humanity = 200
	local moneyreward = 2000
	
	
	
	if type == 0 then -- chose between items or kills
		local itemid = math.random(1,16)
		local itemcount = math.random(0,10)
		items = { {id = itemid, count = itemcount} }
		moneyreward = (consumableItems[itemid].price*itemcount)*1.3
	elseif type == 1 then
		local killtype = math.random(1,3)
		if killtype == 1 then
			banditkills = math.random(1,15)
			moneyreward = (banditkills*500)*0.6
		elseif killtype == 2 then
			herokills = math.random(1,15)
			moneyreward = (herokills*200)*0.6
			humanity = 50*herokills
		elseif killtype == 3 then
			zombiekills = math.random(10,100)
			moneyreward = (zombiekills*10)
		elseif killtype == 4 then
			stopCamps = math.random(1,4)
			moneyreward = (stopCamps*1300)
			useWeapon = 0
		end
		if useWeapon == 1 then
			randomWeapon = weaponChances[ math.random( #weaponChances ) ]
			withweapon = GetHashKey(consumableItems[randomWeapon].hash)
		end
	end
	local loot = {{id = 17, count = math.round(moneyreward)}}
	if bonusitem == 1 then
		if bonusitemtype == 0 then
			table.insert(loot, {id = weaponChances[math.random(1, #weaponChances)], count = math.random(10,60)})
		elseif bonusitemtype == 1 then
			local item = itemChances[ math.random( #itemChances ) ]
			if consumableItems[item].randomFinds[1] then
				table.insert(loot, {id = item, count = math.random( consumableItems[item].randomFinds[1], consumableItems[item].randomFinds[2]   )+0.0})
			else
				table.insert(loot, {id = item, count = math.random( 1, 1   )+0.0})
			end
		end
	end
	
	local daily = {
		finishrequirements = {withweapon = withweapon, banditkills = banditkills, herokills = herokills, zombiekills = zombiekills, stopCamps = stopCamps, items = items  },
		finishloot = {humanity = humanity, loot = loot},
	}
	
	return daily
end

dailies[1] = GenerateDaily()
dailies[2] = GenerateDaily()
dailies[3] = GenerateDaily()

RegisterServerEvent("requestDaily")
AddEventHandler("requestDaily", function()
	TriggerClientEvent("requestDaily", source, dailies)
end)