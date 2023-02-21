return { 'goolord/alpha-nvim',
  enabled = true,
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

    local function get_header_script()
      local headers_cat = '16'

      -- local winwidth = vim.fn.winwidth'%'
      -- local winheight = vim.fn.winheight'%'
      --
      -- if winwidth >= 100 and winheight >= 60 then
      --   headers_cat = 'small'
      --   height = 25
      -- end
      --
      -- if winwidth >= 100 and winheight >= 60 then
      --   headers_cat = 'wide'
      --   width = 100
      -- end
      --
      -- if winheight >= 60 then
      --   headers_cat = 'tall'
      --   height = 40
      -- end
      --
      local headers_dirname = vim.fn.expand('~/.config/nvim/headers/' .. headers_cat)

      local headers = {}

      for _, filename in ipairs(vim.fn.readdir(headers_dirname)) do
        table.insert(headers, (headers_dirname .. '/' .. filename))
      end

      local idx = math.random(1, #headers)
      return 'cat | ' .. headers[idx]
    end

    alpha.setup {
      layout = {
        {
          type = 'terminal',
          command = get_header_script,
          width = width,
          height = height,
          opts = {
            redraw = true,
            window_config = {
              noautocmd = true,
            },
          },
        },

        { type = 'padding', val = height },

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
      },
    }
  end
}
