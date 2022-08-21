# RottenV
RottenV:R is a Community-Driven Zombie Gamemode, originally developed by Scammer, it has been majorly rewritten and expanded by Blü, it has been in development for over 3 years with breaks inbetween, this is the public release of the whole Gamemode, nothing was redacted, everything is here.

## Features
- Fully integrated currency system
- Hunger, thirst and morality system with different skins
- over 100 usable items
- Adaptable quest system and random world events
- Dynamic enemies which react to player behaviour
- Persistant player inventories
- Realistic voice chat with a radio system for long-listance chatting


## Requirements:
* [oxmysql](https://github.com/overextended/oxmysql)
* [pogresbar](https://github.com/SWRP-PUBLIC/pogressBar)
* [EasyAdmin](https://github.com/Blumlaut/EasyAdmin)
* [Antichese Anticheat](https://github.com/Blumlaut/anticheese-anticheat)

**Create a database in MySQL and import the SQL file, then configure these in oxmysql, RottenV will automatically establish a database connection.**


## Configuration:
* Main Configuration
Configuration is done in `config\config.lua` there various gameplay options can be configured, every option is documented in the file, best to just hop in and take a look!
* Changing/Adding Items
Items Can be changed in `shared\inventory\items.lua`.

Each item has its own id marked at the beginning of it with a comment.

**Do not change the Order of the Items, that will cause problems Ingame, instead add new items at the bottom.**

An example of a food item is:
```
	{-- 15
		name = "Twinkie", -- Display Name 
		multipleCase = "Twinkies", -- Display Name, if it's Multiple
		hunger = 3.0, -- the amount of hunger it restores, from 0-100%
		thirst = 1.0, -- the amount of thirst it restores, from 0-100%
		health = 3, -- the amount of health it restores, in percent.
		spawnChance = 50, -- the "Chance" of finding it, this has no particular measurement, higher is more likely
		randomFinds = {2,3}, -- how many you can find from a single item drop.
		desc = "I hate coconut, not the taste, the consistency.", -- a short item description
		consumable = true, -- can you consume it?
		price = 3, -- the Price in the Stores
		stockAmount = {20,70}, -- the amount Stores have in stock of them, at any given time
	},
```
Items can be freely added, however, a database reset is recommended if Items are Removed.


## Info:
Experience an issue or have a suggestion? Feel free to create an [Issue](https://github.com/Bluethefurry/RottenV/issues)

Made your own changes to the code? Feel free to add it! We're always looking for [Pull Requests](https://github.com/Bluethefurry/RottenV/pulls)

Discord Server: https://discord.gg/GugyRU8
