RegisterNetEvent("SquadCreated")
RegisterNetEvent("SquadMemberJoined")
RegisterNetEvent("SquadMemberLeft")
RegisterNetEvent("LeftSquad")
RegisterNetEvent("JoinedSquad")
RegisterNetEvent("addSquadAdmin")
rd = false	 -- KEEP THIS FALSE, OTHERWISE DEBUG FEATURES WILL BE ENABLED

helpTexts = {
	{"Finding Food and Weapons", "Finding Loot is the most important thing in the post-apocalyptic San Andreas, you can find items by their glowing area, what you find is random"},
	{"Vehicles", "Vehicles are scattered around the world, you can repair them using repair kits, these kits can be found or bought in the hubs"},
	{"Zombies", "Zombies are infected people, out to eat you, they can hear/see almost as good as normal people, make sure to stay quiet around them."},
	{"Using the Inventory", "The Inventory is separated into two categories, 'useables' and 'consumables'.", "You can eat/use items by pressing enter when the item is selected and choosing 'Consume' or 'Use'"},
	{"Squads","Squads is an easy way to join your friends, enter a name, press enter and join a squad!", "If a squad by that name doesn't exist we will create one for you, other players can join if you give them your squad name."},
	{"The Hubs", "Hubs are Safezones scattered around the World in which players can trade items with Traders or other players.", "Each Hub has it's own inventory, you can sell or buy both weapons and items there, look for the icons on the map!"},
	{"CB Radio and Ingame Chat", "Chat works by CB Radio, if you have a CB Radio you can select a channel ( default is AM9 ) and Chat with people on the same frequency.", "CB Radio also has Limited Range which can be increased by using better Radios", "You can also use Local Chat which works for a small distance by using the G and H Keys."},
	{"Safes and Passcodes","Safes are created by players who also define the passcodes, you can find or buy safes","You can also try guessing the Safe Password, however, that may take a while","Safes unlock after 6 days of Inactivity and get deleted after 7."},
	{"Infection","If you are infected you will see a little icon over your Blood Icon, that will cause you to eventually lose control of your body","You will need to find antibiotics to heal yourself."}
}




local weaponTint = 0
local maxTint = 7
curSquadMembers = {}

bannedSquads = {}
squadAdmin = false

local playersDB = {}
for i=0, 255 do
	playersDB[i] = {}
end

AddEventHandler("SquadCreated", function(squadName)
	curSquadMembers = {}
	TriggerEvent("showNotification", "~g~"..squadName.."~w~ has been created!")
	Citizen.Trace("\ncreated new squad\n")
	--table.insert( curSquadMembers,GetPlayerServerId(PlayerId()))
	UpdateSquadMembers()
end)

AddEventHandler("JoinedSquad", function(members,squadName,admin)
	curSquadMembers = {}
	TriggerEvent("showNotification", "You joined ~g~"..squadName.."~w~!")
	Citizen.Trace("\njoined a new squad\n")
	AddRichPresence("Just joined a Squad")
	for i,theMember in ipairs(members) do
		table.insert(curSquadMembers,theMember.id)
	end
	if admin then
		squadAdmin = true
	else
		squadAdmin = false
	end
	UpdateSquadMembers()
end)

AddEventHandler("LeftSquad", function(squadName,reason,banned)
	curSquadMembers = {}
	if not reason then
		TriggerEvent("showNotification", "You left ~g~"..squadName.."~w~!")
	elseif reason and not banned then 
		TriggerEvent("showNotification", "You were removed from ~g~"..squadName.."~w~!")
	elseif reason and banned then 
		TriggerEvent("showNotification", "You were banned from ~g~"..squadName.."~w~!")
	end
	if banned then 
		table.insert(bannedSquads,squadName)
	end
	Citizen.Trace("\nwe are leaving this squad\n")
	AddRichPresence("Is now a Lone Wolf")
	UpdateSquadMembers()
	squadAdmin = false
end)

AddEventHandler("SquadMemberLeft", function(memberId,memberName,reason)
	local found = false
	for i,theTeammate in ipairs(curSquadMembers) do
		if theTeammate == memberId then
			found = true
			table.remove(curSquadMembers, i)
			if not reason then
				TriggerEvent("showNotification", "~g~"..memberName.."~w~ was removed from your Squad!")
			else 
				TriggerEvent("showNotification", "~g~"..memberName.."~w~ left your Squad!")
			end
		end
	end
	if not found then Citizen.Trace("\nsquad member left but we couldn't find him in our member list\n") else Citizen.Trace("\nplayer left us and was removed\n") end
	UpdateSquadMembers()
end)

AddEventHandler("SquadMemberJoined", function(PlayerName,playerid)
	if PlayerId() ~= GetPlayerFromServerId(playerid) then
		TriggerEvent("showNotification", "~g~"..PlayerName.."~w~ joined your Squad!")
		Citizen.Trace("\nsomeone joined our squad\n")
		table.insert(curSquadMembers, playerid)
		UpdateSquadMembers()
	end
end)

