return { 'bennypowers/changesets.nvim',
  enabled = true,
  keys = {
    { '<leader>cs',
      function() require'changesets'.create() end,
      mode = 'n',
      desc = 'Create a changeset',
    },
    { '<leader>ca',
      function() require'changesets'.add_package() end,
      mode = 'n',
      desc = 'Add a package to the changeset in the current buffer',
    },
  },
}

