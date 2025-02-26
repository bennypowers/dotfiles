local term_lazydotfiles
local term_lazygit
local term_pinned

local lazygit_term_options = {
  cmd = 'lazygit',
  direction = 'float',
  hidden = true,
  -- Close a terminal whose command exits cleanly.
  -- For good measure, refresh the neo-tree filesystem view either way
  on_exit = function(terminal, _, exit_code)
    if exit_code == 0 then
      terminal:close()
    end
    pcall(function()
      require 'neo-tree.sources.manager'.refresh 'filesystem'
    end)
  end,
  start_in_insert = true,
  shade_terminals = false,
  highlights = {
    -- NormalFloat = {
    --   guibg = "#212121",
    -- },
  },
  float_opts = {
    -- winblend = 3,
    border = 'shadow',
  },
}

---Launch lazygit in a scratch terminal,
---but if we're in `~/.config`, use the bare repo
local function toggle_term_lazygit()
  local cwd = vim.loop.cwd()
  if cwd and vim.startswith(cwd, vim.fn.expand'~/.config') then
    term_lazydotfiles:toggle()
  else
    term_lazygit:toggle()
  end
end

local function toggle_term_pinned()
  term_pinned:toggle()
end

-- 🖥️  terminal emulator
return { 'akinsho/toggleterm.nvim',
  enabled = true,
  keys = {
    { '<c-t>', toggle_term_pinned,  desc = 'Toggle terminal in horizontal split', mode = { 'n', 'i', 't' } },
    { '<c-g>', toggle_term_lazygit, desc = 'Git UI via lazygit', mode = { 'n', 't' } },
  },
  dependencies = {
    { 'stevearc/stickybuf.nvim', enabled = false, opts = {} }
  },
  config = function()
    require'toggleterm'.setup {
      shell = 'fish'
    }

    local Terminal = require 'toggleterm.terminal'.Terminal

    term_lazygit = Terminal:new(lazygit_term_options)

    term_lazydotfiles = Terminal:new(vim.tbl_extend('force', lazygit_term_options, {
      cmd = 'lazygit --git-dir=$HOME/.cfg --work-tree=$HOME',
    }))

    term_pinned = Terminal:new {
      direction = 'horizontal',
      size = 20,
      dir = 'git_dir',
      start_in_insert = true,
      on_create = function()
        pcall(function() require'stickybuf'.pin_buftype() end)
      end
    }

    au('TermOpen', {
      pattern = '*',
      group = ag('terminal_setup', {}),
      command = 'nnoremap <buffer><LeftRelease> <LeftRelease>i'
    })
  end
}

