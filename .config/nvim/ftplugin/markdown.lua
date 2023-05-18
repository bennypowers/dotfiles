local function get_table_and_paragraph_nodes(node)
  local tbl, paragraph
  while node do
    if node:type() == 'pipe_table' then
      tbl = node
    elseif node:type() == 'paragraph' then
      paragraph = node
    end
    node = node:parent()
  end
  return tbl, paragraph
end

local get_node_text = vim.treesitter.get_node_text

au('InsertLeave', {
  group = ag('markdown_tables', {}),
  desc = 'Align markdown tables',
  callback = function()
    local crow, ccol = unpack(vim.api.nvim_win_get_cursor(0))
    local node = vim.treesitter.get_node()
    local tbl, paragraph = get_table_and_paragraph_nodes(node)
    if tbl then
      local s, _, e = tbl:range()
      local rstart = s + 1
      local rend = e + 1
      local range = rstart .. ',' .. rend
      local delim = rstart + 1
      -- trim trailing spaces from table cells
      vim.cmd(range .. [[s/ \{1,}|/ |/g]])
      -- trim delimiter row to `---`
      vim.cmd(delim .. [[s/| \{1,}-\{3,} \{1,}/| --- /g]])
      -- use vim lion to align table, but delimiter row will be mostly spaces
      vim.cmd.normal'glip|'
      -- fill in delimiter row with `---`
      vim.cmd(delim .. 's/ /-/g')
      vim.cmd(delim .. 's/|-/| /g')
      vim.cmd(delim .. 's/-|/ |/g')
    elseif paragraph then
      vim.cmd.normal'gqap'
    end
    vim.api.nvim_win_set_cursor(0, { crow, ccol + 1 })
  end
})

command('MarkdownToggleImage', function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local parser = vim.treesitter.get_parser(0, 'markdown')
  local langtree = parser:language_for_range({ row, col, row, col })
  local caps = {}
  langtree:for_each_tree(function(tree, ltree)
    ltree:parse()
    local lang = ltree:lang();
    local query = vim.treesitter.query.get(lang, 'images')
    if query then
      for id, node in query:iter_captures(tree:root(), 0, row - 1, row) do
        local cap = query.captures[id]
        if cap == 'image' then
          caps.node = node
        elseif cap == '_attr' then
          local name, value
          for child in node:iter_children() do
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
          if name == 'src' or name == 'alt' then
            caps[name] = value
          end
        elseif not cap:starts'_' then
          local split = vim.split(cap, '.', { plain = true, trimempty = true })
          local name = split[#split]
          caps[name] = get_node_text(node, 0)
        end
      end
    end
  end)
  if caps.node then
    local type = caps.node:type()
    local tag
    if type:match'tag$' then
      tag = '![' ..caps.alt .. '](' .. caps.src .. ')'
    elseif type == 'image' then
      tag = '<img alt="'..caps.alt .. '" src="' .. caps.src .. '">'
    else
      return
    end
    local start_row, start_col, end_row, end_col = vim.treesitter.get_node_range(caps.node)
    vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, { tag })
  end
end, { desc = 'Toggle Markdown image syntax' })
