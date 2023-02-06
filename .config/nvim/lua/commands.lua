command('ClearNotifications', function()
  local has_notify, notify = pcall(require, 'notify')
  if has_notify then
    notify.dismiss { silent = true }
  else
    vim.cmd[[:NotifierClear]]
  end
  vim.cmd[[nohlsearch|diffupdate|normal! <C-L><CR>]]
end, {
  bang = true,
})

command('HighlightRepeats', function(args)
  local line_counts = {}
  local first = args.line1
  local last = args.line2
  if first == last then
    first = 1
    last = vim.api.nvim_buf_line_count(0)
  end
  vim.notify(vim.inspect { first, last })
  local line_num = first
  while line_num <= last do
    local line_text = vim.fn.getline(line_num)
    if #line_text > 0 then
      line_counts[line_text] = (line_counts[line_text] or 0) + 1
    end
    line_num = line_num + 1
  end
  vim.fn.execute('syn clear Repeat')
  for line_text, amt in pairs(line_counts) do
    if amt >= 2 then
      local escaped = vim.fn.escape(line_text, [[".\^%*[]])
      local command = 'syn match Repeat "^' .. escaped .. '$"'
      vim.notify(vim.inspect {
        line_text = line_text,
        escaped = escaped,
        command = command,
      })
      vim.fn.execute(command)
    end
  end
end, {
  bang = true,
  range = '%'
})

