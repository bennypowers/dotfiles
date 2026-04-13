local u = require'utils'

u.pack(
  'bennypowers/adelman-keyboard',
  'bennypowers/changesets.nvim',
  'bennypowers/splitjoin.nvim',
  'bennypowers/template-literal-comments.nvim',
  'bennypowers/svgo.nvim',
  'bennypowers/webc.nvim'
)

local splitjoin = require'splitjoin'

splitjoin.setup {
  languages = {
    html = {
      nodes = {
        attribute = {
          aligned = true
        }
      }
    }
  }
}

u.nmap('gj', splitjoin.join, 'Join the object under cursor')
u.nmap('g,', splitjoin.split, 'Split the object under cursor')

local changesets = require'changesets'

u.nmap('<leader>cs', changesets.create, 'Create a changeset')
u.nmap('<leader>ca', changesets.add_package, 'Add a package to the changeset in the current buffer')

