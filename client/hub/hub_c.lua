local menus = {"itemstore", "gamble", "wepstore", "buyitem", "sellitem", "buywep","buyattach", "sellwep","quests","skinstore","buyskin","locker"}


function DrawText3D(x,y,z,drawdist,text)
    SetDrawOrigin(x, y, z, 0)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.0, 0.53)
    SetTextColour(19, 232, 46, 240)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function HelpText(text)
  SetTextComponentFormat("STRING")
  AddTextComponentString(text)
  DisplayHelpTextFromStringLabel(0, 0, 0, -1)
end

Citizen.CreateThread(function()
	
	for i,quest in ipairs(Quests) do
		table.insert(menus, quest.name)
	end
	
	for i,Stall in pairs(Stores) do
		if Stall.model then
			Stall.model = GetHashKey(Stall.model)
		else
			Stall.model = GetHashKey("prop_protest_table_01")
		end
		local StallObj = CreateObject(Stall.model, Stall.location[1], Stall.location[2], Stall.location[3], false, false, false)
		FreezeEntityPosition(StallObj, true)
		SetEntityHeading(StallObj, Stall.location[4])
		
		
		local blip = AddBlipForCoord(Stall.location[1], Stall.location[2], Stall.location[3]) -- blip creation
		SetBlipSprite(blip, Stall.blip)
		SetBlipColour(blip, 4)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Stall.name)
		EndTextCommandSetBlipName(blip)
		
	end 
	InStore = false
	NearStore = false
	CurrentStore = 0
	while true do
		Citizen.Wait(0)
		NearStore = false
		for i,Stall in pairs(Stores) do
			if #(GetEntityCoords(PlayerPedId(), true) - vector3(Stall.location[1], Stall.location[2], Stall.location[3])) <= 10 then
				NearStore = true
				if not InStore then
					HelpText("Press ~INPUT_CONTEXT~ to enter the ~g~"..Stall.name)
					DrawText3D(Stall.location[1], Stall.location[2], Stall.location[3]+1.3, 10.0, Stall.name)
				end
				if IsControlJustPressed(0, 51) and not InStore then
					InStore = true
					CurrentStore = i
					Wait(100)
					WarMenu.OpenMenu(Stall.wmid)
				elseif WarMenu.IsMenuOpened(Stall.wmid) and not InStore then
					WarMenu.CloseMenu()
				end
			end
		end
		local MenuFound = false
		for i,Menu in pairs(menus) do
			if WarMenu.IsMenuOpened(Menu) then 
				MenuFound = true
			end
			if not NearStore and WarMenu.IsMenuOpened(Menu) then
				writeLog("\nClosing", 1)
				WarMenu.CloseMenu()
			end
		end
		if not MenuFound and InStore then
			writeLog("\nmenu not found, but player is in store, exiting", 1)
			InStore = false
			CurrentStore = 0
		end
	end
end)