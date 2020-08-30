function DrawText3D(x, y, z, text)
    SetDrawOrigin(x, y, z, 0);
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.0, 0.2)
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

players = {} -- global players table

RegisterNetEvent("Z:playerUpdate")
AddEventHandler("Z:playerUpdate", function(mPlayers)
	players = mPlayers
end)

Citizen.CreateThread(function()
	function CreateAwaitedKeyboardInput(textentry,title,maxLen,c,d,e)
		if title then
			AddTextEntry(textentry, title)
		end
		DisplayOnscreenKeyboard(1, textentry, "", "", "", "", "", maxLen)

		local kbupdate = UpdateOnscreenKeyboard()
		
		while kbupdate ~= 1 and kbupdate~= 2 do
			kbupdate =UpdateOnscreenKeyboard()
			Citizen.Wait( 0 )
		end
		
		local result = GetOnscreenKeyboardResult()
		return result, kbupdate -- return kbupdate to possibly prevent "cancellation" from causing problems
	end
end)

function GetPlayers()
	local players = {}
	
	for i = 0, 255 do
		if NetworkIsPlayerActive(i) then
			table.insert(players, i)
		end
	end
	return players
end


function GetPlayersInRadius(radius)
	local plist = GetPlayers()
	local pamount = 0
	local localx,localy,localz = table.unpack(GetEntityCoords(PlayerPedId(), true))	
	for _,player in pairs(plist) do
		local pedx,pedy,pedz = table.unpack(GetEntityCoords(GetPlayerPed(player), true))
		if GetDistanceBetweenCoords(localx, localy, localz, pedx,pedy,pedz, false) < (radius or 300) then
			pamount=pamount+1
		end
	end
	return pamount
end

function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
	if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
		return k
	else
		return "[" .. table.val_to_str( k ) .. "]"
	end
end

function table.tostring( tbl )
	local result, done = {}, {}
	for k, v in ipairs( tbl ) do
		table.insert( result, table.val_to_str( v ) )
		done[ k ] = true
	end

	for k, v in pairs( tbl ) do
		if not done[ k ] then
		 	table.insert( result,
			table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
		end
	end
	return "{" .. table.concat( result, "," ) .. "}"
end