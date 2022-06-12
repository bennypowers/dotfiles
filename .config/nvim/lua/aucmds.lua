local U = require 'utils'

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

---Disable cursor column in help buffers
--
autocmd({ 'BufEnter', 'BufWinEnter' }, {
  group = augroup('help_options', { clear = true }),
  pattern = '*',
  callback = function()
    if vim.bo.filetype == 'help' then
      vim.wo.cursorcolumn = false
    end
  end
})

---Apply the 'jinja' file type to nunjucks files
--
autocmd({ 'BufNewFile', 'BufRead' }, {
  group = augroup('nunjucks_ft', { clear = true }),
  pattern = '*.njk',
  command = 'set ft=jinja',
})

---Clean and compile packer when `plugins.lua` or `init.lua` change
--
autocmd('BufWritePost', {
  group = augroup('packer_user_config', { clear = true }),
  pattern = { 'plugins.lua', 'init.lua', 'lua/config/*.lua' },
  callback = U.refresh_packer,
})


---Format on save, using only the clients with `autoFixOnSave` set
--
autocmd('BufWritePre', {
  group = augroup('LspFormatting', { clear = true }),
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
autocmd('BufWritePre', {
  group = augroup('eslint-fixall', { clear = true }),
  pattern = { '*.tsx', '*.ts', '*.jsx', '*.js', },
  command = 'EslintFixAll',
})

---Any time a buffer closes, when there are no more active buffers, Launch Alpha
--
autocmd('User', {
  pattern = 'BDeletePre',
  group = augroup('alpha_on_empty', { clear = true }),
  callback = function(event)
    if not U.has_non_empty_buffers(event.buf) then
      vim.cmd [[ :Alpha ]]
    end
  end,
})

---Launch alpha if vim starts with only empty buffers
--
autocmd('VimEnter', {
  group = augroup('alpha_on_startup', { clear = false }),
  pattern = '*',
  callback = function()
    if not (U.has_non_empty_buffers() or U.is_in_active_session()) then
      vim.cmd [[ :Alpha ]]
    end
  end
})
