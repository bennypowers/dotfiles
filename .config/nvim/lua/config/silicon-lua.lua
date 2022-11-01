require'silicon'.setup{
  theme = 'catppuccin',
  windowControls = false,
  output = string.format(
    vim.fn.expand"~/Pictures/Screenshots/SILICON_%s-%s-%s_%s-%s.png",
    os.date("%Y"),
    os.date("%m"),
    os.date("%d"),
    os.date("%H"),
    os.date("%M")
 ),
}
