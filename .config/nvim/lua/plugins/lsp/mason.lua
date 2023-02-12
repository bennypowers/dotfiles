-- 🤖 Language Servers, automatically installed
return { 'williamboman/mason.nvim',
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig', -- basic facility to configure language servers
    'nvim-lua/lsp-status.nvim', -- support for reporting buffer's lsp status (diagnostics, etc) to other plugins
    'lukas-reineke/lsp-format.nvim',
    'hrsh7th/nvim-cmp',
    'b0o/schemastore.nvim', -- json schema support
    'typescript',
    {'folke/neodev.nvim', opts = {} }, -- nvim api docs, signatures, etc.
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
    local mason           = require 'mason'
    local mason_lspconfig = require 'mason-lspconfig'
    local lsp_config      = require 'lspconfig'
    local lsp_status      = require 'lsp-status'
    local lsp_format      = require 'lsp-format'
    local lsp_util        = require 'lspconfig.util'
    local cmp_nvim_lsp    = require 'cmp_nvim_lsp'

    lsp_format.setup()

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
      }
    }

    -- Setup lspconfig with some default capabilities
    --
    local function default_on_attach(client)
      lsp_status.on_attach(client)
    end

    lsp_status.config {
      current_function = false,
      kind_labels = vim.g.completion_customize_lsp_label,
      indicator_errors = '🔥',
      indicator_warnings = ' 🚧',
      indicator_info = 'ℹ️ ',
      indicator_hint = '🙋 ',
      indicator_ok = ' ',
      spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' },
      status_symbol = '',
      -- status_symbol = '💬: ',
      -- status_symbol = ' ',
    }

    lsp_status.register_progress()

    mason.setup()

    mason_lspconfig.setup {
      automatic_installation = true,
    }

    -- Install these, k?
    -- Specify server options and settings per server by adding an options table
    -- servers with `false` options table use the default on_attach function
    --
    for name, opts in pairs {
      -- ['angularls'] = {},
      -- ['dockerls'] = {},
      -- ['denols'] = {},

      -- markdown
      marksman = {
        settings = {
          autoFixOnSave = true,
        },
      },

      bashls = {},

      clangd = {},

      cssls = {},

      emmet_ls = {
        root_dir = lsp_util.find_git_ancestor,
        single_file_support = true,
        filetypes = {
          'html',
          'svg',
          'css', 'scss',
          'njk', 'nunjucks', 'jinja',
          -- 'markdown',
          'ts', 'typescript',
          'js', 'javascript',
        },
      },

      eslint = {
        root_dir = lsp_util.find_git_ancestor,
        on_attach = function (client)
          ---For reasons unclear to me, eslint ls doesn't autoFixOnSave,
          ---so execute `EslintFixAll` instead
          --
          au('BufWritePre', {
            group = ag('carry_lsp-water', {}),
            pattern = { '*.tsx', '*.ts', '*.jsx', '*.js', '*.cjs' },
            command = 'EslintFixAll',
          })

          default_on_attach(client)
        end,
        settings = {
          codeActionsOnSave = {
            enable = true,
            mode = "all",
            rules = { "!debugger", "!no-only-tests/*" },
          },
        },
      },

      graphql = {},

      html = {
        filetypes = { 'html', 'njk', 'md', 'svg' },
        settings = {
          html = {
            format = {
              templating = true,
              wrapLineLength = 200,
              wrapAttributes = 'force-aligned',
            },
            editor = {
              formatOnSave = false,
              formatOnPaste = true,
              formatOnType = false,
            },
            hover = {
              documentation = true,
              references = true,
            },
          },
        },
      },

      jsonls = {
        on_attach = function(client)
          lsp_format.on_attach(client)
          default_on_attach(client)
        end,
        settings = {
          json = {
            format = { enable = true },
            schemas = require 'schemastore'.json.schemas(),
            validate = { enable = true },
          },
        },
      },

      pyright = {},

      rust_analyzer = {},

      -- OpenAPI
      -- ['spectral'] = {},

      stylelint_lsp = {
        on_attach = function(client)
          lsp_format.on_attach(client)
          default_on_attach(client)
        end,
        filetypes = { 'css', 'scss' },
        settings = {
          stylelintplus = {
            autoFixOnSave = true,
            autoFixOnFormat = true,
            cssInJs = false,
          },
        },
      },

      -- lua
      lua_ls = {
        lspconfig = {
          settings = {
            autoFixOnSave = true,
            Lua = {
              format = {
                enable = true,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  quote_style = 'single',
                  align_call_args = true,
                  align_function_define_params = true,
                  continuous_assign_statement_align_to_equal_sign = true,
                }
              },
              completion = {
                autoRequire = false,
                callSnippet = "Replace",
              },
              hint = {
                enable = true,
              },
              telemetry = {
                enable = false, -- Do not send telemetry data containing a randomized but unique identifier
              },
            },
          },
        },
      },

      -- vala_ls = {},

      vimls = {},

      yamlls = {},
    } do
      lsp_config[name].setup(vim.tbl_extend('force', {
        capabilities = default_capabilities,
        on_attach = default_on_attach,
      }, opts or {}))
    end

    require 'inc_rename'.setup()

  end,
}

