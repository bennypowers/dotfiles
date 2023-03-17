-- ysiw
return { 'kylechui/nvim-surround',
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
