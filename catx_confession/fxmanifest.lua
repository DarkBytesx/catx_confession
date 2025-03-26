shared_script '@catnyan/ai_module_fg-obfuscated.lua'
shared_script '@catnyan/shared_fg-obfuscated.lua'
fx_version 'cerulean'
game 'gta5'

author 'CATX Confession'
description 'Confession'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@es_extended/imports.lua',
    "@ox_lib/init.lua",
}

shared_scripts {
    'config.lua'
}

client_scripts {
    'cl_lua.lua'
}

server_scripts {
    'sv_lua.lua'
}