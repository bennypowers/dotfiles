return { 'bennypowers/nvim-regexplainer',
  enabled = true,
  dev = true,
  ft = { 'javascript', 'typescript', 'html', 'python', 'jinja' },
  dependencies = {
    'MunifTanjim/nui.nvim',
    'edluffy/hologram.nvim'
  },
  opts = {
    -- test authoring mode
    -- display = 'split',
    -- debug = true,
    -- mode = 'narrative',

    auto = true,
    display = 'popup',
    -- display = 'split',
    debug = true,
    mode = 'narrative',
    -- mode = 'debug',
    -- mode = 'railroad',

    -- narrative = {
    --   indentation_string = '> '
    -- },

  },
}
