(assignment_expression
  left: (member_expression
          property: (property_identifier) @_prop
          (#eq? @_prop "innerHTML"))
  right: (template_string) @html
    (#offset! @html 0 1 0 -1))

(assignment_expression
   left: (member_expression
           property: (property_identifier) @_prop
           (#eq? @_prop "innerHTML"))
   right: (string (string_fragment) @html
                  (#offset! @html 0 1 0 -1)))


