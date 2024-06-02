local function biscuits_toggle()
  require 'nvim-biscuits'.toggle_biscuits()
end

-- hints for block ends
return { 'code-biscuits/nvim-biscuits',
  enabled = true,
  lazy = true,
  keys = {
    { '<leader>cb', biscuits_toggle, desc = 'Toggle code biscuits' },
  },
  opts = {
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
  },
}
