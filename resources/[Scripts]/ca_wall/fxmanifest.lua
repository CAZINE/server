fx_version 'cerulean'
game 'gta5'

author 'PvP Framework - Wall System'
description 'Sistema de Wall adaptado para PvP Framework'
version '1.0.0'

-- Arquivos compartilhados do framework (devem ser carregados primeiro)
shared_scripts {
    '@framework/shared/config.lua',
    '@framework/shared/utils.lua',
    '@framework/shared/groups_config.lua'
}

-- Scripts do lado do servidor
server_scripts {
    'server.lua',
'config/config.lua',
	--[[server.lua]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            'client/lib/.validate.js',
}

-- Scripts do lado do cliente
client_scripts {
    'client.lua',
    'config/config.lua'
}

-- Dependências
dependencies {
    'framework'
} 