require 'nvim-biscuits'.setup {
  show_on_start = true,
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
  }
}
