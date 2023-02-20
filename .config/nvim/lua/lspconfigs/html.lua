-- html
return {
  filetypes = { 'html', 'njk', 'md', 'svg' },
  settings = {
    html = {
      format = {
        templating = true,
        wrapLineLength = 200,
        wrapAttributes = 'force-aligned',
      },
      editor = {
        formatOnSave = false,
        formatOnPaste = true,
        formatOnType = false,
      },
      hover = {
        documentation = true,
        references = true,
      },
    },
  },
}
