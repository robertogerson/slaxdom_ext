local SXMLUA = require ("slaxdom_ext")

--Layout Flow function
-- nao recebe width do elemento selecionado. Precisa?
--TODO make add "%" optional
SXMLUA.flow = function(proptable) 
  local left,top
  --proptable.n_items = proptable.n_items+1 or 0 --useful for focusIndex
  proptable.margin = proptable.margin or proptable[3] or 0
  proptable.dist =  proptable.dist or proptable[2] or 20
  proptable.top = proptable.top or proptable[4] or nil
  proptable.height = proptable.height or proptable[5] or 25 --many optional parameters
  if proptable.left ~= nil then 
    proptable.left = proptable.left + proptable.dist 
  else
    proptable.left = proptable.margin 
  end
  if proptable.n_items ~= nil then 
    proptable.n_items = proptable.n_items+1
  else
    proptable.n_items = 0
  end

  print(proptable.margin,proptable.n_items)
  --proptable.n_items = proptable.n_items+1
  --proptable.focusIndex = proptable.n_items
  --proptable.left = (proptable.left + proptable.dist) 
  if proptable.left >= 100 then
    proptable.left = 0
    if proptable.top == nil then 
      proptable.top = 0
    end
    proptable.top = proptable.top + proptable.height
  end
  left = proptable.left.."%" 
  if proptable.top == nil then
    top = nil
  else
    top = proptable.top.."%"
  end
  
  return  {["left"] = left,["focusIndex"] = proptable.n_items,["top"] = top}
end

--Layout Box function
-- nao recebe height do elemento selecionado. Precisa?
--TODO make add "%" optional
SXMLUA.box = function(proptable) 
  local left,top
  --proptable.n_items = proptable.n_items+1 or 0 --useful for focusIndex
  proptable.margin = proptable.margin or proptable[3] or 0
  proptable.dist =  proptable.dist or proptable[2] or 20
  proptable.left = proptable.left or proptable[4] or nil
  --proptable.height = proptable.height or proptable[5] or 25 
  proptable.width = proptable.width or proptable[5] or 25--many optional parameters
  if proptable.n_items ~= nil then 
    proptable.n_items = proptable.n_items+1
  else
    proptable.n_items = 0
  end  
  if proptable.top ~= nil then 
    proptable.top = proptable.top + proptable.dist 
  else
    proptable.top = proptable.margin 
  end

  print(proptable.margin,proptable.n_items)
  --proptable.n_items = proptable.n_items+1
  --proptable.focusIndex = proptable.n_items 
  if proptable.top >= 100 then
    proptable.top = 0
    if proptable.left == nil then 
      proptable.left = 0
    end
    proptable.left = proptable.left + proptable.width
  end
  top = proptable.top.."%" 
  if proptable.left == nil then
    left = nil
  else
    left = proptable.left.."%"
  end
  
  return  {["left"] = left,["focusIndex"] = proptable.n_items,["top"] = top}
end

--Layout Grid function
--TODO  make add "%" optional
--precisa receber width e height dos elementos?
SXMLUA.grid = function(proptable)
  local left,top
  --proptable.n_items = proptable.n_items+1 or 0
  proptable.m = proptable.m or proptable[2] or 5 --rows
  proptable.n = proptable.n or proptable[3] or 5 --columns
  proptable.disth =  proptable.disth or proptable[4] or 100/proptable.m
  proptable.distv =  proptable.distv or proptable[5] or 100/proptable.n
  proptable.margin = proptable.margin or proptable[6] or 0
  proptable.contv = proptable.contv or 0

  if proptable.n_items ~= nil then 
    proptable.n_items = proptable.n_items+1
  else
    proptable.n_items = 0
  end
  if proptable.conth ~= nil and proptable.conth < proptable.m-1 then 
    proptable.conth = proptable.conth+1    
  else
    if proptable.conth ~= nil then
      proptable.contv = proptable.contv+1
    end
    proptable.conth = 0 
  end

  left = proptable.margin+proptable.conth*proptable.disth .. "%"
  top = proptable.margin+proptable.contv*proptable.distv .. "%"

  return  {["left"] = left,["focusIndex"] = proptable.n_items,["top"] = top}
end

