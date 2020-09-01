-- CONFIG --

-- Zombies have a 1 in 150 chance to spawn with guns
-- It will choose a gun in this list when it happens
-- Weapon list here: https://www.se7ensins.com/forums/threads/weapon-and-explosion-hashes-list.1045035/


-- zombie spawn amounts in specific zones, default = 15

zombieZones = {
	AIRP = 12,
	ALAMO = 5,
	ALTA = 12,
	ARMYB = 15,
	BANHAMC = 3,
	BANNING = 6,
	BEACH = 10,
	BHAMCA = 5,
	BRADP = 4,
	BRADT = 3,
	BURTON = 15,
	CALAFB = 2,
	CANNY = 5,
	CCREAK = 5,
	CHAMH = 15,
	CHIL = 12,
	CHU = 6,
	CMSW = 3,
	CYPRE = 6,
	DAVIS = 15,
	DELBE = 10,
	DELPE = 12,
	DELSOL = 8,
	DESRT = 4,
	DOWNT = 15,
	DTVINE = 13,
	EAST_V = 13,
	EBURO = 8,
	ELGORL = 2,
	ELYSIAN = 6,
	GALFISH = 3,
	GOLF = 1,
	GRAPES = 10,
	GREATC = 3,
	HARMO = 7,
	HAWICK = 13,
	HORS = 8,
	HUMLAB = 15,
	JAIL = 15,
	KOREAT = 12,
	LACT = 3,
	LAGO = 2,
	LDAM = 3,
	LEGSQU = 15,
	LMESA = 8,
	LOSPUER = 12,
	MIRR = 2,
	MORN = 14,
	MOVIE = 15,
	MTCHIL = 2,
	MTGORDO = 1,
	MTJOSE = 1,
	MURRI = 10,
	NCHU = 4,
	NOOSE = 15,
	OCEANA = 0,
	PALCOV = 5,
	PALETO = 10,
	PALFOR = 8,
	PALHIGH = 3,
	PALMPOW = 14,
	PBLUFF = 8,
	PBOX = 15,
	PROCOB = 5,
	RANCHO = 10,
	RGLEN = 3,
	RICHM = 15,
	ROCKF = 15,
	RTRAK = 3,
	SANAND = 15,
	SANCHIA = 4,
	SANDY = 13,
	SKID = 15,
	SLAB = 7,
	STAD = 15,
	STRAW = 7,
	TATAMO = 3,
	TERMINA = 8,
	TEXTI = 15,
	TONGVAH = 4,
	TONGVAV = 6,
	VCANA = 12,
	VESP = 14,
	VINE = 15,
	WINDF = 5,
	WVINE = 13,
	ZANCUDO = 6,
	ZP_ORT = 4,
	ZQ_UAR = 3,
}

