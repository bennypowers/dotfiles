require 'nvim-surround'.setup {
  surrounds = {
    ["<"] = { add = { "<", ">" } },
    [">"] = { add = { "< ", " >" } },
    ["["] = { add = { "[", "]" } },
    ["]"] = { add = { "[ ", " ]" } },
  }
}
