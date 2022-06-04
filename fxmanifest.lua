fx_version 'cerulean'
games { 'gta5' }
dependency 'oxmysql'
dependency 'pogressBar'

shared_scripts {
	"config/config.lua"
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
	"shared/gameplay/weatherconfig.lua",
	"shared/useful/loghandler.lua",
	"server/main.lua",
	"server/pingkick.lua",
	"shared/useful/functions.lua",
	"server/handlers/hosthandler.lua",
	"server/db/dbServer.lua",
	"server/db/dbServerSafes.lua",
	"server/gameplay/drops.lua",
	"server/gameplay/weather_server.lua",
	"server/gameplay/hunted_server.lua",
	"server/gui/gui_s.lua",
	"server/gui/notifications_s.lua",
	"server/spawners/carspawner_server.lua",
	"server/spawners/itemspawner_server.lua",
	"server/missions/ai_camps_s.lua",
	"server/missions/power_s.lua",
	"server/missions/airdrop_s.lua",
	"shared/inventory/items.lua",
	"shared/missions/quests.lua",
	"server/inventory/inventory_s.lua",
	"shared/hub/hubStores.lua",
	"server/hub/itemshop_s.lua",
	"server/hub/questshop_s.lua",
	"server/hub/gamble_s.lua",
	"server/anticheat/anticheat_server.lua",
	"server/prometheus.lua",
}

client_scripts {
	"shared/useful/loghandler.lua",
	"shared/inventory/items.lua",
	"shared/missions/quests.lua",
	"shared/useful/functions.lua",
	"shared/gameplay/weatherconfig.lua",
	"client/useful/scaleform_wrapper.lua",
	"client/pingkick.lua",
	"client/gui/warmenu.lua",
	"client/gameplay/newplayer.lua",
	"client/gameplay/nopeds.lua",
	"client/spawners/zombiespawner.lua",
	"client/spawners/carspawner.lua",
	"client/spawners/itemspawner.lua",
	"client/spawners/animalspawner.lua",
	"client/gameplay/environment.lua",
	"client/gameplay/weather_c.lua",
	"client/gameplay/humanity_c.lua",
	"client/gameplay/temperature.lua",
	"client/gameplay/binoculars_and_goggles.lua",
	"client/gameplay/itemtasks.lua",
	"client/gameplay/hunted_c.lua",
	"client/useful/killplayer.lua",
	"client/gui/hud.lua",
	"client/gui/radio.lua",
	"client/useful/util.lua",
	"client/inventory/food.lua",
	"client/db/dbClient.lua",
	"client/db/dbClientSafes.lua",
	"client/gameplay/dropc.lua",
	"client/gui/gui.lua",
	"client/gui/notifications.lua",
	"client/useful/reverse_weapon_hashes.lua",
	"client/gameplay/savezones_c.lua",
	"client/gameplay/noreticle.lua",
	"client/missions/power_c.lua",
	"client/missions/airdrop_c.lua",
	"client/missions/quests_c.lua",
	"client/missions/ai_camps_c.lua",
	

	"client/useful/exports.lua",
	"client/anticheat/anticheat_client.lua",
	"shared/hub/hubStores.lua",
	"client/hub/itemshop_c.lua",
	"client/hub/wepshop_c.lua",
	"client/hub/skinshop_c.lua",
	"client/hub/questshop_c.lua",
	"client/hub/locker_c.lua",
	"client/hub/gamble_c.lua",
	"client/hub/hub_c.lua",
	"client/inventory/inventory_c.lua",
	"client/RichPresence.lua",
	
}


resource_type 'map' { gameTypes = { fivem = true } }

map 'map.lua'

--[[
ui_page('client/web/playsound.html')

files({
	'client/web/cb1_on.ogg',
	'client/web/cb1_off.ogg',
	'client/web/cb2_on.ogg',
	'client/web/cb2_off.ogg',
	'client/web/cb3_on.ogg',
	'client/web/cb3_off.ogg',
})
]]
exports {
    	'isPlayerInfected',
		'GetPlayerUniqueId',
		'GetHighestVoiceProximity',
		'DoesPlayerHaveCBRadio',
		'GetPlayerCurrentRadioData'
}

files {
	'stream/def_props.ytyp'
}
   
data_file 'DLC_ITYP_REQUEST' 'stream/def_props.ytyp'

loadscreen_manual_shutdown 'yes'