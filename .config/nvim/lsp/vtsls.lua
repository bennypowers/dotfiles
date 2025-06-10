local cfg = require'lsp'

---https://github.com/yioneko/vtsls
---
---`vtsls` can be installed with npm:
---```sh
---npm install -g @vtsls/language-server
---```
---
---To configure a TypeScript project, add a
---[`tsconfig.json`](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html)
---or [`jsconfig.json`](https://code.visualstudio.com/docs/languages/jsconfig) to
---the root of your project.
---@type vim.lsp.ClientConfig
return {
  name = 'TypeScript',
  cmd = { 'vtsls', '--stdio' },
  root_markers = {'tsconfig.json', 'package.json', 'jsconfig.json', '.git'},
  root_dir = cfg.required_root_markers {'jsconfig.json', 'tsconfig.json'},
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  settings = {
    typescript = {
      inlayHints = {
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
      referencesCodeLens = {
        enabled = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      format = {
        enable = false,
        enabled = false
      },
    },
  },
}
