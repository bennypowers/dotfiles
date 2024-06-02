return { 'kevinhwang91/nvim-ufo',
  enabled = true,
  keys = {
    { 'zc' },
    { 'zo' },
    { 'zC' },
    { 'zO' },
    { 'za' },
    { 'zA' },
    { 'zr', function() require'ufo'.openFoldsExceptKinds() end, desc = 'Open folds except kinds' },
    { 'zR', function() require'ufo'.openAllFolds() end, desc = 'Open all folds' },
    { 'zM', function() require'ufo'.closeAllFolds() end, desc = 'Close all folds' },
    { 'zm', function() require'ufo'.closeAllFolds() end, desc = 'Close folds with' },
    { 'zp', function() if not require'ufo'.peedFoldedLinesUnderCursor() then vim.lsp.buf.hover() end end, desc = 'Peek folds' },
  },
  event = 'VeryLazy',
  dependencies = {
    'kevinhwang91/promise-async',
    'luukvbaal/statuscol.nvim',
  },
  init = function()
    vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
    vim.opt.foldcolumn = tostring(vim.fn.exists'&statuscolumn')
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
