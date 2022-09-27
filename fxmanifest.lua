client_script '@X.Brain/Shared/xGuardPlayer.lua'
server_script '@X.Brain/Shared/xGuardServer.lua'
fx_version 'adamant' 
game 'gta5' 

description 'TWENTY2 SHOP'

ui_page 'html/index.html'

files {
	'html/index.html',
  'html/style.css',
  'html/script.js'
}

version '1.0'

client_scripts {
  "config.lua",
  "client/main.lua"
}

server_script {
  '@mysql-async/lib/MySQL.lua',
  "config.lua",
  "server/server.lua"
}
