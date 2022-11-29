local U = require 'utils'
local T = require 'config.toggleterm'

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

local BUFFERS_GROUP = {
  name = 'buffers',
  j    = { ':BufferLineCycleNext<cr>', 'Next buffer' },
  k    = { ':BufferLineCyclePrev<cr>', 'Previous buffer' },
  p    = { ':BufferLinePick<cr>', 'Pick buffer' },
  -- d    = { U.bufdelete, 'Delete buffer' },
  d    = { ':BufDel<cr>', 'Delete buffer' },
  b    = { ':Telescope buffers<cr>', 'Search buffers' }
}

return {
  [';'] = {
    p = { function() require 'winpick'.select() end, 'Pick window' }
  },

  ['<c-l>'] = { '<cmd>ClearNotifications<cr>', 'Clear Notifications' },
  ['<C-k>'] = { vim.lsp.buf.signature_help, 'Signature help' },
  ['<m-,>'] = { vim.diagnostic.goto_prev, 'Previous diagnostic' },
  ['<m-.>'] = { vim.diagnostic.goto_next, 'Next diagnostic' },
  ['<m-i>'] = { U.refresh_init, 'Reload config' },
  ['<m-j>'] = { ':BufferLineCycleNext<cr>', 'Next buffer' },
  ['<m-k>'] = { ':BufferLineCyclePrev<cr>', 'Previous buffer' },

  E = { U.open_diagnostics, 'Open diagnostics in floating window' },

  K = { vim.lsp.buf.hover, 'Hover' },

  F = TELESCOPE_GROUP,

  B = BUFFERS_GROUP,

  ['<leader>'] = {
    name = '+leader',

    [';']  = { ':vnew<cr>', 'New Split' },
    ['}']  = { ':BufferLineCycleNext<cr>', 'Next buffer' },
    ['{']  = { ':BufferLineCyclePrev<cr>', 'Previous buffer' },
    ['|'] = { ':Neotree reveal filesystem float toggle=true<cr>', 'Toggle file tree (float)' },
    ['\\']  = { ':Neotree reveal filesystem show left toggle focus<cr>', 'Toggle file tree (sidebar)' },
    ['.']  = { vim.lsp.buf.code_action, 'Code actions' },

    w = { ':BufDel<cr>', 'Delete buffer' },

    b = BUFFERS_GROUP,

    c = {
      b = { function() require 'nvim-biscuits'.toggle_biscuits() end, 'Toggle code biscuits' },
    },

    D = 'Go to type definition',

    e = { U.open_diagnostics, 'Open diagnostics in floating window' },

    f = TELESCOPE_GROUP,

    g = { T.lazilygit, 'Git UI via lazygit' },

    h = { function() require 'replacer'.run() end, 'Edit quicklist' },

    k = { U.legendary_open, 'Command Palette' },

    l = {
      name = 'lsp',
      f    = { function() vim.lsp.buf.format { async = true } end, 'Format file' },
      r    = { vim.lsp.buf.rename, 'Rename' },
      k    = { vim.lsp.buf.signature_help, 'Signature help' },
      d    = { vim.lsp.buf.declaration, 'Goto declaration' },
      D    = { vim.lsp.buf.type_definition, 'Goto type definition' },
      e    = { U.open_diagnostics, 'Open diagnostics in floating window' },
    },

    P = {
      name = 'Plugins',
      i    = { ':PackerInstall<cr>', 'Install plugins via Packer' },
      u    = { ':PackerUpdate --preview<cr>', 'Update plugins via Packer' },
      s    = { ':PackerSync --preview<cr>', 'Update plugins (sync) via Packer' },
      c    = { ':PackerCompile<cr>', 'Compile plugins via Packer' },
      x    = { ':PackerClean<cr>', 'Clean plugins via Packer' },
    },
    p = { ':Telescope find_files hidden=true<cr>', 'Find files' },

    q = 'Quit',

    R = { vim.lsp.buf.rename, 'Rename refactor' },

    --- Screenshots
    s = {
      s = { function() require'silicon'.visualise_api { debug = true } end, 'Save a Screenshot' },
      b = { function() require'silicon'.visualise_api { debug = true, show_buf = true } end, 'Save a Screenshot with Buffer' },
    },

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
  },

  O = { U.open_uri_under_cursor, 'Open URI under cursor' },

  r = {
    name = 'rename/rotate',
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

    o = {
      name = 'colours',
      c    = { U.cycle_color, 'Cycle colour format' },
      h    = { U.format_hsl, 'Format color as hsl()' },
    },

    n = { vim.lsp.buf.rename, 'Rename refactor' },

  },

}
