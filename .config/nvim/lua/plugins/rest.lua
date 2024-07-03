return { 'rest-nvim/rest.nvim',
  enabled = false,
  ft = 'http',
  dependencies = { 'vhyrro/luarocks.nvim' },
  config = function()
    require'rest-nvim'.setup {
      keybinds = {
        { '<c-Enter>', '<cmd>Rest run <cr>', 'Run request under the cursor' },
      },
      result = {
        split = {
          horizontal = true
        },
        behavior = {
          formatters = {
            json = 'jq',
            html = function(body) return body end,
            -- html = function(body)
            --   if vim.fn.executable("tidy") == 0 then
            --     return body, { found = false, name = "tidy" }
            --   end
            --   local fmt_body = vim.fn.system({
            --     "tidy",
            --     "-i",
            --     "-q",
            --     "--tidy-mark",      "no",
            --     "--show-body-only", "auto",
            --     "--show-errors",    "0",
            --     "--show-warnings",  "0",
            --     "-",
            --   }, body):gsub("\n$", "")
            --
            --   return body
            --   -- return fmt_body, { found = true, name = "tidy" }
            -- end,
          },--
        }
      }
    }
  end,
}

