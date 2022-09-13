-- https://github.com/wbthomason/packer.nvim#bootstrapping
local fn = vim.fn
local packer_bootstrap = false
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    install_path })
end

---@param mod string module to load under lua/config
local function c(mod)
  local config = string.format([[require 'config.%s']], mod)
  return config
end

return require 'packer'.startup({ function(use)
  --[==[-------------------------------------------------------]-=]
                    🏎️ Perf, Packages,and bufixes
  --[=-[-------------------------------------------------------]==]

  -- vim startup profiler. Use together with `PackerProfile`
  use { 'tweekmonster/startuptime.vim', cmd = 'StartupTime' }
  -- plugin manager
  use 'wbthomason/packer.nvim'
  -- faster startup?
  use 'lewis6991/impatient.nvim'
  -- faster startup!
  use { 'nathom/filetype.nvim', cond = function()
    return vim.fn.has 'nvim-0.8.0' == 0
  end }

  -- bug fix for neovim's cursorhold event
  vim.g.cursorhold_updatetime = 100
  use { 'antoinemadec/FixCursorHold.nvim' }

  --[[----------------------------------------------------------
  --                    📒 Sessions
  --]] ----------------------------------------------------------

  use { 'rmagatti/auto-session',
    config = c 'auto-session',
    requires = 'rmagatti/session-lens' }

  --[[----------------------------------------------------------
                        🎨 Themes
  --]] ----------------------------------------------------------

  use 'B4mbus/oxocarbon-lua.nvim'
  use 'folke/tokyonight.nvim'
  use { 'catppuccin/nvim', as = 'catppuccin', config = c 'catppuccin-nvim', run = "CatppuccinCompile" }
  use { 'projekt0n/github-nvim-theme', config = c 'github-nvim-theme' }
  use { 'daschw/leaf.nvim', config = c'leaf-nvim' }

  --[[----------------------------------------------------------
                        Essential Plugins
  --]] ----------------------------------------------------------

  -- 🌳 Syntax
  use { 'nvim-treesitter/nvim-treesitter',
    config = c 'treesitter',
    run = ':TSUpdate', }

  -- 🔭 Telescope - generic fuzzy finder with popup window
  use { 'nvim-telescope/telescope.nvim',
    config = c 'telescope',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-lua/popup.nvim',
      'nvim-telescope/telescope-symbols.nvim'
    } }

  -- tries to sort files helpfully
  use { 'nvim-telescope/telescope-frecency.nvim', requires = 'tami5/sqlite.lua' }

  -- telescope as UI for various vim built-in things
  use 'stevearc/dressing.nvim'

  -- editor tabs. yeah ok I know they're not "tabs"
  use { 'akinsho/bufferline.nvim',
    tag = "v2.*",
    config = c 'bufferline' }

  -- pretty statusline
  use { 'nvim-lualine/lualine.nvim', config = c 'lualine' }

  -- tree browser
  use { 'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    config = c 'neo-tree',
    requires = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      { 'kyazdani42/nvim-web-devicons',
        module = 'nvim-web-devicons',
        config = c 'web-devicons' }
    } }

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
      'ray-x/cmp-treesitter',
      'David-Kunz/cmp-npm', -- npm package versions
      'KadoBOT/cmp-plugins', -- plugin names
      'lukas-reineke/cmp-under-comparator', -- _afterOthers
      'mtoohey31/cmp-fish' -- 🐟
    } }

  -- 🤖 Language Server
  use { 'lvimuser/lsp-inlayhints.nvim', config = c 'inlayhints' }
  use { 'williamboman/mason.nvim', -- automatically install language servers
    config = c 'mason-nvim',
    requires = {
      'williamboman/mason-lspconfig.nvim',
      'lukas-reineke/lsp-format.nvim',
      'neovim/nvim-lspconfig', -- basic facility to configure language servers
      'nvim-lua/lsp-status.nvim', -- support for reporting buffer's lsp status (diagnostics, etc) to other plugins
      'hrsh7th/nvim-cmp',
      'b0o/schemastore.nvim', -- json schema support
      'neovim/nvim-lspconfig',
      'folke/lua-dev.nvim', -- nvim api docs, signatures, etc.
    } }

  --[[----------------------------------------------------------
  --                    Editor Ergonomics
  --]] ----------------------------------------------------------

  -- autoconvert '' or "" to ``
  use 'axelvc/template-string.nvim'

  -- Live cheat sheet for key bindings
  use { 'folke/which-key.nvim',
    requires = 'mrjones2014/legendary.nvim',
    config = c 'whichkey' }

  -- gd, but in a floating window
  use { 'rmagatti/goto-preview',
    opt = true,
    config = c 'goto-preview',
    -- event = 'VimEnter',
    requires = 'nvim-telescope/telescope.nvim' }

  use { 'nvim-treesitter/nvim-treesitter-context', config = c 'nvim-treesitter-context' }
  -- append `end` in useful places
  use { 'RRethy/nvim-treesitter-endwise' }
  -- close HTML tags, but using treesitter
  use { 'windwp/nvim-ts-autotag' }

  use { 'windwp/nvim-autopairs', config = c 'autopairs' }

  -- select a comment
  use { 'nvim-treesitter/nvim-treesitter-textobjects' }
  -- hints for block ends
  use { 'code-biscuits/nvim-biscuits', config = c 'biscuits' }

  use { "kylechui/nvim-surround", config = c 'surround' }

  use { 'nkakouros-original/numbers.nvim', config = c 'numbers-nvim' }

  --[[----------------------------------------------------------
  --                    Eye Candy
  --]] ----------------------------------------------------------

  -- fancy icons for lsp AST types and such
  use 'onsails/lspkind-nvim'

  -- LSP eye-candy
  use { 'j-hui/fidget.nvim', config = c 'fidget' }

  -- display colour values
  use { 'RRethy/vim-hexokinase',
    cmd = { 'HexokinaseToggle', 'HexokinaseTurnOn' },
    setup = c 'hexokinase',
    run = 'make hexokinase' }

  use { 'petertriho/nvim-scrollbar', config = c 'scrollbar' }
  -- use { 'mvllow/modes.nvim', config = c 'modes' }
  -- use { 'glepnir/dashboard-nvim', config = c 'dashboard-nvim' }
  -- use { 'goolord/alpha-nvim', command = 'Alpha', config = c'alpha' }
  -- use { '~/Developer/alpha-nvim', command = 'Alpha', config = c 'alpha' }

  -- language-server diagnostics panel
  use { 'folke/lsp-trouble.nvim',
    command = { 'Trouble', 'TroubleToggle' },
    config = c 'trouble',
    requires = {
      'folke/trouble.nvim',
      'kyazdani42/nvim-web-devicons'
    } }

  -- 🪟 UI

  -- navigate to markdown headers
  use { 'crispgm/telescope-heading.nvim', ft = { 'md', 'markdown' } }

  use { 'https://git.sr.ht/~whynothugo/lsp_lines.nvim', config = c 'lsp-lines' }

  -- close buffers (tabs) with less headache
  use 'ojroques/nvim-bufdel'

  use { 'gbrlsnchs/winpick.nvim', config = c 'nvim-winpick' }

  -- pretty notifications
  use { 'rcarriga/nvim-notify', config = c 'notify' }

  -- ⌨️  Editing

  -- change case (camel, dash, etc)
  use { 'arthurxavierx/vim-caser', setup = c 'caser' }

  -- align anything
  use 'tommcdo/vim-lion'

  use 'powerman/vim-plugin-AnsiEsc'

  -- better to burn out than to fade away
  use 'simrat39/rust-tools.nvim'

  -- Telescope live_grep -> <Tab> to select files -> <C-q> to populate qflist -> <leader>h to find/replace in qf files
  use 'gabrielpoca/replacer.nvim'

  -- yae, cae, etc
  use { 'kana/vim-textobj-entire', requires = 'kana/vim-textobj-user' }

  -- replaces various individual of plugins
  use { 'echasnovski/mini.nvim', config = c 'mini' }

  -- use { 'yamatsum/nvim-cursorline', config = c 'cursorline' }
  -- use { 'bennypowers/nvim-cursorline', config = c 'cursorline', branch = 'feat/disable-filetype' }

  -- multiple cursors, kinda like atom + vim-mode-plus
  use { 'mg979/vim-visual-multi', branch = 'master', keys = { '<c-n>' } }

  -- indent guide
  use { 'lukas-reineke/indent-blankline.nvim', config = c 'indent-blankline' }

  -- pretty folds with previews
  -- use { 'anuvyklack/pretty-fold.nvim',
  --   config = c 'prettyfold',
  --   requires = {
  --     'anuvyklack/nvim-keymap-amend',
  --     'anuvyklack/fold-preview.nvim'
  --   } }

  use { 'kevinhwang91/nvim-ufo',
    requires = 'kevinhwang91/promise-async',
    config = c'nvim-ufo', }

  -- highlight matching paren
  use { 'monkoose/matchparen.nvim', config = c 'matchparen' }

  -- like vmp `g,` action
  use { 'AndrewRadev/splitjoin.vim', keys = { 'gj', 'g,' }, config = c 'splitjoin' }

  -- gs to toggle bool
  use 'AndrewRadev/switch.vim'

  use { '~/Developer/nvim-regexplainer',
    ft = { 'javascript', 'typescript', 'html', 'python', 'jinja' },
    requires = 'MunifTanjim/nui.nvim',
    config = c 'regexplainer' }

  -- 📌 Git

  -- git gutter
  use { 'lewis6991/gitsigns.nvim', config = c 'gitsigns' }
  -- resolve conflicts
  use { 'akinsho/git-conflict.nvim', config = c 'git-conflict-nvim' }

  -- 🕸️  Webdev

  -- markdown previews
  use { 'iamcco/markdown-preview.nvim',
    ft = { 'md', 'markdown' },
    run = function()
      vim.fn["mkdp#util#install"]()
    end }

  -- 🖥️  terminal emulator
  use { 'akinsho/toggleterm.nvim', config = c 'toggleterm' }

  -- 🔥 Browser Integration
  --    here be 🐉 🐲

  -- use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }

  --[[----------------------------------------------------------
                        Development Tools
  --]] ----------------------------------------------------------

  -- tool for exploring treesitter ASTs
  use { 'nvim-treesitter/playground', command = 'TSPlaygroundToggle' }

  -- 🌔 Lua Development

  -- lua docs in vim help
  use 'milisims/nvim-luaref'

  -- lua REPL/scratchpad
  use { 'rafcamlet/nvim-luapad', command = 'LuaPad' }

  --[[----------------------------------------------------------
                        The OPT Wasteland
  --]] ----------------------------------------------------------

  -- regexp-based syntax for njk
  -- use { 'lepture/vim-jinja', ft = { 'jinja', 'html' } }
  -- use 'lepture/vim-jinja'

  use 'RRethy/vim-illuminate'

  -- better vim marks
  use { 'chentau/marks.nvim', opt = true }

  use { 'pwntester/octo.nvim',
    opt = true,
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'kyazdani42/nvim-web-devicons',
    },
    config = function()
      require 'octo'.setup()
    end }

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
    auto_reload_compiled = true,
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
