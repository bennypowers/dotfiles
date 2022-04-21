return function()
  require'nvim-biscuits'.setup {
    show_on_start = true,
    default_config = {
      max_length = 12,
      min_distance = 5,
      prefix_string = " 📎 "
    },
    language_config = {
      html = {
        prefix_string = " 🌐 "
      },
      javascript = {
        prefix_string = " ✨ ",
        max_length = 80
      },
      python = {
        disabled = true
      }
    }
  }
end
