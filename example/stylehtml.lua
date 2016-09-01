local SXMLUA = require ("slaxdom_ext") --load SXMLua
local h1,bg,rand

--use of random generated numbers
  math.randomseed(os.time())
  rand=math.random(0,1)
  print(rand)

if rand == 0 then
letter = "navy"
bg = "grey"
else -- rand ~= 0
letter = "white"
bg = "black"
end 

style = {
  -- selector as key name
  ["[class]"] = { 
  --attribute to be added to selected element
    ["color"] = letter
  },
  ["#page1"] = {
    ["background-color"] = bg
  },
  [".h,p"] = {
	["text-align"] = "center"
  },
  ["p [title=Lua]"] = {
	["border-radius"] = "50%"
  }
}

--call passing table,name of input and output and additional argument with function to apply the table
SXMLUA:process(style, "simples.html","saida.html",SXMLUA.applyAsAttrStyle)
 
