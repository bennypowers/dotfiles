return {

  -- markdown previews
  { 'iamcco/markdown-preview.nvim',
    enabled = true,
    ft = { 'md', 'markdown' },
    build = function()
      vim.fn["mkdp#util#install"]()
    end },

}
