local FP = require'fp'

local basename = vim.fs.basename
local function remove_extension(filename) return filename:gsub('%.lua$', '') end
local function glob(pat) return vim.fn.glob(pat, true, true) end

local get_servers = FP.pipe(glob, FP.reduce(function (configs, path)
  local file = basename(path)
  if file ~= 'init.lua' then
    local name = remove_extension(file)
    configs[name] = 'lspconfigs.'..name
  end
  return configs
end, {}))

return get_servers'~/.config/nvim/lua/lspconfigs/*.lua'

