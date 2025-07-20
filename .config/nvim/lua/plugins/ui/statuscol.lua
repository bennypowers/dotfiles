return { 'luukvbaal/statuscol.nvim',
  enabled = false,
  cond = vim.fn.exists'&statuscolumn' == 1,
  config = function()
    local builtin = require'statuscol.builtin'
    require'statuscol'.setup {
      setopt = true,
      relculright = true,
      segments = {
        { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
        { text = { '%s' }, click = 'v:lua.ScSa' },
        { text = { builtin.lnumfunc }, click = 'v:lua.ScLa' },
      },
    }
  end,
}
