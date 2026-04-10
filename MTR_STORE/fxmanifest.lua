fx_version 'cerulean'
game 'gta5'

author 'MTR - Vera CFW'
description 'Ultimate Anti-Cheat for Vera RP'
version '1.0.0'
lua54 'yes'

shared_scripts {
    'shared/config.lua',
    'shared/main.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

ui_page 'html/index.html'
files {
    'html/index.html',
    'html/script.js'
}