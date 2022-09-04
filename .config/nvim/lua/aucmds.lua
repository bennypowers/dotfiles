local ag = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

---Clean and compile packer when `plugins.lua` or `init.lua` change
--
au('BufWritePost', {
  group = ag('packer_user_config', { clear = true }),
  pattern = { 'plugins.lua', 'init.lua', 'lua/config/*.lua', 'aucmds.lua', 'catppuccin-nvim.lua' },
  command = 'PackerCompile',
})

-- Create an autocmd User PackerCompileDone to update it every time packer is compiled
au('User', {
  pattern = "PackerCompileDone",
  callback = function()
    vim.notify('Compile done', 'info', { title = 'Packer' })
    vim.cmd [[ PackerClean ]]
    vim.cmd [[ :source ~/.config/nvim/plugin/packer_compiled.lua ]]
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

---WORKAROUND
-- vim.opt.foldmethod     = 'expr'
-- vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
-- au({ 'BufEnter', 'BufAdd', 'BufNew', 'BufNewFile', 'BufWinEnter' }, {
--   group = ag('TS_FOLD_WORKAROUND', {}),
--   callback = function()
--     vim.opt.foldmethod = 'expr'
--     vim.opt.foldexpr   = 'nvim_treesitter#foldexpr()'
--   end
-- })
---ENDWORKAROUND

---Settings for tokyonight theme
--
au('ColorSchemePre', {
  pattern = 'tokyonight',
  callback = function()
    local colors = require 'tokyonight.colors'.setup {}
    local util = require 'tokyonight.util'
    vim.g.tokyonight_style = 'night'
    vim.g.tokyonight_transparent = true
    vim.g.tokyonight_lualine_bold = true
    vim.g.tokyonight_colors = {
      bg_highlight = util.blend(colors.bg_highlight, '#000000', 0.5),
    }
    vim.cmd.hi('Normal', {guibg='transparent'})
  end
})

