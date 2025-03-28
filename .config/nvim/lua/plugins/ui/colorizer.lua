return {"catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = { -- set to setup table
    user_default_options = {
      mode = 'virtualtext',
      names_custom = function()
        local json_path = '~/Developer/redhat-ux/red-hat-design-tokens/editor/neovim/nvim-colorizer.json'
        local handle = assert(io.open(vim.fn.expand(json_path), "r")) -- assuming path is in the scope
        local content = handle:read("*a")
              handle:close()
        local colors = vim.json.decode(content)
        return colors
      end,
    }
  },
}
