fx_version 'cerulean'
game 'gta5'

name 'gang'
description 'Sistema de gangues com NUI'
author 'SeuNome'
version '1.0.0'

client_script 'client.lua'
server_script 'server.lua'

ui_page 'nui/index.html'

files {
    'nui/index.html',
    'nui/app.js',
    'nui/style.css'
}
dependency 'oxmysql'
dependency 'framework' -- Comentado temporariamente 