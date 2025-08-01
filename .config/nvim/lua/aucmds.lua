au('BufEnter', {
  group = ag('waybar_config', {}),
  pattern = 'config',
  callback = function(event)
    if event.match == vim.fn.expand '~/.config/waybar/config' then
      vim.bo.filetype = 'json'
    end
  end
})

---Settings for various themes which don't have setup functions
--
-- au('ColorScheme', {
--   callback = function(event)
--     if (event.match == 'tokyonight'
--           or event.match == 'noctis'
--         ) then
--       vim.cmd.hi('Normal', "guibg='transparent'")
--     end
--   end
-- })

---Highlight yanked text
--
au('TextYankPost', {
  group = ag('yank_highlight', {}),
  pattern = '*',
  callback = function()
    vim.highlight.on_yank { higroup = 'IncSearch', timeout = 300 }
  end,
})

-- Only setup gnvim when it attaches.
au('UIEnter', {
  callback = function()
    local chanid = vim.v.event.chan
    if chanid then
      local chan = vim.api.nvim_get_chan_info(chanid)
      if chan.client and chan.client.name == 'gnvim' then
        -- Gnvim brings its own runtime files.
        local gnvim = require 'gnvim'

        -- Set the font
        vim.opt.guifont = 'FiraCode Nerd Font 13'

        -- Increase/decrease font.
        vim.keymap.set('n', '<c-+>', function() gnvim.font_size(1) end)
        vim.keymap.set('n', '<c-->', function() gnvim.font_size(-1) end)

        gnvim.setup {
          cursor = {
            blink_transition = 300
          }
        }
      end
    end
  end
})

au('OptionSet', {
  group = ag('auto_dark_light', { clear = true }),
  pattern = 'background',
  callback = function()
    local colors = require 'catppuccin.palettes'.get_palette()
    local blend = require 'catppuccin.utils.colors'.blend
    vim.api.nvim_set_hl(0, 'DiagnosticErrorLine', { bg = blend(colors.red, colors.surface0, 0.2) })
    vim.api.nvim_set_hl(0, 'DiagnosticWarningLine', { bg = blend(colors.yellow, colors.surface0, 0.2) })
  end
})

au('LspAttach', {
  callback = function(args)
    if vim.lsp.document_color then
      vim.lsp.document_color.enable(true, args.buf, {
        style = 'virtual'
      })
    end
  end
})
