fx_version 'cerulean'
games { 'gta5' }
dependency 'oxmysql'
dependency 'pogressBar'

shared_scripts {
	"config/config.lua",
	"shared/**.lua"
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
	"server/**.lua"
}

client_scripts {
	"client/**.lua"
}

resource_type 'map' { gameTypes = { ['basic-gamemode'] = true } }
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
