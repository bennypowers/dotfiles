local function get_markdown_nodes(node)
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

au('InsertLeave', {
  group = ag('markdown_tables', {}),
  desc = 'Align markdown tables',
  callback = function()
    local crow, ccol = unpack(vim.api.nvim_win_get_cursor(0))
    local node = vim.treesitter.get_node()
    local tbl, paragraph = get_markdown_nodes(node)
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

