local U = require 'utils'
local T = require 'config.toggleterm'

return {
  K = { vim.lsp.buf.hover, 'Hover' },

  ['<C-k>'] = { vim.lsp.buf.signature_help, 'Signature help' },
  ['<m-,>'] = { vim.diagnostic.goto_prev, 'Previous diagnostic' },
  ['<m-.>'] = { vim.diagnostic.goto_next, 'Next diagnostic' },
  ['<m-i>'] = { U.refresh_init, 'Reload config' },


  ['<leader>'] = {
    name = '+leader',

    [';']  = { ':vnew<cr>', 'New Split' },
    ['}']  = { ':BufferLineCycleNext<cr>', 'Next buffer' },
    ['{']  = { ':BufferLineCyclePrev<cr>', 'Previous buffer' },
    ['|']  = { '<cmd>Neotree reveal filesystem float toggle=true<cr>', 'Toggle file tree (float)' },
    ['\\'] = { '<cmd>Neotree reveal filesystem show left toggle focus<cr>', 'Toggle file tree (sidebar)' },
    ['.']  = { vim.lsp.buf.code_action, 'Code actions' },

    b = {
      name = 'buffers',
      j    = { ':BufferLineCycleNext<cr>', 'Next buffer' },
      k    = { ':BufferLineCyclePrev<cr>', 'Previous buffer' },
      p    = { ':BufferLinePick<cr>', 'Pick buffer' },
      d    = { U.bufdelete, 'Delete buffer' },
      b    = { ':Telescope buffers<cr>', 'Search buffers' }
    },

    c = {
      name = 'colours',
      c    = { U.cycle_color, 'Cycle colour format' },
      h    = { ':lua require"color-converter".to_hsl()<cr>:s/%//g<cr>', 'Format color as hsl()' },
    },

    D = 'Go to type definition',

    e = { U.open_diagnostics, 'Open diagnostics in floating window' },

    f = {
      name = 'find',
      g    = { '<cmd>Telescope live_grep<cr>', 'Find in files (live grep)' },
      b    = { '<cmd>Telescope buffers<cr>', 'Find buffers' },
      h    = { '<cmd>Telescope help_tags<cr>', 'Find in help' },
      s    = { '<cmd>Telescope symbols<cr>', 'Find symbol' },
      r    = { '<cmd>Telescope resume<cr>', 'Resume finding' },
    },

    g = { T.lazilygit, 'Git UI via lazygit' },

    h = { function() require 'replacer'.run() end, 'Edit quicklist' },

    k = { U.legendary_open, 'Command Palette' },

    l = {
      name = 'lsp',
      f    = { vim.lsp.buf.formatting, 'Format file' },
      r    = { vim.lsp.buf.rename, 'Rename' },
      k    = { vim.lsp.buf.signature_help, 'Signature help' },
      d    = { vim.lsp.buf.declaration, 'Goto declaration' },
      D    = { vim.lsp.buf.type_definition, 'Goto type definition' },
      e    = { U.open_diagnostics, 'Open diagnostics in floating window' },
    },

    P = {
      name = 'Plugins',
      i    = { '<cmd>PackerInstall<cr>', 'Install plugins via Packer' },
      u    = { '<cmd>PackerUpdate<cr>', 'Update plugins via Packer' },
      s    = { '<cmd>PackerSync<cr>', 'Update plugins (sync) via Packer' },
      c    = { U.refresh_packer, 'Compile plugins via Packer' },
      x    = { '<cmd>PackerClean<cr>', 'Clean plugins via Packer' },
    },
    p = { '<cmd>Telescope find_files hidden=true<cr>', 'Find files' },

    q = 'Quit',

    R = { vim.lsp.buf.rename, 'Rename refactor' },

    s = 'Save file',

    t = {
      name = 'terminals',
      t    = { T.term_vertical, 'Open terminal in vertical split' },
      f    = { T.term_with_command, 'Open terminal with command' },
      s    = { T.scratch_with_command, 'Open Scratch terminal with command' },
    },
  },

  g = {
    name = '+global',

    ['%'] = 'match surround backwards',

    A = { ':Alpha<cr>', 'Show dashboard' },

    c = {
      name = 'comments',
      c    = 'comment line',
    },

    D = { vim.lsp.buf.declaration, 'Goto declaration' },
    d = { U.goto_preview_definition, 'Goto definitions' },

    i = { U.goto_preview_implementation, 'Goto implementations' },

    L = {
      name = 'align right',
    },
    l = {
      name = 'align left',
    },

    n = {
      name = 'incremental',
      n    = 'select'
    },

    P = { U.close_all_win, 'Close all preview windows' },

    r = { U.goto_preview_references, 'Goto references' },

    s = {
      name        = 'caser',
      m           = 'mixed case',
      p           = 'mixed case',
      c           = 'camelCase',
      _           = 'snake_case',
      u           = 'UPPER_SNAKE',
      U           = 'UPPER_SNAKE',
      t           = 'Title Case',
      s           = 'Sentence case',
      ['<space>'] = 'space case',
      ['-']       = 'dash-case',
      k           = 'dash-case',
    },

    T = { ':TroubleToggle<cr>', 'Toggle trouble' },

    U = 'uppercase',
    u = 'lowercase',
  },

  O = { U.open_uri_under_cursor, 'Open URI under cursor' }
}
