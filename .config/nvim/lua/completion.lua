local au = vim.api.nvim_create_autocmd

local kind_icons = {
  Text          = '󰉿',
  Method        = '󰆧',
  Function      = '󰊕',
  Constructor   = '',
  Field         = '󰜢',
  Variable      = '󰀫',
  Class         = '󰠱',
  Interface     = '',
  Module        = '',
  Property      = '󰜢',
  Unit          = '󰑭',
  Value         = '󰎠',
  Enum          = '',
  Keyword       = '󰌋',
  Snippet       = '',
  Color         = '󰏘',
  File          = '󰈙',
  Reference     = '󰈇',
  Folder        = '󰉋',
  EnumMember    = '',
  Constant      = '󰏿',
  Struct        = '󰙅',
  Event         = '',
  Operator      = '󰆕',
  TypeParameter = '',
}

local kind_hl = {
  Text          = 'String',
  Method        = 'Function',
  Function      = 'Function',
  Constructor   = 'Special',
  Field         = '@variable.member',
  Variable      = '@variable',
  Class         = 'Type',
  Interface     = 'Type',
  Module        = '@module',
  Property      = '@property',
  Unit          = 'Number',
  Value         = 'Number',
  Enum          = 'Type',
  Keyword       = 'Keyword',
  Snippet       = 'Conceal',
  Color         = 'Special',
  File          = 'Directory',
  Reference     = '@markup.link',
  Folder        = 'Directory',
  EnumMember    = 'Constant',
  Constant      = 'Constant',
  Struct        = 'Type',
  Event         = 'Special',
  Operator      = 'Operator',
  TypeParameter = 'Type',
}

au('LspAttach', {
  callback = function(ev)
    vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, {
      autotrigger = true,
      convert = function(item)
        local kind = vim.lsp.protocol.CompletionItemKind[item.kind] or 'Text'
        local icon = kind_icons[kind] or ''
        local label = item.label or ''
        item.abbr = icon .. ' ' .. label
        item.kind_text = kind
        item.abbr_hlgroup = kind_hl[kind]
        return item
      end,
    })
  end,
})
