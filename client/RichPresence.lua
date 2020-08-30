local StatusQueue = {}


function SetNextRichPresence(label)
	table.insert(StatusQueue,1,label)
end

function AddRichPresence(label)
	table.insert(StatusQueue,label)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(30000)
		if StatusQueue[1] then
			SetRichPresence(StatusQueue[1])
			table.remove(StatusQueue,1)
		else
			local status = GenerateRichPresence()
			SetRichPresence(status)
		end
	end
end)

function GenerateRichPresence()
	local possibleStates = {
		"Exploring the Wastelands",
		"Surviving the Apocalypse",
		"Thinking about Cheese",
		"Thinking about the Old Times",
		"Planning their next Move",
		"Looking for a Safezone",
		"Searching for Loot",
		"Searching for Weapons",
	}
	local PlayerPed = PlayerPedId()

	if IsPedWalking(PlayerPed) then
		table.insert(possibleStates, "Walking across San Andreas")
		table.insert(possibleStates, "Walking across the Wastelands")
		table.insert(possibleStates, "Exploring the Area")
	elseif IsPedRunning(PlayerPed) then
		table.insert(possibleStates, "Running across San Andreas")
		table.insert(possibleStates, "Running across the Wastelands")
		table.insert(possibleStates, "Running from the Undead")
	elseif IsPedSprinting(PlayerPed) then
		table.insert(possibleStates, "Sprinting across San Andreas")
		table.insert(possibleStates, "Sprinting across the Wastelands")
		table.insert(possibleStates, "Sprinting from the Undead")
	end
	if IsPedInAnyVehicle(PlayerPed, false) then
		table.insert(possibleStates, "Travelling across San Andreas")
	end
	if possessed then
		table.insert(possibleStates, "Having a Nightmare")
	end
	if isPlayerInSafezone then
		table.insert(possibleStates, "In Safety")
		table.insert(possibleStates, "Relaxing")
	end
	if #curSquadMembers > 1 then
		table.insert(possibleStates, "Exploring the Wastelands with Friends")
		table.insert(possibleStates, "Travelling in a Squad")
	end
	if GetClockHours() < 5 or GetClockHours() > 22 then
		table.insert(possibleStates, "Travelling in the Cold")
		table.insert(possibleStates, "Experiencing the Darkness")
	end
	if DecorGetFloat(PlayerPedId(),"thirst") < 20.0 then
		table.insert(possibleStates, "Searching for a Drink")
		table.insert(possibleStates, "Dying of Thirst")
	end
	if DecorGetFloat(PlayerPedId(),"hunger") < 20.0 then
		table.insert(possibleStates, "Starving")
		table.insert(possibleStates, "Searching for Food")
	end
	return possibleStates[math.random(1, #possibleStates)]
end
