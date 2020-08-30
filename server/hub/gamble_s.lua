
local WheelChances = {
	{type = "money", icon = 2, value = 500, chance = 50, label = "$%i"},
	{type = "money", icon = 2, value = 1500, chance = 45, label = "$%i"},
	{type = "money", icon = 2, value = 2000, chance = 40, label = "$%i"},
	{type = "money", icon = 2, value = 5000, chance = 20, label = "$%i"},
	{type = "money", icon = 2, value = 15000, chance = 6, label = "$%i"},
	{type = "money", icon = 2, value = 35000, chance = 2, label = "$%i"},
	{type = "money", icon = 2, value = 50000, chance = 0, label = "$%i"},
	{type = "money", icon = 2, value = 100000, chance = 0, label = "$%i"},
	{type = "armor", icon = 1,value = 100 ,chance = 50, label = "Armor Pack"},
	{type = "health", icon = 1,value = 100 ,chance = 50, label = "Health Recharge"},
	{type = "spin", icon = 5,value = 1,chance = 50, label = "%i Free Spin"},
	{type = "spin", icon = 5,value = 2,chance = 30, label = "%i Free Spin"},
	{type = "weapon", icon=4, value="randomWeapon", chance = 35, label = "%s" },
	{type = "item", icon=3, value=26, chance=4, label = "%s"},
	{type = "item", icon=3, value="randomItem", chance=45, label = "%s"},
	
}

local condensedChances = {}
for i,chance in ipairs(WheelChances) do
	for d = 1, chance.chance do
		table.insert(condensedChances, i)
	end
end 


Citizen.CreateThread(function()
	RegisterServerEvent("RequestWheelspinResult")
	AddEventHandler("RequestWheelspinResult", function()
		local segments = {}
		local rndchance = condensedChances[ math.random( #condensedChances ) ]
		local win = deepcopy(WheelChances[rndchance])
		local winningChance = math.random(0,10)
		for i=0, 10 do
			if i == winningChance then
				win.id = win.icon
				Citizen.Trace(win.label, win.value)
				if win.value == "randomWeapon" then
					local rndwp = weaponChances[ math.random(#weaponChances) ]
					win.value = consumableItems[rndwp].name
					win.hash = consumableItems[rndwp].hash
				elseif win.value == "randomItem" then
					local rndit = itemChances[ math.random( #itemChances ) ]
					win.value = consumableItems[rndit].name
					win.item = rndit
				elseif win.type == "item" and win.value ~= "randomItem" then 
					win.item = win.value
					win.value = consumableItems[win.item].name
				end
				table.insert(segments,win)
			else
				local gamble = WheelChances[ math.random( #WheelChances ) ]
				gamble.id = gamble.icon
				table.insert(segments,gamble)
			end
		end
	
	--[[	
	segments = {
		{id = 0, value = 0},
		{id = 1, value = 1},
		{id = 2, value = 2},
		{id = 3, value = 3},
		{id = 4, value = 4},
		{id = 5, value = 5},
		{id = 6, value = 6},
		{id = 7, value = 7},
		{id = 8, value = 8},
		{id = 9, value = 9},
	}
	]]
	-- result, winicon, wintext, type, segments
	TriggerClientEvent("RequestWheelspinResult", source, winningChance,win.icon,"You Won: "..string.format(win.label,win.value),0,segments)
	local win = nil
	local segments = nil
	end)
end)