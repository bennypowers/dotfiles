return { 'tummetott/reticle.nvim',
  event = { 'WinNew', 'WinLeave' },
  enabled = false,
  opts = {
    always_highlight_number = true,
    on_focus = {
      cursorline = {
        'alpha',
        'neo-tree',
      },
    },
  },
}
