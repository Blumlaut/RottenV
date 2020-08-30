RegisterNetEvent("Z:killplayer")

AddEventHandler("Z:killplayer", function()
	SetEntityHealth(PlayerPedId(), 1)
end)