local function make_bind ()
  return ":IncRename " .. vim.fn.expand("<cword>")
end

return { 'smjonas/inc-rename.nvim',
  enabled = true,
  dependencies = 'neovim/nvim-lspconfig',
  keys = {
    { '<leader>rn', ':IncRename ', desc = 'Rename (Incrementally)' },
    { '<leader>rN', make_bind, desc = 'Rename (Incrementally) with word', expr = true },
  },
  opts = {},
}
