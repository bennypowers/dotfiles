-- 🤖 Language Servers, automatically installed
return { 'williamboman/mason.nvim',
  enabled = true,
  dependencies = {
    'neovim/nvim-lspconfig',
    'williamboman/mason-lspconfig.nvim',
    -- 'typescript',
    'hrsh7th/nvim-cmp',
    'nvim-lua/lsp-status.nvim',
    'b0o/schemastore.nvim', -- json schema support
    'onsails/lspkind-nvim', -- fancy icons for lsp AST types and such
    { 'lukas-reineke/lsp-format.nvim', opts = {} },
    { 'folke/lazydev.nvim',
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
 { 'Bilal2453/luvit-meta', lazy = true }, -- optional `vim.uv` typings
 { 'hrsh7th/nvim-cmp',
      opts = function(_, opts)
        opts.sources = opts.sources or {}
        table.insert(opts.sources, {
          name = 'lazydev',
          group_index = 0, -- set group index to 0 to skip loading LuaLS completions
        })
      end,
    },
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

    local ensure_installed = vim.tbl_filter(function(name)
      -- vala is a special case, as mason has difficulty managing its build deps
      return name ~= 'vala_ls'
    end, vim.tbl_keys(configs))

    require 'mason'.setup()

    require 'mason-lspconfig'.setup {
      ensure_installed = ensure_installed,
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

    local default_config = {
      capabilities = default_capabilities(),
      on_attach = function(client, bufnr)
        -- default on_attach function
        require 'lsp-status'.on_attach(client)
        if client.server_capabilities.documentSymbolProvider then
          require 'nvim-navic'.attach(client, bufnr)
        end
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
        end
        -- require'lsp-format'.on_attach(client)
      end,
    }

    local function get_config_mod(server_name)
      local mod_name = configs[server_name]

      local config = {}

      if type(mod_name) == 'string' then
        config = require('lspconfigs.' .. server_name)
      end

      local enabled = config.enabled;
      config.enabled = nil
      if enabled == nil then enabled = true end

      config = vim.tbl_extend('force', default_config, config)

      return config, enabled
    end

    local function setup_vala()
      local config, enabled = get_config_mod'vala_ls'
      if enabled then
        require'lspconfig'.vala_ls.setup(config)
      end
    end

    require 'mason-lspconfig'.setup_handlers {
      function(server_name)
        if server_name == 'tsserver' then return end
        local config, enabled = get_config_mod(server_name)
        if enabled then
          require 'lspconfig'[server_name].setup(config)
        end
      end,
      vala_ls = setup_vala
    }

    setup_vala();
  end,

}
