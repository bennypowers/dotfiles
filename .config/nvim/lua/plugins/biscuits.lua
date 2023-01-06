-- hints for block ends
return { 'code-biscuits/nvim-biscuits', config = function ()
  local biscuits = require 'nvim-biscuits'
  biscuits.setup {
    show_on_start = true,
    cursor_line_only = true,
    on_events = { 'InsertLeave', 'CursorHoldI' },
    default_config = {
      max_length = 12,
      min_distance = 5,
      prefix_string = " 📎 "
    },
    language_config = {
      html = {
        prefix_string = " 🌐 "
      },
    },
  }

  biscuits.toggle_biscuits()
end }
