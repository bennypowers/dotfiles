-- Live cheat sheet for key bindings
return { 'folke/which-key.nvim',
  enabled = true,
  dependencies = { 'mrjones2014/legendary.nvim' },
  config = function()
    local wk = require'which-key'
    wk.setup {
      preset = 'helix',
    }

    wk.add({
      mode = {'n', 'v' },
      { 'F', group = 'Telescope' },
      { '<leader>', group = 'Leader' },
      { '<leader>l', group = 'LSP' },
      { '<leader>r', group = '+re...', },
      { '<leader>ro', group = '+colours' },
      { '<leader>rc', group = '+caser' },
      { '<leader>s', group = '+screenshots' },
      { '<leader>f', group = '+telescope' },
    })

    wk.add({
      mode = 'v',
      { 'gL', name = 'align right' },
      { 'gl', name = 'align left' },
      { 'g%', name = 'match surround backwards' },
      { 'gn', group = 'incremental' },
      { 'gnn', name = 'select' },
    })

  end
}

