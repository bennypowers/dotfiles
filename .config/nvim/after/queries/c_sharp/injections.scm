((comment) @injection.content
  (#set! injection.language "comment"))

; new Regex(pattern) - verbatim string
(object_creation_expression
  type: (identifier) @_type
  arguments: (argument_list
    . (argument
        (verbatim_string_literal) @injection.content))
  (#eq? @_type "Regex")
  (#offset! @injection.content 0 2 0 -1)
  (#set! injection.language "regex"))

; new Regex(pattern) - regular string
(object_creation_expression
  type: (identifier) @_type
  arguments: (argument_list
    . (argument
        (string_literal) @injection.content))
  (#eq? @_type "Regex")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "regex")
  (#set! injection.include-children))

; new Regex(pattern) - raw string
(object_creation_expression
  type: (identifier) @_type
  arguments: (argument_list
    . (argument
        (raw_string_literal
          (raw_string_content) @injection.content)))
  (#eq? @_type "Regex")
  (#set! injection.language "regex"))

; Regex.Method(input, pattern) - verbatim string
(invocation_expression
  function: (member_access_expression
    expression: (identifier) @_type
    name: (identifier) @_method)
  arguments: (argument_list
    . (argument (_))
    . (argument
        (verbatim_string_literal) @injection.content))
  (#eq? @_type "Regex")
  (#any-of? @_method "Match" "IsMatch" "Replace" "Split" "Matches")
  (#offset! @injection.content 0 2 0 -1)
  (#set! injection.language "regex"))

; Regex.Method(input, pattern) - regular string
(invocation_expression
  function: (member_access_expression
    expression: (identifier) @_type
    name: (identifier) @_method)
  arguments: (argument_list
    . (argument (_))
    . (argument
        (string_literal) @injection.content))
  (#eq? @_type "Regex")
  (#any-of? @_method "Match" "IsMatch" "Replace" "Split" "Matches")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "regex")
  (#set! injection.include-children))

; Regex.Method(input, pattern) - raw string
(invocation_expression
  function: (member_access_expression
    expression: (identifier) @_type
    name: (identifier) @_method)
  arguments: (argument_list
    . (argument (_))
    . (argument
        (raw_string_literal
          (raw_string_content) @injection.content)))
  (#eq? @_type "Regex")
  (#any-of? @_method "Match" "IsMatch" "Replace" "Split" "Matches")
  (#set! injection.language "regex"))
