return { 'vigoux/notifier.nvim', config = function()
  require'notifier'.setup {
    -- components = { 'nvim', 'lsp' } -- replace fidget
    components = { 'nvim' }
  }
end }
