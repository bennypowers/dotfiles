function! ScratchCapture(cmd) abort
  echo a:cmd

  " Detect if the command was a Vim command or 
  let l:cmd = substitute(a:cmd, '^\s*!', '', '')
  if a:cmd == l:cmd
    let l:output = nvim_exec(l:cmd, 1)
  else
    let l:output = system(l:cmd)
  endif

  " Create a new scratch buffer
  new
  setlocal buftype=nofile bufhidden=hide noswapfile

  " Put the output into the new buffer
  0put =l:output
endfunction


command! -nargs=* Capture call ScratchCapture(<q-args>)