local pedModels = {
	"A_F_M_Beach_01",
	"A_F_M_BevHills_01",
	"A_F_M_BevHills_02",
	"A_F_M_BodyBuild_01",
	"A_F_M_Business_02",
	"A_F_M_Downtown_01",
	"A_F_M_EastSA_01",
	"A_F_M_EastSA_02",
	"A_F_M_FatBla_01",
	"A_F_M_FatCult_01",
	"A_F_M_FatWhite_01",
	"A_F_M_KTown_01",
	"A_F_M_KTown_02",
	"A_F_M_ProlHost_01",
	"A_F_M_Salton_01",
	"A_F_M_SkidRow_01",
	"A_F_M_SouCentMC_01",
	"A_F_M_SouCent_01",
	"A_F_M_SouCent_02",
	"A_F_M_Tourist_01",
	"A_F_M_TrampBeac_01",
	"A_F_M_Tramp_01",
	"A_F_O_GenStreet_01",
	"A_F_O_Indian_01",
	"A_F_O_KTown_01",
	"A_F_O_Salton_01",
	"A_F_O_SouCent_01",
	"A_F_O_SouCent_02",
	"A_F_Y_Beach_01",
	"A_F_Y_BevHills_01",
	"A_F_Y_BevHills_02",
	"A_F_Y_BevHills_03",
	"A_F_Y_BevHills_04",
	"A_F_Y_Business_01",
	"A_F_Y_Business_02",
	"A_F_Y_Business_03",
	"A_F_Y_Business_04",
	"A_F_Y_EastSA_01",
	"A_F_Y_EastSA_02",
	"A_F_Y_EastSA_03",
	"A_F_Y_Epsilon_01",
	"A_F_Y_Fitness_01",
	"A_F_Y_Fitness_02",
	"A_F_Y_GenHot_01",
	"A_F_Y_Golfer_01",
	"A_F_Y_Hiker_01",
	"A_F_Y_Hippie_01",
	"A_F_Y_Hipster_01",
	"A_F_Y_Hipster_02",
	"A_F_Y_Hipster_03",
	"A_F_Y_Hipster_04",
	"A_F_Y_Indian_01",
	"A_F_Y_Juggalo_01",
	"A_F_Y_Runner_01",
	"A_F_Y_RurMeth_01",
	"A_F_Y_SCDressy_01",
	"A_F_Y_Skater_01",
	"A_F_Y_SouCent_01",
	"A_F_Y_SouCent_02",
	"A_F_Y_SouCent_03",
	"A_F_Y_Tennis_01",
	"A_F_Y_Topless_01",
	"A_F_Y_Tourist_01",
	"A_F_Y_Tourist_02",
	"A_F_Y_Vinewood_01",
	"A_F_Y_Vinewood_02",
	"A_F_Y_Vinewood_03",
	"A_F_Y_Vinewood_04",
	"A_F_Y_Yoga_01",
	"A_M_M_ACult_01",
	"A_M_M_AfriAmer_01",
	"A_M_M_Beach_01",
	"A_M_M_Beach_02",
	"A_M_M_BevHills_01",
	"A_M_M_BevHills_02",
	"A_M_M_Business_01",
	"A_M_M_EastSA_01",
	"A_M_M_EastSA_02",
	"A_M_M_Farmer_01",
	"A_M_M_FatLatin_01",
	"A_M_M_GenFat_01",
	"A_M_M_GenFat_02",
	"A_M_M_Golfer_01",
	"A_M_M_HasJew_01",
	"A_M_M_Hillbilly_01",
	"A_M_M_Hillbilly_02",
	"A_M_M_Indian_01",
	"A_M_M_KTown_01",
	"A_M_M_Malibu_01",
	"A_M_M_MexCntry_01",
	"A_M_M_MexLabor_01",
	"A_M_M_OG_Boss_01",
	"A_M_M_Paparazzi_01",
	"A_M_M_Polynesian_01",
	"A_M_M_ProlHost_01",
	"A_M_M_RurMeth_01",
	"A_M_M_Salton_01",
	"A_M_M_Salton_02",
	"A_M_M_Salton_03",
	"A_M_M_Salton_04",
	"A_M_M_Skater_01",
	"A_M_M_Skidrow_01",
	"A_M_M_SoCenLat_01",
	"A_M_M_SouCent_01",
	"A_M_M_SouCent_02",
	"A_M_M_SouCent_03",
	"A_M_M_SouCent_04",
	"A_M_M_StLat_02",
	"A_M_M_Tennis_01",
	"A_M_M_Tourist_01",
	"A_M_M_TrampBeac_01",
	"A_M_M_Tramp_01",
	"A_M_M_TranVest_01",
	"A_M_M_TranVest_02",
	"A_M_O_ACult_01",
	"A_M_O_ACult_02",
	"A_M_O_Beach_01",
	"A_M_O_GenStreet_01",
	"A_M_O_KTown_01",
	"A_M_O_Salton_01",
	"A_M_O_SouCent_01",
	"A_M_O_SouCent_02",
	"A_M_O_SouCent_03",
	"A_M_O_Tramp_01",
	"A_M_Y_ACult_01",
	"A_M_Y_ACult_02",
	"A_M_Y_BeachVesp_01",
	"A_M_Y_BeachVesp_02",
	"A_M_Y_Beach_01",
	"A_M_Y_Beach_02",
	"A_M_Y_Beach_03",
	"A_M_Y_BevHills_01",
	"A_M_Y_BevHills_02",
	"A_M_Y_BreakDance_01",
	"A_M_Y_BusiCas_01",
	"A_M_Y_Business_01",
	"A_M_Y_Business_02",
	"A_M_Y_Business_03",
	"A_M_Y_Cyclist_01",
	"A_M_Y_DHill_01",
	"A_M_Y_Downtown_01",
	"A_M_Y_EastSA_01",
	"A_M_Y_EastSA_02",
	"A_M_Y_Epsilon_01",
	"A_M_Y_Epsilon_02",
	"A_M_Y_Gay_01",
	"A_M_Y_Gay_02",
	"A_M_Y_GenStreet_01",
	"A_M_Y_GenStreet_02",
	"A_M_Y_Golfer_01",
	"A_M_Y_HasJew_01",
	"A_M_Y_Hiker_01",
	"A_M_Y_Hippy_01",
	"A_M_Y_Hipster_01",
	"A_M_Y_Hipster_02",
	"A_M_Y_Hipster_03",
	"A_M_Y_Indian_01",
	"A_M_Y_Jetski_01",
	"A_M_Y_Juggalo_01",
	"A_M_Y_KTown_01",
	"A_M_Y_KTown_02",
	"A_M_Y_Latino_01",
	"A_M_Y_MethHead_01",
	"A_M_Y_MexThug_01",
	"A_M_Y_MotoX_01",
	"A_M_Y_MotoX_02",
	"A_M_Y_MusclBeac_01",
	"A_M_Y_MusclBeac_02",
	"A_M_Y_Polynesian_01",
	"A_M_Y_RoadCyc_01",
	"A_M_Y_Runner_01",
	"A_M_Y_Runner_02",
	"A_M_Y_Salton_01",
	"A_M_Y_Skater_01",
	"A_M_Y_Skater_02",
	"A_M_Y_SouCent_01",
	"A_M_Y_SouCent_02",
	"A_M_Y_SouCent_03",
	"A_M_Y_SouCent_04",
	"A_M_Y_StBla_01",
	"A_M_Y_StBla_02",
	"A_M_Y_StLat_01",
	"A_M_Y_StWhi_01",
	"A_M_Y_StWhi_02",
	"A_M_Y_Sunbathe_01",
	"A_M_Y_Surfer_01",
	"A_M_Y_VinDouche_01",
	"A_M_Y_Vinewood_01",
	"A_M_Y_Vinewood_02",
	"A_M_Y_Vinewood_03",
	"A_M_Y_Vinewood_04",
	"A_M_Y_Yoga_01",
	"G_F_Y_ballas_01",
	"G_F_Y_Families_01",
	"G_F_Y_Lost_01",
	"G_F_Y_Vagos_01",
	"G_M_M_ArmBoss_01",
	"G_M_M_ArmGoon_01",
	"G_M_M_ArmLieut_01",
	"G_M_M_ChemWork_01",
	"G_M_M_ChiBoss_01",
	"G_M_M_ChiCold_01",
	"G_M_M_ChiGoon_01",
	"G_M_M_ChiGoon_02",
	"G_M_M_KorBoss_01",
	"G_M_M_MexBoss_01",
	"G_M_M_MexBoss_02",
	"G_M_Y_ArmGoon_02",
	"G_M_Y_Azteca_01",
	"G_M_Y_BallaEast_01",
	"G_M_Y_BallaOrig_01",
	"G_M_Y_BallaSout_01",
	"G_M_Y_FamCA_01",
	"G_M_Y_FamDNF_01",
	"G_M_Y_FamFor_01",
	"G_M_Y_Korean_01",
	"G_M_Y_Korean_02",
	"G_M_Y_KorLieut_01",
	"G_M_Y_Lost_01",
	"G_M_Y_Lost_02",
	"G_M_Y_Lost_03",
	"G_M_Y_MexGang_01",
	"G_M_Y_MexGoon_01",
	"G_M_Y_MexGoon_02",
	"G_M_Y_MexGoon_03",
	"G_M_Y_PoloGoon_01",
	"G_M_Y_PoloGoon_02",
	"G_M_Y_SalvaBoss_01",
	"G_M_Y_SalvaGoon_01",
	"G_M_Y_SalvaGoon_02",
	"G_M_Y_SalvaGoon_03",
	"G_M_Y_StrPunk_01",
	"G_M_Y_StrPunk_02",
	"HC_Driver",
	"HC_Gunman",
	"HC_Hacker",
	"IG_Abigail",
	"IG_AmandaTownley",
	"IG_Andreas",
	"IG_Ashley",
	"IG_BallasOG",
	"IG_Bankman",
	"IG_Barry",
	"IG_BestMen",
	"IG_Beverly",
	"IG_Brad",
	"IG_Bride",
	"IG_Car3guy1",
	"IG_Car3guy2",
	"IG_Casey",
	"IG_Chef",
	"IG_ChengSr",
	"IG_ChrisFormage",
	"IG_Clay",
	"IG_ClayPain",
	"IG_Cletus",
	"IG_Dale",
	"IG_DaveNorton",
	"IG_Denise",
	"IG_Devin",
	"IG_Dom",
	"IG_Dreyfuss",
	"IG_DrFriedlander",
	"IG_Fabien",
	"IG_FBISuit_01",
	"IG_Floyd",
	"IG_Groom",
	"IG_Hao",
	"IG_Hunter",
	"IG_Janet",
	"ig_JAY_Norris",
	"IG_JewelAss",
	"IG_JimmyBoston",
	"IG_JimmyDiSanto",
	"IG_JoeMinuteMan",
	"ig_JohnnyKlebitz",
	"IG_Josef",
	"IG_Josh",
	"IG_KerryMcIntosh",
	"IG_LamarDavis",
	"IG_LesterCrest",
	"IG_LifeInvad_01",
	"IG_LifeInvad_02",
	"IG_Magenta",
	"IG_Manuel",
	"IG_Marnie",
	"IG_MaryAnn",
	"IG_Maude",
	"IG_Michelle",
	"IG_Milton",
	"IG_Molly",
	"IG_MRK",
	"IG_MrsPhillips",
	"IG_MRS_Thornhill",
	"IG_Natalia",
	"IG_NervousRon",
	"IG_Nigel",
	"IG_Old_Man1A",
	"IG_Old_Man2",
	"IG_Omega",
	"IG_ONeil",
	"IG_Orleans",
	"IG_Ortega",
	"IG_Paper",
	"IG_Patricia",
	"IG_Priest",
	"IG_ProlSec_02",
	"IG_Ramp_Gang",
	"IG_Ramp_Hic",
	"IG_Ramp_Hipster",
	"IG_Ramp_Mex",
	"IG_RoccoPelosi",
	"IG_RussianDrunk",
	"IG_Screen_Writer",
	"IG_SiemonYetarian",
	"IG_Solomon",
	"IG_SteveHains",
	"IG_Stretch",
	"IG_Talina",
	"IG_Tanisha",
	"IG_TaoCheng",
	"IG_TaosTranslator",
	"U_M_Y_Zombie_01"
}

