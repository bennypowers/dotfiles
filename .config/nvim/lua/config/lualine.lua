require 'lualine'.setup {
  -- theme = 'tokyonight',
  theme = 'catppuccin',
  extentions = {},
  options = {
    disabled_filetypes = { 'neo-tree' },
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
}
