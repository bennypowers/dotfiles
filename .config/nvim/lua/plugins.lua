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

return require'packer'.startup({ function(use)
  use { 'tweekmonster/startuptime.vim', cmd = 'StartupTime' }
  use 'wbthomason/packer.nvim'

  -- 🎨 Themes

  -- use '~/.config/nvim/themes/framed'                     -- WIP custom color theme based on lush
  -- use 'rktjmp/lush.nvim'                                 -- custom color themes
  use { 'EdenEast/nightfox.nvim', config = c'nightfox' }    -- 🦊

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
          'nvim-lua/popup.nvim',
          'nvim-telescope/telescope-symbols.nvim',
          { 'nvim-telescope/telescope-frecency.nvim',     -- tries to sort files helpfully
                cmd = 'Telescope',
                config = function() require'telescope'.load_extension'frecency' end,
                requires = 'tami5/sqlite.lua' } } }

  -- 🌳 Syntax

  use { 'nvim-treesitter/nvim-treesitter',
        config = c'treesitter',
        run = ':TSUpdate',                                                -- AST wizardry 🧙
        requires = {
          'RRethy/nvim-treesitter-endwise',                               -- append `end` in useful places
          'windwp/nvim-ts-autotag',                                       -- close HTML tags, but using treesitter
          'nvim-treesitter/nvim-treesitter-textobjects' -- select a comment
        } }
  use { 'code-biscuits/nvim-biscuits', config = c'biscuits' }             -- hints for block ends
  use {'lepture/vim-jinja', ft = {'md','html','njk'} }                    -- regexp-based syntax for njk
  use 'nvim-treesitter/playground'                                        -- tool for exploring treesitter ASTs

  -- 🪟 UI

  use { 'https://gitlab.com/yorickpeterse/nvim-window.git',
        module = 'nvim-window' }
  use 'famiu/bufdelete.nvim'                                         -- close buffers (tabs) with less headache
  use { 'folke/twilight.nvim',                                       -- focus mode editing
        cmd = 'Twilight' }
  use 'kosayoda/nvim-lightbulb'                                      -- 💡
  use { 'kyazdani42/nvim-web-devicons',                              -- yet more icons
        config = c'web-devicons',
        module = 'nvim-web-devicons' }
  use { 'mvllow/modes.nvim', config = c'modes' }                     -- the colors!
  use { 'goolord/alpha-nvim',                                        -- startup screen
        config = c'alpha', }
        -- setup = function()
        --   -- Automatically open alpha when the last buffer is deleted and only one window left
        --   vim.api.nvim_create_autocmd({ 'BufDelete', 'VimEnter' }, {
        --     callback = function ()
        --       local empty = vim.fn.empty(vim.fn.filter(vim.fn.tabpagebuflist(), '!buflisted(v:val)')) == 0
        --       local nowin = vim.fn.winnr('$') == 1
        --       if empty and nowin then
        --         require'alpha'.start(false)
        --       end
        --     end
        --   })
        -- end }
  use { 'akinsho/bufferline.nvim', config = c'bufferline' }          -- editor tabs. yeah ok I know they're not "tabs"
  use { 'rcarriga/nvim-notify', config = c'notify' }                 -- pretty notifications
  use { 'antoinemadec/FixCursorHold.nvim',
        setup = function() vim.g.cursorhold_updatetime = 100 end }   -- bug fix for neovim's CursorHold event
  use 'RRethy/vim-illuminate'
                                                                     -- use { 'lukas-reineke/indent-blankline.nvim',
                                                                     --       config = c'indent', setup = s'indent' }                      -- indentation guide with context
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

  -- use { 'Shatur/neovim-session-manager',
  --       config = c'neovim-session-manager',
  --       requires = {
  --         'nvim-telescope/telescope.nvim',
  --         'JoseConseco/telescope_sessions_picker.nvim' } }

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
  use { 'echasnovski/mini.nvim', config = c'mini' }               -- lots of plugins
  -- use { 'numToStr/Comment.nvim', config = c'comment' }           -- comment/uncomment text objects
  -- use { 'windwp/nvim-autopairs', config = c'autopairs' }         -- automatically pair brackets etc
  use { 'mg979/vim-visual-multi', branch = 'master' }            -- multiple cursors, kinda like atom + vim-mode-plus
  use { 'anuvyklack/pretty-fold.nvim', config = c'pretty-fold' } -- beautiful folds with previews
  use { 'monkoose/matchparen.nvim',                              -- highlight matching paren
        config = function() require'matchparen'.setup {on_startup=false} end,
        ft = {
          'lua',
          'js', 'javascript',
          'ts', 'typescript',
          'html', 'njk', 'ejs', 'jinja',
          'fish', 'bash', 'sh',
          'json',
        } }
  use { 'AndrewRadev/splitjoin.vim',                             -- like vmp `g,` action
        setup = function()
          vim.g.splitjoin_split_mapping = ''
          vim.g.splitjoin_join_mapping = ''
          vim.api.nvim_set_keymap('n', 'gj', ':SplitjoinJoin<cr>', {})
          vim.api.nvim_set_keymap('n', 'g,', ':SplitjoinSplit<cr>', {})
        end }
  use { '~/Developer/nvim-regexplainer', config = c'regexplainer',
        requires = 'MunifTanjim/nui.nvim' }


  -- 🤖 Language Server

  use 'nvim-lua/lsp-status.nvim'             -- support for reporting buffer's lsp status (diagnostics, etc) to other plugins
  use 'onsails/lspkind-nvim'                 -- fancy icons for lsp AST types and such
  use { 'folke/lua-dev.nvim', ft = 'lua' }   -- nvim api docs, signatures, etc.
  use { 'j-hui/fidget.nvim',                 -- LSP eye-candy
        config = function ()
          require'fidget'.setup()
        end }
  use { 'williamboman/nvim-lsp-installer',   -- automatically install language servers
        config = c'lsp',
        requires = {
          'neovim/nvim-lspconfig',           -- basic facility to configure language servers
          'hrsh7th/nvim-cmp',
          'b0o/schemastore.nvim',            -- json schema support
          'neovim/nvim-lspconfig' } }
  use { 'folke/lsp-trouble.nvim',            -- language-server diagnostics panel
        config = c'trouble',
        requires = {
          'folke/trouble.nvim',
          'kyazdani42/nvim-web-devicons'
        } }
  use { 'rmagatti/goto-preview',             -- gd, but in a floating window
        config = function() require'goto-preview'.setup {} end }

  -- 📎 Completions and Snippets

  use { 'mtoohey31/cmp-fish', ft = "fish" }                                          -- 🐟
  use { 'hrsh7th/nvim-cmp',
        config = c'cmp',
        requires = {
          'petertriho/cmp-git',                                                      -- autocomplete git issues
          'nvim-lua/plenary.nvim' ,
          'hrsh7th/cmp-nvim-lsp',                                                    -- language-server-based completions
          'hrsh7th/cmp-nvim-lua',                                                    -- lua
          'hrsh7th/cmp-calc',                                                        -- math
          'hrsh7th/cmp-buffer',                                                      -- buffer contents completion
          'hrsh7th/cmp-path',                                                        -- path completions
          'hrsh7th/cmp-emoji',                                                       -- ok boomer
          'hrsh7th/cmp-cmdline',                                                     -- cmdline completions
          'hrsh7th/cmp-nvim-lsp-signature-help',                                     -- ffffunction
          'David-Kunz/cmp-npm',                                                      -- npm package versions
          'lukas-reineke/cmp-under-comparator',                                      -- _afterOthers
          'L3MON4D3/LuaSnip',
          'saadparwaiz1/cmp_luasnip' } }                                                  -- completion engine

  -- 📌 Git

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
    profile = {
      enable = true,
      threshold = 1,
    }
  }
})
