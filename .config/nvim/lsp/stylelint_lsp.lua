local u = require'utils'

---stylelint language server
---@type vim.lsp.ClientConfig
return {
  cmd = { 'stylelint-lsp', '--stdio' },
  filetypes = {
    'css',
    'less',
    'scss',
    'vue',
  },
  ---@diagnostic disable-next-line: assign-type-mismatch
  root_dir = u.required_root_markers{
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
