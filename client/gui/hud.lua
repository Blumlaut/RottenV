
local questText = {}
local seeThrough = false
local nightVision = false
Citizen.CreateThread(function() -- Data Refresh Thread
	while true do 
		safeZoneOffset = (GetSafeZoneSize() / 2.5) - 0.4
		health = GetEntityHealth(PlayerPedId())
		hunger = LocalPlayer.state.hunger
		thirst = LocalPlayer.state.thirst

		questText = {}
		if currentQuest.active then 
			table.insert(questText, "Active Quest:")
			for i,thereq in pairs( Quests[currentQuest.id].finishrequirements ) do
				if i == "banditkills" and thereq > 0 then
					table.insert(questText, "Bandits Killed: "..currentQuest.progress.banditkills.."/"..thereq)

				elseif i == "zombiekills" and thereq > 0 then
					table.insert(questText, "Zombies Killed: "..currentQuest.progress.zombiekills.."/"..thereq)
				elseif i == "herokills" and thereq > 0 then
					table.insert(questText, "Heroes Killed: "..currentQuest.progress.herokills.."/"..thereq)
				elseif i == "stopCamps" and thereq > 0 then
					table.insert(questText, "Mercenary Camps Stopped: "..currentQuest.progress.stopCamps.."/"..thereq)
				elseif i == "items" and #thereq ~= 0 then
					for index,item in pairs(thereq) do
						if item.count > 1 and not consumableItems[item.id].isWeapon then
							table.insert(questText, consumableItems[item.id].multipleCase.." "..math.round(consumableItems.count[item.id]).."/"..item.count)
						elseif item.count == 1 and not consumableItems[item.id].isWeapon then
							table.insert(questText, consumableItems[item.id].name.." "..math.round(consumableItems.count[item.id]).."/"..item.count)
						elseif consumableItems[item.id].isWeapon then
							table.insert(questText, consumableItems[item.id].name.." "..math.round(consumableItems.count[item.id]).."/"..item.count.."x")
						end
					end
				end
			end
		end
		seeThrough = IsSeethroughActive()
		nightVision = IsNightvisionActive()
		Wait(400)
	end
end)
local DebugView = false


RegisterCommand("debugtext", function()
	DebugView = not DebugView
end, false)	

