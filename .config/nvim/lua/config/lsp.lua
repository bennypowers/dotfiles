vim.g.diagnostic_enable_virtual_text = 1
vim.g.diagnostic_virtual_text_prefix = ' '
vim.fn.sign_define('DiagnosticSignError', { text = '🔥', texthl = 'DiagnosticError' })
vim.fn.sign_define('DiagnosticSignWarning', { text = '🚧', texthl = 'DiagnosticWarning' })
vim.fn.sign_define('DiagnosticSignInformation', { text = '👷', texthl = 'DiagnosticInformation' })
vim.fn.sign_define('DiagnosticSignHint', { text = '🙋', texthl = 'DiagnosticHint' })

local lsp_installer = require 'nvim-lsp-installer'
local lsp_config    = require 'lspconfig'
local lsp_status    = require 'lsp-status'
local lsp_util      = require 'lspconfig.util'
local cmp_nvim_lsp  = require 'cmp_nvim_lsp'

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
  local has_illuminate, illuminate = pcall(require, 'illuminate')
  if has_illuminate then illuminate.on_attach(client) end
  lsp_status.on_attach(client)
end

--- Neovim's LSP client does not currently support dynamic capabilities registration, so we need to set
--- the resolved capabilities of the eslint server ourselves!
---
---@param  enable boolean whether to enable formating
---
local function toggle_formatting(enable)
  return function(client)
    default_on_attach(client)
    client.server_capabilities.documentFormattingProvider = enable
    client.server_capabilities.documentRangeFormattingProvider = enable
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

  -- markdown. see https://github.com/unifiedjs/unified-language-server/issues/31
  -- ['remark_ls'] = {
  --   settings = {
  --     defaultProcessor = 'remark',
  --   },
  -- },

  ['bashls'] = {},
  ['clangd'] = {},
  ['cssls'] = {},

  ['emmet_ls'] = {
    root_dir = lsp_util.find_git_ancestor,
    single_file_support = true,
    filetypes = {
      'html',
      'css', 'scss',
      'njk', 'nunjucks', 'jinja',
      'markdown',
      -- 'ts', 'typescript',
      -- 'js', 'javascript',
    },
  },

  ['eslint'] = {
    on_attach = toggle_formatting(true),
    root_dir = lsp_util.find_git_ancestor,
    settings = {
      autoFixOnSave = true,
      codeActionsOnSave = {
        enable = true,
        mode = "all",
        rules = { "!debugger", "!no-only-tests/*" },
      },
    },
  },

  ['graphql'] = {},

  -- haskell
  -- ['hls'] = {},

  ['html'] = {
    settings = {
      autoFixOnSave = false,
      html = {
        format = {
          templating = true,
          wrapLineLength = 200,
          wrapAttributes = 'force-aligned',
        },
        editor = {
          formatOnSave = false,
          formatOnPaste = false,
          formatOnType = false,
        },
        hover = {
          documentation = true,
          references = true,
        },
      },
    },
  },

  ['jsonls'] = {
    settings = {
      autoFixOnSave = true,
      json = {
        schemas = require 'schemastore'.json.schemas(),
      },
    },
  },

  ['pyright'] = {},
  ['rust_analyzer'] = {},

  -- OpenAPI
  ['spectral'] = {},

  ['stylelint_lsp'] = {
    on_attach = toggle_formatting(true),
    filetypes = {
      'css',
      'les',
      'scss',
      'sugarss',
      'vue',
      'wxss',
    },
    settings = {
      autoFixOnSave = true,
      stylelintplus = {
        autoFixOnSave = true,
        autoFixOnFormat = true,
        cssInJs = false,
      },
    },
  },

  -- lua
  ['sumneko_lua'] = require 'lua-dev'.setup {
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

  -- typescript
  ['tsserver'] = {
    on_attach = toggle_formatting(false), -- Disable formatting so that eslint can take over.
    root_dir = lsp_util.find_git_ancestor,
    settings = {
      format = false,
    },
  },

  ['vimls'] = {},
  ['yamlls'] = {},
}

lsp_status.config {
  kind_labels = vim.g.completion_customize_lsp_label,
  current_function = false,
  -- status_symbol = '💬: ',
  -- status_symbol = ' ',
  status_symbol = '',
  indicator_errors = '🔥',
  indicator_warnings = ' 🚧',
  indicator_info = 'ℹ️ ',
  indicator_hint = '🙋 ',
  indicator_ok = ' ',
  spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' },
}

lsp_status.register_progress()

lsp_installer.setup {
  ensure_installed = vim.tbl_keys(servers)
}

-- Loop through the servers listed above.
-- setup install
-- installing each, then if install succeeded,
-- setup the server with the options specified in server_opts,
-- or just use the default options
--
for name, opts in pairs(servers) do
  local server_config = vim.tbl_extend('force', {
    capabilities = default_capabilities,
    on_attach = default_on_attach,
  }, opts or {})
  lsp_config[name].setup(server_config)
end

vim.api.nvim_create_augroup('eslint-fixall', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = { '*.tsx', '*.ts', '*.jsx', '*.js', },
  command = 'EslintFixAll',
})
-- uncomment for automatic hover on cursor-hold
-- see also https://github.com/neovim/neovim/issues/9534
-- vim.api.nvim_create_augroup('HoverOnHold')
-- vim.api.nvim_create_autocmd('CursorHold', {
--   pattern = '*',
--   group = 'HoverOnHold',
--   callback = function() vim.lsp.buf.hover() end,
-- })
