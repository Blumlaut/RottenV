RegisterServerEvent("CheckMyPing")
AddEventHandler("CheckMyPing", function()
	local hostname = GetConvar("sv_hostname", "this will never be the case anyway")
	local pingstring = ""
	if string.find(hostname, "#1") then
		pingstring = "Looks like your ping is %s right now, i recommend you try joining our American Server ( 185.249.196.62:32030 )."
	else
		pingstring = "Looks like your ping is %s right now, i recommend you try joining our European Server ( 185.239.238.158:30120 )."
	end


	if GetPlayerPing(source) > 130 then
		TriggerClientEvent("chat:addMessage", source, { templateId = "defaultAlt", args = { string.format(pingstring, GetPlayerPing(source)) } })
	end
end)