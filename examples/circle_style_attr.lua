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

SXMLUA:process( style,
                "circle_in.svg",
                "circle_style_attr_out.svg",
                SXMLUA.applyAsAttrStyle )
