local M = {}

function M.capabilities(caps)
  caps = caps or {}
  local lsp_status = require 'lsp-status'
  ---@note: skip next line after nvim-lspconfig finishes porting to 0.11
  -- return vim.tbl_deep_extend('force', require'blink.cmp'.get_lsp_capabilities(lsp_status.capabilities), caps)
  return lsp_status.capabilities
end

function M.on_attach(client, bufnr)
  require 'lsp-format'.on_attach(client, bufnr)
  require 'lsp-status'.on_attach(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    require 'nvim-navic'.attach(client, bufnr)
  end
  if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true)
  end
end

function M.config()
  return {
    capabilities = M.capabilities(),
    on_attach = M.on_attach,
  }
end

return M
