safes = {}



RegisterServerEvent('createSafe')
RegisterServerEvent('CreateCustomSafe')
RegisterServerEvent('requestSafes')
RegisterServerEvent('removeSafe')
RegisterServerEvent('GetSafeContents')
RegisterServerEvent('SetSafeContents')
RegisterServerEvent('updateSafe')
RegisterServerEvent("ExitSafe")
RegisterServerEvent("Z:newplayerID")


Citizen.CreateThread(function()

	function updateAllSafes()
		Citizen.Trace("\nUpdating all Safes...\n")
		safes = {}
		Wait(500)
		if not TESTMODE then
				exports['ghmattimysql']:execute('SELECT * FROM safes', {}, function(data)
					local success, err = pcall(function()
					for i,theSafe in pairs(data) do
						Citizen.Wait(10)
						theSafe.x = tonumber(theSafe.x)
						theSafe.y = tonumber(theSafe.y)
						theSafe.z = tonumber(theSafe.z)
						theSafe.r = tonumber(theSafe.r)
						theSafe.in_use = false
						theSafe.usageTime = 0
						theSafe.permanent = true
						local tempinv = json.decode(theSafe.inv)
						theSafe.inv = {}
						for i, item in pairs(tempinv) do 
							if item.id and theSafe.inv[item.id] then
								theSafe.inv[item.id].count = theSafe.inv[item.id].count+item.count
							elseif item.id then
								theSafe.inv[item.id] = item
							end
						end
						local tempinv = nil

						if os.time()-theSafe.creationTime > config.SafeExpirationTime*86400 and os.time()-theSafe.creationTime < ((config.SafeExpirationTime*86400)+(config.SafeUnlockTime*86400)) then
							theSafe.passcode = "0000"
							theSafe.visible = true
							table.insert(safes,theSafe)
						elseif os.time()-theSafe.creationTime > ((config.SafeExpirationTime*86400)+(config.SafeUnlockTime*86400)) then
							exports['ghmattimysql']:execute('DELETE FROM safes WHERE id=@id', {id=theSafe.id}, function() end)
						else
							table.insert(safes,theSafe)
						end
					end
					Citizen.Trace("\nUpdated Safes. "..#safes.."\n")
				end)
				if not success then
					TriggerEvent("SentryIO_Error", err, debug.traceback())
					return false
				end
			end)
			SetTimeout(10800000, updateAllSafes)
		end
	end
	updateAllSafes()
end)

Citizen.CreateThread(function()

	AddEventHandler('createSafe', function(x,y,z,r,passcode,inv)
		local success, err = pcall(function()
			local client = source
			if not GetPlayerIdentifier(client,0) then return end
			local inv = {}
			local id = -1
			exports['ghmattimysql']:execute('INSERT INTO safes (creationTime,owner,passcode,x,y,z,r,inv) VALUES(@creationTime, @owner, @passcode, @x, @y, @z, @r, @inv) ', { creationTime = os.time(), owner = GetPlayerIdentifier(client,0), passcode = passcode, x = x, y = y, z = z, r = r, inv = json.encode(inv) }, 
			function(response)
				id = response.insertId -- assign an  id
			end)
			repeat
				Wait(1) -- wait for response
			until id ~= -1
			Citizen.Trace("\nSafe "..id.." Created!\n")
			TriggerClientEvent("addSafe", -1, id,x,y,z,r)
			table.insert(safes, {id = id,x = x,y = y,z = z,r = r,passcode = passcode, inv = inv, in_use = false, usageTime = 0, permanent = true} )
		end)
		if not success then
			TriggerEvent("SentryIO_Error", err, debug.traceback())
			return false
		end
	end)
	
	AddEventHandler("CreateCustomSafe", function(x,y,z,r,model,inv,permanent,passcode,blip)
		local success, err = pcall(function()
			local client = source
			if not GetPlayerIdentifier(client,0) then return end
			if not model then model = "prop_ld_int_safe_01" end
			
			if not inv then
				inv = {}
			end
			if not blip then blip = 181 end
			local id = nil
			if permanent then
				id = #safes+1 -- assign an  id
			else
				id = math.random(1000,1000000) -- assign an id that hasnt been used yet and probably never will, we won't be saving this anyway.
				passcode = "0000"
			end
			Citizen.Trace("\nSafe "..id.." Created!\n")
			TriggerClientEvent("addCustomSafe", -1, id,x,y,z,r,model,blip)
			table.insert(safes, {id=id,x = x,y = y,z = z,r = r,passcode = passcode, inv = inv, in_use = false, usageTime = 0, permanent = permanent,blip=blip,model=model} )
		end)
		if not success then
			TriggerEvent("SentryIO_Error", err, debug.traceback())
			return false
		end
	end)

	AddEventHandler('removeSafe', function(id,passcode)
		local success, err = pcall(function()
			local client = source
			if not GetPlayerIdentifier(client,0) then return end
			for i,theSafe in pairs(safes) do
				if id == theSafe.id and passcode == theSafe.passcode and passcode ~= "0000" and theSafe.permanent then
					exports['ghmattimysql']:execute('DELETE FROM safes WHERE id=@id LIMIT 1', {id=id}, function() end)
					table.remove(safes,i)
					Citizen.Trace("\nSafe "..id.." Deleted!\n")
					TriggerClientEvent("removeSafe", -1, id)
					break
				end
			end
		end)
		if not success then
			TriggerEvent("SentryIO_Error", err, debug.traceback())
			return false
		end		
	end)

	AddEventHandler("GetSafeContents", function(id,passcode)
		local success, err = pcall(function()
			local foundSafe = false
			local c = source
			for i,theSafe in pairs(safes) do
				if id == theSafe.id and passcode == theSafe.passcode then
					if theSafe.in_use and (theSafe.usageTime < (os.time()-600)) then
						safes[i].in_use = false
						safes[i].usageTime = 0
					elseif theSafe.in_use and (theSafe.usageTime < (os.time()+600)) then
						TriggerClientEvent("showNotification", c, "Someone is already accessing this Safe!")
						break
					end
					TriggerClientEvent("GetSafeContents", c, id, theSafe.x, theSafe.y, theSafe.z, theSafe.r, passcode, theSafe.inv)
					safes[i].in_use = true
					safes[i].usageTime = os.time()
					foundSafe = true
					if passcode ~= "0000" then
						exports['ghmattimysql']:execute('UPDATE safes SET creationTime=@creationTime WHERE id=@id LIMIT 1', {creationTime = os.time(), id = id}, function() end)
					end
					Citizen.Trace("\nPlayer Opened Safe!\n")
					break
				end
			end
			if not foundSafe then
				TriggerClientEvent("GetSafeContents", c, false,false, false, false, false, false, "")
				Citizen.Trace("\nSafe not found but client insists, whats wrong?\n")
			end
		end)
		if not success then
			TriggerEvent("SentryIO_Error", err, debug.traceback())
			return false
		end		
	end)
	
	AddEventHandler("ExitSafe", function(id)
		local foundSafe = false
		local c = source
		for i,theSafe in pairs(safes) do
			if id == theSafe.id then
				safes[i].in_use = false
				safes[i].usageTime = 0
				Citizen.Trace("\nPlayer Exited Safe!\n")
				break
			end
		end
	end)

	AddEventHandler("SetSafeContents", function(id,x,y,z,r,passcode,inv)
		local success, err = pcall(function()
			local foundSafe = false
			local c = source
			for i,theSafe in pairs(safes) do
				if id == theSafe.id and passcode == theSafe.passcode then
					if theSafe.permanent then
						exports['ghmattimysql']:execute('UPDATE safes SET inv=@inv WHERE id=@id LIMIT 1', { inv = json.encode(inv), id = id }, function() end)
					end
					foundSafe = true
					safes[i].inv = inv
					Citizen.Trace("\nPlayer Updated Safe!\n")
					break
				end
			end
			if not foundSafe then
				Citizen.Trace("\nSafe not found but client insists, whats wrong?\n")
			end
		end)
		if not success then
			TriggerEvent("SentryIO_Error", err, debug.traceback())
			return false
		end		
	end)

	AddEventHandler("Z:newplayerID", function(src)
		--local tt = {}
		for i,theSafe in pairs(safes) do
			--table.insert(tt, {x = theSafe.x, y = theSafe.y,z = theSafe.z,r = theSafe.r,visible = theSafe.visible } )
			if theSafe.blip then
				TriggerClientEvent("addCustomSafe", src, theSafe.id, theSafe.x,theSafe.y,theSafe.z,theSafe.r,theSafe.model,theSafe.blip)
			else
				TriggerClientEvent("loadSafe", src, {id = theSafe.id, x = theSafe.x, y = theSafe.y,z = theSafe.z,r = theSafe.r,visible = theSafe.visible}) -- send many small events instead of one B I G B O I
			end
			Citizen.Wait(15)
		end
		--TriggerClientEvent("loadSafes", src, tt )
		Citizen.Trace("\nSending Client Safes!\n")
	end)

end)



