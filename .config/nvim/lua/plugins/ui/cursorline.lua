-- return { 'yamatsum/nvim-cursorline', config = c 'cursorline' }
return { 'bennypowers/nvim-cursorline',
  branch = 'feat/disable-filetype',
  opts =  {
    cursorline = {
      enable = true,
      timeout = 1000,
      number = false,
    },
    cursorword = {
      enable = true,
      min_length = 3,
      hl = { underline = true },
    }
  },
}
