return { 'mvllow/modes.nvim',
  enabled = false,
  config = function()
    local modes = require 'modes'
    local options = {}
    if vim.g.colors_name == 'tokyonight' then
      local colors = require 'tokyonight.colors'.setup {}
      local util = require 'tokyonight.util'
      options = vim.tbl_extend('force', options, {
        colors = {
          copy = util.lighten(colors.orange, 0.15),
          delete = util.lighten(colors.red, 0.15),
          insert = 'TRANSPARENT',
          visual = util.lighten(colors.purple, 0.15),
        }
      });
    end
    modes.setup(options)
  end,
}