-- Apply a css-like lua table into xml DOM
-- @css The css-like Lua Table
-- @doc The xml of input
-- @elementsonname If given,a created element of this name receives the attributes 
SXMLUA.applyAtribb = function (css, doc, elementsonname)
  local ret
  local removefunc=false
  for k, v in pairs (css) do
    local elements = {}
		
    for c,d in pairs(v) do
      if type(css[k][c]) == "table" and c ~= "_style" then
	      for e, f in pairs(d) do
	        css[k][e] = f--put key e and value f in table of the selector v
	      end
	      --[[else
	      func = css[k][c][1]
	      --table.remove(d,1)
	      ret = func (d)
	      SXMLUA:set_attr(b, c, ret)
	      ]]
	      css[k][c] = nil --deletes table entry to allow serialize
      end
    end

    SXMLUA:selects(k, doc.root, elements) -- search for k in doc
    for a, b in pairs (elements) do
      if elementsonname==nil then
        for c,d in pairs(v) do
          if type(d) == "function" then
            ret = d()
            removefunc = true
            SXMLUA:set_attr(b, c, ret)
          else
            SXMLUA:set_attr(b, c, d)
          end
        end
      else
        for c,d in pairs(v) do
          local element = {attr = {}, name = elementsonname,type = "element"}
          if type(d) == "function" then 
            ret = d()
            removefunc = true
            SXMLUA:set_attr(element, "value", ret)
          else
            SXMLUA:set_attr(element, "value", d)
          end

          SXMLUA:set_attr(element, "name", c)	--attribute c and its value d
          table.insert(b.kids,element)
        end
      end
    end

    if removefunc == true then
      for c,d in pairs(v) do
        if type(d) == "function" then
          css[k][c] = nil
        end
      end
    end
  end	
end

--Apply css-like lua table into xml DOM (HTML specific)
--@css The css-like Lua Table
--@doc The xml of input
SXMLUA.applyAsAttrStyle = function (css, doc)
  local ret
  local removefunc=false
  for k, v in pairs (css) do
    local elements = {}

    for c,d in pairs(v) do
      if type(css[k][c]) == "table" then
        for e, f in pairs(d) do
	  css[k][e] = f--put key e and value f in table of the selector v
        end

        css[k][c] = nil --deletes table entry to allow serialize
      end
    end

    SXMLUA:selects(k, doc.root, elements) --look for k in doc

    for a, b in pairs (elements) do
    --if k ~= "border" and k~="padding" and k~=
      for c,d in pairs(v) do
        if type(d) == "function" then 
          ret = d()
          removefunc = true
          SXMLUA:set_attr(b, "style", c..":"..ret)
        else
          SXMLUA:set_attr(b, "style", c..":"..d) -- (ao elemento selecionado, b recebe o style c com atributo d) se alterar a tabela pra deixar style implicito?
        end
      end
      --end
     end

    if removefunc == true then
      for c,d in pairs(v) do
        if type(d) == "function" then
          css[k][c] = nil
        end
      end
    end
  end
end

--Apply css-like lua table into xml DOM (NCL specific)
--@css The css-like Lua Table
--@doc The xml of input
SXMLUA.applyAsElemProperty = function (css, doc)
  local resultstyle = {}
  local removefunc=false
  for k, v in pairs (css) do
    local elements = {}
    for c,d in pairs(v) do
      if type(css[k][c]) == "table" and c ~= "_style" then
        for e, f in pairs(d) do
          css[k][e] = f--put key e and value f in table of the selector v
        end
        css[k][c] = nil --deletes table entry to allow serialize
      end
    end

    SXMLUA:selects(k, doc.root, elements)  --look for k in doc
    for a, b in pairs (elements) do
      if b.name ~= "media" then
        for c,d in pairs(v) do
          if type(d) == "function" then
            ret = d()
            removefunc = true
            SXMLUA:set_attr(b, c, ret)
	        elseif type(d) == "table" and c == "_style" then 
	          resultstyle = d[1](d);  
            for e,f in pairs (resultstyle) do
              SXMLUA:set_attr(b, e, f) 
            end
            removefunc = true --css[k][c] = nil --deletes table entry to allow serialize
          else
            SXMLUA:set_attr(b, c, d)
          end
        end
      else
        for c,d in pairs(v) do
          --
          if type(d) == "table" and c == "_style" then
            resultstyle = d[1](d);  
            for e,f in pairs (resultstyle) do
              local element = {attr = {}, name = "property",type = "element"}
              SXMLUA:set_attr(element, "name",e)
              SXMLUA:set_attr(element, "value",f)
              table.insert(b.kids,element)
            end
            removefunc = true--css[k][c] = nil --deletes table entry to allow serialize
          else
            local element = {attr = {}, name = "property",type = "element"}
            if type(d) == "function" then 
              ret = d()
              removefunc = true
              SXMLUA:set_attr(element, "value", ret)            
            else
              SXMLUA:set_attr(element, "value", d)
            end
            SXMLUA:set_attr(element, "name", c) --attribute c and its value d
            table.insert(b.kids,element)
          end
        end
      end
    end

    if removefunc == true then
      for c,d in pairs(v) do
        if type(d) == "function" or type(d) == "table" then
          css[k][c] = nil
        end
      end
    end
  end
end

return SXMLUA
