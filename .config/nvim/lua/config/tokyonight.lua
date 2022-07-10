local colors = require 'tokyonight.colors'.setup {}
local util = require 'tokyonight.util'

vim.g.tokyonight_style = 'night'
vim.g.tokyonight_transparent = true
vim.g.tokyonight_lualine_bold = true
vim.g.tokyonight_colors = {
  bg_highlight = util.blend(colors.bg_highlight, '#000000', 0.5),
}

vim.cmd [[
  colorscheme tokyonight
  hi Normal guibg=transparent
]]
