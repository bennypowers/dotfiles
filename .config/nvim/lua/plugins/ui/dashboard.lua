return { 'glepnir/dashboard-nvim',
  enabled = false,
  config = function()
    local expand = vim.fn.expand
    local db = require 'dashboard'
    local headers_basedir = expand('~/.config/nvim/headers/')

    -- db.preview_command = "cat | sed '$d'"
    -- db.preview_file_height = 40
    -- db.preview_file_width = 80
    -- db.preview_file_path = function()
    --   local headers_dirnames = { headers_basedir .. 'small' }
    --
    --   if vim.fn.winwidth('%') >= 100 then
    --     table.insert(headers_dirnames, headers_basedir .. 'wide')
    --   end
    --
    --   if vim.fn.winheight('%') >= 60 then
    --     table.insert(headers_dirnames, headers_basedir .. 'large')
    --   end
    --
    --   local headers = {}
    --
    --   for _, dirname in ipairs(headers_dirnames) do
    --     for _, filename in ipairs(vim.fn.readdir(dirname)) do
    --       table.insert(headers, dirname .. '/' .. filename)
    --     end
    --   end
    --
    --   local path = headers[math.random(1, #headers)]
    --
    --   local lines = vim.fn.readfile(path)
    --   db.preview_file_height = #lines
    --   local max = 0
    --   for _, line in ipairs(lines) do
    --     if string.len(line) > max then
    --       max = #line
    --     end
    --   end
    --   db.preview_file_width = max
    --
    --   return path
    -- end

    db.custom_center = {
      { icon = '  ',
        desc = 'Load previous session                   ',
        shortcut = 'SPC s l',
        action = 'SessionLoad' },
      { icon = '  ',
        desc = 'Recently opened files                   ',
        action = 'Telescope oldfiles',
        shortcut = 'SPC f h' },
      { icon = '  ',
        desc = 'Find  File                              ',
        action = 'Telescope find_files find_command=rg,--hidden,--files',
        shortcut = 'SPC f f' },
      { icon = '  ',
        desc = 'File Browser                            ',
        action = 'Neotree float',
        shortcut = 'SPC f b' },
      { icon = '  ',
        desc = 'Find  word                              ',
        action = 'Telescope live_grep',
        shortcut = 'SPC f w' },
      { icon = '  ',
        desc = 'Open config                             ',
        action = 'Telescope dotfiles path=' .. expand('~/.config/nvim'),
        shortcut = 'SPC f d' },
    }

  end,
}

