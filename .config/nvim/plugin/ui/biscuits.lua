local u = require'utils'

-- hints for block ends
u.pack 'code-biscuits/nvim-biscuits'

local biscuits = require 'nvim-biscuits'

biscuits.setup {
  show_on_start = true,
  cursor_line_only = true,
  on_events = { 'InsertLeave', 'CursorHoldI' },
  default_config = {
    max_length = 12,
    min_distance = 5,
    prefix_string = ' 📎 '
  },
  language_config = {
    html = {
      prefix_string = ' 🌐 '
    },
  },
}

u.nmap('<leader>cb', biscuits.toggle_biscuits, 'Toggle code biscuits')
