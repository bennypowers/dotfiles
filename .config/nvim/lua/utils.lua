local M = {};

local open_cmd = vim.fn.has('macunix') == '0' and 'open' or 'xdg-open'

local function open_uri(uri)
  if type(uri) ~= 'nil' then
    vim.notify(open_cmd)
    uri = string.gsub(uri, '#', '\\#') --double escapes any # signs
    uri = '"' .. uri .. '"'
    vim.cmd('!' .. open_cmd .. ' ' .. uri .. ' > /dev/null')
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


--- Most Recently Used files
--- @param start number
--- @param items_number number optional number of items to generate, default = 10
--- @param cwd string optional
function M.mru(start, items_number, cwd, opts)
  local cont, path = pcall(require,'plenary.path')
  if not cont then return {} end

  opts = opts or {
    ignore = function(filepath, ext)
      return (string.find(filepath, "COMMIT_EDITMSG")) or (vim.tbl_contains({ "gitcommit" }, ext))
    end,
  }

  items_number = items_number or 9

  local oldfiles = {}
  for _, v in pairs(vim.v.oldfiles) do
    if #oldfiles == items_number then
      break
    end
    local cwd_cond
    if not cwd then
      cwd_cond = true
    else
      cwd_cond = vim.startswith(v, cwd)
    end
    local ignore_ext = ''
    local match = v:match'^.+(%..+)$' if match then ignore_ext = match:sub(2) end
    local ignore = (opts.ignore and opts.ignore(v, ignore_ext)) or false
    if (vim.fn.filereadable(v) == 1) and cwd_cond and not ignore then
      oldfiles[#oldfiles + 1] = v
    end
  end

  local special_shortcuts = { 'a', 's', 'd' }
  local target_width = 35

  local tbl = {}
  for i, file_name in ipairs(oldfiles) do
    local short_file_name
    if cwd then
      short_file_name = vim.fn.fnamemodify(file_name, ":.")
    else
      short_file_name = vim.fn.fnamemodify(file_name, ":~")
    end

    if (#short_file_name > target_width) then
      short_file_name = path.new(short_file_name):shorten(1, { -2, -1 })
      if (#short_file_name > target_width) then
        short_file_name = path.new(short_file_name):shorten(1, { -1 })
      end
    end

    local shortcut = ""
    if i <= #special_shortcuts then
      shortcut = special_shortcuts[i]
    else
      shortcut = tostring(i + start - 1 - #special_shortcuts)
    end

    tbl[i] = { file_name, " " .. shortcut, short_file_name }
  end

  return tbl
end


return M
