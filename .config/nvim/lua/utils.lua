local M = {};

function M.pick_window()
  require 'nvim-window'.pick()
end

function M.open_diagnostics()
  vim.diagnostic.open_float {
    focus = false,
  }
end

function M.spectre_open()
  require 'spectre'.open()
end

function M.spectre_open_visual()
  require 'spectre'.open_visual { select_word = true }
end

function M.legendary_open()
  require 'legendary'.find()
end

function M.cycle_color()
  require 'color-converter'.cycle()
end

function M.goto_preview_definition()
  require 'goto-preview'.goto_preview_definition {}
end

function M.goto_preview_implementation()
  require 'goto-preview'.goto_preview_implementation {}
end

function M.goto_preview_references()
  require 'goto-preview'.goto_preview_references()
end

function M.close_all_win()
  require 'goto-preview'.close_all_win()
end

---@author kikito
---@see https://codereview.stackexchange.com/questions/268130/get-list-of-buffers-from-current-neovim-instance
function M.get_listed_buffers()
  local buffers = {}
  local len = 0
  for buffer = 1, vim.fn.bufnr('$') do
    if vim.fn.buflisted(buffer) == 1 then
      len = len + 1
      buffers[len] = buffer
    end
  end

  return buffers
end

function M.bufdelete(bufnum)
  require 'bufdelete'.bufdelete(bufnum, true)
  if #M.get_listed_buffers() == 1 and vim.api.nvim_buf_get_name(0) == '' then
    vim.cmd [[:Alpha]]
  end
end

local function open_uri(uri)
  if type(uri) ~= 'nil' then
    uri = string.gsub(uri, '#', '\\#') --double escapes any # signs
    uri = '"' .. uri .. '"'
    vim.cmd('!open ' .. uri .. ' > /dev/null')
    vim.cmd 'mode'
    -- print(uri)
    return true
  else
    return false
  end
end

--- @author Rafat913
--- https://www.reddit.com/r/neovim/comments/um3epn/comment/i8140hi/
function M.open_uri_under_cursor()
  local word_under_cursor = vim.fn.expand '<cWORD>'

  -- any uri with a protocol segment
  local regex_protocol_uri = '%a*:%/%/[%a%d%#%[%]%-%%+:;!$@/?&=_.,~*()]*'
  if open_uri(string.match(word_under_cursor, regex_protocol_uri)) then
    return
  end

  -- consider anything that looks like string/string a github link
  local regex_plugin_url = '[%a%d%-%.%_]*%/[%a%d%-%.%_]*'
  local match = string.match(word_under_cursor, regex_plugin_url)
  if match then
    if open_uri('https://github.com/' .. match) then
      return
    end
  end

  -- otherwise, open a new line above
  vim.api.nvim_feedkeys('O', 'n', false)
end

---Reload and compile the packer config
function M.refresh_packer()
  vim.notify('Refreshing Packer', 'info', { render = require 'notify.render.minimal' })
  vim.cmd [[ :source ~/.config/nvim/lua/plugins.lua ]]
  vim.cmd [[ PackerClean ]]
  vim.cmd [[ PackerCompile ]]
  vim.cmd [[ PackerClean ]]
  vim.cmd [[ :source ~/.config/nvim/plugin/packer_compiled.lua ]]
end

-- don't use this
function M.refresh_require_cache()
  local basic_packages = { "_G", "bit", "coroutine", "debug", "ffi", "io", "jit", "jit.opt", "luv", "math", "mpack", "os", "package", "plugins", "string", "table", }
  for k in pairs(package.loaded) do
    if not string.find(k, '^vim%.') and not vim.tbl_contains(basic_packages, k) then
      package.loaded[k] = nil
    end
  end
end

function M.refresh_init()
  -- refresh_require_cache()
  vim.notify('Refreshing init', 'info', { render = require 'notify.render.minimal' })
  vim.cmd [[ :source ~/.config/nvim/init.lua ]]
  M.refresh_packer()
end

return M
