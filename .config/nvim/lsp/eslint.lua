local cfg = require 'lsp'

---@type vim.lsp.ClientConfig
return {
  cmd = { 'vscode-eslint-language-server', '--stdio' },
  root_dir = cfg.required_root_markers {
    '.eslintrc',
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc.yaml',
    '.eslintrc.yml',
    '.eslintrc.json',
    'eslint.config.js',
    'eslint.config.mjs',
    'eslint.config.cjs',
    'eslint.config.ts',
    'eslint.config.mts',
    'eslint.config.cts',
  },
  filetypes = {
    'javascript', 'javascriptreact',
    'typescript', 'typescriptreact',
    'html',
  },
  root_markers = {
    '.eslintrc',
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc.yaml',
    '.eslintrc.yml',
    '.eslintrc.json',
    'eslint.config.js',
    'eslint.config.mjs',
    'eslint.config.cjs',
    'eslint.config.ts',
    'eslint.config.mts',
    'eslint.config.cts',
    'package.json',
    '.git',
  },
  capabilities = cfg.capabilities {
    documentFormattingProvider = true,
  },
  handlers = {
    ['eslint/openDoc'] = function(_, result)
      if result then
        vim.ui.open(result.url)
      end
      return {}
    end,
    ['eslint/confirmESLintExecution'] = function(_, result)
      if not result then
        return
      end
      return 4 -- approved
    end,
    ['eslint/probeFailed'] = function()
      vim.notify('ESLint probe failed.', vim.log.levels.WARN)
      return {}
    end,
    ['eslint/noLibrary'] = function()
      vim.notify('Unable to find ESLint library.', vim.log.levels.WARN)
      return {}
    end,
  },
  commands = {
    EslintFixAll = function()
      local client = unpack(vim.lsp.get_clients { bufnr = 0, name = 'eslint' })
      if client then
        client:request_sync('workspace/executeCommand', {
                              command = 'eslint.applyAllFixes',
                              arguments = {
                                {
                                  uri = vim.uri_from_bufnr(0),
                                  version = vim.lsp.util.buf_versions[0],
                                },
                              },
                            }, nil, 0)
      end
    end
  },
  settings = {
    validate = 'on',
    packageManager = nil,
    useESLintClass = false,
    experimental = {
      useFlatConfig = true,
    },
    codeActionOnSave = {
      enable = true,
      mode = 'all',
      rules = { '!debugger', '!no-only-tests/*' },
    },
    format = false,
    quiet = false,
    onIgnoredFiles = 'off',
    rulesCustomizations = {},
    run = 'onType',
    problems = {
      shortenToSingleLine = false,
    },
    -- nodePath configures the directory in which the eslint server should start its node_modules resolution.
    -- This path is relative to the workspace folder (root dir) of the server instance.
    nodePath = '',
    -- use the workspace folder location or the file location (if no workspace folder is open) as the working directory
    workingDirectory = { mode = 'location' },
    codeAction = {
      disableRuleComment = {
        enable = true,
        location = 'separateLine',
      },
      showDocumentation = {
        enable = true,
      },
    },
  },
}