Citizen.CreateThread(function()
	function UpdateSquadMembers()
		ptable = GetPlayers()
		for id, Player in ipairs(ptable) do
			isTeamMate = false
			for i,theTeammate in ipairs(curSquadMembers) do
				if Player == GetPlayerFromServerId(theTeammate) then
					if playersDB[Player].blip then 
						RemoveBlip(playersDB[Player].blip) 
						playersDB[Player].blip = false
					end
					isTeamMate = true
					local ped = GetPlayerPed(GetPlayerFromServerId(theTeammate))
					local blip = AddBlipForEntity(ped)
					SetBlipSprite(blip, 1)
					ShowHeadingIndicatorOnBlip(blip, true)
					SetBlipNameToPlayerName(blip, Player)
					SetBlipScale(blip, 0.85)
					playersDB[Player].blip = blip
				end
			end
			if isTeamMate == false then
				if playersDB[Player].blip then
					RemoveBlip(playersDB[Player].blip)
					playersDB[Player].blip = false
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		for i,Player in ipairs(playersDB) do
			for id,theTeammate in ipairs(curSquadMembers) do
				if Player == GetPlayerFromServerId(theTeammate) then
					local veh = GetVehiclePedIsIn(playersDB[Player].ped, false)
					if playersDB[Player].ped ~= GetPlayerPed(playersDB[Player]) then
						RemoveBlip(RemoveBlip(playersDB[Player].blip))
						playersDB[Player].blip = false
						UpdateSquadMembers()
					end
					local blip = playersDB[Player].blip
					local blipSprite = GetBlipSprite(blip)
					if IsPedInAnyVehicle(playersDB[Player].ped, true) then
						local sprite = GetVehicleSpriteId(veh)
						
						if blipSprite ~= sprite then
							SetBlipSprite(blip, sprite)
							ShowHeadingIndicatorOnBlip(blip, true)
						end
					else
						if blipSprite ~= 1 then
							SetBlipSprite(blip, 1)
							ShowHeadingIndicatorOnBlip(blip, true)
						end
					end
				end
			end
		end
	end
end)


Citizen.CreateThread( function()
	while true do
		local playerPed = PlayerPedId()
		local veh = GetVehiclePedIsUsing(playerPed)
		if FreezeEngine and veh ~= 0 then
			SetVehicleEngineOn(veh,false,true,false)
		elseif KeepEngineOn and veh ~= 0 then
			SetVehicleEngineOn(veh,true,true,false)
		end
		Citizen.Wait(0)
	end
end)

