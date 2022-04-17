local webhook = "WEBHOOK_URL"


Users = {}
violations = {}



hashValidatedUsers = {}

Citizen.CreateThread(function()
	AddEventHandler('playerDropped', function(reason)
		local source = source
		local sname = GetPlayerName(source)
		for i,user in pairs(hashValidatedUsers) do
			if user.identifier == GetPlayerIdentifier(source,1) then
				table.remove(hashValidatedUsers,i)
			end
		end
	end)
end)


local function RemovePlayerFromHashCheck(username,identifier)
	for i,user in pairs(hashValidatedUsers) do
		if user.identifier == identifier then
			table.remove(hashValidatedUsers,i)
		end
	end
end




Citizen.CreateThread(function()
	AddEventHandler('playerConnecting', function(playerName)
		table.insert(hashValidatedUsers, { identifier = GetPlayerIdentifier(source,1), joining = true, waitTime = 0, verified = false, hashes = FilesHashesToVerify })
	end)
end) 



Citizen.CreateThread(function()
	ServerReady = true
end)



Citizen.CreateThread(function()
	AddEventHandler("scrambler:injectionDetected", function(e,p)
		TriggerEvent("RottenV:FuckCheaters", p,"Executed Scrambled Event", "Tried to Execute "..e.." without Permission.",true)
	end)
		
	RegisterServerEvent("RottenV:Fuckme")
	AddEventHandler('RottenV:FuckMe', function(reason,extrainfo,banInstantly)
		TriggerEvent("RottenV:FuckCheaters", source, reason,extrainfo,banInstantly)
	end)
	
	AddEventHandler('RottenV:FuckCheaters', function(player,reason,extrainfo,banInstantly)
		local source = player
		if not IsPlayerAceAllowed(source,"anticheese.bypass") then
			local license, steam = GetPlayerNeededIdentifiers(source)
			local name = GetPlayerName(source)
			if not extrainfo then extrainfo = "no extra informations provided" end
			if banInstantly then
				for i,thePlayer in ipairs(violations) do
					if thePlayer.name == name then
						violations[i].count = 2
					end
				end
			end
			local isKnown, isKnownCount, isKnownExtraText = WarnPlayer(name,reason,source)
			if banInstantly then 
				SendWebhookMessage(webhook,"**"..reason.."** \n```\nUser:"..name.."\n"..license.."\n"..steam.."\n"..extrainfo.."\nWas Banned.```")
			else
				SendWebhookMessage(webhook,"**"..reason.."** \n```\nUser:"..name.."\n"..license.."\n"..steam.."\n"..extrainfo.."\nAnticheat Flags:"..isKnownCount..""..isKnownExtraText.." ```")
			end
		end
	end)
	
	AddEventHandler('RottenV:CheatingNotification', function(player,reason,extrainfo)
		local source = player
		local license, steam = GetPlayerNeededIdentifiers(source)
		local name = GetPlayerName(source)
		if not extrainfo then extrainfo = "no extra informations provided" end
		SendWebhookMessage(webhook,"**"..reason.."** \n```\nUser:"..name.."\n"..license.."\n"..steam.."\n"..extrainfo.."```")
	end)
	
	function SendWebhookMessage(webhook,message)
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
	
	function WarnPlayer(name, reason, playerid)
		local isKnown = false
		local isKnownCount = 1
		local isKnownExtraText = ""
		for i,thePlayer in ipairs(violations) do
			if thePlayer.name == name then
				isKnown = true
				if violations[i].count == 2 then
					TriggerEvent("EasyAdmin:addBan", playerid, "Cheating")
					isKnownCount = violations[i].count
					table.remove(violations,i)
					isKnownExtraText = ", was banned."
				else
					violations[i].count = violations[i].count+1
					isKnownCount = violations[i].count
				end
			end
		end
		if not isKnown then
			table.insert(violations, { id = playerid,name = name, count = 1 })
		end
		return isKnown, isKnownCount,isKnownExtraText
	end

	function GetPlayerNeededIdentifiers(player)
		local ids = GetPlayerIdentifiers(player)
		for i,theIdentifier in ipairs(ids) do
			if string.find(theIdentifier,"license:") or -1 > -1 then
				license = theIdentifier
			elseif string.find(theIdentifier,"steam:") or -1 > -1 then
				steam = theIdentifier
			end
		end
		if not steam then
			steam = "steam: missing"
		end
		return license, steam
	end




end)






-- event table, add your own resource/events here.

