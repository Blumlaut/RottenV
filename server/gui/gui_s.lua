Squads = {}
RegisterServerEvent("joinsquad")
RegisterServerEvent("leavesquad")

Citizen.CreateThread(function()
	
	function IsSquadMemberAdmin(member)
		for i,theSquad in pairs(Squads) do
			for theRow,theMember in ipairs(theSquad.members) do
				if GetPlayerName(member) == theMember.name then
					return theMember.admin
				end
			end
		end
	end
	
	AddEventHandler("joinsquad", function(squadName,PlayerName)
		jstheSource = source
		local squadExists = false
		for i,theSquad in ipairs(Squads) do
			for theRow,theMember in ipairs(theSquad.members) do
				if theMember.name == PlayerName then
					squadExists = true
					TriggerClientEvent("LeftSquad", theMember.id, Squads[i].name)
					table.remove(Squads[i].members, theRow)
					Citizen.Trace("\nremoved member from old squad\n")
					for ti,TM in ipairs(Squads[i].members) do
						TriggerClientEvent("SquadMemberLeft", TM.id, theMember.id, theMember.name)
						Citizen.Trace("\ntelling members their member left\n")
					end
					Citizen.Trace("\nPlayer Joined new Squad\n")
					break -- member was found, everything was done, break our loop
				end
			end
			if squadExists then
				break -- as we cant break out of multiple loops without breaking the whole event, break this too.
			end
		end

		local squadExists = false
		for i,theSquad in ipairs(Squads) do
			if theSquad.name == squadName then
				squadExists = true
				table.insert(Squads[i].members, {id = jstheSource,name = PlayerName, admin = false})
				TriggerClientEvent("JoinedSquad", jstheSource, Squads[i].members, Squads[i].name)
				Citizen.Trace("\nPlayer Joined new Squad\n")
				for i,theMember in ipairs(Squads[i].members) do
					TriggerClientEvent("SquadMemberJoined", theMember.id, PlayerName, jstheSource)
					Citizen.Trace("\ntelling member they have a new member\n")
				end
				break
			end
		end
		
		if squadExists == false then
			local squadtable = {name = squadName, members = { } }
			table.insert(Squads, squadtable)
			TriggerClientEvent("SquadCreated", jstheSource, squadName)
			Citizen.Trace("\nnew squad created\n")
			PlayerJoinSquad(jstheSource, PlayerName, true, squadName)
		end
	end)

	AddEventHandler("leavesquad", function(PlayerName,p2,p3)
		lstheSource = source
		local squadExists = false
		for i,theSquad in ipairs(Squads) do
			for theRow,theMember in ipairs(theSquad.members) do
				if theMember.name == PlayerName and (GetPlayerName(source) == PlayerName or IsSquadMemberAdmin(source)) then
					squadExists = true
					TriggerClientEvent("LeftSquad", theMember.id, Squads[i].name,p2,p3)
					table.remove(Squads[i].members, theRow)
					Citizen.Trace("\nremoved member from old squad\n")
					for ti,TM in ipairs(Squads[i].members) do
						TriggerClientEvent("SquadMemberLeft", TM.id, theMember.id, theMember.name,p2)
						Citizen.Trace("\ntelling members their member left\n")
					end
					break
				end
			end
			if squadExists then
				break
			end
		end

		for sid,theSquad in ipairs(Squads) do
			for row,member in ipairs(theSquad.members) do 
				local found = false
				local ptable = GetPlayers()
				for _,player in pairs(GetPlayers()) do
					if player == member.id then
						found=true
						break
					end
				end
				if not found then
					table.remove(Squads[sid].members, row)
				end
			end

				
			if #theSquad.members == 0 then
				table.remove(Squads, i)
				Citizen.Trace("\nremoved dead squad")
				break
			end
		end
	end)

	function PlayerJoinSquad(PlayerId,PlayerName,admin,SquadName)
		for i,theSquad in ipairs(Squads) do
			if theSquad.name == SquadName then
				table.insert(Squads[i].members, {id = PlayerId, name = PlayerName, admin = admin})
				TriggerClientEvent("JoinedSquad", PlayerId, Squads[i].members, Squads[i].name,admin)
				Citizen.Trace("\nPlayer Joined Squad\n")
				break
			end
		end
	end

	RegisterServerEvent("sendSquadMessage")
	AddEventHandler("sendSquadMessage", function(players,args)
		local msg = ""
		for i,arg in ipairs(args) do
			if i == 1 then
				msg = msg..arg
			else
				msg = msg.." "..arg
			end
		end
		for i,player in ipairs(players) do
			TriggerClientEvent("chat:addMessage", player, { templateId = "squad", args = { GetPlayerName(source), msg } })
		end
	end)

	AddEventHandler('playerDropped', function(reason)
		local PlayerName = GetPlayerName(source)
		for i,theSquad in ipairs(Squads) do
			for theRow,theMember in ipairs(theSquad.members) do
				if theMember.name == PlayerName then
					table.remove(Squads[i].members, theRow)
					Citizen.Trace("\nPlayer Dropped, Removing them from their Squad..")
					for ti,TM in ipairs(Squads[i].members) do
						TriggerClientEvent("SquadMemberLeft", TM.id, theMember.id, theMember.name)
					end
				end
			end
			break
		end
	end)
end)