function UseUsable(property)
	
	if property == "vehiclerepair" then
		local ped = PlayerPedId()
		local veh = GetVehiclePedIsIn( ped,false)
		if veh == 0 or not veh then
			TriggerEvent("showNotification", "You need to be in a vehicle to use this kit")
			return false
		else
			usingVehicleUsable = true
			SetVehicleEngineOn(veh,false,true,false)
			TriggerEvent("showNotification", "You started to repair the vehicle, this can take a bit")
			SetPedAllowVehiclesOverride(ped,false)
			SetVehicleDoorsLocked(veh,4)
			local tv = KeepEngineOn
			KeepEngineOn = false
			FreezeEngine = true
			TriggerEvent('pogressBar:drawBar', 10000, 'Repairing Engine...')
			Wait(10000)
			FreezeEngine = false
			KeepEngineOn = tv
			usingVehicleUsable = false
			if veh and PlayerPedId() == ped then
				TriggerEvent("showNotification", "Engine was Fixed!")
				SetEntityHealth(veh,1000.0)
				SetVehicleEngineHealth(veh,1000.0)
				SetVehiclePetrolTankHealth(veh,1000.0)
				SetVehicleDoorsLocked(veh,0)
				SetPedAllowVehiclesOverride(PlayerPedId(),true)
				SetVehicleEngineOn(veh,true,true,false)
			else
				SetVehicleDoorsLocked(veh,0)
				SetPedAllowVehiclesOverride(PlayerPedId(),true)
				SetVehicleEngineOn(veh,true,true,false)
				return false
			end
		end
		
	elseif property == "tyrerepair" then
		local ped = PlayerPedId()
		local veh = GetVehiclePedIsIn(ped,false)
		if veh == 0 or not veh then
			TriggerEvent("showNotification", "You need to be in a vehicle to use this kit")
			return false
		else
			usingVehicleUsable = true
			SetVehicleEngineOn(veh,false,true,false)
			TriggerEvent("showNotification", "You started to repair the vehicle, this can take a bit")
			SetPedAllowVehiclesOverride(ped,false)
			SetVehicleDoorsLocked(veh,4)
			local tv = KeepEngineOn
			KeepEngineOn = false
			FreezeEngine = true
			TriggerEvent('pogressBar:drawBar', 10000, 'Repairing Tyres...')
			Wait(10000)
			FreezeEngine = false
			KeepEngineOn = tv
			usingVehicleUsable = false
			if GetVehiclePedIsIn(PlayerPedId(),false) and PlayerPedId() == ped then
				TriggerEvent("showNotification", "Tyres were Fixed!")
				for i=0, 5 do
					SetVehicleTyreFixed(veh,i)
				end
				SetPedAllowVehiclesOverride(PlayerPedId(),true)
				SetVehicleEngineOn(veh,true,true,false)
				SetVehicleDoorsLocked(veh,0)
			else
				SetVehicleDoorsLocked(veh,0)
				SetPedAllowVehiclesOverride(PlayerPedId(),true)
				SetVehicleEngineOn(veh,true,true,false)
				return false
			end
		end
		
	elseif property == "vehiclerefuel" then
		local ped = PlayerPedId()
		local veh = GetVehiclePedIsIn(ped,false)
		if veh == 0 or not veh then
			TriggerEvent("showNotification", "You need to be in a vehicle to use this.")
			return false
		else
			usingVehicleUsable = true
			SetVehicleEngineOn(veh,false,true,false)
			TriggerEvent("showNotification", "You started to refuel the vehicle.")
			SetPedAllowVehiclesOverride(ped,false)
			SetVehicleDoorsLocked(veh,4)
			local tv = KeepEngineOn
			KeepEngineOn = false
			FreezeEngine = true
			TriggerEvent('pogressBar:drawBar', 8000, 'Fuelling Up...')
			Wait(8000)
			FreezeEngine = false
			KeepEngineOn = tv
			usingVehicleUsable = false
			if GetVehiclePedIsIn(PlayerPedId(),false) and PlayerPedId() == ped then
				TriggerEvent("showNotification", "Vehicle Refueled!")
				exports.frfuel:setFuel(GetVehicleHandlingFloat(veh, "CHandlingData", "fPetrolTankVolume"))
				
				SetPedAllowVehiclesOverride(PlayerPedId(),true)
				SetVehicleEngineOn(veh,true,true,false)
				SetVehicleDoorsLocked(veh,0)
			else
				SetVehicleDoorsLocked(veh,0)
				SetPedAllowVehiclesOverride(PlayerPedId(),true)
				SetVehicleEngineOn(veh,true,true,false)
				return false
			end
		end
		
	elseif property == "cureinfection" then
		if infected then
			infected = false
			TriggerEvent("showNotification", "You are no longer infected!!")
			return true
		else
			TriggerEvent("showNotification", "I don't feel sick!")
			return false
		end
		
	elseif property == "signalAirdrop" then
		return DoDropAnim()
		
	elseif property == "flipcoin" then
		local money = consumableItems.count[17]
		if money > 0 then
			local result = math.random(0,1)
			TriggerEvent("showNotification", "Flipped a Coin, result is...")
			Wait(100)
			if result == 0 then
				TriggerEvent("showNotification", "Heads!")
			elseif result == 1 then
				TriggerEvent("showNotification", "Tails!")
			else
				TriggerEvent("showNotification", "You dropped your coin, oh well, you will find another.")
			end
			return true
		end
	elseif property == "placeSafe" then
		if isPlayerInSafezone then
			TriggerEvent("showNotification", "You can't place a safe here.")
			return false
		end
		local px,py,pz = table.unpack( GetEntityCoords(PlayerPedId(), true) )
		local _,_,pr = table.unpack(GetEntityRotation(PlayerPedId(),2))
		local result, type = CreateAwaitedKeyboardInput("FMMC_KEY_TIP1", "Enter Passcode",4)
		if not result or result == 0 or result == "" then 
			TriggerEvent("showNotification", "Safe Placing Cancelled.")
			return false 
		end
		if result then
			local sx,sy,sz = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,1.0,0.0))
			local _,sz = GetGroundZFor_3dCoord(sx+.0, sy+.0, 999.0, 0)
			local safeItems = {}
			TriggerServerEvent("createSafe", sx,sy,sz,pr,result,safeItems)
		end
		return true
		
	elseif property == "useCrate" then
		if consumableItems.count[25] > 0 and consumableItems.count[26] > 0 then
			consumableItems.count[26]=consumableItems.count[26]-1
			local pickupString = "You Found:"
			local randomLootCount = math.random(1,4)
			for i=1,randomLootCount do
				local item = itemChances[ math.random( #itemChances ) ]
				local PickupCounts = math.round(math.random( consumableItems[item].randomFinds[1], consumableItems[item].randomFinds[2]   ))
				if PickupCounts > 1 then
					pickupString = pickupString.."\n~g~" .. PickupCounts .." " .. (consumableItems[item].multipleCase or consumableItems[item].name)
				elseif PickupCounts == 1 then
					pickupString = pickupString.."\n~g~" .. PickupCounts .." " .. consumableItems[item].name
				end
				consumableItems.count[item] = consumableItems.count[item] + randomLootCount
				if item == 17 then
					TriggerServerEvent("AddLegitimateMoney", randomLootCount)
				end
				Wait(1)
			end
			
			for i = 0, #pickupString,100 do
				TriggerEvent('showNotification', string.sub(pickupString,i,i+99))
			end
			return true
		elseif consumableItems.count[26] == 0 or consumableItems.count[25] == 0 then
			TriggerEvent("showNotification", "I don't have a key for this.")
			return false
		end
		
	elseif property == "useKey" then
		if consumableItems.count[25] > 0 and consumableItems.count[26] > 0 then
			consumableItems.count[25]=consumableItems.count[25]-1
			local pickupString = "You Found:"
			local randomLootCount = math.random(1,4)
			for i=1,randomLootCount do
				local item = itemChances[ math.random( #itemChances ) ]
				local PickupCounts = math.round(math.random( consumableItems[item].randomFinds[1], consumableItems[item].randomFinds[2]   ))
				if PickupCounts > 1 then
					pickupString = pickupString.."\n~g~" .. PickupCounts .." " .. consumableItems[item].multipleCase
				elseif PickupCounts == 1 then
					pickupString = pickupString.."\n~g~" .. PickupCounts .." " .. consumableItems[item].name
				end
				consumableItems.count[item] = consumableItems.count[item] + randomLootCount
				if item == 17 then
					TriggerServerEvent("AddLegitimateMoney", randomLootCount)
				end
				Wait(1)
			end
			
			for i = 0, #pickupString,100 do
				TriggerEvent('showNotification', string.sub(pickupString,i,i+99))
			end
			return true
		elseif consumableItems.count[26] == 0 or consumableItems.count[25] == 0 then
			TriggerEvent("showNotification", "I need something to use this key on.")
			return false
		end
	elseif property == "useBinos" then
		if not binoculars then
			binoculars = not binoculars
			if not IsPedSittingInAnyVehicle( lPed ) then
				Citizen.CreateThread(function()
					TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_BINOCULARS", 0, 1)
				end)
			end
		else
			StopBinocularAnim()
		end
		return true
		
	elseif property == "useIR" then
		if consumableItems[89].charge <= 0 then
			TriggerEvent("showNotification", "There is no Battery Charge left.")
		else
			SetNightvision(false)
			SetSeethrough(not IsSeethroughActive())
		end
		return true
		
	elseif property == "useNV" then
		if consumableItems[90].charge <= 0 then
			TriggerEvent("showNotification", "There is no Battery Charge left.")
		else
			SetNightvision(not IsNightvisionActive())
			SetSeethrough(false)
		end
		return true
	elseif property == "useAAAwithItem" then
		WarMenu.OpenMenu('useAAAwithItem')
		local selectedOption = false
		while not selectedOption do
			if WarMenu.IsMenuOpened('useAAAwithItem') then
				for i,consumableItem in ipairs(consumableItems) do
					if consumableItems[i].requiredbatteries and consumableItems.count[i] > 0 then
						if WarMenu.Button(consumableItems[i].name) then
							if consumableItems[i].charge+(100/consumableItems[i].requiredbatteries) > 100 then
								consumableItems[i].charge = 100
							else
								consumableItems[i].charge = consumableItems[i].charge+(100/consumableItems[i].requiredbatteries)
							end
							TriggerEvent("showNotification", "Swapped One Battery in "..consumableItems[i].name.." for a new one, charge is now "..consumableItems[i].charge.."%")
							selectedOption = true
						end
					end
				end
				WarMenu.Display()
			else
				selectedOption = true
			end
			Wait(1)
		end
		
	elseif property == "useCBAmateur" then
		TriggerEvent("showNotification", "Press 'H' To Manage the CB Radio")
		return false
	elseif property == "useWand" then
		TriggerEvent("showNotification", "I tried performing a magic trick, the Wand started vibrating, this thing is useless, i'll throw it away.")
		return true
	end
	
	
	
	return true
end

function GetVehicleSpriteId(veh)
	vehClass = GetVehicleClass(veh)
	vehModel = GetEntityModel(veh)
	local sprite = 1
	
	if(vehClass == 8 or vehClass == 13)then
		sprite = 226 -- Bikes
	elseif(vehClass == 14)then
		sprite = 427 -- Boat
	elseif(vehClass == 15)then
		sprite = 422 -- Jet
	elseif(vehClass == 16)then
		sprite = 423 -- Planes
	elseif(vehClass == 19)then
		sprite = 421 -- Military
	else
		sprite = 225 -- Car
	end
	
	-- Model Specific Icons override Class.
	if(vehModel == GetHashKey("besra") or vehModel == GetHashKey("hydra") or vehModel == GetHashKey("lazer"))then
		sprite = 424
	elseif(vehModel == GetHashKey("insurgent") or vehModel == GetHashKey("insurgent2") or vehModel == GetHashKey("limo2"))then
		sprite = 426
	elseif(vehModel == GetHashKey("rhino"))then
		sprite = 421
	end
	
	return sprite
end

Citizen.CreateThread(function()
	local currentItemIndex = 1
	local selectedItemIndex = 1
	local lockcurrentItemIndex = 1
	local lockselectedItemIndex = 1
	
	
	WarMenu.CreateMenu('useAAAwithItem', 'Use Battery')
	WarMenu.SetSubTitle('useAAAwithItem', 'Use Battery on..') 
	
	WarMenu.CreateMenu('useCBAmateur', 'CB Radio')
	WarMenu.SetSubTitle('useCBAmateur', 'CB Radio Menu') 
	
	WarMenu.CreateMenu('useCBEnth', 'CB Radio')
	WarMenu.SetSubTitle('useCBEnth', 'CB Radio Menu') 
	
	WarMenu.CreateMenu('useCBProf', 'CB Radio')
	WarMenu.SetSubTitle('useCBProf', 'CB Radio Menu') 
	
	WarMenu.CreateMenu('Interaction', 'Interaction Menu')
		
	
	WarMenu.CreateSubMenu('inventory', 'Interaction', 'Inventory')
		WarMenu.CreateSubMenu('consumables', 'inventory', 'Consumables')
		WarMenu.CreateSubMenu('useables', 'inventory', 'Useables')
		WarMenu.CreateSubMenu('weapons', 'inventory', 'Weapons')
		
	if rd then
		WarMenu.CreateSubMenu('debug', 'Interaction', 'Debug Menu')
	end
	
	WarMenu.CreateSubMenu('squad', 'Interaction', 'Squad Menu')
		WarMenu.CreateSubMenu('manageSquad', 'squad', "Manage Squad")
			WarMenu.CreateSubMenu('addsquadadmin', 'squad', "Add Squad Admin")
			WarMenu.CreateSubMenu('kickSquadMember', 'squad', "Kick Squad Member")
			WarMenu.CreateSubMenu('banSquadMember', 'squad', "Ban Squad Member")
	
	WarMenu.CreateSubMenu('safe', 'Interaction', 'Safe')
		WarMenu.CreateSubMenu('safeinventory', 'safe', 'Safe Inventory')
			WarMenu.CreateSubMenu('safeadditem', 'safeinventory', 'Store Item')
			WarMenu.CreateSubMenu('safetakeitem', 'safeinventory', 'Take Item')
	
	WarMenu.CreateSubMenu('helpmenu', 'Interaction', 'Survival Guide')
	
	WarMenu.CreateSubMenu('vehiclemenu', 'Interaction', 'Vehicle Menu')
	
	WarMenu.CreateSubMenu('kys', 'Interaction', "R.I.P.")
	
	for i,Consumable in ipairs(consumableItems) do
		if consumableItems[i].consumable then
			WarMenu.CreateSubMenu(Consumable.name, 'consumables', Consumable.name)
		else
			WarMenu.CreateSubMenu(Consumable.name, 'useables', Consumable.name)
		end
	end
	
	while true do
		if IsPlayerDead(PlayerId()) then
			WarMenu.CloseMenu()
		end
		if WarMenu.IsMenuOpened('Interaction') then
			if WarMenu.MenuButton('Inventory', 'inventory') then
				
			elseif WarMenu.MenuButton('Squad Menu', 'squad') then
				
			elseif WarMenu.MenuButton("Survival Guide", "helpmenu") then
				
			elseif DoesPlayerHaveCBRadio() and WarMenu.MenuButton("CB Radio", "useCBAmateur") then
				if VoiceType then
					cii_, sii_ = 1, 1
				else
					cii_, sii_ = 2, 2
				end
		

			elseif IsPedInAnyVehicle(PlayerPedId(), true) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() and WarMenu.MenuButton("Vehicle Menu", "vehiclemenu") then 
				
				
			elseif rd and WarMenu.MenuButton("Debug Menu", "debug") then
				
				
			end
			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('kys') then
			if WarMenu.Button('Yes') then
				TriggerEvent("Z:killplayer")
				WarMenu.CloseMenu()
			elseif WarMenu.MenuButton('No', 'Interaction') then
			end
			WarMenu.Display()
			
		elseif WarMenu.IsMenuOpened('helpmenu') then
			for i,theHelp in ipairs(helpTexts) do
				
				if WarMenu.Button(theHelp[1]) then
					for i,thetext in ipairs(theHelp) do
						if i>1 then
							TriggerEvent("chat:addMessage", { templateId = "defaultAlt", args = { thetext } })
						else
							TriggerEvent("chat:addMessage", { templateId = "defaultAlt", args = { "^2*****************"..thetext.."*****************" } })
						end
					end
				end
			end
			WarMenu.Display()
			
		elseif WarMenu.IsMenuOpened('vehiclemenu') then
			if usingVehicleUsable then
				WarMenu.CloseMenu()
				return
			end
			local items = {"On","Keep On","Off"}
			if WarMenu.ComboBox("Engine State", items, currentItemIndex, selectedItemIndex, function(currentIndex, selectedIndex)
				currentItemIndex = currentIndex
				selectedItemIndex = selectedIndex
				if currentItemIndex == 2 then
					SetVehicleEngineOn(GetVehiclePedIsUsing(PlayerPedId(), false), true, false, true)
					KeepEngineOn = true
					FreezeEngine = false
				elseif currentItemIndex == 1 then
					SetVehicleEngineOn(GetVehiclePedIsUsing(PlayerPedId(), false), true, false, true)
					KeepEngineOn = false
					FreezeEngine = false
				elseif currentItemIndex == 3 then
					SetVehicleEngineOn(GetVehiclePedIsUsing(PlayerPedId(), false), false, false, true)
					KeepEngineOn = false
					FreezeEngine = false
				end
			end) then
					-- nothing to do here
			end
	
			local items = {"Unlocked","Locked"}
			if WarMenu.ComboBox("Vehicle Locks", items, lockcurrentItemIndex, lockselectedItemIndex, function(currentIndex, selectedIndex)
				lockcurrentItemIndex = currentIndex
				lockselectedItemIndex = selectedIndex
				if lockcurrentItemIndex == 2 then
					SetVehicleDoorsLocked(GetVehiclePedIsIn(PlayerPedId(), false), 4)
				elseif lockcurrentItemIndex == 1 then
					SetVehicleDoorsLocked(GetVehiclePedIsIn(PlayerPedId(), false), 1)
				end
				end) then
					-- nothing to do here
			end
			
			
			WarMenu.Display()
			
		elseif WarMenu.IsMenuOpened('inventory') then
			if WarMenu.MenuButton('Consumables', 'consumables') then
			elseif WarMenu.MenuButton('Useables', 'useables') then
			elseif WarMenu.MenuButton('Weapons', 'weapons') then
			end
			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('consumables') then
			for i,Consumable in ipairs(consumableItems) do
				if consumableItems[i].consumable and consumableItems.count[i] > 0.0 then
					WarMenu.MenuButton(Consumable.name, Consumable.name, tostring(math.round(consumableItems.count[i])))
				end
			end
			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('useables') then
			for i,Consumable in ipairs(consumableItems) do
				if consumableItems.count[i] > 0.0 and consumableItems[i].consumable == false then
					WarMenu.MenuButton(Consumable.name, Consumable.name, tostring(math.round(consumableItems.count[i])))
				end
			end
			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('weapons') then
			for i,Consumable in ipairs(consumableItems) do
				if consumableItems.count[i] > 0.0 and consumableItems[i].isWeapon then
					if HasPedGotWeapon(PlayerPedId(), consumableItems[i].hash, false) then
						consumableItems.count[i] = GetAmmoInPedWeapon(PlayerPedId(), consumableItems[i].hash)
						WarMenu.MenuButton(Consumable.name, Consumable.name, tostring(math.round(consumableItems.count[i])))
					end
				end
			end
			WarMenu.Display()

		elseif WarMenu.IsMenuOpened('squad') then
			if WarMenu.Button('Join/Create Squad') then
				local result, type = CreateAwaitedKeyboardInput("FMMC_KEY_TIP12N", false,128 + 1)
				local banned = false
				if result then
					for i,squad in pairs(bannedSquads) do
						if result == squad then
							TriggerEvent("showNotification", "You cannot join this Squad.")
							banned = true
						end
					end
					if not banned then
						TriggerServerEvent("joinsquad", result, GetPlayerName(PlayerId()))
					end
				end
				
			
			
				
			elseif WarMenu.Button('Leave Squad') then
				TriggerServerEvent("leavesquad", GetPlayerName(PlayerId()))

			elseif squadAdmin and WarMenu.MenuButton('Kick Member', 'kickSquadMember') then
			elseif squadAdmin and WarMenu.MenuButton('Ban Member', 'banSquadMember') then		
			end
			WarMenu.Display()
		end
	
			if WarMenu.IsMenuOpened('kickSquadMember') then
				for i,member in pairs(curSquadMembers) do
					if WarMenu.Button(GetPlayerName(GetPlayerFromServerId(member))) then
						TriggerServerEvent("leavesquad", GetPlayerName(GetPlayerFromServerId(member)),true)
					end
				end
				WarMenu.Display()
			elseif WarMenu.IsMenuOpened('banSquadMember') then
				for i,member in pairs(curSquadMembers) do
					if WarMenu.Button(GetPlayerName(GetPlayerFromServerId(member))) then
						TriggerServerEvent("leavesquad", GetPlayerName(GetPlayerFromServerId(member)),true,true)
					end
				end
				WarMenu.Display()
			
		elseif WarMenu.IsMenuOpened('safe') then
			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('safeinventory') then
			if WarMenu.MenuButton('Store Item', 'safeadditem') then
			elseif WarMenu.MenuButton('Take Item', 'safetakeitem') then
			end
			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('safeadditem') then
			for i,Consumable in ipairs(consumableItems) do
				if consumableItems.count[i] > 0.0 then
					if WarMenu.Button(consumableItems[i].name, consumableItems.count[i]) then
						local result, type = CreateAwaitedKeyboardInput("ITEM_COUNT", "How many Items to put inside ( empty for all, max "..math.round(consumableItems.count[i]).." )?",65)
						if not result or result == "" then result = consumableItems.count[i] end
						if result and tonumber(result) and tonumber(result) > 0 and tonumber(result) <= consumableItems.count[i] then
							result = math.round(tonumber(result))
							print("add item result: "..result)
							if not safeContents[i] then safeContents[i] = {id = i, count = 0} end 
							safeContents[i].count = safeContents[i].count+result
							consumableItems.count[i] = math.round(consumableItems.count[i]-result)
							if consumableItems[i].isWeapon then
								local newammo = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(Consumable.hash))-result
								SetPedAmmo(PlayerPedId(), GetHashKey(Consumable.hash), math.round(newammo) )
								print("new ammo: "..newammo)
								if newammo == 0 then
									RemoveWeaponFromPed(PlayerPedId(), GetHashKey(Consumable.hash))
									print("taking weapon")
								else
									safeContents[i].ammoonly = true
									print("ammo only")
								end
							end
							if i == 17 then
								TriggerServerEvent("SetLegitimateMoney", 0)
							end
							SaveCurrentSafe()
							initiateSave(true)
						end
					end
				end
			end
			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('safetakeitem') then
			for i,Consumable in ipairs(consumableItems) do
				if safeContents[i] and safeContents[i].count > 0.0 then
					local itemname = consumableItems[i].name
					if consumableItems[i].isWeapon and safeContents[i].ammoonly and GetWeapontypeGroup(GetHashKey(Consumable.hash)) ~= 1548507267 then 
						itemname = consumableItems[i].name.." Ammo"
					end
					if WarMenu.Button(itemname, math.round(safeContents[i].count)) then
						if consumableItems[i].isWeapon and not safeContents[i].ammoonly then 
							if HasPedGotWeapon(PlayerPedId(), GetHashKey(Consumable.hash), false) then
								SetPedAmmo(PlayerPedId(), GetHashKey(Consumable.hash), GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(Consumable.hash))+safeContents[i].count)
							else
								GiveWeaponToPed(PlayerPedId(), GetHashKey(Consumable.hash), safeContents[i].count, false, false)
							end
							safeContents[i] = nil
							print("giving weapon from safe")
						else 
							local result, type = CreateAwaitedKeyboardInput("ITEM_COUNT", "How many Items to take ( empty for all, max "..math.round(safeContents[i].count).." )?",65)
							if not result or result == "" then result = math.round(safeContents[i].count) end
							if result and tonumber(result) and tonumber(result) > 0 and tonumber(result) <= safeContents[i].count then
								result = math.round(tonumber(result))
								print("take item result: "..result)
								consumableItems.count[i] = math.round(consumableItems.count[i]+result)
								if consumableItems[i].isWeapon and (not safeContents[i].ammoonly or GetWeapontypeGroup(GetHashKey(Consumable.hash)) == 1548507267) then
									GiveWeaponToPed(PlayerPedId(), GetHashKey(Consumable.hash), result, false, false)
									print("giving weapon from safe")
								elseif consumableItems[i].isWeapon and safeContents[i].ammoonly then
									SetPedAmmo(PlayerPedId(), GetHashKey(Consumable.hash), GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(Consumable.hash))+result)
									print("new ammo: "..GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(Consumable.hash))+result)
								end


								if i == 17 then
									TriggerServerEvent("AddLegitimateMoney", result)
								end
								if math.round(safeContents[i].count)-result == 0 then
									safeContents[i] = nil
								else 
									safeContents[i].count = math.round(safeContents[i].count)-result
								end
							end
						end
						SaveCurrentSafe()
					end
				end
			end
			WarMenu.Display()
			
			
			
			
			------------------------------------------------ DEBUG CODE --------------------------------------------------
		elseif rd and WarMenu.IsMenuOpened('debug') then
			if rd and WarMenu.Button("Set Hunger") then
				

				local result, type = CreateAwaitedKeyboardInput("FMMC_KEY_TIP12N", false,128 + 1)
				if result and tonumber(result) then
					DecorSetFloat(PlayerPedId(), "hunger", tonumber(result)+0.000)
				end
				
			elseif rd and WarMenu.Button("Set Thirst") then
				local result, type = CreateAwaitedKeyboardInput("FMMC_KEY_TIP12N", false,128 + 1)
				
				if result and tonumber(result) then
					DecorSetFloat(PlayerPedId(), "thirst", tonumber(result)+0.000)
				end
				
			elseif rd and WarMenu.Button("Set Humanity") then
				
				local result, type = CreateAwaitedKeyboardInput("FMMC_KEY_TIP12N", false,128 + 1)
				
				if result and tonumber(result) then
					humanity = tonumber(result)+0.000
				end
				
			elseif rd and WarMenu.Button("Set Health") then
				
				local result, type = CreateAwaitedKeyboardInput("FMMC_KEY_TIP12N", false,128 + 1)
				
				if result and tonumber(result) then
					SetEntityHealth(PlayerPedId(), tonumber(result)+0.000 )
				end
				
			elseif rd and WarMenu.Button("Give All Items") then
				for i,c in ipairs(consumableItems) do
					consumableItems.count[i] = 99.0
				end
			elseif rd and WarMenu.Button("Get ~g~Rich ~s~Quick!") then
				consumableItems.count[17] = 100000
			elseif rd and WarMenu.Button("Toggle Infection") then
				infected = not infected
			elseif rd and WarMenu.Button("Toggle Possession") then
				if possessed then
					unPossessPlayer(PlayerPedId())
				else
					PossessPlayer(PlayerPedId())
				end
			end
			WarMenu.Display()
			
		elseif IsControlJustReleased(0, 244) then --M by default
			if possessed then
				TriggerEvent("showNotification", "~r~I am unable to reach for my pocket.")
			else
				WarMenu.OpenMenu('Interaction')
			end
			collectgarbage()
		else
			local currentMenu = WarMenu.CurrentMenu()
			if currentMenu ~= nil then
				for item,Consumable in ipairs(consumableItems) do
					if currentMenu == Consumable.name then
						if consumableItems.count[item] > 0.0 then
							local title = "Use"
							if consumableItems[item].consumable then
								title = "Consume"
							end
							if not Consumable.isWeapon and WarMenu.Button(title, tostring(math.round(consumableItems.count[item]))) then
								if consumableItems[item].consumable then
									local cctext = "Consuming"
									if consumableItems[item].hunger < consumableItems[item].thirst then
										cctext = "Drinking"
									elseif consumableItems[item].hunger > consumableItems[item].thirst then
										cctext = "Eating"
									elseif consumableItems[item].health > consumableItems[item].thirst and consumableItems[item].health > consumableItems[item].hunger then
										cctext = "Using"
									end
									TriggerEvent('pogressBar:drawBar', consumableItems[item].interactionDelay or 3000, cctext.." "..Consumable.name, nil)
									Citizen.Wait(consumableItems[item].interactionDelay or 3000)
									DecorSetFloat(PlayerPedId(), "hunger", DecorGetFloat(PlayerPedId(),"hunger")+consumableItems[item].hunger)
									DecorSetFloat(PlayerPedId(), "thirst", DecorGetFloat(PlayerPedId(),"thirst")+consumableItems[item].thirst)
									
									local newhealth = GetEntityHealth(PlayerPedId()) + consumableItems[item].health
									if newhealth > 200 then
										SetEntityHealth(PlayerPedId(), 200.0)
									else
										SetEntityHealth(PlayerPedId(), newhealth)
									end
									
									used = nil
									if consumableItems[item].property then
										used = nil
										used = UseUsable( consumableItems[item].property )
										while used == nil do Citizen.Wait(0) end
									else
										used = true
									end
									if used and not consumableItems[item].infinite then
										consumableItems.count[item] = consumableItems.count[item]-1.0
										if item == 17 then
											TriggerServerEvent("AddLegitimateMoney", -1.0)
										end
									end
								else
									used = nil
									used = UseUsable( consumableItems[item].property )
									while used == nil do Citizen.Wait(0) end
									if used and not consumableItems[item].infinite then
										consumableItems.count[item] = consumableItems.count[item]-1.0
										if item == 17 then
											TriggerServerEvent("AddLegitimateMoney", -1.0)
										end
									end
								end
							end
							if Consumable.desc and WarMenu.Button("Inspect") then
								TriggerEvent("showNotification", Consumable.desc)
							end
							local items = {}
							for j=1,consumableItems.count[item] do
								table.insert(items, j)
							end
							if WarMenu.Button("Drop") then
								local result, type = CreateAwaitedKeyboardInput("ITEM_COUNT", "How Many Items to drop ( max "..math.round(consumableItems.count[item]).." )?",12)
								if not result or result == "" then result = math.round(consumableItems.count[item]) end
								if result and tonumber(result) then
									local result = math.round(tonumber(result))
									local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
									if Consumable.isWeapon then
										local ammoinweapon = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(Consumable.hash))
										SetPedAmmo(PlayerPedId(), GetHashKey(Consumable.hash), ammoinweapon-result)
										if ammoinweapon-result == 0 then
											 RemoveWeaponFromPed(PlayerPedId(), GetHashKey(Consumable.hash))
											 TriggerServerEvent("ForceCreateWeaponPickupAtLocation", playerX + 3, playerY, playerZ, item,result,true,false)
										else 
											TriggerServerEvent("ForceCreateWeaponPickupAtLocation", playerX + 3, playerY, playerZ, item,result,true,true)
										end
										consumableItems.count[item] = ammoinweapon-result
									else
										TriggerServerEvent("ForceCreateFoodPickupAtCoord", playerX + 3, playerY, playerZ, item, result,true)
										consumableItems.count[item] = consumableItems.count[item] - result
										if item == 17 then
											TriggerServerEvent("AddLegitimateMoney", -result)
										end
									end
								end
							end
						else
							if consumableItems[item].consumable and not consumableItems[item].isWeapon then
								WarMenu.OpenMenu("consumables")
								
							elseif not consumableItems[item].consumable and not consumableItems[item].isWeapon then
								WarMenu.OpenMenu("useables")
							elseif not consumableItems[item].consumable and consumableItems[item].isWeapon then
								WarMenu.OpenMenu("weapons")
							end
						end
						WarMenu.Display()
					end
				end
			end
		end
		
		Citizen.Wait(0)
	end
end)


RegisterCommand("help", function()
	WarMenu.OpenMenu("helpmenu")
end, false)	