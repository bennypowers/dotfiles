return function()
  require'mini.comment'.setup()
  require'mini.pairs'.setup()
  require'mini.surround'.setup()

  require'mini.trailspace'.setup()
  vim.api.nvim_create_augroup('MiniTrailspaceOnSave', { clear = true })
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = 'MiniTrailspaceOnSave',
    pattern = {'*.lua'},
    callback = function()
      require'mini.trailspace'.trim()
    end
  })

  -- require'mini.indentscope'.setup {
  --   symbol = '|',
  --   draw = {
  --     delay = 0,
  --     animation = require'mini.indentscope'.gen_animation('none'),
  --   }
  -- }
end
