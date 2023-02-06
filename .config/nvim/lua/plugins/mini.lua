-- replaces various individual of plugins
return { 'echasnovski/mini.nvim',
  config = function()
    require 'mini.comment'.setup {}
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

