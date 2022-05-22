require 'toggleterm'.setup {}

local Terminal = require 'toggleterm.terminal'.Terminal

---Close a terminal whose command exits cleanly.
---For good measure, refresh the neo-tree filesystem view either way
local function close_terminal_on_zero_exit(terminal, _, exit_code)
  if exit_code == 0 then
    terminal:close()
  end
  require 'neo-tree.sources.manager'.refresh 'filesystem'
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
  return Terminal:new {
    cmd = input,
    direction = 'vertical',
  }:open()
end

local function scratch_with_command(input)
  return Terminal:new {
    cmd = input,
    close_on_exit = true,
    direction = 'float',
    on_exit = close_terminal_on_zero_exit,
  }:open()
end

local lazygit_term_options = {
  cmd = 'lazygit',
  direction = 'float',
  hidden = true,
  on_exit = close_terminal_on_zero_exit,
}

local lazygit = Terminal:new(lazygit_term_options)
local dotfileslazygit = Terminal:new(vim.tbl_extend('force', lazygit_term_options, {
  cmd = 'lazygit --git-dir=$HOME/.cfg --work-tree=$HOME',
}))

local M = {}

---Launch a scratch terminal with a given command
---@type fun(input:string):nil
M.scratch_with_command = input_wrapper(scratch_with_command)

---Launch a terminal in a vertical split with a given command
---@type fun(input:string):nil
M.term_with_command = input_wrapper(term_with_command)

---Launch a terminal in a vertical split
function M.term_vertical()
  local term = Terminal:new { cmd = 'fish' }
  term:open(80, 'vertical', true)
  return term
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
