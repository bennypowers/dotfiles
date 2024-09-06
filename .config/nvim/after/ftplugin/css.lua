local get_node_text = vim.treesitter.get_node_text
local read_flattened_tokens = require'design-tokens'.read_flattened_tokens

---@param node TSNode
---@param line1 number 1-indexed start row
---@param line2 number 1-indexed end row
local function node_is_on_line(node, line1, line2)
  local row = node:range()
  return row >= line1 - 1 and row <= line2 - 1
end

local rhds_tokens =
 vim.iter(read_flattened_tokens'~/Developer/redhat-ux/red-hat-design-tokens/json/rhds.tokens.json')
  :fold({}, function(acc,  v)
    acc['--'..v.name] = v
    return acc
  end)

local pfv4_tokens = {
  ['--pf-global--palette--black-100'] = { ['$value'] = '#fafafa'},
  ['--pf-global--palette--black-150'] = { ['$value'] = '#f5f5f5'},
  ['--pf-global--palette--black-200'] = { ['$value'] = '#f0f0f0'},
  ['--pf-global--palette--black-300'] = { ['$value'] = '#d2d2d2'},
  ['--pf-global--palette--black-400'] = { ['$value'] = '#b8bbbe'},
  ['--pf-global--palette--black-500'] = { ['$value'] = '#8a8d90'},
  ['--pf-global--palette--black-600'] = { ['$value'] = '#6a6e73'},
  ['--pf-global--palette--black-700'] = { ['$value'] = '#4f5255'},
  ['--pf-global--palette--black-800'] = { ['$value'] = '#3c3f42'},
  ['--pf-global--palette--black-850'] = { ['$value'] = '#212427'},
  ['--pf-global--palette--black-900'] = { ['$value'] = '#151515'},
  ['--pf-global--palette--black-1000'] = { ['$value'] = '#030303'},
  ['--pf-global--palette--blue-50'] = { ['$value'] = '#e7f1fa'},
  ['--pf-global--palette--blue-100'] = { ['$value'] = '#bee1f4'},
  ['--pf-global--palette--blue-200'] = { ['$value'] = '#73bcf7'},
  ['--pf-global--palette--blue-300'] = { ['$value'] = '#2b9af3'},
  ['--pf-global--palette--blue-400'] = { ['$value'] = '#06c'},
  ['--pf-global--palette--blue-500'] = { ['$value'] = '#004080'},
  ['--pf-global--palette--blue-600'] = { ['$value'] = '#002952'},
  ['--pf-global--palette--blue-700'] = { ['$value'] = '#001223'},
  ['--pf-global--palette--cyan-50'] = { ['$value'] = '#f2f9f9'},
  ['--pf-global--palette--cyan-100'] = { ['$value'] = '#a2d9d9'},
  ['--pf-global--palette--cyan-200'] = { ['$value'] = '#73c5c5'},
  ['--pf-global--palette--cyan-300'] = { ['$value'] = '#009596'},
  ['--pf-global--palette--cyan-400'] = { ['$value'] = '#005f60'},
  ['--pf-global--palette--cyan-500'] = { ['$value'] = '#003737'},
  ['--pf-global--palette--cyan-600'] = { ['$value'] = '#002323'},
  ['--pf-global--palette--cyan-700'] = { ['$value'] = '#000f0f'},
  ['--pf-global--palette--gold-50'] = { ['$value'] = '#fdf7e7'},
  ['--pf-global--palette--gold-100'] = { ['$value'] = '#f9e0a2'},
  ['--pf-global--palette--gold-200'] = { ['$value'] = '#f6d173'},
  ['--pf-global--palette--gold-300'] = { ['$value'] = '#f4c145'},
  ['--pf-global--palette--gold-400'] = { ['$value'] = '#f0ab00'},
  ['--pf-global--palette--gold-500'] = { ['$value'] = '#c58c00'},
  ['--pf-global--palette--gold-600'] = { ['$value'] = '#795600'},
  ['--pf-global--palette--gold-700'] = { ['$value'] = '#3d2c00'},
  ['--pf-global--palette--green-50'] = { ['$value'] = '#f3faf2'},
  ['--pf-global--palette--green-100'] = { ['$value'] = '#bde5b8'},
  ['--pf-global--palette--green-200'] = { ['$value'] = '#95d58e'},
  ['--pf-global--palette--green-300'] = { ['$value'] = '#6ec664'},
  ['--pf-global--palette--green-400'] = { ['$value'] = '#5ba352'},
  ['--pf-global--palette--green-500'] = { ['$value'] = '#3e8635'},
  ['--pf-global--palette--green-600'] = { ['$value'] = '#1e4f18'},
  ['--pf-global--palette--green-700'] = { ['$value'] = '#0f280d'},
  ['--pf-global--palette--light-blue-100'] = { ['$value'] = '#beedf9'},
  ['--pf-global--palette--light-blue-200'] = { ['$value'] = '#7cdbf3'},
  ['--pf-global--palette--light-blue-300'] = { ['$value'] = '#35caed'},
  ['--pf-global--palette--light-blue-400'] = { ['$value'] = '#00b9e4'},
  ['--pf-global--palette--light-blue-500'] = { ['$value'] = '#008bad'},
  ['--pf-global--palette--light-blue-600'] = { ['$value'] = '#005c73'},
  ['--pf-global--palette--light-blue-700'] = { ['$value'] = '#002d39'},
  ['--pf-global--palette--light-green-100'] = { ['$value'] = '#e4f5bc'},
  ['--pf-global--palette--light-green-200'] = { ['$value'] = '#c8eb79'},
  ['--pf-global--palette--light-green-300'] = { ['$value'] = '#ace12e'},
  ['--pf-global--palette--light-green-400'] = { ['$value'] = '#92d400'},
  ['--pf-global--palette--light-green-500'] = { ['$value'] = '#6ca100'},
  ['--pf-global--palette--light-green-600'] = { ['$value'] = '#486b00'},
  ['--pf-global--palette--light-green-700'] = { ['$value'] = '#253600'},
  ['--pf-global--palette--orange-50'] = { ['$value'] = '#fff6ec'},
  ['--pf-global--palette--orange-100'] = { ['$value'] = '#f4b678'},
  ['--pf-global--palette--orange-200'] = { ['$value'] = '#ef9234'},
  ['--pf-global--palette--orange-300'] = { ['$value'] = '#ec7a08'},
  ['--pf-global--palette--orange-400'] = { ['$value'] = '#c46100'},
  ['--pf-global--palette--orange-500'] = { ['$value'] = '#8f4700'},
  ['--pf-global--palette--orange-600'] = { ['$value'] = '#773d00'},
  ['--pf-global--palette--orange-700'] = { ['$value'] = '#3b1f00'},
  ['--pf-global--palette--purple-50'] = { ['$value'] = '#f2f0fc'},
  ['--pf-global--palette--purple-100'] = { ['$value'] = '#cbc1ff'},
  ['--pf-global--palette--purple-200'] = { ['$value'] = '#b2a3ff'},
  ['--pf-global--palette--purple-300'] = { ['$value'] = '#a18fff'},
  ['--pf-global--palette--purple-400'] = { ['$value'] = '#8476d1'},
  ['--pf-global--palette--purple-500'] = { ['$value'] = '#6753ac'},
  ['--pf-global--palette--purple-600'] = { ['$value'] = '#40199a'},
  ['--pf-global--palette--purple-700'] = { ['$value'] = '#1f0066'},
  ['--pf-global--palette--red-50'] = { ['$value'] = '#faeae8'},
  ['--pf-global--palette--red-100'] = { ['$value'] = '#c9190b'},
  ['--pf-global--palette--red-200'] = { ['$value'] = '#a30000'},
  ['--pf-global--palette--red-300'] = { ['$value'] = '#7d1007'},
  ['--pf-global--palette--red-400'] = { ['$value'] = '#470000'},
  ['--pf-global--palette--red-500'] = { ['$value'] = '#2c0000'},
  ['--pf-global--palette--white'] = { ['$value'] = '#fff'},
  ['--pf-global--BackgroundColor--100'] = { ['$value'] = '#fff'},
  ['--pf-global--BackgroundColor--150'] = { ['$value'] = '#fafafa'},
  ['--pf-global--BackgroundColor--200'] = { ['$value'] = '#f0f0f0'},
  ['--pf-global--BackgroundColor--light-100'] = { ['$value'] = '#fff'},
  ['--pf-global--BackgroundColor--light-200'] = { ['$value'] = '#fafafa'},
  ['--pf-global--BackgroundColor--light-300'] = { ['$value'] = '#f0f0f0'},
  ['--pf-global--BackgroundColor--dark-100'] = { ['$value'] = '#151515'},
  ['--pf-global--BackgroundColor--dark-200'] = { ['$value'] = '#3c3f42'},
  ['--pf-global--BackgroundColor--dark-300'] = { ['$value'] = '#212427'},
  ['--pf-global--BackgroundColor--dark-400'] = { ['$value'] = '#4f5255'},
  ['--pf-global--BackgroundColor--dark-transparent-100'] = { ['$value'] = '0.62)'},
  ['--pf-global--BackgroundColor--dark-transparent-200'] = { ['$value'] = '0.32)'},
  ['--pf-global--Color--100'] = { ['$value'] = '#151515'},
  ['--pf-global--Color--200'] = { ['$value'] = '#6a6e73'},
  ['--pf-global--Color--300'] = { ['$value'] = '#3c3f42'},
  ['--pf-global--Color--400'] = { ['$value'] = '#8a8d90'},
  ['--pf-global--Color--light-100'] = { ['$value'] = '#fff'},
  ['--pf-global--Color--light-200'] = { ['$value'] = '#f0f0f0'},
  ['--pf-global--Color--light-300'] = { ['$value'] = '#d2d2d2'},
  ['--pf-global--Color--dark-100'] = { ['$value'] = '#151515'},
  ['--pf-global--Color--dark-200'] = { ['$value'] = '#6a6e73'},
  ['--pf-global--active-color--100'] = { ['$value'] = '#06c'},
  ['--pf-global--active-color--200'] = { ['$value'] = '#bee1f4'},
  ['--pf-global--active-color--300'] = { ['$value'] = '#2b9af3'},
  ['--pf-global--active-color--400'] = { ['$value'] = '#73bcf7'},
  ['--pf-global--disabled-color--100'] = { ['$value'] = '#6a6e73'},
  ['--pf-global--disabled-color--200'] = { ['$value'] = '#d2d2d2'},
  ['--pf-global--disabled-color--300'] = { ['$value'] = '#f0f0f0'},
  ['--pf-global--primary-color--100'] = { ['$value'] = '#06c'},
  ['--pf-global--primary-color--200'] = { ['$value'] = '#004080'},
  ['--pf-global--primary-color--light-100'] = { ['$value'] = '#73bcf7'},
  ['--pf-global--primary-color--dark-100'] = { ['$value'] = '#06c'},
  ['--pf-global--secondary-color--100'] = { ['$value'] = '#6a6e73'},
  ['--pf-global--default-color--100'] = { ['$value'] = '#73c5c5'},
  ['--pf-global--default-color--200'] = { ['$value'] = '#009596'},
  ['--pf-global--default-color--300'] = { ['$value'] = '#003737'},
  ['--pf-global--success-color--100'] = { ['$value'] = '#3e8635'},
  ['--pf-global--success-color--200'] = { ['$value'] = '#1e4f18'},
  ['--pf-global--info-color--100'] = { ['$value'] = '#2b9af3'},
  ['--pf-global--info-color--200'] = { ['$value'] = '#002952'},
  ['--pf-global--warning-color--100'] = { ['$value'] = '#f0ab00'},
  ['--pf-global--warning-color--200'] = { ['$value'] = '#795600'},
  ['--pf-global--danger-color--100'] = { ['$value'] = '#c9190b'},
  ['--pf-global--danger-color--200'] = { ['$value'] = '#a30000'},
  ['--pf-global--danger-color--300'] = { ['$value'] = '#470000'},
  ['--pf-global--BoxShadow--sm'] = { ['$value'] = '0.06)'},
  ['--pf-global--BoxShadow--sm-top'] = { ['$value'] = '0.16)'},
  ['--pf-global--BoxShadow--sm-right'] = { ['$value'] = '0.16)'},
  ['--pf-global--BoxShadow--sm-bottom'] = { ['$value'] = '0.16)'},
  ['--pf-global--BoxShadow--sm-left'] = { ['$value'] = '0.16)'},
  ['--pf-global--BoxShadow--md'] = { ['$value'] = '0.06)'},
  ['--pf-global--BoxShadow--md-top'] = { ['$value'] = '0.18)'},
  ['--pf-global--BoxShadow--md-right'] = { ['$value'] = '0.18)'},
  ['--pf-global--BoxShadow--md-bottom'] = { ['$value'] = '0.18)'},
  ['--pf-global--BoxShadow--md-left'] = { ['$value'] = '0.18)'},
  ['--pf-global--BoxShadow--lg'] = { ['$value'] = '0.08)'},
  ['--pf-global--BoxShadow--lg-top'] = { ['$value'] = '0.18)'},
  ['--pf-global--BoxShadow--lg-right'] = { ['$value'] = '0.18)'},
  ['--pf-global--BoxShadow--lg-bottom'] = { ['$value'] = '0.18)'},
  ['--pf-global--BoxShadow--lg-left'] = { ['$value'] = '0.18)'},
  ['--pf-global--BoxShadow--xl'] = { ['$value'] = '0.1)'},
  ['--pf-global--BoxShadow--xl-top'] = { ['$value'] = '0.2)'},
  ['--pf-global--BoxShadow--xl-right'] = { ['$value'] = '0.2)'},
  ['--pf-global--BoxShadow--xl-bottom'] = { ['$value'] = '0.2)'},
  ['--pf-global--BoxShadow--xl-left'] = { ['$value'] = '0.2)'},
  ['--pf-global--BoxShadow--inset'] = { ['$value'] = '0.25)'},
  ['--pf-global--font-path'] = { ['$value'] = '"./assets/fonts"'},
  ['--pf-global--fonticon-path'] = { ['$value'] = '"./assets/pficon"'},
  ['--pf-global--spacer--xs'] = { ['$value'] = '0.25rem'},
  ['--pf-global--spacer--sm'] = { ['$value'] = '0.5rem'},
  ['--pf-global--spacer--md'] = { ['$value'] = '1rem'},
  ['--pf-global--spacer--lg'] = { ['$value'] = '1.5rem'},
  ['--pf-global--spacer--xl'] = { ['$value'] = '2rem'},
  ['--pf-global--spacer--2xl'] = { ['$value'] = '3rem'},
  ['--pf-global--spacer--3xl'] = { ['$value'] = '4rem'},
  ['--pf-global--spacer--4xl'] = { ['$value'] = '5rem'},
  ['--pf-global--spacer--form-element'] = { ['$value'] = '0.375rem'},
  ['--pf-global--gutter'] = { ['$value'] = '1rem'},
  ['--pf-global--gutter--md'] = { ['$value'] = '1.5rem'},
  ['--pf-global--ZIndex--xs'] = { ['$value'] = '100'},
  ['--pf-global--ZIndex--sm'] = { ['$value'] = '200'},
  ['--pf-global--ZIndex--md'] = { ['$value'] = '300'},
  ['--pf-global--ZIndex--lg'] = { ['$value'] = '400'},
  ['--pf-global--ZIndex--xl'] = { ['$value'] = '500'},
  ['--pf-global--ZIndex--2xl'] = { ['$value'] = '600'},
  ['--pf-global--breakpoint--xs'] = { ['$value'] = '0'},
  ['--pf-global--breakpoint--sm'] = { ['$value'] = '576px'},
  ['--pf-global--breakpoint--md'] = { ['$value'] = '768px'},
  ['--pf-global--breakpoint--lg'] = { ['$value'] = '992px'},
  ['--pf-global--breakpoint--xl'] = { ['$value'] = '1200px'},
  ['--pf-global--breakpoint--2xl'] = { ['$value'] = '1450px'},
  ['--pf-global--link--Color'] = { ['$value'] = '#06c'},
  ['--pf-global--link--Color--hover'] = { ['$value'] = '#004080'},
  ['--pf-global--link--Color--light'] = { ['$value'] = '#2b9af3'},
  ['--pf-global--link--Color--light--hover'] = { ['$value'] = '#73bcf7'},
  ['--pf-global--link--Color--dark'] = { ['$value'] = '#06c'},
  ['--pf-global--link--Color--dark--hover'] = { ['$value'] = '#004080'},
  ['--pf-global--link--Color--visited'] = { ['$value'] = '#40199a'},
  ['--pf-global--link--TextDecoration'] = { ['$value'] = 'none'},
  ['--pf-global--link--TextDecoration--hover'] = { ['$value'] = 'underline'},
  ['--pf-global--BorderWidth--sm'] = { ['$value'] = '1px'},
  ['--pf-global--BorderWidth--md'] = { ['$value'] = '2px'},
  ['--pf-global--BorderWidth--lg'] = { ['$value'] = '3px'},
  ['--pf-global--BorderWidth--xl'] = { ['$value'] = '4px'},
  ['--pf-global--BorderColor--100'] = { ['$value'] = '#d2d2d2'},
  ['--pf-global--BorderColor--200'] = { ['$value'] = '#8a8d90'},
  ['--pf-global--BorderColor--300'] = { ['$value'] = '#f0f0f0'},
  ['--pf-global--BorderColor--dark-100'] = { ['$value'] = '#d2d2d2'},
  ['--pf-global--BorderColor--light-100'] = { ['$value'] = '#b8bbbe'},
  ['--pf-global--BorderRadius--sm'] = { ['$value'] = '3px'},
  ['--pf-global--BorderRadius--lg'] = { ['$value'] = '30em'},
  ['--pf-global--icon--Color--light'] = { ['$value'] = '#6a6e73'},
  ['--pf-global--icon--Color--dark'] = { ['$value'] = '#151515'},
  ['--pf-global--icon--FontSize--sm'] = { ['$value'] = '0.625rem'},
  ['--pf-global--icon--FontSize--md'] = { ['$value'] = '1.125rem'},
  ['--pf-global--icon--FontSize--lg'] = { ['$value'] = '1.5rem'},
  ['--pf-global--icon--FontSize--xl'] = { ['$value'] = '3.375rem'},
  ['--pf-global--FontFamily--sans-serif'] = { ['$value'] = 'sans-serif'},
  ['--pf-global--FontFamily--heading--sans-serif'] = { ['$value'] = 'sans-serif'},
  ['--pf-global--FontFamily--monospace'] = { ['$value'] = 'monospace'},
  ['--pf-global--FontFamily--redhat-updated--sans-serif'] = { ['$value'] = 'sans-serif'},
  ['--pf-global--FontFamily--redhat-updated--heading--sans-serif'] = { ['$value'] = 'sans-serif'},
  ['--pf-global--FontFamily--redhat--monospace'] = { ['$value'] = 'monospace'},
  ['--pf-global--FontFamily--redhatVF--sans-serif'] = { ['$value'] = 'sans-serif'},
  ['--pf-global--FontFamily--redhatVF--heading--sans-serif'] = { ['$value'] = 'sans-serif'},
  ['--pf-global--FontFamily--redhatVF--monospace'] = { ['$value'] = 'monospace'},
  ['--pf-global--FontFamily--overpass--sans-serif'] = { ['$value'] = '"Segoe UI Symbol"'},
  ['--pf-global--FontFamily--overpass--monospace'] = { ['$value'] = 'monospace'},
  ['--pf-global--FontSize--4xl'] = { ['$value'] = '2.25rem'},
  ['--pf-global--FontSize--3xl'] = { ['$value'] = '1.75rem'},
  ['--pf-global--FontSize--2xl'] = { ['$value'] = '1.5rem'},
  ['--pf-global--FontSize--xl'] = { ['$value'] = '1.25rem'},
  ['--pf-global--FontSize--lg'] = { ['$value'] = '1.125rem'},
  ['--pf-global--FontSize--md'] = { ['$value'] = '1rem'},
  ['--pf-global--FontSize--sm'] = { ['$value'] = '0.875rem'},
  ['--pf-global--FontSize--xs'] = { ['$value'] = '0.75rem'},
  ['--pf-global--FontWeight--light'] = { ['$value'] = '300'},
  ['--pf-global--FontWeight--normal'] = { ['$value'] = '400'},
  ['--pf-global--FontWeight--semi-bold'] = { ['$value'] = '700'},
  ['--pf-global--FontWeight--overpass--semi-bold'] = { ['$value'] = '500'},
  ['--pf-global--FontWeight--bold'] = { ['$value'] = '700'},
  ['--pf-global--FontWeight--overpass--bold'] = { ['$value'] = '600'},
  ['--pf-global--LineHeight--sm'] = { ['$value'] = '1.3'},
  ['--pf-global--LineHeight--md'] = { ['$value'] = '1.5'},
  ['--pf-global--ListStyle'] = { ['$value'] = 'disc outside'},
  ['--pf-global--Transition'] = { ['$value'] = '1)'},
  ['--pf-global--TimingFunction'] = { ['$value'] = '1)'},
  ['--pf-global--TransitionDuration'] = { ['$value'] = '250ms'},
  ['--pf-global--arrow--width'] = { ['$value'] = '0.9375rem'},
  ['--pf-global--arrow--width-lg'] = { ['$value'] = '1.5625rem'},
  ['--pf-global--target-size--MinWidth'] = { ['$value'] = '44px'},
  ['--pf-global--target-size--MinHeight'] = { ['$value'] = '44px'},
}

