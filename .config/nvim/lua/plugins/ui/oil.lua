return { 'stevearc/oil.nvim',
  dev = true,
  keys = {
    { '-', '<CMD>Oil<CR>', mode = 'n', desc = 'Open parent directory' },
  },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    view_options = {
      custom_highlights = function(entry, meta)
        if entry[2]:gmatch'(.js|.map|.d.ts)$' then
          vim.notify(vim.inspect(meta))
          return { 'OilArtifact' }
        end
      end
    }
  }
}
