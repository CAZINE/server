local cfg = {}

cfg.groups = {
	["PRESIDENTE"] = {
		"owner.permissao",
		"admin.permissao",
		"polpar.permissao",
		"ticket.permissao",
		"comum.permissao",
		"alerta.permissao",
		"mod.permissao",
		"flux.bypass",
		"flux.admin",
		"fix.permissao",
		"god.permissao",
		"money.permissao",
		"ban.permissao",
		"unban.permissao",
		"noclip.permissao",
		"group.permissao",
		"clima.permissao",
		"tp.permissao",
		"suporte.permissao",
		"car.permissao",
		"player.noclip",
		"kill.permissao",
		"cor.permissao",
		"comandantegeral.permissao"
	},


	["ADMINISTRADOR"] = {
		"admin.permissao",
		"polpar.permissao",
		"ticket.permissao",
		"comum.permissao",
		"player.noclip",
		"clima.permissao",
		"alerta.permissao",
		"mod.permissao",
		"flux.bypass",
		"flux.admin",
		"god.permissao",
		"ban.permissao",
		"unban.permissao",
		"noclip.permissao",
		"suporte.permissao",
		"group.permissao",
		"tp.permissao",
		"fix.permissao",
		"money.permissao"
	},


	["MOD"] = {
		"polpar.permissao",
		"ticket.permissao",
		"player.noclip",
		"comum.permissao",
		"alerta.permissao",
		"mod.permissao",
		"suporte.permissao",
		"flux.bypass",
		"ban.permissao",
		"god.permissao",
		"noclip.permissao",
		"group.permissao",
		"tp.permissao",
		"cor.permissao"
	},
	["SUPORTE"] = {
		"polpar.permissao",
		"suporte.permissao",		
		"comum.permissao",
		"alerta.permissao",
		"ticket.permissao",
		"flux.bypass",
		"god.permissao",
		"ban.permissao",
		"tp.permissao",
		"cor.permissao"
	},
	["OFFPRESIDENTE"] = {
		"offowner.permissao",
		"offadmin.permissao",
		"offpolpar.permissao",
		"offticket.permissao",
		"offcomum.permissao",
		"offalerta.permissao",
		"offmod.permissao",
		"offflux.bypass",
		"offflux.admin",
		"offfix.permissao",
		"offgod.permissao",
		"offmoney.permissao",
		"offban.permissao",
		"offunban.permissao",
		"offnoclip.permissao",
		"offgroup.permissao",
		"offclima.permissao",
		"offtp.permissao",
		"offsuporte.permissao",
		"offcar.permissao",
		"offplayer.noclip",
		"offkill.permissao",
		"offcor.permissao",
		"offcomandantegeral.permissao"
	},
	["OFFADM"] = {
		"offadmin.permissao",
		"offpolpar.permissao",
		"offticket.permissao",
		"offcomum.permissao",
		"offplayer.noclip",
		"offclima.permissao",
		"offalerta.permissao",
		"offmod.permissao",
		"offflux.bypass",
		"offflux.admin",
		"offgod.permissao",
		"offban.permissao",
		"offunban.permissao",
		"offnoclip.permissao",
		"offsuporte.permissao",
		"offgroup.permissao",
		"offtp.permissao",
		"offfix.permissao",
		"offmoney.permissao"
	},
	["OFFMOD"] = {
		"offmod.permissao",
		"offpolpar.permissao",
		"offticket.permissao",
		"offplayer.noclip",
		"offcomum.permissao",
		"offalerta.permissao",
		"offsuporte.permissao",
		"offflux.bypass",
		"offban.permissao",
		"offgod.permissao",
		"offnoclip.permissao",
		"offgroup.permissao",
		"offtp.permissao",
		"offcor.permissao"
	},
	["OFFSUPORTE"] = {
		"offsuporte.permissao",
		"offpolpar.permissao",	
		"offcomum.permissao",
		"offalerta.permissao",
		"offticket.permissao",
		"offflux.bypass",
		"offgod.permissao",
		"offban.permissao",
		"offtp.permissao",
		"offcor.permissao"
	},
-- ################################################################################################################
    -- ##############################################--POLICIA PM--#######################################################
    -- ################################################################################################################ 
    ["coronel"] = {
        _config = {
            title = "Coronel PM",
            gtype = "job"
        },
        "policia.permissao",
		"coronel.permissao",
        "polpar.permissao",
        "portadp.permissao",
        "sem.permissao"
    },
	["paisanacoronel"] = {
		_config = {
			title = "Paisana Coronel PM",
			gtype = "job"
		},
		"paisanacoronel.permissao"
	},
	["tenentecoronel"] = {
		_config = {
			title = "Tenente Coronel",
			gtype = "job"
		},
		"policia.permissao",
		"tenentecoronel.permissao",
		"polpar.permissao",
		"portadp.permissa"
	},
	["paisanatenentecoronel"] = {
		_config = {
			title = "Folga Tenente Coronel",
			gtype = "job"
		},
		"paisanatenentecoronel.permissao"
	},
	["cabo"] = {
		_config = {
			title = "Cabo",
			gtype = "job"
		},
		"policia.permissao",
		"tenentecabo.permissao",
		"revistar.permissao",
		"portadp.permissa"
	},
	["paisanacabo"] = {
		_config = {
			title = "Folga cabo",
			gtype = "job"
		},
		"paisanacabo.permissao",
		"portadp.permissa"
	},
	
    -- ################################################################################################################
    -- ##############################################--POLICIA PM--#######################################################
    -- ################################################################################################################

}

cfg.users = {
	[1] = { "PRESIDENTE" },
	[2] = { "PRESIDENTE" },
	[3] = { "PRESIDENTE" },
}

cfg.selectors = {

}

return cfg