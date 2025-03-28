-- 🤖 Language Servers, automatically installed
return {
  'williamboman/mason.nvim',
  enabled = true,
  dependencies = {
    -- 'typescript',
    'nvim-lua/lsp-status.nvim',
    'b0o/schemastore.nvim', -- json schema support
    'onsails/lspkind-nvim', -- fancy icons for lsp AST types and such
    { 'lukas-reineke/lsp-format.nvim', opts = {} },
    { 'Bilal2453/luvit-meta',          lazy = true }, -- optional `vim.uv` typings
    {
      'folke/lazydev.nvim',
      ft = 'lua', -- only load on lua files
      opts = {
        library = {
          -- Library items can be absolute paths
          -- "~/projects/my-awesome-lib",
          -- Or relative, which means they will be resolved as a plugin
          'LazyVim',
          -- When relative, you can also provide a path to the library in the plugin dir
          'luvit-meta/library', -- see below
        },
      },
    },
  },
  opts = {},
}
