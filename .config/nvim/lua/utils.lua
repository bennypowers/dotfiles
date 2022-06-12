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

function M.format_hsl()
  require 'color-converter'.to_hsl()
  vim.cmd [[:s/%//g<cr>]]
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

function M.get_listed_buffers()
  ---@author akinsho
  ---@see bufferline.nvim
  return vim.tbl_filter(function(bufnr)
    if not bufnr or bufnr < 1 then
      return false
    end
    local exists = vim.api.nvim_buf_is_valid(bufnr)
    return vim.bo[bufnr].buflisted and exists
  end, vim.api.nvim_list_bufs())
end

---Whether any non-empty buffers are open. Non-empty buffers are listed and have file contents.
---@param exclude_bufnr? number bufnr to ignore
---@return boolean
function M.has_non_empty_buffers(exclude_bufnr)
  for _, bufnr in ipairs(M.get_listed_buffers()) do
    local name = vim.api.nvim_buf_get_name(bufnr)
    local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
    if (exclude_bufnr and bufnr ~= exclude_bufnr) and (name ~= '') and (ft ~= 'Alpha') then
      return true
    end
  end
  return false
end

function M.bufdelete(bufnum)
  require 'bufdelete'.bufdelete(bufnum, true)
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

local function get_selected_text()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg('v')
  vim.fn.setreg('v', {})
  text = string.gsub(text, "\n", "")
  if string.len(text) == 0 then
    text = nil
  end
  return text
end

function M.find_selection()
  require 'telescope.builtin'.live_grep {
    default_text = get_selected_text()
  }
end

---Is there an active neovim_session_manager session in the cwd?
--
function M.is_in_active_session()
  local session_manager = require 'session_manager.utils'
  local session_name = session_manager.get_last_session_filename()
  local session_dir = session_manager.session_filename_to_dir(session_name)
  local cwd = vim.fn.getcwd()
  return session_dir == cwd
end

return M
