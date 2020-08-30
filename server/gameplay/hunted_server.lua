huntedPlayers = {}

Citizen.CreateThread(function()
	RegisterServerEvent("AddPlayerHunted")
	AddEventHandler("AddPlayerHunted", function(x,y,z)
		local t = {id = source, huntedStart = os.time(), x=x,y=y,z=z}
		table.insert(huntedPlayers, t)
		TriggerClientEvent("AddPlayerHunted", -1, t)
	end)


	RegisterServerEvent("UpdateHuntedPos")
	AddEventHandler("UpdateHuntedPos", function(x,y,z)
		for i, player in ipairs(huntedPlayers) do
			if player.id == source then
				huntedPlayers[i].x = x 
				huntedPlayers[i].y = y
				huntedPlayers[i].z = z
				TriggerClientEvent("UpdateHuntedPos", -1, huntedPlayers[i]) 
			end
		end
	end)
end)

AddEventHandler("playerDropped", function(reason)
	local s = source
	for i, player in pairs(huntedPlayers) do
		if s == player.id then
			TriggerClientEvent("DissapearHunted", -1, player)
			table.remove(huntedPlayers,i)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(25000)
		for i, player in ipairs(huntedPlayers) do
			if os.time()-player.huntedStart > 300 and GetNumPlayerIndices(player.id) > 0 then
				TriggerClientEvent("ExpireHunted", -1, player)
				table.remove(huntedPlayers,i)
			elseif GetNumPlayerIndices(player.id) == 0 then 
				TriggerClientEvent("DissapearHunted", -1, player)
				table.remove(huntedPlayers,i)
			end
		end
	end
end)