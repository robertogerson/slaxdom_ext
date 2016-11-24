local SLAXML = require ("slaxdom_ext")
local menutop="91.7%"
local menuwidth="11.7%"
local menuheight="6.7%"
local menuzindex="3"
local dist = 22.5
local leftborder = 2.5

menu = {
	--["top"] = menutop,
	["width"] = menuwidth,
	["height"] = menuheight,
	["zIndex"] = menuzindex,
}

style = { 
	["#background"] = {
		["width"] = "100%",
		["height"] = "100%",
		["zIndex"] = "1"
	},
	["#animation"] = {
		["width"] = "100%",
		["height"] = "88%",
		["zIndex"] = "2"
	},
	[".menu"] = {
	    menu,
	    _style = {SLAXML.flow,dist,leftborder,menutop}
	  }
}

--chamada da ferramenta passando a tabela,o nomes do documento de entrada e o que vai sair
SLAXML:process(style, "ztest.ncl","zflowout.ncl",SLAXML.applyAsElemProperty)
