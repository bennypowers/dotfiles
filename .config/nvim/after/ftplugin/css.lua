local get_node_text = vim.treesitter.get_node_text

---@param node TSNode
---@param line1 number 1-indexed start row
---@param line2 number 1-indexed end row
local function node_is_on_line(node, line1, line2)
  local row = node:range()
  return row >= line1 - 1 and row <= line2 - 1
end

local pfv4_tokens = {
  ['--pf-global--palette--black-100'] = 'var(--pf-global--palette--black-100, #fafafa)',
  ['--pf-global--palette--black-150'] = 'var(--pf-global--palette--black-150, #f5f5f5)',
  ['--pf-global--palette--black-200'] = 'var(--pf-global--palette--black-200, #f0f0f0)',
  ['--pf-global--palette--black-300'] = 'var(--pf-global--palette--black-300, #d2d2d2)',
  ['--pf-global--palette--black-400'] = 'var(--pf-global--palette--black-400, #b8bbbe)',
  ['--pf-global--palette--black-500'] = 'var(--pf-global--palette--black-500, #8a8d90)',
  ['--pf-global--palette--black-600'] = 'var(--pf-global--palette--black-600, #6a6e73)',
  ['--pf-global--palette--black-700'] = 'var(--pf-global--palette--black-700, #4f5255)',
  ['--pf-global--palette--black-800'] = 'var(--pf-global--palette--black-800, #3c3f42)',
  ['--pf-global--palette--black-850'] = 'var(--pf-global--palette--black-850, #212427)',
  ['--pf-global--palette--black-900'] = 'var(--pf-global--palette--black-900, #151515)',
  ['--pf-global--palette--black-1000'] = 'var(--pf-global--palette--black-1000, #030303)',
  ['--pf-global--palette--blue-50'] = 'var(--pf-global--palette--blue-50, #e7f1fa)',
  ['--pf-global--palette--blue-100'] = 'var(--pf-global--palette--blue-100, #bee1f4)',
  ['--pf-global--palette--blue-200'] = 'var(--pf-global--palette--blue-200, #73bcf7)',
  ['--pf-global--palette--blue-300'] = 'var(--pf-global--palette--blue-300, #2b9af3)',
  ['--pf-global--palette--blue-400'] = 'var(--pf-global--palette--blue-400, #06c)',
  ['--pf-global--palette--blue-500'] = 'var(--pf-global--palette--blue-500, #004080)',
  ['--pf-global--palette--blue-600'] = 'var(--pf-global--palette--blue-600, #002952)',
  ['--pf-global--palette--blue-700'] = 'var(--pf-global--palette--blue-700, #001223)',
  ['--pf-global--palette--cyan-50'] = 'var(--pf-global--palette--cyan-50, #f2f9f9)',
  ['--pf-global--palette--cyan-100'] = 'var(--pf-global--palette--cyan-100, #a2d9d9)',
  ['--pf-global--palette--cyan-200'] = 'var(--pf-global--palette--cyan-200, #73c5c5)',
  ['--pf-global--palette--cyan-300'] = 'var(--pf-global--palette--cyan-300, #009596)',
  ['--pf-global--palette--cyan-400'] = 'var(--pf-global--palette--cyan-400, #005f60)',
  ['--pf-global--palette--cyan-500'] = 'var(--pf-global--palette--cyan-500, #003737)',
  ['--pf-global--palette--cyan-600'] = 'var(--pf-global--palette--cyan-600, #002323)',
  ['--pf-global--palette--cyan-700'] = 'var(--pf-global--palette--cyan-700, #000f0f)',
  ['--pf-global--palette--gold-50'] = 'var(--pf-global--palette--gold-50, #fdf7e7)',
  ['--pf-global--palette--gold-100'] = 'var(--pf-global--palette--gold-100, #f9e0a2)',
  ['--pf-global--palette--gold-200'] = 'var(--pf-global--palette--gold-200, #f6d173)',
  ['--pf-global--palette--gold-300'] = 'var(--pf-global--palette--gold-300, #f4c145)',
  ['--pf-global--palette--gold-400'] = 'var(--pf-global--palette--gold-400, #f0ab00)',
  ['--pf-global--palette--gold-500'] = 'var(--pf-global--palette--gold-500, #c58c00)',
  ['--pf-global--palette--gold-600'] = 'var(--pf-global--palette--gold-600, #795600)',
  ['--pf-global--palette--gold-700'] = 'var(--pf-global--palette--gold-700, #3d2c00)',
  ['--pf-global--palette--green-50'] = 'var(--pf-global--palette--green-50, #f3faf2)',
  ['--pf-global--palette--green-100'] = 'var(--pf-global--palette--green-100, #bde5b8)',
  ['--pf-global--palette--green-200'] = 'var(--pf-global--palette--green-200, #95d58e)',
  ['--pf-global--palette--green-300'] = 'var(--pf-global--palette--green-300, #6ec664)',
  ['--pf-global--palette--green-400'] = 'var(--pf-global--palette--green-400, #5ba352)',
  ['--pf-global--palette--green-500'] = 'var(--pf-global--palette--green-500, #3e8635)',
  ['--pf-global--palette--green-600'] = 'var(--pf-global--palette--green-600, #1e4f18)',
  ['--pf-global--palette--green-700'] = 'var(--pf-global--palette--green-700, #0f280d)',
  ['--pf-global--palette--light-blue-100'] = 'var(--pf-global--palette--light-blue-100, #beedf9)',
  ['--pf-global--palette--light-blue-200'] = 'var(--pf-global--palette--light-blue-200, #7cdbf3)',
  ['--pf-global--palette--light-blue-300'] = 'var(--pf-global--palette--light-blue-300, #35caed)',
  ['--pf-global--palette--light-blue-400'] = 'var(--pf-global--palette--light-blue-400, #00b9e4)',
  ['--pf-global--palette--light-blue-500'] = 'var(--pf-global--palette--light-blue-500, #008bad)',
  ['--pf-global--palette--light-blue-600'] = 'var(--pf-global--palette--light-blue-600, #005c73)',
  ['--pf-global--palette--light-blue-700'] = 'var(--pf-global--palette--light-blue-700, #002d39)',
  ['--pf-global--palette--light-green-100'] = 'var(--pf-global--palette--light-green-100, #e4f5bc)',
  ['--pf-global--palette--light-green-200'] = 'var(--pf-global--palette--light-green-200, #c8eb79)',
  ['--pf-global--palette--light-green-300'] = 'var(--pf-global--palette--light-green-300, #ace12e)',
  ['--pf-global--palette--light-green-400'] = 'var(--pf-global--palette--light-green-400, #92d400)',
  ['--pf-global--palette--light-green-500'] = 'var(--pf-global--palette--light-green-500, #6ca100)',
  ['--pf-global--palette--light-green-600'] = 'var(--pf-global--palette--light-green-600, #486b00)',
  ['--pf-global--palette--light-green-700'] = 'var(--pf-global--palette--light-green-700, #253600)',
  ['--pf-global--palette--orange-50'] = 'var(--pf-global--palette--orange-50, #fff6ec)',
  ['--pf-global--palette--orange-100'] = 'var(--pf-global--palette--orange-100, #f4b678)',
  ['--pf-global--palette--orange-200'] = 'var(--pf-global--palette--orange-200, #ef9234)',
  ['--pf-global--palette--orange-300'] = 'var(--pf-global--palette--orange-300, #ec7a08)',
  ['--pf-global--palette--orange-400'] = 'var(--pf-global--palette--orange-400, #c46100)',
  ['--pf-global--palette--orange-500'] = 'var(--pf-global--palette--orange-500, #8f4700)',
  ['--pf-global--palette--orange-600'] = 'var(--pf-global--palette--orange-600, #773d00)',
  ['--pf-global--palette--orange-700'] = 'var(--pf-global--palette--orange-700, #3b1f00)',
  ['--pf-global--palette--purple-50'] = 'var(--pf-global--palette--purple-50, #f2f0fc)',
  ['--pf-global--palette--purple-100'] = 'var(--pf-global--palette--purple-100, #cbc1ff)',
  ['--pf-global--palette--purple-200'] = 'var(--pf-global--palette--purple-200, #b2a3ff)',
  ['--pf-global--palette--purple-300'] = 'var(--pf-global--palette--purple-300, #a18fff)',
  ['--pf-global--palette--purple-400'] = 'var(--pf-global--palette--purple-400, #8476d1)',
  ['--pf-global--palette--purple-500'] = 'var(--pf-global--palette--purple-500, #6753ac)',
  ['--pf-global--palette--purple-600'] = 'var(--pf-global--palette--purple-600, #40199a)',
  ['--pf-global--palette--purple-700'] = 'var(--pf-global--palette--purple-700, #1f0066)',
  ['--pf-global--palette--red-50'] = 'var(--pf-global--palette--red-50, #faeae8)',
  ['--pf-global--palette--red-100'] = 'var(--pf-global--palette--red-100, #c9190b)',
  ['--pf-global--palette--red-200'] = 'var(--pf-global--palette--red-200, #a30000)',
  ['--pf-global--palette--red-300'] = 'var(--pf-global--palette--red-300, #7d1007)',
  ['--pf-global--palette--red-400'] = 'var(--pf-global--palette--red-400, #470000)',
  ['--pf-global--palette--red-500'] = 'var(--pf-global--palette--red-500, #2c0000)',
  ['--pf-global--palette--white'] = 'var(--pf-global--palette--white, #fff)',
  ['--pf-global--BackgroundColor--100'] = 'var(--pf-global--BackgroundColor--100, #fff)',
  ['--pf-global--BackgroundColor--150'] = 'var(--pf-global--BackgroundColor--150, #fafafa)',
  ['--pf-global--BackgroundColor--200'] = 'var(--pf-global--BackgroundColor--200, #f0f0f0)',
  ['--pf-global--BackgroundColor--light-100'] = 'var(--pf-global--BackgroundColor--light-100, #fff)',
  ['--pf-global--BackgroundColor--light-200'] = 'var(--pf-global--BackgroundColor--light-200, #fafafa)',
  ['--pf-global--BackgroundColor--light-300'] = 'var(--pf-global--BackgroundColor--light-300, #f0f0f0)',
  ['--pf-global--BackgroundColor--dark-100'] = 'var(--pf-global--BackgroundColor--dark-100, #151515)',
  ['--pf-global--BackgroundColor--dark-200'] = 'var(--pf-global--BackgroundColor--dark-200, #3c3f42)',
  ['--pf-global--BackgroundColor--dark-300'] = 'var(--pf-global--BackgroundColor--dark-300, #212427)',
  ['--pf-global--BackgroundColor--dark-400'] = 'var(--pf-global--BackgroundColor--dark-400, #4f5255)',
  ['--pf-global--BackgroundColor--dark-transparent-100'] = 'var(--pf-global--BackgroundColor--dark-transparent-100, rgba(3, 3, 3, 0.62))',
  ['--pf-global--BackgroundColor--dark-transparent-200'] = 'var(--pf-global--BackgroundColor--dark-transparent-200, rgba(3, 3, 3, 0.32))',
  ['--pf-global--Color--100'] = 'var(--pf-global--Color--100, #151515)',
  ['--pf-global--Color--200'] = 'var(--pf-global--Color--200, #6a6e73)',
  ['--pf-global--Color--300'] = 'var(--pf-global--Color--300, #3c3f42)',
  ['--pf-global--Color--400'] = 'var(--pf-global--Color--400, #8a8d90)',
  ['--pf-global--Color--light-100'] = 'var(--pf-global--Color--light-100, #fff)',
  ['--pf-global--Color--light-200'] = 'var(--pf-global--Color--light-200, #f0f0f0)',
  ['--pf-global--Color--light-300'] = 'var(--pf-global--Color--light-300, #d2d2d2)',
  ['--pf-global--Color--dark-100'] = 'var(--pf-global--Color--dark-100, #151515)',
  ['--pf-global--Color--dark-200'] = 'var(--pf-global--Color--dark-200, #6a6e73)',
  ['--pf-global--active-color--100'] = 'var(--pf-global--active-color--100, #06c)',
  ['--pf-global--active-color--200'] = 'var(--pf-global--active-color--200, #bee1f4)',
  ['--pf-global--active-color--300'] = 'var(--pf-global--active-color--300, #2b9af3)',
  ['--pf-global--active-color--400'] = 'var(--pf-global--active-color--400, #73bcf7)',
  ['--pf-global--disabled-color--100'] = 'var(--pf-global--disabled-color--100, #6a6e73)',
  ['--pf-global--disabled-color--200'] = 'var(--pf-global--disabled-color--200, #d2d2d2)',
  ['--pf-global--disabled-color--300'] = 'var(--pf-global--disabled-color--300, #f0f0f0)',
  ['--pf-global--primary-color--100'] = 'var(--pf-global--primary-color--100, #06c)',
  ['--pf-global--primary-color--200'] = 'var(--pf-global--primary-color--200, #004080)',
  ['--pf-global--primary-color--light-100'] = 'var(--pf-global--primary-color--light-100, #73bcf7)',
  ['--pf-global--primary-color--dark-100'] = 'var(--pf-global--primary-color--dark-100, #06c)',
  ['--pf-global--secondary-color--100'] = 'var(--pf-global--secondary-color--100, #6a6e73)',
  ['--pf-global--default-color--100'] = 'var(--pf-global--default-color--100, #73c5c5)',
  ['--pf-global--default-color--200'] = 'var(--pf-global--default-color--200, #009596)',
  ['--pf-global--default-color--300'] = 'var(--pf-global--default-color--300, #003737)',
  ['--pf-global--success-color--100'] = 'var(--pf-global--success-color--100, #3e8635)',
  ['--pf-global--success-color--200'] = 'var(--pf-global--success-color--200, #1e4f18)',
  ['--pf-global--info-color--100'] = 'var(--pf-global--info-color--100, #2b9af3)',
  ['--pf-global--info-color--200'] = 'var(--pf-global--info-color--200, #002952)',
  ['--pf-global--warning-color--100'] = 'var(--pf-global--warning-color--100, #f0ab00)',
  ['--pf-global--warning-color--200'] = 'var(--pf-global--warning-color--200, #795600)',
  ['--pf-global--danger-color--100'] = 'var(--pf-global--danger-color--100, #c9190b)',
  ['--pf-global--danger-color--200'] = 'var(--pf-global--danger-color--200, #a30000)',
  ['--pf-global--danger-color--300'] = 'var(--pf-global--danger-color--300, #470000)',
  ['--pf-global--BoxShadow--sm'] = 'var(--pf-global--BoxShadow--sm, 0 0.0625rem 0.125rem 0 rgba(3, 3, 3, 0.12), 0 0 0.125rem 0 rgba(3, 3, 3, 0.06))',
  ['--pf-global--BoxShadow--sm-top'] = 'var(--pf-global--BoxShadow--sm-top, 0 -0.125rem 0.25rem -0.0625rem rgba(3, 3, 3, 0.16))',
  ['--pf-global--BoxShadow--sm-right'] = 'var(--pf-global--BoxShadow--sm-right, 0.125rem 0 0.25rem -0.0625rem rgba(3, 3, 3, 0.16))',
  ['--pf-global--BoxShadow--sm-bottom'] = 'var(--pf-global--BoxShadow--sm-bottom, 0 0.125rem 0.25rem -0.0625rem rgba(3, 3, 3, 0.16))',
  ['--pf-global--BoxShadow--sm-left'] = 'var(--pf-global--BoxShadow--sm-left, -0.125rem 0 0.25rem -0.0625rem rgba(3, 3, 3, 0.16))',
  ['--pf-global--BoxShadow--md'] = 'var(--pf-global--BoxShadow--md, 0 0.25rem 0.5rem 0rem rgba(3, 3, 3, 0.12), 0 0 0.25rem 0 rgba(3, 3, 3, 0.06))',
  ['--pf-global--BoxShadow--md-top'] = 'var(--pf-global--BoxShadow--md-top, 0 -0.5rem 0.5rem -0.375rem rgba(3, 3, 3, 0.18))',
  ['--pf-global--BoxShadow--md-right'] = 'var(--pf-global--BoxShadow--md-right, 0.5rem 0 0.5rem -0.375rem rgba(3, 3, 3, 0.18))',
  ['--pf-global--BoxShadow--md-bottom'] = 'var(--pf-global--BoxShadow--md-bottom, 0 0.5rem 0.5rem -0.375rem rgba(3, 3, 3, 0.18))',
  ['--pf-global--BoxShadow--md-left'] = 'var(--pf-global--BoxShadow--md-left, -0.5rem 0 0.5rem -0.375rem rgba(3, 3, 3, 0.18))',
  ['--pf-global--BoxShadow--lg'] = 'var(--pf-global--BoxShadow--lg, 0 0.5rem 1rem 0 rgba(3, 3, 3, 0.16), 0 0 0.375rem 0 rgba(3, 3, 3, 0.08))',
  ['--pf-global--BoxShadow--lg-top'] = 'var(--pf-global--BoxShadow--lg-top, 0 -0.75rem 0.75rem -0.5rem rgba(3, 3, 3, 0.18))',
  ['--pf-global--BoxShadow--lg-right'] = 'var(--pf-global--BoxShadow--lg-right, 0.75rem 0 0.75rem -0.5rem rgba(3, 3, 3, 0.18))',
  ['--pf-global--BoxShadow--lg-bottom'] = 'var(--pf-global--BoxShadow--lg-bottom, 0 0.75rem 0.75rem -0.5rem rgba(3, 3, 3, 0.18))',
  ['--pf-global--BoxShadow--lg-left'] = 'var(--pf-global--BoxShadow--lg-left, -0.75rem 0 0.75rem -0.5rem rgba(3, 3, 3, 0.18))',
  ['--pf-global--BoxShadow--xl'] = 'var(--pf-global--BoxShadow--xl, 0 1rem 2rem 0 rgba(3, 3, 3, 0.16), 0 0 0.5rem 0 rgba(3, 3, 3, 0.1))',
  ['--pf-global--BoxShadow--xl-top'] = 'var(--pf-global--BoxShadow--xl-top, 0 -1rem 1rem -0.5rem rgba(3, 3, 3, 0.2))',
  ['--pf-global--BoxShadow--xl-right'] = 'var(--pf-global--BoxShadow--xl-right, 1rem 0 1rem -0.5rem rgba(3, 3, 3, 0.2))',
  ['--pf-global--BoxShadow--xl-bottom'] = 'var(--pf-global--BoxShadow--xl-bottom, 0 1rem 1rem -0.5rem rgba(3, 3, 3, 0.2))',
  ['--pf-global--BoxShadow--xl-left'] = 'var(--pf-global--BoxShadow--xl-left, -1rem 0 1rem -0.5rem rgba(3, 3, 3, 0.2))',
  ['--pf-global--BoxShadow--inset'] = 'var(--pf-global--BoxShadow--inset, inset 0 0 0.625rem 0 rgba(3, 3, 3, 0.25))',
  ['--pf-global--font-path'] = 'var(--pf-global--font-path, "./assets/fonts")',
  ['--pf-global--fonticon-path'] = 'var(--pf-global--fonticon-path, "./assets/pficon")',
  ['--pf-global--spacer--xs'] = 'var(--pf-global--spacer--xs, 0.25rem)',
  ['--pf-global--spacer--sm'] = 'var(--pf-global--spacer--sm, 0.5rem)',
  ['--pf-global--spacer--md'] = 'var(--pf-global--spacer--md, 1rem)',
  ['--pf-global--spacer--lg'] = 'var(--pf-global--spacer--lg, 1.5rem)',
  ['--pf-global--spacer--xl'] = 'var(--pf-global--spacer--xl, 2rem)',
  ['--pf-global--spacer--2xl'] = 'var(--pf-global--spacer--2xl, 3rem)',
  ['--pf-global--spacer--3xl'] = 'var(--pf-global--spacer--3xl, 4rem)',
  ['--pf-global--spacer--4xl'] = 'var(--pf-global--spacer--4xl, 5rem)',
  ['--pf-global--spacer--form-element'] = 'var(--pf-global--spacer--form-element, 0.375rem)',
  ['--pf-global--gutter'] = 'var(--pf-global--gutter, 1rem)',
  ['--pf-global--gutter--md'] = 'var(--pf-global--gutter--md, 1.5rem)',
  ['--pf-global--ZIndex--xs'] = 'var(--pf-global--ZIndex--xs, 100)',
  ['--pf-global--ZIndex--sm'] = 'var(--pf-global--ZIndex--sm, 200)',
  ['--pf-global--ZIndex--md'] = 'var(--pf-global--ZIndex--md, 300)',
  ['--pf-global--ZIndex--lg'] = 'var(--pf-global--ZIndex--lg, 400)',
  ['--pf-global--ZIndex--xl'] = 'var(--pf-global--ZIndex--xl, 500)',
  ['--pf-global--ZIndex--2xl'] = 'var(--pf-global--ZIndex--2xl, 600)',
  ['--pf-global--breakpoint--xs'] = 'var(--pf-global--breakpoint--xs, 0)',
  ['--pf-global--breakpoint--sm'] = 'var(--pf-global--breakpoint--sm, 576px)',
  ['--pf-global--breakpoint--md'] = 'var(--pf-global--breakpoint--md, 768px)',
  ['--pf-global--breakpoint--lg'] = 'var(--pf-global--breakpoint--lg, 992px)',
  ['--pf-global--breakpoint--xl'] = 'var(--pf-global--breakpoint--xl, 1200px)',
  ['--pf-global--breakpoint--2xl'] = 'var(--pf-global--breakpoint--2xl, 1450px)',
  ['--pf-global--link--Color'] = 'var(--pf-global--link--Color, #06c)',
  ['--pf-global--link--Color--hover'] = 'var(--pf-global--link--Color--hover, #004080)',
  ['--pf-global--link--Color--light'] = 'var(--pf-global--link--Color--light, #2b9af3)',
  ['--pf-global--link--Color--light--hover'] = 'var(--pf-global--link--Color--light--hover, #73bcf7)',
  ['--pf-global--link--Color--dark'] = 'var(--pf-global--link--Color--dark, #06c)',
  ['--pf-global--link--Color--dark--hover'] = 'var(--pf-global--link--Color--dark--hover, #004080)',
  ['--pf-global--link--Color--visited'] = 'var(--pf-global--link--Color--visited, #40199a)',
  ['--pf-global--link--TextDecoration'] = 'var(--pf-global--link--TextDecoration, none)',
  ['--pf-global--link--TextDecoration--hover'] = 'var(--pf-global--link--TextDecoration--hover, underline)',
  ['--pf-global--BorderWidth--sm'] = 'var(--pf-global--BorderWidth--sm, 1px)',
  ['--pf-global--BorderWidth--md'] = 'var(--pf-global--BorderWidth--md, 2px)',
  ['--pf-global--BorderWidth--lg'] = 'var(--pf-global--BorderWidth--lg, 3px)',
  ['--pf-global--BorderWidth--xl'] = 'var(--pf-global--BorderWidth--xl, 4px)',
  ['--pf-global--BorderColor--100'] = 'var(--pf-global--BorderColor--100, #d2d2d2)',
  ['--pf-global--BorderColor--200'] = 'var(--pf-global--BorderColor--200, #8a8d90)',
  ['--pf-global--BorderColor--300'] = 'var(--pf-global--BorderColor--300, #f0f0f0)',
  ['--pf-global--BorderColor--dark-100'] = 'var(--pf-global--BorderColor--dark-100, #d2d2d2)',
  ['--pf-global--BorderColor--light-100'] = 'var(--pf-global--BorderColor--light-100, #b8bbbe)',
  ['--pf-global--BorderRadius--sm'] = 'var(--pf-global--BorderRadius--sm, 3px)',
  ['--pf-global--BorderRadius--lg'] = 'var(--pf-global--BorderRadius--lg, 30em)',
  ['--pf-global--icon--Color--light'] = 'var(--pf-global--icon--Color--light, #6a6e73)',
  ['--pf-global--icon--Color--dark'] = 'var(--pf-global--icon--Color--dark, #151515)',
  ['--pf-global--icon--FontSize--sm'] = 'var(--pf-global--icon--FontSize--sm, 0.625rem)',
  ['--pf-global--icon--FontSize--md'] = 'var(--pf-global--icon--FontSize--md, 1.125rem)',
  ['--pf-global--icon--FontSize--lg'] = 'var(--pf-global--icon--FontSize--lg, 1.5rem)',
  ['--pf-global--icon--FontSize--xl'] = 'var(--pf-global--icon--FontSize--xl, 3.375rem)',
  ['--pf-global--FontFamily--sans-serif'] = 'var(--pf-global--FontFamily--sans-serif, "RedHatText", "Overpass", overpass, helvetica, arial, sans-serif)',
  ['--pf-global--FontFamily--heading--sans-serif'] = 'var(--pf-global--FontFamily--heading--sans-serif, "RedHatDisplay", "Overpass", overpass, helvetica, arial, sans-serif)',
  ['--pf-global--FontFamily--monospace'] = 'var(--pf-global--FontFamily--monospace, "Liberation Mono", consolas, "SFMono-Regular", menlo, monaco, "Courier New", monospace)',
  ['--pf-global--FontFamily--redhat-updated--sans-serif'] = 'var(--pf-global--FontFamily--redhat-updated--sans-serif, "RedHatTextUpdated", "Overpass", overpass, helvetica, arial, sans-serif)',
  ['--pf-global--FontFamily--redhat-updated--heading--sans-serif'] = 'var(--pf-global--FontFamily--redhat-updated--heading--sans-serif, "RedHatDisplayUpdated", "Overpass", overpass, helvetica, arial, sans-serif)',
  ['--pf-global--FontFamily--redhat--monospace'] = 'var(--pf-global--FontFamily--redhat--monospace, "RedHatMono", "Liberation Mono", consolas, "SFMono-Regular", menlo, monaco, "Courier New", monospace)',
  ['--pf-global--FontFamily--redhatVF--sans-serif'] = 'var(--pf-global--FontFamily--redhatVF--sans-serif, "RedHatTextVF", "RedHatText", "Overpass", overpass, helvetica, arial, sans-serif)',
  ['--pf-global--FontFamily--redhatVF--heading--sans-serif'] = 'var(--pf-global--FontFamily--redhatVF--heading--sans-serif, "RedHatDisplayVF", "RedHatDisplay", "Overpass", overpass, helvetica, arial, sans-serif)',
  ['--pf-global--FontFamily--redhatVF--monospace'] = 'var(--pf-global--FontFamily--redhatVF--monospace, "RedHatMonoVF", "RedHatMono", "Liberation Mono", consolas, "SFMono-Regular", menlo, monaco, "Courier New", monospace)',
  ['--pf-global--FontFamily--overpass--sans-serif'] = 'var(--pf-global--FontFamily--overpass--sans-serif, "overpass", overpass, "open sans", -apple-system, blinkmacsystemfont, "Segoe UI", roboto, "Helvetica Neue", arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol")',
  ['--pf-global--FontFamily--overpass--monospace'] = 'var(--pf-global--FontFamily--overpass--monospace, "overpass-mono", overpass-mono, "SFMono-Regular", menlo, monaco, consolas, "Liberation Mono", "Courier New", monospace)',
  ['--pf-global--FontSize--4xl'] = 'var(--pf-global--FontSize--4xl, 2.25rem)',
  ['--pf-global--FontSize--3xl'] = 'var(--pf-global--FontSize--3xl, 1.75rem)',
  ['--pf-global--FontSize--2xl'] = 'var(--pf-global--FontSize--2xl, 1.5rem)',
  ['--pf-global--FontSize--xl'] = 'var(--pf-global--FontSize--xl, 1.25rem)',
  ['--pf-global--FontSize--lg'] = 'var(--pf-global--FontSize--lg, 1.125rem)',
  ['--pf-global--FontSize--md'] = 'var(--pf-global--FontSize--md, 1rem)',
  ['--pf-global--FontSize--sm'] = 'var(--pf-global--FontSize--sm, 0.875rem)',
  ['--pf-global--FontSize--xs'] = 'var(--pf-global--FontSize--xs, 0.75rem)',
  ['--pf-global--FontWeight--light'] = 'var(--pf-global--FontWeight--light, 300)',
  ['--pf-global--FontWeight--normal'] = 'var(--pf-global--FontWeight--normal, 400)',
  ['--pf-global--FontWeight--semi-bold'] = 'var(--pf-global--FontWeight--semi-bold, 700)',
  ['--pf-global--FontWeight--overpass--semi-bold'] = 'var(--pf-global--FontWeight--overpass--semi-bold, 500)',
  ['--pf-global--FontWeight--bold'] = 'var(--pf-global--FontWeight--bold, 700)',
  ['--pf-global--FontWeight--overpass--bold'] = 'var(--pf-global--FontWeight--overpass--bold, 600)',
  ['--pf-global--LineHeight--sm'] = 'var(--pf-global--LineHeight--sm, 1.3)',
  ['--pf-global--LineHeight--md'] = 'var(--pf-global--LineHeight--md, 1.5)',
  ['--pf-global--ListStyle'] = 'var(--pf-global--ListStyle, disc outside)',
  ['--pf-global--Transition'] = 'var(--pf-global--Transition, all 250ms cubic-bezier(0.42, 0, 0.58, 1))',
  ['--pf-global--TimingFunction'] = 'var(--pf-global--TimingFunction, cubic-bezier(0.645, 0.045, 0.355, 1))',
  ['--pf-global--TransitionDuration'] = 'var(--pf-global--TransitionDuration, 250ms)',
  ['--pf-global--arrow--width'] = 'var(--pf-global--arrow--width, 0.9375rem)',
  ['--pf-global--arrow--width-lg'] = 'var(--pf-global--arrow--width-lg, 1.5625rem)',
  ['--pf-global--target-size--MinWidth'] = 'var(--pf-global--target-size--MinWidth, 44px)',
  ['--pf-global--target-size--MinHeight'] = 'var(--pf-global--target-size--MinHeight, 44px)',
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

          local prop_name = get_node_text(prop, 0)
          local prop_value = pfv4_tokens[prop_name]

          if prop_name then
            local replacement
            if not has_fallback then
              if not prop_value then
                print(prop_name, )
              else
                replacement = prop_value:gsub('^var','')
              end
            else
              replacement = '('..prop_name..')'
            end
            if replacement then
              local row_start, row_end, col_start, col_end = node:range()
              vim.api.nvim_buf_set_text(0, row_start, row_end, col_start, col_end, {replacement})
            end
          end
        end
      end
    end
  end
end, {
  bang = true,
  range = true,
})

