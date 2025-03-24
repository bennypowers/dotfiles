au('BufEnter', {
  group = ag('waybar_config', {}),
  pattern = 'config',
  callback = function(event)
    if event.match == vim.fn.expand('~/.config/waybar/config') then
      vim.bo.filetype = 'json'
    end
  end
})

---Settings for various themes which don't have setup functions
--
au('ColorSchemePre', {
  callback = function(event)
    if event.match == 'tokyonight' then
      local colors = require 'tokyonight.colors'.setup {}
      local util = require 'tokyonight.util'
      vim.g.tokyonight_style = 'night'
      vim.g.tokyonight_transparent = true
      vim.g.tokyonight_lualine_bold = true
      vim.g.tokyonight_colors = {
        bg_highlight = util.blend(colors.bg_highlight, '#000000', 0.5),
      }
    elseif event.match == 'oxocarbon-lua' then
      vim.g.oxocarbon_lua_transparent = true
    end
  end
})

---Settings for various themes which don't have setup functions
--
au('ColorScheme', {
  callback = function(event)
    if ( event.match == 'tokyonight'
      or event.match == 'noctis'
    ) then
      vim.cmd.hi('Normal', "guibg='transparent'")
    end
  end
})

---Highlight yanked text
--
au('TextYankPost', {
  group = ag('yank_highlight', {}),
  pattern = '*',
  callback = function()
    vim.highlight.on_yank { higroup='IncSearch', timeout=300 }
  end,
})

-- Only setup gnvim when it attaches.
au('UIEnter', {
  callback = function()
    local chanid = vim.v.event.chan
    print (chanid)
    local chan = vim.api.nvim_get_chan_info(chanid)
    if chan.client and chan.client.name == 'gnvim' then
      -- Gnvim brings its own runtime files.
      local gnvim = require'gnvim'

      -- Set the font
      vim.opt.guifont = 'FiraCode Nerd Font 13'

      -- Increase/decrease font.
      vim.keymap.set('n', '<c-+>', function() gnvim.font_size(1) end)
      vim.keymap.set('n', '<c-->', function() gnvim.font_size(-1) end)

      gnvim.setup({
          cursor = {
              blink_transition = 300
          }
      })
    end
  end
})

au('OptionSet', {
  group = ag('auto_dark_light', {clear=true}),
  pattern = 'background',
  callback = function(data)
    -- print(vim.inspect(data))
    -- if vim.o.background == 'dark' then
    --   vim.cmd.colorscheme'catppuccin-mocha'
    -- else
    --   vim.cmd.colorscheme'catppuccin-latte'
    -- end
  end
})

