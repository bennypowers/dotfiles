; Output delimiters {{ }}
["{{" "{{-" "{{~"] @punctuation.special
["}}" "-}}" "~}}"] @punctuation.special

; Statement delimiters {% %}
["{%" "{%-" "{%~"] @keyword.directive
["%}" "-%}" "~%}"] @keyword.directive

; Comment {# #}
(comment) @comment
(comment ["{#" "{#-" "{#~"] @comment.delimiter)
(comment ["#}" "-#}" "~#}"] @comment.delimiter)

; Control flow keywords
["if" "elif" "elseif" "else" "endif"] @keyword.conditional
["for" "endfor" "recursive"] @keyword.repeat
"in" @keyword.operator

; Block / structural keywords
["block" "endblock"] @keyword
["macro" "endmacro"] @keyword
["call" "endcall"] @keyword
["filter" "endfilter"] @keyword
["set" "endset"] @keyword
["with" "endwith"] @keyword
["autoescape" "endautoescape"] @keyword
["raw" "endraw" "verbatim" "endverbatim"] @keyword
"do" @keyword
"scoped" @keyword

; Import / include keywords
["extends" "include" "import" "from" "as"] @keyword.import
["context" "ignore" "missing" "without"] @keyword

; Logical / test operators
["not"] @keyword.operator
["and" "or"] @keyword.operator
["is"] @keyword.operator

; Generic tag name (unknown/custom tags)
(generic_tag name: (identifier) @keyword.directive)

; Block name label
(block_statement name: (identifier) @label)

; Macro / call definition name
(macro_statement name: (identifier) @function)

; Set / for variable binding
(set_statement variable: (identifier) @variable.parameter)
(for_statement variable: (identifier) @variable.parameter)

; Filter expression: foo | bar
(filter_expression name: (identifier) @function.method)
"|" @operator

; Test expression: foo is defined
(test_expression name: (identifier) @function.method)

; Call expression: foo(...)
(call_expression function: (_) @function.call)

; Member access: foo.bar
(member_expression object: (_) @variable)
(member_expression property: (identifier) @variable.member)
"." @punctuation.delimiter

; Subscript: foo[bar]
(subscript_expression object: (_) @variable)
"[" @punctuation.bracket
"]" @punctuation.bracket

; Keyword arguments: key=val
(keyword_argument key: (identifier) @variable.parameter)

; Plain identifiers (variables)
(identifier) @variable

; Literals
(boolean) @boolean
(integer) @number
(float) @number.float
(string) @string
(none) @constant.builtin

; Arithmetic / comparison operators
["+" "-" "*" "**" "/" "//" "%"] @operator
["==" "!=" "===" "!==" "<" "<=" ">" ">="] @operator
["~" "??" "?" "?."] @operator
"=" @operator

; Punctuation
"," @punctuation.delimiter
":" @punctuation.delimiter
"(" @punctuation.bracket
")" @punctuation.bracket
"{" @punctuation.bracket
"}" @punctuation.bracket
