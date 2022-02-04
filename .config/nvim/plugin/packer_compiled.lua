-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
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
  ["auto-session"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/auto-session",
    url = "https://github.com/rmagatti/auto-session"
  },
  ["bufferline.nvim"] = {
    config = { "\27LJ\2\n†\2\0\0\a\0\v\0\0176\0\0\0'\2\1\0B\0\2\0026\1\2\0009\1\3\1'\3\4\0B\1\2\0019\1\5\0005\3\t\0005\4\6\0004\5\3\0005\6\a\0>\6\1\5=\5\b\4=\4\n\3B\1\2\1K\0\1\0\foptions\1\0\0\foffsets\1\0\3\ttext\nFiles\rfiletype\rneo-tree\15text_align\vcenter\1\0\4\20show_close_icon\2\fnumbers\tnone\22show_buffer_icons\2\16diagnostics\rnvim_lsp\nsetup*source ~/.config/nvim/config/bbye.vim\bcmd\bvim\15bufferline\frequire\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/bufferline.nvim",
    url = "https://github.com/akinsho/bufferline.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-cmdline"] = {
    config = { "\27LJ\2\n÷\1\0\0\n\0\r\0\0286\0\0\0'\2\1\0B\0\2\0029\1\2\0009\1\3\1'\3\4\0005\4\6\0004\5\3\0005\6\5\0>\6\1\5=\5\a\4B\1\3\0019\1\2\0009\1\3\1'\3\b\0005\4\f\0009\5\t\0009\5\a\0054\a\3\0005\b\n\0>\b\1\a4\b\3\0005\t\v\0>\t\1\bB\5\3\2=\5\a\4B\1\3\1K\0\1\0\1\0\0\1\0\1\tname\fcmdline\1\0\1\tname\tpath\vconfig\6:\fsources\1\0\0\1\0\1\tname\vbuffer\6/\fcmdline\nsetup\bcmp\frequire\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["cmp-snippy"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/cmp-snippy",
    url = "https://github.com/dcampos/cmp-snippy"
  },
  ["emmet-vim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/emmet-vim",
    url = "https://github.com/mattn/emmet-vim"
  },
  ["fine-cmdline.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/fine-cmdline.nvim",
    url = "https://github.com/VonHeikemen/fine-cmdline.nvim"
  },
  firenvim = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/firenvim",
    url = "https://github.com/glacambre/firenvim"
  },
  ["lsp-status.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/lsp-status.nvim",
    url = "https://github.com/nvim-lua/lsp-status.nvim"
  },
  ["lsp-trouble.nvim"] = {
    config = { "\27LJ\2\nw\0\0\4\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\3\0B\1\2\1K\0\1\0\1\0\4\17auto_preview\2\15auto_close\2\14auto_open\2\25use_diagnostic_signs\1\nsetup\ftrouble\frequire\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/lsp-trouble.nvim",
    url = "https://github.com/folke/lsp-trouble.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/lspkind-nvim",
    url = "https://github.com/onsails/lspkind-nvim"
  },
  ["markdown-preview.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/markdown-preview.nvim",
    url = "https://github.com/iamcco/markdown-preview.nvim"
  },
  ["matchparen.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/matchparen.nvim",
    url = "https://github.com/monkoose/matchparen.nvim"
  },
  ["neo-tree.nvim"] = {
    config = { "\27LJ\2\n≤\1\0\0\3\0\6\0\n6\0\0\0009\0\1\0009\0\2\0\a\0\3\0X\0\4Ä6\0\0\0009\0\4\0'\2\5\0B\0\2\1K\0\1\0j                  setlocal nocursorcolumn\n                  setlocal virtualedit=all\n                \bcmd\rneo-tree\rfiletype\abo\bvim†\r\1\0\b\0$\00056\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\3\0'\2\4\0B\0\2\0029\1\5\0005\3\6\0005\4\a\0005\5\b\0=\5\t\0045\5\n\0005\6\v\0=\6\f\5=\5\r\0045\5\20\0004\6\a\0005\a\14\0>\a\1\0065\a\15\0>\a\2\0065\a\16\0>\a\3\0065\a\17\0>\a\4\0065\a\18\0>\a\5\0065\a\19\0>\a\6\6=\6\21\5=\5\22\4=\4\23\0035\4\24\0005\5\25\0005\6\26\0=\6\f\5=\5\r\4=\4\27\0035\4\30\0005\5\28\0005\6\29\0=\6\f\5=\5\r\4=\4\31\0034\4\3\0005\5 \0003\6!\0=\6\"\5>\5\1\4=\4#\3B\1\2\1K\0\1\0\19event_handlers\fhandler\0\1\0\1\nevent\21vim_buffer_enter\15git_status\1\0\0\1\0\18\6S\15open_split\6c\22copy_to_clipboard\t<cr>\topen\agg\24git_commit_and_push\6r\vrename\6d\vdelete\6R\frefresh\6p\25paste_from_clipboard\agp\rgit_push\6C\15close_node\agc\15git_commit\6s\16open_vsplit\agr\20git_revert_file\18<2-LeftMouse>\topen\aga\17git_add_file\6x\21cut_to_clipboard\agu\21git_unstage_file\6A\16git_add_all\1\0\1\rposition\nfloat\fbuffers\1\0\r\6S\15open_split\6.\rset_root\6c\22copy_to_clipboard\6s\16open_vsplit\t<cr>\topen\18<2-LeftMouse>\topen\6d\vdelete\6x\21cut_to_clipboard\6a\badd\6R\frefresh\6p\25paste_from_clipboard\6r\vrename\t<bs>\16navigate_up\1\0\1\rposition\tleft\1\0\1\18show_unloaded\1\15filesystem\14renderers\14directory\1\0\0\1\2\1\0\16diagnostics\16errors_only\2\1\2\1\0\14clipboard\14highlight\19NeoTreeDimText\1\2\1\0\19symlink_target\14highlight\30NeoTreeSymbolicLinkTarget\1\2\0\0\tname\1\2\0\0\19current_filter\1\2\3\0\ticon\fpadding\6 \16folder_open\bÔÅº\18folder_closed\bÔÑî\vwindow\rmappings\1\0\20\6S\15open_split\6.\rset_root\n<c-x>\17clear_filter\6a\badd\6r\vrename\6d\vdelete\6c\22copy_to_clipboard\6p\25paste_from_clipboard\6R\frefresh\6I\21toggle_gitignore\6H\18toggle_hidden\t<bs>\16navigate_up\6/\23filter_as_you_type\6C\15close_node\6f\21filter_on_submit\6s\16open_vsplit\t<cr>\topen\18<2-LeftMouse>\topen\6x\21cut_to_clipboard\abd\18buffer_delete\1\0\2\rposition\tleft\nwidth\3(\ffilters\1\0\2\16show_hidden\2\22respect_gitignore\2\1\0\2\27use_libuv_file_watcher\2\24follow_current_file\2\1\0\3\22enable_git_status\2\23popup_border_style\frounded\23enable_diagnostics\2\nsetup\rneo-tree\frequiret        hi link NeoTreeDirectoryName Directory\n        hi link NeoTreeDirectoryIcon NeoTreeDirectoryName\n      \bcmd\bvim\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/neo-tree.nvim",
    url = "https://github.com/nvim-neo-tree/neo-tree.nvim"
  },
  neoformat = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/neoformat",
    url = "https://github.com/sbdchd/neoformat"
  },
  ["nightfox.nvim"] = {
    config = { "\27LJ\2\n±\3\0\0\a\0\18\0\0316\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\1\3\1B\1\1\0029\2\4\0005\4\5\0005\5\6\0=\5\a\0044\5\0\0=\5\b\0045\5\t\0=\5\n\0045\5\f\0005\6\v\0=\6\r\0055\6\14\0=\6\15\5=\5\16\4B\2\2\0019\2\3\0B\2\1\0016\2\0\0'\4\17\0B\2\2\0029\2\4\2B\2\1\1K\0\1\0\15matchparen\rhlgroups\16LspCodeLens\1\0\2\nstyle\vitalic\abg\n${bg}\21TSPunctDelimiter\1\0\0\1\0\1\afg\v${red}\vcolors\1\0\4\vbg_alt\f#010101\abg\f#000000\17bg_highlight\f#121820\14bg_visual\f#131b24\finverse\vstyles\1\0\3\rcomments\vitalic\14functions\16italic,bold\rkeywords\tbold\1\0\2\bfox\fduskfox\valt_nc\2\nsetup\tload\20nightfox.colors\rnightfox\frequire\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nightfox.nvim",
    url = "https://github.com/EdenEast/nightfox.nvim"
  },
  ["nui.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nui.nvim",
    url = "https://github.com/MunifTanjim/nui.nvim"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\2\n1\0\1\4\1\2\0\5-\1\0\0009\1\0\0019\3\1\0B\1\2\1K\0\1\0\2¿\tbody\19expand_snippetà\5\1\0\f\0)\0Q6\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0026\2\0\0'\4\3\0B\2\2\0029\3\4\0005\5\b\0005\6\6\0003\a\5\0=\a\a\6=\6\t\0055\6\r\0009\a\n\0009\t\n\0009\t\v\t)\v¸ˇB\t\2\0025\n\f\0B\a\3\2=\a\14\0069\a\n\0009\t\n\0009\t\v\t)\v\4\0B\t\2\0025\n\15\0B\a\3\2=\a\16\0069\a\n\0009\t\n\0009\t\17\tB\t\1\0025\n\18\0B\a\3\2=\a\19\0069\a\20\0009\a\21\a=\a\22\0069\a\n\0005\t\24\0009\n\n\0009\n\23\nB\n\1\2=\n\25\t9\n\n\0009\n\26\nB\n\1\2=\n\27\tB\a\2\2=\a\28\0069\a\n\0009\a\29\a5\t\30\0B\a\2\2=\a\31\6=\6\n\0059\6\20\0009\6 \0064\b\3\0005\t!\0>\t\1\b5\t\"\0>\t\2\b4\t\3\0005\n#\0>\n\1\tB\6\3\2=\6 \0055\6&\0009\a$\0015\t%\0B\a\2\2=\a'\6=\6(\5B\3\2\0012\0\0ÄK\0\1\0\15formatting\vformat\1\0\0\1\0\2\rmaxwidth\0032\14with_text\1\15cmp_format\1\0\1\tname\vbuffer\1\0\1\tname\vsnippy\1\0\1\tname\rnvim_lsp\fsources\t<CR>\1\0\1\vselect\2\fconfirm\n<C-e>\6c\nclose\6i\1\0\0\nabort\n<C-y>\fdisable\vconfig\16<C-S-Space>\1\3\0\0\6i\6c\rcomplete\n<C-f>\1\3\0\0\6i\6c\n<C-b>\1\0\0\1\3\0\0\6i\6c\16scroll_docs\fmapping\fsnippet\1\0\0\vexpand\1\0\0\0\nsetup\vsnippy\flspkind\bcmp\frequire\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-lsp-installer"] = {
    config = { "\27LJ\2\n#\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\blsp\frequire\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer",
    url = "https://github.com/williamboman/nvim-lsp-installer"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-notify"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-notify",
    url = "https://github.com/rcarriga/nvim-notify"
  },
  ["nvim-snippy"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-snippy",
    url = "https://github.com/dcampos/nvim-snippy"
  },
  ["nvim-spectre"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-spectre",
    url = "https://github.com/windwp/nvim-spectre"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\nΩ\2\0\0\b\0\14\0\0276\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0026\2\0\0'\4\3\0B\2\2\0029\3\4\0004\5\0\0B\3\2\0019\3\4\0015\5\5\0B\3\2\0019\3\4\0025\5\t\0005\6\6\0005\a\a\0=\a\b\6=\6\n\0055\6\v\0=\6\f\0054\6\0\0=\6\r\5B\3\2\1K\0\1\0\fexclude\vexpand\1\5\0\0\rfunction\vmethod\ntable\17if_statement\fdimming\1\0\2\fcontext\3\n\15treesitter\2\ncolor\1\3\0\0\vNormal\f#ffffff\1\0\2\rinactive\1\nalpha\4\0ÄÄ¿˛\3\1\0\1\bkey\6h\nsetup\rtwilight\24pretty-fold.preview\16pretty-fold\frequire\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
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
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/pretty-fold.nvim",
    url = "https://github.com/anuvyklack/pretty-fold.nvim"
  },
  ["telescope-symbols.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/telescope-symbols.nvim",
    url = "https://github.com/nvim-telescope/telescope-symbols.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n¶\4\0\0\t\0\27\0 6\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\2\3\0005\4\19\0005\5\5\0005\6\4\0=\6\6\0055\6\a\0=\6\b\0055\6\16\0005\a\n\0009\b\t\1=\b\v\a9\b\f\1=\b\r\a9\b\14\1=\b\15\a=\a\17\6=\6\18\5=\5\20\0045\5\22\0005\6\21\0=\6\23\0055\6\24\0=\6\25\5=\5\26\4B\2\2\1K\0\1\0\fpickers\30lsp_workspace_diagnostics\1\0\1\ntheme\rdropdown\21lsp_code_actions\1\0\0\1\0\1\ntheme\vcursor\rdefaults\1\0\0\rmappings\6i\1\0\0\n<esc>\nclose\n<C-j>\24move_selection_next\n<C-k>\1\0\0\28move_selection_previous\25file_ignore_patterns\1\3\0\0\t.git\17node_modules\22vimgrep_arguments\1\0\1\18prompt_prefix\nüîé \1\n\0\0\arg\18--color=never\17--no-heading\20--with-filename\18--line-number\r--column\17--smart-case\r--ignore\r--hidden\nsetup\22telescope.actions\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["trouble.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ["twilight.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/twilight.nvim",
    url = "https://github.com/folke/twilight.nvim"
  },
  ["vgit.nvim"] = {
    config = { "\27LJ\2\nÔ\4\0\2\22\0\26\3Z9\2\0\0019\3\1\0\5\2\3\0X\4\1Ä'\3\2\0006\4\3\0009\4\4\0046\6\3\0009\6\5\6B\6\1\0029\a\6\0B\4\3\2\25\4\0\0044\5\a\0005\6\a\0>\6\1\0055\6\b\0>\6\2\0055\6\t\0>\6\3\0055\6\n\0>\6\4\0055\6\v\0>\6\5\0055\6\f\0>\6\6\5)\6\1\0008\a\6\5:\b\1\a:\t\2\a)\n\1\0\1\4\n\0X\n\nÄ\21\n\5\0\4\6\n\0X\n\aÄU\n\6Ä8\a\6\5:\b\1\a:\t\2\a\"\4\b\4\22\6\1\6X\nÛ9\n\r\0009\v\14\0\14\0\v\0X\v\bÄ'\3\2\0'\n\15\0006\v\16\0009\v\17\v'\r\18\0\18\14\3\0\18\15\n\0D\v\4\0)\vˇ\0\21\f\n\0\1\v\f\0X\f\aÄ\18\14\n\0009\f\19\n)\15\1\0\18\16\v\0B\f\4\2'\r\20\0&\n\r\f6\f\16\0009\f\17\f'\14\21\0\18\15\3\0006\16\16\0009\16\17\16'\18\22\0)\19\0\0\3\19\4\0X\19\6Ä6\19\23\0009\19\24\19\22\21\2\4B\19\2\2\14\0\19\0X\20\4Ä6\19\23\0009\19\25\19\23\21\2\4B\19\2\2\18\20\t\0B\16\4\2\18\17\n\0D\f\5\0\tceil\nfloor\tmath\14%s %s ago\19 %s, %s ‚Ä¢ %s\b...\bsub\15 %s ‚Ä¢ %s\vformat\vstring\24Uncommitted changes\14committed\19commit_message\1\3\0\0\3<\fseconds\1\3\0\0\3<\fminutes\1\3\0\0\3\24\nhours\1\3\0\0\3\30\tdays\1\3\0\0\3\f\vmonths\1\3\0\0\3\1\nyears\16author_time\ttime\rdifftime\aos\bYou\vauthor\14user.nameÄ‘\29\2\1ÄÄÄˇ\3§\f\1\0\b\0002\00096\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\0035\4\19\0005\5\6\0005\6\a\0=\6\b\0055\6\t\0=\6\n\0055\6\v\0=\6\f\0055\6\r\0=\6\14\0055\6\15\0=\6\16\0055\6\17\0=\6\18\5=\5\20\0045\5\21\0003\6\22\0=\6\23\5=\5\24\0045\5\25\0=\5\26\0045\5\27\0=\5\28\0045\5\29\0=\5\30\0045\5\31\0005\6!\0005\a \0=\a\"\0065\a#\0=\a$\0065\a%\0=\a\n\0065\a&\0=\a\14\0065\a'\0=\a\f\6=\6(\0055\6*\0005\a)\0=\a\30\0065\a+\0=\a,\6=\6-\5=\5.\0045\5/\0=\0050\4=\0041\3B\1\2\1K\0\1\0\rsettings\fsymbols\1\0\1\tvoid\b‚£ø\nsigns\nusage\tmain\1\0\3\vchange\19GitSignsChange\vremove\19GitSignsDelete\badd\16GitSignsAdd\1\0\0\1\0\2\vremove\21GitSignsDeleteLn\badd\18GitSignsAddLn\16definitions\1\0\2\ttext\b‚îÉ\vtexthl\19GitSignsChange\1\0\2\ttext\b‚îÉ\vtexthl\19GitSignsDelete\1\0\2\ttext\b‚îÉ\vtexthl\16GitSignsAdd\21GitSignsDeleteLn\1\0\2\vlinehl\21GitSignsDeleteLn\ttext\5\18GitSignsAddLn\1\0\0\1\0\2\vlinehl\18GitSignsAddLn\ttext\5\1\0\1\rpriority\3\n\vscreen\1\0\1\20diff_preference\funified\25authorship_code_lens\1\0\1\fenabled\2\16live_gutter\1\0\1\fenabled\2\15live_blame\vformat\0\1\0\1\fenabled\2\bhls\1\0\0\18GitWordDelete\1\0\2\roverride\1\abg\f#960f3d\15GitWordAdd\1\0\2\roverride\1\abg\f#5d7a22\19GitSignsDelete\1\0\2\afg\f#e95678\roverride\1\19GitSignsChange\1\0\2\afg\f#7AA6DA\roverride\1\16GitSignsAdd\1\0\2\afg\f#d7ffaf\roverride\1\27GitBackgroundSecondary\1\0\1\roverride\1\1\0\6\25GitBackgroundPrimary\16NormalFloat\18GitSignsAddLn\fDiffAdd\21GitSignsDeleteLn\15DiffDelete\15GitComment\fComment\14GitLineNr\vLineNr\14GitBorder\vLineNr\fkeymaps\1\0\0\1\0\14\17n <leader>gu\17buffer_reset\17n <leader>gf\24buffer_diff_preview\17n <leader>gg buffer_gutter_blame_preview\17n <leader>gb\25buffer_blame_preview\17n <leader>gl\26project_hunks_preview\17n <leader>gp\24buffer_hunk_preview\17n <leader>gd\25project_diff_preview\17n <leader>gr\22buffer_hunk_reset\17n <leader>gq\21project_hunks_qf\17n <leader>gs\22buffer_hunk_stage\17n <leader>gx\27toggle_diff_preference\fn <C-j>\14hunk_down\fn <C-k>\fhunk_up\17n <leader>gh\27buffer_history_preview\nsetup\tvgit\frequire\0" },
    loaded = true,
    needs_bufread = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/vgit.nvim",
    url = "https://github.com/tanvirtin/vgit.nvim"
  },
  ["vim-airline"] = {
    loaded = true,
    needs_bufread = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/vim-airline",
    url = "https://github.com/vim-airline/vim-airline"
  },
  ["vim-airline-themes"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/vim-airline-themes",
    url = "https://github.com/vim-airline/vim-airline-themes"
  },
  ["vim-closer"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/vim-closer",
    url = "https://github.com/rstacruz/vim-closer"
  },
  ["vim-closetag"] = {
    loaded = true,
    needs_bufread = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/vim-closetag",
    url = "https://github.com/alvan/vim-closetag"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/vim-commentary",
    url = "https://github.com/tpope/vim-commentary"
  },
  ["vim-devicons"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/vim-devicons",
    url = "https://github.com/ryanoasis/vim-devicons"
  },
  ["vim-fish"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/vim-fish",
    url = "https://github.com/dag/vim-fish"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-hexokinase"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/vim-hexokinase",
    url = "https://github.com/rrethy/vim-hexokinase"
  },
  ["vim-html-template-literals"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/vim-html-template-literals",
    url = "https://github.com/jonsmithers/vim-html-template-literals"
  },
  ["vim-jinja"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/vim-jinja",
    url = "https://github.com/lepture/vim-jinja"
  },
  ["vim-polyglot"] = {
    loaded = true,
    needs_bufread = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/vim-polyglot",
    url = "https://github.com/sheerun/vim-polyglot"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-sayonara"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/vim-sayonara",
    url = "https://github.com/mhinz/vim-sayonara"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  ["vim-visual-multi"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/vim-visual-multi",
    url = "https://github.com/mg979/vim-visual-multi"
  }
}

time([[Defining packer_plugins]], false)
-- Setup for: vim-polyglot
time([[Setup for vim-polyglot]], true)
try_loadstring('\27LJ\2\nÃ\1\0\0\2\0\4\0\0056\0\0\0009\0\1\0005\1\3\0=\1\2\0K\0\1\0\1\17\0\0\bcss\tscss\thtml\vpython\14py=python\ash\fbash=sh\tfish\15typescript\18ts=typescript\15javascript\18js=javascript\20json=javascript\fgraphql\16gql=graphql\bvim"vim_markdown_fenced_languages\6g\bvim\0', "setup", "vim-polyglot")
time([[Setup for vim-polyglot]], false)
time([[packadd for vim-polyglot]], true)
vim.cmd [[packadd vim-polyglot]]
time([[packadd for vim-polyglot]], false)
-- Setup for: vgit.nvim
time([[Setup for vgit.nvim]], true)
try_loadstring("\27LJ\2\nh\0\0\2\0\a\0\r6\0\0\0009\0\1\0)\1,\1=\1\2\0006\0\0\0009\0\1\0+\1\1\0=\1\3\0006\0\0\0009\0\4\0'\1\6\0=\1\5\0K\0\1\0\byes\15signcolumn\awo\14incsearch\15updatetime\6o\bvim\0", "setup", "vgit.nvim")
time([[Setup for vgit.nvim]], false)
time([[packadd for vgit.nvim]], true)
vim.cmd [[packadd vgit.nvim]]
time([[packadd for vgit.nvim]], false)
-- Setup for: vim-airline
time([[Setup for vim-airline]], true)
try_loadstring("\27LJ\2\n¢\1\0\0\2\0\5\0\r6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\0\0009\0\1\0)\1\1\0=\1\4\0K\0\1\0\28airline_powerline_fonts*webdevicons_enable_airline_statusline'webdevicons_enable_airline_tabline\6g\bvim\0", "setup", "vim-airline")
time([[Setup for vim-airline]], false)
time([[packadd for vim-airline]], true)
vim.cmd [[packadd vim-airline]]
time([[packadd for vim-airline]], false)
-- Setup for: vim-closetag
time([[Setup for vim-closetag]], true)
try_loadstring("\27LJ\2\nß\1\0\0\2\0\6\0\t6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0K\0\1\0(html,xhtml,phtml,md,js,ts,njk,jinja\23closetag_filetypes0*.html,*.xhtml,*.phtml,*.md,*.ts,*.js,*.njk\23closetag_filenames\6g\bvim\0", "setup", "vim-closetag")
time([[Setup for vim-closetag]], false)
time([[packadd for vim-closetag]], true)
vim.cmd [[packadd vim-closetag]]
time([[packadd for vim-closetag]], false)
-- Config for: neo-tree.nvim
time([[Config for neo-tree.nvim]], true)
try_loadstring("\27LJ\2\n≤\1\0\0\3\0\6\0\n6\0\0\0009\0\1\0009\0\2\0\a\0\3\0X\0\4Ä6\0\0\0009\0\4\0'\2\5\0B\0\2\1K\0\1\0j                  setlocal nocursorcolumn\n                  setlocal virtualedit=all\n                \bcmd\rneo-tree\rfiletype\abo\bvim†\r\1\0\b\0$\00056\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\3\0'\2\4\0B\0\2\0029\1\5\0005\3\6\0005\4\a\0005\5\b\0=\5\t\0045\5\n\0005\6\v\0=\6\f\5=\5\r\0045\5\20\0004\6\a\0005\a\14\0>\a\1\0065\a\15\0>\a\2\0065\a\16\0>\a\3\0065\a\17\0>\a\4\0065\a\18\0>\a\5\0065\a\19\0>\a\6\6=\6\21\5=\5\22\4=\4\23\0035\4\24\0005\5\25\0005\6\26\0=\6\f\5=\5\r\4=\4\27\0035\4\30\0005\5\28\0005\6\29\0=\6\f\5=\5\r\4=\4\31\0034\4\3\0005\5 \0003\6!\0=\6\"\5>\5\1\4=\4#\3B\1\2\1K\0\1\0\19event_handlers\fhandler\0\1\0\1\nevent\21vim_buffer_enter\15git_status\1\0\0\1\0\18\6S\15open_split\6c\22copy_to_clipboard\t<cr>\topen\agg\24git_commit_and_push\6r\vrename\6d\vdelete\6R\frefresh\6p\25paste_from_clipboard\agp\rgit_push\6C\15close_node\agc\15git_commit\6s\16open_vsplit\agr\20git_revert_file\18<2-LeftMouse>\topen\aga\17git_add_file\6x\21cut_to_clipboard\agu\21git_unstage_file\6A\16git_add_all\1\0\1\rposition\nfloat\fbuffers\1\0\r\6S\15open_split\6.\rset_root\6c\22copy_to_clipboard\6s\16open_vsplit\t<cr>\topen\18<2-LeftMouse>\topen\6d\vdelete\6x\21cut_to_clipboard\6a\badd\6R\frefresh\6p\25paste_from_clipboard\6r\vrename\t<bs>\16navigate_up\1\0\1\rposition\tleft\1\0\1\18show_unloaded\1\15filesystem\14renderers\14directory\1\0\0\1\2\1\0\16diagnostics\16errors_only\2\1\2\1\0\14clipboard\14highlight\19NeoTreeDimText\1\2\1\0\19symlink_target\14highlight\30NeoTreeSymbolicLinkTarget\1\2\0\0\tname\1\2\0\0\19current_filter\1\2\3\0\ticon\fpadding\6 \16folder_open\bÔÅº\18folder_closed\bÔÑî\vwindow\rmappings\1\0\20\6S\15open_split\6.\rset_root\n<c-x>\17clear_filter\6a\badd\6r\vrename\6d\vdelete\6c\22copy_to_clipboard\6p\25paste_from_clipboard\6R\frefresh\6I\21toggle_gitignore\6H\18toggle_hidden\t<bs>\16navigate_up\6/\23filter_as_you_type\6C\15close_node\6f\21filter_on_submit\6s\16open_vsplit\t<cr>\topen\18<2-LeftMouse>\topen\6x\21cut_to_clipboard\abd\18buffer_delete\1\0\2\rposition\tleft\nwidth\3(\ffilters\1\0\2\16show_hidden\2\22respect_gitignore\2\1\0\2\27use_libuv_file_watcher\2\24follow_current_file\2\1\0\3\22enable_git_status\2\23popup_border_style\frounded\23enable_diagnostics\2\nsetup\rneo-tree\frequiret        hi link NeoTreeDirectoryName Directory\n        hi link NeoTreeDirectoryIcon NeoTreeDirectoryName\n      \bcmd\bvim\0", "config", "neo-tree.nvim")
time([[Config for neo-tree.nvim]], false)
-- Config for: nvim-lsp-installer
time([[Config for nvim-lsp-installer]], true)
try_loadstring("\27LJ\2\n#\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\blsp\frequire\0", "config", "nvim-lsp-installer")
time([[Config for nvim-lsp-installer]], false)
-- Config for: lsp-trouble.nvim
time([[Config for lsp-trouble.nvim]], true)
try_loadstring("\27LJ\2\nw\0\0\4\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\3\0B\1\2\1K\0\1\0\1\0\4\17auto_preview\2\15auto_close\2\14auto_open\2\25use_diagnostic_signs\1\nsetup\ftrouble\frequire\0", "config", "lsp-trouble.nvim")
time([[Config for lsp-trouble.nvim]], false)
-- Config for: vgit.nvim
time([[Config for vgit.nvim]], true)
try_loadstring("\27LJ\2\nÔ\4\0\2\22\0\26\3Z9\2\0\0019\3\1\0\5\2\3\0X\4\1Ä'\3\2\0006\4\3\0009\4\4\0046\6\3\0009\6\5\6B\6\1\0029\a\6\0B\4\3\2\25\4\0\0044\5\a\0005\6\a\0>\6\1\0055\6\b\0>\6\2\0055\6\t\0>\6\3\0055\6\n\0>\6\4\0055\6\v\0>\6\5\0055\6\f\0>\6\6\5)\6\1\0008\a\6\5:\b\1\a:\t\2\a)\n\1\0\1\4\n\0X\n\nÄ\21\n\5\0\4\6\n\0X\n\aÄU\n\6Ä8\a\6\5:\b\1\a:\t\2\a\"\4\b\4\22\6\1\6X\nÛ9\n\r\0009\v\14\0\14\0\v\0X\v\bÄ'\3\2\0'\n\15\0006\v\16\0009\v\17\v'\r\18\0\18\14\3\0\18\15\n\0D\v\4\0)\vˇ\0\21\f\n\0\1\v\f\0X\f\aÄ\18\14\n\0009\f\19\n)\15\1\0\18\16\v\0B\f\4\2'\r\20\0&\n\r\f6\f\16\0009\f\17\f'\14\21\0\18\15\3\0006\16\16\0009\16\17\16'\18\22\0)\19\0\0\3\19\4\0X\19\6Ä6\19\23\0009\19\24\19\22\21\2\4B\19\2\2\14\0\19\0X\20\4Ä6\19\23\0009\19\25\19\23\21\2\4B\19\2\2\18\20\t\0B\16\4\2\18\17\n\0D\f\5\0\tceil\nfloor\tmath\14%s %s ago\19 %s, %s ‚Ä¢ %s\b...\bsub\15 %s ‚Ä¢ %s\vformat\vstring\24Uncommitted changes\14committed\19commit_message\1\3\0\0\3<\fseconds\1\3\0\0\3<\fminutes\1\3\0\0\3\24\nhours\1\3\0\0\3\30\tdays\1\3\0\0\3\f\vmonths\1\3\0\0\3\1\nyears\16author_time\ttime\rdifftime\aos\bYou\vauthor\14user.nameÄ‘\29\2\1ÄÄÄˇ\3§\f\1\0\b\0002\00096\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\0035\4\19\0005\5\6\0005\6\a\0=\6\b\0055\6\t\0=\6\n\0055\6\v\0=\6\f\0055\6\r\0=\6\14\0055\6\15\0=\6\16\0055\6\17\0=\6\18\5=\5\20\0045\5\21\0003\6\22\0=\6\23\5=\5\24\0045\5\25\0=\5\26\0045\5\27\0=\5\28\0045\5\29\0=\5\30\0045\5\31\0005\6!\0005\a \0=\a\"\0065\a#\0=\a$\0065\a%\0=\a\n\0065\a&\0=\a\14\0065\a'\0=\a\f\6=\6(\0055\6*\0005\a)\0=\a\30\0065\a+\0=\a,\6=\6-\5=\5.\0045\5/\0=\0050\4=\0041\3B\1\2\1K\0\1\0\rsettings\fsymbols\1\0\1\tvoid\b‚£ø\nsigns\nusage\tmain\1\0\3\vchange\19GitSignsChange\vremove\19GitSignsDelete\badd\16GitSignsAdd\1\0\0\1\0\2\vremove\21GitSignsDeleteLn\badd\18GitSignsAddLn\16definitions\1\0\2\ttext\b‚îÉ\vtexthl\19GitSignsChange\1\0\2\ttext\b‚îÉ\vtexthl\19GitSignsDelete\1\0\2\ttext\b‚îÉ\vtexthl\16GitSignsAdd\21GitSignsDeleteLn\1\0\2\vlinehl\21GitSignsDeleteLn\ttext\5\18GitSignsAddLn\1\0\0\1\0\2\vlinehl\18GitSignsAddLn\ttext\5\1\0\1\rpriority\3\n\vscreen\1\0\1\20diff_preference\funified\25authorship_code_lens\1\0\1\fenabled\2\16live_gutter\1\0\1\fenabled\2\15live_blame\vformat\0\1\0\1\fenabled\2\bhls\1\0\0\18GitWordDelete\1\0\2\roverride\1\abg\f#960f3d\15GitWordAdd\1\0\2\roverride\1\abg\f#5d7a22\19GitSignsDelete\1\0\2\afg\f#e95678\roverride\1\19GitSignsChange\1\0\2\afg\f#7AA6DA\roverride\1\16GitSignsAdd\1\0\2\afg\f#d7ffaf\roverride\1\27GitBackgroundSecondary\1\0\1\roverride\1\1\0\6\25GitBackgroundPrimary\16NormalFloat\18GitSignsAddLn\fDiffAdd\21GitSignsDeleteLn\15DiffDelete\15GitComment\fComment\14GitLineNr\vLineNr\14GitBorder\vLineNr\fkeymaps\1\0\0\1\0\14\17n <leader>gu\17buffer_reset\17n <leader>gf\24buffer_diff_preview\17n <leader>gg buffer_gutter_blame_preview\17n <leader>gb\25buffer_blame_preview\17n <leader>gl\26project_hunks_preview\17n <leader>gp\24buffer_hunk_preview\17n <leader>gd\25project_diff_preview\17n <leader>gr\22buffer_hunk_reset\17n <leader>gq\21project_hunks_qf\17n <leader>gs\22buffer_hunk_stage\17n <leader>gx\27toggle_diff_preference\fn <C-j>\14hunk_down\fn <C-k>\fhunk_up\17n <leader>gh\27buffer_history_preview\nsetup\tvgit\frequire\0", "config", "vgit.nvim")
time([[Config for vgit.nvim]], false)
-- Config for: nightfox.nvim
time([[Config for nightfox.nvim]], true)
try_loadstring("\27LJ\2\n±\3\0\0\a\0\18\0\0316\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\1\3\1B\1\1\0029\2\4\0005\4\5\0005\5\6\0=\5\a\0044\5\0\0=\5\b\0045\5\t\0=\5\n\0045\5\f\0005\6\v\0=\6\r\0055\6\14\0=\6\15\5=\5\16\4B\2\2\0019\2\3\0B\2\1\0016\2\0\0'\4\17\0B\2\2\0029\2\4\2B\2\1\1K\0\1\0\15matchparen\rhlgroups\16LspCodeLens\1\0\2\nstyle\vitalic\abg\n${bg}\21TSPunctDelimiter\1\0\0\1\0\1\afg\v${red}\vcolors\1\0\4\vbg_alt\f#010101\abg\f#000000\17bg_highlight\f#121820\14bg_visual\f#131b24\finverse\vstyles\1\0\3\rcomments\vitalic\14functions\16italic,bold\rkeywords\tbold\1\0\2\bfox\fduskfox\valt_nc\2\nsetup\tload\20nightfox.colors\rnightfox\frequire\0", "config", "nightfox.nvim")
time([[Config for nightfox.nvim]], false)
-- Config for: bufferline.nvim
time([[Config for bufferline.nvim]], true)
try_loadstring("\27LJ\2\n†\2\0\0\a\0\v\0\0176\0\0\0'\2\1\0B\0\2\0026\1\2\0009\1\3\1'\3\4\0B\1\2\0019\1\5\0005\3\t\0005\4\6\0004\5\3\0005\6\a\0>\6\1\5=\5\b\4=\4\n\3B\1\2\1K\0\1\0\foptions\1\0\0\foffsets\1\0\3\ttext\nFiles\rfiletype\rneo-tree\15text_align\vcenter\1\0\4\20show_close_icon\2\fnumbers\tnone\22show_buffer_icons\2\16diagnostics\rnvim_lsp\nsetup*source ~/.config/nvim/config/bbye.vim\bcmd\bvim\15bufferline\frequire\0", "config", "bufferline.nvim")
time([[Config for bufferline.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n¶\4\0\0\t\0\27\0 6\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\2\3\0005\4\19\0005\5\5\0005\6\4\0=\6\6\0055\6\a\0=\6\b\0055\6\16\0005\a\n\0009\b\t\1=\b\v\a9\b\f\1=\b\r\a9\b\14\1=\b\15\a=\a\17\6=\6\18\5=\5\20\0045\5\22\0005\6\21\0=\6\23\0055\6\24\0=\6\25\5=\5\26\4B\2\2\1K\0\1\0\fpickers\30lsp_workspace_diagnostics\1\0\1\ntheme\rdropdown\21lsp_code_actions\1\0\0\1\0\1\ntheme\vcursor\rdefaults\1\0\0\rmappings\6i\1\0\0\n<esc>\nclose\n<C-j>\24move_selection_next\n<C-k>\1\0\0\28move_selection_previous\25file_ignore_patterns\1\3\0\0\t.git\17node_modules\22vimgrep_arguments\1\0\1\18prompt_prefix\nüîé \1\n\0\0\arg\18--color=never\17--no-heading\20--with-filename\18--line-number\r--column\17--smart-case\r--ignore\r--hidden\nsetup\22telescope.actions\14telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: cmp-cmdline
time([[Config for cmp-cmdline]], true)
try_loadstring("\27LJ\2\n÷\1\0\0\n\0\r\0\0286\0\0\0'\2\1\0B\0\2\0029\1\2\0009\1\3\1'\3\4\0005\4\6\0004\5\3\0005\6\5\0>\6\1\5=\5\a\4B\1\3\0019\1\2\0009\1\3\1'\3\b\0005\4\f\0009\5\t\0009\5\a\0054\a\3\0005\b\n\0>\b\1\a4\b\3\0005\t\v\0>\t\1\bB\5\3\2=\5\a\4B\1\3\1K\0\1\0\1\0\0\1\0\1\tname\fcmdline\1\0\1\tname\tpath\vconfig\6:\fsources\1\0\0\1\0\1\tname\vbuffer\6/\fcmdline\nsetup\bcmp\frequire\0", "config", "cmp-cmdline")
time([[Config for cmp-cmdline]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\nΩ\2\0\0\b\0\14\0\0276\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0026\2\0\0'\4\3\0B\2\2\0029\3\4\0004\5\0\0B\3\2\0019\3\4\0015\5\5\0B\3\2\0019\3\4\0025\5\t\0005\6\6\0005\a\a\0=\a\b\6=\6\n\0055\6\v\0=\6\f\0054\6\0\0=\6\r\5B\3\2\1K\0\1\0\fexclude\vexpand\1\5\0\0\rfunction\vmethod\ntable\17if_statement\fdimming\1\0\2\fcontext\3\n\15treesitter\2\ncolor\1\3\0\0\vNormal\f#ffffff\1\0\2\rinactive\1\nalpha\4\0ÄÄ¿˛\3\1\0\1\bkey\6h\nsetup\rtwilight\24pretty-fold.preview\16pretty-fold\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\n1\0\1\4\1\2\0\5-\1\0\0009\1\0\0019\3\1\0B\1\2\1K\0\1\0\2¿\tbody\19expand_snippetà\5\1\0\f\0)\0Q6\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0026\2\0\0'\4\3\0B\2\2\0029\3\4\0005\5\b\0005\6\6\0003\a\5\0=\a\a\6=\6\t\0055\6\r\0009\a\n\0009\t\n\0009\t\v\t)\v¸ˇB\t\2\0025\n\f\0B\a\3\2=\a\14\0069\a\n\0009\t\n\0009\t\v\t)\v\4\0B\t\2\0025\n\15\0B\a\3\2=\a\16\0069\a\n\0009\t\n\0009\t\17\tB\t\1\0025\n\18\0B\a\3\2=\a\19\0069\a\20\0009\a\21\a=\a\22\0069\a\n\0005\t\24\0009\n\n\0009\n\23\nB\n\1\2=\n\25\t9\n\n\0009\n\26\nB\n\1\2=\n\27\tB\a\2\2=\a\28\0069\a\n\0009\a\29\a5\t\30\0B\a\2\2=\a\31\6=\6\n\0059\6\20\0009\6 \0064\b\3\0005\t!\0>\t\1\b5\t\"\0>\t\2\b4\t\3\0005\n#\0>\n\1\tB\6\3\2=\6 \0055\6&\0009\a$\0015\t%\0B\a\2\2=\a'\6=\6(\5B\3\2\0012\0\0ÄK\0\1\0\15formatting\vformat\1\0\0\1\0\2\rmaxwidth\0032\14with_text\1\15cmp_format\1\0\1\tname\vbuffer\1\0\1\tname\vsnippy\1\0\1\tname\rnvim_lsp\fsources\t<CR>\1\0\1\vselect\2\fconfirm\n<C-e>\6c\nclose\6i\1\0\0\nabort\n<C-y>\fdisable\vconfig\16<C-S-Space>\1\3\0\0\6i\6c\rcomplete\n<C-f>\1\3\0\0\6i\6c\n<C-b>\1\0\0\1\3\0\0\6i\6c\16scroll_docs\fmapping\fsnippet\1\0\0\vexpand\1\0\0\0\nsetup\vsnippy\flspkind\bcmp\frequire\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
