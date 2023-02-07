-- Telescope live_grep -> <Tab> to select files -> <C-q> to populate qflist -> <leader>h to find/replace in qf files
return { 'gabrielpoca/replacer.nvim',
  lazy = true,
  keys = {
    { '<leader>h', function() require 'replacer'.run() end, desc = 'Edit quicklist' },
  }
}

