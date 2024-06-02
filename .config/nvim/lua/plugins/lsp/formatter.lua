local ignores = {
  'nusah/keymap.json'
}

---Adapted from MunifTanjim/prettier.nvim
---@param project_root string
---@return boolean
local function prettier_package_json_key_exists(project_root)
  local ok, has_prettier_key = pcall(function()
    local package_json_blob = table.concat(vim.fn.readfile(require'lspconfig.util'.path.join(project_root, "/package.json")))
    local package_json = vim.json.decode(package_json_blob) or {}
    return not not package_json.prettier
  end)
  return ok and has_prettier_key
end
---Adapted from MunifTanjim/prettier.nvim
---@param project_root string
---@return boolean
local function prettier_config_file_exists(project_root)
  return (not not project_root)
         and vim.tbl_count(vim.fn.glob('.prettierrc*', true, true)) > 0
          or vim.tbl_count(vim.fn.glob('prettier.config.*', true, true)) > 0
end

local function prettier_d()
  local startpath = vim.fn.getcwd()
  local project_root = (require'lspconfig.util'.find_git_ancestor(startpath)
                     or require'lspconfig.util'.find_package_json_ancestor(startpath))
  if prettier_config_file_exists(project_root)
  or prettier_package_json_key_exists(project_root) then
    return require'formatter.defaults.prettierd'()
  end
end

local function ignore_file(filepath)
  local match = vim.fn.match(ignores, filepath);
  return match ~= -1
end

return { 'mhartington/formatter.nvim',
  enabled = true,
  config = function()
    require'formatter'.setup {
      filetype = {
        -- lua = require'formatter.filetypes.lua'.stylua,
        javascript = {
          require'formatter.filetypes.javascript'.eslint_d,
          prettier_d,
        },
        typescript = {
          require'formatter.filetypes.typescript'.eslint_d,
          prettier_d,
        },
        json = require'formatter.filetypes.json'.fixjson,
      },
    }
    local format_on_save = true
    command('FormatDisable', function()
      format_on_save = false
    end, {
      desc = 'Disable format on save',
    })
    command('FormatEnable', function()
      format_on_save = true
    end, {
      desc = 'Enable format on save',
    })
    au('BufWritePost', {
      group = ag('FormatAutogroup', {}),
      pattern = '*',
      callback = function(args)
        if format_on_save and not ignore_file(args.file) then
          vim.cmd[[FormatWrite]]
        end
      end
    })
  end,
}
