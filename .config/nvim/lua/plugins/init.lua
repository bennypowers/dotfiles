return {

  { import = 'plugins.colorschemes' },
  { import = 'plugins.editing' },
  { import = 'plugins.git' },
  { import = 'plugins.languages' },
  { import = 'plugins.lsp' },
  { import = 'plugins.treesitter' },
  { import = 'plugins.ui' },

  { 'masukomi/html_encode_decode', enabled = false },

  { 'powerman/vim-plugin-AnsiEsc', lazy = true },

  -- Telescope live_grep -> <Tab> to select files -> <C-q> to populate qflist -> <leader>h to find/replace in qf files
  'gabrielpoca/replacer.nvim',

}
