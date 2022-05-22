-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = true
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/bennyp/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/bennyp/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/bennyp/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/bennyp/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/bennyp/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["FixCursorHold.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/FixCursorHold.nvim",
    url = "https://github.com/antoinemadec/FixCursorHold.nvim"
  },
  LuaSnip = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["alpha-nvim"] = {
    config = { "require 'config.alpha'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/alpha-nvim",
    url = "https://github.com/bennypowers/alpha-nvim"
  },
  ["bufdelete.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/bufdelete.nvim",
    url = "https://github.com/famiu/bufdelete.nvim"
  },
  ["bufferline.nvim"] = {
    config = { "require 'config.bufferline'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/bufferline.nvim",
    url = "https://github.com/akinsho/bufferline.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-calc"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/cmp-calc",
    url = "https://github.com/hrsh7th/cmp-calc"
  },
  ["cmp-cmdline"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-emoji"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/cmp-emoji",
    url = "https://github.com/hrsh7th/cmp-emoji"
  },
  ["cmp-fish"] = {
    after_files = { "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/cmp-fish/after/plugin/cmp_fish.lua" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/cmp-fish",
    url = "https://github.com/mtoohey31/cmp-fish"
  },
  ["cmp-git"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/cmp-git",
    url = "https://github.com/petertriho/cmp-git"
  },
  ["cmp-npm"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/cmp-npm",
    url = "https://github.com/David-Kunz/cmp-npm"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lsp-signature-help"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp-signature-help",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["cmp-under-comparator"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/cmp-under-comparator",
    url = "https://github.com/lukas-reineke/cmp-under-comparator"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["color-converter.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/color-converter.nvim",
    url = "https://github.com/NTBBloodbath/color-converter.nvim"
  },
  ["dressing.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/dressing.nvim",
    url = "https://github.com/stevearc/dressing.nvim"
  },
  ["fidget.nvim"] = {
    config = { "require 'config.fidget'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/fidget.nvim",
    url = "https://github.com/j-hui/fidget.nvim"
  },
  ["filetype.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/filetype.nvim",
    url = "https://github.com/nathom/filetype.nvim"
  },
  firenvim = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/firenvim",
    url = "https://github.com/glacambre/firenvim"
  },
  ["gh.nvim"] = {
    config = { "require 'config.gh-nvim'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/gh.nvim",
    url = "https://github.com/ldelossa/gh.nvim"
  },
  ["git-conflict.nvim"] = {
    config = { "require 'config.git-conflict-nvim'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/git-conflict.nvim",
    url = "https://github.com/akinsho/git-conflict.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "require 'config.gitsigns'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["goto-preview"] = {
    config = { "require 'config.goto-preview'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/goto-preview",
    url = "https://github.com/rmagatti/goto-preview"
  },
  ["impatient.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/impatient.nvim",
    url = "https://github.com/lewis6991/impatient.nvim"
  },
  ["indent-blankline.nvim"] = {
    config = { "require 'config.indent-blankline'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["legendary.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/legendary.nvim",
    url = "https://github.com/mrjones2014/legendary.nvim"
  },
  ["litee.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/litee.nvim",
    url = "https://github.com/ldelossa/litee.nvim"
  },
  ["lsp-status.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/lsp-status.nvim",
    url = "https://github.com/nvim-lua/lsp-status.nvim"
  },
  ["lsp-trouble.nvim"] = {
    config = { "require 'config.trouble'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/lsp-trouble.nvim",
    url = "https://github.com/folke/lsp-trouble.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/lspkind-nvim",
    url = "https://github.com/onsails/lspkind-nvim"
  },
  ["lua-dev.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/lua-dev.nvim",
    url = "https://github.com/folke/lua-dev.nvim"
  },
  ["lualine.nvim"] = {
    config = { "require 'config.lualine'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["markdown-preview.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/markdown-preview.nvim",
    url = "https://github.com/iamcco/markdown-preview.nvim"
  },
  ["marks.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/marks.nvim",
    url = "https://github.com/chentau/marks.nvim"
  },
  ["matchparen.nvim"] = {
    config = { "require 'config.matchparen'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/matchparen.nvim",
    url = "https://github.com/monkoose/matchparen.nvim"
  },
  ["mini.nvim"] = {
    config = { "require 'config.mini'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/mini.nvim",
    url = "https://github.com/echasnovski/mini.nvim"
  },
  ["modes.nvim"] = {
    config = { "require 'config.modes'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/modes.nvim",
    url = "https://github.com/mvllow/modes.nvim"
  },
  ["neo-tree.nvim"] = {
    config = { "require 'config.neo-tree'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/neo-tree.nvim",
    url = "https://github.com/nvim-neo-tree/neo-tree.nvim"
  },
  ["neovim-session-manager"] = {
    cond = { "\27LJ\2\n5\0\0\1\0\3\0\0056\0\0\0009\0\1\0009\0\2\0\19\0\0\0L\0\2\0\24started_by_firenvim\6g\bvim\0" },
    config = { "require 'config.neovim-session-manager'" },
    loaded = false,
    needs_bufread = false,
    only_cond = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/neovim-session-manager",
    url = "https://github.com/Shatur/neovim-session-manager"
  },
  ["nui.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nui.nvim",
    url = "https://github.com/MunifTanjim/nui.nvim"
  },
  ["nvim-biscuits"] = {
    config = { "require 'config.biscuits'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-biscuits",
    url = "https://github.com/code-biscuits/nvim-biscuits"
  },
  ["nvim-cmp"] = {
    config = { "require 'config.cmp'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-keymap-amend"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-keymap-amend",
    url = "https://github.com/anuvyklack/nvim-keymap-amend"
  },
  ["nvim-lsp-installer"] = {
    config = { "require 'config.lsp'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer",
    url = "https://github.com/williamboman/nvim-lsp-installer"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-luapad"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/nvim-luapad",
    url = "https://github.com/rafcamlet/nvim-luapad"
  },
  ["nvim-luaref"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-luaref",
    url = "https://github.com/milisims/nvim-luaref"
  },
  ["nvim-notify"] = {
    config = { "require 'config.notify'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-notify",
    url = "https://github.com/rcarriga/nvim-notify"
  },
  ["nvim-regexplainer"] = {
    config = { "require 'config.regexplainer'" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/nvim-regexplainer",
    url = "/Users/bennyp/Developer/nvim-regexplainer"
  },
  ["nvim-scrollbar"] = {
    config = { "require 'config.scrollbar'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-scrollbar",
    url = "https://github.com/petertriho/nvim-scrollbar"
  },
  ["nvim-spectre"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/nvim-spectre",
    url = "https://github.com/windwp/nvim-spectre"
  },
  ["nvim-treesitter"] = {
    config = { "require 'config.treesitter'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-endwise"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-treesitter-endwise",
    url = "https://github.com/RRethy/nvim-treesitter-endwise"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  },
  ["nvim-ts-autotag"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-ts-autotag",
    url = "https://github.com/windwp/nvim-ts-autotag"
  },
  ["nvim-web-devicons"] = {
    config = { "require 'config.web-devicons'" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["nvim-window.git"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/nvim-window.git",
    url = "https://gitlab.com/yorickpeterse/nvim-window"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/popup.nvim",
    url = "https://github.com/nvim-lua/popup.nvim"
  },
  ["pretty-fold.nvim"] = {
    config = { "require 'config.prettyfold'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/pretty-fold.nvim",
    url = "https://github.com/anuvyklack/pretty-fold.nvim"
  },
  ["quickmath.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/quickmath.nvim",
    url = "https://github.com/jbyuki/quickmath.nvim"
  },
  ["schemastore.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/schemastore.nvim",
    url = "https://github.com/b0o/schemastore.nvim"
  },
  ["splitjoin.vim"] = {
    config = { "\27LJ\2\nä\1\0\0\6\0\f\0\0256\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\3\0=\1\4\0006\0\0\0009\0\5\0009\0\6\0'\2\a\0'\3\b\0'\4\t\0004\5\0\0B\0\5\0016\0\0\0009\0\5\0009\0\6\0'\2\a\0'\3\n\0'\4\v\0004\5\0\0B\0\5\1K\0\1\0\24:SplitjoinSplit<cr>\ag,\23:SplitjoinJoin<cr>\agj\6n\20nvim_set_keymap\bapi\27splitjoin_join_mapping\5\28splitjoin_split_mapping\6g\bvim\0" },
    keys = { { "", "gj" }, { "", "g," } },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/splitjoin.vim",
    url = "https://github.com/AndrewRadev/splitjoin.vim"
  },
  ["sqlite.lua"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/sqlite.lua",
    url = "https://github.com/tami5/sqlite.lua"
  },
  ["startuptime.vim"] = {
    commands = { "StartupTime" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/startuptime.vim",
    url = "https://github.com/tweekmonster/startuptime.vim"
  },
  ["telescope-frecency.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/telescope-frecency.nvim",
    url = "https://github.com/nvim-telescope/telescope-frecency.nvim"
  },
  ["telescope-heading.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/telescope-heading.nvim",
    url = "https://github.com/crispgm/telescope-heading.nvim"
  },
  ["telescope-symbols.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/telescope-symbols.nvim",
    url = "https://github.com/nvim-telescope/telescope-symbols.nvim"
  },
  ["telescope.nvim"] = {
    config = { "require 'config.telescope'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["telescope_sessions_picker.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/telescope_sessions_picker.nvim",
    url = "https://github.com/JoseConseco/telescope_sessions_picker.nvim"
  },
  ["toggleterm.nvim"] = {
    config = { "require 'config.toggleterm'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/toggleterm.nvim",
    url = "https://github.com/akinsho/toggleterm.nvim"
  },
  ["tokyonight.nvim"] = {
    config = { "require 'config.tokyonight'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/tokyonight.nvim",
    url = "https://github.com/folke/tokyonight.nvim"
  },
  ["trouble.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ["vim-caser"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/vim-caser",
    url = "https://github.com/arthurxavierx/vim-caser"
  },
  ["vim-hexokinase"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/vim-hexokinase",
    url = "https://github.com/RRethy/vim-hexokinase"
  },
  ["vim-html-template-literals"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/vim-html-template-literals",
    url = "https://github.com/jonsmithers/vim-html-template-literals"
  },
  ["vim-illuminate"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/vim-illuminate",
    url = "https://github.com/RRethy/vim-illuminate"
  },
  ["vim-jinja"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/vim-jinja",
    url = "https://github.com/lepture/vim-jinja"
  },
  ["vim-lion"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/vim-lion",
    url = "https://github.com/tommcdo/vim-lion"
  },
  ["vim-textobj-entire"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/vim-textobj-entire",
    url = "https://github.com/kana/vim-textobj-entire"
  },
  ["vim-textobj-user"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/vim-textobj-user",
    url = "https://github.com/kana/vim-textobj-user"
  },
  ["vim-visual-multi"] = {
    keys = { { "", "<c-n>" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/vim-visual-multi",
    url = "https://github.com/mg979/vim-visual-multi"
  },
  ["which-key.nvim"] = {
    config = { "require 'config.whichkey'" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
local module_lazy_loads = {
  ["^nvim%-web%-devicons"] = "nvim-web-devicons",
  ["^nvim%-window"] = "nvim-window.git"
}
local lazy_load_called = {['packer.load'] = true}
local function lazy_load_module(module_name)
  local to_load = {}
  if lazy_load_called[module_name] then return nil end
  lazy_load_called[module_name] = true
  for module_pat, plugin_name in pairs(module_lazy_loads) do
    if not _G.packer_plugins[plugin_name].loaded and string.match(module_name, module_pat) then
      to_load[#to_load + 1] = plugin_name
    end
  end

  if #to_load > 0 then
    require('packer.load')(to_load, {module = module_name}, _G.packer_plugins)
    local loaded_mod = package.loaded[module_name]
    if loaded_mod then
      return function(modname) return loaded_mod end
    end
  end
end

if not vim.g.packer_custom_loader_enabled then
  table.insert(package.loaders, 1, lazy_load_module)
  vim.g.packer_custom_loader_enabled = true
end

-- Config for: neo-tree.nvim
time([[Config for neo-tree.nvim]], true)
require 'config.neo-tree'
time([[Config for neo-tree.nvim]], false)
-- Config for: toggleterm.nvim
time([[Config for toggleterm.nvim]], true)
require 'config.toggleterm'
time([[Config for toggleterm.nvim]], false)
-- Config for: modes.nvim
time([[Config for modes.nvim]], true)
require 'config.modes'
time([[Config for modes.nvim]], false)
-- Config for: nvim-notify
time([[Config for nvim-notify]], true)
require 'config.notify'
time([[Config for nvim-notify]], false)
-- Config for: mini.nvim
time([[Config for mini.nvim]], true)
require 'config.mini'
time([[Config for mini.nvim]], false)
-- Config for: bufferline.nvim
time([[Config for bufferline.nvim]], true)
require 'config.bufferline'
time([[Config for bufferline.nvim]], false)
-- Config for: matchparen.nvim
time([[Config for matchparen.nvim]], true)
require 'config.matchparen'
time([[Config for matchparen.nvim]], false)
-- Config for: alpha-nvim
time([[Config for alpha-nvim]], true)
require 'config.alpha'
time([[Config for alpha-nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
require 'config.telescope'
time([[Config for telescope.nvim]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
require 'config.gitsigns'
time([[Config for gitsigns.nvim]], false)
-- Config for: tokyonight.nvim
time([[Config for tokyonight.nvim]], true)
require 'config.tokyonight'
time([[Config for tokyonight.nvim]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
require 'config.whichkey'
time([[Config for which-key.nvim]], false)
-- Config for: git-conflict.nvim
time([[Config for git-conflict.nvim]], true)
require 'config.git-conflict-nvim'
time([[Config for git-conflict.nvim]], false)
-- Config for: fidget.nvim
time([[Config for fidget.nvim]], true)
require 'config.fidget'
time([[Config for fidget.nvim]], false)
-- Config for: goto-preview
time([[Config for goto-preview]], true)
require 'config.goto-preview'
time([[Config for goto-preview]], false)
-- Config for: gh.nvim
time([[Config for gh.nvim]], true)
require 'config.gh-nvim'
time([[Config for gh.nvim]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
require 'config.cmp'
time([[Config for nvim-cmp]], false)
-- Config for: pretty-fold.nvim
time([[Config for pretty-fold.nvim]], true)
require 'config.prettyfold'
time([[Config for pretty-fold.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
require 'config.treesitter'
time([[Config for nvim-treesitter]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
require 'config.lualine'
time([[Config for lualine.nvim]], false)
-- Config for: nvim-lsp-installer
time([[Config for nvim-lsp-installer]], true)
require 'config.lsp'
time([[Config for nvim-lsp-installer]], false)
-- Config for: lsp-trouble.nvim
time([[Config for lsp-trouble.nvim]], true)
require 'config.trouble'
time([[Config for lsp-trouble.nvim]], false)
-- Config for: indent-blankline.nvim
time([[Config for indent-blankline.nvim]], true)
require 'config.indent-blankline'
time([[Config for indent-blankline.nvim]], false)
-- Config for: nvim-biscuits
time([[Config for nvim-biscuits]], true)
require 'config.biscuits'
time([[Config for nvim-biscuits]], false)
-- Config for: nvim-scrollbar
time([[Config for nvim-scrollbar]], true)
require 'config.scrollbar'
time([[Config for nvim-scrollbar]], false)
-- Conditional loads
time([[Conditional loading of neovim-session-manager]], true)
  require("packer.load")({"neovim-session-manager"}, {}, _G.packer_plugins)
time([[Conditional loading of neovim-session-manager]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file StartupTime lua require("packer.load")({'startuptime.vim'}, { cmd = "StartupTime", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.cmd [[noremap <silent> <c-n> <cmd>lua require("packer.load")({'vim-visual-multi'}, { keys = "<lt>c-n>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> gj <cmd>lua require("packer.load")({'splitjoin.vim'}, { keys = "gj", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> g, <cmd>lua require("packer.load")({'splitjoin.vim'}, { keys = "g,", prefix = "" }, _G.packer_plugins)<cr>]]
time([[Defining lazy-load keymaps]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'telescope-heading.nvim', 'markdown-preview.nvim'}, { ft = "markdown" }, _G.packer_plugins)]]
vim.cmd [[au FileType typescript ++once lua require("packer.load")({'nvim-regexplainer'}, { ft = "typescript" }, _G.packer_plugins)]]
vim.cmd [[au FileType html ++once lua require("packer.load")({'nvim-regexplainer', 'vim-jinja'}, { ft = "html" }, _G.packer_plugins)]]
vim.cmd [[au FileType python ++once lua require("packer.load")({'nvim-regexplainer'}, { ft = "python" }, _G.packer_plugins)]]
vim.cmd [[au FileType jinja ++once lua require("packer.load")({'vim-jinja'}, { ft = "jinja" }, _G.packer_plugins)]]
vim.cmd [[au FileType lua ++once lua require("packer.load")({'lua-dev.nvim'}, { ft = "lua" }, _G.packer_plugins)]]
vim.cmd [[au FileType fish ++once lua require("packer.load")({'cmp-fish'}, { ft = "fish" }, _G.packer_plugins)]]
vim.cmd [[au FileType md ++once lua require("packer.load")({'telescope-heading.nvim', 'markdown-preview.nvim'}, { ft = "md" }, _G.packer_plugins)]]
vim.cmd [[au FileType javascript ++once lua require("packer.load")({'nvim-regexplainer'}, { ft = "javascript" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /Users/bennyp/.local/share/nvim/site/pack/packer/opt/vim-jinja/ftdetect/jinja.vim]], true)
vim.cmd [[source /Users/bennyp/.local/share/nvim/site/pack/packer/opt/vim-jinja/ftdetect/jinja.vim]]
time([[Sourcing ftdetect script at: /Users/bennyp/.local/share/nvim/site/pack/packer/opt/vim-jinja/ftdetect/jinja.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles(1) end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
