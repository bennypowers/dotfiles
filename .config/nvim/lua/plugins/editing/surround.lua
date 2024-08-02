-- ysiw
return {
  'kylechui/nvim-surround',
  enabled = true,
  version = '2',
  opts = {
    move_cursor = 'sticky',
    surrounds = {
      ['<'] = { add = { '<', '>' } },
      ['>'] = { add = { '< ', ' >' } },
      ['['] = { add = { '[', ']' } },
      [']'] = { add = { '[ ', ' ]' } },

      ['t'] = {
        -- add = wrap_with_abbreviation,
        add = function()
          local input = vim.fn.input 'Emmet Abbreviation:'

          if input then
            --- hat_tip to https://github.com/b0o/nvim-conf/blob/363e126f6ae3dff5f190680841e790467a00124d/lua/user/util/wrap.lua#L12
            local bufnr = 0
            local client = unpack(vim.lsp.get_clients{ bufnr = bufnr, name = 'emmet_language_server' })
            if client then
              local splitter =  'BENNYSPECIALSECRETSTRING'
              local response = client.request_sync('emmet/expandAbbreviation', {
                  abbreviation = input,
                  language = vim.opt.filetype,
                  options = {
                    text = splitter,
                  },
                }, 50, bufnr)
              if response then
                if response.err then
                  vim.notify(response.err.message)
                else
                  vim.notify(vim.inspect(response))
                  return (vim.split(response.result, splitter))
                end
              end
            end
          end
        end,
        find = function()
          return require 'nvim-surround.config'.get_selection { motion = 'at' }
        end,
        delete = '^(%b<>)().-(%b<>)()$',
        change = {
          target = '^<([^%s<>]*)().-([^/]*)()>$',
          replacement = function()
            local input = vim.fn.input'New Emmet Abbreviation:'
            if input then
              local element = input:match '^<?([^%s>]*)'
              local attributes = input:match '^<?[^%s>]*%s+(.-)>?$'

              local open = attributes and element .. ' ' .. attributes or element
              local close = element

              return { { open }, { close } }
            end
          end,
        },
      },
    }
  }
}
