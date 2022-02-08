return function ()
  require'lualine'.setup {
    theme = 'auto',
    options = {
      disabled_filetypes = { 'neo-tree' },
    },
  }
end
