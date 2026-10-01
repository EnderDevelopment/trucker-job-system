fx_version 'cerulean'
game 'gta5'

description 'Trucker Job System'
version '1.0.0'

author 'Your Name'

dependency 'es_extended'

client_scripts {
    'client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}

shared_scripts {
    'config.lua'
}