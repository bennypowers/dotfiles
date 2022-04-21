pcall(require, 'impatient')

-- https://github.com/wbthomason/packer.nvim#bootstrapping
local fn = vim.fn
local packer_bootstrap = false
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- load a config function for a plugin
-- the module should be located in `~/.config/nvim/lua/config/${name}.lua`
-- and should return a single function
-- @param type 'config' or 'setup'
local function loader(type)
  -- @param name the name of the lua module to load
  return function(name)
    return require(type..'.'..name)
  end
end

local c = loader'config'
local s = loader'setup'

return require'packer'.startup({ function(use)
  -- 🎨 Themes

  -- use '~/.config/nvim/themes/framed'                     -- WIP custom color theme based on lush
  -- use 'rktjmp/lush.nvim'                                 -- custom color themes
  use { 'EdenEast/nightfox.nvim', config = c'nightfox' }    -- 🦊

  use 'wbthomason/packer.nvim'                    -- manage plugins
  use 'lewis6991/impatient.nvim'                  -- faster startup?
  use 'nathom/filetype.nvim'                      -- faster startup!
  use 'milisims/nvim-luaref'                      -- lua docs in vim help

  -- 🖥️  terminal emulator
  use { 'akinsho/toggleterm.nvim', config = c'toggleterm' }

  -- 🔥 Browser Integration
  --    here be 🐉 🐲

  -- use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }

  -- 🔭 Telescope

  use 'stevearc/dressing.nvim'                        -- telescope as UI for various vim built-in things
  use { 'nvim-telescope/telescope.nvim',              -- generic fuzzy finder with popup window
        config = c'telescope',
        requires = {
          'nvim-lua/plenary.nvim',
          'nvim-lua/popup.nvim' } }
  use { 'nvim-telescope/telescope-frecency.nvim',     -- tries to sort files helpfully
        config = function() require'telescope'.load_extension'frecency' end,
        requires = 'tami5/sqlite.lua' }
  use { 'nvim-telescope/telescope-symbols.nvim',      -- mostly for emoji
        requires = 'nvim-telescope/telescope.nvim' }

  -- 🌳 Syntax

  use 'lepture/vim-jinja'                              -- regexp-based syntax for njk
  use 'nvim-treesitter/playground'                     -- tool for exploring treesitter ASTs
  use { 'sheerun/vim-polyglot', setup = s'polyglot' }  -- regexp-based syntax
  use { 'code-biscuits/nvim-biscuits',
        config = c'biscuits',
        requires = 'nvim-treesitter/nvim-treesitter' } -- hints for block ends
  use { 'nvim-treesitter/nvim-treesitter',
        config = c'treesitter',
        run = ':TSUpdate',                             -- AST wizardry 🧙
        requires = {
          'RRethy/nvim-treesitter-endwise',            -- append `end` in useful places
          'windwp/nvim-ts-autotag',                    -- close HTML tags, but using treesitter
        } }
  use { 'nvim-treesitter/nvim-treesitter-textobjects', -- select a comment
        requires = 'nvim-treesitter/nvim-treesitter' }

  -- 🪟 UI

  use 'https://gitlab.com/yorickpeterse/nvim-window.git'
  use 'famiu/bufdelete.nvim'                                         -- close buffers (tabs) with less headache
  use 'ryanoasis/vim-devicons'                                       -- some icon s
  use 'folke/twilight.nvim'                                          -- focus mode editing
  use 'kosayoda/nvim-lightbulb'                                      -- 💡
  -- use { 'stonelasley/flare.nvim',                                    -- flash cursor on move
  --       config = function() require('flare').setup {
  --           file_ignore = { -- suppress highlighting for files of this type
  --             "NvimTree",
  --             "NeoTree",
  --             "fugitive",
  --             "TelescopePrompt",
  --             "TelescopeResult",
  --           },
  --       } end }
  use { 'mvllow/modes.nvim', config = c'modes' }                     -- the colors!
  use { 'kyazdani42/nvim-web-devicons', config = c'web-devicons' }   -- yet more icons
  use { 'goolord/alpha-nvim', config = c'alpha' }                    -- startup screen
  use { 'akinsho/bufferline.nvim', config = c'bufferline' }          -- editor tabs. yeah ok I know they're not "tabs"
  use { 'rcarriga/nvim-notify', config = c'notify' }                 -- pretty notifications
  use { 'antoinemadec/FixCursorHold.nvim',
        setup = function() vim.g.cursorhold_updatetime = 100 end }   -- bug fix for neovim's CursorHold event
  use 'RRethy/vim-illuminate'
  use { 'lukas-reineke/indent-blankline.nvim',
        config = c'indent', setup = s'indent' }                      -- indentation guide with context
  use { 'nvim-lualine/lualine.nvim',                                 -- pretty statusline
        config = c'lualine',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
  use { 'mrjones2014/legendary.nvim' }
  use { 'folke/which-key.nvim',                                      -- which key was it, again?
        config = c'which-key',
        requires = 'mrjones2014/legendary.nvim' }
  use { 'nvim-neo-tree/neo-tree.nvim',                               -- tree browser
        branch = 'v2.x',
        config = c'neo-tree',
        requires = {
          'nvim-lua/plenary.nvim',
          'kyazdani42/nvim-web-devicons',
          'MunifTanjim/nui.nvim',
        } }

  -- 📒 Sessions

  -- Disabling because neo-tree doesn't play nice.
  -- alpha kinda-sorta helps with this in the mean time

  use { 'Shatur/neovim-session-manager',
        config = c'neovim-session-manager',
        requires = {
          'nvim-telescope/telescope.nvim',
          'JoseConseco/telescope_sessions_picker.nvim' } }

  -- ⌨️  Editing

  use {'kana/vim-textobj-entire',
        requires='kana/vim-textobj-user'}                        -- yae, cae, etc
  use 'arthurxavierx/vim-caser'                                  -- change case (camel, dash, etc)
  use 'tommcdo/vim-lion'                                         -- align anything
  use 'tpope/vim-surround'                                       -- surround objects with chars, change surround, remove, etc
  use 'tpope/vim-repeat'                                         -- dot-repeat for various plugin actions
  use 'windwp/nvim-spectre'                                      -- project find/replace
  use 'rafcamlet/nvim-luapad'                                    -- lua REPL/scratchpad
  use 'chentau/marks.nvim'                                       -- better vim marks
  use { 'numToStr/Comment.nvim', config = c'comment' }           -- comment/uncomment text objects
  use { 'mg979/vim-visual-multi', branch = 'master' }            -- multiple cursors, kinda like atom + vim-mode-plus
  use { 'windwp/nvim-autopairs', config = c'autopairs' }         -- automatically pair brackets etc
  use { 'anuvyklack/pretty-fold.nvim', config = c'pretty-fold' } -- beautiful folds with previews
  use { 'monkoose/matchparen.nvim',                              -- highlight matching paren
        config = function()
          require'matchparen'.setup {
            on_startup = true,
            hl_group = 'MatchParen',
          }
        end }
  use { 'AndrewRadev/splitjoin.vim',                             -- like vmp `g,` action
        setup = function()
          vim.cmd [[
            let g:splitjoin_split_mapping = ''
            let g:splitjoin_join_mapping = ''
            nmap gj :SplitjoinJoin<cr>
            nmap g, :SplitjoinSplit<cr>
          ]]
        end }
  use { '~/Developer/nvim-regexplainer', config = c'regexplainer',
        requires = {
          'nvim-lua/plenary.nvim',
          'MunifTanjim/nui.nvim',
        } }


  -- 🤖 Language Server

  use 'folke/lua-dev.nvim'                 -- nvim api docs, signatures, etc.
  use 'neovim/nvim-lspconfig'              -- basic facility to configure language servers
  use 'nvim-lua/lsp-status.nvim'           -- support for reporting buffer's lsp status (diagnostics, etc) to other plugins
  use 'onsails/lspkind-nvim'               -- fancy icons for lsp AST types and such
  use 'b0o/schemastore.nvim'               -- json schema support
  use { 'j-hui/fidget.nvim',               -- LSP eye-candy
        config = function ()
          require'fidget'.setup()
        end }
  use { 'williamboman/nvim-lsp-installer', -- automatically install language servers
        config = c'lsp-installer',
        setup = s'lsp-installer',
        requires = {
          'hrsh7th/nvim-cmp',
          'neovim/nvim-lspconfig' } }
  use { 'folke/lsp-trouble.nvim',          -- language-server diagnostics panel
        config = c'trouble',
        requires = {
          'folke/trouble.nvim',
          'kyazdani42/nvim-web-devicons'
        } }
  use { 'rmagatti/goto-preview',           -- gd, but in a floating window
        config = function() require'goto-preview'.setup {} end }

  -- 📎 Completions and Snippets

  use 'hrsh7th/cmp-nvim-lsp'                                                    -- language-server-based completions
  use 'hrsh7th/cmp-nvim-lua'                                                    -- lua
  use 'hrsh7th/cmp-calc'                                                        -- math
  use 'hrsh7th/cmp-buffer'                                                      -- buffer contents completion
  use 'hrsh7th/cmp-path'                                                        -- path completions
  use 'hrsh7th/cmp-emoji'                                                       -- ok boomer
  use 'hrsh7th/cmp-nvim-lsp-signature-help'                                     -- ffffunction
  use 'David-Kunz/cmp-npm'                                                      -- npm package versions
  use 'lukas-reineke/cmp-under-comparator'                                      -- _afterOthers
  use { 'petertriho/cmp-git', requires = 'nvim-lua/plenary.nvim' }              -- autocomplete git issues
  use { 'mtoohey31/cmp-fish', ft = "fish" }                                     -- 🐟
  use { 'hrsh7th/nvim-cmp', config = c'cmp', requires = 'dcampos/nvim-snippy' } -- completion engine
  use { 'hrsh7th/cmp-cmdline', config = c'cmp-cmdline' }                        -- cmdline completions

  -- 📌 Git

  use { 'pwntester/octo.nvim',
        requires = {
          'nvim-lua/plenary.nvim',
          'nvim-telescope/telescope.nvim',
          'kyazdani42/nvim-web-devicons',
        },
        config = function ()
          require"octo".setup()
        end
      }
  use { 'lewis6991/gitsigns.nvim',                                              -- git gutter
    config = function() require'gitsigns'.setup() end }

  -- 🕸️  Webdev

  use 'jonsmithers/vim-html-template-literals'                           -- lit-html
  use 'NTBBloodbath/color-converter.nvim'                                -- convert colour values
  use 'crispgm/telescope-heading.nvim'                                   -- navigate to markdown headers
  use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install' } -- markdown previews
  use { 'rrethy/vim-hexokinase', run = 'make hexokinase' }               -- display colour values

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require'packer'.sync()
  end
end,
  config =  {
    max_jobs = 8,
    display = {
      open_fn = require'packer.util'.float
    },
  }
})
