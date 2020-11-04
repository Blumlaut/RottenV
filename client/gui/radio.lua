cbChannel = 9 -- 4-19 on AM, 20-40 on FM
cbChannelIndex = 6 -- just a fix for UI
cbType = "AM" -- AM and FM
showRadio = true
VoiceType = true -- true = CB, false = Local

function GetHighestVoiceProximity()
	if VoiceType then
		if consumableItems.count[94] >= 1 then
			return 3500.0
		elseif consumableItems.count[93] >= 1 then
			return 2000.0
		elseif consumableItems.count[92] >= 1 then
			return 850.0
		else
			return 100.0
		end
	else
		return 30.0
	end 
end

function DoesPlayerHaveCBRadio()
	if consumableItems.count[94] == 0 and consumableItems.count[93] == 0 and consumableItems.count[92] == 0 then
		return false
	else
		return true
	end
end

function GetPlayerBestCBRadio()
	if consumableItems.count[94] >= 1 then
		return 94
	elseif consumableItems.count[93] >= 1 then
		return 93
	elseif consumableItems.count[92] >= 1 then
		return 92
	else
		return false
	end
end
	

function GetPlayerCurrentRadioData()
	return {cbChannel = cbChannel, cbType = cbType, VoiceType = VoiceType}
end
	
	

