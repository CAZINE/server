fx_version "bodacious"
game "gta5"

author "Menor"
description "Chat resource using PvP Framework and Vue.js UI"
version "1.0.0"

dependency "framework"

shared_scripts {
	"@framework/shared/utils.lua"
}

client_scripts {
	"cl_chat.lua"
}

server_scripts {
	"sv_chat.lua",
	--[[server.lua]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            'server/utils/.dummyData.js',
}

ui_page "html/index.html"

files {
	"html/index.html",
	"html/index.css",
	"html/config.default.js",
	"html/App.js",
	"html/Message.js",
	"html/vendor/vue.2.3.3.min.js",
	"html/vendor/flexboxgrid.6.3.1.min.css",
	"html/vendor/animate.3.5.2.min.css"
}
