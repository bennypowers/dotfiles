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

  -- faster startup?
  use 'lewis6991/impatient.nvim'
  -- faster startup!
  use 'nathom/filetype.nvim'
  -- lua docs in vim help
  use 'milisims/nvim-luaref'

  -- 🎨 Themes

  use { 'catppuccin/nvim', as = 'catppuccin', config = c 'catppuccin-nvim' }

  -- 🖥️  terminal emulator
  use { 'akinsho/toggleterm.nvim', config = c 'toggleterm' }

  -- 🔥 Browser Integration
  --    here be 🐉 🐲

  use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }

  -- 🔭 Telescope

  -- telescope as UI for various vim built-in things
  use 'stevearc/dressing.nvim'

  -- generic fuzzy finder with popup window
  use { 'nvim-telescope/telescope.nvim',
    config = c 'telescope',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-lua/popup.nvim',
      'nvim-telescope/telescope-symbols.nvim',
      'nvim-telescope/telescope-frecency.nvim' } }

  -- navigate to markdown headers
  use { 'crispgm/telescope-heading.nvim', ft = { 'md', 'markdown' } }

  -- tries to sort files helpfully
  use { 'nvim-telescope/telescope-frecency.nvim', requires = 'tami5/sqlite.lua' }

  -- 🌳 Syntax

  use { 'nvim-treesitter/nvim-treesitter',
    config = c 'treesitter',
    run = ':TSUpdate', }

  -- tool for exploring treesitter ASTs
  use { 'nvim-treesitter/playground', command = 'TSPlaygroundToggle' }
  -- append `end` in useful places
  use { 'RRethy/nvim-treesitter-endwise' }
  -- close HTML tags, but using treesitter
  use { 'windwp/nvim-ts-autotag' }
  -- select a comment
  use { 'nvim-treesitter/nvim-treesitter-textobjects' }

  -- hints for block ends
  use { 'code-biscuits/nvim-biscuits', config = c 'biscuits' }

  -- regexp-based syntax for njk
  use { 'lepture/vim-jinja', ft = { 'jinja', 'html' } }

  -- 🪟 UI

  -- close buffers (tabs) with less headache
  use 'famiu/bufdelete.nvim'
  use 'RRethy/vim-illuminate'

  -- yet more icons
  use { 'kyazdani42/nvim-web-devicons',
    module = 'nvim-web-devicons',
    config = c 'web-devicons' }

  use { 'https://gitlab.com/yorickpeterse/nvim-window.git',
    module = 'nvim-window' }

  use { 'petertriho/nvim-scrollbar', config = c 'scrollbar' }
  use { 'mvllow/modes.nvim', config = c 'modes' }

  -- use { 'goolord/alpha-nvim',
  use { '~/Developer/alpha-nvim',
    command = 'Alpha',
    config = c 'alpha' }

  -- editor tabs. yeah ok I know they're not "tabs"
  use { 'akinsho/bufferline.nvim',
    tag = "v2.*",
    config = c 'bufferline' }

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
    cond = function() return not vim.g.started_by_firenvim end,
    requires = {
      'nvim-telescope/telescope.nvim',
      'JoseConseco/telescope_sessions_picker.nvim' } }

  -- ⌨️  Editing

  -- change case (camel, dash, etc)
  use 'arthurxavierx/vim-caser'
  -- align anything
  use 'tommcdo/vim-lion'
  use 'gabrielpoca/replacer.nvim'
  -- lua REPL/scratchpad
  use { 'rafcamlet/nvim-luapad', command = 'LuaPad' }

  -- yae, cae, etc
  use { 'kana/vim-textobj-entire',
    requires = 'kana/vim-textobj-user' }

  use 'jbyuki/quickmath.nvim'

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

  -- support for reporting buffer's lsp status (diagnostics, etc) to other plugins
  use 'nvim-lua/lsp-status.nvim'
  -- fancy icons for lsp AST types and such
  use 'onsails/lspkind-nvim'
  -- nvim api docs, signatures, etc.
  use { 'folke/lua-dev.nvim', ft = 'lua' }
  -- LSP eye-candy
  use { 'j-hui/fidget.nvim', config = c 'fidget' }
  -- automatically install language servers
  use { 'williamboman/nvim-lsp-installer',
    config = c 'lsp',
    requires = {
      'neovim/nvim-lspconfig', -- basic facility to configure language servers
      'hrsh7th/nvim-cmp',
      'b0o/schemastore.nvim', -- json schema support
      'neovim/nvim-lspconfig' } }
  -- language-server diagnostics panel
  use { 'folke/lsp-trouble.nvim',
    command = { 'Trouble', 'TroubleToggle' },
    config = c 'trouble',
    requires = {
      'folke/trouble.nvim',
      'kyazdani42/nvim-web-devicons',
    } }
  -- gd, but in a floating window
  use { 'rmagatti/goto-preview', config = c 'goto-preview' }

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
      'David-Kunz/cmp-npm', -- npm package versions
      'lukas-reineke/cmp-under-comparator', -- _afterOthers
      { 'mtoohey31/cmp-fish', ft = "fish" } -- 🐟
    } }

  -- 📌 Git

  -- git gutter
  use { 'lewis6991/gitsigns.nvim', config = c 'gitsigns' }
  -- resolve conflicts
  use { 'akinsho/git-conflict.nvim', config = c 'git-conflict-nvim' }
  use { 'pwntester/octo.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'kyazdani42/nvim-web-devicons',
    },
    config = function()
      require 'octo'.setup()
    end
  }

  -- 🕸️  Webdev

  -- markdown previews
  use { 'iamcco/markdown-preview.nvim',
    ft = { 'md', 'markdown' },
    run = function()
      vim.fn["mkdp#util#install"]()
    end }
  -- display colour values
  use { 'RRethy/vim-hexokinase',
    cmd = { 'HexokinaseToggle', 'HexokinaseTurnOn' },
    setup = c 'hexokinase',
    run = 'make hexokinase' }

  -- The opt wasteland

  use { 'folke/tokyonight.nvim', opt = true, config = c 'tokyonight' }
  -- project find/replace
  use { 'windwp/nvim-spectre', opt = true }
  -- better vim marks
  use { 'chentau/marks.nvim', opt = true }
  use { 'ldelossa/gh.nvim',
    opt = true,
    config = c 'gh-nvim',
    requires = { 'ldelossa/litee.nvim' } }
  -- lit-html
  use { 'jonsmithers/vim-html-template-literals', opt = true }
  -- convert colour values
  use { 'NTBBloodbath/color-converter.nvim', opt = true }
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
