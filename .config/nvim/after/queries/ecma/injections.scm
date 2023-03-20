; svg``
(call_expression
 function: ((identifier) @_name (#eq? @_name "svg"))
 arguments: ((template_string) @html (#offset! @html 0 1 0 -1)))

(call_expression
 function: ((identifier) @_name
   (#eq? @_name "html"))
 arguments: ((template_string) @lit_html))

((comment) @_comment
  (#eq? @_comment "/* html */")
  (template_string) @html)

