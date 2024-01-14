return { 'goolord/alpha-nvim',
  enabled = true,
  dev = true,
  branch = 'patch-3',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local mru = require'utils'.mru
    local alpha = require 'alpha'
    local term = require 'alpha.term'
    local dashboard = require 'alpha.themes.dashboard'
    local nvim_web_devicons = require 'nvim-web-devicons'

    local width = 16

    local height = 16

    local heights = {
      [16] = 12,
      [32] = 16,
      [48] = 28,
      [64] = 32,
    }

    local custom_heights = {
      ['ness.bike'] = 24,
      nessy = 30,
      runaway5 = 24,
      phasedistorter = 24,
      skyrunner = 24,
    }

    local function get_header_script()
      local cats = {16}

      local winwidth = vim.fn.winwidth'%'
      local winheight = vim.fn.winheight'%'

      if winheight >= 40 then table.insert(cats, 32) end
      if winheight >= 60 then table.insert(cats, 48) end
      if winwidth >= 100 and winheight >= 60 then table.insert(cats, 64) end

      local headers_dir = vim.fn.expand'~/.config/nvim/headers/'

      local headers = {}

      for _, size in ipairs(cats) do
        for _, filename in ipairs(vim.fn.readdir(headers_dir .. size)) do
          table.insert(headers, { size, headers_dir .. size .. '/' .. filename })
        end
      end

      local size, path = unpack(headers[math.random(1, #headers)])
      local name = path:match'/([%w%.]+)%.sh$'
      width = size
      height = custom_heights[name] or heights[size] or 16

      return 'cat | ' .. path
    end

    alpha.setup {
      layout = {
        {
          type = 'terminal',
          command = get_header_script,
          opts = {
            redraw = true,
            window_config = function() return {
              noautocmd = true,
              focusable = false,
              zindex = 1,
              width = width,
              height = height,
            } end,
          },
        },

        { type = 'padding', val = function() return height + 4 end },

        {
          type = 'group',
          val = {
            {
              type = 'text',
              val = 'Recent files',
              opts = {
                hl = 'SpecialComment',
                shrink_margin = false,
                position = 'center',
              },
            },
            { type = 'padding', val = 1 },
            {
              type = 'group',
              val = function()
                return {
                  {
                    type = 'group',
                    val = vim.tbl_map(function(x)
                      local filename, key_label, short_filename = unpack(x)
                      local final_filename = short_filename or filename
                      local icon_ext = ''
                      local match = filename:match'^.+(%..+)$' if match then icon_ext = match:sub(2) end
                      local ico, hl = nvim_web_devicons.get_icon(filename, icon_ext, { default = true })
                      local fb_hl = {}
                      local hl_option_type = type(nvim_web_devicons.highlight)
                      if hl_option_type == 'boolean' then
                        if hl and nvim_web_devicons.highlight then
                          table.insert(fb_hl, { hl, 0, 1 })
                        end
                      elseif hl_option_type == 'string' then
                        table.insert(fb_hl, { nvim_web_devicons.highlight, 0, 1 })
                      end
                      local file_button_el =
                        dashboard.button(key_label, ico .. '  ' .. final_filename, '<cmd>e ' .. filename .. ' <CR>')
                      local filename_start = final_filename:match'.*/'
                      if filename_start ~= nil then
                        table.insert(fb_hl, { 'Comment', #ico, #filename_start + #ico })
                      end
                      file_button_el.opts.hl = fb_hl
                      return file_button_el
                    end, mru(1, 5, vim.fn.getcwd())),
                    opts = {},
                  }
                }
              end,
              opts = { shrink_margin = false },
            },
          }
        },

        { type = 'padding', val = 2 },

        {
          type = 'group',
          val = {
            { type = 'text', val = 'Quick links', opts = { hl = 'SpecialComment', position = 'center' } },
            { type = 'padding', val = 1 },
            dashboard.button('n', '  New file', ':ene <BAR> startinsert <CR>'),
            dashboard.button('spc /', '  File Explorer', ':Neotree float filesystem<CR>'),
            dashboard.button('spc p', '  Find file', ':Telescope find_files <CR>'),
            dashboard.button('spc fg', '  Find text', ':Telescope live_grep <CR>'),
            dashboard.button('q', '  Quit', ':qa<CR>'),
          },
          position = 'center',
        },
      },
      opts = {
        margin = 5,
        autostart = true,
        setup = function()
          au('User', {
            pattern = 'AlphaReady',
            desc = 'hide cursor for alpha',
            callback = function()
              vim.opt_local.guicursor:append('a:Cursor/lCursor')
              vim.opt_local.cursorline = true
              vim.cmd [[hi Cursor blend=100]]
              au('BufUnload', {
                buffer = 0,
                once = true,
                desc = 'show cursor after alpha',
                callback = function()
                  vim.cmd [[hi Cursor blend=0]]
                  vim.opt_local.guicursor:remove('a:Cursor/lCursor')
                end,
              })
            end,
          })
        end,
      },
    }
    au('User', {
      pattern = 'BDeletePre *',
      group = ag('alpha_on_empty', { clear = true }),
      callback = function()
        if vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()) == "" then
          vim.cmd([[:Alpha | bd#]])
        end
      end,
    })
  end
}
