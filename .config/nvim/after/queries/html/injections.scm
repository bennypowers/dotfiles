; extends
((text) @twig (#match? @twig "\\{\\%.*\\%\\}"))

((element
  (start_tag
   (tag_name) @_tag_name
   (attribute
    (attribute_name) @_attr_name
    (quoted_attribute_value
     (attribute_value) @injection.language)))
  (text) @injection.content)
 (#eq? @_attr_name "language")
 (#match? @_tag_name "code-copy|code-tab"))


