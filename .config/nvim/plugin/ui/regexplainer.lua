local u = require'utils'
local au = vim.api.nvim_create_autocmd

au('FileType', {
  pattern = { 'javascript', 'typescript', 'html', 'python', 'jinja' },
  callback = function()
    u.pack(
      'MunifTanjim/nui.nvim',
      'edluffy/hologram.nvim',
      'bennypowers/nvim-regexplainer'
    )

    require'regexplainer'.setup {
      auto = true,
      display = 'popup',
      debug = false,
      mode = 'graphical',
    }
  end
});
