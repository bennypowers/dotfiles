-- ysiw
return { 'kylechui/nvim-surround', config = function()

require 'nvim-surround'.setup {
  surrounds = {
    ["<"] = { add = { "<", ">" } },
    [">"] = { add = { "< ", " >" } },
    ["["] = { add = { "[", "]" } },
    ["]"] = { add = { "[ ", " ]" } },
  }
}

end }
