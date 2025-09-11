---@brief
---
--- https://github.com/golang/tools/tree/master/gopls
---
--- Google's lsp server for golang.

local mod_cache = nil

---@param fname string
---@return string?
local function get_root(fname)
  if mod_cache and fname:sub(1, #mod_cache) == mod_cache then
    local clients = vim.lsp.get_clients { name = 'gopls' }
    if #clients > 0 then
      return clients[#clients].config.root_dir
    end
  end
  return vim.fs.root(fname, 'go.work') or vim.fs.root(fname, 'go.mod') or vim.fs.root(fname, '.git')
end

---@type vim.lsp.ClientConfig
return {
  cmd = { 'sh', '-c', 'GOTOOLCHAIN=auto gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    -- see: https://github.com/neovim/nvim-lspconfig/issues/804
    if mod_cache then
      on_dir(get_root(fname))
      return
    end
    local cmd = { 'go', 'env', 'GOMODCACHE' }
    vim.system(cmd, { text = true }, function(output)
      if output.code == 0 then
        if output.stdout then
          mod_cache = vim.trim(output.stdout)
        end
        on_dir(get_root(fname))
      else
        vim.schedule(function()
          vim.notify(('[gopls] cmd failed with code %d: %s\n%s'):format(output.code, cmd, output.stderr))
        end)
      end
    end)
  end,
  settings = {
    gopls = {
      buildFlags =  {"-tags=e2e"},
      semanticTokens = true,
      completion = {
        usePlaceholders = true,
      }
    }
  },
  on_attach = function (client, bufnr)
    au("BufWritePre", {
      pattern = "*.go",
      callback = function()
        local params = vim.lsp.util.make_range_params(0, "utf-8")
        params.context = {only = {"source.organizeImports"}}
        -- buf_request_sync defaults to a 1000ms timeout. Depending on your
        -- machine and codebase, you may want longer. Add an additional
        -- argument after params if you find that you have to write the file
        -- twice for changes to be saved.
        -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
        for cid, res in pairs(result or {}) do
          for _, r in pairs(res.result or {}) do
            if r.edit then
              local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
              vim.lsp.util.apply_workspace_edit(r.edit, enc)
            end
          end
        end
        vim.lsp.buf.format({async = false})
      end
    })
  end
}
