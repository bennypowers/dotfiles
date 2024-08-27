; extends

(document
  (section
    (request
      (header
        (header_entity) @_header
        (value) @_value)
      (#eq? @_value "text/html")
      (#match? @_header "^[cC][oO][nN][tT][eE][nN][tT]-[tT][yY][pP][eE]$")
      (xml_body) @injection.content
      (#set! injection.language "html"))))

