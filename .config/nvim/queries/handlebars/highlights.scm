; Expression delimiters {{ }}
["{{" "}}"] @punctuation.special
; Raw / unescaped {{{ }}}
["{{{" "}}}"] @punctuation.special
; Raw block {{{{ }}}}
["{{{{" "}}}}"] @punctuation.special

; Block open/close markers
["#" "#*" "#>"] @keyword.directive
"/" @keyword.directive

; Partial / decorator markers
">" @punctuation.special
"*" @keyword.directive
"&" @punctuation.special

; Comments
(comment) @comment
(comment_content) @comment

; Path expressions — identifier segments
(path_expression (identifier) @variable)
(path_expression (segment_literal) @string.special)

; Path separators
(path_expression "." @punctuation.delimiter)
(path_expression ".." @punctuation.delimiter)
(path_expression "../" @punctuation.delimiter)
(path_expression "./" @punctuation.delimiter)

; In block contexts, the first path is the helper name
(block_open (path_expression) @function)
(block_close (path_expression) @function)
(block_decorator_open (path_expression) @function)

; Partials: {{> name}}
(partial (path_expression) @module)

; Subexpressions: (helper arg)
(subexpression (path_expression) @function.call)
"(" @punctuation.bracket
")" @punctuation.bracket

; Hash pairs: key=value
(hash_pair (identifier) @variable.parameter)
"=" @operator

; Block params: as |x y|
"as" @keyword
"|" @punctuation.bracket
(block_params (identifier) @variable.parameter)

; else
"else" @keyword.conditional

; Literals
(boolean_literal) @boolean
(number_literal) @number
(null_literal) @constant.builtin
(string_literal) @string
