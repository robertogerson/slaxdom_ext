local SXMLUA = require ("sxmlua")
local menuleft="80%"
local menuwidth="11.7%"
local menuheight="6.7%"
local menuzindex="3"
local dist = 22.5
local topborder = 2.5

menu = {
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
	    _style = {SXMLUA.box,dist,topborder,menuleft}
	  }
}

--chamada da ferramenta passando a tabela,o nomes do documento de entrada e o que vai sair
SXMLUA:process(style, "ncltablefunction.ncl","boxout.ncl",SXMLUA.applyAsElemProperty)
