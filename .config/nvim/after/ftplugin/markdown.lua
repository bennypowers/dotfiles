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

local function get_all_link_references()
  local parser = vim.treesitter.get_parser(0, 'markdown')
  local query = vim.treesitter.query.get('markdown', 'link_reference_definitions')
  local refs = {}
  if query then
    for _, tree in ipairs(parser:parse()) do
      for _, node in query:iter_captures(tree:root(), 0) do
        local label_node, dest_node = unpack(node:named_children())
        if label_node and dest_node then
          local label = vim.treesitter.get_node_text(label_node, 0)
          local dest = vim.treesitter.get_node_text(dest_node, 0)
          table.insert(refs, { label, dest })
        end
      end
    end
  end
  return refs
end

---@param node TSNode
---@param replacement string
local function replace_node_text(node, replacement)
  local sr, sc, er, ec = vim.treesitter.get_node_range(node)
  vim.api.nvim_buf_set_text(
    0,
    sr,
    sc,
    er,
    ec,
    vim.split(replacement, '\n')
  )
end

---@param text string
local function append_text(text)
  vim.api.nvim_buf_set_lines(
    0,
    -1,
    -1,
    true,
    vim.split(text, '\n')
  )
end

command('MarkdownToggleLinkToRef', function(args)
  local parser = vim.treesitter.get_parser(0, 'markdown_inline')
  local query = vim.treesitter.query.get('markdown_inline', 'toggle_links_ref')
  local _line, col = unpack(vim.api.nvim_win_get_cursor(0))
  local row = _line - 1
  if not query then return end
  for _, tree in ipairs(parser:parse()) do
    for id, node in query:iter_captures(tree:root(), 0) do
      if vim.treesitter.is_in_node_range(node, row, col) then
        local name = query.captures[id]
        local text_node, ref_or_dest_node = unpack(node:named_children())
        if not text_node or not ref_or_dest_node then return end
        local text = vim.treesitter.get_node_text(text_node, 0)
        local ref_or_dest = vim.treesitter.get_node_text(ref_or_dest_node, 0)
        if name == 'inline' then
          local dest = ref_or_dest
          for _, tuple in ipairs(get_all_link_references()) do
            local referant_ref, referant_dest = unpack(tuple)
            if dest == referant_dest then
              replace_node_text(node, '['..text..']['..referant_ref..']')
            end
          end
          local new_ref = text:gsub('%W',''):lower()
          replace_node_text(node, '['..text..']['..new_ref..']')
          append_text('['..new_ref..']: '..dest)
        else
          local ref = ref_or_dest
          for _, tuple in ipairs(get_all_link_references()) do
            local referant_ref, referant_dest = unpack(tuple)
            if ref == referant_ref then
              replace_node_text(node, '['..text..']('..referant_dest..')')
            end
          end
        end
      end
    end
  end
end, { desc = 'Toggle Markdown links between reference links and inline' })

vim.keymap.set('n', 'gtl', ':MarkdownToggleLinkToRef<cr>', { desc = 'Toggle Markdown links between reference links and inline' })