lastTimePlayerShot = 0

Citizen.CreateThread(function()
	while true do
		Wait(1)
		if IsPedShooting(PlayerPedId()) then
			lastTimePlayerShot = GetGameTimer()
		end
	end
end)

function calculateZombieAmount()
	local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	local pedAmount = (zombieZones[ GetNameOfZone(x,y,z) ] or 10)
	if type(zombiepedAmount) ~= "number" then
		zombiepedAmount = 15
	end
	zombiepedAmount = math.round((pedAmount/GetPlayersInRadius(500))*1.2)
	if lastTimePlayerShot > GetGameTimer()-5000 then
		zombiepedAmount = math.round(zombiepedAmount*1.6)
	end
	return zombiepedAmount
end
	
function calculateZombieHealth()
	if GetClockHours() < 5 or GetClockHours() > 22 then
		return math.random(300,500)
	else
		return math.random(180,300)
	end
end

function WillThisPedBeaBoss()
	if math.random(0,100) > 98 then
		return true
	else 
		return false
	end
end




-- CODE --

zombies = {}

peddeletionqueue = {}

Citizen.CreateThread(function()
	AddRelationshipGroup("zombeez")
	SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(5, GetHashKey("zombeez"), GetHashKey("bandit"))
	SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("zombeez"))
	DecorRegister("C8pE53jw", 2)
	DecorRegister("zombie", 2)
	DecorRegister("IsBoss", 3)

	SetAiMeleeWeaponDamageModifier(2.0)

	while true do
		Wait(100)
		local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
		zombiepedAmount = calculateZombieAmount()

		if not isPlayerInSafezone and not IsPlayerDead(PlayerId()) and #zombies < zombiepedAmount then

			choosenPed = pedModels[math.random(1, #pedModels)]
			choosenPed = string.upper(choosenPed)
			RequestModel(GetHashKey(choosenPed))
			while not HasModelLoaded(GetHashKey(choosenPed)) or not HasCollisionForModelLoaded(GetHashKey(choosenPed)) do
				Wait(1)
			end

			repeat
				Wait(100)

				newX = x + math.random(-50, 50)
				newY = y + math.random(-50 , 50)
				newZ = z + 999.0
				for i = -400,10,400 do
					RequestCollisionAtCoord(newX, newY, i)
					Wait(1)
				end
				_,newZ = GetGroundZFor_3dCoord(newX+.0,newY+.0,9999.0, 0)
				
--				for _, player in pairs(players) do -- i have literally no idea what this code does tbh
--					Wait(10)
					playerX, playerY = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
					if newX > playerX - 35 and newX < playerX + 35 or newY > playerY - 35 and newY < playerY + 35 then
						canSpawn = false
					else
						canSpawn = true
					end
--				end
			until canSpawn
			
			ped = CreatePed(4, GetHashKey(choosenPed), newX, newY, newZ, 0.0, true, false)
			DecorSetBool(ped, "C8pE53jw", true)
			DecorSetBool(ped, "zombie", true)
			SetPedArmour(ped, 100)
			if WillThisPedBeaBoss() then
				local th = math.random(3000,18000)
				SetPedMaxHealth(ped, th)
				SetEntityHealth(ped, th)
				SetPedSeeingRange(ped, 40.0)
				SetEntityMaxSpeed(ped, 8.0)
				DecorSetInt(ped, "IsBoss", 1)
				SetPedSuffersCriticalHits(ped, false)
				SetPedRagdollBlockingFlags(ped, 1)
				SetPedRagdollBlockingFlags(ped, 4)
			else
				local th = calculateZombieHealth()
				SetPedMaxHealth(ped, th)
				SetEntityHealth(ped, th)
				SetPedSeeingRange(ped, 20.0)
				SetEntityMaxSpeed(ped, 5.0)
			end
			SetPedAccuracy(ped, 25)
			SetPedHearingRange(ped, 65.0)

			SetPedFleeAttributes(ped, 0, 0)
			SetPedCombatAttributes(ped, 16, 1)
			SetPedCombatAttributes(ped, 17, 0)
			SetPedCombatAttributes(ped, 46, 1)
			SetPedCombatAttributes(ped, 1424, 0)
			SetPedCombatAttributes(ped, 5, 1)
			SetPedCombatRange(ped,1)
			SetPedAlertness(ped,1)
			SetAmbientVoiceName(ped, "ALIENS")
			SetPedEnableWeaponBlocking(ped, true)
			SetPedRelationshipGroupHash(ped, GetHashKey("zombeez"))
			DisablePedPainAudio(ped, true)
			SetPedDiesInWater(ped, false)
			SetPedDiesWhenInjured(ped, false)
			--	PlaceObjectOnGroundProperly(ped)
			SetPedDiesInstantlyInWater(ped,true)
			SetPedIsDrunk(ped, true)
			SetPedConfigFlag(ped,100,1)
			SetPedConfigFlag(ped, 33, 0)
			RequestAnimSet("move_m@drunk@verydrunk")
			while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
				Wait(1)
			end
			SetPedMovementClipset(ped, "move_m@drunk@verydrunk", 1.0)
			ApplyPedDamagePack(ped,"BigHitByVehicle", 0.0, 9.0)
			ApplyPedDamagePack(ped,"SCR_Dumpster", 0.0, 9.0)
			ApplyPedDamagePack(ped,"SCR_Torture", 0.0, 9.0)
			StopPedSpeaking(ped,true)

			TaskWanderStandard(ped, 1.0, 10)

			if not NetworkGetEntityIsNetworked(ped) then
				NetworkRegisterEntityAsNetworked(ped)
			end

			table.insert(zombies, ped)
		end

		for i, ped in pairs(zombies) do
			Wait(100)
			if DoesEntityExist(ped) == false or not NetworkHasControlOfEntity(ped) then
				table.remove(zombies, i)
			end
			local pedX, pedY, pedZ = table.unpack(GetEntityCoords(ped, true))
			if IsPedDeadOrDying(ped, true) then
				local pedX, pedY, pedZ = table.unpack(GetEntityCoords(ped, false))
				local distancebetweenpedandplayer = DistanceBetweenCoords(pedX,pedY,pedZ,x,y,z)
				-- Set ped as no longer needed for despawning
				if distancebetweenpedandplayer < 200.0 then
					local dropChance = math.random(0,100)
					if dropChance >= 95 and not DecorGetInt(ped, "IsBoss") == 1 then
						TriggerServerEvent("ForceCreateFoodPickupAtCoord", pedX,pedY,pedZ)
					elseif DecorGetInt(ped, "IsBoss") == 1 and not IsEntityOnFire(ped) then
						writeLog("\nGENERATING BOSS DROP", 1)
						local minItems = math.random(3,10)
						local minGuns = math.random(1,3)
						local items = {}
						for i=1,minItems do
								local chance = itemChances[ math.random( #itemChances ) ]
								local count = math.round(math.random( consumableItems[chance].randomFinds[1], consumableItems[chance].randomFinds[2]   ))+0.0
								table.insert(items, {id = chance, count = count})
						end
						for i=1,minGuns do
								local chance = weaponChances[math.random(1, #weaponChances)]
								local count = 1
								if consumableItems[chance].hasammo then
									count = math.random(20,60)
								end
								table.insert(items, {id = chance, count = count})
						end
						local itemInfo = {
							x = pedX,
							y = pedY,
							z = pedZ,
							model = consumableItems[1].model,
							pickupItemData = items,
							owner = GetPlayerServerId(PlayerId()), -- ideally, this should never be PlayerId(), but added it just in case.
							ownerName = GetPlayerName(PlayerId()),
							spawned = false
						}
						writeLog("\nBOSS DROP SHOULD BE CREATED", 1)
						TriggerServerEvent("registerPickup", itemInfo,true)
						SetEntityHealth(ped, 0)
					end
					
					
				end
				--[[
				if GetPedSourceOfDeath(ped) == PlayerPedId() then
					zombiekillsthislife = zombiekillsthislife+1
					zombiekills = zombiekills+1
					local money = consumableItems.count[17]
					consumableItems.count[17] = math.round(money+10)
				end
				--]]
				local cod = GetPedSourceOfDeath(ped)
				local weap = GetPedCauseOfDeath(ped)
				if cod ~= 0 and NetworkGetPlayerIndexFromPed(cod) then
					TriggerServerEvent("s_killedZombie",GetPlayerServerId(NetworkGetPlayerIndexFromPed(cod)),weap)
				end
				
				
				
				table.insert(peddeletionqueue, ped)
				
				table.remove(zombies, i)
			else
				playerX, playerY = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				if GetPedArmour(ped) <= 90 then
					SetPedArmour(ped, GetPedArmour(ped)+5)
				end
				SetPedAccuracy(ped, 25)
				SetPedSeeingRange(ped, 20.0)
				SetPedHearingRange(ped, 65.0)
	
				SetPedFleeAttributes(ped, 0, 0)
				SetPedCombatAttributes(ped, 16, 1)
				SetPedCombatAttributes(ped, 17, 0)
				SetPedCombatAttributes(ped, 46, 1)
				SetPedCombatAttributes(ped, 1424, 0)
				SetPedCombatAttributes(ped, 5, 1)
				SetPedCombatRange(ped,1)
				SetAmbientVoiceName(ped, "ALIENS")
				SetPedEnableWeaponBlocking(ped, true)
				SetPedRelationshipGroupHash(ped, GetHashKey("zombeez"))
				DisablePedPainAudio(ped, true)
				SetPedDiesInWater(ped, false)
				SetPedDiesWhenInjured(ped, false)
				if GetDistanceBetweenCoords(pedX, pedY, 0.0, playerX, playerY, 0.0, false) > 135.0 then
					-- Set ped as no longer needed for despawning
					local model = GetEntityModel(ped)
					DeleteEntity(ped)
					SetModelAsNoLongerNeeded(model)
					--table.remove(zombies, i) -- the first check takes care of this 
				end
			end
		end
	end
end)

-- ped assignment
Citizen.CreateThread(function()
	while true do
		Wait(1000)
		local handle, ped = FindFirstPed()
		local finished = false -- FindNextPed will turn the first variable to false when it fails to find another ped in the index
		repeat
			Wait(20)
			if not IsPedAPlayer(ped) and not IsPedDeadOrDying(ped, true) and DecorGetBool(ped, "zombie") and not DecorGetBool(ped, "MissionPed") and not DecorGetBool(ped, "bandit") and NetworkHasControlOfEntity(ped) then
				local ownedByMe = false
				local CanNotControl = false
				for i,zombie in pairs(zombies) do
					if ped == zombie then
						ownedByMe = true
					end
				end
				for i,bandit in pairs(bandits) do
					if ped == bandit then
						CanNotControl = true
					end
				end
				for i,animal in pairs(animals) do
					if ped == animal then
						CanNotControl = true
					end
				end

				if NetworkHasControlOfEntity(ped) and (not ownedByMe and not CanNotControl) then
					table.insert(zombies, ped)
					writeLog("\nFound homeless zombie "..ped..", lets give him a home :heart:!\n", 1)
				end
			end
			finished, ped = FindNextPed(handle) -- first param returns true while entities are found
		until not finished
		EndFindPed(handle)
	end
end)



-- boss light
Citizen.CreateThread(function()
	while true do
		Wait(1)
		for i,ped in pairs(zombies) do
			if DecorGetInt(ped, "IsBoss") == 1 then
				pedX, pedY, pedZ = table.unpack(GetEntityCoords(ped, true))
				DrawLightWithRangeAndShadow(pedX, pedY, pedZ + 0.4, 255, 0, 0, 4.0, 50.0, 5.0)
			end
		end
	end
end)
	

Citizen.CreateThread(function()
	while true do
		Wait(math.random(5000,15000))
		for i, ped in pairs(peddeletionqueue) do
			local model = GetEntityModel(ped)
			DeleteEntity(ped)
			SetModelAsNoLongerNeeded(model)
			table.remove(peddeletionqueue,i)
		end
	end
end)
	

RegisterNetEvent("Z:cleanup")
AddEventHandler("Z:cleanup", function()
	for i, ped in pairs(zombies) do
		-- Set ped as no longer needed for despawning
		local model = GetEntityModel(ped)
		SetModelAsNoLongerNeeded(model)
		SetEntityAsNoLongerNeeded(ped)

		table.remove(zombies, i)
	end
end)
