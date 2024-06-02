-- ysiw
return { 'kylechui/nvim-surround',
  enabled = true,
  version = '2',
  opts = {
    surrounds = {
      ['<'] = { add = { '<', '>' } },
      ['>'] = { add = { '< ', ' >' } },
      ['['] = { add = { '[', ']' } },
      [']'] = { add = { '[ ', ' ]' } },
    }
  }
}
