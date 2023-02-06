ag = vim.api.nvim_create_augroup
au = vim.api.nvim_create_autocmd

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

