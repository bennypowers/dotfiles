return {

  -- markdown previews
  { 'iamcco/markdown-preview.nvim',
    ft = { 'md', 'markdown' },
    build = function()
      vim.fn["mkdp#util#install"]()
    end },

}
