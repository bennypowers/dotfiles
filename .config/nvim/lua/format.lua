-- Polyfill `vim.lsp.buf.format` from neovim 0.8
--
-- START COPYPASTA https://github.com/neovim/neovim/commit/5b04e46d23b65413d934d812d61d8720b815eb1c
local util = require 'vim.lsp.util'
--- Formats a buffer using the attached (and optionally filtered) language
--- server clients.
---
--- @param options table|nil Optional table which holds the following optional fields:
---     - formatting_options (table|nil):
---         Can be used to specify FormattingOptions. Some unspecified options will be
---         automatically derived from the current Neovim options.
---         @see https://microsoft.github.io/language-server-protocol/specification#textDocument_formatting
---     - timeout_ms (integer|nil, default 1000):
---         Time in milliseconds to block for formatting requests. Formatting requests are current
---         synchronous to prevent editing of the buffer.
---     - bufnr (number|nil):
---         Restrict formatting to the clients attached to the given buffer, defaults to the current
---         buffer (0).
---     - filter (function|nil):
---         Predicate used to filter clients. Receives a client as argument and must return a
---         boolean. Clients matching the predicate are included. Example:
---
---         <pre>
---         -- Never request typescript-language-server for formatting
---         vim.lsp.buf.format {
---           filter = function(client) return client.name ~= "tsserver" end
---         }
---         </pre>
---
---     - id (number|nil):
---         Restrict formatting to the client with ID (client.id) matching this field.
---     - name (string|nil):
---         Restrict formatting to the client with name (client.name) matching this field.
vim.lsp.buf.format = vim.lsp.buf.format or function(options)
  options = options or {}
  local bufnr = options.bufnr or vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({
    id = options.id,
    bufnr = bufnr,
    name = options.name,
  })

  if options.filter then
    clients = vim.tbl_filter(options.filter, clients)
  elseif options.id then
    clients = vim.tbl_filter(
      function(client) return client.id == options.id end,
      clients
    )
  elseif options.name then
    clients = vim.tbl_filter(
      function(client) return client.name == options.name end,
      clients
    )
  end

  clients = vim.tbl_filter(
    function(client) return client.supports_method 'textDocument/formatting' end,
    clients
  )

  if #clients == 0 then
    vim.notify '[LSP] Format request failed, no matching language servers.'
  end

  local timeout_ms = options.timeout_ms or 1000
  for _, client in pairs(clients) do
    local params = util.make_formatting_params(options.formatting_options)
    local result, err = client.request_sync('textDocument/formatting', params, timeout_ms, bufnr)
    if result and result.result then
      util.apply_text_edits(result.result, bufnr, client.offset_encoding)
    elseif err then
      vim.notify(string.format('[LSP][%s] %s', client.name, err), vim.log.levels.WARN)
    end
  end
end
-- END COPYPASTA
