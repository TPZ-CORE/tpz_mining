fx_version "adamant"
games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

version '1.0.0'

author 'Nosmakos'
description 'TPZ-CORE Mining'

shared_scripts { 'config.lua', 'locales.lua' }
server_scripts { 'server/*.lua' }
client_scripts { 'client/*.lua' }

lua54 'yes'
