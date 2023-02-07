return { 'RRethy/vim-illuminate',
  lazy = true,
  events = { 'CursorMoved', 'InsertLeave' },
  opts = {
    filetypes_denylist = {
      'neotree',
      'neo-tree',
    }
  }
}


