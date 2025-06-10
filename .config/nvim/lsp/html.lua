local cfg = require'lsp'

---html language server
---@type vim.lsp.ClientConfig
return {
  cmd = { 'vscode-html-language-server', '--stdio' },
  filetypes = { 'html', 'templ', 'njk', 'svg' },
  root_markers = { 'package.json', '.git' },
  single_file_support = true,
  init_options = {
    provideFormatter = true,
    embeddedLanguages = { css = true, javascript = true },
    configurationSection = { 'html', 'css', 'javascript' },
  },
  capabilities = cfg.capabilities({
    documentFormattingProvider = true,
  }),
  settings = {
    html = {
      format = {
        templating = true,
        wrapLineLength = 200,
        wrapAttributes = 'force-aligned',
      },
      editor = {
        formatOnSave = false,
        formatOnPaste = true,
        formatOnType = false,
      },
      hover = {
        documentation = true,
        references = true,
      },
    },
  },
}
