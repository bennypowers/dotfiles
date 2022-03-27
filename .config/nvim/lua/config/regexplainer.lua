return function()
  require'regexplainer'.setup {
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
  }

  -- test authoring mode
  -- require'regexplainer'.setup {
  --   display = 'split',
  --   debug = true,
  --   mode = 'narrative',
  -- }
end
