fx_version "adamant"
game "gta5"
lua54 'yes'
author 'Nexus Dev.'
description 'New Lobby System By Nexus | discord.gg/nexusdev | nexusdev.online'
version '1.0.0'
ui_page "ui/index.html"
files {
    "ui/**/*",
}

shared_scripts {
	'config.lua'
}

client_script {
    'client.lua',
    'config.lua'
}

server_script {
    'server.lua'
}