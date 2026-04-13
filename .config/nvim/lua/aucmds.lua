local au = vim.api.nvim_create_autocmd
local ag = vim.api.nvim_create_augroup

au('BufEnter', {
  group = ag('waybar_config', {}),
  pattern = 'config',
  callback = function(event)
    if event.match == vim.fn.expand '~/.config/waybar/config' then
      vim.bo.filetype = 'json'
    end
  end
})

---Highlight yanked text
--
au('TextYankPost', {
  group = ag('yank_highlight', {}),
  pattern = '*',
  callback = function()
    vim.highlight.on_yank { higroup = 'IncSearch', timeout = 300 }
  end,
})

-- Only setup gnvim when it attaches.
au('UIEnter', {
  callback = function()
    local chanid = vim.v.event.chan
    if chanid then
      local chan = vim.api.nvim_get_chan_info(chanid)
      if chan.client and chan.client.name == 'gnvim' then
        -- Gnvim brings its own runtime files.
        local gnvim = require 'gnvim'

        -- Set the font
        vim.opt.guifont = 'FiraCode Nerd Font 13'

        -- Increase/decrease font.
        vim.keymap.set('n', '<c-+>', function() gnvim.font_size(1) end)
        vim.keymap.set('n', '<c-->', function() gnvim.font_size(-1) end)

        gnvim.setup {
          cursor = {
            blink_transition = 300
          }
        }
      end
    end
  end
})

au('TermClose', {
  callback = function(ev)
    local ns = vim.api.nvim_create_namespace('nvim.terminal.exitmsg')
    vim.defer_fn(function()
      if vim.api.nvim_buf_is_valid(ev.buf) then
        vim.api.nvim_buf_clear_namespace(ev.buf, ns, 0, -1)
      end
    end, 10)
  end,
})

au('LspAttach', {
  callback = function(args)
    if vim.lsp.document_color then
      vim.lsp.document_color.enable(true, { bufnr = args.buf }, {
        style = 'virtual'
      })
    end
  end
})
