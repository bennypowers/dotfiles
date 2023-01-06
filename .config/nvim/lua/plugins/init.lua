return {
  --[[----------------------------------------------------------
                        🎨 Themes
  --]] ----------------------------------------------------------

  'B4mbus/oxocarbon-lua.nvim',
  'folke/tokyonight.nvim',
  { 'kartikp10/noctis.nvim', dependencies = { 'rktjmp/lush.nvim' } },

  -- telescope as UI for various vim built-in things
  'stevearc/dressing.nvim',
  -- append `end` in useful places
  'RRethy/nvim-treesitter-endwise',
  -- close HTML tags, but using treesitter
  -- 'windwp/nvim-ts-autotag',
  { 'bennypowers/nvim-ts-autotag', branch = 'template-tags' },

  -- select a comment
  'nvim-treesitter/nvim-treesitter-textobjects',

  -- 'masukomi/html_encode_decode',

  -- autoconvert '' or "" to ``
  'axelvc/template-string.nvim',

  -- fancy icons for lsp AST types and such
  'onsails/lspkind-nvim',

  --[[----------------------------------------------------------
  --                    🪟 UI
  --]] ----------------------------------------------------------

  -- navigate to markdown headers
  { 'crispgm/telescope-heading.nvim', ft = { 'md', 'markdown' } },

  -- close buffers (tabs) with less headache
  'ojroques/nvim-bufdel',

  --[[----------------------------------------------------------
  --                    ⌨️  Editing
  --]] ----------------------------------------------------------

  -- align anything
  'tommcdo/vim-lion',

  'powerman/vim-plugin-AnsiEsc',

  -- better to burn out than to fade away
  'simrat39/rust-tools.nvim',

  { 'MrcJkb/haskell-tools.nvim', dependencies = {
    'neovim/nvim-lspconfig',
    'nvim-lua/plenary.nvim',
    'telescope',
  } },

  --[[----------------------------------------------------------
  --                    Languages
  --]] ----------------------------------------------------------

  -- Telescope live_grep -> <Tab> to select files -> <C-q> to populate qflist -> <leader>h to find/replace in qf files
  'gabrielpoca/replacer.nvim',

  -- yae, cae, etc
  { 'kana/vim-textobj-entire', dependencies = { 'kana/vim-textobj-user' } },

  -- multiple cursors, kinda like atom + vim-mode-plus
  { 'mg979/vim-visual-multi', branch = 'master', keys = { '<c-n>' } },

  -- gs to toggle bool
  'AndrewRadev/switch.vim',

  -- markdown previews
  { 'iamcco/markdown-preview.nvim',
    ft = { 'md', 'markdown' },
    build = function()
      vim.fn["mkdp#util#install"]()
    end },

  -- 🔥 Browser Integration
  --    here be 🐉 🐲

  { 'glacambre/firenvim', build = function() vim.fn['firenvim#install'](0) end },

  --[[----------------------------------------------------------
                        Development Tools
  --]] ----------------------------------------------------------

  -- tool for exploring treesitter ASTs
  { 'nvim-treesitter/playground', cmd = 'TSPlaygroundToggle' },

  -- help writing treesitter queries
  'ziontee113/query-secretary',

  -- 🌔 Lua Development

  -- lua docs in vim help
  'milisims/nvim-luaref',

  -- lua REPL/scratchpad
  { 'rafcamlet/nvim-luapad', cmd = 'LuaPad' },

  -- regexp-based syntax for rjk
  { 'lepture/vim-jinja', ft = { 'jinja', 'html' }, enabled = false },

  'RRethy/vim-illuminate',

  -- better vim marks
  { 'chentau/marks.nvim', enabled = false },

  { 'pwntester/octo.nvim',
    enabled = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require 'octo'.setup()
    end },

  -- lit-html
  { 'jonsmithers/vim-html-template-literals', enabled = false },

  -- convert colour values
  { 'NTBBloodbath/color-converter.nvim', enabled = false },

}
