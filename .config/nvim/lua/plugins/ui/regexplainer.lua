return {
  'bennypowers/nvim-regexplainer',
  enabled = true,
  dev = true,
  ft = { 'javascript', 'typescript', 'html', 'python', 'jinja' },
  dependencies = {
    'MunifTanjim/nui.nvim',
    'edluffy/hologram.nvim',
  },
  opts = {
    auto = true,
    display =
      -- 'split' | 'popup'
      -- 'split',
      'popup',
    debug = false,

    mode =
      -- 'graphical' | 'narrative' | 'debug'
      'graphical',
    -- 'narrative',
    -- 'debug',
  },
}
