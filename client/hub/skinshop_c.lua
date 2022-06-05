
local clickedAmount = 0
local clickedButton = 0
local SelectionScreen = false
local ped = nil
local savedHunger,savedThirst,savedWeapons = 0.0,0.0,{}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if SelectionScreen and ped ~= nil then
			local rot = GetEntityHeading(ped)
			SetEntityHeading(ped, rot + 1.0)
			HideHudAndRadarThisFrame()
		end
	end
end)




Citizen.CreateThread(function()
	local function SwitchSkin(skin,coords)
		RequestModel(skin)
		while not HasModelLoaded(skin) do
			Wait(250)
		end
		if ped ~= nil then
			SetEntityAsMissionEntity(ped, 1, 1)
			DeleteEntity(ped)
			ped = nil
		end
		ped = CreatePed(1, GetHashKey(skin), coords[1], coords[2], coords[3], coords[4], true, true)
		SetEntityInvincible(ped, true)
		SetEntityProofs(ped, true, true, true, true, true, true, true, true)
		Entity(ped).state:set("C8pE53jw", true, true)
		SetPedRandomComponentVariation(ped, true)
		SetPedRandomProps(ped)
	end
	
	local function ExitSkinCam()
		if ped ~= nil then
			SetEntityAsMissionEntity(ped, 1, 1)
			DeleteEntity(ped)
			ped = nil
		end
		SetFollowPedCamViewMode(1)
		RenderScriptCams(false, 0, 0, true, true)
		EnableAllControlActions(0)
		FreezeEntityPosition(PlayerPedId(), false)
		SelectionScreen = false
	end
	
	local function init(coords)
		CreationCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
		SetCamCoord(CreationCam, coords[1], coords[2], coords[3])
		SetCamRot(CreationCam, 0.0, 0.0, coords[4])
		SetCamFov(CreationCam, 60.0)
	end
	
	function ButtonMessage(text)
	    BeginTextCommandScaleformString("STRING")
	    AddTextComponentScaleform(text)
	    EndTextCommandScaleformString()
	end
	
	function Button(ControlButton)
	    N_0xe83a3e3557a56640(ControlButton)
	end
	
	
	local function BeginCameraIn(model,camcoords,pedcoords)
		loadingSkin = true
		DoScreenFadeOut(1500)
		Wait(2500)
		init(camcoords)
		FreezeEntityPosition(PlayerPedId(), true)
		DisableAllControlActions(0)
		SetGameplayCamRelativeHeading(80.0)
		SetFollowPedCamViewMode(4)
		Wait(1000)
		SwitchSkin(model,pedcoords)
		DoScreenFadeIn(2500)
		RenderScriptCams(true, 1, 5000, true, true)
		SelectionScreen = true
		loadingSkin = false
	end
	

	
	WarMenu.CreateMenu('skinstore', 'Clothing Store')
	WarMenu.SetSubTitle('skinstore', 'Clothing Store')
	WarMenu.CreateSubMenu('buyskin', 'skinstore', "DOWNLOAD CLOTHING")
	
	while true do
		if WarMenu.IsMenuOpened('skinstore') then
			ExitSkinCam()
			if WarMenu.MenuButton('Purchase Skins', 'buyskin') then
			end
			WarMenu.Display()
			
		elseif SelectionScreen and ped and not WarMenu.IsMenuOpened('buyskin') then
			ExitSkinCam()
			
		elseif WarMenu.IsMenuOpened('buyskin') then
			
			if not SelectionScreen then
				loadingSkin = true
				BeginCameraIn("s_m_y_armymech_01", Stores[CurrentStore].camcoords, Stores[CurrentStore].pedcoords)
				repeat
					Wait(1)
				until SelectionScreen
			end
				
			for item,Ped in ipairs(BuyablePeds) do
				if Ped.price then
					local AlreadyOwned = (GetEntityModel(PlayerPedId()) == Ped.model)
					local ExtraText = IfTrueDraw(AlreadyOwned, " ~g~[OWNED]", "x%s")
					local ModelPrice = math.floor(Ped.price * (1+(calculateBonuses(humanity)/100) ))
					if Ped.price < 1 then
						DisplayPrice = "UNAVAILABLE"
					else 
						if clickedAmount == 1 and clickedButton == item then
							DisplayPrice = "[PREVIEW] $"..math.floor(Ped.price * (1+(calculateBonuses(humanity)/100) ))
						else
							DisplayPrice = "$"..math.floor(Ped.price * (1+(calculateBonuses(humanity)/100) ))
						end
					end
					
					if WarMenu.Button(Ped.name, DisplayPrice) then
						savedHunger,savedThirst,savedWeapons,attaches = LocalPlayer.state.hunger,LocalPlayer.state.thirst,{},{}
						for i,theItem in ipairs(consumableItems) do
							local ammocount = consumableItems.count[i]
							local attaches = {}
							if consumableItems[i].isWeapon then
								if HasPedGotWeapon(PlayerPedId(), consumableItems[i].hash, false) then
									ammocount = GetAmmoInPedWeapon(PlayerPedId(), consumableItems[i].hash)
									for _,attachment in ipairs(weaponComponents) do
										if DoesWeaponTakeWeaponComponent(consumableItems[i].hash, GetHashKey(attachment.hash)) and HasPedGotWeaponComponent(PlayerPedId(), consumableItems[i].hash, GetHashKey(attachment.hash)) then
											table.insert(attaches, attachment.hash)
										end
									end
								else
									count = 0
								end
							end
							if #attaches == 0 then
								attaches = nil
							end

							table.insert(savedWeapons, {item = theItem.name, count = ammocount, attachments = attaches})
						end
									
						if clickedButton ~= item then
							clickedButton = item
							clickedAmount = 1
							SwitchSkin(Ped.model, Stores[CurrentStore].pedcoords)
						elseif clickedButton == item then
							if clickedAmount == 1 then
								clickedAmount = 2
							end
						
							if Ped.price < 1 then
								TriggerEvent('showNotification', "This Item is Unavailable at this time, please try again later.")
								clickedAmount = 0
							else
								local money = consumableItems.count[17]
								if ModelPrice <= money and not AlreadyOwned then
									TriggerEvent('showNotification', "Successfully purchased!")
									consumableItems.count[17] = math.round(money-ModelPrice)
									TriggerServerEvent("AddLegitimateMoney", -ModelPrice)
									TriggerServerEvent("SetPlayerSkin", item)
									SetPlayerModel(PlayerId(), Ped.model)
									SetPedRandomComponentVariation(PlayerPedId(), true)
									Wait(200)
									LocalPlayer.state.hunger = savedHunger
									LocalPlayer.state.thirst = savedThirst
									for i,w in ipairs(savedWeapons) do
										consumableItems.count[i] = w.count
										if consumableItems[i].isWeapon and w.count ~= 0 then
											GiveWeaponToPed(PlayerPedId(), consumableItems[i].hash, w.count, false, false)
											if w.attachments then
												for _,attachment in pairs(w.attachments) do
													if DoesWeaponTakeWeaponComponent(consumableItems[i].hash, GetHashKey(attachment)) then
														GiveWeaponComponentToPed(PlayerPedId(), consumableItems[i].hash, GetHashKey(attachment))
													end
												end
											end
										end
									end
									
								elseif ModelPrice >= money and not AlreadyOwned then
									TriggerEvent('showNotification', "Cannot purchase:~n~Missing: ~r~$"..ModelPrice-money)
								end
								clickedAmount = 0
							end
						end
					end
				end
			end
			WarMenu.Display()
		end 
		Citizen.Wait(0)
	end
end)