local function highlight_repeats(args)
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
end

vim.api.nvim_create_user_command('HighlightRepeats', highlight_repeats, {
  bang = true,
  range = '%'
})


-- " Edge motion
-- "
-- " Jump to the next or previous line that has the same level or a lower
-- " level of indentation than the current line.
-- "
-- " exclusive (bool): true: Motion is exclusive
-- " false: Motion is inclusive
-- " fwd (bool): true: Go to next line
-- " false: Go to previous line
-- " lowerlevel (bool): true: Go to line with lower indentation level
-- " false: Go to line with the same indentation level
-- " skipblanks (bool): true: Skip blank lines
-- " false: Don't skip blank lines
-- function! NextIndent(exclusive, fwd, lowerlevel, skipblanks)
--   let line = line('.')
--   let column = col('.')
--   let lastline = line('$')
--   let indent = indent(line)
--   let stepvalue = a:fwd ? 1 : -1
--   while (line > 0 && line <= lastline)
--     let line = line + stepvalue
--     if ( ! a:lowerlevel && indent(line) == indent ||
--           \ a:lowerlevel && indent(line) < indent)
--       if (! a:skipblanks || strlen(getline(line)) > 0)
--         if (a:exclusive)
--           let line = line - stepvalue
--         endif
--         exe line
--         exe "normal " column . "|"
--         return
--       endif
--     endif
--   endwhile
-- endfunction
--
-- " Moving back and forth between lines of same or lower indentation.
-- nnoremap <silent><M-]>  :call NextIndent(0, 1, 0, 1)<CR>
-- nnoremap <silent><M-[>  :call NextIndent(0, 0, 0, 1)<CR>
-- vnoremap <silent> [h    <Esc>:call NextIndent(0, 0, 0, 1)<CR>m'gv''
-- vnoremap <silent> ]j    <Esc>:call NextIndent(0, 1, 0, 1)<CR>m'gv''
-- vnoremap <silent> [h    <Esc>:call NextIndent(0, 0, 1, 1)<CR>m'gv''
-- vnoremap <silent> ]j    <Esc>:call NextIndent(0, 1, 1, 1)<CR>m'gv''
-- onoremap <silent> [h    :call NextIndent(0, 0, 0, 1)<CR>
-- onoremap <silent> ]j    :call NextIndent(0, 1, 0, 1)<CR>
-- onoremap <silent> [h    :call NextIndent(1, 0, 1, 1)<CR>
-- onoremap <silent> ]j    :call NextIndent(1, 1, 1, 1)<CR>
vim.cmd [[
function! HTMLEncode()
perl << EOF
 use HTML::Entities;
 @pos = $curwin->Cursor();
 $line = $curbuf->Get($pos[0]);
 $encvalue = encode_entities($line);
 $curbuf->Set($pos[0],$encvalue)
EOF
endfunction

function! HTMLDecode()
perl << EOF
 use HTML::Entities;
 @pos = $curwin->Cursor();
 $line = $curbuf->Get($pos[0]);
 $encvalue = decode_entities($line);
 $curbuf->Set($pos[0],$encvalue)
EOF
endfunction

nnoremap <Leader>h :call HTMLEncode()<CR>
nnoremap <Leader>H :call HTMLDecode()<CR>
]]
