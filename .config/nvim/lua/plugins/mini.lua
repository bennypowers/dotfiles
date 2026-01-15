return {
  {
    'echasnovski/mini.trailspace',
    enabled = true,
    event = 'VeryLazy',
    opts = {
      only_in_normal_buffers = true,
    },
  },
  {
    'echasnovski/mini.base16',
    config = function()
      local function apply_theme()
        local ok, palette = pcall(require, 'matugen')
        if ok then
          require('mini.base16').setup { palette = palette }
        end
      end

      -- Apply theme on startup
      apply_theme()

      -- Register SIGUSR1 handler for dynamic updates
      local signal = vim.uv.new_signal()
      signal:start('sigusr1', vim.schedule_wrap(function()
        package.loaded['matugen'] = nil
        apply_theme()
      end))
    end,
  },
}
