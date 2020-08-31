
function GenerateQuestDescriptions()
	for i,quest in pairs(Quests) do
		WarMenu.CreateSubMenu(quest.name, 'quests', quest.name)
		AddTextEntry(GetHashKey(quest.name), quest.name)
		AddTextEntry(GetHashKey(quest.desc), quest.desc)
		AddTextEntry(GetHashKey(quest.finishmessage), quest.finishmessage)
		
		local reqt = "Requirements:"
		for i,req in pairs(quest.finishrequirements) do
			if i == "banditkills" and req > 0 then
				reqt=reqt.."\nBandit Kills: "..req
			end
			if i == "zombiekills" and req > 0 then
				reqt=reqt.."\nZombie Kills: "..req
			end
			if i == "herokills" and req > 0 then
				reqt=reqt.."\nHero Kills: "..req
			end
			if i == "stopCamps" and req > 0 then
				reqt=reqt.."\nStop "..req.." Mercenary Camps"
			end
			if i == "withweapon" then
				reqt=reqt.." with "..WEAPON_HASHES_STRINGS[""..req..""]
			end
				
			if i == "items" and #req ~= 0 then
				for index,item in pairs(req) do
					reqt=reqt.."\n"..item.count.."x "..consumableItems[item.id].name
				end
			end
		end
		AddTextEntry(GetHashKey(quest.name.."_required"), reqt)
	end
	writeLog("\nQuest Data Loaded", 1)
end
Citizen.CreateThread(function()
	
	WarMenu.CreateMenu('quests', 'Quests')
	WarMenu.SetSubTitle('quests', 'Quests')
	
	
	while true do
		if WarMenu.IsMenuOpened('quests') then
			
			for i,quest in pairs(Quests) do
				if (not CanPlayerStartQuest(quest.id) and quest.hide and currentQuest.id ~= quest.id) then
					
				elseif WarMenu.MenuButton(quest.name, quest.name) then
				
				end
			end
			WarMenu.Display()
			
		end
		for i,quest in pairs(Quests) do
			if WarMenu.IsMenuOpened(quest.name) then
				DrawQuestText(quest.id,0.25,0.96)
				if IsQuestFinished(quest.id) then
					if WarMenu.Button("~h~[FINISHED]~h~ Accept Mission") then
						ActivateQuest(quest.id)
					end
				elseif currentQuest.active and currentQuest.id ~= quest.id then
					if WarMenu.Button("~h~[UNAVAIL]~h~ Accept Mission") then
						ActivateQuest(quest.id)
					end
				elseif currentQuest.active and currentQuest.id == quest.id then
					if WarMenu.Button("~h~[ACTIVE]~h~ Accept Mission") then
						ActivateQuest(quest.id)
					end
					if WarMenu.Button("Finish Mission") then
						FinishQuest(quest.id)
						DrawQuestText(quest.finishmessage,10000,true)
					end
					if WarMenu.Button("Abort Mission") then
						AbortQuest(quest.id)
					end
				else
					if WarMenu.Button("Accept Mission") then
						ActivateQuest(quest.id)
					end
				end
				WarMenu.Display()
			end
		end
		Citizen.Wait(0)
	end
end)

function DrawQuestText(id)
	if id and Quests[id] then
		DrawRect(0.5, 0.5, 0.5, 0.5, 50, 50, 50, 210)

		SetTextFont(0)
		SetTextProportional(1)
		SetTextScale(0.0, 0.6)

		SetTextColour(255, 255, 255, 255)

		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		BeginTextCommandDisplayText(GetHashKey(Quests[id].name))
		DrawText(0.30, 0.25)


		SetTextFont(0)
		SetTextProportional(1)
		SetTextScale(0.0, 0.4)

		SetTextColour(255, 255, 255, 255)

		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		BeginTextCommandDisplayText(GetHashKey(Quests[id].desc))
		DrawText(0.30, 0.3)

		SetTextFont(0)
		SetTextProportional(1)
		SetTextScale(0.0, 0.4)

		SetTextColour(255, 255, 255, 255)

		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		BeginTextCommandDisplayText(GetHashKey(Quests[id].name.."_required"))
		DrawText(0.30, 0.5)


		if IsQuestFinished(id) then
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.4)

			SetTextColour(255, 255, 255, 255)

			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			BeginTextCommandDisplayText(GetHashKey(Quests[id].finishmessage))
			DrawText(0.30, 0.6)
		end
	end
end
