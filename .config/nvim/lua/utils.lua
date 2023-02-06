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

return M
