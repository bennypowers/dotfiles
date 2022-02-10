return function()
  local lsp_status = require'lsp-status'
  local lsp_installer_servers = require'nvim-lsp-installer.servers'
  local cmp_nvim_lsp = require'cmp_nvim_lsp'

  -- Install these, k?
  local servers = {
    "angularls",
    "bashls",
    "clangd",
    "cssls",
    "dockerls",
    "emmet_ls",
    "eslint",
    "graphql",
    "hls",            -- haskell
    "html",
    "jsonls",
    "pyright",
    -- "remark_ls",      -- markdown. see https://github.com/unifiedjs/unified-language-server/issues/31
    "rust_analyzer",
    "spectral",       -- OpenAPI
    "stylelint_lsp",
    "sumneko_lua",    -- lua
    "tsserver",       -- typescript
    "vimls",
    "yamlls",
  }

  lsp_status.config {
    kind_labels = vim.g.completion_customize_lsp_label,
    current_function = false,
    status_symbol = '💬: ',
    indicator_errors = '🔥 ',
    indicator_warnings = '🚧 ',
    indicator_info = '👷 ',
    indicator_hint = '🙋 ',
    indicator_ok = '✅',
    spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' },
  }

  lsp_status.register_progress()

  local function common_on_attach(client)
    -- Setup lspconfig.
    local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
      }
    }

    -- autocmd BufWritePre * :!{bash -c "while ![ -e $1 ]; do echo $1; sleep 0.1s; done"} %:p
    if client.resolved_capabilities.document_formatting then
      vim.cmd([[
      augroup LspFormatting
          autocmd! * <buffer>
          autocmd BufWritePre * sleep 200m
          autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
      augroup END
      ]])
    end
  end

  local function disable_formatting(client)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
    common_on_attach(client)
  end

  local function enable_formatting(client)
    client.resolved_capabilities.document_formatting = true
    client.resolved_capabilities.document_range_formatting = true
    common_on_attach(client)
  end

  -- Setup your lua path
  -- needed to get IDE features in lua files
  -- I promised Clason in the neovim gitter i wouldn't call it 'intellisense'
  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  local server_settings = {

    tsserver = {
      format = { enable = false },
    },

    eslint = {
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

    remark_ls = {
      defaultProcessor = 'remark'
    },

    sumneko_lua = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = runtime_path,
        },
        diagnostics = {
          globals = { 'utf8', 'vim' }, -- Get the language server to recognize the `vim` global
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true), -- Make the server aware of Neovim runtime files
          checkThirdParty = false,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    }
  }

  -- Loop through the servers listed above.
  for _, name in pairs(servers) do
    local available, server = lsp_installer_servers.get_server(name)

    if available then
      server:on_ready(function ()
        local opts = { on_attach = common_on_attach }

        -- set server-specific settings
        --
        if server_settings[server.name]   then opts.settings = server_settings[server.name] end

        -- neovim's LSP client does not currently support dynamic capabilities registration, so we need to set
        -- the resolved capabilities of the eslint server ourselves!
        --
        if server.name == "eslint"        then opts.on_attach = enable_formatting end
        if server.name == "sumneko_lua"   then opts.on_attach = enable_formatting end

        -- Disable formatting for typescript, so that eslint can take over.
        --
        if server.name == 'tsserver'      then opts.on_attach = disable_formatting end
        if server.name == 'denols'        then opts.on_attach = disable_formatting end

        if server.name == 'emmet_ls' then
          opts.filetypes = { 'html', 'css', 'scss', 'njk', 'ts', 'js', 'md', 'markdown', 'jinja', 'typescript', 'javascript' }
          opts.root_dir = function() return vim.loop.cwd() end
        end

        server:setup(opts)
      end)

      -- Queue the server to be installed.
      if not server:is_installed() then server:install() end

    end
  end

  -- uncomment for automatic hover on cursor-hold
  -- see also https://github.com/neovim/neovim/issues/9534
  -- vim.cmd [[
  --   autocmd CursorHold  * :lua vim.lsp.buf.hover()
  -- ]]

end
