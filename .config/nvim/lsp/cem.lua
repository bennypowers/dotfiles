---https://bennypowers.dev/cem/
---
vim.lsp.log.set_level 'info'


---`cem lsp` provides editor features for custom-elements a.k.a. web components
---
---Install with go
---```sh
---go install bennypowers.dev/cem
---```
---Or with NPM
---```sh
---npm install -g @pwrs/cem
---```
---
---@type vim.lsp.Config
return {
  cmd = { 'cem', 'lsp' },
  -- cmd = { 'sh', '-c', 'cem lsp -v 2> /home/bennyp/cem.log' },
  -- cmd = { 'lsp-devtools', 'agent', '--', 'cem', 'lsp' },
  trace = 'verbose',
  root_markers = {
    'custom-elements.json',
    'package.json',
    '.git',
  },
  filetypes = {
    'handlebars',
    'html',
    'javascript',
    'jinja',
    'typescript',
  },
}
