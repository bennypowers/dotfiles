local has_statuscol = vim.fn.has'statuscol'
return { 'kevinhwang91/nvim-ufo',
  lazy = false,
  keys = {
    { 'zR', function() require'ufo'.openAllFolds() end, desc = 'Open all folds' },
    { 'zM', function() require'ufo'.closeAllFolds() end, desc = 'Close all folds' },
  },
  dependencies = {
    'kevinhwang91/promise-async',
    'luukvbaal/statuscol.nvim',
  },
  init = function()
    vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
    vim.opt.foldcolumn = tostring(has_statuscol)
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
    vim.opt.foldenable = true
  end,
  opts = {
    provider_selector = function()
      return { 'treesitter', 'indent' }
    end
  },
}
