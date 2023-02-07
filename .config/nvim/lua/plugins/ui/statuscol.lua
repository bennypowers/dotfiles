return { 'luukvbaal/statuscol.nvim',
  cond = vim.fn.has'statuscol' == 1,
  opts = {
    foldfunc = 'builtin',
    setopt = true,
  },
}
