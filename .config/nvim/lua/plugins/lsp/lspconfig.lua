-- basic facility to configure language servers
return { 'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'hrsh7th/nvim-cmp',
    'b0o/schemastore.nvim', -- json schema support
    'typescript',
    'nvim-lua/lsp-status.nvim',
    { 'lukas-reineke/lsp-format.nvim', opts = {} },
    { 'folke/neodev.nvim', opts = {} }, -- nvim api docs, signatures, etc.
  },

  init = function()
    vim.g.diagnostic_enable_virtual_text = 1
    vim.g.diagnostic_virtual_text_prefix = ' '
    vim.fn.sign_define('DiagnosticSignError', { text = '🔥', texthl = 'DiagnosticError' })
    vim.fn.sign_define('DiagnosticSignWarning', { text = '🚧', texthl = 'DiagnosticWarning' })
    vim.fn.sign_define('DiagnosticSignInformation', { text = '👷', texthl = 'DiagnosticInformation' })
    vim.fn.sign_define('DiagnosticSignHint', { text = '🙋', texthl = 'DiagnosticHint' })
  end,

  config = function()
    local lsp_config = require 'lspconfig'
    local lsp_status = require 'lsp-status'
    local cmp_nvim_lsp = require 'cmp_nvim_lsp'

    -- Install these, k?
    -- Specify server options and settings per server by adding an options table
    -- servers with `false` options table use the default on_attach function
    --
    local configs = {

      -- ['angularls'] = {},
      -- ['dockerls'] = {},
      -- ['denols'] = {},

      bashls = {},

      clangd = {},

      cssls = {},

      graphql = {},

      pyright = {},

      rust_analyzer = {},

      -- OpenAPI
      -- ['spectral'] = {},

      -- vala_ls = {},

      vimls = {},

      yamlls = {},
    }
    -- Read server configs from lua/plugins/lsp/lspconfig/*.lua
    for _, filename in ipairs(vim.fn.readdir(vim.fn.expand('~/.config/nvim/lua/plugins/lsp/lspconfig/'))) do
      local lspname = filename:gsub('%.lua$', '')
      configs[lspname] = require('plugins.lsp.lspconfig.'..lspname)
    end

    local default_capabilities = vim.tbl_extend('keep',
      cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities()),
      lsp_status.capabilities
    )

    default_capabilities.textDocument.completion.completionItem.snippetSupport = true
    default_capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
      },
    }

    for name, opts in pairs(configs) do
      lsp_config[name].setup(vim.tbl_extend('force', {
        capabilities = default_capabilities,
        on_attach = function(client)
          -- default on_attach function
          lsp_status.on_attach(client)
        end,
      }, opts or {}))
    end
  end,
}
