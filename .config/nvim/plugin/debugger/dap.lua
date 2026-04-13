local u = require'utils'
local au = vim.api.nvim_create_autocmd
local ag = vim.api.nvim_create_augroup

-- Defer DAP loading until first use
local function load_dap()
  u.pack(
    'mfussenegger/nvim-dap',
    'nvim-neotest/nvim-nio',
    'theHamsta/nvim-dap-virtual-text',
    'rcarriga/nvim-dap-ui',
    'mxsdev/nvim-dap-vscode-js',
    'leoluz/nvim-dap-go'
  )

  au({ 'BufWinEnter', 'WinEnter', 'WinLeave' }, {
    desc = 'Set options on DAP windows',
    group = ag('set_dap_win_options', { clear = true }),
    pattern = { '\\[dap-repl*\\]', 'DAP *' },
    callback = function(args)
      local win = vim.fn.bufwinid(args.buf)
      vim.schedule(function()
        if not vim.api.nvim_win_is_valid(win) then return end
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.fillchars = ''
        vim.opt_local.foldlevel = 0
        vim.opt_local.foldenable = false
      end)
    end,
  })

  vim.fn.sign_define('DapBreakpoint', { text = '🔴' })
  vim.fn.sign_define('DapBreakpointRejected', { text = '⭕' })
  vim.fn.sign_define('DapBreakpointCondition', { text = '🟠' })
  vim.fn.sign_define('DapLogPoint', { text = '🔵' })
  vim.fn.sign_define('DapStopped', { text = '➡️' })
  vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

  require 'nvim-dap-virtual-text'.setup {}
  local dapui = require 'dapui'
  dapui.setup {}

  local dap = require 'dap'

  dap.adapters['pwa-node'] = {
    type = 'server',
    host = 'localhost',
    port = '${port}',
    executable = {
      command = 'js-debug-adapter',
      args = { '${port}' },
    },
  }

  dap.listeners.after.event_initialized.dapui_config = function() dapui.open() end
  dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

  local vscode = require 'dap.ext.vscode'
  vscode.json_decode = function(str)
    return vim.json.decode(str:gsub('//.-\n', '\n'))
  end

  require 'dap-go'.setup()

  require 'dap-vscode-js'.setup {
    debugger_cmd = { 'js-debug-adapter' },
    adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
    node_path = 'node',
  }

  local function get_args()
    local cmd_args = vim.fn.input 'CommandLine Args:'
    local params = {}
    for param in string.gmatch(cmd_args, '[^%s]+') do
      table.insert(params, param)
    end
    return params
  end

  u.nmap('<leader>dB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, 'Breakpoint Condition')
  u.nmap('<leader>db', dap.toggle_breakpoint, 'Toggle Breakpoint')
  u.nmap('<leader>dc', dap.continue, 'Continue')
  u.nmap('<leader>da', function() dap.continue { before = get_args } end, 'Run with Args')
  u.nmap('<leader>dC', dap.run_to_cursor, 'Run to Cursor')
  u.nmap('<leader>dg', dap.goto_, 'Go to Line (No Execute)')
  u.nmap('<leader>di', dap.step_into, 'Step Into')
  u.nmap('<leader>dj', dap.down, 'Down')
  u.nmap('<leader>dk', dap.up, 'Up')
  u.nmap('<leader>dl', dap.run_last, 'Run Last')
  u.nmap('<leader>do', dap.step_out, 'Step Out')
  u.nmap('<leader>dO', dap.step_over, 'Step Over')
  u.nmap('<leader>dp', dap.pause, 'Pause')
  u.nmap('<leader>dr', dap.repl.toggle, 'Toggle REPL')
  u.nmap('<leader>ds', dap.session, 'Session')
  u.nmap('<leader>dt', dap.terminate, 'Terminate')
  u.nmap('<leader>du', function() dapui.toggle {} end, 'Dap UI')

  return dap
end

-- Stub keymaps that load DAP on first use
u.nmap('<leader>db', function() load_dap().toggle_breakpoint() end, 'Toggle Breakpoint')
u.nmap('<leader>dc', function() load_dap().continue() end, 'Continue')
