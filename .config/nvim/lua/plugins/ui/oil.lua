local filename_cache = {}

return { 'stevearc/oil.nvim',
  keys = {
    { '-', '<CMD>Oil<CR>', mode = 'n', desc = 'Open parent directory' },
  },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    view_options = {
      show_hidden = true,
      is_hidden_file = function(name, bufnr)
        if name == '..' then
          filename_cache = vim.api.nvim_buf_get_lines(3, 0, -1, false)
          vim.notify(vim.inspect({ name, bufnr, filename_cache }))
        end
        if name:gmatch'%.(js|map|d%.ts)$' then
          return 'OilArtifact'
        end
      end,
      highlight_filename = function(entry, is_hidden)
        return nil
        -- if is_hidden then
        --   return 'Comment'
        -- end
      end
    }
  }
}
