-- require slaxml
--local SLAXML = require 'slaxml.slaxdom' --old
local SLAXML = require ("slaxdom")

-- Get the attribute of an XML element represented by SLAXML.
-- @param xml_el
-- @param name
-- @param value
function SLAXML:get_attr(xml_el, name)
  assert(xml_el.attr)
  -- if there is the attribute in attr table, update it
  for x, attr in pairs(xml_el.attr) do
    if attr.name == name then
      return attr.value
    end
  end

  return nil
end

-- Set an value to an attribute.
-- @param xml_el
-- @param name
-- @param value
function SLAXML:set_attr(xml_el, name, value)
  assert(xml_el.attr)
  local updated = false
  -- if there is the attribute in attr table, update it
  for x, attr in pairs(xml_el.attr) do
    if attr.name == name  then 
        if attr.value:find(value)==nil then -- and  attr.name == "style" ??
		attr.value = attr.value..";"..value  
	else
		attr.value = attr.value
	end
      updated = true
      break
    end
  end

  -- if there is no the attribute, then, add it
  if not updated then
    table.insert(xml_el.attr, {["name"]=name,
                               ["value"] = value,
                               ["type"] = "attribute"})
  end
end

-- Find all the elements with attribute attr = value
-- @xml_el
-- @attr
-- @value
function SLAXML:find_by_attribute(xml_el, attr, value)
  local found_elements = {};
  if xml_el.attr then
    for k,v in pairs (xml_el.attr) do
      if k == attr and v == value then
      --if v.name == attr and v.value == value then
        table.insert ( found_elements, xml_el )
        break;
      end
    end
  end
  
  -- go into children recursively
  if xml_el.kids then
    for k,v in pairs (xml_el.kids) do
      local found_from_child_el = SLAXML:find_by_attribute (v, attr, value)
      if found_from_child_el then
        for k,v in pairs (found_from_child_el) do
          table.insert ( found_elements, v )
        end
      end
    end
  end
  
  return found_elements;
end

-- Get XML element by attribute.
-- @param xml_el
-- @param name
-- @param value
function SLAXML:get_elem_by_attr(root, attr, value)
  if root.attr then
     local attr_value = SLAXML:get_attr(root, attr)
    if attr_value == value then
      return root
    end
  end
  
  if root.kids then
    for k, child in pairs(root.kids) do
      local x = SLAXML:get_elem_by_attr(child, attr, value)
      if x then
        return x
      end
    end
  end
  return nil
end


