vim.g.diagnostic_enable_virtual_text = 1
vim.g.diagnostic_virtual_text_prefix = ' '
vim.fn.sign_define("DiagnosticSignError",       { text = "🔥", texthl = "DiagnosticError"       })
vim.fn.sign_define("DiagnosticSignWarning",     { text = "🚧", texthl = "DiagnosticWarning"     })
vim.fn.sign_define("DiagnosticSignInformation", { text = "👷", texthl = "DiagnosticInformation" })
vim.fn.sign_define("DiagnosticSignHint",        { text = "🙋", texthl = "DiagnosticHint"        })

return function()
  local lsp_installer_servers = require'nvim-lsp-installer.servers'
  local cmp_nvim_lsp          = require'cmp_nvim_lsp'
  local lsp_status            = require'lsp-status'
  local lsp_util              = require'lspconfig.util'

  -- Install these, k?
  local servers = {
    'angularls',
    'bashls',
    'clangd',
    'cssls',
    'dockerls',
    'emmet_ls',
    'eslint',
    'graphql',
    'hls',            -- haskell
    'html',
    'jsonls',
    'pyright',
    'rust_analyzer',
    'spectral',       -- OpenAPI
    'stylelint_lsp',
    'sumneko_lua',    -- lua
    'tsserver',       -- typescript
    'vimls',
    'yamlls',

    -- "remark_ls",      -- markdown. see https://github.com/unifiedjs/unified-language-server/issues/31
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

  -- Setup lspconfig with some default capabilities
  --
  local function default_on_attach(client)
    local capabilities = vim.tbl_extend(
      'keep',
      cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities()),
      lsp_status.capabilities
    )
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
      }
    }
    local has_illuminate, illuminate = pcall(require, 'illuminate')
    if has_illuminate then illuminate.on_attach(client) end
    lsp_status.on_attach(client)
  end

  --- Neovim's LSP client does not currently support dynamic capabilities registration, so we need to set
  --- the resolved capabilities of the eslint server ourselves!
  ---
  ---@param  allow_formatting boolean whether to enable formating
  ---@param  format_on_save   boolean whether to enable format on save
  ---
  local function toggle_formatting(allow_formatting, format_on_save)
    return function(client)
      default_on_attach(client)

      client.resolved_capabilities.document_formatting = allow_formatting
      client.resolved_capabilities.document_range_formatting = allow_formatting

      -- format on save
      if format_on_save then
        vim.api.nvim_create_augroup('LspFormatting', { clear = true })
        vim.api.nvim_create_autocmd('BufWritePre', {
          pattern = '<buffer>',
          group = 'LspFormatting',
          callback = function(opts)
            local ext = opts.match:match(".*[\\/](.*)"):match(".+%.(%w+)")
            local extension_map = require'filetype.mappings.extensions'
            local ft = extension_map[ext]
            if ft == 'javascript' or ft == 'typescript' then
              os.execute('sleep ' .. 0.2)
            end
            vim.lsp.buf.formatting_sync()
          end
        })
      end
    end
  end

  --- Setup your lua path
  --- needed to get IDE features in lua files
  --- I promised clason in the neovim gitter i wouldn't call it 'intellisense'
  ---@return string[]
  ---
  local function get_sumneko_lua_runtime_path()
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")
    return runtime_path
  end

  -- Specify server options and settings per server
  -- servers not configured here will use the defaul on_attach function
  --
  local server_opts = {

    denols = {
      on_attach = toggle_formatting(false), -- Disable formatting so that eslint can take over.
    },

    eslint = {
      on_attach = toggle_formatting(true, true),
      root_dir = lsp_util.find_git_ancestor,
      settings = {
        enable = true,
        format = { enable = true }, -- this will enable formatting
        packageManager = "npm",
        autoFixOnSave = true,
        codeActionsOnSave = {
          mode = "all",
          rules = { "!debugger", "!no-only-tests/*" },
        },
        lintTask = {
          enable = true,
        },
      },
    },

    emmet_ls = {
      root_dir = lsp_util.find_git_ancestor,
      filetypes = {
        'html',
        'css', 'scss',
        'njk', 'nunjucks', 'jinja',
        -- 'ts', 'typescript',
        'md', 'markdown',
        -- 'js', 'javascript',
      },
    },

    jsonls = {
      settings = {
        json = {
          schemas = require'schemastore'.json.schemas(),
        },
      },
    },

    remark_ls = {
      settings = {
        defaultProcessor = 'remark',
      },
    },

    stylelint_lsp = {
      on_attach = toggle_formatting(true, true),
      filetypes = {
        'css',
        'les',
        'scss',
        'sugarss',
        'vue',
        'wxss',
      },
      settings = {
        stylelintplus = {
          cssInJs = false,
        },
      },
    },

    sumneko_lua = {
      -- on_attach = toggle_formatting(true, true),
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
            path = get_sumneko_lua_runtime_path(),
          },
          diagnostics = {
            globals = { 'utf8', 'vim' }, -- Get the language server to recognize the `vim` global
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file('', true), -- Make the server aware of Neovim runtime files
            checkThirdParty = false,
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

    tsserver = {
      on_attach = toggle_formatting(false), -- Disable formatting so that eslint can take over.
      root_dir = lsp_util.find_git_ancestor,
      settings = {
        format = { enable = false },
      },
    },

  }

  -- Loop through the servers listed above.
  -- installing each, then if install succeeded,
  -- setup the server with the options specified in server_opts,
  -- or just use the default options
  --
  for _, name in pairs(servers) do
    local available, server = lsp_installer_servers.get_server(name)

    if available then
      server:on_ready(function ()
        local opts = server_opts[server.name] or {}
              opts.on_attach = opts.on_attach or default_on_attach
        server:setup(opts)
      end)

      -- Queue the server to be installed.
      if not server:is_installed() then server:install() end
    end
  end

  -- uncomment for automatic hover on cursor-hold
  -- see also https://github.com/neovim/neovim/issues/9534
  -- vim.cmd [[
  -- augroup
  --   au!
  --   autocmd CursorHold  * :lua vim.lsp.buf.hover()
  -- augroup END
  -- ]]

end
