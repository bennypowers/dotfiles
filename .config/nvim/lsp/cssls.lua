---https://github.com/hrsh7th/vscode-langservers-extracted
---
---`css-languageserver` can be installed via `npm`:
---
---```sh
---npm i -g vscode-langservers-extracted
---```
---
---Neovim does not currently include built-in snippets. `vscode-css-language-server` only provides completions when snippet support is enabled. To enable completion,
---install a snippet plugin and add the following override to your language client capabilities during setup.
---
---```lua
-----Enable (broadcasting) snippet capability for completion local capabilities = vim.lsp.protocol.make_client_capabilities()
---capabilities.textDocument.completion.completionItem.snippetSupport = true
---
---require'lspconfig'.cssls.setup {
---  capabilities = capabilities,
---}
---```
---@type vim.lsp.ClientConfig
return {
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
  root_markers = { 'package.json', '.git' },
  -- init_options = {
  --   provideFormatter = false,
  -- },
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true
        },
      },
    },
  },
  settings = {
    css = { validate = true, lint = false },
    scss = { validate = true, lint = false },
    less = { validate = true, lint = false },
  },
}
