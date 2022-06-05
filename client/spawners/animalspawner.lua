-- animal = animal name
-- flags = 
-- 1 = SET_PED_PATH_AVOID_FIRE
-- 2 = SET_PED_PATH_PREFER_TO_AVOID_WATER
-- 3 = BF_CanFightArmedPedsWhenNotArmed
-- 4 = BF_AlwaysFight
-- 5 = BF_PlayerCanUseFiringWeapons
-- 

local animaltable = {
	{animal="Mountain Lion", model="a_c_mtlion", flags={1,2,3}, relationship="predator" },
	{animal="Boar", model="a_c_boar", flags={1}, relationship="prey" },
	{animal="Cat", model="a_c_cat_01", flags={1,2,3}, relationship="predatordom" },
	{animal="Chop", model="a_c_chop", flags={3}, relationship="predatordom" },
	{animal="Cormorant", model="a_c_cormorant", flags={1}, relationship="prey" },
	{animal="Cow", model="a_c_cow", flags={1}, relationship="prey"},
	{animal="Coyote", model="a_c_coyote", flags={1,3}, relationship="predator"},
	{animal="Deer", model="a_c_deer", flags={1}, relationship="prey" },
	{animal="Hen", model="a_c_hen", flags={1}, relationship="preydom" },
	{animal="Husky", model="a_c_husky", flags={1,3}, relationship="predatordom" },
	{animal="Pig", model="a_c_pig", flags={1}, relationship="dom" },
	{animal="Pigeon", model="a_c_pigeon", flags={1}, relationship="prey" },
	{animal="Poodle", model="a_c_poodle", flags={1}, relationship="predatordom" },
	{animal="Pug", model="a_c_pug", flags={1}, relationship="prey" },
	{animal="Rabbit", model="a_c_rabbit_01", flags={1}, relationship="prey" },
	{animal="Rat", model="a_c_rat", flags={1}, relationship="prey" },
	{animal="Retriever", model="a_c_retriever", flags={1,3}, relationship="predatordom" },
	{animal="Rottweiler", model="a_c_rottweiler", flags={1,3}, relationship="predatordom" },
	{animal="Seagull", model="a_c_seagull", flags={1,3}, relationship="prey" },
	{animal="Shepherd", model="a_c_shepherd", flags={1,3}, relationship="predatordom" },
}


animals = {}


Citizen.CreateThread(function()
	AddRelationshipGroup("prey")
	AddRelationshipGroup("preydom")

	AddRelationshipGroup("pedator")
	AddRelationshipGroup("predatordom")
	
	SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("prey"))
	SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("predator"))
	SetRelationshipBetweenGroups(5, GetHashKey("predator"), GetHashKey("zombeez"))
	
	SetRelationshipBetweenGroups(5, GetHashKey("predatordom"), GetHashKey("zombeez"))
	SetRelationshipBetweenGroups(1, GetHashKey("predatordom"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(1, GetHashKey("PLAYER"), GetHashKey("predatordom"))
	SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("predatordom"))

	SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("preydom"))
	
	SetRelationshipBetweenGroups(255, GetHashKey("prey"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(4, GetHashKey("predator"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(4, GetHashKey("PLAYER"), GetHashKey("predator"))


	while true do
		Wait(100)
		local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
		local pedAmount = zombieZones[ GetNameOfZone(x,y,z) ]
		if type(pedAmount) ~= "number" then
			pedAmount = 1
		end
		animalAmount = pedAmount
		local pedAmount = math.round(pedAmount/6)
		if not isPlayerInSafezone and #animals < pedAmount then

			choosenAnimalTable = animaltable[math.random(1, #animaltable)]
			choosenAnimal = string.upper(choosenAnimalTable.model)
			RequestModel(choosenAnimal)
			while not HasModelLoaded(choosenAnimal) do
				Wait(500)
			end

			local newX = x
			local newY = y
			local newZ = z + 999.0

			repeat
				Wait(100)

				newX = x + math.random(-400, 400)
				newY = y + math.random(-400 , 400)
				_,newZ = GetGroundZFor_3dCoord(newX+.0,newY+.0,z, 1)

				for _, player in pairs(players) do
					Wait(10)
					playerX, playerY = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
					if newX > playerX - 35 and newX < playerX + 35 or newY > playerY - 35 and newY < playerY + 35 then
						canSpawn = false
						break
					else
						canSpawn = true
					end
				end
			until canSpawn
			ped = CreatePed(4, choosenAnimal, newX, newY, newZ, 0.0, true, false)
			Entity(ped).state:set("C8pE53jw", true, true)

			for i,theFlag in ipairs(choosenAnimalTable.flags) do
				
				if theFlag == 1 then
					SetPedPathAvoidFire(ped, true)
				elseif theFlag == 2 then
					SetPedPathPreferToAvoidWater(ped, true)
				elseif theFlag == 3 then
					SetPedCombatAttributes(ped, 5, true)
				elseif theFlag == 4 then
					SetPedCombatAttributes(ped, 46, true)
				elseif theFlag == 5 then
					SetPedCombatAttributes(ped, 1424, true)
				end
			end
			SetPedRelationshipGroupDefaultHash(ped, choosenAnimalTable.relationship)
			SetPedRelationshipGroupHash(ped, choosenAnimalTable.relationship)

			TaskWanderStandard(ped, 10.0, 10)

			if not NetworkGetEntityIsNetworked(ped) then
				NetworkRegisterEntityAsNetworked(ped)
			end

			table.insert(animals, ped)
		end

		for i, ped in pairs(animals) do
			if DoesEntityExist(ped) == false then
				table.remove(animals, i)
			end
			pedX, pedY, pedZ = table.unpack(GetEntityCoords(ped, true))
			if IsPedDeadOrDying(ped, 1) == 1 then
				-- Set ped as no longer needed for despawning
				SetEntityAsNoLongerNeeded(ped)
				table.remove(animals, i)
			else
				playerX, playerY = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				
				if pedX < playerX - 500 or pedX > playerX + 500 or pedY < playerY - 500 or pedY > playerY + 500 then
					-- Set ped as no longer needed for despawning
					local model = GetEntityModel(ped)
					SetEntityAsNoLongerNeeded(ped)
					SetModelAsNoLongerNeeded(model)
					table.remove(animals, i)
				end
			end
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
			if not IsPedAPlayer(ped) and NetworkHasControlOfEntity(ped) and GetPedType(ped) == 28 then
				local ownedByMe = false
				local CanNotControl = false
				for i,animal in pairs(animals) do
					if ped == animal then
						ownedByMe = true
					end
				end
				for i,bandit in pairs(bandits) do
					if ped == bandit then
						CanNotControl = true
					end
				end
				for i,zombie in pairs(zombies) do
					if ped == zombie then
						CanNotControl = true
					end
				end
				
				if NetworkHasControlOfEntity(ped) and not ownedByMe and not CanNotControl then
					DeleteEntity(ped) -- delete entity as fuck reassigning this one
				end
			end
			finished, ped = FindNextPed(handle) -- first param returns true while entities are found
		until not finished
		EndFindPed(handle)
	end
end)