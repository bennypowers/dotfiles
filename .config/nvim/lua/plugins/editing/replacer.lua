local function replacer()
  require 'replacer'.run()
end

-- Telescope live_grep -> <Tab> to select files -> <C-q> to populate qflist -> <leader>h to find/replace in qf files
return {'gabrielpoca/replacer.nvim',
  keys = {
    { '<leader>h', replacer, desc = 'Edit quicklist' },
  }
}

