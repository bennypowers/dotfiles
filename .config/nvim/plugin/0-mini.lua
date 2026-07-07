local u = require'utils'

u.pack 'echasnovski/mini.nvim'

local function apply_lsp_highlights()
  local hi = vim.api.nvim_set_hl
  -- Let treesitter's more granular highlights show through
  hi(0, '@lsp.mod.defaultLibrary.lua', { link = 'Special' })
  hi(0, '@lsp.typemod.function.defaultLibrary.lua', { link = 'Special' })
end

local function apply_html_highlights(palette)
  local hi = vim.api.nvim_set_hl
  hi(0, '@tag.html', { fg = palette.base08 })
  hi(0, '@tag.attribute.html', { fg = palette.base09 })
  hi(0, '@tag.delimiter.html', { fg = palette.base04 })
  hi(0, '@operator.html', { fg = palette.base04 })
end

local function clear_column_backgrounds()
  local hi = vim.api.nvim_set_hl
  for _, group in ipairs {
    'SignColumn', 'FoldColumn', 'LineNr', 'LineNrAbove', 'LineNrBelow', 'CursorLineNr',
    'Folded',
    'DiagnosticSignError', 'DiagnosticSignWarn', 'DiagnosticSignInfo', 'DiagnosticSignHint', 'DiagnosticSignOk',
    'DiagnosticFloatingError', 'DiagnosticFloatingWarn', 'DiagnosticFloatingInfo', 'DiagnosticFloatingHint', 'DiagnosticFloatingOk',
    'GitSignsAdd', 'GitSignsChange', 'GitSignsDelete', 'GitSignsUntracked',
    'MiniDiffSignAdd', 'MiniDiffSignChange', 'MiniDiffSignDelete',
  } do
    local hl = vim.api.nvim_get_hl(0, { name = group })
    if hl.link then
      hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    end
    hl.bg = nil
    hl.ctermbg = nil
    hi(0, group, hl)
  end
end

local function apply_theme()
  local ok, palette = pcall(require, 'matugen')
  if ok then
    require 'mini.base16'.setup { palette = palette }
  end
  apply_lsp_highlights()
  if ok then
    apply_html_highlights(palette)
  end
  clear_column_backgrounds()
end

-- Register SIGUSR1 handler for dynamic updates
local signal = vim.uv.new_signal()
if signal then
  signal:start('sigusr1', vim.schedule_wrap(function()
    package.loaded['matugen'] = nil
    apply_theme()
  end))
end

-- Apply theme on startup
apply_theme()
