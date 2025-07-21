local function lazygit()
  local cwd = vim.loop.cwd()
  if cwd and vim.startswith(cwd, vim.fn.expand'~/.config') then
    local home = vim.fn.expand('~')
    Snacks.lazygit{ args = {
      '--git-dir='..home..'/.cfg',
      '--work-tree='..home,
    } }
  else
    Snacks.lazygit()
  end
end

au('User', {
  pattern = 'OilActionsPost',
  callback = function(event)
      if event.data.actions.type == 'move' then
          Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
      end
  end,
})

return { 'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  keys = {
    { "<leader>p", function() Snacks.picker.smart() end },
    { "<leader>fg", function() Snacks.picker.grep() end },
    { "<leader>fr", function() Snacks.picker.resume() end },
    { "<c-g>", lazygit },
    { "<c-e>", function() Snacks.picker.icons() end },
  },
  ---@type snacks.Config
  opts = {
    explorer = { enabled = false },
    git = { enabled = false },
    image = { enabled = false },
    dashboard = {
      sections = {
        {
          section = "terminal",
          cmd = "fish -c 'colorscript -r; sleep .1'",
          random = 10,
          indent = 4,
          height = 25,
          width = 64,
        },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
    },
    lazygit = {},
    notifier = {
      render = 'minimal',
    },
    picker = {
      render = 'minimal',
    },
    scope = {},
    statuscolumn = {
      folds = {
        open = true,
        git_hl = true,
      }
    },
  }
}
