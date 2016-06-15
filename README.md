# slaxdom_ext
Extensions to SLAXML (https://github.com/Phrogz/SLAXML) API


## CSS selectors
slaxdom_ext allows to select DOM nodes based on CSS selectors. Currently, the
following selectors are implemented:

  * `.class`: e.g. ".intro" - Selects all elements with class="intro".
  * `#id`: e.g. "#firstname" - Selects the element with id="firstname".
  * `element`: e.g. "p" - Selects all &lt;p&gt; elements.
  * `element, element`: e.g. "d, p" - Selects all &lt;d&gt; elements and all
    &lt;p&gt; elements.
  * `element element`: e.g. "d p" - Selects all &lt;p&gt; elements inside
    &lt;d&gt; elements.

