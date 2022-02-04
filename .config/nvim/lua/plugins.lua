-- https://github.com/wbthomason/packer.nvim#bootstrapping
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local packer_bootstrap = nil
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require'packer'.startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'windwp/nvim-spectre'
  use 'rstacruz/vim-closer'
  use 'dag/vim-fish'
  use 'folke/twilight.nvim'
  use 'lepture/vim-jinja'

  use { 'EdenEast/nightfox.nvim',
    config = function()
      local nightfox = require'nightfox'
      local c = require'nightfox.colors'.load()

      -- This function set the configuration of nightfox. If a value is not passed in the setup function
      -- it will be taken from the default configuration above
      nightfox.setup {
        fox = 'duskfox',
        alt_nc = true,
        styles = {
          comments = "italic", -- change style of comments to be italic
          keywords = "bold", -- change style of keywords to be bold
          functions = "italic,bold" -- styles can be a comma separated list
        },
        inverse = {
          -- match_paren = false, -- inverse the highlighting of match_parens
          -- match_paren = true, -- inverse the highlighting of match_parens
        },
        colors = {
          bg = "#000000",
          bg_alt = "#010101",
          bg_highlight = "#121820", -- 55% darkened from stock
          -- bg_visual = "#151d28", -- 50% darkened from stock
          -- bg_visual = "#111820", -- 60% darkened from stock
          bg_visual = "#131b24", -- 55% darkened from stock
        },
        hlgroups = {
          TSPunctDelimiter = { fg = "${red}" }, -- Override a highlight group with the color red
          LspCodeLens = {
            bg = "${bg}",
            style = "italic"
          },
        }
      }

      -- Load the configuration set above and apply the colorscheme
      nightfox.load()

      require'matchparen'.setup {
        on_startup = true,
        hl_group = 'MatchParen',
      }
    end
  }

  -- 🔥
  use { 'glacambre/firenvim',
    run = function() vim.fn['firenvim#install'](0) end
  }

  -- Tellyscope
  use { 'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-lua/popup.nvim',
    },
    config = function()
      local telescope = require'telescope'
      local actions = require'telescope.actions'

      telescope.setup{

          defaults = {
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

              prompt_prefix = "🔎 ",

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

  use { 'nvim-telescope/telescope-symbols.nvim',
    requires = { 'nvim-telescope/telescope.nvim' },
  }

  -- Syntax and 🌳
  use 'sbdchd/neoformat'
  use 'nvim-treesitter/playground'
  use { 'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      local treesitter = require'nvim-treesitter.configs'
      local twilight = require'twilight'

      treesitter.setup {
        ensure_installed = 'maintained',
        highlight = { enable = true },
        incremental_selection = { enable = true },
        textobjects = { enable = true },
        indent = { enable = true },
      }

      twilight.setup {
        dimming = {
          alpha = 0.25, -- amount of dimming
          -- we try to get the foreground from the highlight groups or fallback color
          color = { "Normal", "#ffffff" },
          inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
        },
        context = 10, -- amount of lines we will try to show around the current line
        treesitter = true, -- use treesitter when available for the filetype
        -- treesitter is used to automatically expand the visible text,
        -- but you can further control the types of nodes that should always be fully expanded
        expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
          "function",
          "method",
          "table",
          "if_statement",
        },
        exclude = {}, -- exclude these filetypes
      }
    end
  }

  use { 'sheerun/vim-polyglot',
    setup = function()
      -- Markdown fenced code blocks
      vim.g.vim_markdown_fenced_languages = {
        'css', 'scss', 'html',
        'python', 'py=python',
        'sh', 'bash=sh',
        'fish',

        'typescript', 'ts=typescript',
        'javascript', 'js=javascript',
        'json=javascript',

        'graphql', 'gql=graphql',
        'vim'
      }
    end
  }

  -- UI and Env
  use 'ryanoasis/vim-devicons'
  use 'rcarriga/nvim-notify'
  use 'anuvyklack/pretty-fold.nvim'
  use 'VonHeikemen/fine-cmdline.nvim'

  use { 'nvim-neo-tree/neo-tree.nvim',
    branch = 'v1.x',
    requires = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    config = function()
      vim.cmd([[
        hi link NeoTreeDirectoryName Directory
        hi link NeoTreeDirectoryIcon NeoTreeDirectoryName
      ]])

      local tree = require'neo-tree'

      tree.setup{
        popup_border_style = 'rounded',
        enable_git_status = true,
        enable_diagnostics = true,

        filesystem = {

          follow_current_file = true,
          use_libuv_file_watcher = true,

          filters = {
            show_hidden = true,
            respect_gitignore = true,
          },

          window = {
            position = "left",
            width = 40,
            mappings = {
              ["<2-LeftMouse>"] = "open",
              ["<cr>"] = "open",
              ["S"] = "open_split",
              ["s"] = "open_vsplit",
              ["C"] = "close_node",
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
              ["H"] = "toggle_hidden",
              ["I"] = "toggle_gitignore",
              ["R"] = "refresh",
              ["/"] = "filter_as_you_type",
              --["/"] = "none" -- Assigning a key to "none" will remove the default mapping
              ["f"] = "filter_on_submit",
              ["<c-x>"] = "clear_filter",
              ["a"] = "add",
              ["d"] = "delete",
              ["r"] = "rename",
              ["c"] = "copy_to_clipboard",
              ["x"] = "cut_to_clipboard",
              ["p"] = "paste_from_clipboard",
              ["bd"] = "buffer_delete",
            },
          },

          renderers = {
            directory = {
              {
                "icon",
                folder_closed = "",
                folder_open = "",
                padding = " ",
              },
              { "current_filter" },
              { "name" },
              {
                "symlink_target",
                highlight = "NeoTreeSymbolicLinkTarget",
              },
              {
                "clipboard",
                highlight = "NeoTreeDimText",
              },
              { "diagnostics", errors_only = true },
            },
          },

        },

        buffers = {
          show_unloaded = false,
          window = {
            position = "left",
            mappings = {
              ["<2-LeftMouse>"] = "open",
              ["<cr>"] = "open",
              ["S"] = "open_split",
              ["s"] = "open_vsplit",
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
              ["R"] = "refresh",
              ["a"] = "add",
              ["d"] = "delete",
              ["r"] = "rename",
              ["c"] = "copy_to_clipboard",
              ["x"] = "cut_to_clipboard",
              ["p"] = "paste_from_clipboard",
            },
          },
        },

        git_status = {
          window = {
            position = "float",
            mappings = {
              ["<2-LeftMouse>"] = "open",
              ["<cr>"] = "open",
              ["S"] = "open_split",
              ["s"] = "open_vsplit",
              ["C"] = "close_node",
              ["R"] = "refresh",
              ["d"] = "delete",
              ["r"] = "rename",
              ["c"] = "copy_to_clipboard",
              ["x"] = "cut_to_clipboard",
              ["p"] = "paste_from_clipboard",
              ["A"]  = "git_add_all",
              ["gu"] = "git_unstage_file",
              ["ga"] = "git_add_file",
              ["gr"] = "git_revert_file",
              ["gc"] = "git_commit",
              ["gp"] = "git_push",
              ["gg"] = "git_commit_and_push",
            },
          },
        },

        event_handlers = {

          {
            event = "vim_buffer_enter",
            handler = function()
              if vim.bo.filetype == "neo-tree" then
                vim.cmd [[
                  setlocal nocursorcolumn
                  setlocal virtualedit=all
                ]]
              end
            end
          },
        },
      }
    end
  }

  use { 'akinsho/bufferline.nvim',
    config = function()
      local bufferline = require'bufferline'
      vim.cmd 'source ~/.config/nvim/config/bbye.vim'
      bufferline.setup{
        options = {
          numbers = 'none',
          diagnostics = 'nvim_lsp',
          offsets = {{filetype = "neo-tree", text = "Files", text_align = "center" }},
          show_buffer_icons = true,
          show_close_icon = true,
        },
      }
    end
  }

  -- Sessions
  use 'rmagatti/auto-session'
  use { 'mhinz/vim-sayonara', run = 'Sayonara' }

  -- Airline
  use { 'vim-airline/vim-airline',
    setup = function()
      -- adding to vim-airline's tabline
      vim.g.webdevicons_enable_airline_tabline = 1
      vim.g.webdevicons_enable_airline_statusline = 1
      vim.g.airline_powerline_fonts=1

      -- Hide cmdline
      -- Wait until https://github.com/neovim/neovim/pull/16251
      --
      -- vim.cmd [[
      -- 	set noshowmode
      -- 	set noshowcmd
      -- 	set shortmess+=F
      -- 	set laststatus=0 For some reason this doesnt work
      -- 	autocmd BufRead,BufNewFile * set laststatus=0 " This will work instead
      -- ]]
    end
  }

  use { 'vim-airline/vim-airline-themes',
    requires = { 'vim-airline/vim-airline' },
  }

  -- Editing
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'
  use 'tpope/vim-repeat'
  use 'mattn/emmet-vim'
  use 'monkoose/matchparen.nvim'
  use { 'mg979/vim-visual-multi', branch = 'master' }

  use { 'alvan/vim-closetag',
    setup = function()
      -- Auto-close tags
      vim.g.closetag_filenames = '*.html,*.xhtml,*.phtml,*.md,*.ts,*.js,*.njk'
      vim.g.closetag_filetypes = 'html,xhtml,phtml,md,js,ts,njk,jinja'
    end
  }

  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/lsp-status.nvim'
  use 'onsails/lspkind-nvim'
  use { 'williamboman/nvim-lsp-installer', config = function() require'lsp' end }

  use { 'folke/lsp-trouble.nvim',
    requires = {
      'folke/trouble.nvim',
      'kyazdani42/nvim-web-devicons'
    },
    config = function()
      local trouble = require'trouble'
      trouble.setup{
        auto_open = true,
        auto_close = true,
        auto_preview = true,
        use_diagnostic_signs = false,
      }
    end
  }

  -- Completions
  use { 'hrsh7th/cmp-nvim-lsp', requires = 'hrsh7th/nvim-cmp' }
  use { 'hrsh7th/cmp-buffer', requires = 'hrsh7th/nvim-cmp' }
  use { 'hrsh7th/cmp-path', requires = 'hrsh7th/nvim-cmp' }
  use { 'hrsh7th/cmp-cmdline',
    requires = { 'hrsh7th/nvim-cmp', },
    config = function()
      local cmp = require'cmp'
      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline("/", {
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end
  }

  use { 'hrsh7th/nvim-cmp',
    requires = { 'dcampos/nvim-snippy' },
    config = function()
      -- Setup nvim-cmp.
      local cmp = require'cmp'
      local lspkind = require'lspkind'
      local snippy = require'snippy'

      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            snippy.expand_snippet(args.body) -- For `snippy` users.
          end,
        },

        mapping = {
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-S-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
          ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        },

        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "snippy" },
        }, {
          { name = "buffer" },
        }),

        formatting = {
          format = lspkind.cmp_format({
            with_text = false,
            maxwidth = 50,
          }),
        },
      })
  end}

  -- Snippets
  use 'dcampos/nvim-snippy'
  use { 'dcampos/cmp-snippy',
    requires = { 'hrsh7th/nvim-cmp' },
  }

  -- Git
  use 'tpope/vim-fugitive'

  use { 'tanvirtin/vgit.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    setup = function()
      vim.o.updatetime = 300
      vim.o.incsearch = false
      vim.wo.signcolumn = 'yes'
    end,
    config = function()
      local vgit = require'vgit'

      vgit.setup{
        keymaps = {
          ['n <C-k>'] = 'hunk_up',
          ['n <C-j>'] = 'hunk_down',
          ['n <leader>gs'] = 'buffer_hunk_stage',
          ['n <leader>gr'] = 'buffer_hunk_reset',
          ['n <leader>gp'] = 'buffer_hunk_preview',
          ['n <leader>gb'] = 'buffer_blame_preview',
          ['n <leader>gf'] = 'buffer_diff_preview',
          ['n <leader>gh'] = 'buffer_history_preview',
          ['n <leader>gu'] = 'buffer_reset',
          ['n <leader>gg'] = 'buffer_gutter_blame_preview',
          ['n <leader>gl'] = 'project_hunks_preview',
          ['n <leader>gd'] = 'project_diff_preview',
          ['n <leader>gq'] = 'project_hunks_qf',
          ['n <leader>gx'] = 'toggle_diff_preference',
        },
        settings = {
          hls = {
            GitBackgroundPrimary = 'NormalFloat',
            GitBackgroundSecondary = {
              gui = nil,
              fg = nil,
              bg = nil,
              sp = nil,
              override = false,
            },
            GitBorder = 'LineNr',
            GitLineNr = 'LineNr',
            GitComment = 'Comment',
            GitSignsAdd = {
              gui = nil,
              fg = '#d7ffaf',
              bg = nil,
              sp = nil,
              override = false,
            },
            GitSignsChange = {
              gui = nil,
              fg = '#7AA6DA',
              bg = nil,
              sp = nil,
              override = false,
            },
            GitSignsDelete = {
              gui = nil,
              fg = '#e95678',
              bg = nil,
              sp = nil,
              override = false,
            },
            GitSignsAddLn = 'DiffAdd',
            GitSignsDeleteLn = 'DiffDelete',
            GitWordAdd = {
              gui = nil,
              fg = nil,
              bg = '#5d7a22',
              sp = nil,
              override = false,
            },
            GitWordDelete = {
              gui = nil,
              fg = nil,
              bg = '#960f3d',
              sp = nil,
              override = false,
            },
          },
          live_blame = {
            enabled = true,
            format = function(blame, git_config)
              local config_author = git_config['user.name']
              local author = blame.author
              if config_author == author then
                author = 'You'
              end
              local time = os.difftime(os.time(), blame.author_time)
              / (60 * 60 * 24 * 30 * 12)
              local time_divisions = {
                { 1, 'years' },
                { 12, 'months' },
                { 30, 'days' },
                { 24, 'hours' },
                { 60, 'minutes' },
                { 60, 'seconds' },
              }
              local counter = 1
              local time_division = time_divisions[counter]
              local time_boundary = time_division[1]
              local time_postfix = time_division[2]
              while time < 1 and counter ~= #time_divisions do
                time_division = time_divisions[counter]
                time_boundary = time_division[1]
                time_postfix = time_division[2]
                time = time * time_boundary
                counter = counter + 1
              end
              local commit_message = blame.commit_message
              if not blame.committed then
                author = 'You'
                commit_message = 'Uncommitted changes'
                return string.format(' %s • %s', author, commit_message)
              end
              local max_commit_message_length = 255
              if #commit_message > max_commit_message_length then
                commit_message = commit_message:sub(1, max_commit_message_length) .. '...'
              end
              return string.format(
                ' %s, %s • %s',
                author,
                string.format(
                  '%s %s ago',
                  time >= 0 and math.floor(time + 0.5) or math.ceil(time - 0.5),
                  time_postfix
                  ),
                commit_message
                )
            end,
          },
          live_gutter = {
            enabled = true,
          },
          authorship_code_lens = {
            enabled = true,
          },
          screen = {
            diff_preference = 'unified',
          },
          signs = {
            priority = 10,
            definitions = {
              GitSignsAddLn = {
                linehl = 'GitSignsAddLn',
                texthl = nil,
                numhl = nil,
                icon = nil,
                text = '',
              },
              GitSignsDeleteLn = {
                linehl = 'GitSignsDeleteLn',
                texthl = nil,
                numhl = nil,
                icon = nil,
                text = '',
              },
              GitSignsAdd = {
                texthl = 'GitSignsAdd',
                numhl = nil,
                icon = nil,
                linehl = nil,
                text = '┃',
              },
              GitSignsDelete = {
                texthl = 'GitSignsDelete',
                numhl = nil,
                icon = nil,
                linehl = nil,
                text = '┃',
              },
              GitSignsChange = {
                texthl = 'GitSignsChange',
                numhl = nil,
                icon = nil,
                linehl = nil,
                text = '┃',
              },
            },
            usage = {
              screen = {
                add = 'GitSignsAddLn',
                remove = 'GitSignsDeleteLn',
              },
              main = {
                add = 'GitSignsAdd',
                remove = 'GitSignsDelete',
                change = 'GitSignsChange',
              },
            },
          },
          symbols = {
            void = '⣿',
          },
        }
      }
    end
  }

  -- Markdown
  use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install' }

  -- Webdev
  use 'jonsmithers/vim-html-template-literals'
  use { 'rrethy/vim-hexokinase', run = 'make hexokinase' }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require'packer'.sync()
  end
end)

