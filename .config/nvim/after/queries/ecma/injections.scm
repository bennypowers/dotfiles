; extends

; css`<css>`, keyframes`<css>`
; Override bundled query to use css parser instead of styled
(call_expression
  function: (identifier) @_name
  (#any-of? @_name "css" "keyframes")
  arguments: (template_string
    (string_fragment) @injection.content)
  (#set! injection.combined)
  (#set! injection.language "css"))
