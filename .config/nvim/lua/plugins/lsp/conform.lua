local ignores = {
  'nusah/keymap.json',
}

---@param dir string
---@return string|nil
local function find_project_root(dir)
  local git_dir = vim.fs.find('.git', { path = dir, upward = true, type = 'directory' })[1]
  if git_dir then
    return vim.fs.dirname(git_dir)
  end
  local package_json = vim.fs.find('package.json', { path = dir, upward = true, type = 'file' })[1]
  if package_json then
    return vim.fs.dirname(package_json)
  end
  return nil
end

---Adapted from MunifTanjim/prettier.nvim
---@param project_root string|nil
---@return boolean
local function prettier_config_file_exists(project_root)
  return (not not project_root)
      and vim.tbl_count(vim.fn.glob('.prettierrc*', true, true)) > 0
    or vim.tbl_count(vim.fn.glob('prettier.config.*', true, true)) > 0
end

---@param project_root string|nil
---@return boolean
local function prettier_package_json_key_exists(project_root)
  if not project_root then
    return false
  end
  local ok, has_prettier_key = pcall(function()
    local package_json_path = vim.fs.joinpath(project_root, 'package.json')
    local package_json_blob = table.concat(vim.fn.readfile(package_json_path))
    local package_json = vim.json.decode(package_json_blob) or {}
    return not not package_json.prettier
  end)
  return ok and has_prettier_key
end

---@return boolean
local function has_prettier()
  local startpath = vim.fn.getcwd()
  local project_root = find_project_root(startpath)
  return prettier_config_file_exists(project_root) or prettier_package_json_key_exists(project_root)
end

---@return boolean
local function is_deno_project()
  local cwd = vim.fn.getcwd()
  return vim.fn.filereadable(cwd .. '/deno.json') == 1 or vim.fn.filereadable(cwd .. '/deno.jsonc') == 1
end

local function ignore_file(filepath)
  local match = vim.fn.match(ignores, filepath)
  return match ~= -1
end

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>lf',
      function() require('conform').format { async = true, lsp_fallback = true } end,
      mode = '',
      desc = 'Format buffer',
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'eslint_d' },
      typescript = function()
        if is_deno_project() then
          return { 'deno_fmt' }
        elseif has_prettier() then
          return { 'prettierd' }
        else
          return { 'eslint_d' }
        end
      end,
      json = { 'fixjson' },
      qml = { 'qmlformat' },
    },
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      local filepath = vim.api.nvim_buf_get_name(bufnr)
      if ignore_file(filepath) then
        return
      end
      return { timeout_ms = 500, lsp_fallback = true }
    end,
    formatters = {
      qmlformat = {
        command = '/usr/lib64/qt6/bin/qmlformat',
        args = { '--normalize', '$FILENAME' },
        stdin = false,
      },
    },
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
  config = function(_, opts)
    require('conform').setup(opts)

    command('FormatDisable', function(args)
      if args.bang then
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = 'Disable format on save',
      bang = true,
    })

    command('FormatEnable', function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = 'Enable format on save',
    })
  end,
}
