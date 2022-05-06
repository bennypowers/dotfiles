-- https://github.com/wbthomason/packer.nvim#bootstrapping
local fn = vim.fn
local packer_bootstrap = false
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require'packer'.startup({ function(use)
  use { 'tweekmonster/startuptime.vim', cmd = 'StartupTime' }
  use 'wbthomason/packer.nvim'

  -- bug fix for neovim's cursorhold event
  vim.g.cursorhold_updatetime = 100
  use 'antoinemadec/FixCursorHold.nvim'

  -- 🎨 Themes

  -- use '~/.config/nvim/themes/framed'                     -- WIP custom color theme based on lush
  -- use 'rktjmp/lush.nvim'                                 -- custom color themes
  -- use { 'EdenEast/nightfox.nvim', config = require'config.nightfox' }    -- 🦊

  use { 'folke/tokyonight.nvim',
        config = function ()
          vim.g.tokyonight_style = 'night'
          vim.g.tokyonight_transparent = true
          vim.cmd[[colorscheme tokyonight]]
        end }

  use 'lewis6991/impatient.nvim'                  -- faster startup?
  use 'nathom/filetype.nvim'                      -- faster startup!
  use 'milisims/nvim-luaref'                      -- lua docs in vim help

  -- 🖥️  terminal emulator
  use { 'akinsho/toggleterm.nvim',
        config = function()
          require'toggleterm'.setup {}
        end }

  -- 🔥 Browser Integration
  --    here be 🐉 🐲

  -- use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }

  -- 🔭 Telescope

  use 'stevearc/dressing.nvim'                        -- telescope as UI for various vim built-in things
  use { 'nvim-telescope/telescope.nvim',              -- generic fuzzy finder with popup window
        config = function()
          local telescope = require'telescope'
          local actions = require'telescope.actions'

          telescope.setup {
            defaults = {
              prompt_prefix = "🔎 ",
              vimgrep_arguments = {
                'rg',
                '--color=never',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',
                '--smart-case',
                '--ignore',
                '--hidden'
              },
              file_ignore_patterns = {
                ".git",
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
        end,
        requires = {
          'nvim-lua/plenary.nvim',
          'nvim-lua/popup.nvim',
          'nvim-telescope/telescope-symbols.nvim', }}

  use { 'nvim-telescope/telescope-frecency.nvim',     -- tries to sort files helpfully
        requires = 'tami5/sqlite.lua',
        config = function()
          require'telescope'.load_extension'frecency'
        end }

  -- 🌳 Syntax

  use { 'nvim-treesitter/nvim-treesitter',
        config = require'config.treesitter',
        run = ':TSUpdate',                                                -- AST wizardry 🧙
        requires = {
          'RRethy/nvim-treesitter-endwise',                               -- append `end` in useful places
          'windwp/nvim-ts-autotag',                                       -- close HTML tags, but using treesitter
          'nvim-treesitter/nvim-treesitter-textobjects' -- select a comment
        } }

  use { 'stevearc/aerial.nvim',
        config = function() require'aerial'.setup() end }

  -- hints for block ends
  use { 'code-biscuits/nvim-biscuits',
        opt = true,
        config = function()
          require'nvim-biscuits'.setup {
            show_on_start = true,
            default_config = {
              max_length = 12,
              min_distance = 5,
              prefix_string = " 📎 "
            },
            language_config = {
              html = {
                prefix_string = " 🌐 "
              },
              javascript = {
                prefix_string = " ✨ ",
                max_length = 80
              },
              python = {
                disabled = true
              }
            }
          }
        end }

  use 'lepture/vim-jinja'                    -- regexp-based syntax for njk
  use 'nvim-treesitter/playground'                                        -- tool for exploring treesitter ASTs

  -- 🪟 UI

  use 'famiu/bufdelete.nvim'                                         -- close buffers (tabs) with less headache
  use { 'kosayoda/nvim-lightbulb', opt = true }                      -- 💡
  use 'RRethy/vim-illuminate'
  use { 'https://gitlab.com/yorickpeterse/nvim-window.git', module = 'nvim-window' }
  use { 'kyazdani42/nvim-web-devicons',                              -- yet more icons
        module = 'nvim-web-devicons',
        config = function()
          local icons = require'nvim-web-devicons'
          icons.setup {
            override = {
              md = {
                icon = "",
                color = "#519aba",
                cterm_color = "67",
                name = "Markdown",
              },
              node_modules = {
                icon = "",
                color = "#90a959",
                name = "NodeModules",
              },
              ts = {
                icon = 'ﯤ',
                color = "#519aba",
                cterm_color = "67",
                name = "Ts",
              },
            }
          }
          icons.set_icon {
            ['.github'] = {
              icon = '',
              name = "GitHub",
            },
            ['tsconfig.json'] = {
              icon = "",
              color = "#519aba",
              name = "TSConfigJson"
            },
          }
        end }

  use { 'mvllow/modes.nvim',
        config = function() require'modes'.setup { } end }

  -- use { 'goolord/alpha-nvim', config = require'config.alpha' }                    -- startup screen
  use { 'bennypowers/alpha-nvim',
        branch = 'patch-2',
        config = require'config.alpha' }

  use { 'akinsho/bufferline.nvim',
        tag = "v2.*",
        config = require'config.bufferline' }          -- editor tabs. yeah ok I know they're not "tabs"

  -- pretty notifications
  use { 'rcarriga/nvim-notify',
        config = function ()
          local notify = require'notify'
          notify.setup {
            render = 'minimal'
          }
          vim.notify = notify
        end }

  -- pretty statusline
  use { 'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        config = function ()
          require'lualine'.setup {
            theme = 'tokyonight',
            extentions = { },
            options = {
              disabled_filetypes = { 'neo-tree' },
              globalstatus = true,
            },
            sections = {
              lualine_a = {'mode'},
              lualine_b = {'branch', 'diff', 'diagnostics'},
              lualine_c = {'filename'},
              lualine_x = {'encoding', 'fileformat', 'filetype'},
              lualine_y = {'progress'},
              lualine_z = {'location'},
            },
          }
        end }

  -- which key was it, again?
  use { 'folke/which-key.nvim',
        requires = 'mrjones2014/legendary.nvim',
        config = require'config.which-key' }

  -- tree browser
  use { 'nvim-neo-tree/neo-tree.nvim',
        branch = 'v2.x',
        config = require'config.neo-tree',
        requires = {
          'nvim-lua/plenary.nvim',
          'kyazdani42/nvim-web-devicons',
          'MunifTanjim/nui.nvim',
        } }

  -- 📒 Sessions

  -- Disabling because neo-tree doesn't play nice.
  -- alpha kinda-sorta helps with this in the mean time

  -- use { 'Shatur/neovim-session-manager',
  --       config = require'config.neovim-session-manager',
  --       requires = {
  --         'nvim-telescope/telescope.nvim',
  --         'JoseConseco/telescope_sessions_picker.nvim' } }

  -- ⌨️  Editing

  use 'arthurxavierx/vim-caser'                                     -- change case (camel, dash, etc)
  use 'tommcdo/vim-lion'                                            -- align anything
  use 'tpope/vim-surround'                                          -- surround objects with chars, change surround, remove, etc
  use 'tpope/vim-repeat'                                            -- dot-repeat for various plugin actions
  use 'windwp/nvim-spectre'                                         -- project find/replace
  use 'rafcamlet/nvim-luapad'                                       -- lua REPL/scratchpad
  use 'chentau/marks.nvim'                                          -- better vim marks
  use { 'petertriho/nvim-scrollbar',-- yae, cae, etc
        config = function() require'scrollbar'.setup() end }
  use { 'kana/vim-textobj-entire',
        requires='kana/vim-textobj-user' }

  -- replaces varioud individual of plugins
  use { 'echasnovski/mini.nvim', config = require'config.mini' }
  use { 'mg979/vim-visual-multi', branch = 'master' }               -- multiple cursors, kinda like atom + vim-mode-plus

  -- beautiful folds with previews
  use { 'anuvyklack/pretty-fold.nvim',
         requires = 'anuvyklack/nvim-keymap-amend',
        config = function ()
            require'pretty-fold'.setup {
              keep_indentation = false,
              fill_char = '━',
              sections = {
                  left = {
                     '━ ', function() return string.rep('>', vim.v.foldlevel) end, ' ━┫', 'content', '┣'
                  },
                  right = {
                     '┫ ', 'number_of_folded_lines', ': ', 'percentage', ' ┣━━',
                  }
              }
            }
            require'pretty-fold.preview'.setup { key = 'l' }
        end }

  -- highlight matching paren
  use { 'monkoose/matchparen.nvim',
        config = function()
          require'matchparen'.setup { on_startup = true }
        end }

  -- like vmp `g,` action
  use { 'AndrewRadev/splitjoin.vim',
        config = function()
          vim.g.splitjoin_split_mapping = ''
          vim.g.splitjoin_join_mapping = ''
          vim.api.nvim_set_keymap('n', 'gj', ':SplitjoinJoin<cr>', {})
          vim.api.nvim_set_keymap('n', 'g,', ':SplitjoinSplit<cr>', {})
        end }

  use { '~/Developer/nvim-regexplainer',
        opt = true,
        requires = 'MunifTanjim/nui.nvim',
        config = function()
          require'regexplainer'.setup {
            auto = true,
            display = 'popup',
            -- display = 'split',
            debug = true,
            mode = 'narrative',
            -- mode = 'debug',
            -- mode = 'graphical',
            narrative = {
              separator = function(component)
                local sep = '\n';
                if component.depth > 0 then
                  for _ = 1, component.depth do
                    sep = sep .. '> '
                  end
                end
                return sep
              end
            },
          }
          -- test authoring mode
          -- require'regexplainer'.setup {
          --   display = 'split',
          --   debug = true,
          --   mode = 'narrative',
          -- }
        end }


  -- 🤖 Language Server

  use 'nvim-lua/lsp-status.nvim'             -- support for reporting buffer's lsp status (diagnostics, etc) to other plugins
  use 'onsails/lspkind-nvim'                 -- fancy icons for lsp AST types and such
  use { 'folke/lua-dev.nvim', ft = 'lua' }   -- nvim api docs, signatures, etc.
  use { 'j-hui/fidget.nvim',                 -- LSP eye-candy
        config = function ()
          require'fidget'.setup()
        end }
  use { 'williamboman/nvim-lsp-installer',   -- automatically install language servers
        config = require'config.lsp',
        requires = {
          'neovim/nvim-lspconfig',           -- basic facility to configure language servers
          'hrsh7th/nvim-cmp',
          'b0o/schemastore.nvim',            -- json schema support
          'neovim/nvim-lspconfig' } }
  use { 'folke/lsp-trouble.nvim',            -- language-server diagnostics panel
        config = function()
          local trouble = require'trouble'
          trouble.setup {
            auto_open = false,
            auto_close = true,
            auto_preview = true,
            use_diagnostic_signs = true,
          }

          vim.api.nvim_create_autocmd('BufNew', {
            pattern = "Trouble",
            command = "setlocal colorcolumn=0"
          })
        end,
        requires = {
          'folke/trouble.nvim',
          'kyazdani42/nvim-web-devicons'
        } }
  use { 'rmagatti/goto-preview',             -- gd, but in a floating window
        config = function() require'goto-preview'.setup {} end }

  -- 📎 Completions and Snippets

  use { 'hrsh7th/nvim-cmp',
        config = require'config.cmp',
        requires = {
          'nvim-lua/plenary.nvim' ,
          'L3MON4D3/LuaSnip',
          'saadparwaiz1/cmp_luasnip',             -- completion engine
          'petertriho/cmp-git',                   -- autocomplete git issues
          'hrsh7th/cmp-nvim-lsp',                 -- language-server-based completions
          'hrsh7th/cmp-nvim-lua',                 -- lua
          'hrsh7th/cmp-calc',                     -- math
          'hrsh7th/cmp-buffer',                   -- buffer contents completion
          'hrsh7th/cmp-path',                     -- path completions
          'hrsh7th/cmp-emoji',                    -- ok boomer
          'hrsh7th/cmp-cmdline',                  -- cmdline completions
          'hrsh7th/cmp-nvim-lsp-signature-help',  -- ffffunction
          'David-Kunz/cmp-npm',                   -- npm package versions
          'lukas-reineke/cmp-under-comparator',   -- _afterOthers
          { 'mtoohey31/cmp-fish', ft = "fish" }   -- 🐟
    } }

  -- 📌 Git

  use { 'lewis6991/gitsigns.nvim',                                              -- git gutter
        config = function() require'gitsigns'.setup() end }
  use { 'akinsho/git-conflict.nvim',
        config = function() require'git-conflict'.setup {
            default_mappings = true, -- disable buffer local mapping created by this plugin
            disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
            highlights = { -- They must have background color, otherwise the default color will be used
              incoming = 'DiffText',
              current = 'DiffAdd',
            }
          }
        end }

  -- 🕸️  Webdev

  use { 'jonsmithers/vim-html-template-literals', opt = true }                           -- lit-html
  use 'NTBBloodbath/color-converter.nvim'                                -- convert colour values
  use 'crispgm/telescope-heading.nvim'                                   -- navigate to markdown headers
  use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install' } -- markdown previews
  use { 'RRethy/vim-hexokinase', -- display colour values
    run = 'make hexokinase' }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require'packer'.sync()
  end
end,
  config =  {
    max_jobs = 16,
    display = {
      open_fn = require'packer.util'.float
    },
    profile = {
      enable = true,
      threshold = 1,
    }
  }
})
