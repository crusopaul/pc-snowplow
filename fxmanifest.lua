name 'pc-snowplow'
description ''
version '0.0.1'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_script 'config.lua'

server_scripts {
    'server/functions.lua',
    'server/main.lua',
}

client_scripts {
    'client/functions.lua',
    'client/main.lua',
}
