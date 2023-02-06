local function input_wrapper(fn)
  return function()
    vim.ui.input({ prompt = '$' }, function(x)
      if x then
        fn(x)
      end
    end)
  end
end

local dotfileslazygit
local lazygit
local Terminal

---Close a terminal whose command exits cleanly.
---For good measure, refresh the neo-tree filesystem view either way
local function close_terminal_on_zero_exit(terminal, _, exit_code)
  if exit_code == 0 then
    terminal:close()
  end
  require 'neo-tree.sources.manager'.refresh 'filesystem'
end

local lazygit_term_options = {
  cmd = 'lazygit',
  direction = 'float',
  hidden = true,
  on_exit = close_terminal_on_zero_exit,
  shade_terminals = false,
  highlights = {
    NormalFloat = {
      guibg = "#212121",
    },
  },
  float_opts = {
    -- winblend = 3,
    border = 'shadow',
  },
}

---Launch a scratch terminal with a given command
---@type fun(input:string):nil
local scratch_with_command = input_wrapper(function (input)
  return Terminal:new {
    cmd = input,
    close_on_exit = true,
    direction = 'float',
    on_exit = close_terminal_on_zero_exit,
  }:open()
end)

---Launch a terminal in a vertical split with a given command
---@type fun(input:string):nil
local term_with_command = input_wrapper(function(input)
  return Terminal:new {
    cmd = input,
    direction = 'vertical',
  }:open()
end)

---Launch lazygit in a scratch terminal,
---but if we're in `~/.config`, use the bare repo
local function lazilygit()
  local cwd = vim.loop.cwd()
  if cwd and vim.startswith(cwd, vim.fn.expand'~/.config') then
    dotfileslazygit:toggle()
  else
    lazygit:toggle()
  end
end

-- 🖥️  terminal emulator
return { 'akinsho/toggleterm.nvim',
  keys = {
    { '<leader>tt', ':ToggleTerm size=20 dir=git_dir direction=vertical<cr>', desc = 'Open terminal in vertical split' },
    { '<leader>tp', ':ToggleTerm size=20 dir=git_dir<cr>',                    desc = 'Open terminal in horizontal split' },
    { '<leader>tf', term_with_command,                                        desc = 'Open terminal with command' },
    { '<leader>ts', scratch_with_command,                                     desc = 'Open Scratch terminal with command' },
    { '<leader>g',  lazilygit,                                                desc = 'Git UI via lazygit' },
  },
  config = function()

    require 'toggleterm'.setup {
      shell = 'fish'
    }

    Terminal = require 'toggleterm.terminal'.Terminal
    lazygit = Terminal:new(lazygit_term_options)
    dotfileslazygit = Terminal:new(vim.tbl_extend('force', lazygit_term_options, {
      cmd = 'lazygit --git-dir=$HOME/.cfg --work-tree=$HOME',
    }))

  end
}

