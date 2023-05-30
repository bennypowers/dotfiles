return { 'rmagatti/gx-extended.nvim',
  -- dev = true,
  keys = { 'gx' },
  opts = {
    open_fn = require'lazy.util'.open,
    extensions = {
      {
        patterns = { '*/plugins/**/*.lua' },
        match_to_url = function(line_string)
          local line = string.match(line_string, '["|\'].*/.*["|\']')
          local repo = vim.split(line, ':')[1]:gsub('["|\']', '')
          local url = 'https://github.com/' .. repo
          return (line and repo) and url or nil
        end,
      }
    }
  }
}

