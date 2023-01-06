local DEPS = {
  'nvim-lua/plenary.nvim',
  'nvim-lua/popup.nvim',
  'nvim-telescope/telescope-symbols.nvim'
}

-- 🔭 Telescope - generic fuzzy finder with popup window
return { 'nvim-telescope/telescope.nvim', name = 'telescope', dependencies = DEPS, config = function()
local telescope = require 'telescope'
local actions = require 'telescope.actions'

telescope.setup {
  defaults = {
    prompt_prefix = "🔎 ",
    cache_picker = {
      num_pickers = -1,
    },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--ignore',
      '--hidden',
      '--trim',
    },
    file_ignore_patterns = {
      ".git/",
      "node_modules"
    },
    mappings = {
      i = {
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
        ["<esc>"] = actions.close
      }
    }
  },
  pickers = {
    lsp_code_actions = {
      theme = "cursor"
    },
    lsp_workspace_diagnostics = {
      theme = "dropdown"
    }
  },
}

  end
}

