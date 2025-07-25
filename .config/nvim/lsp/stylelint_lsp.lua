local cfg = require 'lsp'

---stylelint language server
---@type vim.lsp.ClientConfig
return {
  cmd = { 'stylelint-lsp', '--stdio' },
  filetypes = {
    'css',
    'less',
    'scss',
    'sugarss',
    'vue',
    'wxss',
  },
  root_dir = cfg.required_root_markers{
    '.stylelintrc',
    '.stylelintrc.cjs',
    '.stylelintrc.js',
    '.stylelintrc.json',
    '.stylelintrc.yaml',
    '.stylelintrc.yml',
    'stylelint.config.cjs',
    'stylelint.config.js',
  },
  settings = {
    stylelintplus = {
      autoFixOnFormat = true,
      autoFixOnSave = true,
      cssInJs = false,
    },
  },
}
