if vim.g.colors_name == 'leaf' then
  local colors = require'leaf.colors'.setup()
  require'leaf'.setup {
    theme = 'dark',

    transparent = true,

    -- contrast = 'low',
    -- contrast = 'medium',
    contrast = 'high',

    overrides = {
      TelescopeBorder = { link = 'Normal' },
      Folded = { bg = colors.darker }
    },

  }
  vim.cmd.colorscheme'leaf'
end
