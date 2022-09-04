vim.g.diagnostic_enable_virtual_text = 1
vim.g.diagnostic_virtual_text_prefix = ' '
vim.fn.sign_define('DiagnosticSignError', { text = '🔥', texthl = 'DiagnosticError' })
vim.fn.sign_define('DiagnosticSignWarning', { text = '🚧', texthl = 'DiagnosticWarning' })
vim.fn.sign_define('DiagnosticSignInformation', { text = '👷', texthl = 'DiagnosticInformation' })
vim.fn.sign_define('DiagnosticSignHint', { text = '🙋', texthl = 'DiagnosticHint' })

local mason           = require 'mason'
local mason_lspconfig = require 'mason-lspconfig'
local lsp_config      = require 'lspconfig'
local lsp_status      = require 'lsp-status'
local lsp_format      = require 'lsp-format'
local lsp_util        = require 'lspconfig.util'
local cmp_nvim_lsp    = require 'cmp_nvim_lsp'

lsp_format.setup()

local default_capabilities = vim.tbl_extend('keep',
  cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities()),
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

--- Neovim's LSP client does not currently support dynamic capabilities registration, so we need to set
--- the resolved capabilities of the eslint server ourselves!
---
---@param  enable boolean whether to enable formating
---
local function toggle_formatting(enable)
  return function(client)
    if (enable) then
      lsp_format.on_attach(client)
    end
    default_on_attach(client)
  end
end

-- Install these, k?
-- Specify server options and settings per server by adding an options table
-- servers with `false` options table use the default on_attach function
--
local servers = {
  -- ['angularls'] = {},

  -- ['dockerls'] = {},

  -- ['denols'] = {
  --   on_attach = toggle_formatting(false), -- Disable formatting so that eslint can take over.
  -- },

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
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('carry_lsp-water', {}),
        pattern = { '*.tsx', '*.ts', '*.jsx', '*.js', },
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

  -- haskell
  -- ['hls'] = {},

  html = {
    filetypes = { 'html', 'njk', 'md' },
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
    on_attach = toggle_formatting(true),
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
    on_attach = toggle_formatting(true),
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
  sumneko_lua = require 'lua-dev'.setup {
    -- add any options here, or leave empty to use the default settings
    -- lspconfig = {
    --   cmd = {"lua-language-server"}
    -- },
    lspconfig = {
      settings = {
        autoFixOnSave = true,
        Lua = {
          -- next three replaced by pre-compiled docs in `folke/lua-dev.nvim`
          -- runtime = {
          --   version = 'LuaJIT',
          --   path = get_sumneko_lua_runtime_path(),
          -- },
          -- diagnostics = {
          --   globals = { 'utf8', 'vim' }, -- Get the language server to recognize the `vim` global
          -- },
          -- workspace = {
          --   library = vim.api.nvim_get_runtime_file('', true), -- Make the server aware of Neovim runtime files
          --   checkThirdParty = false,
          -- },
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

  -- typescript language server options
  tsserver = {
    on_attach = toggle_formatting(false), -- Disable formatting so that eslint can take over.
    root_dir = lsp_util.find_git_ancestor,
    settings = {
      format = false,
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        }
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        }
      }
    },
  },

  vala_ls = {},

  vimls = {},
  yamlls = {},
}

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
  ensure_installed = vim.tbl_keys(servers)
}

--- Loop through the servers listed above.
--- setup install
--- installing each, then if install succeeded,
--- setup the server with the options specified in server_opts,
--- or just use the default options
--
for name, opts in pairs(servers) do
  local server_config = vim.tbl_extend('force', {
    capabilities = default_capabilities,
    on_attach = default_on_attach,
  }, opts or {})
  lsp_config[name].setup(server_config)
end

-- uncomment for automatic hover on cursor-hold
-- see also https://github.com/neovim/neovim/issues/9534
-- vim.api.nvim_create_augroup('HoverOnHold')
-- vim.api.nvim_create_autocmd('CursorHold', {
--   pattern = '*',
--   group = 'HoverOnHold',
--   callback = function() vim.lsp.buf.hover() end,
-- })
