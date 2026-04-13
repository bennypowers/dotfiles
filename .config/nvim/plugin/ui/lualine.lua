local u = require'utils'
local au = vim.api.nvim_create_autocmd

-- pretty statusline
u.pack 'nvim-lualine/lualine.nvim'

local progress = {}

local lsp_icons = {
  lua_ls           = '󰢱',
  gopls            = '',
  rust_analyzer    = '🦀',
  vtsls            = '',
  denols           = '🦕',
  eslint           = '󰱺',
  cssls            = '',
  html             = '',
  jsonls           = '',
  yamlls           = '',
  bashls           = '',
  fish_lsp         = '󰈺',
  marksman         = '',
  emmet_language_server = '󰀀',
  stylelint_lsp    = '',
  hyprls           = '',
  qmlls            = '',
  asimonim         = '󰜗',
  cem              = '󰜗',
  golangci_lint_langserver = '',
}

au('LspProgress', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then return end
    local value = ev.data.params.value
    if value.kind == 'end' then
      progress[client.name] = nil
    else
      progress[client.name] = {
        title = value.title or '',
        percentage = value.percentage,
      }
    end
  end,
})

require 'lualine'.setup {
  theme = 'auto',
  extentions = {},
  options = {
    disabled_filetypes = {},
    globalstatus = true,
    refresh = {
      statusline = 200,
      events = { 'WinEnter', 'BufEnter', 'LspProgress' },
    },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename', function()
      local s = ''
      for name, info in pairs(progress) do
        if s ~= '' then s = s .. '  ' end
        local icon = lsp_icons[name] or '󰒍'
        s = s .. icon .. ' ' .. info.title
        if info.percentage then s = s .. ' ' .. info.percentage .. '%%' end
      end
      return s
    end },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
}
