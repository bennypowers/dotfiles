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
  use 'wbthomason/packer.nvim'

  use 'lewis6991/impatient.nvim'

  -- 🎨 Themes
  use 'yonlu/omni.vim'                                   -- dark neon kinda theme
  use 'mangeshrex/uwu.vim'                               -- a meme of a theme
  use 'rktjmp/lush.nvim'                                 -- custom color themes
  -- use '~/.config/nvim/themes/framed'                     -- WIP custom color theme based on lush
  use { 'EdenEast/nightfox.nvim', config = c'nightfox' } -- 🦊

  -- 🔥 Browser Integration
  --    here be 🐉 🐲
  use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }

  -- 🔭 Telescope
  use 'stevearc/dressing.nvim'                        -- telescope as UI for various vim built-in things
  use { 'nvim-telescope/telescope.nvim',              -- generic fuzzy finder with popup window
        config = c'telescope',
        requires = {
          'nvim-lua/plenary.nvim',
          'nvim-lua/popup.nvim' } }
  use { 'nvim-telescope/telescope-frecency.nvim',     -- tries to sort files helpfully
        config = function()
          require'telescope'.load_extension'frecency'
        end,
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

  -- 🪟 UI
  use 'ryanoasis/vim-devicons'                                       -- some icons
  use { 'kyazdani42/nvim-web-devicons', config = c'web-devicons' }   -- yet more icons
  use { 'antoinemadec/FixCursorHold.nvim',
        setup = function() vim.g.cursorhold_updatetime = 500 end }   -- bug fix for neovim's CursorHold event
  use { 'folke/which-key.nvim', config = c'which-key' }
  use 'folke/twilight.nvim'                                          -- focus mode editing
  use { 'yamatsum/nvim-cursorline',
        setup = function () vim.g.cursorline_timeout=0 end }         -- highlight word under cursor
  use { 'goolord/alpha-nvim', config = c'alpha' }                    -- startup screen
  use { 'akinsho/bufferline.nvim', config = c'bufferline' }          -- editor tabs. yeah ok I know they're not "tabs"
  use { 'rcarriga/nvim-notify',
        config = function() vim.notify = require'notify' end }       -- pretty notifications
  use { 'lukas-reineke/indent-blankline.nvim',
        config = c'indent', setup = s'indent' }                      -- indentation guide with context
  use { 'mhinz/vim-sayonara', run = 'Sayonara' }                     -- close buffers (tabs) with less headache
  use { 'nvim-lualine/lualine.nvim',                                 -- pretty statusline
        config = c'lualine',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
  use { 'nvim-neo-tree/neo-tree.nvim',                               -- tree browser
        branch = 'v1.x',
        config = c'neo-tree',
        requires = {
          'nvim-lua/plenary.nvim',
          'kyazdani42/nvim-web-devicons',
          'MunifTanjim/nui.nvim',
        } }

  -- 📒 Sessions
  -- Disabling because neo-tree doesn't play nice.
  -- alpha kinda-sorta helps with this in the mean time
  --
  -- use { 'Shatur/neovim-session-manager',
  --       config = c'neovim-session-manager',
  --       requires = 'nvim-telescope/nvim-telescope' }

  -- ⌨️  Editing
  use 'tpope/vim-surround'                                                        -- surround objects with chars, change surround, remove, etc
  use { 'numToStr/Comment.nvim', config = c'comment' }                                     -- comment/uncomment text objects
  use 'tpope/vim-repeat'                                                          -- dot-repeat for various plugin actions
  use 'mattn/emmet-vim'                                                           -- HTML but faster
  use 'windwp/nvim-spectre'                                                       -- project find/replace
  use 'rafcamlet/nvim-luapad'                                                     -- lua REPL/scratchpad
  use { 'monkoose/matchparen.nvim',                                               -- highlight matching paren
        config = function()
          require'matchparen'.setup {
            on_startup = true,
            hl_group = 'MatchParen',
          }
        end }
  use 'arthurxavierx/vim-caser'                                                   -- change case (camel, dash, etc)
  use 'tommcdo/vim-lion'                                                          -- align anything
  use { 'mg979/vim-visual-multi', branch = 'master' }                             -- multiple cursors, kinda like atom + vim-mode-plus
  use { 'windwp/nvim-autopairs', config = c'autopairs' }                          -- automatically pair brackets etc
  use { 'anuvyklack/pretty-fold.nvim', config = c'pretty-fold' }                  -- beautiful folds with previews

  -- 🤖 Language Server
  use 'neovim/nvim-lspconfig'              -- basic facility to configure language servers
  use 'nvim-lua/lsp-status.nvim'           -- support for reporting buffer's lsp status (diagnostics, etc) to other plugins
  use 'onsails/lspkind-nvim'               -- fancy icons for lsp AST types and such
  use { 'williamboman/nvim-lsp-installer', -- automatically install language servers
        config = c'lsp-installer',
        setup = s'lsp-installer',
        requires = { 'hrsh7th/nvim-cmp', 'neovim/nvim-lspconfig' } }
  use { 'folke/lsp-trouble.nvim',          -- language-server diagnostics panel
        config = c'trouble',
        requires = {
          'folke/trouble.nvim',
          'kyazdani42/nvim-web-devicons'
        } }

  -- 📎 Completions and Snippets
  use 'hrsh7th/cmp-nvim-lsp'                                                    -- language-server-based completions
  use 'hrsh7th/cmp-buffer'                                                      -- buffer contents completion
  use 'hrsh7th/cmp-path'                                                        -- path completions
  use 'dcampos/cmp-snippy'                                                      -- snippet completions
  use { 'hrsh7th/nvim-cmp', config = c'cmp', requires = 'dcampos/nvim-snippy' } -- completion engine
  use { 'hrsh7th/cmp-cmdline', config = c'cmp-cmdline' }                        -- cmdline completions

  -- 📌 Git
  use 'tpope/vim-fugitive'                  -- basically `git` shell command but `:Git`
  use { 'tanvirtin/vgit.nvim',              -- visual git operations
        requires = 'nvim-lua/plenary.nvim',
        config = c'vgit',
        setup = s'vgit', }

  -- ⬇ Markdown
  use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install' } -- markdown previews

  -- 🕸️  Webdev
  use 'jonsmithers/vim-html-template-literals'             -- lit-html
  use 'NTBBloodbath/color-converter.nvim'                  -- convert colour values
  --use { 'rrethy/vim-hexokinase', run = 'make hexokinase' } -- display colour values

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require'packer'.sync()
  end
end,
  config =  {
    display = {
      open_fn = require'packer.util'.float
    },
  }
})
