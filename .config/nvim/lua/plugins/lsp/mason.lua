-- 🤖 Language Servers, automatically installed
return {
  'williamboman/mason.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    'williamboman/mason-lspconfig.nvim',
    -- 'typescript',
    'hrsh7th/nvim-cmp',
    'nvim-lua/lsp-status.nvim',
    'b0o/schemastore.nvim', -- json schema support
    'onsails/lspkind-nvim', -- fancy icons for lsp AST types and such
    -- { 'lukas-reineke/lsp-format.nvim', opts = {} },
    { 'folke/neodev.nvim',             opts = {} }, -- nvim api docs, signatures, etc.
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
    local configs = require 'lspconfigs'

    require 'mason'.setup()

    require 'mason-lspconfig'.setup {
      ensure_installed = vim.tbl_keys(configs),
    }

    local function default_capabilities()
      local lsp_status = require 'lsp-status'
      local cmp_nvim_lsp = require 'cmp_nvim_lsp'
      local caps = vim.tbl_extend('keep',
        cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities()),
        lsp_status.capabilities
      )
      caps.textDocument.completion.completionItem.snippetSupport = true
      caps.textDocument.completion.completionItem.resolveSupport = {
        properties = {
          'documentation',
          'detail',
          'additionalTextEdits',
        },
      }
      return caps
    end

    require 'mason-lspconfig'.setup_handlers {
      function(server_name)
        if server_name == 'tsserver' then return end
        local mod_name = configs[server_name]

        local config = {}

        if type(mod_name) == 'string' then
          config = require('lspconfigs.' .. server_name)
        end

        local enabled = config.enabled;
        config.enabled = nil

        if enabled ~= false then
          require 'lspconfig'[server_name].setup(vim.tbl_extend('force', {
            capabilities = default_capabilities(),
            on_attach = function(client, bufnr)
              -- default on_attach function
              require 'lsp-status'.on_attach(client)
              if client.server_capabilities.documentSymbolProvider then
                require 'nvim-navic'.attach(client, bufnr)
              end
              -- require'lsp-format'.on_attach(client)
            end,
          }, config))
        end
      end
    }
  end,
}
