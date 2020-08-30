blackoutEnabled = true
-- 1800, 7200
local blackoutTime = math.floor(math.random(1800,7200)) -- 30 minutes - 120 minutes?

RegisterServerEvent("ActivatePower")
AddEventHandler("ActivatePower", function(name)
    TriggerClientEvent("togglePower", -1, true)
		blackoutEnabled = false
    TriggerClientEvent("showNotification",-1,"~g~Power Grid Restored!~n~~s~Survivor ~o~"..name.."~s~ has successfully restored the power!")
end)

RegisterServerEvent("CutPower")
AddEventHandler("CutPower", function()
    TriggerClientEvent("togglePower", -1, false)
    blackoutEnabled = true
end)

RegisterServerEvent("disableRepairAction")
AddEventHandler("disableRepairAction", function(disable, station)
    TriggerClientEvent("disableRepairAction", -1, disable, station)
end)


RegisterServerEvent("Z:newplayerID")
AddEventHandler("Z:newplayerID", function(id)
    TriggerClientEvent("togglePower", id, not blackoutEnabled)
end)

Citizen.CreateThread(function()
  while true do
    Wait(1000)
    if not blackoutEnabled then
      blackoutTime = blackoutTime - 1
      if blackoutTime <= 0 then
        blackoutEnabled = true
        blackoutTime = math.floor(math.random(1800,7200))
        TriggerClientEvent("togglePower", -1, false)
        TriggerClientEvent("showNotification",-1,"~r~Power generators have malfunctioned!~n~~s~Go repair them again to turn the power back on!")
      end
    end
  end
end)
