local U = require 'utils'

vim.api.nvim_create_augroup('help_options', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  group = 'help_options',
  pattern = '*',
  callback = function()
    if vim.bo.filetype == 'help' then
      vim.wo.cursorcolumn = false
    end
  end
})

vim.api.nvim_create_augroup('nunjucks_ft', { clear = true })
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  group = 'nunjucks_ft',
  pattern = '*.njk',
  command = 'set ft=jinja',
})

vim.api.nvim_create_augroup('packer_user_config', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  group = 'packer_user_config',
  pattern = { 'plugins.lua', 'init.lua' },
  callback = U.refresh_packer,
})


vim.api.nvim_create_augroup('LspFormatting', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  group = 'LspFormatting',
  callback = function()
    vim.lsp.buf.format {
      timeout_ms = 2000,
      filter = function(clients)
        return vim.tbl_filter(function(client)
          return pcall(function(_client)
            return _client.config.settings.autoFixOnSave or false
          end, client) or false
        end, clients)
      end
    }
  end
})
