-- stylelint_lsp
return {
  on_attach = function(client)
    require 'lsp-format'.on_attach(client)
    require 'lsp-status'.on_attach(client)
  end,
  filetypes = { 'css', 'scss', },
  settings = {
    stylelintplus = {
      autoFixOnSave = true,
      autoFixOnFormat = true,
      cssInJs = false,
    },
  },
}
