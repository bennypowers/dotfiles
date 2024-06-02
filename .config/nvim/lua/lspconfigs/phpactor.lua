-- php
return {
  filetypes = { 'php' },
  settings = {
    phpactor = {
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
