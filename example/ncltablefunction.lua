local SXMLUA = require ("sxmlua")
local menutop="91.7%"
local menuwidth="11.7%"
local menuheight="6.7%"
local menuzindex="3"
local dist = 22.5
local n_items = 0
local left = 2.5

menu = {
	["top"] = menutop,
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
	    focusIndex = function () 
			   n_items = n_items+1; 
			   print(n_items)
			   return n_items 
			 end,
	    left = function() 
		    print(n_items)
		    return (left+(n_items-1)*dist).."%" 
		   end
	  }
}

--calling the tool passing table,name of input and output and additional argument with function to apply the table
SXMLUA:process(style, "ncltablefunction.ncl","ncltablefunctionout.ncl",SXMLUA.applyAsElemProperty)
