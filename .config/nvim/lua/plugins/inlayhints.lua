return { 'lvimuser/lsp-inlayhints.nvim', config = function()

require 'lsp-inlayhints'.setup {
  inlay_hints = {
    parameter_hints = {
      show = true,
      prefix = "<- ",
      separator = ", ",
      remove_colon_start = false,
      remove_colon_end = true,
    },
    type_hints = {
      -- type and other hints
      show = true,
      prefix = "",
      separator = ", ",
      remove_colon_start = false,
      remove_colon_end = false,
    },
    -- separator between types and parameter hints. Note that type hints are
    -- shown before parameter
    labels_separator = "  ",
    -- whether to align to the length of the longest line in the file
    max_len_align = false,
    -- padding from the left if max_len_align is true
    max_len_align_padding = 1,
    -- whether to align to the extreme right or not
    right_align = false,
    -- padding from the right if right_align is true
    right_align_padding = 7,
    -- highlight group
    -- highlight = "LspInlayHint", -- default
    highlight = "Comment",
  },
}

-- vim.cmd.hi('link', 'LspInlayHint', 'Comment')
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('LspAttach_inlayhints', {}),
  callback = function(args)
    if (args.data and args.data.client_id) then
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      require 'lsp-inlayhints'.on_attach(client, args.buf, false)
    end
  end
})

end }
