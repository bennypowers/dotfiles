vim.opt.formatoptions = 'cqw'
vim.opt.textwidth = 80
vim.opt.wrapmargin = 0
vim.opt.softtabstop = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.colorcolumn = '80'
vim.api.nvim_set_hl(0, 'MiniTrailspace', {
  bg = '#333333'
})

local function get_markdown_nodes(nodetype)
  return function(node)
    local needle
    while node and not needle do
      if node:type() == nodetype then
        needle = node
      else
        node = node:parent()
      end
    end
    return needle
  end
end

local get_table_nodes = get_markdown_nodes'pipe_table'
local get_paragraph_nodes = get_markdown_nodes'paragraph'

local function is_shortcode(node)
  return vim.startswith(vim.trim(vim.treesitter.get_node_text(node, 0)), '{%')
end

local md_aucmd_group = ag('markdown_autoformat', {})

au('InsertLeave', {
  group = md_aucmd_group,
  pattern = {'*.md', '*.njk', '*.webc', '*.html'},
  desc = 'Align markdown tables',
  callback = function()
    local crow, ccol = unpack(vim.api.nvim_win_get_cursor(0))
    local node = vim.treesitter.get_node()
    local tbl = get_table_nodes(node)
    if tbl then
      local s, _, e = tbl:range()
      local rstart = s + 1
      local rend = e + 1
      local range = rstart .. ',' .. rend
      local delim = rstart + 1
      -- trim trailing spaces from table cells
      vim.cmd(range .. [[s/ \{1,}|/ |/g]])
      -- trim delimiter row to `---`
      vim.cmd(delim .. [[s/|\( \{-}\)\{1,}-\{3,}\( \{-}\)\{1,}/| --- /g]])
      -- use vim lion to align table, but delimiter row will be mostly spaces
      vim.cmd.normal'glip|'
      -- fill in delimiter row with `---`
      vim.cmd(delim .. 's/ /-/g')
      vim.cmd(delim .. 's/|-/| /g')
      vim.cmd(delim .. 's/-|/ |/g')
      vim.api.nvim_win_set_cursor(0, { crow, ccol + 1 })
    end
  end
})

-- au('InsertLeave', {
--   group = md_aucmd_group,
--   desc = 'Hardwrap markdown paragraphs',
--   callback = function()
--     local node = vim.treesitter.get_node()
--     local paragraph = get_paragraph_nodes(node)
--     if paragraph and not is_shortcode(node) then
--       vim.cmd.normal'gqap'
--     end
--   end
-- })

command('MarkdownToggleImage', require'commands'.toggle_markdown_image, {
  desc = 'Toggle Markdown image syntax',
})
command('MarkdownToggleLink', require'commands'.toggle_markdown_link, {
  desc = 'Toggle Markdown link syntax',
})
