return function ()
  local notify = require'notify'
  notify.setup {
    render = 'minimal'
  }
  vim.notify = notify
end
