-- telescope as UI for various vim built-in things
return { 'stevearc/dressing.nvim',
  opts = {
    input = {
      enabled = true,
      buf_options = {
        number = false,
      },
      win_options = {
        winblend = 25,
        number = false,
      },
    },
  },
}

