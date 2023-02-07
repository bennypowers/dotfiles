return { 'bennypowers/nvim-regexplainer',
  ft = { 'javascript', 'typescript', 'html', 'python', 'jinja' },
  dependencies = { 'MunifTanjim/nui.nvim' },
  opts = {
    -- test authoring mode
    -- display = 'split',
    -- debug = true,
    -- mode = 'narrative',

    auto = true,
    display = 'popup',
    -- display = 'split',
    debug = true,
    mode = 'narrative',
    -- mode = 'debug',
    -- mode = 'graphical',
    narrative = {
      separator = function(component)
        local sep = '\n';
        if component.depth > 0 then
          for _ = 1, component.depth do
            sep = sep .. '> '
          end
        end
        return sep
      end
    },
  },
}
