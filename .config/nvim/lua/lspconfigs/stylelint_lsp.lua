-- stylelint_lsp
return {
  on_attach = function(client, bufnr)
    require 'lsp-format'.on_attach(client)
    require 'lsp-status'.on_attach(client)
    au('BufWritePre', {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format()
      end
    })
  end,
  filetypes = { 'css', 'scss', },
  settings = {
    stylelintplus = {
      autoFixOnFormat = true,
      cssInJs = false,
    },
  },
}
