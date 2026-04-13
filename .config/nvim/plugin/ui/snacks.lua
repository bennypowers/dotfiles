local u = require'utils'
local au = vim.api.nvim_create_autocmd

local function lazygit()
  local cwd = vim.loop.cwd()
  if cwd and vim.startswith(cwd, vim.fn.expand '~/.config') then
    local home = vim.fn.expand '~'
    Snacks.lazygit { args = {
      '--git-dir=' .. home .. '/.cfg',
      '--work-tree=' .. home,
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

u.pack('https://github.com/folke/snacks.nvim')

require 'snacks'.setup {
  explorer = { enabled = false },
  git = { enabled = false },
  image = { enabled = true },
  indent = { enabled = true },
  scroll = { enabled = true },
  dashboard = {
    enabled = true,
    sections = {
      {
        section = 'terminal',
        cmd = "fish -c 'colorscript -r'",
        random = 10,
        indent = 4,
        height = 26,
        width = 64,
      },
      { section = 'keys', gap = 1, padding = 1 },
      -- { section = 'startup' },
    },
  },
  lazygit = {},
  notifier = {
    render = 'minimal',
  },
  picker = {
    render = 'minimal',
    matcher = {
      frecency = true,
    },
    debug = {
      files = true,
    },
  },
  scope = {},
  statuscolumn = {
    folds = {
      open = true,
      git_hl = true,
    },
  },
}

u.nmap('<leader>p', Snacks.picker.smart, 'Smart picker')
u.nmap('<leader>fg', Snacks.picker.grep, 'Grep picker')
u.nmap('<leader>fh', Snacks.picker.help, 'Help picker')
u.nmap('<leader>fd', Snacks.picker.diagnostics, 'LSP diagnostics picker')
u.nmap('<leader>fp', Snacks.picker.pickers, 'Pickers picker')
u.nmap('<leader>fr', Snacks.picker.resume, 'Resume last picker')
u.nmap('<leader>fi', Snacks.picker.icons, 'Icons picker')
u.nmap('<c-g>', lazygit, 'Lazygit')
u.imap('<c-e>', Snacks.picker.icons, 'Icons picker')
