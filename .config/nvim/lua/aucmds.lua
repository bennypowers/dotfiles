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
      filter = function(c)
        return (c and c.config and c.config.settings and c.config.settings.autoFixOnSave) or false
      end,
    }
  end
})

vim.api.nvim_create_augroup('alpha_on_empty', { clear = true })
vim.api.nvim_create_autocmd('User', {
  pattern = 'BDeletePre',
  group = 'alpha_on_empty',
  callback = function(event)
    local found_non_empty_buffer = false
    local buffers = U.get_listed_buffers()

    for _, bufnr in ipairs(buffers) do
      if not found_non_empty_buffer then
        local name = vim.api.nvim_buf_get_name(bufnr)
        local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')

        if bufnr ~= event.buf and name ~= '' and ft ~= 'Alpha' then
          found_non_empty_buffer = true
        end
      end
    end

    if not found_non_empty_buffer then
      require 'neo-tree'.close_all()
      vim.cmd [[:Alpha]]
    end
  end,
})
