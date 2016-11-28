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
SXMLUA:process(style,"input.svg", "out.svg")
