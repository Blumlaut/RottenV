Citizen.CreateThread(function()
	function writeLog(msg,level)
		if level <= config.LogLevel then 
			print(msg)
		end
	end
end)