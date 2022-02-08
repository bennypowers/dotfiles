 return function()
  -- Markdown fenced code blocks
  vim.g.vim_markdown_fenced_languages = {
    'css', 'scss', 'html',
    'python', 'py=python',
    'sh', 'bash=sh',
    'fish',

    'typescript', 'ts=typescript',
    'javascript', 'js=javascript',
    'json=javascript',

    'graphql', 'gql=graphql',
    'vim'
  }
end