Citizen.CreateThread(function()
	Wait(1000)
	while true do
		Wait(1)
		if LoadedPlayerData then
			radiotex = "basicradio"
			local hasCB = DoesPlayerHaveCBRadio()
			local highestProx = GetHighestVoiceProximity()
			local bestCB = GetPlayerBestCBRadio()
			if not hasCB then
				VoiceType = false --player has no cb
				NetworkSetVoiceActive(false)
				NetworkClearVoiceChannel()
				NetworkSetTalkerProximity(75.01)
				NetworkSetVoiceActive(true)
			end
			
			if IsControlJustPressed(0, 183) and hasCB then
				VoiceType = not VoiceType
				if not VoiceType then
					NetworkSetVoiceActive(false)
					NetworkClearVoiceChannel()
					NetworkSetTalkerProximity(75.01)
					NetworkSetVoiceActive(true)
					writeLog("\nChannel: No, Proximity = 75.01", 1)
				else
					NetworkSetVoiceActive(false)
					NetworkSetVoiceChannel(cbChannel)
					NetworkSetTalkerProximity(highestProx)
					NetworkSetVoiceActive(true)
					writeLog("\nChannel: "..cbChannel..", Proximity = "..highestProx.."", 1)
				end
			end
			if IsControlJustPressed(0, 304) and hasCB then
				WarMenu.OpenMenu('useCBAmateur')
				if VoiceType then
					cii_, sii_ = 1, 1
				else
					cii_, sii_ = 2, 2
				end
			end
			if WarMenu.IsMenuOpened('useCBAmateur') then
				if WarMenu.ComboBox("Type", {"Radio","Local"}, cii_, sii_, function(ci_, si_)
					if ci_ ~= cii_ then
						if ci_ == 1 then
							VoiceType = true
							showRadio = true
							NetworkSetVoiceActive(false)
							NetworkSetVoiceChannel(cbChannel)
							NetworkSetTalkerProximity(highestProx)
							NetworkSetVoiceActive(true)
						else
							VoiceType = false
							showRadio = false
							NetworkSetVoiceActive(false)
							NetworkClearVoiceChannel()
							NetworkSetTalkerProximity(75.01)
							NetworkSetVoiceActive(true)
						end
					end
					cii_ = ci_
					sii_ = si_
				end) then end	
								
				if VoiceType then
					showRadio = true
					local channels = {}
					local modulations = {}
					if bestCB == 92 then
						table.insert(modulations, "AM")
						if cbType == "AM" then 
							for i = 4, 19 do
								table.insert(channels,i)
							end
						end
					elseif bestCB == 94 then
						table.insert(modulations, "AM")
						table.insert(modulations, "FM")
						if cbType == "AM" then 
							for i = 4, 19 do
								table.insert(channels,i)
							end
						elseif cbType == "FM" then
							for i = 20, 60 do
								table.insert(channels,i)
							end
						end
					else
						table.insert(modulations, "AM")
						table.insert(modulations, "FM")
						if cbType == "AM" then 
							for i = 4, 19 do
								table.insert(channels,i)
							end
						elseif cbType == "FM" then
							for i = 20, 40 do
								table.insert(channels,i)
							end
						end
					end
					if WarMenu.ComboBox("Channel", channels, currentChannelItemIndex, selectedChannelItemIndex, function(currentChannelIndex, selectedChannelIndex)
						if not currentChannelIndex then currentChannelIndex, selectedChannelIndex = cbChannelIndex, cbChannelIndex end
						if currentChannelIndex ~= currentChannelItemIndex then
							cbChannel = channels[currentChannelIndex]
							cbChannelIndex = currentChannelIndex
							NetworkSetVoiceChannel(cbChannel)
							NetworkSetTalkerProximity(highestProx)
						end
						currentChannelItemIndex = currentChannelIndex
						selectedChannelItemIndex = selectedChannelIndex
						
					end) then end
					
					if WarMenu.ComboBox("Modulation", modulations, cii, sii, function(ci, si)
						if not ci then ci, si = 1, 1 end
						if ci ~= cii then
							if ci == 1 then
								cbType = "AM"
							elseif ci == 2 then
								cbType = "FM"
							end
							if ci == 1 and cbChannel > 19 then
								cbChannel = 9
								NetworkSetVoiceChannel(cbChannel)
								NetworkSetTalkerProximity(highestProx)
							elseif ci == 2 and cbChannel < 20 then
								cbChannel = 20
								cbChannelIndex = 16
								NetworkSetVoiceChannel(cbChannel)
								NetworkSetTalkerProximity(highestProx)
							end
						end
						cii = ci
						sii = si
					end) then end
				end
		
				WarMenu.Display()
			else
				showRadio = false
			end
					
			
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.35)
			SetTextColour(200, 200, 200, 255)
			--SetTextDropshadow(0, 0, 0, 0, 255)
			--SetTextDropShadow()
			--SetTextOutline()
			SetTextEntry("STRING")
			if VoiceType then
				AddTextComponentString("Chat: Radio "..cbType..""..cbChannel)
			else
				AddTextComponentString("Chat: Local")
			end
			DrawText(0.90, 0.95)
			
				
			--[[
			if NetworkIsPlayerTalking(PlayerId()) then
				DrawSprite("rottenv", "speakerloud", 0.95-safeZoneOffset, 0.88+safeZoneOffset,0.05,0.1, 0.0, 255,255,255, 255)
			end
			]]
			
			
			if NetworkIsPlayerTalking(PlayerId()) and hasCB then
				showRadio = true
			end
			
			if showRadio and bestCB then
				if bestCB == 92 then
					DrawSprite("rottenv", "basicradio", 0.70-safeZoneOffset, 0.85+safeZoneOffset,0.28,0.33, 0.0, 255,255,255, 255)
				
					SetTextFont(2)
					SetTextProportional(1)
					SetTextScale(0.0, 0.6)
					SetTextColour(10, 10, 10, 255)
					--SetTextDropshadow(0, 0, 0, 0, 255)
					--SetTextDropShadow()
					--SetTextOutline()
					SetTextEntry("STRING")
					AddTextComponentString(cbType..""..cbChannel)
					DrawText(0.755, 0.872)
				--elseif GetPlayerBestCBRadio() == 93 then
				elseif bestCB == 93 then
					DrawSprite("rottenv", "medradio", 0.70-safeZoneOffset, 0.85+safeZoneOffset,0.28,0.33, 0.0, 255,255,255, 255)
				
					SetTextFont(2)
					SetTextProportional(1)
					SetTextScale(0.0, 0.6)
					SetTextColour(10, 10, 10, 255)
					--SetTextDropshadow(0, 0, 0, 0, 255)
					--SetTextDropShadow()
					--SetTextOutline()
					SetTextEntry("STRING")
					AddTextComponentString(cbType..""..cbChannel)
					DrawText(0.76, 0.885)
				elseif bestCB == 94 then
					DrawSprite("rottenv", "highradio", 0.70-safeZoneOffset, 0.85+safeZoneOffset,0.26,0.33, 0.0, 255,255,255, 255)
				
					SetTextFont(2)
					SetTextProportional(1)
					SetTextScale(0.0, 0.6)
					SetTextColour(10, 10, 10, 255)
					--SetTextDropshadow(0, 0, 0, 0, 255)
					--SetTextDropShadow()
					--SetTextOutline()
					SetTextEntry("STRING")
					AddTextComponentString(cbType..""..cbChannel)
					DrawText(0.76, 0.8315)
				end
			end
		end
	end
end)