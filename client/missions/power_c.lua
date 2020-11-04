powerareas = {
    {disabled = false, name = "Palmer Taylor Power Station", x = 2834.53, y = 1568.78, z = 23.68, heading = 251.64, actionX = 2834.74, actionY = 1568.78, actionZ = 24.00},
    {disabled = false, name = "Power Plant", x = 534.07, y = -1598.01, z = 28.14, heading = 228.47, actionX = 534.02, actionY = -1598.01, actionZ = 29.14},
}

repairing = false
time = math.floor(math.random(5, 180)) -- Repair time
cooldown = 0
blackout = true
firstspawn = true
stationIAmRepairing = ""

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if repairing and time > 0 then
            Citizen.Wait(1000)
            time = time - 1
        end
        if not repairing and cooldown > 0 then
            Citizen.Wait(1000)
            cooldown = cooldown - 1
        end
    end
end)

Citizen.CreateThread(function()
    for k,v in pairs(powerareas) do
        blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, 402)
        SetBlipColour(blip, 1)
        BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v.name)
		EndTextCommandSetBlipName(blip)
    end
    while true do
        Citizen.Wait(0)
        for k,v in pairs(powerareas) do
          if blackout and not v.disabled then
              DrawMarker(1, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 25, 200, 25, 150, false, false, 0, false, 0, 0, false)
          end
          playerCoords = GetEntityCoords(PlayerPedId(), true)
          if #(playerCoords - vector3(v.x, v.y, v.z)) < 2.0 and not repairing and blackout and stationIAmRepairing == "" then
              if cooldown == 0 and not v.disabled and not IsPedInAnyVehicle(PlayerPedId(), true) then
                HelpText("Press ~INPUT_CONTEXT~ to begin repairing the transformer")
                if IsControlJustPressed(1, 51) then -- BEGIN
                    repairing = true
                    stationIAmRepairing = v.name
                    TriggerServerEvent("disableRepairAction", true, stationIAmRepairing)
                    AddRichPresence("Repairing the Power Station")
                end
              elseif cooldown > 0 then
                HelpText("You must wait ~r~"..cooldown.."~s~ seconds before attempting to repair again")
              elseif IsPedInAnyVehicle(PlayerPedId(), true) then
                HelpText("You cannot repair the transformer while in a vehicle")
              end
          end
          if repairing and time > 0 and v.name == stationIAmRepairing then
              HelpText("Press ~INPUT_VEH_EXIT~ to cancel repair")
              DrawMissionText("Hold off the transformer for ~g~"..time.."~s~ Seconds!",200,true)
              if IsControlJustPressed(1, 75) and repairing then -- CANCEL
                  repairing = false
                  time = math.floor(math.random(60, 180))
                  cooldown = 10
                  ClearPedTasks(PlayerPedId())
                  TriggerServerEvent("disableRepairAction", false, stationIAmRepairing)
                  stationIAmRepairing = ""
              end
              if not IsPedActiveInScenario(PlayerPedId()) and repairing then
                  TaskStartScenarioAtPosition(PlayerPedId(), "WORLD_HUMAN_WELDING", v.actionX, v.actionY, v.actionZ, v.heading, 0, false, true)
              end
          elseif repairing and time == 0 and v.name == stationIAmRepairing then
              ClearPedTasks(PlayerPedId())
              HelpText("Successfully repaired the transformer! ~n~Power: ~g~Online~s~!")
              TriggerServerEvent("ActivatePower", GetPlayerName(PlayerId()) ) -- Trigger the event to activate power for everyone
              Wait(500)
							humanity = humanity+100.0
              repairing = false
              TriggerServerEvent("disableRepairAction", false, stationIAmRepairing)
              stationIAmRepairing = ""
          end
        end
        if repairing and GetEntityHealth(PlayerPedId()) <= 0 then
            repairing = false
            TriggerServerEvent("disableRepairAction", false, stationIAmRepairing)
            stationIAmRepairing = ""
            ClearPedTasks(PlayerPedId())
        end
    end
end)

RegisterNetEvent("togglePower")
AddEventHandler("togglePower", function(state)
    SetBlackout(not state)
    blackout = not state
		if state == true then
	    time = 5
		else
			repairing = false
		end
end)

RegisterNetEvent("disableRepairAction")
AddEventHandler("disableRepairAction", function(disabled, station)
  for i,j in pairs(powerareas) do
    if j.name == station then
      j.disabled = disabled
      powerareas[i] = j
      break
    end
  end
end)

function HelpText(text, state)
  SetTextComponentFormat("STRING")
  AddTextComponentString(text)
  DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

function DrawMissionText(text,displaytime,drawimmdeiately)
    BeginTextCommandPrint("STRING")
    AddTextComponentString(text)
    EndTextCommandPrint(displaytime,drawimmdeiately)
end

AddEventHandler('playerSpawned', function(spawn) -- Sync up newcomers so that they see the blackout/no blackout too
    if firstspawn then
        if blackout then
            SetBlackout(true)
        else
            SetBlackout(false)
        end
        firstspawn = false
    end
    if repairing then
        repairing = false
        TriggerServerEvent("disableRepairAction", false, stationIAmRepairing)
        stationIAmRepairing = ""
        ClearPedTasks(PlayerPedId())
    end
end)
