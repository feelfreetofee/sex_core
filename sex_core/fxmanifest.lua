fx_version 'cerulean'
game 'gta5'

lua54 'yes'
use_experimental_fxv2_oal 'yes'

shared_script 'config.lua'

server_scripts {
	'server/multicharacter.lua',
	'server/main.lua',
	'server/commands.lua',
	'server/init.lua'
}

client_scripts {
	'client/multicharacter.lua',
	'client/main.lua',
	'client/commands.lua',
	'client/init.lua'
}