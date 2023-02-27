-- return { 'yamatsum/nvim-cursorline', config = c 'cursorline' }
return { 'bennypowers/nvim-cursorline',
  branch = 'feat/disable-filetype',
  enabled = false,
  opts =  {
    cursorline = {
      enable = true,
      timeout = 1000,
      number = false,
    },
    cursorword = {
      enable = false,
    },
    disable_filetypes = {
      'alpha',
      'neo-tree',
      'neo-tree-popup',
    },
  },
}
