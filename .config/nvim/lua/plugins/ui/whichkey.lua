-- Live cheat sheet for key bindings
return { 'folke/which-key.nvim',
  dependencies = { 'legendary' },
  config = function()
    local wk = require'which-key'
    wk.setup {
      plugins = {
        spelling = {
          enabled = true,
        },
        presets = {
          -- modes.nvim is incompatible
          -- https://github.com/mvllow/modes.nvim/blob/b1cea686c049b03cb01300b6a6367b81302d2a90/readme.md#known-issues
          operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
          motions = true, -- adds help for motions
          text_objects = true, -- help for text objects triggered after entering an operator
          windows = true, -- default bindings on <c-w>
          nav = true, -- misc bindings to work with windows
          z = true, -- bindings for folds, spelling and others prefixed with z
          g = true, -- bindings for prefixed with g
        },
      },
      -- add operators that will trigger motion and text object completion
      -- to enable all native operators, set the preset / operators plugin above
      operators = { gc = "Comments" },
    }

    wk.register({
      F = { name = '+telescope' },
      ['<leader>'] = {
        name = '+leader',
        l = { name = '+lsp' },
        r = {
          name = '+re...',
          o = { name = '+colours' },
          c = { name = '+caser' },
        },
        s = { name = '+screenshots' },
        t = { name = '+terminals' },
        f = { name = '+telescope' },
      },
      g = {
        name = '+global',
        L = { name = 'align right', },
        l = { name = 'align left', },
        ['%'] = 'match surround backwards',
        c = {
          name = '+comments',
          c = 'comment line',
        },
        n = {
          name = '+incremental',
          n    = 'select'
        },
      },
    }, { mode = 'n' })

    wk.register({
      s = { name = '+screenshots', },
      r = {
        name = '+rename/rotate',
        c = { name = '+caser' },
        o = { name = '+colours' },
      }
    }, { mode = 'v' })

  end
}

