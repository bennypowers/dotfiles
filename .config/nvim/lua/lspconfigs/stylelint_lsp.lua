-- stylelint_lsp
return {
  on_attach = function(client, bufnr)
    require 'lsp-format'.on_attach(client, bufnr)
    require 'lsp-status'.on_attach(client, bufnr)
  end,
  filetypes = { 'css', 'scss', },
  settings = {
    stylelintplus = {
      autoFixOnFormat = true,
      cssInJs = false,
    },
  },
}
