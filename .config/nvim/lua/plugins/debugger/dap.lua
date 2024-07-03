return { 'mfussenegger/nvim-dap',
  dependencies = {
    { 'nvim-neotest/nvim-nio' },
    { 'theHamsta/nvim-dap-virtual-text', opts = {} },
    { 'rcarriga/nvim-dap-ui',
          dependencies = { 'nvim-neotest/nvim-nio' },
          keys = {
            { '<leader>du', function() require'dapui'.toggle({ }) end, desc = 'Dap UI' },
            { '<leader>de', function() require'dapui'.eval() end, desc = 'Eval', mode = {'n', 'v'} },
          },
          opts = {} },
    { 'mxsdev/nvim-dap-vscode-js' },
  },

  -- stylua: ignore
  keys = {
    { '<leader>d', '', desc = '+debug', mode = {'n', 'v'} },
    { '<leader>dB', function() require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = 'Breakpoint Condition' },
    { '<leader>db', function() require'dap'.toggle_breakpoint() end, desc = 'Toggle Breakpoint' },
    { '<leader>dc', function() require'dap'.continue() end, desc = 'Continue' },
    { '<leader>da', function() require'dap'.continue({ before = get_args }) end, desc = 'Run with Args' },
    { '<leader>dC', function() require'dap'.run_to_cursor() end, desc = 'Run to Cursor' },
    { '<leader>dg', function() require'dap'.goto_() end, desc = 'Go to Line (No Execute)' },
    { '<leader>di', function() require'dap'.step_into() end, desc = 'Step Into' },
    { '<leader>dj', function() require'dap'.down() end, desc = 'Down' },
    { '<leader>dk', function() require'dap'.up() end, desc = 'Up' },
    { '<leader>dl', function() require'dap'.run_last() end, desc = 'Run Last' },
    { '<leader>do', function() require'dap'.step_out() end, desc = 'Step Out' },
    { '<leader>dO', function() require'dap'.step_over() end, desc = 'Step Over' },
    { '<leader>dp', function() require'dap'.pause() end, desc = 'Pause' },
    { '<leader>dr', function() require'dap'.repl.toggle() end, desc = 'Toggle REPL' },
    { '<leader>ds', function() require'dap'.session() end, desc = 'Session' },
    { '<leader>dt', function() require'dap'.terminate() end, desc = 'Terminate' },
    { '<leader>dw', function() require'dap.ui.widgets'.hover() end, desc = 'Widgets' },
  },

  config = function(_, opts)
    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

    local dap = require'dap'

    local mason_pkg_path = vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/packages/')

    -- dap.adapters.node = {
    --   type = 'executable',
    --   command = 'node',
    --   args = { mason_pkg_path .. 'js-debug-adapter/js-debug/src/dapDebugServer.js' }
    -- }

    require'dap-vscode-js'.setup({
      -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
      debugger_path = '~/.local/share/nvim/masoin/packages/js-debug-adapter/js-debug-adapter', -- Path to vscode-js-debug installation.
      debugger_cmd = { 'js-debug-adapter' }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
      adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
      node_path = 'node',
      -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
      -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
      -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
    })


    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "js-debug-adapter", -- As I'm using mason, this will be in the path
        args = {"${port}"},
      }
    }

    local dapui = require'dapui'
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    -- setup dap config by VsCode launch.json file
    local vscode = require'dap.ext.vscode'
    local json = require'plenary.json'
    vscode.json_decode = function(str)
      return vim.json.decode(json.json_strip_comments(str))
    end
  end,
}
