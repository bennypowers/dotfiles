local function find_selection()
  vim.cmd 'noau normal! "vy"'
  ---@type string|nil
  local text = vim.fn.getreg('v')
  vim.fn.setreg('v', {})
  text = string.gsub(text or '', '\n', '')
  if string.len(text) == 0 then
    text = nil
  end

  require 'telescope.builtin'.live_grep {
    default_text = text
  }
end

local function pick_symbols()
  require'telescope.builtin'.symbols { sources = {
    'emoji', 'gitmoji', 'math',
  } }
end
-- 🔭 Telescope - generic fuzzy finder with popup window
return { 'nvim-telescope/telescope.nvim',
  name = 'telescope',
  lazy = true,
  cmd = {'Telescope'},
  keys = {

    {'<leader>p',  ':Telescope find_files hidden=true<cr>', desc = 'Find files'},
    {'<leader>fF', ':Telescope oldfiles<cr>',               desc = 'Find old files'},
    {'<leader>fg', ':Telescope live_grep<cr>',              desc = 'Find in files (live grep)'},
    {'<leader>fb', ':Telescope buffers<cr>',                desc = 'Find buffers'},
    {'<leader>fh', ':Telescope help_tags<cr>',              desc = 'Find in help'},
    {'<leader>fs', pick_symbols,                            desc = 'Find symbol'},
    {'<leader>fr', ':Telescope resume<cr>',                 desc = 'Resume finding'},
    {'<leader>fn', ':Telescope notify<cr>',                 desc = 'Find in Notifications'},
    {'<leader>fp', ':Telescope pickers<cr>',                desc = 'Choose Pickers'},
    {'<c-e>',      pick_symbols,                            mode = 'i',    desc = 'Pick symbol via Telescope'},
    {'F',          find_selection,                          mode = 'v',    desc = 'Find selection in project' },
    {'fg',         find_selection,                          mode = 'v',    desc = 'Find selection in project' },

  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-lua/popup.nvim',
    'nvim-telescope/telescope-symbols.nvim',
    'neovim/nvim-lspconfig',
  },
  config = function()
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
          '.git/',
          'node_modules'
        },
        mappings = {
          i = {
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-j>'] = actions.move_selection_next,
            ['<esc>'] = actions.close
          }
        }
      },
      pickers = {
        lsp_code_actions = {
          theme = 'cursor'
        },
        lsp_workspace_diagnostics = {
          theme = 'dropdown'
        }
      },
    }
  end,
}

