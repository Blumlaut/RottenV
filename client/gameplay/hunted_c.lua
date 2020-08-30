local KilledPlayers = {}
local HuntedPlayers = {}
IsPlayerHunted = false


RegisterNetEvent("Z:killedPlayer")
AddEventHandler("Z:killedPlayer", function(playerId)
	table.insert(KilledPlayers, playerId)
	if #KilledPlayers >= 5 and not IsPlayerHunted then
		local cx,cy,cz = GetEntityCoords(PlayerPedId(), true)
		TriggerServerEvent("AddPlayerHunted", cx,cy,cz)
		IsPlayerHunted = true
	end
end)

RegisterNetEvent("AddPlayerHunted")
AddEventHandler("AddPlayerHunted", function(player)
	if player.id == GetPlayerServerId(PlayerId()) then
		TriggerEvent("showNotification", "You are being ~r~Hunted~w~, you are now visible on the Map.")
		IsPlayerHunted = true
		SetResourceKvpInt("hunted",1)
	else
		player.blip = AddBlipForCoord(player.x, player.y, player.z)
		SetBlipDisplay(player.blip, 2)
		SetBlipSprite(player.blip, 303)
		SetBlipColour(player.blip, 1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(GetPlayerName(GetPlayerFromServerId(player.id)))
		EndTextCommandSetBlipName(player.blip)
		table.insert(HuntedPlayers, player)
		TriggerEvent("showNotification", ""..GetPlayerName(GetPlayerFromServerId(player.id)).." is being ~r~Hunted~w~ and is now visible on the Map.")
	end
end)


RegisterNetEvent("UpdateHuntedPos")
AddEventHandler("UpdateHuntedPos", function(player)
	if player.id == GetPlayerServerId(PlayerId()) then
		IsPlayerHunted = true
	else
		local found = false
		for i,hunted in ipairs(HuntedPlayers) do
			if player.id == hunted.id then
				found = true
				SetBlipCoords(hunted.blip, player.x, player.y, player.z)
			end
		end
		if not found then 
			player.blip = AddBlipForCoord(player.x, player.y, player.z)
			SetBlipDisplay(player.blip, 2)
			SetBlipSprite(player.blip, 303)
			SetBlipColour(player.blip, 1)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(GetPlayerName(GetPlayerFromServerId(player.id)))
			EndTextCommandSetBlipName(player.blip)
			table.insert(HuntedPlayers, player)
			TriggerEvent("showNotification", ""..GetPlayerName(GetPlayerFromServerId(player.id)).." is being ~r~Hunted~w~ and is now visible on the Map.")
		end
	end
end)

RegisterNetEvent("ExpireHunted")
AddEventHandler("ExpireHunted", function(player)
	if player.id == GetPlayerServerId(PlayerId()) then
		IsPlayerHunted = false
		TriggerEvent("showNotification", "Hunt Expired, you are no longer marked on the Map.")
		SetResourceKvpInt("hunted",0)
	else
		for i,hunted in ipairs(HuntedPlayers) do
			if player.id == hunted.id then
				RemoveBlip(hunted.blip)
				table.remove(HuntedPlayers,i)
				TriggerEvent("showNotification", "Hunt for "..GetPlayerName(GetPlayerFromServerId(player.id)).." Expired.")
			end
		end
	end
end)

RegisterNetEvent("DissapearHunted")
AddEventHandler("DissapearHunted", function(player)
	for i,hunted in ipairs(HuntedPlayers) do
		if player.id == hunted.id then
			RemoveBlip(hunted.blip)
			table.remove(HuntedPlayers,i)
			TriggerEvent("showNotification", "A Hunted Player dissapeared.")
		end
	end
end)

Citizen.CreateThread(function()
	Wait(20000)
	if GetResourceKvpInt("hunted") == 1 then -- fuck ur combat loggin ass lol
		local cx,cy,cz = GetEntityCoords(PlayerPedId(), true)
		TriggerServerEvent("AddPlayerHunted", cx,cy,cz)
		IsPlayerHunted = true
	end 
end)


local thisTick = 0
Citizen.CreateThread(function()
	while true do
		Wait(10000)
		thisTick = thisTick+1
		if thisTick == 6 then
			if KilledPlayers[1] then
				table.remove(KilledPlayers,1)
			end
		end
		if IsPlayerHunted then
			local cx,cy,cz = table.unpack(GetEntityCoords(PlayerPedId(), true))
			TriggerServerEvent("UpdateHuntedPos", cx,cy,cz)
		end
	end
end)