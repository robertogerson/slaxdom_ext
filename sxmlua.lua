local SXMLUA = require ("slaxdom_ext")

--Layout Flow function
-- nao recebe width do elemento selecionado. Precisa?
--TODO make add "%" optional
SXMLUA.flow = function(proptable) 
  local left,top
  --proptable.n_items = proptable.n_items+1 or 0 --useful for focusIndex
  proptable.margin = proptable.margin or proptable[3] or 0
  proptable.dist =  proptable.dist or proptable[2] or 20 --hgap
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
  proptable.disth =  proptable.disth or proptable[4] or 100/proptable.m --hgap
  proptable.distv =  proptable.distv or proptable[5] or 100/proptable.n --vgap
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
--@selected: xml element selected
--@key: attribute name
--@value: attribute value
SXMLUA.applyAtribb = function (selected,key,value, elementsonname)
  if elementsonname==nil then
   SXMLUA:set_attr(selected, key, value)      
  else
   local element = {attr = {}, name = elementsonname,type = "element"}
   SXMLUA:set_attr(element, "value", value)
   SXMLUA:set_attr(element, "name", key)	--attribute c and its value d
   table.insert(b.kids,element)
  end	
end

--Apply css-like lua table into xml DOM (HTML specific)
--
SXMLUA.applyAsAttrStyle = function (selected,key,value)
  SXMLUA:set_attr(selected, "style", key..":"..value)
  
end

--Apply css-like lua table into xml DOM (NCL specific)
--
SXMLUA.applyAsElemProperty = function (selected,key,value)
  if selected.name ~= "media" then
    SXMLUA:set_attr(selected, key, value)
  else             
    local element = {attr = {}, name = "property",type = "element"}
    SXMLUA:set_attr(element, "name",key)
    SXMLUA:set_attr(element, "value",value)
    table.insert(selected.kids,element)
  end
end          

return SXMLUA