Citizen.CreateThread(function()
	RequestStreamedTextureDict("rottenv", true)
	function ConvertToRGB(value)
		local value = tonumber(value)
		if not value or value > 100.0 then return {255,255,255} end
		local colouring = value*2.55
		local red,green,blue = 255-colouring,colouring,0
		local red, green, blue = math.round(red),math.round(green),math.round(blue)
		return {red, green, blue}
	end
	
	while true do
		if not HasStreamedTextureDictLoaded("rottenv") then
			while not HasStreamedTextureDictLoaded("rottenv") do
				RequestStreamedTextureDict("rottenv", true)
				Wait(500)
			end
		else
			Wait(1)
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.3)
			
			SetTextColour(128, 128, 200, 255)
			
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString("RottenV:R")
			DrawText(0.005, 0.005)
			
			
			if DebugView and LoadedPlayerData then
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.3)
				SetTextColour(128, 128, 200, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString("Zombies: "..#zombies.."/"..zombiepedAmount)
				DrawText(0.005, 0.020)
				
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.3)
				SetTextColour(128, 128, 200, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString("Animals: "..#animals.."/"..animalAmount)
				DrawText(0.005, 0.035)
				
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.3)
				SetTextColour(128, 128, 200, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString("Bandits: "..#bandits)
				DrawText(0.005, 0.050)
				
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.3)
				SetTextColour(128, 128, 200, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString("Cars: "..#cars)
				DrawText(0.005, 0.065)

				local spawneddeaddrops = 0
				local spawnedglobalpickups = 0
				for i,p in pairs(spawnedPickups) do
					if p.spawned then
						spawnedglobalpickups=spawnedglobalpickups+1
					end
					if p.owner then
						spawneddeaddrops=spawneddeaddrops+1
					end
				end				
	
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.3)
				SetTextColour(128, 128, 200, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString("Global Items: "..spawnedglobalpickups.."/"..#spawnedPickups.."/D"..spawneddeaddrops)
				DrawText(0.005, 0.095)
				
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.3)
				SetTextColour(128, 128, 200, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString("PIR: "..GetPlayersInRadius())
				DrawText(0.005, 0.110)
			end
				
				
			
			if hudHidden then
				hudHidden = false
			else
				if PlayerUniqueId then
					SetTextFont(0)
					SetTextProportional(1)
					SetTextScale(0.0, 0.3)
					SetTextColour(170, 170, 170, 200)
					--SetTextDropshadow(0, 0, 0, 0, 255)
					SetTextEdge(1, 0, 0, 0, 255)
					SetTextDropShadow()
					SetTextOutline()
					SetTextEntry("STRING")
					AddTextComponentString(PlayerUniqueId)
					DrawText(0.0, 0.98)
				end
				
				if currentQuest.active then
					for i,t in ipairs(questText) do 
						SetTextFont(0)
						SetTextProportional(1)
						SetTextScale(0.0, 0.4)
						SetTextColour(255, 255, 255, 255)
						--SetTextDropshadow(0, 0, 0, 0, 255)
						SetTextEdge(1, 0, 0, 0, 255)
						SetTextDropShadow()
						SetTextOutline()
						SetTextEntry("STRING")
						AddTextComponentString(t)
						DrawText(0.02, 0.3+(i/40))
					end
				end
				
				if seeThrough then
					SetTextFont(4)
					SetTextProportional(1)
					SetTextScale(0.0, 0.6)
					SetTextColour(255, 255, 255, 255)
					--SetTextDropshadow(0, 0, 0, 0, 255)
					SetTextEdge(1, 0, 0, 0, 255)
					SetTextDropShadow()
					SetTextOutline()
					SetTextEntry("STRING")
					AddTextComponentString(consumableItems[89].charge.."%")
					DrawText(0.6, 0.85)
				elseif nightVision then
					SetTextFont(4)
					SetTextProportional(1)
					SetTextScale(0.0, 0.6)
					SetTextColour(255, 255, 255, 255)
					--SetTextDropshadow(0, 0, 0, 0, 255)
					SetTextEdge(1, 0, 0, 0, 255)
					SetTextDropShadow()
					SetTextOutline()
					SetTextEntry("STRING")
					AddTextComponentString(consumableItems[90].charge.."%")
					DrawText(0.6, 0.85)
				end
				
				if health then
					local red, green, blue = table.unpack(ConvertToRGB(health-100))
					
					local blood_icon = "blood100"
					if health >= 200 and health <= 181 then
						blood_icon = "blood100"
					elseif health <= 180 and health >= 161 then
						blood_icon = "blood80"
					elseif health <= 160 and health >= 141 then
						blood_icon = "blood60"
					elseif health <= 140 and health >= 121 then
						blood_icon = "blood40"
					elseif health <= 120 and health >= 101 then
						blood_icon = "blood20"
					elseif health < 101 then
						blood_icon = "blood0"
					end
					DrawSprite("rottenv", blood_icon, 0.17-safeZoneOffset, 0.974+safeZoneOffset,0.09,0.13, 0.0, red,green,blue, 255)
					if infected then
						DrawSprite("rottenv", "bloodinfection", 0.17-safeZoneOffset, 0.974+safeZoneOffset,0.09,0.13, 0.0, 0,0,0, 255)
					end
				end
				
				if hunger then
					local convertedhunger = math.round(hunger)
					local red, green, blue = table.unpack(ConvertToRGB(convertedhunger))
					local food_icon = "hunger100"
					if convertedhunger >= 100 and convertedhunger <= 81 then
						food_icon = "hunger100"
					elseif convertedhunger <= 80 and convertedhunger >= 61 then
						food_icon = "hunger80"
					elseif convertedhunger <= 60 and convertedhunger >= 41 then
						food_icon = "hunger60"
					elseif convertedhunger <= 40 and convertedhunger >= 21 then
						food_icon = "hunger40"
					elseif convertedhunger <= 20 and convertedhunger >= 1 then
						food_icon = "hunger20"
					elseif convertedhunger < 1 then
						food_icon = "hunger0"
					end
					DrawSprite("rottenv", food_icon, 0.17-safeZoneOffset, 0.864+safeZoneOffset,0.10,0.12, 0.0, red,green,blue, 255)
				end
				
				if thirst then
					local convertedthirst = math.round(thirst)
					local red, green, blue = table.unpack(ConvertToRGB(convertedthirst))
					local thirst_icon = "thirst100"
					if convertedthirst >= 100 and convertedthirst <= 81 then
						thirst_icon = "thirst100"
					elseif convertedthirst <= 80 and convertedthirst >= 61 then
						thirst_icon = "thirst80"
					elseif convertedthirst <= 60 and convertedthirst >= 41 then
						thirst_icon = "thirst60"
					elseif convertedthirst <= 40 and convertedthirst >= 21 then
						thirst_icon = "thirst40"
					elseif convertedthirst <= 20 and convertedthirst >= 1 then
						thirst_icon = "thirst20"
					elseif convertedthirst < 1 then
						thirst_icon = "thirst0"
					end
					
					
					DrawSprite("rottenv", thirst_icon, 0.17-safeZoneOffset, 0.918+safeZoneOffset,0.10,0.12, 0.0, red,green,blue, 255)
				end
				
				if humanity then
					local red,green,blue = 0,255,0
					local displayHumanity = math.round(humanity/10)
					local red, green, blue = table.unpack(ConvertToRGB(displayHumanity))
					local humanity_icon = "humanity100"
					if displayHumanity >= 100 and displayHumanity <= 81 then
						humanity_icon = "humanity100"
					elseif displayHumanity <= 80 and displayHumanity >= 61 then
						humanity_icon = "humanity80"
					elseif displayHumanity <= 60 and displayHumanity >= 41 then
						humanity_icon = "humanity60"
					elseif displayHumanity <= 40 and displayHumanity >= 21 then
						humanity_icon = "humanity40"
					elseif displayHumanity <= 20 and displayHumanity >= 1 then
						humanity_icon = "humanity20"
					elseif displayHumanity < 1 then
						humanity_icon = "humanity0"
					end
					DrawSprite("rottenv", humanity_icon, 0.17-safeZoneOffset, 0.814+safeZoneOffset,0.07,0.09, 0.0, red,green,blue, 255)
				end
				
				local money = consumableItems.count[17]
				if money then
					SetTextFont(7)
					SetTextProportional(1)
					SetTextScale(0.0, 0.5)
					SetTextColour(0, 255, 0, 200)
					--SetTextDropshadow(0, 0, 0, 0, 255)
					SetTextEdge(1, 0, 0, 0, 255)
					SetTextDropShadow()
					SetTextOutline()
					SetTextEntry("STRING")
					AddTextComponentString("$"..money)
					DrawText(0.2-safeZoneOffset, 0.95+safeZoneOffset)
					HideHudComponentThisFrame(3)
					HideHudComponentThisFrame(4)
					HideHudComponentThisFrame(13)
					RemoveMultiplayerHudCash()
					local b = -3
				end
					
					
				
				local talkingPlayers = {}
				for _,player in pairs(GetActivePlayers()) do
					if NetworkIsPlayerTalking(player) then
						table.insert(talkingPlayers,{id = player,ped = GetPlayerPed(player),name = GetPlayerName(player)})
					end
				end
				
				local _,AimedAtPed = GetEntityPlayerIsFreeAimingAt(PlayerId())
				if AimedAtPed and IsEntityAPed(AimedAtPed) and DecorGetInt(AimedAtPed, "IsBoss") == 1 then
					local percent = (100/(GetEntityMaxHealth(AimedAtPed)-100)) * (GetEntityHealth(AimedAtPed)-100)
					if percent < 0 then percent = 0 end
					local percent = percent/100
					local barLength = ((0.1) * percent)
					local barHeight = 0.02*0.65
					local barX = (0.5)-(0.5*0.1)+(barLength*0.5)
					
					DrawRect(0.5,0.3,0.1*(1*1.05),0.02*1, 0, 0, 0, 255)
					DrawRect(barX,0.3,barLength,barHeight,0, 255, 0, 255)
				
				end
				
				for i,player in ipairs(talkingPlayers) do
					SetTextFont(0)
					SetTextProportional(1)
					SetTextScale(0.0, 0.35)
					SetTextColour(200, 200, 200, 255)
					SetTextEntry("STRING")
					AddTextComponentString(string.sub(player.name,1,12))
					DrawText(0.90, 0.6315+(i/40))


					DrawSprite("rottenv", "speakerloud", 0.98, 0.645+(i/40),0.01225,0.0245, 0.0, 255,255,255, 255)
				end
				--[[
				
				for i,player in ipairs(talkingPlayers) do
					local x,y,z = table.unpack(GetEntityCoords(player.ped,true))
					local startx,starty,startz = table.unpack(GetEntityCoords(PlayerPedId(), true))
					local ray = StartShapeTestRay(startx,starty,startz, x,y,z, -1, PlayerPedId(), 0)
					local _,hit,endcoords,surfacenormal,entityhit = GetShapeTestResult(ray)
					if not hit or entityhit == player.ped then 
						SetDrawOrigin(x, y, z+1.0, 0);
						DrawSprite("rottenv", "speakerloud", 0.0, 0.0,0.03,0.05, 0.0, 255,255,255,255)
						ClearDrawOrigin()
					end
				end ]]
			end

			
		end
	end
end)

Citizen.CreateThread(function()
	curCash = 0
	lastCash = 0
	while true do
		Wait(0)
		curCash = consumableItems.count[17]
		if curCash ~= lastCash and not hudHidden then
			local a = 255
			local c = {255,0,0}
			local str = "$"
			local stop = false
			local i = 0.00
			for i,theConsumable in pairs(consumableItems) do
				if theConsumable.name == "Money" then
					consumableItems.count[i] = curCash
				end
			end
			
			repeat
				local tc = consumableItems.count[17]
				if tc ~= curCash then
					a = 255
				end
				curCash = consumableItems.count[17]
				if curCash-lastCash > 0 then
					c = {0,255,0}
					str = "$+"
				end
				local r,g,b = table.unpack(c)
				SetTextFont(7)
				SetTextProportional(1)
				SetTextScale(0.0, 0.5)
				SetTextColour(r,g,b, a)
				if a > 230 then
					a=a-1
				else
					a=a-5
				end
				i = i-0.01
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString(str..curCash-lastCash)
				DrawText(0.23-safeZoneOffset, 0.92+safeZoneOffset)
				if a <= 0 then
					stop = true
				end
				Wait(0)
			until stop
		end
		lastCash = consumableItems.count[17]
	end
end)

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(1) -- Wanted Stars
	HideHudComponentThisFrame(2) -- Weapon icon
	HideHudComponentThisFrame(3) -- Cash
	HideHudComponentThisFrame(4) -- MP CASH
	HideHudComponentThisFrame(6)
	HideHudComponentThisFrame(7)
	HideHudComponentThisFrame(8)
	HideHudComponentThisFrame(9)
	HideHudComponentThisFrame(13) -- Cash Change
	HideHudComponentThisFrame(11) -- Floating Help Text
	HideHudComponentThisFrame(12) -- more floating help text
	HideHudComponentThisFrame(15) -- Subtitle Text
	HideHudComponentThisFrame(18) -- Game Stream
	HideHudComponentThisFrame(19) -- weapon wheel
	hudHidden = true
end