return function()
  local trouble = require'trouble'
  trouble.setup {
    auto_open = true,
    auto_close = true,
    auto_preview = true,
    use_diagnostic_signs = false,
  }
end
