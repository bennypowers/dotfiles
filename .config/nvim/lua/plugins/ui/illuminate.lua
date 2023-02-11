return { 'RRethy/vim-illuminate',
  lazy = true,
  enabled = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  event = { 'CursorMoved', 'InsertLeave' },
  opts = {
    filetypes_denylist = {
      'neotree',
      'neo-tree',
      'Telescope',
      'telescope',
    }
  }
}


