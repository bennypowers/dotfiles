---@type vim.lsp.ClientConfig
return {
  cmd = {
    'lsp-devtools', 'agent', '--', 'design-tokens-language-server',
    -- 'design-tokens-language-server',
  },
  root_markers = { 'package.json', '.git' },
  filetypes = { 'css', 'json', 'yaml' },
  settings = {
    dtls = {
      groupMarkers = {
        '_',
        '@',
        'GROUP',
        'HOOLI',
      }
    }
  },
  on_attach = function(client, bufnr)
    if vim.lsp.document_color then
      vim.lsp.document_color.enable(true, bufnr, {
        style = 'virtual'
      })
    end
  end,
}
