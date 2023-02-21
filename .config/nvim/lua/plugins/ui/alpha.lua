return { 'goolord/alpha-nvim',
  enabled = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    math.randomseed(os.time(os.date'!*t'))

    local path = require 'plenary.path'
    local nvim_web_devicons = require 'nvim-web-devicons'
    local alpha = require 'alpha'
    local term = require 'alpha.term'
    local dashboard = require 'alpha.themes.dashboard'

    local cdir = vim.fn.getcwd()

    local function get_extension(fn)
      local match = fn:match("^.+(%..+)$")
      local ext = ""
      if match ~= nil then
        ext = match:sub(2)
      end
      return ext
    end

    local function icon(fn)
      local ext = get_extension(fn)
      return nvim_web_devicons.get_icon(fn, ext, { default = true })
    end

    local function file_button(fn, sc, short_fn)
      short_fn = short_fn or fn
      local ico_txt
      local fb_hl = {}

      local ico, hl = icon(fn)
      local hl_option_type = type(nvim_web_devicons.highlight)

      if hl_option_type == "boolean" then
        if hl and nvim_web_devicons.highlight then
          table.insert(fb_hl, { hl, 0, 1 })
        end
      end

      if hl_option_type == "string" then
        table.insert(fb_hl, { nvim_web_devicons.highlight, 0, 1 })
      end

      ico_txt = ico .. "  "

      local file_button_el = dashboard.button(sc, ico_txt .. short_fn, "<cmd>e " .. fn .. " <CR>")
      local fn_start = short_fn:match(".*/")
      if fn_start ~= nil then
        table.insert(fb_hl, { "Comment", #ico_txt - 2, #fn_start + #ico_txt - 2 })
      end
      file_button_el.opts.hl = fb_hl
      return file_button_el
    end

    local default_mru_ignore = { "gitcommit" }

    local mru_opts = {
      ignore = function(filepath, ext)
        return (string.find(filepath, "COMMIT_EDITMSG")) or (vim.tbl_contains(default_mru_ignore, ext))
      end,
    }

    --- @param start number
    --- @param cwd string optional
    --- @param items_number number optional number of items to generate, default = 10
    local function mru(start, cwd, items_number, opts)
      opts = opts or mru_opts
      items_number = items_number or 9

      local oldfiles = {}
      for _, v in pairs(vim.v.oldfiles) do
        if #oldfiles == items_number then
          break
        end
        local cwd_cond
        if not cwd then
          cwd_cond = true
        else
          cwd_cond = vim.startswith(v, cwd)
        end
        local ignore = (opts.ignore and opts.ignore(v, get_extension(v))) or false
        if (vim.fn.filereadable(v) == 1) and cwd_cond and not ignore then
          oldfiles[#oldfiles + 1] = v
        end
      end

      local special_shortcuts = { 'a', 's', 'd' }
      local target_width = 35

      local tbl = {}
      for i, fn in ipairs(oldfiles) do
        local short_fn
        if cwd then
          short_fn = vim.fn.fnamemodify(fn, ":.")
        else
          short_fn = vim.fn.fnamemodify(fn, ":~")
        end

        if (#short_fn > target_width) then
          short_fn = path.new(short_fn):shorten(1, { -2, -1 })
          if (#short_fn > target_width) then
            short_fn = path.new(short_fn):shorten(1, { -1 })
          end
        end

        local shortcut = ""
        if i <= #special_shortcuts then
          shortcut = special_shortcuts[i]
        else
          shortcut = tostring(i + start - 1 - #special_shortcuts)
        end

        local file_button_el = file_button(fn, " " .. shortcut, short_fn)
        tbl[i] = file_button_el
      end

      return {
        type = "group",
        val = tbl,
        opts = {},
      }
    end

    local width = 16
    local height = 16

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

    local headers_dirname = vim.fn.expand('~/.config/nvim/headers/' .. headers_cat)

    local function get_header_script()
      local headers = {}

      for _, filename in ipairs(vim.fn.readdir(headers_dirname)) do
        table.insert(headers, (headers_dirname .. '/' .. filename))
      end

      local idx = math.random(1, #headers)
      return headers[idx]
    end

    alpha.setup {
      layout = {
        {
          type = "terminal",
          command = 'cat | ' .. get_header_script(),
          width = width,
          height = height,
          opts = {
            redraw = true,
            window_config = {
              width = width,
              height = height,
              style = 'minimal',
              noautocmd = true,
            },
          },
        },

        { type = 'padding', val = height },

        {
          type = "group",
          val = {
            {
              type = "text",
              val = "Recent files",
              opts = {
                hl = "SpecialComment",
                shrink_margin = false,
                position = "center",
              },
            },
            { type = 'padding', val = 1 },
            {
              type = "group",
              val = function()
                return { mru(1, cdir, 5) }
              end,
              opts = { shrink_margin = false },
            },
          }
        },

        { type = 'padding', val = 2 },

        {
          type = "group",
          val = {
            { type = "text", val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
            { type = 'padding', val = 1 },
            dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
            dashboard.button("spc /", "  File Explorer", ":Neotree float filesystem<CR>"),
            dashboard.button("spc p", "  Find file", ":Telescope find_files <CR>"),
            dashboard.button("spc fg", "  Find text", ":Telescope live_grep <CR>"),
            dashboard.button("q", "  Quit", ":qa<CR>"),
          },
          position = "center",
        },
      },
      opts = {
        margin = 5,
        autostart = true,
      },
    }
  end
}
