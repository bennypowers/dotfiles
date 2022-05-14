local Terminal = require 'toggleterm.terminal'.Terminal

local function close_terminal_on_zero_exit(terminal, _, exit_code)
  if exit_code == 0 then
    terminal:close()
  end
end

local function input_wrapper(fn)
  return function()
    vim.ui.input({ prompt = '$' }, function(x)
      if x then
        fn(x)
      end
    end)
  end
end

local function term_with_command(input)
  Terminal:new {
    cmd = input,
    direction = 'vertical',
  }
end

local function scratch_with_command(input)
  Terminal:new {
    cmd = input,
    close_on_exit = true,
    direction = 'float',
    on_exit = close_terminal_on_zero_exit,
  }
end

local lazygit = Terminal:new {
  cmd = 'lazygit',
  direction = 'float',
  hidden = true,
  on_exit = close_terminal_on_zero_exit,
}

local dotfileslazygit = Terminal:new {
  cmd = 'lazygit --git-dir=$HOME/.cfg --work-tree=$HOME',
  direction = 'float',
  hidden = true,
  on_exit = close_terminal_on_zero_exit,
}

local M = {}

---Launch a scratch terminal with a given command
---@type fun(input:string):nil
M.scratch_with_command = input_wrapper(scratch_with_command)

---Launch a terminal in a vertical split with a given command
---@type fun(input:string):nil
M.term_with_command = input_wrapper(term_with_command)

---Launch a terminal in a vertical split
function M.term_vertical()
  Terminal:new {
    direction = 'vertical',
  }
end

---Launch lazygit in a scratch terminal,
---but if we're in `~/.config`, use the bare repo
function M.lazilygit()
  if vim.loop.cwd() == vim.call('expand', '~/.config') then
    dotfileslazygit:toggle()
  else
    lazygit:toggle()
  end
end

return M
