local SXMLUA = require ("sxmlua")

local colors = {
  stroke = "green",
  fill = "yellow"
}

local style = {
  [".mycircle"] = {
    colors
  }
}
SXMLUA:process(style,"input.svg", "outas.svg",SXMLUA.applyAsAttrStyle)
