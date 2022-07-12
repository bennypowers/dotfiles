local U = require 'utils'

local ag = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

---Disable cursor column in help buffers
--
au({ 'BufEnter', 'BufWinEnter' }, {
  group = ag('help_options', { clear = true }),
  pattern = '*',
  callback = function()
    if vim.bo.filetype == 'help' then
      vim.wo.cursorcolumn = false
    end
  end
})

---Apply the 'jinja' file type to nunjucks files
--
au({ 'BufNewFile', 'BufRead' }, {
  group = ag('nunjucks_ft', { clear = true }),
  pattern = '*.njk',
  command = 'set ft=jinja',
})

---Clean and compile packer when `plugins.lua` or `init.lua` change
--
au('BufWritePost', {
  group = ag('packer_user_config', { clear = true }),
  pattern = { 'plugins.lua', 'init.lua', 'lua/config/*.lua' },
  callback = U.refresh_packer,
})

---Format on save, using only the clients with `autoFixOnSave` set
--
au('BufWritePre', {
  group = ag('LspFormatting', { clear = true }),
  pattern = '*',
  callback = function()
    vim.lsp.buf.format {
      timeout_ms = 2000,
      filter = function(c)
        return (c and c.config and c.config.settings and c.config.settings.autoFixOnSave) or false
      end,
    }
  end
})

---For reasons unclear to me, eslint ls doesn't autoFixOnSave, so execute `EslineFixAll` instead
--
au('BufWritePre', {
  group = ag('eslint-fixall', { clear = true }),
  pattern = { '*.tsx', '*.ts', '*.jsx', '*.js', },
  command = 'EslintFixAll',
})

---WORKAROUND
-- vim.opt.foldmethod     = 'expr'
-- vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
au({ 'BufEnter', 'BufAdd', 'BufNew', 'BufNewFile', 'BufWinEnter' }, {
  group = ag('TS_FOLD_WORKAROUND', {}),
  callback = function()
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr   = 'nvim_treesitter#foldexpr()'
  end
})
---ENDWORKAROUND

---Settings for catppuccin theme
--
au('ColorSchemePre', {
  pattern = 'catppuccin',
  callback = function()
    require 'catppuccin'.setup {
      transparent_background = true,
      integrations = {
        lsp_trouble = true,
        neotree = {
          enabled = true,
          show_root = true,
          transparent_panel = true,
        },
        which_key = true,
        indent_blankline = {
          enabled = true,
          colored_indent_levels = false,
        },
      }
    }
  end
})

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
    vim.cmd 'hi Normal guibg=transparent'
  end
})

-- au({ 'VimEnter', 'BufEnter' }, {
--   group = ag('illuminate_augroup', { clear = true }),
--   pattern = '*',
--   callback = function()
--     vim.cmd [[
--       hi illuminatedWord cterm=underline gui=underline guibg=transparent
--       hi! def link LspReferenceText DiagnosticUnderlineHint
--       hi! def link LspReferenceWrite DiagnosticUnderlineHint
--       hi! def link LspReferenceRead DiagnosticUnderlineHint
--     ]]
--   end
-- })
