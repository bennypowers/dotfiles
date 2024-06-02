-- telescope as UI for various vim built-in things
return { 'stevearc/dressing.nvim',
  enabled = true,
  opts = {
    input = {
      enabled = true,
      win_options = {
        winblend = 25,
        number = false,
      },
    },
  },
}

