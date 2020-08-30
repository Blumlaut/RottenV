players = {}

RegisterServerEvent("Z:newplayer")
AddEventHandler("Z:newplayer", function(id)
	players[source] = id

	if not host then
		host = source
	end
end)

AddEventHandler("playerDropped", function(reason)
	players[source] = nil

	if source == host then
		if #players > 0 then
			for mSource, _ in pairs(players) do
				host = mSource
				break
			end
		else
			host = nil
		end
	end
end)

time = {hour = 7, minute = 0} -- start time
date = {day = 1, month = 2, year = 2018} -- start date

RegisterServerEvent("tads:newplayer")
AddEventHandler("tads:newplayer", function()
    TriggerClientEvent("tads:timeanddatesync", source, time, date)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		time.minute = time.minute+1
		if time.minute >= 60 then
			time.minute = 0
			time.hour = time.hour+1
		end
		if time.hour >= 24 then
			time.hour = 0
		end
	end
end)