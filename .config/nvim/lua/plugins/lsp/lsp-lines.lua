return { 'https://git.sr.ht/~whynothugo/lsp_lines.nvim', enabled = false, config = function()

vim.diagnostic.config { virtual_lines = false }
require 'lsp_lines'.setup()
vim.diagnostic.config { virtual_lines = false }
require 'lsp_lines'.toggle()

end }
