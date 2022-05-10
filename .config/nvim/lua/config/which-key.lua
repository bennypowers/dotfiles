return function()
  vim.cmd [[nmap ; <C-w>]]

  local can_legendary, legendary = pcall(require, 'legendary')
  local Terminals = require 'terminals'

  if can_legendary then
    legendary.setup {
      include_builtin = true,
      auto_register_which_key = true,
      select_prompt = 'Command Pallete'
    }
  end

  local function pick_window()
    require 'nvim-window'.pick()
  end

  local function open_diagnostics()
    vim.diagnostic.open_float {
      focus = false,
    }
  end

  local function spectre_open()
    require 'spectre'.open()
  end

  local function spectre_open_visual()
    require 'spectre'.open_visual { select_word = true }
  end

  local function legendary_open()
    legendary.find()
  end

  local function cycle_color()
    require 'color-converter'.cycle()
  end

  local function goto_preview_definition()
    require 'goto-preview'.goto_preview_definition()
  end

  local function goto_preview_implementation()
    require 'goto-preview'.goto_preview_implementation()
  end

  local function goto_preview_references()
    require 'goto-preview'.goto_preview_references()
  end

  local function close_all_win()
    require 'goto-preview'.close_all_win()
  end

  local wk = require 'which-key'

  wk.setup {
    plugins = {
      spelling = {
        enabled = true,
      },
    },
  }

  wk.register({
    [';'] = {
      name     = 'Window management',
      w        = { pick_window, 'Pick Window' },
      s        = "Split window",
      v        = "Split window vertically",
      q        = "Quit a window",
      T        = "Break out into a new tab",
      x        = "Swap current with next",
      ["-"]    = "Decrease height",
      ["+"]    = "Increase height",
      ["<lt>"] = "Decrease width",
      [">"]    = "Increase width",
      ["|"]    = "Max out the width",
      ["="]    = "Equally high and wide",
      h        = "Go to the left window",
      l        = "Go to the right window",
      k        = "Go to the up window",
      j        = "Go to the down window",
    },
  }, { preset = true })

  wk.register({
    K         = { vim.lsp.buf.hover, 'Hover' },
    ['<c-k>'] = { vim.lsp.buf.signature_help, 'Signature help' },
    ['<m-,>'] = { vim.diagnostic.goto_prev, 'Previous diagnostic' },
    ['<m-.>'] = { vim.diagnostic.goto_next, 'Next diagnostic' },
    ['<c-i>'] = { ':source ~/.config/nvim/init.vim<cr>', 'Reload config' },
    ['<c-d>'] = { ':<c-u>call vm#commands#ctrln(v:count1)<cr>', 'Find occurrence of word under cursor' },

    ['<leader>'] = {
      name   = '+leader',
      D      = 'Go to type definition',
      s      = 'Save file',
      q      = 'Quit',
      [';']  = { ':vnew<cr>', 'New Split' },
      ['}']  = { ':BufferLineCycleNext<cr>', 'Next buffer' },
      ['{']  = { ':BufferLineCyclePrev<cr>', 'Previous buffer' },
      ['\\'] = { '<cmd>Neotree reveal filesystem float<cr>', 'Toggle file tree (float)' },
      ['|']  = { '<cmd>Neotree filesystem show left toggle=true<cr>', 'Toggle file tree (sidebar)' },
      ['.']  = { vim.lsp.buf.code_action, 'Code actions' },
      p      = { '<cmd>Telescope find_files hidden=true<cr>', 'Find files' },
      g      = { Terminals.lazilygit, 'Git UI via lazygit' },
      R      = { vim.lsp.buf.rename, 'Rename refactor' },
      F      = { spectre_open, 'Find/replace in project' },
      e      = { open_diagnostics, 'Open diagnostics in floating window' },
      k      = { legendary_open, 'Command Palette' },
      b      = {
        name = "buffers",
        j    = { ':BufferLineCycleNext<cr>', 'Next buffer' },
        k    = { ':BufferLineCyclePrev<cr>', 'Previous buffer' },
        p    = { ':BufferLinePick<cr>', 'Pick buffer' },
        d    = { ':Bdelete<cr>', 'Delete buffer' },
        b    = { ':Telescope buffers<cr>', 'Search buffers' }
      },
      t      = {
        name = 'terminals',
        t    = { Terminals.term_vertical, 'Open terminal in vertical split' },
        f    = { Terminals.term_with_command, 'Open terminal with command' },
        s    = { Terminals.scratch_with_command, 'Open Scratch terminal with command' },
      },
      c      = {
        name = 'colours',
        c    = { cycle_color, 'Cycle colour format' },
        h    = { ':lua require"color-converter".to_hsl()<cr>:s/%//g<cr>', 'Format color as hsl()' },
      },
      l      = {
        name = 'lsp',
        f    = { vim.lsp.buf.formatting, 'Format file' },
        r    = { vim.lsp.buf.rename, 'Rename' },
        k    = { vim.lsp.buf.signature_help, 'Signature help' },
        d    = { vim.lsp.buf.declaration, 'Goto declaration' },
        D    = { vim.lsp.buf.type_definition, 'Goto type definition' },
        e    = { open_diagnostics, 'Open diagnostics in floating window' },
      },
      f      = {
        name = 'find',
        g    = { '<cmd>Telescope live_grep<cr>', 'Find in files (live grep)' },
        b    = { '<cmd>Telescope buffers<cr>', 'Find buffers' },
        h    = { '<cmd>Telescope help_tags<cr>', 'Find in help' },
        s    = { '<cmd>Telescope symbols<cr>', 'Find symbol' },
        r    = { '<cmd>Telescope resume<cr>', 'Resume finding' },
      },
      P      = {
        name = 'Plugins',
        i    = { '<cmd>PackerInstall<cr>', 'Install plugins via Packer' },
        u    = { '<cmd>PackerUpdate<cr>', 'Update plugins via Packer' },
        s    = { '<cmd>PackerSync<cr>', 'Update plugins (sync) via Packer' },
        c    = { '<cmd>PackerCompile<cr>', 'Compile plugins via Packer' },
        x    = { '<cmd>PackerClean<cr>', 'Clean plugins via Packer' },
      }
    },

    g = {
      name  = '+global',
      A     = { ':Alpha<cr>', 'Show dashboard' },
      T     = { ':TroubleToggle<cr>', 'Toggle trouble' },
      D     = { vim.lsp.buf.declaration, 'Goto declaration' },
      d     = { goto_preview_definition, 'Goto definitions' },
      i     = { goto_preview_implementation, 'Goto implementations' },
      r     = { goto_preview_references, 'Goto references' },
      P     = { close_all_win, 'Close all preview windows' },
      u     = 'lowercase',
      U     = 'uppercase',
      ['%'] = 'match surround backwards',
      c     = {
        name = 'comments',
        c    = 'comment line',
      },
      n     = {
        name = 'incremental',
        n    = 'select'
      },
      s     = {
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
      l     = {
        name = 'align left',
      },
      L     = {
        name = 'align right',
      },
    }
  })

  -- Visual mode
  wk.register({
    ['<leader>'] = {
      F         = { spectre_open_visual, 'Find/replace selection in project' },
      ['<c-d>'] = { '<Plug>(VM-Find-Subword-Under)<cr>', 'Find occurrence of subword under cursor' },
    }
  }, { mode = 'v' })

  -- Insert mode
  wk.register({
    ['<a-m-space>'] = { ':Telescope symbols<cr>', 'Pick symbol via Telescope' },
  }, { mode = 'i' })

end
