local configs = {}

-- Read server configs from lua/plugins/lsp/lspconfig/*.lua
for _, filename in ipairs(vim.fn.readdir(vim.fn.expand('~/.config/nvim/lua/lspconfigs/'))) do
  local server_name = filename:gsub('%.lua$', '')
  if server_name ~= 'init' then
    configs[server_name] = 'lspconfigs.'..server_name
  end
end

return configs

