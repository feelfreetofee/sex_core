fx_version 'cerulean'
game 'gta5'

lua54 'yes'
use_experimental_fxv2_oal 'yes'

loadscreen 'html/loadscreen.html'

loadscreen_manual_shutdown "yes"

files {
	'html/loadscreen.html'
}

shared_scripts {
	'config.lua'
}

server_scripts {
	'server/cb.lua',
	'server/init.lua',
	'server/vehicle.lua'
}

client_scripts {
	'client/cb.lua',
	'client/init.lua',
	'client/vehicle.lua'
}
