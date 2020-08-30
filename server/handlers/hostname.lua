
--[[
Citizen.CreateThread(function()
	
	while true do
		Wait(100)
		local base = GetConvar("sv_hostname", "none")
		local baseNormal = GetConvar("sv_colouredhostname", "none")
		local ctable = {}
		for i=1,20 do 
			table.insert(ctable, "^"..tostring(math.random(0,9)))
		end
		local servername = string.format(baseNormal, ctable[1], ctable[2], ctable[3], ctable[4], ctable[5])
		if string.find(GetConvar("sv_hostname", "none"),"RottenV") then
			Citizen.Trace("\nSetting New Hostname "..servername.."\n")
			SetConvar("sv_hostname", servername)
		end
		Wait(3420000)
	end
end)

]]