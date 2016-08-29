# SXMLUA(slaxdom_ext)
Extensions to SLAXML (https://github.com/Phrogz/SLAXML) API


## CSS selectors
SXMLua(slaxdom_ext) supports the selection of XML elements based on CSS selectors.

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

  * Add other selectors
  * Add functions to library like create templates,grids...
