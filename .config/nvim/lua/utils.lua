local M = {}

--- Create an LSP root_dir function that activates only when
--- one of the given marker files is found in an ancestor directory.
--- @param markers string|string[] filenames to search for (e.g. 'tsconfig.json')
--- @return fun(buf: integer, cb: fun(root: string))
function M.required_root_markers(markers)
  return function(buf, cb)
    local path = vim.api.nvim_buf_get_name(buf)
    local dir = vim.fs.dirname(vim.fs.find(markers, { path = path, upward = true })[1])
    if dir then cb(dir) end
  end
end

--- Get enabled LSP configs, optionally filtered by name prefix.
--- @param arg? string prefix to filter by
--- @return vim.lsp.Config[]
function M.get_enabled_lsp_clients(arg)
  return vim.iter(vim.lsp._enabled_configs)
    :filter(function(config)
      if arg and arg:len() > 0 then
        return vim.startswith(config.resolved_config.name, arg)
      else
        return true
      end
    end)
    :totable()
end

--- Get active LSP clients on the current buffer, optionally filtered by name prefix.
--- @param arg? string prefix to filter by
--- @return vim.lsp.Client[]
function M.get_active_lsp_clients(arg)
  return vim.iter(vim.lsp.get_clients { bufnr = 0 })
    :filter(function(client)
      if arg and arg:len() > 0 then
        return vim.startswith(client.name, vim.trim(arg))
      else
        return true
      end
    end)
    :totable()
end

--- Start an LSP server by name, or all servers matching the current filetype.
--- @param info vim.api.keyset.create_user_command.command_args
function M.lsp_start(info)
  local server_name = string.len(info.args) > 0 and info.args or nil
  if server_name then
    for name in vim.spairs(vim.lsp._enabled_configs) do
      if name == server_name then
        vim.lsp.start(vim.lsp.config[name])
        return
      end
    end
  end
  for _, config in vim.spairs(vim.lsp._enabled_configs) do
    for _, filetype in ipairs(config.resolved_config.filetypes) do
      if filetype == vim.bo.filetype then
        vim.lsp.start(config)
      end
    end
  end
end

--- Stop LSP clients by name, or all clients on the current buffer.
--- Append ++force to args to force-stop.
--- @param info vim.api.keyset.create_user_command.command_args
function M.lsp_stop(info)
  local args = info.args
  local force = false
  args = args:gsub('%+%+force', function()
    force = true
    return ''
  end)
  local clients = #args == 0
    and vim.lsp.get_clients { bufnr = 0 }
    or vim.lsp.get_clients { name = vim.trim(args) }
  for _, client in ipairs(clients) do
    client:stop(force)
  end
end

--- Restart LSP clients by name, or pick from active clients via Snacks picker.
--- Stops matching clients then re-enables them after they've shut down.
--- @param info vim.api.keyset.create_user_command.command_args
function M.lsp_restart(info)
  local name = info.args and #info.args > 0 and vim.trim(info.args) or nil

  local function restart(client_name)
    local clients = vim.lsp.get_clients { name = client_name, bufnr = 0 }
    for _, client in ipairs(clients) do
      local bufs = vim.tbl_keys(client.attached_buffers)
      client:stop()
      vim.defer_fn(function()
        for _, buf in ipairs(bufs) do
          vim.lsp.start(vim.lsp.config[client_name], { bufnr = buf })
        end
      end, 500)
    end
  end

  if name then
    restart(name)
  else
    local clients = vim.lsp.get_clients { bufnr = 0 }
    if #clients == 0 then
      vim.notify('No active LSP clients', vim.log.levels.WARN)
    elseif #clients == 1 then
      restart(clients[1].name)
    else
      vim.ui.select(
        vim.tbl_map(function(c) return c.name end, clients),
        { prompt = 'Restart LSP client:' },
        function(choice)
          if choice then restart(choice) end
        end
      )
    end
  end
end

--- Open the LSP log file in a new tab.
function M.lsp_log()
  vim.cmd.tabnew(vim.lsp.log.get_filename())
end

--- Install a list of plugin specs
--- @param ... string|vim.pack.Spec
function M.pack(...)
  return vim.pack.add(vim.iter { ... }:map(
  ---@param r string|table
    function(r)
      if type(r) == 'table' or r:match '^https?://' then
        return r
      else
        return 'https://github.com/' .. r
      end
    end
  ):totable())
end

--- Set a keymap with a description.
--- @param lhs string
--- @param rhs string|function
--- @param desc? string
--- @param opts { mode: string|string[] }
function M.map(lhs, rhs, desc, opts)
  vim.keymap.set(opts.mode, lhs, rhs, { desc = desc })
end

--- Set a normal mode keymap.
--- @param lhs string
--- @param rhs string|function
--- @param desc? string
function M.nmap(lhs, rhs, desc) M.map(lhs, rhs, desc, { mode = 'n' }) end

--- Set a visual mode keymap.
--- @param lhs string
--- @param rhs string|function
--- @param desc? string
function M.vmap(lhs, rhs, desc) M.map(lhs, rhs, desc, { mode = 'v' }) end

--- Set an insert mode keymap.
--- @param lhs string
--- @param rhs string|function
--- @param desc? string
function M.imap(lhs, rhs, desc) M.map(lhs, rhs, desc, { mode = 'i' }) end

--- Set a keymap for operator-pending and visual modes.
--- @param lhs string
--- @param rhs string|function
--- @param desc? string
function M.xomap(lhs, rhs, desc) M.map(lhs, rhs, desc, { mode = { 'x', 'o' } }) end

return M
