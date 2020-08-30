RegisterServerEvent("AirdropStarted")
RegisterServerEvent("AirdropLanded")
RegisterServerEvent("AirdropFailed")
RegisterServerEvent("RegisterAirdropPlane")
RegisterServerEvent("TellAirdropToFuckOffAndUnregister")




AddEventHandler("AirdropStarted", function(x,y,z)
	TriggerClientEvent("showNotification", -1, "An ~y~Airdrop~s~ has been called in by a player.")
	TriggerClientEvent("addAirdropBlip", -1, x,y,z)
end)

AddEventHandler("AirdropFailed", function(x,y,z)
	TriggerClientEvent("removeAirdropBlip", -1, x,y,z)
end)

AddEventHandler("AirdropLanded", function(x,y,z)
	TriggerClientEvent("removeAirdropBlip", -1, x,y,z)
end)

AddEventHandler("RegisterAirdropPlane", function(info)
	TriggerClientEvent("RegisterAirdropPlane", -1,info)
end)

AddEventHandler("TellAirdropToFuckOffAndUnregister", function(info)
	TriggerClientEvent("TellAirdropToFuckOffAndUnregister", -1,info)
end)
