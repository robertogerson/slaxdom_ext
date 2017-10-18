# slaxdom_ext
Extensions to SLAXML (https://github.com/Phrogz/SLAXML) API

## Functions added to SLAXML

  * `SLAXML:get_attr (xml_el, name)`: Returns the value of an attribute from SLAXML
    element.
  * `SLAXML:set_attr (xml_el, name, value)`: Sets the value of an attribute of
    an SLAXML element.
  * `SLAXML:find_by_attribute (xml_el, attr, value)`: Returns all the elements
    with attribute `attr` equals to `value`.
  * `SLAXML:get_elem_by_attr (root, attr, value)`: Returns the first element
    with attribute `attr` equals to `value`.
  * `SLAXML:get_elements_by_type (xml_el, tagname, recursive)`: Search for all
    elements with tagname equals to `tagname`.
  * `SLAXML:selects (css_selector, xml_el, elements)`: Selects the SLAXML
    elements based on a CSS selector.

## About the CSS selectors
slaxdom_ext supports the selection of XML elements based on CSS selectors.

Currently, the following CSS selectors are implemented:

  * `.class`: e.g. ".intro" - Selects all elements with class="intro".
  * `#id`: e.g. "#firstname" - Selects the element with id="firstname".
  * `element`: e.g. "p" - Selects all &lt;p&gt; elements.
  * `element,element`: e.g. "d,p" - Selects all &lt;d&gt; elements and all
    &lt;p&gt; elements.
  * `element element`: e.g. "d p" - Selects all &lt;p&gt; elements inside
    &lt;d&gt; elements.
  * `[attribute]`: e.g. "[target]" - Selects all elements with an attribute target.
  * `[attribute=value]`: e.g. "[target=chosen]" - Selects all elements with target="chosen".

## TODO

  - [x] Add functions to automaticcaly define layout templates, such as flow, box, and grid.
  - [ ] Add missing CSS selectors.
  - [ ] Can we apply the styles in NCL in cascade?  How?
  - [ ] Nested rules?
