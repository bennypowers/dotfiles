---@type vim.lsp.Config
return {
  init_options = { hostInfo = 'neovim' },
  cmd = { 'hyprls' },
  root_markers = { 'hyprland.conf' },
  filetypes = {'hyprlang'},
}
