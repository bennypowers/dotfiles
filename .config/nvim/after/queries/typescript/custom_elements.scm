; ; Defined by customElements.define call
; (call_expression
;   (member_expression
;     (identifier) @namespace
;     (property_identifier) @method)
;   (arguments
;     (string) @tag_name
;     (identifier) @class_name)
;   (#eq? @namespace "customElements")
;   (#eq? @method "define")
;   (#set! "kind" "define"))
;
; ; Defined by @customElement decorator
; ((decorator
;   (call_expression
;     (identifier) @decorator
;     (arguments
;       (string) @tag_name))
;   (#eq? @decorator "customElement"))
; (class_declaration (type_identifier) @class_name)
; (#set! "kind" "decorator"))

; imperative define call
(call_expression
  function: (member_expression
    object: (identifier)
    property: (property_identifier))
  arguments: (arguments
    (string) @tag_name
    (identifier) @class_name)
  (#eq? object "customElements")
  (#eq? property "define")
  (#set! "kind" "define"))

; exported decorated class
(export_statement
  decorator: (decorator
    (call_expression
      function: (identifier)
      arguments: (arguments (string) @tag_name))
    (#eq? function "customElement"))
  (class_declaration
    name: (type_identifier) @class_name)
  (#set! "kind" "exported"))

; local decorated class
(class_declaration
  decorator: (decorator
    (call_expression
      function: (identifier)
      arguments: (arguments (string) @tag_name)))
  name: (type_identifier) @class_name
    (#eq? function "customElement")
  (#set! "kind" "local"))

