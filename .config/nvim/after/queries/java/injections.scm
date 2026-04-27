([
  (block_comment)
  (line_comment)
] @injection.content
  (#set! injection.language "comment"))

((block_comment) @injection.content
  (#lua-match? @injection.content "/[*][*][%s]")
  (#set! injection.language "javadoc"))

; markdown-style javadocs https://openjdk.org/jeps/467
((line_comment) @injection.content
  (#lua-match? @injection.content "^///%s")
  (#set! injection.language "javadoc"))

((method_invocation
  name: (identifier) @_method
  arguments: (argument_list
    .
    (string_literal
      .
      (_) @injection.content)))
  (#any-of? @_method "format" "printf")
  (#set! injection.language "printf"))

((method_invocation
  object: (string_literal
    (string_fragment) @injection.content)
  name: (identifier) @_method)
  (#eq? @_method "formatted")
  (#set! injection.language "printf"))

; Pattern.compile(pattern) / Pattern.matches(pattern, input)
((method_invocation
  object: (identifier) @_type
  name: (identifier) @_method
  arguments: (argument_list
    .
    (string_literal) @injection.content))
  (#eq? @_type "Pattern")
  (#any-of? @_method "compile" "matches")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "regex")
  (#set! injection.include-children))

; String regex methods: .matches(pattern), .split(pattern),
; .replaceAll(pattern, ...), .replaceFirst(pattern, ...)
((method_invocation
  name: (identifier) @_method
  arguments: (argument_list
    .
    (string_literal) @injection.content))
  (#any-of? @_method "matches" "replaceAll" "replaceFirst" "split")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "regex")
  (#set! injection.include-children))
