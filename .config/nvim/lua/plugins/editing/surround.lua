-- ysiw
return { 'kylechui/nvim-surround',
  opts = {
    surrounds = {
      ["<"] = { add = { "<", ">" } },
      [">"] = { add = { "< ", " >" } },
      ["["] = { add = { "[", "]" } },
      ["]"] = { add = { "[ ", " ]" } },
    }
  }
}
