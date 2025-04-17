local function next_choice()
  local luasnip = require'luasnip'
  if luasnip.in_snippet() then
    luasnip.change_choice(1)
  end
end

local function prev_choice()
  local luasnip = require'luasnip'
  if luasnip.in_snippet() then
    luasnip.change_choice(-1)
  end
end

local function pick_choice()
  local luasnip = require'luasnip'
  if luasnip.in_snippet() then
    require'luasnip.extras.select_choice'()
  end
end

local filetype_extensions = {
  css = { 'css', 'scss' },
  html = { 'css', 'javascript', 'json', 'svg' },
  svg = { 'css', 'html' },
  javascript = { 'html', 'svg' },
  typescript = { 'html', 'svg' },
  markdown = {
    'lua',
    'json',
    'html',
    'svg',
    'yaml',
    'css',
    'typescript',
    'javascript',
  }
}

return { 'L3MON4D3/LuaSnip',
  enabled = true,
  version = '2.*',
  build = 'make install_jsregexp',
  dependencies = { 'bennypowers/design-tokens.nvim' },
  keys = {
    { '<C-j>', next_choice, mode = { 'i' }, desc = 'Luasnip - next choice' },
    { '<C-k>', prev_choice, mode = { 'i' }, desc = 'Luasnip - prev choice' },
    { '<C-e>', pick_choice, mode = { 'i' }, desc = 'Luasnip - pick choice' },
  },
  config = function()
    local ls = require'luasnip'
    local ft = require'luasnip.extras.filetype_functions'
    local lu = require'luasnip.util.types'
    local fl = require'luasnip.loaders.from_lua'
    local fs = require'luasnip.loaders.from_snipmate'

    ls.config.setup {
      history = true,
      native_menu = false,
      updateevents = 'TextChanged,TextChangedI',
      enable_autosnippets = true,
      ext_opts = {
        [lu.choiceNode] = {
          active = {
            virt_text = { { "●", "GruvboxOrange" } }
          }
        }
      },
      ft_func = ft.from_pos,
      load_ft_func = ft.extend_load_ft(filetype_extensions),
    }

    fl.lazy_load()

    fs.lazy_load {
      paths =  { '~/.config/nvim/snippets' },
      fs_event_providers = { libuv = true },
    }

    for filetype, extensions in pairs(filetype_extensions) do
      if #filetype > 0 then
        ls.filetype_extend(filetype, extensions)
      end
    end
  end
}
