--load SXMLUA
local SXMLUA = require ("sxmlua")

local n_rect = 0
local tam = 150
local colors = {
  stroke = "green",
  fill = "yellow"
}

--table with style definitions
local style = {
  ["rect"] = {
    colors,
    width = tam,
    height = function ()
               n_rect = n_rect+1
               return n_rect * 100
             end 
  },
  [".mycircle"] = {
    colors
  }
}
--function call
SXMLUA:process( style,
                "circle_in.svg",
                "circle_out.svg" )
