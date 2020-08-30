RegisterServerEvent('playerDied')
AddEventHandler('playerDied',function(killer,reason,weapon)
	if killer == "**Invalid**" then --Can't figure out what's generating invalid, it's late. If you figure it out, let me know. I just handle it as a string for now.
		reason = 2
	end
	if reason == 0 then
		TriggerClientEvent('showNotification', -1,"~o~".. GetPlayerName(source).."~w~ committed suicide. ")
	elseif reason == 1 and weapon then
		TriggerClientEvent('showNotification', -1,"~o~".. killer .. "~w~ killed ~o~"..GetPlayerName(source).."~w~ with ~o~"..weapon.."~w~.")
	end
	Citizen.Trace("\nPlayer "..GetPlayerName(source).." died\n")
end)


RegisterServerEvent("registerKill")
AddEventHandler("registerKill", function(player,humanity,weapon)
	if (player) and player ~= 0 and GetPlayerName(player) then
		TriggerClientEvent("Z:killedPlayer", player,humanity,weapon)
		Citizen.Trace(GetPlayerName(source).." Registered a kill from "..GetPlayerName(player).."\n")
	end
end)

AddEventHandler('rconCommand', function(commandName, args)
	local msg = table.concat(args, ' ')
	if commandName:lower() == 'notify' and msg ~= nil then
		TriggerClientEvent('chatMessage', -1, "^4ℹ️ Notice: " .. "^0" .. msg) 
		CancelEvent()
	end
end)