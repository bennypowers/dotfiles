local ignores = {
  'nusah/keymap.json',
}

---Adapted from MunifTanjim/prettier.nvim
---@param project_root string
---@return boolean
local function prettier_package_json_key_exists(project_root)
  local ok, has_prettier_key = pcall(function()
    local package_json_blob =
      table.concat(vim.fn.readfile(require('lspconfig.util').path.join(project_root, '/package.json')))
    local package_json = vim.json.decode(package_json_blob) or {}
    return not not package_json.prettier
  end)
  return ok and has_prettier_key
end

---Adapted from MunifTanjim/prettier.nvim
---@param project_root string
---@return boolean
local function prettier_config_file_exists(project_root)
  return (not not project_root) and vim.tbl_count(vim.fn.glob('.prettierrc*', true, true)) > 0
    or vim.tbl_count(vim.fn.glob('prettier.config.*', true, true)) > 0
end

local function prettier_d()
  local startpath = vim.fn.getcwd()
  local project_root = (
    require('lspconfig.util').find_git_ancestor(startpath)
    or require('lspconfig.util').find_package_json_ancestor(startpath)
  )
  if prettier_config_file_exists(project_root) or prettier_package_json_key_exists(project_root) then
    vim.notify 'prettier'
    return require 'formatter.defaults.prettierd'()
  end
end

local function ignore_file(filepath)
  local match = vim.fn.match(ignores, filepath)
  return match ~= -1
end

return {
  'mhartington/formatter.nvim',
  enabled = false,
  config = function()
    require('formatter').setup {
      filetype = {
        lua = require('formatter.filetypes.lua').stylua,
        javascript = {
          function()
            return {
              exe = vim.fn.stdpath 'data' .. '/mason/bin/eslint_d',
              args = {
                '--stdin',
                '--stdin-filename',
                require('formatter.util').escape_path(require('formatter.util').get_current_buffer_file_path()),
                '--fix-to-stdout',
              },
              stdin = true,
            }
          end,
          -- prettier_d,
        },
        typescript = {
          function()
            local cwd = vim.fn.getcwd()
            local is_deno = vim.fn.filereadable(cwd .. '/deno.json') == 1
              or vim.fn.filereadable(cwd .. '/deno.jsonc') == 1

            if is_deno then
              return { exe = 'deno', args = { 'fmt' }, stdin = false }
            elseif prettier_config_file_exists(cwd) then
              return prettier_d()
            else
              return {
                exe = vim.fn.stdpath 'data' .. '/mason/bin/eslint_d',
                args = {
                  '--stdin',
                  '--stdin-filename',
                  require('formatter.util').escape_path(require('formatter.util').get_current_buffer_file_path()),
                  '--fix-to-stdout',
                },
                stdin = true,
              }
            end
          end,
        },
        json = require('formatter.filetypes.json').fixjson,
        qml = {
          function()
            return {
              exe = '/usr/lib64/qt6/bin/qmlformat',
              args = {
                '--normalize',
                require('formatter.util').escape_path(require('formatter.util').get_current_buffer_file_path()),
              },
              stdin = true,
            }
          end,
        },
      },
    }
    local format_on_save = true
    command('FormatDisable', function() format_on_save = false end, {
      desc = 'Disable format on save',
    })
    command('FormatEnable', function() format_on_save = true end, {
      desc = 'Enable format on save',
    })
    au('BufWritePost', {
      group = ag('FormatAutogroup', {}),
      pattern = '*',
      callback = function(args)
        if format_on_save and not ignore_file(args.file) then vim.cmd [[FormatWrite]] end
      end,
    })
  end,
}
