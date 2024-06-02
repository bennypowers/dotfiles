-- replaces various individual of plugins
return { 'echasnovski/mini.nvim',
  enabled = true,
  config = function()
    if vim.version().major == 0 and vim.version().minor < 10 then
      require 'mini.comment'.setup {}
    end
    require 'mini.trailspace'.setup {}
    au('BufWritePre', {
      group = ag('MiniTrailspaceOnSave', {}),
      pattern = { '*.lua' },
      callback = function()
        require 'mini.trailspace'.trim()
      end
    })
  end
}

