return {
  'utilyre/barbecue.nvim',
  enabled = true,
  name = 'barbecue',
  version = '*',
  dependencies = { 'SmiteshP/nvim-navic', 'nvim-tree/nvim-web-devicons' },
  opts = {
    attach_navic = false, -- prevent barbecue from automatically attaching nvim-navic
    theme = 'catppuccin',
  },
}
