BanditCamps = {}
maxCamps = 5

pedPollResults = {}


CampCoords = {
	{x = 1781.9, y = 3892.9, z = 34.4, lastCreated=0},
	{x = 1750.0, y = 3227.0, z = 41.2, lastCreated=0},
	{x = 214.7, y = -30.9, z = 69.7, lastCreated=0},
	{x = 89.8, y = -204.9, z = 54.5, lastCreated=0},
	{x = -368.8, y = -122.4, z = 38.7, lastCreated=0},
	{x = 97.9, y = -1404.4, z = 29.2, lastCreated=0},
	{x = 138.8, y = 6591.9, z = 31.9, lastCreated=0},
	{x = 118.4, y = -402.0, z = 41.25, lastCreated=0},
	{x = 958.8, y = 3560.0, z = 47.65, lastCreated=0},
	{x = 2498.4, y =  2870.0, z = 47.0, lastCreated=0},
}

RegisterServerEvent("RegisterNewBanditCamp")
RegisterServerEvent("RemoveOldCamp")
RegisterServerEvent("banditPoll")

AddEventHandler("RegisterNewBanditCamp", function(data)
	local t = data
	table.insert(BanditCamps,t)
	CampCoords[data.id].used = true
	CampCoords[data.id].lastCreated = os.time()
	TriggerClientEvent("RegisterNewBanditCamp", -1, t)
	writeLog("\nRegistering Camp", 1)
end)

AddEventHandler("RemoveOldCamp", function(campid)
	--print("got camp removal request")
	for i,camp in pairs(BanditCamps) do
		writeLog(camp.id, 1)
		if camp.id == campid then
			table.remove(BanditCamps,i)
			
			writeLog("camp removed", 1)
		end
	end
	TriggerClientEvent("RemoveOldCamp", -1, campid)
end)


AddEventHandler("banditPoll", function(peds)
	table.insert(pedPollResults, peds)
end)

Citizen.CreateThread(function()
	while true do
		Wait(30000)
		local players = GetPlayers()
		for i, player in pairs(players) do
			if #BanditCamps < maxCamps  then
				Wait(1)
				local px,py,pz = table.unpack(GetEntityCoords(GetPlayerPed(player), true))
				for i, coord in pairs(CampCoords) do 
					Wait(1)
					local dist = #(vector3(coord.x, coord.y, 0) -  vector3(px, py,0)) 
					if (dist < 200 and dist > 50) and not coord.used and (os.time()-coord.lastCreated > 1000) then
						writeLog("generating", 1)
						TriggerClientEvent("GenerateBanditCamp", player, {id = i, coords = coord, pedcount = math.random(2,8)}  ) -- ask a random player to generate a camp
					end
				end
			end
		end
	end
end)



Citizen.CreateThread(function()
	RegisterServerEvent("Z:newplayerID")
	AddEventHandler("Z:newplayerID", function(playerid)
		TriggerClientEvent("LoadCamps", source, BanditCamps)
	end)
end)
