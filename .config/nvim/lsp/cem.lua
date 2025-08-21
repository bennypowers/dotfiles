---https://bennypowers.dev/cem/
---
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
  cmd = { 'cem', 'lsp', '-v' },
  on_attach = function() vim.lsp.set_log_level'DEBUG' end,
  root_markers = {
    'custom-elements.json',
    'package.json',
    '.git',
  },
  filetypes = {
    'html',
    'typescript',
    'javascript',
  },
}

