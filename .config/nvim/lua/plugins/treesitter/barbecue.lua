return { 'utilyre/barbecue.nvim',
  enabled = true,
  name = 'barbecue',
  version = '*',
  dependencies = {
    'SmiteshP/nvim-navic',
    'neovim/nvim-lspconfig',
    'nvim-tree/nvim-web-devicons', -- optional dependency
  },
  opts = {
    attach_navic = false, -- prevent barbecue from automatically attaching nvim-navic
    theme = 'catppuccin'
  },
}
