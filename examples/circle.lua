--load SXMLUA
local SXMLUA = require ("sxmlua")

local colors = {
  stroke = "green",
  fill = "yellow"
}

--table with style definitions
local style = {
  [".mycircle"] = {
    colors
  }
}
--function call
SXMLUA:process( style,
                "circle_in.svg",
                "circle_out.svg" )
