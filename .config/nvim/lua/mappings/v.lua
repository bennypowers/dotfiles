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

local function find_selection()
  require 'telescope.builtin'.live_grep {
    default_text = get_selected_text()
  }
end

return {
  F  = { find_selection, 'Find selection in project' },
  fg = { find_selection, 'Find selection in project' },

  ['<leader>'] = {
    ['<c-d>'] = { '<Plug>(VM-Find-Subword-Under)<cr>', 'Find occurrence of subword under cursor' },
  }
}
