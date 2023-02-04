local U = require 'utils'
local T = require 'commands.terminals'

local TELESCOPE_GROUP = {
  name = 'find',
  F    = { ':Telescope oldfiles<cr>', 'Find old files' },
  g    = { ':Telescope live_grep<cr>', 'Find in files (live grep)' },
  b    = { ':Telescope buffers<cr>', 'Find buffers' },
  h    = { ':Telescope help_tags<cr>', 'Find in help' },
  s    = { ':Telescope symbols<cr>', 'Find symbol' },
  r    = { ':Telescope resume<cr>', 'Resume finding' },
  n    = { ':Telescope notify<cr>', 'Find in Notifications' },
  p    = { ':Telescope pickers<cr>', 'Choose Pickers' },
}

return {
  ['<c-w>'] = {
    p = { function() require 'winpick'.select() end, 'Pick window' }
  },

  ['<c-l>'] = { '<cmd>ClearNotifications<cr>', 'Clear Notifications' },
  ['<C-g>'] = { T.lazilygit, 'Toggle Lazygit' },
  ['<C-k>'] = { vim.lsp.buf.signature_help, 'Signature help' },
  ['<m-,>'] = { vim.diagnostic.goto_prev, 'Previous diagnostic' },
  ['<m-.>'] = { vim.diagnostic.goto_next, 'Next diagnostic' },
  ['<m-i>'] = { U.refresh_init, 'Reload config' },

  E = { U.open_diagnostics, 'Open diagnostics in floating window' },

  K = { vim.lsp.buf.hover, 'Hover' },

  F = TELESCOPE_GROUP,

  -- B = BUFFERS_GROUP,
  B = {':BufmodeEnter<cr>', 'Enter Buffer Mode'},

  ['<leader>'] = {
    name = '+leader',

    [';']  = { ':vnew<cr>', 'New Split' },
    ['|'] = { ':Neotree reveal filesystem float toggle=true<cr>', 'Toggle file tree (float)' },
    ['\\']  = { ':Neotree reveal filesystem show left toggle focus<cr>', 'Toggle file tree (sidebar)' },
    ['.']  = { vim.lsp.buf.code_action, 'Code actions' },

    c = {
      b = { function() require 'nvim-biscuits'.toggle_biscuits() end, 'Toggle code biscuits' },
    },

    D = 'Go to type definition',

    e = { U.open_diagnostics, 'Open diagnostics in floating window' },

    f = TELESCOPE_GROUP,

    g = { T.lazilygit, 'Git UI via lazygit' },

    h = { function() require 'replacer'.run() end, 'Edit quicklist' },

    k = { U.legendary_open, 'Command Palette' },

    L = { ':Lazy<cr>', 'Plugin manager' },
    l = {
      name = 'lsp',
      f    = { function() vim.lsp.buf.format { async = true } end, 'Format file' },
      r    = { vim.lsp.buf.rename, 'Rename' },
      k    = { vim.lsp.buf.signature_help, 'Signature help' },
      d    = { vim.lsp.buf.declaration, 'Goto declaration' },
      D    = { vim.lsp.buf.type_definition, 'Goto type definition' },
      e    = { U.open_diagnostics, 'Open diagnostics in floating window' },
    },

    p = { ':Telescope find_files hidden=true<cr>', 'Find files' },

    q = 'Quit',

    r = {
      name = 're...',

      c = {
        name        = 'caser',
        _           = { '<Plug>CaserSnakeCase<cr>', 'snake_case' },
        ['-']       = { '<Plug>CaserKebabCase<cr>', 'dash-case' },
        ['.']       = { '<Plug>CaserDotCase<cr>', 'dot.case' },
        ['<space>'] = { '<Plug>CaserSpaceCase<cr>', 'space case' },
        c           = { '<Plug>CaserCamelCase<cr>', 'camelCase' },
        K           = { '<Plug>CaserTitleKebabCase<cr>', 'Upper-Dash-Case' },
        p           = { '<Plug>CaserMixedCase<cr>', 'PascalCase' },
        s           = { '<Plug>CaserSentenceCase<cr>', 'Sentence case' },
        t           = { '<Plug>CaserTitleCase<cr>', 'Title Case' },
        u           = { '<Plug>CaserUpperCase<cr>', 'UPPER_SNAKE_CASE' },
        U           = { '<Plug>CaserUpperCase<cr>', 'UPPER_SNAKE_CASE' },
      },

      n = { ':IncRename ', 'Rename (Incrementally)' },

      o = {
        name = 'colours',
        c    = { U.cycle_color, 'Cycle colour format' },
        h    = { U.format_hsl, 'Format color as hsl()' },
      },

    },

    --- Screenshots
    s = {
      s = { function() require'silicon'.visualise_api { debug = true } end, 'Save a Screenshot' },
      b = { function() require'silicon'.visualise_api { debug = true, show_buf = true } end, 'Save a Screenshot with Buffer' },
    },

    t = {
      name = 'terminals',
      t    = { ':ToggleTerm size=20 dir=git_dir direction=vertical<cr>', 'Open terminal in vertical split' },
      p    = { ':ToggleTerm size=20 dir=git_dir<cr>', 'Open terminal in horizontal split' },
      f    = { T.term_with_command, 'Open terminal with command' },
      s    = { T.scratch_with_command, 'Open Scratch terminal with command' },
    },
  },

  g = {
    name = '+global',

    ['%'] = 'match surround backwards',

    b = {':BufmodeEnter<cr>', 'Enter Buffer Mode'},

    A = { ':Dashboard<cr>', 'Show dashboard' },

    c = {
      name = 'comments',
      c    = 'comment line',
    },

    D = { vim.lsp.buf.declaration, 'Goto declaration' },
    -- d = { U.goto_preview_definition, 'Goto definitions' },
    d = { vim.lsp.buf.definition, 'Goto definitions' },

    i = { vim.lsp.buf.implementation, 'Goto implementations' },

    L = { name = 'align right', },
    l = { name = 'align left', },

    n = {
      name = 'incremental',
      n    = 'select'
    },

    P = { U.close_all_win, 'Close all preview windows' },

    r = { vim.lsp.buf.references, 'Goto references' },

    T = { ':TroubleToggle<cr>', 'Toggle trouble' },

    ['.'] = {
      name = 'git conflicts',
      ['.'] = { ':GitConflictNextConflict<cr>', 'Next Git Conflict' },
      [','] = { ':GitConflictPrevConflict<cr>', 'Previous Git Conflict' },
      o = { ':GitConflictChooseOurs<cr>', 'Choose Ours' },
      t = { ':GitConflictChooseTheirs<cr>', 'Choose Theirs' },
    }
  },

  O = { U.open_uri_under_cursor, 'Open URI under cursor' },

}
