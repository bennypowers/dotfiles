-- pretty notifications
return { 'rcarriga/nvim-notify',
  enabled = false,
  config = function()
    local notify = require 'notify'

    notify.setup {
      background_colour = '#000000',
      -- render = 'minimal'
    }

    vim.notify = notify

    pcall(function()
      require 'telescope'.load_extension 'notify'
    end)

  end,
}
