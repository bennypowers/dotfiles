return { 'folke/tokyonight.nvim',
  enabled = false,
  lazy = true,
  opts = {
    on_highlights = function(hl, colors)
      local util = require 'tokyonight.util'
      hl.ModesCopy = util.lighten(colors.orange, 0.15)
      hl.ModesDelete = util.lighten(colors.red, 0.15)
      hl.ModesInsert = 'TRANSPARENT'
      hl.ModesVisual = util.lighten(colors.purple, 0.15)
    end
  }
}
