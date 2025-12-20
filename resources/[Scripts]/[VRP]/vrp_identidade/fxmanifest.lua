shared_script "@vrp/lib/lib.lua" --Para remover esta pendencia de todos scripts, execute no console o comando "uninstall"

fx_version 'bodacious'
game 'gta5'

author 'Esquilo - Rox Infinity'
description 'Folkis Identidade.'
version '1.0.0'

ui_page_preload 'yes'
ui_page 'nui/ui.html'

client_scripts {
	'@vrp/lib/utils.lua',
	'client.lua'
}

server_scripts {
	'@vrp/lib/utils.lua',
	'server.lua'
}

files {
	'nui/**/*'
}                          