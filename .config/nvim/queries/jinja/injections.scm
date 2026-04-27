((text) @injection.content
 (#set! injection.language "html")
 (#set! injection.combined))

((text) @injection.content
 (#match? @injection.content "^---")
 (#trim-to-frontmatter! @injection.content)
 (#set! injection.language "yaml"))
