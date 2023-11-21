return { '0x100101/lab.nvim',
  enabled = false,
  dependencies = { 'nvim-lua/plenary.nvim' },
  build = 'cd js && npm ci',
  opts = {
    code_runner = {
      enabled = true,
    },
  }
}
