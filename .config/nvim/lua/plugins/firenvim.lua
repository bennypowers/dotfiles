-- 🔥 Browser Integration
--    here be 🐉 🐲
return { 'glacambre/firenvim',
  cond = vim.g.started_by_firenvim,
  build = function()
    vim.fn['firenvim#install'](0)
  end,
  init = function ()
    vim.g.auto_session_enabled = false
    vim.opt.laststatus = 0
    vim.opt.showtabline = 0
    vim.opt.guifont = 'FiraCode_Nerd_Font'
    au('BufEnter', {
      group = ag('firenvim_md', {}),
      pattern = 'github.com_*.txt',
      command = 'set filetype=markdown'
    })
  end
}

