currentQuest = {}
finishedQuests = {}
-- we will store our progress in there, same structure as "finishrequirements", except that loot will get calculated once you actually get to the trader.


function ActivateQuest(id)
	if Quests[id] and CanPlayerStartQuest(id) and not IsQuestFinished(id) and not currentQuest.active then
		currentQuest.active = true
		currentQuest.id = id
		currentQuest.progress = {banditkills = 0, herokills = 0, zombiekills = 0, stopCamps = 0}
	elseif IsQuestFinished(id) then
		TriggerEvent('showNotification', "You have already completed this Quest.")
	elseif currentQuest.active then
		TriggerEvent('showNotification', "You are already in Quest: "..Quests[currentQuest.id].name)
	elseif not CanPlayerStartQuest(id) then
		TriggerEvent('showNotification', "You do not meet the requirements to start this Quest.")
	end
end

function CanPlayerStartQuest(id)
	if Quests[id] then
		local startRequirements = Quests[id].startRequirements
		local failedQuest = false
		if startRequirements.humanityMin then
			if humanity < startRequirements.humanityMin then
				failedQuest = true
			end
		end
		if startRequirements.humanityMax then
			if humanity > startRequirements.humanityMax then
				failedQuest = true
			end
		end
		if startRequirements.zombiekills then
			if zombiekills < startRequirements.zombiekills then
				failedQuest = true
			end
		end
		if startRequirements.stopCamps then
			if stopCamps < startRequirements.stopCamps then
				failedQuest = true
			end
		end
		if startRequirements.items then
			for i,item in pairs(startRequirements.items) do
				if consumableItems.count[item.id] < item.count then
					failedQuest = true
				end
			end
		end
		
		return not failedQuest
	end	
end

function IsQuestFinished(id)
	for i,quest in ipairs(finishedQuests) do
		if quest == id then
			return true
		end
	end
	return false
end

function FinishQuest(id)
	if currentQuest.active and currentQuest.id == id then
		
		
		local failedQuest = false
		-- check if all requirements are met
		local requirements = Quests[id].finishrequirements
		if requirements.banditkills and currentQuest.progress.banditkills < requirements.banditkills then
				failedQuest = true
				Citizen.Trace("\nfailed at bandit kills")
		elseif requirements.herokills and currentQuest.progress.herokills < requirements.herokills then
				failedQuest = true
				Citizen.Trace("\nfailed at hero kills")
		elseif requirements.zombiekills and currentQuest.progress.zombiekills < requirements.zombiekills then
				failedQuest = true
				Citizen.Trace("\nfailed at zombie kills")
		elseif requirements.stopCamps and currentQuest.progress.stopCamps < requirements.stopCamps then
				failedQuest = true
				Citizen.Trace("\nfailed at stop camps")
		end
		
		if requirements.items then 
			for i,item in ipairs(requirements.items) do
				if consumableItems.count[item.id] < item.count then
					failedQuest = true
					Citizen.Trace(consumableItems[item.id].name.." "..consumableItems.count[item.id])
				end
			end
		end
		
		if failedQuest then
			TriggerEvent('showNotification', "You are not meeting the requirements to finish this Quest.")
			return false
		else
			
		if requirements.items then
			for i,item in ipairs(requirements.items) do
				consumableItems.count[item.id] = math.round(consumableItems.count[item.id]-item.count)
				if item.id == 17 then
					TriggerServerEvent("AddLegitimateMoney", math.round(-item.count))
				end
				if consumableItems[item.id].isWeapon then
					RemoveWeaponFromPed(PlayerPedId(), consumableItems[item.id].hash)
				end
			end
		end
			
			local loot = Quests[id].finishloot
			
			if loot.humanity then
				humanity=humanity+loot.humanity
			elseif loot.health then
				local newhealth = GetEntityHealth(PlayerPedId()) + loot.health
				if newhealth > 200 then
					SetEntityHealth(PlayerPedId(), 200.0)
				else
					SetEntityHealth(PlayerPedId(), newhealth)
				end
			end
			
			local pickupString = "You Got:"
			Citizen.Trace(#loot.loot)
			for i,item in pairs(loot.loot) do
				Citizen.Trace(i)
				item.count = math.round(item.count)
				consumableItems.count[item.id] = math.round(consumableItems.count[item.id]+item.count)
				if item.id == 17 then
					TriggerServerEvent("AddLegitimateMoney", item.count)
				end
				if consumableItems[item.id].isWeapon then
					GiveWeaponToPed(PlayerPedId(), consumableItems[item.id].hash, math.round(item.count), false, false)
				end
				if item.count > 1 and not consumableItems[item.id].isWeapon then
					pickupString = pickupString.."\n~g~" .. item.count .." " .. consumableItems[item.id].multipleCase
				elseif item.count == 1 and not consumableItems[item.id].isWeapon then
					pickupString = pickupString.."\n~g~" .. item.count .." " .. consumableItems[item.id].name
				elseif item.count >= 1 and consumableItems[item.id].isWeapon then
					pickupString = pickupString.."\n~g~" .. consumableItems[item.id].name .. " (x"..item.count..")"
				end
			end
			for i = 0, #pickupString,100 do
				TriggerEvent('showNotification', string.sub(pickupString,i,i+99))
			end
			table.insert(finishedQuests,id)
			if id == 10 or id == 11 or id == 12 then
				local _,_,day = GetUtcTime()
				SetResourceKvpInt("quest_day", day)
			end
			currentQuest = {}
			return true
		end
	else
		TriggerEvent('showNotification', "You have no active Quest.")
		return false	
	end
end

function AbortQuest(id)
	if currentQuest.active then
		TriggerEvent('showNotification', "Quest Aborted.")
		currentQuest = {}
	end
end