command('ToggleCSSTokenFallback', function(args)
  local root = vim.treesitter.get_parser(0, 'css'):parse()[1]:root()
  local query = vim.treesitter.query.get('css', 'custom-property-call')
  if query then
    local line1
    local line2

    if args.range > 0 then
      line1 = args.line1
      line2 = args.line2
    else
      line1 = unpack(vim.api.nvim_win_get_cursor(0))
      line2 = line1
    end

    for id, node in query:iter_captures(root, 0, line1 - 1, line2 - 1) do
      if query.captures[id] == 'args' and node_is_on_line(node, line1, line2) then
        local prop
        local has_fallback
        local argnode = node
        if argnode then
          has_fallback = argnode:named_child_count() > 1
          prop = argnode:named_child(0)

          local token_name = get_node_text(prop, 0)

          local token

          if vim.startswith(token_name, '--pf') then
                token = pfv4_tokens[token_name]
          elseif vim.startswith(token_name, '--rh') then
                token = rhds_tokens[token_name]
          end

          local token_value = token and token['$value']

          if token_value then
            local replacement
            if not has_fallback then
              replacement = '('..token_name..', '..token_value..')'
            else
              replacement = '('..token_name..')'
            end
            local row_start, row_end, col_start, col_end = node:range()
            vim.api.nvim_buf_set_text(0, row_start, row_end, col_start, col_end, {replacement})
          end
        end
      end
    end
  end
end, {
  bang = true,
  range = true,
})

