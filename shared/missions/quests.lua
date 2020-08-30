-- finish requirements can be:
-- banditkills, herokills, zombiekills, items
-- start requirements can be 
-- zombiekills, items, humanityMin, humanityMax, hunger, thirst

Quests = {
	{
		id = 1, --mission id
		name = "Helping People.", -- mission title
		desc = "Hey, you! My Friend is infected and needs antibiotics,\nif you can bring me some you can have some of our loot.", -- request
		finishmessage = "Oh, Thank God, here, have some loot,\nI bet you can use it better than us!", -- message once you finish it
		hide = false, -- hide if requirements aren't met
		startRequirements = {}, -- can be the same as below
		finishrequirements = {banditkills = 0, herokills = 0, zombiekills = 0, items = { {id = 16, count = 2} }  }, -- requirements to finish it
		finishloot = { humanity = 100, loot = {{id = 7, count = 2}, {id = 12, count = 4}, {id = 59, count = 60}} }, -- loot you get once you finish it
	},
	{
		id = 2, --mission id
		name = "Cleaning out the Rat Nest.", -- mission title
		desc = "Whats up, i've seen what you did around here,\ngreat work, but we are not done yet,\nour looters keep getting attacked by bandits,\ncould you help us and kill some, please?", -- request
		hide = true, -- hide if requirements aren't met
		finishmessage = "Nice Work! Here, have some supplies.", -- message once you finish it
		startRequirements = {humanityMin = 500},
		finishrequirements = {banditkills = 20, herokills = 0, zombiekills = 0, items = {}  }, -- requirements to finish it
		finishloot = { humanity = 100, loot = {{id = 17, count = 5000}, {id = 11, count = 1}, {id = 16, count = 1}}  } -- loot you get once you finish it
	},
	{
		id = 3, --mission id
		name = "Cleansing the Weak.", -- mission title
		desc = "Those Heroes are ruining our work, make them fear us again.", -- request
		hide = true, -- hide if requirements aren't met
		finishmessage = "Very Nice, that'll teach them not to fuck with us.", -- message once you finish it
		startRequirements = {humanityMax = 200},
		finishrequirements = {banditkills = 0, herokills = 20, zombiekills = 0, items = {}  }, -- requirements to finish it
		finishloot = { humanity = -150, loot = {{id = 17, count = 3500}, {id = 11, count = 1}, {id = 16, count = 1}}  } -- loot you get once you finish it
	},
	
	{
		id = 4, --mission id
		name = "Land of the Dead.", -- mission title
		desc = "Hey, wanna earn some extra cash?\nGet rid of those pesky zombies, will ya.", -- request
		hide = false, -- hide if requirements aren't met
		finishmessage = "Good Job, Soldier, here, have some cash.", -- message once you finish it
		startRequirements = {},
		finishrequirements = {banditkills = 0, herokills = 0, zombiekills = 20, items = {}  }, -- requirements to finish it
		finishloot = { humanity = 100, loot = {{id = 17, count = 2000}}  } -- loot you get once you finish it
	},
	
	{
		id = 5, --mission id
		name = "Resupply Needed.", -- mission title
		desc = "We need some guns since we've been running out lately,\ncan you get us some? Would be great.", -- request
		hide = false, -- hide if requirements aren't met
		finishmessage = "Thanks, these will come in handy.", -- message once you finish it
		startRequirements = {},
		finishrequirements = {banditkills = 0, herokills = 0, zombiekills = 0, items = { {id = 40, count = 30}, {id = 45, count = 15} } }, -- requirements to finish it
		finishloot = { humanity = 100, loot = {{id = 17, count = 3500}}  } -- loot you get once you finish it
	},
	
	{
		id = 6, --mission id
		name = "Fun Facts.", -- mission title
		desc = "Did you know that zombies drop loot sometimes?\nI didn't until recently!", -- request
		hide = false, -- hide if requirements aren't met
		finishmessage = "Nice Job! Here, have this marker, i don't have a use for it.", -- message once you finish it
		startRequirements = {},
		finishrequirements = {banditkills = 0, herokills = 0, zombiekills = 300, items = { } }, -- requirements to finish it
		finishloot = { humanity = 50, loot = {{id = 87, count = 1},{id = 17, count = 15000}}  } -- loot you get once you finish it
	},
	
	{
		id = 7, --mission id
		name = "Eliminar Bandidos.", -- mission title
		desc = "Hey Amigo! These evil bandidos have been making life\nhard for me, please take care of this escoria.", -- request
		hide = true, -- hide if requirements aren't met
		finishmessage = "Gracias hermano, i owe you.", -- message once you finish it
		startRequirements = {humanityMin = 450, humanityMax = 9999999},
		finishrequirements = {banditkills = 50, herokills = 0, zombiekills = 0, items = { } }, -- requirements to finish it
		finishloot = { humanity = 100, loot = {{id = 13, count = 1},{id = 17, count = 8000},{id = 7, count = 2}}} -- loot you get once you finish it
	},
	
	{
		id = 8, --mission id
		name = "Stocking Up.", -- mission title
		desc = "Yo, we've been running low on food lately,\ncan you go out and get us some, we need about a month's worth.", -- request
		hide = true, -- hide if requirements aren't met
		finishmessage = "Thanks man, no idea what we would do without you.", -- message once you finish it
		startRequirements = {},
		finishrequirements = {banditkills = 0, herokills = 0, zombiekills = 0, items = { {id = 5, count = 10},{id = 12, count = 10},{id = 22, count = 4},{id = 1, count = 10},{id = 24, count = 6}  } }, -- requirements to finish it
		finishloot = { humanity = 100, loot = {{id = 81, count = 20},{id = 45, count = 20},{id = 17, count = 10000},{id = 12, count = 4},{id = 12, count = 4},{id = 11, count = 1} }  } -- loot you get once you finish it
	},
	
	-- add new missions here, below is a placeholder, you can replace it with whatever, just make sure you increment the mission id properly.
	{
		id = 9, --mission id
		name = "Getting a Signal.", -- mission title
		desc = "Hey, did you hear? A Heli crashed nearby and it dropped a load of CB Radios, if you can bring me some batteries i'll give you one.", -- request
		finishmessage = "Awesome! Here, this one looks to be good, i hope you need it more than i do.", -- message once you finish it
		startRequirements = {},
		finishrequirements = {items = {{id = 91, count = 6}}  }, -- requirements to finish it
		finishloot = { humanity = 50, loot = {{id = 93, count = 1}} } -- loot you get once you finish it
	},

	{
		id = 10, --mission id
		name = "Campers.", -- mission title
		desc = "These pesky mercenaries have been building up camps in the whole city recently, please get rid of them, if you can.", -- request
		finishmessage = "Thank god, lets hope they dont come back.", -- message once you finish it
		startRequirements = {},
		finishrequirements = {stopCamps = 3}, -- requirements to finish it
		finishloot = { humanity = 150, loot = {{id = 11, count = 2}, {id = 17, count = 6000}} } -- loot you get once you finish it
	},

	[97] = {
		id = 97,
		name = "~g~Daily Quest 1~w~",
		daily = true,
		desc = "This is a Daily Quest, it will change every Day.",
		finishmessage = "Daily Completed.",
		startRequirements = {},
		finishrequirements = {}, -- genererate daily requirement
		finishloot = {}, -- generate daily reward
	},
	
	[98] = {
		id = 98,
		name = "~g~Daily Quest 2~w~",
		daily = true,
		desc = "This is a Daily Quest, it will change every Day.",
		finishmessage = "Daily Completed.",
		startRequirements = {},
		finishrequirements = {}, -- genererate daily requirement
		finishloot = {}, -- generate daily reward
	},
	[99] = {
		id = 99,
		name = "~g~Daily Quest 3~w~",
		daily = true,
		desc = "This is a Daily Quest, it will change every Day.",
		finishmessage = "Daily Completed.",
		startRequirements = {},
		finishrequirements = {}, -- genererate daily requirement
		finishloot = {}, -- generate daily reward
	},
	
}
