; Forked from tree-sitter-regex
; The MIT License (MIT) Copyright (c) 2014 Max Brunsfeld

; Priority 150 so injection highlights override LSP semantic tokens (125)
([
  "("
  ")"
  "(?"
  "(?:"
  "(?<"
  "<"
  ">"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket
(#set! priority 150))

((group_name) @property
  (#set! priority 150))

; These are escaped special characters that lost their special meaning
; -> no special highlighting
((identity_escape) @string.regexp
  (#set! priority 150))

((class_character) @constant
  (#set! priority 150))

((decimal_digits) @number
  (#set! priority 150))

([
  (control_letter_escape)
  (character_class_escape)
  (control_escape)
  (boundary_assertion)
  (non_boundary_assertion)
] @string.escape
  (#set! priority 150))

([
  "*"
  "+"
  "?"
  "|"
  "="
  "!"
  "-"
  "\\k"
  (lazy)
] @operator
  (#set! priority 150))

([
  (start_assertion)
  (end_assertion)
  ","
] @punctuation.delimiter
  (#set! priority 150))

((any_character) @variable.builtin
  (#set! priority 150))
