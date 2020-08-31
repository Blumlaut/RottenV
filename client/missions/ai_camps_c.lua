local pedWeps =
{
	"WEAPON_PISTOL",
	"WEAPON_PUMPSHOTGUN",
	"WEAPON_SAWNOFFSHOTGUN",
	"WEAPON_MICROSMG",
	"WEAPON_COMPACTRIFLE",
	"WEAPON_COMBATPISTOL",
	"WEAPON_BULLPUPRIFLE",
	"WEAPON_ASSAULTSHOTGUN",
	"WEAPON_REVOLVER",
	"WEAPON_COMBATPDW",
	"WEAPON_ASSAULTSMG",
	"WEAPON_ASSAULTRIFLE",
	"weapon_Pistol_Mk2",
	"weapon_AssaultRifle_Mk2",
	"weapon_SMG_Mk2"
}

local pedModels =
{
	"S_M_Y_BlackOps_01",
	"S_M_Y_BlackOps_02",
	"S_M_Y_BlackOps_03",
}
-- CODE --
banditcamps = {}

bandits = {}


Citizen.CreateThread(function()
	AddRelationshipGroup("bandit")
	SetRelationshipBetweenGroups(5, GetHashKey("bandit"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(0, GetHashKey("bandit"), GetHashKey("bandit"))
	SetRelationshipBetweenGroups(5, GetHashKey("bandit"), GetHashKey("zombeez"))
	SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("bandit"))

	while true do
		Wait(100)
		local px,py,pz = table.unpack(GetEntityCoords(PlayerPedId(),false))
		for i, camp in ipairs(banditcamps) do
			for i,ped in ipairs(camp.peds) do
				if NetworkHasControlOfEntity(ped) and GetDistanceBetweenCoords(camp.coords.x, camp.coords.y, camp.coords.z, px,py,pz,false) > 400 then
					DeleteEntity(ped)
					table.remove(camp.peds,i)
				elseif NetworkHasControlOfEntity(ped) and IsPedDeadOrDying(ped, true) then
					local pedX,pedY,pedZ=table.unpack(GetEntityCoords(ped,true) )
					TriggerServerEvent("ForceCreateWeaponPickupAtLocation", pedX,pedY,pedZ)
					table.remove(camp.peds,i)
					writeLog("ped dead", 1)
					local cod = GetPedSourceOfDeath(ped)
					local weap = GetPedCauseOfDeath(ped)
					if cod ~= 0 and NetworkGetPlayerIndexFromPed(cod) then
						TriggerServerEvent("s_killedBanditPed",GetPlayerServerId(NetworkGetPlayerIndexFromPed(cod)),weap)
					end
				elseif GetDistanceBetweenCoords(camp.coords.x, camp.coords.y, camp.coords.z, px,py,pz,false) < 300 and not DoesEntityExist(ped) then
					table.remove(camp.peds,i)
				end
				Wait(1)
			end
			if #camp.peds == 0 then
				TriggerServerEvent("RemoveOldCamp", camp.id)
			end
		end
	end
end)


function GenerateBanditCamp(campinfo)
	x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))

	local campx,campy,campz = campinfo.coords.x, campinfo.coords.y, campinfo.coords.z
	_,campz = GetGroundZFor_3dCoord(campx+.0,campy+.0,9999.0, 0)

	for i, model in ipairs(pedModels) do
		RequestModel(model)
		while not HasModelLoaded(model) or not HasCollisionForModelLoaded(model) do
			Wait(200)
		end
	end
	campinfo.peds = {}
	for i=1, campinfo.pedcount do
		choosenPed1 = pedModels[math.random(1, #pedModels)]
		choosenPed1 = string.upper(choosenPed1)
		ped = CreatePed(4, GetHashKey(choosenPed1), campx+math.random(-3,3),campy+math.random(-3,3),campz, 0.0, true, false)
		DecorSetBool(ped, "C8pE53jw", true)
		DecorSetBool(ped, "bandit", true)
		SetPedArmour(ped, 20.0)
		local health = math.random(200,600)
		SetPedMaxHealth(ped, health)
		SetEntityHealth(ped, health)
		--SetPedAccuracy(ped, 25)
		SetPedSeeingRange(ped, 80.0)
		SetPedHearingRange(ped, 30.0)

		SetPedFleeAttributes(ped, 0, 0)
		SetPedCombatAttributes(ped, 0, 1)
		SetPedCombatAttributes(ped, 16, 1)
		SetPedCombatAttributes(ped, 46, 1)
		SetPedCombatAttributes(ped, 1424, 1)
		SetPedCombatAttributes(ped, 5, 1)
		SetPedCombatMovement(ped, 3)
		--SetPedCombatRange(ped,1)
		--SetPedDiesInstantlyInWater(ped,true)
		SetPedDropsWeaponsWhenDead(ped, false)
		SetPedRelationshipGroupHash(ped, GetHashKey("bandit"))
		TaskGuardCurrentPosition(ped, 35.0, 35.0, 1)
		randomWep = math.random(1, #pedWeps)
		GiveWeaponToPed(ped, GetHashKey(pedWeps[randomWep]), 9999, true, true)

		repeat
			Wait(500)
			if not NetworkGetEntityIsNetworked(ped) then
				NetworkRegisterEntityAsNetworked(ped)
			end
			netid = NetworkGetNetworkIdFromEntity(ped)
		until (netid and NetworkGetEntityFromNetworkId(netid) == ped)
		table.insert(campinfo.peds, NetworkGetNetworkIdFromEntity(ped))
	end
	
	TriggerServerEvent("RegisterNewBanditCamp", campinfo)
	writeLog("\nGenerated New Bandit Camp", 1)
end
RegisterNetEvent("GenerateBanditCamp")
AddEventHandler("GenerateBanditCamp", GenerateBanditCamp)

RegisterNetEvent("RegisterNewBanditCamp")
AddEventHandler("RegisterNewBanditCamp", function(data)
	-- {netid = netid, id = #spawnedCars+1}
	for i, ped in ipairs(data.peds) do
		data.peds[i] = NetworkGetEntityFromNetworkId(ped)
		writeLog("netid:"..ped, 1)
	end
	data.blip = AddBlipForRadius(data.coords.x, data.coords.y, data.coords.z, 30.0)
	SetBlipAsShortRange(data.blip, true)
	SetBlipColour(data.blip, 1)
	SetBlipDisplay(data.blip, 2)
	SetBlipAlpha(data.blip, 180)
	data.blip2 = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
	SetBlipAsShortRange(data.blip2, true)
	SetBlipColour(data.blip2, 1)
	SetBlipDisplay(data.blip2, 2)
	SetBlipSprite(data.blip2, 119)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Enemy Outpost")
	EndTextCommandSetBlipName(data.blip2)

	table.insert(banditcamps, data)
end)


RegisterNetEvent("LoadCamps")
AddEventHandler("LoadCamps", function(data)
	banditcamps = data
end)



RegisterNetEvent("RemoveOldCamp")
AddEventHandler("RemoveOldCamp", function(campid)
	for i,camp in pairs(banditcamps) do
		if camp.id == campid then
			local px,py,pz = table.unpack(GetEntityCoords(PlayerPedId(), false))
			if GetDistanceBetweenCoords(px,py,pz, camp.coords.x, camp.coords.y, camp.coords.z, false) < 100 then
				if currentQuest.active then
					if Quests[currentQuest.id].finishrequirements.stopCamps and not IsPlayerDead(PlayerId()) then
						currentQuest.progress.stopCamps = currentQuest.progress.stopCamps+1
					end
				end
			end
			RemoveBlip(camp.blip)
			RemoveBlip(camp.blip2)
			table.remove(banditcamps,i)
			writeLog("camp removed", 1)
		end
	end
end)


-- ped assignment
Citizen.CreateThread(function()
	while true do
		Wait(1500)
		local handle, ped = FindFirstPed()
		local finished = false -- FindNextPed will turn the first variable to false when it fails to find another ped in the index
		repeat
			Wait(20)
			if not IsPedAPlayer(ped) and NetworkHasControlOfEntity(ped) and not DecorGetBool(ped, "zombie") and not DecorGetBool(ped, "MissionPed") then
				local ownedByMe = false
				local CanNotControl = false
				for i,camp in pairs(banditcamps) do
					for i,bandit in pairs(camp.peds) do
						if ped == bandit then
							ownedByMe = true
						end
					end
				end
				for i,animal in pairs(animals) do
					if ped == animal then
						CanNotControl = true
					end
				end
				for i,zombie in pairs(zombies) do
					if ped == zombie then
						CanNotControl = true
					end
				end
				
				if NetworkHasControlOfEntity(ped) and not ownedByMe and not CanNotControl then
					TaskGuardCurrentPosition(ped, 35.0, 35.0, 1)
				end
			end
			finished, ped = FindNextPed(handle) -- first param returns true while entities are found
		until not finished
		EndFindPed(handle)
	end
end)

