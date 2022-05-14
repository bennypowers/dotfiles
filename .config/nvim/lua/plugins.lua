-- https://github.com/wbthomason/packer.nvim#bootstrapping
local fn = vim.fn
local packer_bootstrap = false
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
end

---@param mod string module to load under lua/config
local function c(mod)
  local config = string.format([[require 'config.%s']], mod)
  return config
end

return require 'packer'.startup({ function(use)
  use { 'tweekmonster/startuptime.vim', cmd = 'StartupTime' }
  use 'wbthomason/packer.nvim'

  -- bug fix for neovim's cursorhold event
  vim.g.cursorhold_updatetime = 100
  use { 'antoinemadec/FixCursorHold.nvim' }

  use 'lewis6991/impatient.nvim' -- faster startup?
  use 'nathom/filetype.nvim' -- faster startup!
  use 'milisims/nvim-luaref' -- lua docs in vim help

  -- 🎨 Themes

  use { 'folke/tokyonight.nvim', config = c 'tokyonight' }
  -- use '~/.config/nvim/themes/framed'                     -- WIP custom color theme based on lush
  -- use 'rktjmp/lush.nvim'                                 -- custom color themes
  -- use { 'EdenEast/nightfox.nvim', config = require'config.nightfox' }    -- 🦊
  -- use { 'Domeee/mosel.nvim',
  --   config = function()
  --     require 'mosel'.apply()
  --   end }

  -- 🖥️  terminal emulator
  use { 'akinsho/toggleterm.nvim', config = c 'toggleterm' }

  -- 🔥 Browser Integration
  --    here be 🐉 🐲

  -- use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }

  -- 🔭 Telescope

  use 'stevearc/dressing.nvim' -- telescope as UI for various vim built-in things
  use { 'nvim-telescope/telescope.nvim', -- generic fuzzy finder with popup window
    config = c 'telescope',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-lua/popup.nvim',
      'nvim-telescope/telescope-symbols.nvim',
      'nvim-telescope/telescope-frecency.nvim' } }

  use { 'crispgm/telescope-heading.nvim', ft = { 'md', 'markdown' } } -- navigate to markdown headers

  -- tries to sort files helpfully
  use { 'nvim-telescope/telescope-frecency.nvim', requires = 'tami5/sqlite.lua' }

  -- 🌳 Syntax

  use { 'nvim-treesitter/nvim-treesitter',
    config = c 'treesitter',
    run = ':TSUpdate', }

  use { 'nvim-treesitter/playground', command = 'TSPlaygroundToggle' } -- tool for exploring treesitter ASTs
  use { 'RRethy/nvim-treesitter-endwise' } -- append `end` in useful places
  use { 'windwp/nvim-ts-autotag' } -- close HTML tags, but using treesitter
  use { 'nvim-treesitter/nvim-treesitter-textobjects' } -- select a comment

  -- hints for block ends
  use { 'code-biscuits/nvim-biscuits', config = c 'biscuits' }

  use { 'lepture/vim-jinja', ft = { 'jinja', 'html' } } -- regexp-based syntax for njk

  -- 🪟 UI

  use 'famiu/bufdelete.nvim' -- close buffers (tabs) with less headache
  use 'RRethy/vim-illuminate'
  use { 'https://gitlab.com/yorickpeterse/nvim-window.git', module = 'nvim-window', opt = true }
  use { 'kyazdani42/nvim-web-devicons', -- yet more icons
    module = 'nvim-web-devicons',
    config = c 'web-devicons' }

  use { 'petertriho/nvim-scrollbar', config = c 'scrollbar' }
  use { 'mvllow/modes.nvim', config = c 'modes' }

  -- use { 'goolord/alpha-nvim', config = require'config.alpha' }                    -- startup screen
  use { 'bennypowers/alpha-nvim',
    command = 'Alpha',
    branch = 'patch-2',
    config = c 'alpha' }

  use { 'akinsho/bufferline.nvim',
    tag = "v2.*",
    config = c 'bufferline' } -- editor tabs. yeah ok I know they're not "tabs"

  -- pretty notifications
  use { 'rcarriga/nvim-notify', config = c 'notify' }

  -- pretty statusline
  use { 'nvim-lualine/lualine.nvim', config = c 'lualine' }

  -- which key was it, again?
  use { 'folke/which-key.nvim',
    requires = 'mrjones2014/legendary.nvim',
    config = c 'whichkey' }

  -- tree browser
  use { 'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    config = c 'neo-tree',
    requires = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    } }

  -- 📒 Sessions

  -- Disabling because neo-tree doesn't play nice.
  -- alpha kinda-sorta helps with this in the mean time

  use { 'Shatur/neovim-session-manager',
    config = c 'neovim-session-manager',
    requires = {
      'nvim-telescope/telescope.nvim',
      'JoseConseco/telescope_sessions_picker.nvim' } }

  -- ⌨️  Editing

  use 'arthurxavierx/vim-caser' -- change case (camel, dash, etc)
  use 'tommcdo/vim-lion' -- align anything
  use { 'windwp/nvim-spectre', opt = true } -- project find/replace
  use { 'rafcamlet/nvim-luapad', opt = true, command = 'LuaPad' } -- lua REPL/scratchpad
  use { 'chentau/marks.nvim', opt = true } -- better vim marks

  -- yae, cae, etc
  use { 'kana/vim-textobj-entire',
    opt = true,
    requires = 'kana/vim-textobj-user' }

  -- replaces various individual of plugins
  use { 'echasnovski/mini.nvim', config = c 'mini' }

  -- multiple cursors, kinda like atom + vim-mode-plus
  use { 'mg979/vim-visual-multi', branch = 'master', keys = { '<c-n>' } }

  -- indent guide
  use { 'lukas-reineke/indent-blankline.nvim', config = c 'indent-blankline' }

  -- pretty folds with previews
  use { 'anuvyklack/pretty-fold.nvim', requires = 'anuvyklack/nvim-keymap-amend', config = c 'prettyfold' }

  -- highlight matching paren
  use { 'monkoose/matchparen.nvim', config = c 'matchparen' }

  -- like vmp `g,` action
  use { 'AndrewRadev/splitjoin.vim',
    keys = { 'gj', 'g,' },
    config = function()
      vim.g.splitjoin_split_mapping = ''
      vim.g.splitjoin_join_mapping = ''
      vim.api.nvim_set_keymap('n', 'gj', ':SplitjoinJoin<cr>', {})
      vim.api.nvim_set_keymap('n', 'g,', ':SplitjoinSplit<cr>', {})
    end }

  use { '~/Developer/nvim-regexplainer',
    ft = { 'javascript', 'typescript', 'html', 'python' },
    requires = 'MunifTanjim/nui.nvim',
    config = c 'regexplainer' }


  -- 🤖 Language Server

  use 'nvim-lua/lsp-status.nvim' -- support for reporting buffer's lsp status (diagnostics, etc) to other plugins
  use 'onsails/lspkind-nvim' -- fancy icons for lsp AST types and such
  use { 'folke/lua-dev.nvim', ft = 'lua' } -- nvim api docs, signatures, etc.
  use { 'j-hui/fidget.nvim', config = c 'fidget' } -- LSP eye-candy
  use { 'williamboman/nvim-lsp-installer', -- automatically install language servers
    config = c 'lsp',
    requires = {
      'neovim/nvim-lspconfig', -- basic facility to configure language servers
      'hrsh7th/nvim-cmp',
      'b0o/schemastore.nvim', -- json schema support
      'neovim/nvim-lspconfig' } }
  use { 'folke/lsp-trouble.nvim', -- language-server diagnostics panel
    command = { 'Trouble', 'TroubleToggle' },
    config = c 'trouble',
    requires = {
      'folke/trouble.nvim',
      'kyazdani42/nvim-web-devicons',
    } }
  use { 'rmagatti/goto-preview', keys = 'gd', config = c 'goto-preview' } -- gd, but in a floating window

  -- 📎 Completions and Snippets

  use { 'hrsh7th/nvim-cmp',
    config = c 'cmp',
    requires = {
      'nvim-lua/plenary.nvim',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip', -- completion engine
      'petertriho/cmp-git', -- autocomplete git issues
      'hrsh7th/cmp-nvim-lsp', -- language-server-based completions
      'hrsh7th/cmp-nvim-lua', -- lua
      'hrsh7th/cmp-calc', -- math
      'hrsh7th/cmp-buffer', -- buffer contents completion
      'hrsh7th/cmp-path', -- path completions
      'hrsh7th/cmp-emoji', -- ok boomer
      'hrsh7th/cmp-cmdline', -- cmdline completions
      'hrsh7th/cmp-nvim-lsp-signature-help', -- ffffunction
      -- 'David-Kunz/cmp-npm', -- npm package versions
      'lukas-reineke/cmp-under-comparator', -- _afterOthers
      { 'mtoohey31/cmp-fish', ft = "fish" } -- 🐟
    } }

  -- 📌 Git

  -- git gutter
  use { 'lewis6991/gitsigns.nvim', config = c 'gitsigns' }
  use { 'akinsho/git-conflict.nvim',
    opt = true,
    config = function() require 'git-conflict'.setup {
        default_mappings = true, -- disable buffer local mapping created by this plugin
        disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
        highlights = { -- They must have background color, otherwise the default color will be used
          incoming = 'DiffText',
          current = 'DiffAdd',
        }
      }
    end }

  -- 🕸️  Webdev

  use { 'jonsmithers/vim-html-template-literals', opt = true } -- lit-html
  use { 'NTBBloodbath/color-converter.nvim', opt = true } -- convert colour values
  use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', ft = { 'md', 'markdown' } } -- markdown previews
  use { 'RRethy/vim-hexokinase', -- display colour values
    opt = true,
    run = 'make hexokinase' }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require 'packer'.sync()
  end
end,
config = {
  max_jobs = 16,
  display = {
    open_fn = require 'packer.util'.float
  },
  profile = {
    enable = true,
    threshold = 1,
  }
}
})
