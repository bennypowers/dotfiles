return {
  ['<c-e>'] = { '<cmd>Telescope symbols<cr>', 'Pick symbol via Telescope' },
  ['<c-l>'] = { function()
    require"notify".dismiss{ silent = true }
    vim.cmd[[nohlsearch|diffupdate|normal! <C-L><CR>]]
  end, 'Clear Notifications' }
}
