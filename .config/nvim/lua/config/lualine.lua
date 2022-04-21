return function ()
  require'lualine'.setup {
    theme = 'auto',
    extentions = { 'fugitive' },
    options = {
      disabled_filetypes = { 'neo-tree' },
      globalstatus = true,
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {'filename'},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'},
    },
  }
end
