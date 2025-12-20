fx_version 'cerulean'
game 'gta5'

author 'PvP Framework'
description 'Framework completo para servidor PvP'
version '1.0.0'

lua54 'yes'

files {
    'stream/**'
}

this_is_a_map 'yes'

-- ======================
-- SHARED
-- ======================
shared_scripts {
    'shared/config.lua',
    'shared/utils.lua',
    'shared/groups_config.lua',
    'shared/weapon_skins.lua'
}

-- ======================
-- SERVER
-- ======================
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
    'server/migration.lua'
}

-- ======================
-- CLIENT
-- ======================
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

-- ======================
-- NUI
-- ======================
ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/kill.ogg'
}

-- ======================
-- EXPORTS (PADRÃO NOVO)
-- ======================
exports {
    'GetCurrentWeapon',
    'GetCurrentWeaponName',
    'GetCurrentWeaponAmmo',
    'GetPlayerWeapons',
    'ReloadCurrentWeapon',
    'HasWeapon',
    'GetWeaponStats',
    'UpdateHUDWeaponSlots',
    'ApplyMovementSpeed',
    'ResetMovementSpeed',
    'SetMovementEnabled'
}

server_exports {
    'GetPlayerGroup'
}
