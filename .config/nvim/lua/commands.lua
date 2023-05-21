command('ClearNotifications', function()
  local has_notify, notify = pcall(require, 'notify')
  if has_notify then
    notify.dismiss { silent = true }
  elseif pcall(require, 'notifier') then
    vim.cmd[[:NotifierClear]]
  elseif pcall(require, 'noice') then
    vim.cmd[[:Noice dismiss]]
  end
  vim.cmd[[nohlsearch|diffupdate|normal! <C-L><CR>]]
end, {
  bang = true,
})

command('HighlightRepeats', function(args)
  local line_counts = {}
  local first = args.line1
  local last = args.line2
  if first == last then
    first = 1
    last = vim.api.nvim_buf_line_count(0)
  end
  vim.notify(vim.inspect { first, last })
  local line_num = first
  while line_num <= last do
    local line_text = vim.fn.getline(line_num)
    if #line_text > 0 then
      line_counts[line_text] = (line_counts[line_text] or 1) + 1
    end
    line_num = line_num + 1
  end
  vim.fn.execute('syn clear Repeat')
  for line_text, amt in pairs(line_counts) do
    if amt >= 2 then
      local escaped = vim.fn.escape(line_text, [[".\^%*[]])
      local command = 'syn match Repeat "^' .. escaped .. '$"'
      vim.notify(vim.inspect {
        line_text = line_text,
        escaped = escaped,
        command = command,
      })
      vim.fn.execute(command)
    end
  end
end, {
  bang = true,
  range = '%'
})

local get_node_text = vim.treesitter.get_node_text

local function replace_node_text(node, replacement)
  local srow, scol, erow, ecol = vim.treesitter.get_node_range(node)
  vim.api.nvim_buf_set_text(0, srow, scol, erow, ecol, { replacement })
end

local function get_image_html(row, root)
  local query = vim.treesitter.query.get('html', 'images')
  if not query then return end
  local node
  local alt
  local src
  for id, _node in query:iter_captures(root, 0, row, row + 1) do
    local cap = query.captures[id]
    if cap == 'image.html' then
      node = _node
    elseif cap == 'image.html.attr' then
      local name, value
      for child in _node:iter_children() do
        local text = get_node_text(child, 0);
        local type = child:type()
        if type == 'attribute_name' then
          name = text
        elseif type == 'attribute_value' then
          value = text
        elseif type == 'quoted_attribute_value' then
          value = text:gsub('^[\'|"](.*)[\'|"]$', '%1')
        end
      end
      if name == 'alt' then
        alt = value
      elseif name == 'src' then
        src = value
      end
    end
  end
  return node, alt, src
end

local function get_image_md(row, root)
  local query = vim.treesitter.query.get('markdown_inline', 'images')
  if not query then return end
  local node
  local alt
  local src
  for id, _node in query:iter_captures(root, 0, row, row + 1) do
    local cap = query.captures[id]
    if cap == 'image.markdown' then
      node = _node
    elseif cap == 'image.markdown.alt' then
      alt = get_node_text(_node, 0)
    elseif cap == 'image.markdown.src' then
      src = get_node_text(_node, 0)
    end
  end
  return node, alt, src
end

local function html_to_md(row, root)
  local node, alt, src = get_image_html(row, root)
  if node then
    replace_node_text(node, ('![%s](%s)'):format(alt, src))
  end
end

local function md_to_html(row, root)
  local node, alt, src = get_image_md(row, root)
  if node then
    replace_node_text(node, ('<img alt="%s" src="%s">'):format(alt, src))
  end
end

local M = {}

function M.toggle_markdown_image()
  local ts_utils = require'nvim-treesitter.ts_utils';
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local root, _, langtree = ts_utils.get_root_for_position(row - 1, col)
  local lang = langtree:lang()
  if lang == 'html' then
    return html_to_md(row - 1, root)
  elseif lang == 'markdown_inline' then
    return md_to_html(row - 1, root)
  end
end

return M