-- Search all the elements with a tagname
-- @xml_el The XML element root where we want to start the search.
-- @tagname The tagname to be found.
-- @recursive It should be true if you want to search recursively in the
--            xml_el'schildren.
function SLAXML:get_elements_by_type(xml_el, tagname, recursive)
  local elements = {}
  if (xml_el.name == tagname) then
    table.insert (elements, xml_el)
  end
  
  if recursive and xml_el.kids then
    for k, v in pairs(xml_el.kids) do
      local x = SLAXML:get_elements_by_type (v, tagname, recursive)
      if (#x ~= 0) then
        for k1, v1 in pairs (x) do
          table.insert(elements, v1)
        end
      end
    end
  end

  return elements
end

-- Selects the DOM elements based on a CSS selector
-- @searched The string being searched.
-- @xml_el The XML element root where we want to start the search.
-- @elements The table with the found elements. 
function SLAXML:selects(searched, xml_el,elements)
  local index
  if searched:find(",")~=nil then --has a ","
    index = searched:find(",")
    --print(index)
    SLAXML:selects(string.sub(searched, 1, index-1), xml_el, elements)
    SLAXML:selects(string.sub(searched, index+1),xml_el,elements)
    
  elseif searched:find(" ")~=nil then --"element element" case
    local temp = {}
    index = searched:find(" ")
    SLAXML:selects(string.sub(searched, 1, index-1),xml_el,temp)--search parent,temp will be filled
    for u,v in ipairs(temp) do--for each parent search the son element
      SLAXML:selects(string.sub(searched, index+1) ,v, elements)
    end

  elseif searched:find('%[')~=nil and searched:find('%[')>1 then --"element[attribute]" case
    local temp = {}
    index = searched:find('%[')
    SLAXML:selects(string.sub(searched, 1, index-1),xml_el,temp)
    for u,v in ipairs(temp) do
      SLAXML:selects(string.sub(searched, index) ,v, elements)
    end
    --elseif proc:find(">")~=nil then
    
  elseif xml_el.el ~= nil then
    for i,n in ipairs(xml_el.el) do
      SLAXML:selects(searched, xml_el.el[i], elements) 
    end

    if string.sub(searched, 1, 1) == "#"and xml_el.attr["id"] == string.sub(searched, 2) then --#id case
      table.insert (elements, xml_el)
      
    elseif string.sub(searched, 1, 1) == "." and xml_el.attr["class"] == string.sub(searched, 2) then --.class case
        table.insert (elements, xml_el)
    --elseif xml_el.attr["id"] ~= nil and searched == "*" then
      
    elseif searched:find('%[')~=nil  and searched:find('%]')==searched:len() then--[attribute] case
      local specify
      index = searched:find('%[')
      specify = searched:find("=") --verifies if [attribute=specified] case
      if specify == nil then
        if index==1 and xml_el.attr[string.sub(searched,index+1,searched:len()-1)] ~= nil then
          table.insert (elements, xml_el)
        end
      else
        if index==1 and xml_el.attr[string.sub(searched,index+1,specify-1)] == string.sub(searched,specify+1,searched:len()-1) then
          table.insert (elements, xml_el)
        end
      end
    else
      if xml_el["name"]==searched and xml_el["type"]=="element" then
        table.insert (elements, xml_el)				
      --elseif proc:find("+")~=nil then
      end
    end
  end
end

-- Apply a css-like lua table into xml DOM
-- @css The css-like Lua Table
-- @doc The xml of input
-- @elementsonname If given,a created element of this name receives the attributes 
SLAXML.applyAtribb = function (css, doc, elementsonname)
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

    SLAXML:selects(k, doc.root, elements) -- search for k in doc
    for a, b in pairs (elements) do
      if elementsonname==nil then
        for c,d in pairs(v) do
          if type(d) == "function" then
            ret = d()
            removefunc = true
            SLAXML:set_attr(b, c, ret)
          else
            SLAXML:set_attr(b, c, d)
          end
        end
      else
        for c,d in pairs(v) do
          local element = {attr = {}, name = elementsonname,type = "element"}
          if type(d) == "function" then 
            ret = d()
            removefunc = true
            SLAXML:set_attr(element, "value", ret)
          else
            SLAXML:set_attr(element, "value", d)
          end

          SLAXML:set_attr(element, "name", c)	--attribute c and its value d
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
SLAXML.applyAsAttrStyle = function (css, doc)
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

    SLAXML:selects(k, doc.root, elements) --look for k in doc

    for a, b in pairs (elements) do
    --if k ~= "border" and k~="padding" and k~=
      for c,d in pairs(v) do
        if type(d) == "function" then 
          ret = d()
          removefunc = true
          SLAXML:set_attr(b, "style", c..":"..ret)
        else
          SLAXML:set_attr(b, "style", c..":"..d) -- (ao elemento selecionado, b recebe o style c com atributo d) se alterar a tabela pra deixar style implicito?
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
SLAXML.applyAsElemProperty = function (css, doc)
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

    SLAXML:selects(k, doc.root, elements)  --look for k in doc
    for a, b in pairs (elements) do
      if b.name ~= "media" then
        for c,d in pairs(v) do
          if type(d) == "function" then
            ret = d()
            removefunc = true
            SLAXML:set_attr(b, c, ret)
          else
            SLAXML:set_attr(b, c, d)
          end
        end
      else
        for c,d in pairs(v) do
          local element = {attr = {}, name = "property",type = "element"}
          if type(d) == "function" then 
            ret = d()
            removefunc = true
            SLAXML:set_attr(element, "value", ret)
          else
            SLAXML:set_attr(element, "value", d)
          end

          SLAXML:set_attr(element, "name", c) --attribute c and its value d
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


--Open XML,process and Save
--@css the css-like Lua Table
--@filein name or location of base xml 
--@elementsonname If given,a created element of this name receives the attributes 
function SLAXML:process(css, filein, out, applyfunction,elementsonname) 
  local name = out or "out.xml"
  local file = io.open(filein);
  local xmlfile = file:read("*all")
  file:close()

  local doc = SLAXML:dom(xmlfile)
	
  if applyfunction == nil then 
    print("basic case")
    applyfunction = SLAXML.applyAtribb 
  end

  --chamada da ferramenta passando a tabela e o XML (seu DOM parseado no caso)
  applyfunction(css, doc, elementsonname)

  --escreve o gerado em arquivo
  file = io.open(out, "w")
  file:write(SLAXML:serialize(doc)) --serialize:passa a tabela para texto
  file:flush()
  file:close()
end


-- Serialize an XML document represented as a SLAXML dom table
-- @param xml_el The SLAXML dom table.
-- @param ntabs The number of tabs to format the current element. 
function SLAXML:serialize (xml_el, ntabs, TAB)
  ntabs = ntabs or 0 -- the default value for ntabs is zero
  TAB   = TAB or '\t' -- default TAB character

  local str_el = ""    
  if xml_el.type == "pi" then
    str_el = "<?" .. xml_el.name .. " " .. xml_el.value .."?>\n"
    return str_el
  else 
    if xml_el.type == "element" then
      for i = 0,ntabs do
        str_el = str_el .. TAB
      end
      str_el = str_el .. "<" .. xml_el.name
      if xml_el.attr then
        for k, v in pairs (xml_el.attr) do
          if v.name ~= nil then
            str_el = str_el .. " " .. v.name .. "=\"" .. v.value .."\""
          end
        end
      end
    else
       if xml_el.type == "text" then --this if was commented
        return xml_el.value --
       end	--
    end
    
    -- go recursively 
    if xml_el.kids and #xml_el.kids > 0 then
      local new_ntabs = ntabs
      if xml_el.type == "element" then
        str_el = str_el .. ">\n"
        new_ntabs = ntabs + 1
      end
      
      for k, xml_kid in pairs (xml_el.kids) do
        str_el = str_el .. SLAXML:serialize(xml_kid, new_ntabs, TAB)
      end
      
      if xml_el.type == "element" and #xml_el.kids then
        for i = 0,ntabs do
          str_el = str_el .. TAB
        end
        str_el = str_el .. "</" .. xml_el.name .. ">\n"
      end
    else
      if xml_el.type == "element" then
        str_el = str_el .. "/>\n" 
      end
    end
  end

  return str_el
end

return SLAXML
