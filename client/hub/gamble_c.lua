
Wheel = {
    Active = false,
    Config = {WheelType=1, SegmentCount=5, SpectatorWheel=false},
    SegmentInfo = {}
}

Citizen.CreateThread(function()
	function startRewardTimeout(result,segments,wintext)
		local result = result
		local segments = segments
		SetTimeout(12000, function()
			TriggerEvent("showNotification", wintext)
			if segments[result].type == "money" then
				consumableItems.count[17]=consumableItems.count[17]+segments[result].value
				TriggerServerEvent("AddLegitimateMoney", segments[result].value)
			elseif segments[result].type == "item" then
				consumableItems.count[segments[result].item]=consumableItems.count[segments[result].item]+1
			elseif segments[result].type == "health" then
				SetEntityHealth(PlayerPedId(), 200)
			elseif segments[result].type == "armor" then
				SetPedArmour(PlayerPedId(), 100)
			elseif segments[result].type == "weapon" then
				GiveWeaponToPed(PlayerPedId(), segments[result].hash, GetWeaponClipSize(segments[result].hash), false, true)
			elseif segments[result].type == "spin" then
				wheelspins = wheelspins+segments[result].value
			end
		end)
		SetTimeout(15000, function()
			Wheel.Hide()
			if segments[result].type ~= "spin" and oldwheelspins <= wheelspins then
				TriggerServerEvent("Z:kickme", "Segment Data Incorrect, Please Report this at discord.gg/2SdrPFF ( DEBUG DATA: "..segments[result].type.." "..oldwheelspins.." "..wheelspins.." "..segments[result].value)
				TriggerServerEvent("SentryIO_Error", "Wheelspin Segment Data Incorrect", "Segment Data Incorrect,  DEBUG DATA: Type:"..segments[result].type.." Old:"..oldwheelspins.." New:"..wheelspins.." Reward:"..segments[result].value)
			end
		end)
	end
end)


Citizen.CreateThread(function()

	RegisterNetEvent("RequestWheelspinResult")
	AddEventHandler("RequestWheelspinResult", function(result, winicon, wintext, type, segments)
		Wheel.SetStyle(type,#segments,false)
		for i,segment in ipairs(segments) do
			Wheel.SetSegment(i-1, segment.id, segment.value)
    end
		local segments = segments
		TriggerEvent("showNotification", "Wheelspin Request Granted!")
		Wheel.Running = true
		Wheel.Show()
		Wheel.Spin(result, 5, 10, 10, winicon+1, wintext)
		local result = result+1
		startRewardTimeout(result,segments,wintext)
		while Wheel.Active do
			Citizen.Wait(0)
			Wheel.Scaleform:Draw2D()
		end
	end)
end)

--[[
RegisterCommand("spin", function()
	if Wheel.Running == true then
		TriggerEvent("showNotification", "Wheelspin Already in Progress!")
		return false
	end
	oldwheelspins = wheelspins
	wheelspins = wheelspins-1
	Wheel.Init()
	TriggerEvent("showNotification", "Requesting Wheelspin...")
	TriggerServerEvent("RequestWheelspinResult")
	
end, false)
]]

Citizen.CreateThread(function()
	WarMenu.CreateMenu('gamble', 'Wheel of Fortune')
	WarMenu.SetSubTitle('gamble', 'Wheel of Fortune')
	while true do
		if WarMenu.IsMenuOpened('gamble') then
			WarMenu.SetSubTitle('locker', 'Current Balance: $'..locker_money)
			
			if WarMenu.Button('Spin the Wheel!', wheelspins..' Spins Left!') then
				if wheelspins < 1 then
					TriggerEvent("showNotification", "No Wheelspins available!")
				elseif Wheel.Running then
					TriggerEvent("showNotification", "Wheelspin already in Progress!")
				else
					oldwheelspins = wheelspins
					wheelspins = wheelspins-1
					
					Wheel.Init()
					TriggerEvent("showNotification", "Requesting Wheelspin...")
					TriggerServerEvent("RequestWheelspinResult")
				end
				
--[[			elseif WarMenu.Button('Buy Spin', "$loadsamone") then
				TriggerEvent("showNotification", "Not Yet.")]]
			end
			WarMenu.Display()
		end
		Citizen.Wait(0)
	end
end)

function Wheel.Init()
    Wheel.Scaleform = Scaleform.Request("SPIN_THE_WHEEL") --if u dont get this u dumb
end

function Wheel.Show()
    Wheel.Active = true -- the fuck would you really expect this to do tbf
end

function Wheel.Hide()
    Wheel.Active = false
    Wheel.Scaleform:Dispose() -- fucking self explanatory okay cunt
    Wheel.Scaleform = nil
		Wheel.Running = false
end

local function UpdateWheelStyle() -- dont touch bitch
    if Wheel.Scaleform then
        Wheel.Scaleform:CallFunction("SET_WHEEL_STYLE", Wheel.Config.WheelType, Wheel.Config.SegmentCount, Wheel.Config.SpectatorWheel)
        Wheel.SegmentInfo = {}

        for i=1, Wheel.Config.SegmentCount do
            Wheel.SegmentInfo[i] = {Type=1, Value=""}
        end
    end
end

function Wheel.SetStyle(WheelType, SegmentCount, SpectatorWheel) -- WheelType: fuck knows, SegmentCount: Amount of options or whatever you call it, SpectatorWheel: dunno
    Wheel.Config.WheelType = WheelType
    Wheel.Config.SegmentCount = SegmentCount
    Wheel.Config.SpectatorWheel = SpectatorWheel
    UpdateWheelStyle()
end

local function RefreshSegments() -- no touchy
    for i=1, #Wheel.SegmentInfo do
        Wheel.Scaleform:CallFunction("SET_SEGMENT", i-1, Wheel.SegmentInfo[i].Type, Wheel.SegmentInfo[i].Value)
    end
end

function Wheel.SetSegment(index, type, value) -- index start at 0 okay, type: icon and text if preset exists, value: sets a value for EG. money/rp reward
    Wheel.SegmentInfo[index + 1].Type = type
    Wheel.SegmentInfo[index + 1].Value = value
    RefreshSegments()
end

function Wheel.Spin(WinningIndex, FullSpinCount, Duration, WinnerDuration, WinIcon, WinMessage) -- index of the segment which will win, how many spins will it do before stopping, duration in seconds, how long to show message in seconds, icon of winning, text to display under the icon
    Wheel.Scaleform:CallFunction("SPIN_WHEEL", WinningIndex, FullSpinCount, Duration, WinnerDuration, WinIcon, WinMessage)
end
