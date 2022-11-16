ag = vim.api.nvim_create_augroup
au = vim.api.nvim_create_autocmd

---Reload and compile packer plugins when config changes
--
au('BufWritePost', {
  group = ag('packer_user_config', { clear = true }),
  pattern = {
    'plugins.lua',
    'init.lua',
    'lua/config/*.lua',
    'aucmds.lua',
    'catppuccin-nvim.lua',
  },
  callback = function(event)
    if event.match:match'plugins%.lua$' then
      vim.cmd.luafile(event.match)
    end
    require'packer'.compile()
  end
})

---Clean and reload packer plugins when compile finishes
--
au('User', {
  pattern = 'PackerCompileDone',
  callback = function()
    vim.notify('Compile done', vim.log.levels.INFO, { title = 'Packer' })
    require'packer'.clean()
    vim.cmd.source'~/.config/nvim/plugin/packer_compiled.lua'
  end,
})

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
