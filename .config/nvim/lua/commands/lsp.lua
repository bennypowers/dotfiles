local M = {}

---@param arg string
function M.get_enabled_clients(arg)
  return vim.iter(vim.lsp._enabled_configs)
    ---@param config { resolved_config: vim.lsp.Config }
    :filter(function(config)
      if arg and arg:len() > 0 then
        return vim.startswith(config.resolved_config.name, arg)
      else
        return true
      end
    end)
    :totable()
end

---@param arg string
function M.get_active_clients(arg)
  return vim.iter(vim.lsp.get_clients { bufnr = 0 })
    :map(function(x) print(x.name); return x end)
    ---@param client vim.lsp.Client
    :filter(function(client)
      if arg and arg:len() > 0 then
        return vim.startswith(client.name, arg)
      else
        return true
      end
    end)
    :totable()
end

---@param info vim.api.keyset.create_user_command.command_args
function M.start(info)
  local server_name = string.len(info.args) > 0 and info.args or nil
  if server_name then
    for name in vim.spairs(vim.lsp._enabled_configs) do
      if name == server_name then
        local config = vim.lsp.config[name]
        vim.lsp.start(config)
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

---@param info vim.api.keyset.create_user_command.command_args
function M.restart(info)
  local detach_clients = {}
  for _, client in ipairs(get_clients_from_cmd_args(info.args)) do
    -- Can remove diagnostic disabling when changing to client:stop() in nvim 0.11+
    --- @diagnostic disable: missing-parameter
    client.stop()
    if vim.tbl_count(client.attached_buffers) > 0 then
      detach_clients[client.name] = { client, lsp.get_buffers_by_client_id(client.id) }
    end
  end
  local timer = assert(vim.loop.new_timer())
  timer:start(
    500,
    100,
    vim.schedule_wrap(function()
      for client_name, tuple in pairs(detach_clients) do
        if require('lspconfig.configs')[client_name] then
          local client, attached_buffers = unpack(tuple)
          if client.is_stopped() then
            for _, buf in pairs(attached_buffers) do
              require('lspconfig.configs')[client_name].launch(buf)
            end
            detach_clients[client_name] = nil
          end
        end
      end

      if next(detach_clients) == nil and not timer:is_closing() then
        timer:close()
      end
    end)
  )
end

function M.stop(info)
  ---@type string
  local args = info.args
  local force = false
  args = args:gsub('%+%+force', function()
    force = true
    return ''
  end)

  local clients = {}

  -- default to stopping all servers on current buffer
  if #args == 0 then
    clients = vim.lsp.get_clients { bufnr = 0 }
  else
    print(args)
    clients = vim.lsp.get_clients { name = vim.trim(args) }
  end

  print(vim.inspect(clients))
  for _, client in ipairs(clients) do
    print(client.name)
    client:stop(force)
  end
end

function M.log()
  vim.cmd(string.format('tabnew %s', vim.lsp.get_log_path()))
end
return M
