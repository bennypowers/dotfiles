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
  require('lsp-status').on_attach(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then require('nvim-navic').attach(client, bufnr) end
  if client.server_capabilities.inlayHintProvider then vim.lsp.inlay_hint.enable(true) end
end

au('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then M.on_attach(client, args.buf) end
  end,
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
    if tsconfig_dir then cb(tsconfig_dir) end
  end
end

-- until https://github.com/neovim/neovim/pull/32820
au('CompleteChanged', {
  callback = function()
    local event = vim.v.event
    if not event or not event.completed_item then return end

    local cy = event.row
    local cx = event.col
    local cw = event.width
    local ch = event.height

    local item = event.completed_item
    local lsp_item = item and item.user_data and item.user_data.nvim and item.user_data.nvim.lsp.completion_item
    local client = vim.lsp.get_clients({ bufnr = 0 })[1]

    if not client or not lsp_item then return end

    client:request('completionItem/resolve', lsp_item, function(_, result)
      vim.cmd 'pclose'

      if result and result.documentation then
        local docs = result.documentation.value or result.documentation
        if type(docs) == 'table' then docs = table.concat(docs, '\n') end
        if not docs or docs == '' then return end

        local buf = vim.api.nvim_create_buf(false, true)
        vim.bo[buf].bufhidden = 'wipe'

        local contents = vim.lsp.util.convert_input_to_markdown_lines(docs)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, contents)
        vim.treesitter.start(buf, 'markdown')

        local dx = cx + cw + 1
        local dw = 60
        local anchor = 'NW'

        if dx + dw > vim.o.columns then
          dw = vim.o.columns - dx
          anchor = 'NE'
        end

        local win = vim.api.nvim_open_win(buf, false, {
          relative = 'editor',
          row = cy,
          col = dx,
          width = dw,
          height = ch,
          anchor = anchor,
          border = 'none',
          style = 'minimal',
          zindex = 60,
        })

        vim.wo[win].conceallevel = 2
        vim.wo[win].wrap = true
        vim.wo[win].previewwindow = true
      end
    end)
  end,
})
au('CompleteDone', {
  callback = function() vim.cmd 'pclose' end,
})

return M
