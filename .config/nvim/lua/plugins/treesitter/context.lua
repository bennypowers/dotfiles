return { 'nvim-treesitter/nvim-treesitter-context',
  name = 'treesitter-context',
  enabled = false,
  opts = {
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
      -- For all filetypes
      -- Note that setting an entry here replaces all other patterns for this entry.
      -- By setting the 'default' entry below, you can control which nodes you want to
      -- appear in the context window.
      default = {
        'class',
        'function',
        'method',
        'switch',
      },
    },
  }
}