events = {
	{
		name = 'esx_society',
		events = {
			'esx_society:openBossMenu',
			'esx_society:setJobSalary',
		}
	},
	{
		name = 'esx_truckerjob',
		events = {
			'esx_truckerjob:pay',
		}
	},
	{
		name = 'esx_slotmachine',
		events = {
			'esx_slotmachine:sv:2',
		}
	},
	{
		name = 'esx',
		events = {
			'esx:spawnVehicle',
			'esx:teleport',
		}
	},
	{
		name = 'esx_vehicleshop',
		events = {
			'esx_vehicleshop:putStockItems',
		}
	},
	{
		name = 'esx_ambulancejob',
		events = {
			'esx_ambulancejob:revive',
		}
	},
	{
		name = 'esx_property',
		events = {
			'esx_property:buyProperty',
		}
	},
	{
		name = 'nb_menuperso',
		events = {
			'AdminMenu:giveDirtyMoney',
			'AdminMenu:giveBank',
			'AdminMenu:giveCash',
		}
	},
	{
		name = 'esx_billing',
		events = {
			'esx_billing:sendBill',
		}
	},
	{
		name = 'esx_policejob',
		events = {
			'esx_policejob:handcuff',
			'esx_policejob:giveWeapon',
			'esx_policejob:drag',
			'esx_policejob:putInVehicle',
			'esx_policejob:OutVehicle',
		}
	},
	{
		name = 'esx_drugs',
		events = {
			'esx_drugs:startHarvestCoke',
			'esx_drugs:startHarvestMeth',
			'esx_drugs:startHarvestWeed',
			'esx_drugs:startHarvestOpium',
		}
	},
	{
		name = 'esx_mecanojob',
		events = {
			'esx_mecanojob:startHarvest',
			'esx_mecanojob:stopHarvest',
			'esx_mecanojob:startHarvest2',
			'esx_mecanojob:startHarvest3',
			'esx_mecanojob:startCraft',
			'esx_mecanojob:startCraft2',
			'esx_mecanojob:startCraft3',
		}
	},
	{
		name = 'esx_weashop',
		events = {
			'esx_weashop:buyItem',
		}
	},
	{
		name = 'esx_jailer',
		events = {
			'esx_jailer:unjailTime',
		}
	},
	{
		name = 'vrp_taxi',
		events = {
			'taxi:success',
		}
	},
	{
		name = 'anticheese-anticheat',
		events = {
			'anticheese:SetAllComponents',
			'anticheese:SetComponentStatus',
			'anticheese:ToggleComponent',
		}
	},
	{
		name = 'mellotrainer',
		events = {
			'mellotrainer:adminKick',
			'mellotrainer:adminTempBan',
			'mellotrainer:s_adminKill',
			'mellotrainer:s_adminTp',
			'mellotrainer:adminTime',
			'mellotrainer:adminWeather',
			'mellotrainer:adminBlackout',
			'mellotrainer:adminWind',
		}
	},
}

activeEvents = {}

Citizen.CreateThread(function()
	
	function BanPlayer(p,event,typ,args)
		if not p then p = source end
		local argstring = ""
		for i,arg in pairs(args) do -- generate argument string
			if type(arg) == "string" then
				arg = '"'..arg..'"'
			end
			arg = tostring(arg)
			argstring = argstring..arg
			if i ~= #args then
				argstring = argstring..","
			end
		end
		
		--writeLog(GetPlayerName(source).." tried to run "..typ.." event "..event.."( "..argstring.." )\n", 1)
		TriggerEvent("RottenV:FuckCheaters", p,"Executed Scrambled Event", "Tried to Execute "..event.." ("..argstring..") on the "..typ.." without Permission.",true)
	end
	
	RegisterServerEvent("BaitEvents:DetectedCheat")
	RegisterServerEvent("BaitEvents:RequestEvents")
	
	AddEventHandler("BaitEvents:DetectedCheat", BanPlayer)
	
	AddEventHandler("BaitEvents:RequestEvents", function()
		TriggerClientEvent("BaitEvents:RecieveEvents", source, activeEvents)
	end)
	local registeredEvents = 0
	for i,resource in pairs(events) do
		if true then
			events[i].active = true
			for i,event in pairs(resource.events) do
				RegisterServerEvent(event)
				AddEventHandler(event, function(...)
					local arg = {...}
					BanPlayer(source,event, "SERVER", arg)
				end)
				table.insert(activeEvents, event)
				TriggerClientEvent("BaitEvents:AddEvent", -1, event)
				registeredEvents = registeredEvents+1
			end
		end
	end
end)







--[[ this is now unusable 
EVENT_PREFIXES = {
    "esx_society",
    "esx_truckerjob",
    "esx_policejob",
    "esx_mecanojob",
    "esx_phone",
    "esx_drugs",
    "esx_taxijob",
    "esx_shops",
    "esx_ambulancejob",
    "esx_jobs",
    "esx_bankerjob",
    "esx_service",
    "esx_realestateagentjob",
    "esx",
    "esx_slotmachine",
}

EVENT_NAMES = {
    "openBossMenu",
    "setJob",
    "customerDeposit",
    "customerWithdraw",
    "pay",
    "sv:2",
    "sv:1",
    "v:2",
    "v:1",
}

for _, prefix in next, EVENT_PREFIXES do
    for _, name in next, EVENT_NAMES do
        local eventname = prefix .. ":" .. name
        RegisterNetEvent(eventname)
        AddEventHandler(eventname, function()
            local source = source
            TriggerEvent("RottenV:FuckCheaters", source, "Calling ESX Events","Tried to call "..eventname..", even though we dont even run ESX, dumbass.")
        end)
    end
end

]]

