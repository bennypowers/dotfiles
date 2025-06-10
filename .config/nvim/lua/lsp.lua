local M = {}

function M.capabilities(caps)
  caps = caps or {}
  local lsp_status = require 'lsp-status'
  ---@note: skip next line after nvim-lspconfig finishes porting to 0.11
  -- return vim.tbl_deep_extend('force', require'blink.cmp'.get_lsp_capabilities(lsp_status.capabilities), caps)
  return lsp_status.capabilities
end

function M.on_attach(client, bufnr)
  -- require 'lsp-format'.on_attach(client, bufnr)
  require 'lsp-status'.on_attach(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    require 'nvim-navic'.attach(client, bufnr)
  end
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true)
  end
end

au('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      M.on_attach(client, args.buf)
    end
  end
})

function M.config()
  return {
    capabilities = M.capabilities(),
    on_attach = M.on_attach,
  }
end

---@param markers string|string[]
function M.required_root_markers(markers)
  return function(buf, cb)
    local path = vim.api.nvim_buf_get_name(buf)
    local tsconfig_dir = vim.fs.dirname(vim.fs.find(markers, { path = path, upward = true })[1])
    if tsconfig_dir then
      cb(tsconfig_dir)
    end
  end
end

return M
