func! ChangeBackground()
  if (v:os_appearance == 1)
    set background=dark
    colorscheme pinkmare
  else
    set background=light
    colorscheme bclear
  endif
  redraw!
endfunc

if has("gui_vimr")
  call ChangeBackground()
  set background=dark
  colorscheme pinkmare
  au OSAppearanceChanged * call ChangeBackground()
	:lua <<EOF
require('onedark').setup()
require('dark_notify').run()
EOF

endif
