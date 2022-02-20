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
  ["Comment.nvim"] = {
    config = { "\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\fComment\frequire\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  ["FixCursorHold.nvim"] = {
    loaded = true,
    needs_bufread = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/FixCursorHold.nvim",
    url = "https://github.com/antoinemadec/FixCursorHold.nvim"
  },
  ["alpha-nvim"] = {
    config = { "\27LJ\2\nQ\0\1\a\0\4\0\r\18\3\0\0009\1\0\0'\4\1\0B\1\3\2'\2\2\0\n\1\0\0X\3\5Ä\18\5\1\0009\3\3\1)\6\2\0B\3\3\2\18\2\3\0L\2\2\0\bsub\5\15^.+(%..+)$\nmatchD\0\1\a\2\2\0\t-\1\0\0\18\3\0\0B\1\2\2-\2\1\0009\2\0\2\18\4\0\0\18\5\1\0005\6\1\0D\2\4\0\a¿\5¿\1\0\1\fdefault\2\rget_icon°\3\0\3\16\3\17\1H\14\0\2\0X\3\1Ä\18\2\0\0+\3\0\0004\4\0\0-\5\0\0\18\a\0\0B\5\2\0036\a\0\0-\t\1\0009\t\1\tB\a\2\2\a\a\2\0X\b\fÄ\15\0\6\0X\b\nÄ-\b\1\0009\b\1\b\15\0\b\0X\t\6Ä6\b\3\0009\b\4\b\18\n\4\0005\v\5\0>\6\1\vB\b\3\1\a\a\6\0X\b\bÄ6\b\3\0009\b\4\b\18\n\4\0005\v\a\0-\f\1\0009\f\1\f>\f\1\vB\b\3\1\18\b\5\0'\t\b\0&\3\t\b-\b\2\0009\b\t\b\18\n\1\0\18\v\3\0\18\f\2\0&\v\f\v'\f\n\0\18\r\0\0'\14\v\0&\f\14\fB\b\4\2\18\v\2\0009\t\f\2'\f\r\0B\t\3\2\n\t\0\0X\n\rÄ6\n\3\0009\n\4\n\18\f\4\0005\r\14\0\21\14\3\0\23\14\0\14>\14\2\r\21\14\t\0\21\15\3\0 \14\15\14\23\14\0\14>\14\3\rB\n\3\0019\n\15\b=\4\16\nL\b\2\0\b¿\5¿\4¿\ahl\topts\1\2\0\0\fComment\b.*/\nmatch\n <CR>\f<cmd>e \vbutton\a  \1\4\0\0\0\3\0\3\1\vstring\1\4\0\0\0\3\0\3\1\vinsert\ntable\fboolean\14highlight\ttype\4i\0\2\6\1\5\0\r6\2\0\0009\2\1\2\18\4\0\0'\5\2\0B\2\3\2\14\0\2\0X\3\5Ä6\2\3\0009\2\4\2-\4\0\0\18\5\1\0B\2\3\2L\2\2\0\n¿\17tbl_contains\bvim\19COMMIT_EDITMSG\tfind\vstring–\5\0\4\20\4\23\1á\1\14\0\3\0X\4\1Ä-\3\0\0\14\0\2\0X\4\1Ä)\2\t\0004\4\0\0006\5\0\0006\a\1\0009\a\2\a9\a\3\aB\5\2\4H\b)Ä\21\n\4\0\5\n\2\0X\n\1ÄX\5'Ä+\n\0\0\14\0\1\0X\v\2Ä+\n\2\0X\v\6Ä6\v\1\0009\v\4\v\18\r\t\0\18\14\1\0B\v\3\2\18\n\v\0009\v\5\3\15\0\v\0X\f\bÄ9\v\5\3\18\r\t\0-\14\1\0\18\16\t\0B\14\2\0A\v\1\2\14\0\v\0X\f\1Ä+\v\1\0006\f\1\0009\f\6\f9\f\a\f\18\14\t\0B\f\2\2\t\f\0\0X\f\aÄ\15\0\n\0X\f\5Ä\14\0\v\0X\f\3Ä\21\f\4\0\22\f\0\f<\t\f\4F\b\3\3R\b’5\5\b\0)\6#\0004\a\0\0006\b\t\0\18\n\4\0B\b\2\4X\vAÄ+\r\0\0\15\0\1\0X\14\bÄ6\14\1\0009\14\6\0149\14\n\14\18\16\f\0'\17\v\0B\14\3\2\18\r\14\0X\14\aÄ6\14\1\0009\14\6\0149\14\n\14\18\16\f\0'\17\f\0B\14\3\2\18\r\14\0\21\14\r\0\1\6\14\0X\14\23Ä-\14\2\0009\14\r\14\18\16\r\0B\14\2\2\18\16\14\0009\14\14\14)\17\1\0005\18\15\0B\14\4\2\18\r\14\0\21\14\r\0\1\6\14\0X\14\nÄ-\14\2\0009\14\r\14\18\16\r\0B\14\2\2\18\16\14\0009\14\14\14)\17\1\0005\18\16\0B\14\4\2\18\r\14\0'\14\17\0\21\15\5\0\3\v\15\0X\15\2Ä8\14\v\5X\15\aÄ6\15\18\0 \17\0\v\23\17\0\17\21\18\5\0!\17\18\17B\15\2\2\18\14\15\0-\15\3\0\18\17\f\0'\18\19\0\18\19\14\0&\18\19\18\18\19\r\0B\15\4\2<\15\v\aE\v\3\3R\vΩ5\b\20\0=\a\21\b4\t\0\0=\t\22\bL\b\2\0\v¿\a¿\3¿\t¿\topts\bval\1\0\1\ttype\ngroup\6 \rtostring\5\1\2\0\0\3ˇˇˇˇ\15\1\3\0\0\3˛ˇˇˇ\15\3ˇˇˇˇ\15\fshorten\bnew\a:~\a:.\16fnamemodify\vipairs\1\4\0\0\6a\6s\6d\17filereadable\afn\vignore\15startswith\roldfiles\6v\bvim\npairs\2ì\2\0\0\14\1\r\0!6\0\0\0009\0\1\0)\2\1\0-\3\0\0\21\3\3\0B\0\3\2-\1\0\0008\1\0\0014\2\0\0006\3\2\0\18\5\1\0B\3\2\4X\6\rÄ'\b\3\0\18\t\6\0&\b\t\b5\t\4\0=\a\5\t5\n\6\0=\b\a\n=\n\b\t6\n\t\0009\n\n\n\18\f\2\0\18\r\t\0B\n\3\1E\6\3\3R\6Ò5\3\v\0=\2\5\0035\4\f\0=\4\b\3L\3\2\0\15¿\1\0\1\rposition\vcenter\1\0\1\ttype\ngroup\vinsert\ntable\topts\ahl\1\0\2\rposition\vcenter\18shrink_margin\1\bval\1\0\1\ttype\ttext\14StartLogo\vipairs\vrandom\tmath1\0\0\6\2\0\1\b4\0\3\0-\1\0\0)\3\1\0-\4\1\0)\5\t\0B\1\4\0?\1\0\0L\0\2\0\f¿\6¿\3ÄÄ¿ô\4ñ\r\1\0\"\0J\1æ\0016\0\0\0006\2\1\0'\3\2\0B\0\3\3\14\0\0\0X\2\1Ä2\0µÄ6\2\0\0006\4\1\0'\5\3\0B\2\3\3\14\0\2\0X\4\1Ä2\0ØÄ6\4\1\0'\6\4\0B\4\2\0026\5\1\0'\a\5\0B\5\2\0026\6\6\0009\6\a\0069\6\b\6B\6\1\0023\a\t\0003\b\n\0003\t\v\0005\n\f\0005\v\14\0003\f\r\0=\f\15\v3\f\16\0006\r\6\0009\r\a\r9\r\17\r'\15\18\0B\r\2\0024\14\3\0\18\15\r\0'\16\19\0&\15\16\15>\15\1\0146\15\6\0009\15\a\0159\15\20\15'\17\21\0B\15\2\2)\16d\0\3\16\15\0X\15\aÄ6\15\22\0009\15\23\15\18\17\14\0\18\18\r\0'\19\24\0&\18\19\18B\15\3\0016\15\6\0009\15\a\0159\15\25\15'\17\21\0B\15\2\2)\16<\0\3\16\15\0X\15\aÄ6\15\22\0009\15\23\15\18\17\14\0\18\18\r\0'\19\26\0&\18\19\18B\15\3\0014\15\0\0006\16\27\0\18\18\14\0B\16\2\4X\19\22Ä6\21\27\0006\23\6\0009\23\a\0239\23\28\23\18\25\20\0B\23\2\0A\21\0\4X\24\fÄ6\26\22\0009\26\23\26\18\28\15\0006\29\6\0009\29\a\0299\29\29\29\18\31\20\0' \30\0\18!\25\0&\31!\31B\29\2\0A\26\1\1E\24\3\3R\24ÚE\19\3\3R\19Ë3\16\31\0005\17 \0004\18\4\0005\19!\0005\20\"\0=\20#\19>\19\1\0185\19$\0>\19\2\0185\19%\0003\20&\0=\20'\0195\20(\0=\20#\19>\19\3\18=\18'\0175\18)\0004\19\n\0005\20*\0005\21+\0=\21#\20>\20\1\0195\20,\0>\20\2\0199\20-\4'\22.\0'\23/\0'\0240\0B\20\4\2>\20\3\0199\20-\4'\0221\0'\0232\0'\0243\0B\20\4\2>\20\4\0199\20-\4'\0224\0'\0235\0'\0246\0B\20\4\2>\20\5\0199\20-\4'\0227\0'\0238\0'\0249\0B\20\4\2>\20\6\0199\20-\4'\22:\0'\23;\0'\24<\0B\20\4\2>\20\a\0199\20-\4'\22=\0'\23>\0'\24?\0B\20\4\2>\20\b\0199\20-\4'\22@\0'\23A\0'\24B\0B\20\4\0?\20\0\0=\19'\0189\19C\0015\21G\0004\22\a\0005\23D\0>\23\1\22\18\23\16\0B\23\1\2>\23\2\0225\23E\0>\23\3\22>\17\4\0225\23F\0>\23\5\22>\18\6\22=\22H\0215\22I\0=\22#\21B\19\2\0012\0\0ÄK\0\1\0K\0\1\0K\0\1\0\1\0\1\vmargin\3\5\vlayout\1\0\0\1\0\2\bval\3\2\ttype\fpadding\1\0\2\bval\3\2\ttype\fpadding\1\0\2\bval\3\2\ttype\fpadding\nsetup\f:qa<CR>\14Ôôô  Quit\6q\20:PackerSync<CR>\24ÔÑπ  Update plugins\6u$:e ~/.config/nvim/init.lua <CR>\23Óòï  Configuration\6c :ene <BAR> startinsert <CR>\18ÔÖõ  New file\6n\30:Telescope live_grep <CR>\19ÔûÉ  Find text\15<leader>fg\31:Telescope find_files <CR>\19Ôúù  Find file\15<leader> p\21:NeoTreeShow<CR>\23Ôêì  File Explorer\15<leader> /\vbutton\1\0\2\bval\3\1\ttype\fpadding\1\0\2\ahl\19SpecialComment\rposition\vcenter\1\0\2\bval\16Quick links\ttype\ttext\1\0\2\rposition\vcenter\ttype\ngroup\1\0\1\18shrink_margin\1\bval\0\1\0\1\ttype\ngroup\1\0\2\bval\3\1\ttype\fpadding\topts\1\0\3\ahl\19SpecialComment\rposition\vcenter\18shrink_margin\1\1\0\2\bval\17Recent files\ttype\ttext\1\0\1\ttype\ngroup\0\6/\rreadfile\freaddir\vipairs\nlarge\14winheight\twide\vinsert\ntable\6%\rwinwidth\nsmall\28~/.config/nvim/headers/\vexpand\0\vignore\1\0\0\0\1\2\0\0\14gitcommit\0\0\0\vgetcwd\afn\bvim\22nvim-web-devicons\27alpha.themes.dashboard\17plenary.path\nalpha\frequire\npcall\19ÄÄ¿ô\4\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/alpha-nvim",
    url = "https://github.com/goolord/alpha-nvim"
  },
  ["bufdelete.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/bufdelete.nvim",
    url = "https://github.com/famiu/bufdelete.nvim"
  },
  ["bufferline.nvim"] = {
    config = { "\27LJ\2\n©\1\0\1\5\0\t\0\0216\1\0\0009\1\1\0018\1\0\0019\1\2\0016\2\0\0009\2\3\0029\2\4\2\18\4\0\0B\2\2\2\6\1\5\0X\3\6Ä\6\1\6\0X\3\4Ä\6\2\a\0X\3\2Ä\a\2\b\0X\3\2Ä+\3\1\0X\4\1Ä+\3\2\0L\3\2\0\14[No Name]\28neo-tree filesystem [1]\fTrouble\rneo-tree\fbufname\afn\rfiletype\abo\bvimÀ\2\1\0\a\0\r\0\0196\0\0\0'\2\1\0B\0\2\0026\1\2\0009\1\3\1'\3\4\0B\1\2\0019\1\5\0005\3\v\0005\4\6\0003\5\a\0=\5\b\0044\5\3\0005\6\t\0>\6\1\5=\5\n\4=\4\f\3B\1\2\1K\0\1\0\foptions\1\0\0\foffsets\1\0\4\rfiletype\rneo-tree\14highlight\14Directory\15text_align\vcenter\ttext\nFiles\18custom_filter\0\1\0\4\fnumbers\tnone\22show_buffer_icons\2\16diagnostics\rnvim_lsp\20show_close_icon\2\nsetup*source ~/.config/nvim/config/bbye.vim\bcmd\bvim\15bufferline\frequire\0" },
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
    config = { "\27LJ\2\n÷\1\0\0\n\0\r\0\0286\0\0\0'\2\1\0B\0\2\0029\1\2\0009\1\3\1'\3\4\0005\4\6\0004\5\3\0005\6\5\0>\6\1\5=\5\a\4B\1\3\0019\1\2\0009\1\3\1'\3\b\0005\4\f\0009\5\t\0009\5\a\0054\a\3\0005\b\n\0>\b\1\a4\b\3\0005\t\v\0>\t\1\bB\5\3\2=\5\a\4B\1\3\1K\0\1\0\1\0\0\1\0\1\tname\fcmdline\1\0\1\tname\tpath\vconfig\6:\fsources\1\0\0\1\0\1\tname\vbuffer\6/\fcmdline\nsetup\bcmp\frequire\0" },
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
  ["cmp-snippy"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/cmp-snippy",
    url = "https://github.com/dcampos/cmp-snippy"
  },
  ["cmp-under-comparator"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/cmp-under-comparator",
    url = "https://github.com/lukas-reineke/cmp-under-comparator"
  },
  ["color-converter.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/color-converter.nvim",
    url = "https://github.com/NTBBloodbath/color-converter.nvim"
  },
  ["dressing.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/dressing.nvim",
    url = "https://github.com/stevearc/dressing.nvim"
  },
  ["emmet-vim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/emmet-vim",
    url = "https://github.com/mattn/emmet-vim"
  },
  firenvim = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/firenvim",
    url = "https://github.com/glacambre/firenvim"
  },
  ["goto-preview"] = {
    config = { "\27LJ\2\n>\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\17goto-preview\frequire\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/goto-preview",
    url = "https://github.com/rmagatti/goto-preview"
  },
  ["hologram.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/hologram.nvim",
    url = "https://github.com/edluffy/hologram.nvim"
  },
  ["impatient.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/impatient.nvim",
    url = "https://github.com/lewis6991/impatient.nvim"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\2\nw\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\31show_current_context_start\1\25show_current_context\2\nsetup\21indent_blankline\frequire\0" },
    loaded = true,
    needs_bufread = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["lsp-status.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/lsp-status.nvim",
    url = "https://github.com/nvim-lua/lsp-status.nvim"
  },
  ["lsp-trouble.nvim"] = {
    config = { "\27LJ\2\nw\0\0\4\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\3\0B\1\2\1K\0\1\0\1\0\4\25use_diagnostic_signs\1\14auto_open\2\15auto_close\2\17auto_preview\2\nsetup\ftrouble\frequire\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/lsp-trouble.nvim",
    url = "https://github.com/folke/lsp-trouble.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/lspkind-nvim",
    url = "https://github.com/onsails/lspkind-nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0056\0\0\0'\2\1\0B\0\2\0029\0\2\0D\0\1\0\vstatus\15lsp-status\frequireô\3\1\0\6\0\25\0\0296\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\a\0005\4\6\0=\4\b\3=\3\t\0025\3\v\0005\4\n\0=\4\f\0035\4\r\0=\4\14\0035\4\15\0=\4\16\0035\4\18\0003\5\17\0>\5\1\4=\4\19\0035\4\20\0=\4\21\0035\4\22\0=\4\23\3=\3\24\2B\0\2\1K\0\1\0\rsections\14lualine_z\1\2\0\0\rlocation\14lualine_y\1\2\0\0\rprogress\14lualine_x\1\5\0\0\0\rencoding\15fileformat\rfiletype\0\14lualine_c\1\2\0\0\rfilename\14lualine_b\1\4\0\0\vbranch\tdiff\16diagnostics\14lualine_a\1\0\0\1\2\0\0\tmode\foptions\23disabled_filetypes\1\0\0\1\2\0\0\rneo-tree\15extentions\1\2\0\0\rfugitive\1\0\1\ntheme\tauto\nsetup\flualine\frequire\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["lush.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/lush.nvim",
    url = "https://github.com/rktjmp/lush.nvim"
  },
  ["markdown-preview.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/markdown-preview.nvim",
    url = "https://github.com/iamcco/markdown-preview.nvim"
  },
  ["marks.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/marks.nvim",
    url = "https://github.com/chentau/marks.nvim"
  },
  ["matchparen.nvim"] = {
    config = { "\27LJ\2\n_\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\rhl_group\15MatchParen\15on_startup\2\nsetup\15matchparen\frequire\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/matchparen.nvim",
    url = "https://github.com/monkoose/matchparen.nvim"
  },
  ["neo-tree.nvim"] = {
    config = { "\27LJ\2\nÊ\3\0\2\n\1\24\0G9\2\0\0\14\0\2\0X\3\1Ä'\2\1\0009\3\2\0\14\0\3\0X\4\1Ä'\3\1\0009\4\3\0\14\0\4\0X\5\2Ä-\4\0\0009\4\4\0046\5\5\0'\a\6\0B\5\2\0029\6\a\1\a\6\b\0X\6\"Ä-\6\0\0009\4\t\0069\6\n\1\6\6\v\0X\6\6Ä9\6\n\1\6\6\f\0X\6\3Ä9\6\n\1\a\6\r\0X\6\bÄ9\6\14\0059\b\n\1B\6\2\3\f\2\6\0X\b\0Ä\f\4\a\0X\b\0ÄX\6\26Ä\18\b\1\0009\6\15\1B\6\2\2\15\0\6\0X\a\5Ä9\6\16\0\f\2\6\0X\a\1Ä'\2\17\0X\6\16Ä9\6\18\0\f\2\6\0X\a\1Ä'\2\19\0X\6\vÄ9\6\a\1\a\6\20\0X\6\bÄ9\6\14\0059\b\n\0019\t\21\1B\6\3\3\f\2\6\0X\b\0Ä\f\4\a\0X\b\0Ä5\6\22\0\18\a\2\0\18\b\3\0&\a\b\a=\a\23\6=\4\3\6L\6\2\0\1¿\ttext\1\0\0\bext\tfile\6+\18folder_closed\6-\16folder_open\16is_expanded\rget_icon\f.github\t.git\17node_modules\tname\19DIRECTORY_ICON\14directory\ttype\22nvim-web-devicons\frequire\14FILE_ICON\14highlight\fpadding\6 \fdefaultú\2\0\0\3\0\6\0\n6\0\0\0009\0\1\0009\0\2\0\a\0\3\0X\0\4Ä6\0\0\0009\0\4\0'\2\5\0B\0\2\1K\0\1\0”\1              setlocal nocursorcolumn\n              setlocal virtualedit=all\n              hi link NeoTreeDirectoryName Directory\n              hi link NeoTreeDirectoryIcon NeoTreeDirectoryName\n            \bcmd\rneo-tree\rfiletype\abo\bvim„\f\1\0\t\0&\00096\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\2\3\0005\4\4\0005\5\5\0005\6\6\0=\6\a\0055\6\b\0005\a\t\0=\a\n\6=\6\v\0055\6\18\0004\a\a\0005\b\f\0>\b\1\a5\b\r\0>\b\2\a5\b\14\0>\b\3\a5\b\15\0>\b\4\a5\b\16\0>\b\5\a5\b\17\0>\b\6\a=\a\19\6=\6\20\0055\6\22\0003\a\21\0=\a\23\6=\6\24\5=\5\25\0045\5\26\0005\6\27\0005\a\28\0=\a\n\6=\6\v\5=\5\29\0045\5 \0005\6\30\0005\a\31\0=\a\n\6=\6\v\5=\5!\0044\5\3\0005\6\"\0003\a#\0=\a$\6>\6\1\5=\5%\4B\2\2\0012\0\0ÄK\0\1\0\19event_handlers\fhandler\0\1\0\1\nevent\21vim_buffer_enter\15git_status\1\0\0\1\0\18\6d\vdelete\agp\rgit_push\6s\16open_vsplit\agr\20git_revert_file\6C\15close_node\18<2-LeftMouse>\topen\agg\24git_commit_and_push\6S\15open_split\6A\16git_add_all\6r\vrename\agu\21git_unstage_file\6x\21cut_to_clipboard\aga\17git_add_file\6p\25paste_from_clipboard\6c\22copy_to_clipboard\agc\15git_commit\t<cr>\topen\6R\frefresh\1\0\1\rposition\nfloat\fbuffers\1\0\r\6d\vdelete\6p\25paste_from_clipboard\6c\22copy_to_clipboard\6.\rset_root\6a\badd\18<2-LeftMouse>\topen\t<cr>\topen\6S\15open_split\6s\16open_vsplit\6r\vrename\6R\frefresh\6x\21cut_to_clipboard\t<bs>\16navigate_up\1\0\1\rposition\tleft\1\0\1\18show_unloaded\1\15filesystem\15components\ticon\1\0\0\0\14renderers\14directory\1\0\0\1\2\1\0\16diagnostics\16errors_only\2\1\2\1\0\14clipboard\14highlight\19NeoTreeDimText\1\2\1\0\19symlink_target\14highlight\30NeoTreeSymbolicLinkTarget\1\2\0\0\tname\1\2\0\0\19current_filter\1\2\3\0\ticon\18folder_closed\bÔÑî\16folder_open\bÔÅº\fpadding\6 \vwindow\rmappings\1\0\20\6d\vdelete\abd\18buffer_delete\6/\23filter_as_you_type\6R\frefresh\6C\15close_node\18<2-LeftMouse>\topen\6f\21filter_on_submit\6S\15open_split\6s\16open_vsplit\6H\18toggle_hidden\6r\vrename\n<c-x>\17clear_filter\6x\21cut_to_clipboard\6p\25paste_from_clipboard\6c\22copy_to_clipboard\6.\rset_root\6a\badd\t<cr>\topen\6I\21toggle_gitignore\t<bs>\16navigate_up\1\0\2\nwidth\3(\rposition\tleft\ffilters\1\0\2\16show_hidden\2\22respect_gitignore\2\1\0\2\24follow_current_file\2\27use_libuv_file_watcher\2\1\0\3\23popup_border_style\frounded\22enable_git_status\2\23enable_diagnostics\2\nsetup\27neo-tree.ui.highlights\rneo-tree\frequire\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/neo-tree.nvim",
    url = "https://github.com/nvim-neo-tree/neo-tree.nvim"
  },
  ["nightfox.nvim"] = {
    config = { "\27LJ\2\n¡\4\0\0\a\0\28\0$6\0\0\0006\2\1\0'\3\2\0B\0\3\3\14\0\0\0X\2\1ÄK\0\1\0009\2\3\0015\4\4\0005\5\5\0=\5\6\0044\5\0\0=\5\a\0045\5\b\0=\5\t\0045\5\v\0005\6\n\0=\6\f\0055\6\r\0=\6\14\0055\6\15\0=\6\16\0055\6\17\0=\6\18\0055\6\19\0=\6\20\0055\6\21\0=\6\22\0055\6\23\0=\6\24\5=\5\25\4B\2\2\0019\2\26\1'\4\27\0B\2\2\1K\0\1\0\fduskfox\tload\rhlgroups\16LspCodeLens\1\0\2\abg\n${bg}\nstyle\vitalic\vFolded\1\0\1\abg\n${bg}\19GitSignsChange\1\0\1\afg\f#f16d0a\31IndentBlankLineContextChar\1\0\1\afg\f#88ddff\15MatchParen\1\0\1\afg\vyellow\fComment\1\0\1\nstyle\vitalic\21TSPunctDelimiter\1\0\0\1\0\1\afg\v${red}\vcolors\1\0\4\14bg_visual\f#131b24\vbg_alt\f#010101\17bg_highlight\f#121820\abg\f#000000\finverse\vstyles\1\0\3\14functions\16italic,bold\rkeywords\tbold\rcomments\vitalic\1\0\2\bfox\fduskfox\valt_nc\2\nsetup\rnightfox\frequire\npcall\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nightfox.nvim",
    url = "https://github.com/EdenEast/nightfox.nvim"
  },
  ["nui.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nui.nvim",
    url = "https://github.com/MunifTanjim/nui.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\nM\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\rcheck_ts\2\nsetup\19nvim-autopairs\frequire\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-biscuits"] = {
    config = { "\27LJ\2\nØ\2\0\0\5\0\14\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\a\0005\4\6\0=\4\b\0035\4\t\0=\4\n\0035\4\v\0=\4\f\3=\3\r\2B\0\2\1K\0\1\0\20language_config\vpython\1\0\1\rdisabled\2\15javascript\1\0\2\15max_length\3P\18prefix_string\n ‚ú® \thtml\1\0\0\1\0\1\18prefix_string\v üåê \19default_config\1\0\3\15max_length\3\f\18prefix_string\v üìé \17min_distance\3\5\1\0\1\18show_on_start\2\nsetup\18nvim-biscuits\frequire\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-biscuits",
    url = "https://github.com/code-biscuits/nvim-biscuits"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\2\n1\0\1\4\1\2\0\5-\1\0\0009\1\0\0019\3\1\0B\1\2\1K\0\1\0\2¿\tbody\19expand_snippetÏ\t\1\0\f\0B\0ä\0016\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0026\2\0\0'\4\3\0B\2\2\0029\3\4\0005\5\b\0005\6\6\0003\a\5\0=\a\a\6=\6\t\0055\6\r\0009\a\n\0009\t\n\0009\t\v\t)\v¸ˇB\t\2\0025\n\f\0B\a\3\2=\a\14\0069\a\n\0009\t\n\0009\t\v\t)\v\4\0B\t\2\0025\n\15\0B\a\3\2=\a\16\0069\a\n\0009\t\n\0009\t\17\tB\t\1\0025\n\18\0B\a\3\2=\a\19\0069\a\20\0009\a\21\a=\a\22\0069\a\n\0005\t\24\0009\n\n\0009\n\23\nB\n\1\2=\n\25\t9\n\n\0009\n\26\nB\n\1\2=\n\27\tB\a\2\2=\a\28\0069\a\n\0009\a\29\a5\t\30\0B\a\2\2=\a\31\6=\6\n\0059\6\20\0009\6 \0064\b\n\0005\t!\0>\t\1\b5\t\"\0>\t\2\b5\t#\0>\t\3\b5\t$\0>\t\4\b5\t%\0>\t\5\b5\t&\0>\t\6\b5\t'\0>\t\a\b5\t(\0>\t\b\b5\t)\0>\t\t\b4\t\3\0005\n*\0>\n\1\tB\6\3\2=\6 \0055\0065\0004\a\t\0009\b\20\0009\b+\b9\b,\b>\b\1\a9\b\20\0009\b+\b9\b-\b>\b\2\a9\b\20\0009\b+\b9\b.\b>\b\3\a6\b\0\0'\n/\0B\b\2\0029\b0\b>\b\4\a9\b\20\0009\b+\b9\b1\b>\b\5\a9\b\20\0009\b+\b9\b2\b>\b\6\a9\b\20\0009\b+\b9\b3\b>\b\a\a9\b\20\0009\b+\b9\b4\b>\b\b\a=\a6\6=\0067\0055\6:\0009\a8\0015\t9\0B\a\2\2=\a;\6=\6<\0055\6=\0=\6>\5B\3\2\0016\3?\0009\3@\3'\5A\0B\3\2\0012\0\0ÄK\0\1\0{    augroup NoCmp\n      autocmd FileType neo-tree lua require'cmp'.setup.buffer { enabled = false }\n    augroup END\n  \bcmd\bvim\17experimental\1\0\1\15ghost_text\2\15formatting\vformat\1\0\0\1\0\1\14with_text\2\15cmp_format\fsorting\16comparators\1\0\0\norder\vlength\14sort_text\tkind\nunder\25cmp-under-comparator\nscore\nexact\voffset\fcompare\1\0\2\19keyword_length\3\5\tname\vbuffer\1\0\1\tname\tfish\1\0\1\tname\vsnippy\1\0\1\tname\nemoji\1\0\1\tname\tcalc\1\0\1\tname\bnpm\1\0\1\tname\rnvim_lua\1\0\1\tname\28nvim_lsp_signature_help\1\0\1\tname\fcmp_git\1\0\1\tname\rnvim_lsp\fsources\t<CR>\1\0\1\vselect\2\fconfirm\n<C-e>\6c\nclose\6i\1\0\0\nabort\n<C-y>\fdisable\vconfig\16<C-S-Space>\1\3\0\0\6i\6c\rcomplete\n<C-f>\1\3\0\0\6i\6c\n<C-b>\1\0\0\1\3\0\0\6i\6c\16scroll_docs\fmapping\fsnippet\1\0\0\vexpand\1\0\0\0\nsetup\vsnippy\flspkind\bcmp\frequire\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-cursorline"] = {
    loaded = true,
    needs_bufread = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/nvim-cursorline",
    url = "https://github.com/yamatsum/nvim-cursorline"
  },
  ["nvim-lightbulb"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-lightbulb",
    url = "https://github.com/kosayoda/nvim-lightbulb"
  },
  ["nvim-lsp-installer"] = {
    config = { "\27LJ\2\nÏ\2\0\1\b\2\17\0\0316\1\0\0009\1\1\1'\3\2\0-\4\0\0009\4\3\0046\6\0\0009\6\4\0069\6\5\0069\6\6\6B\6\1\0A\4\0\2-\5\1\0009\5\a\5B\1\4\0029\2\b\0019\2\t\0029\2\n\2+\3\2\0=\3\v\0029\2\b\0019\2\t\0029\2\n\0025\3\14\0005\4\r\0=\4\15\3=\3\f\2-\2\1\0009\2\16\2\18\4\0\0B\2\2\1K\0\1\0\1¿\2¿\14on_attach\15properties\1\0\0\1\4\0\0\18documentation\vdetail\24additionalTextEdits\19resolveSupport\19snippetSupport\19completionItem\15completion\17textDocument\17capabilities\29make_client_capabilities\rprotocol\blsp\24update_capabilities\tkeep\15tbl_extend\bvim˚\2\0\1\4\3\6\0\17-\1\0\0\18\3\0\0B\1\2\0019\1\0\0-\2\1\0=\2\1\0019\1\0\0-\2\1\0=\2\2\1-\1\2\0\15\0\1\0X\2\4Ä6\1\3\0009\1\4\1'\3\5\0B\1\2\1K\0\1\0\0\0\0¿\1¿·\1          augroup LspFormatting\n              autocmd! * <buffer>\n              autocmd BufWritePre * sleep 200m\n              autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()\n          augroup END\n        \bcmd\bvim\30document_range_formatting\24document_formatting\26resolved_capabilities\22\1\2\3\1\1\0\0033\2\0\0002\0\0ÄL\2\2\0\4¿\0$\0\0\2\0\3\0\0046\0\0\0009\0\1\0009\0\2\0D\0\1\0\bcwd\tloop\bvimj\0\0\5\3\3\0\18-\0\0\0-\1\1\0009\1\0\0018\0\1\0\14\0\0\0X\1\1Ä4\0\0\0009\1\1\0\14\0\1\0X\2\1Ä-\1\2\0=\1\1\0-\1\1\0\18\3\1\0009\1\2\1\18\4\0\0B\1\3\1K\0\1\0\a¿\14¿\4¿\nsetup\14on_attach\tname√\15\1\0\19\0_\0®\0016\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0026\2\0\0'\4\3\0B\2\2\0025\3\4\0009\4\5\0025\6\t\0006\a\6\0009\a\a\a9\a\b\a=\a\n\0065\a\v\0=\a\f\6B\4\2\0019\4\r\2B\4\1\0013\4\14\0003\5\15\0006\6\6\0009\6\16\0066\b\17\0009\b\18\b'\t\19\0B\6\3\0026\a\20\0009\a\21\a\18\t\6\0'\n\22\0B\a\3\0016\a\20\0009\a\21\a\18\t\6\0'\n\23\0B\a\3\0015\a\26\0005\b\24\0\18\t\5\0+\v\1\0B\t\2\2=\t\25\b=\b\27\a5\b\28\0\18\t\5\0+\v\2\0+\f\2\0B\t\3\2=\t\25\b5\t\29\0005\n\30\0=\n\31\t5\n \0005\v!\0=\v\"\n=\n#\t5\n$\0=\n%\t=\t&\b=\b'\a5\b)\0003\t(\0=\t*\b5\t+\0=\t,\b=\b-\a5\b3\0005\t2\0005\n1\0006\v\0\0'\r.\0B\v\2\0029\v/\v9\v0\vB\v\1\2=\v0\n=\n/\t=\t&\b=\b4\a5\b6\0005\t5\0=\t&\b=\b7\a5\b8\0\18\t\5\0+\v\2\0+\f\2\0B\t\3\2=\t\25\b5\t9\0=\t,\b5\t;\0005\n:\0=\n<\t=\t&\b=\b=\a5\b>\0\18\t\5\0+\v\2\0+\f\2\0B\t\3\2=\t\25\b5\tR\0005\n@\0005\v?\0=\6\18\v=\vA\n5\vC\0005\fB\0=\fD\v=\vE\n5\vI\0006\f\6\0009\fF\f9\fG\f'\14H\0+\15\2\0B\f\3\2=\fJ\v=\vK\n5\vL\0=\vM\n5\vN\0=\vO\n5\vP\0=\vQ\n=\nS\t=\t&\b=\bT\a5\bU\0\18\t\5\0+\v\1\0B\t\2\2=\t\25\b5\tW\0005\nV\0=\n\31\t=\t&\b=\bX\a6\bY\0\18\n\3\0B\b\2\4H\v\18Ä9\rZ\0\18\15\f\0B\r\2\3\15\0\r\0X\15\fÄ\18\17\14\0009\15[\0143\18\\\0B\15\3\1\18\17\14\0009\15]\14B\15\2\2\14\0\15\0X\15\3Ä\18\17\14\0009\15^\14B\15\2\0012\r\0ÄF\v\3\3R\vÏ2\0\0ÄK\0\1\0\finstall\17is_installed\0\ron_ready\15get_server\npairs\rtsserver\1\0\0\1\0\1\venable\1\1\0\0\16sumneko_lua\bLua\1\0\0\14telemetry\1\0\1\venable\1\thint\1\0\1\venable\2\15completion\1\0\1\16autoRequire\1\14workspace\flibrary\1\0\1\20checkThirdParty\1\5\26nvim_get_runtime_file\bapi\16diagnostics\fglobals\1\0\0\1\3\0\0\tutf8\bvim\fruntime\1\0\0\1\0\1\fversion\vLuaJIT\1\0\0\18stylelint_lsp\18stylelintplus\1\0\0\1\0\1\fcssInJs\1\1\a\0\0\bcss\tless\tscss\fsugarss\bvue\twxss\1\0\0\14remark_ls\1\0\0\1\0\1\21defaultProcessor\vremark\vjsonls\1\0\0\1\0\0\1\0\0\fschemas\tjson\16schemastore\remmet_ls\14filetypes\1\r\0\0\thtml\bcss\tscss\bnjk\rnunjucks\njinja\ats\15typescript\amd\rmarkdown\ajs\15javascript\rroot_dir\1\0\0\0\veslint\rsettings\rlintTask\1\0\1\venable\2\22codeActionsOnSave\nrules\1\3\0\0\14!debugger\21!no-only-tests/*\1\0\1\tmode\ball\vformat\1\0\1\venable\2\1\0\3\19packageManager\bnpm\18autoFixOnSave\2\venable\2\1\0\0\vdenols\1\0\0\14on_attach\1\0\0\19lua/?/init.lua\14lua/?.lua\vinsert\ntable\6;\tpath\fpackage\nsplit\0\0\22register_progress\19spinner_frames\1\t\0\0\b‚£æ\b‚£Ω\b‚£ª\b‚¢ø\b‚°ø\b‚£ü\b‚£Ø\b‚£∑\16kind_labels\1\0\a\18status_symbol\a: \21indicator_errors\tüî•\23indicator_warnings\n üöß\21current_function\1\19indicator_info\f‚ÑπÔ∏è \17indicator_ok\tÔÄå \19indicator_hint\nüôã #completion_customize_lsp_label\6g\bvim\vconfig\1\20\0\0\14angularls\vbashls\vclangd\ncssls\rdockerls\remmet_ls\veslint\fgraphql\bhls\thtml\vjsonls\fpyright\18rust_analyzer\rspectral\18stylelint_lsp\16sumneko_lua\rtsserver\nvimls\vyamlls\15lsp-status\17cmp_nvim_lsp\31nvim-lsp-installer.servers\frequire\0" },
    loaded = true,
    needs_bufread = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/nvim-lsp-installer",
    url = "https://github.com/williamboman/nvim-lsp-installer"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-luapad"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-luapad",
    url = "https://github.com/rafcamlet/nvim-luapad"
  },
  ["nvim-luaref"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-luaref",
    url = "https://github.com/milisims/nvim-luaref"
  },
  ["nvim-notify"] = {
    config = { "\27LJ\2\nV\0\0\4\0\5\0\t6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\3\0B\1\2\0016\1\4\0=\0\1\1K\0\1\0\bvim\1\0\1\vrender\fminimal\nsetup\vnotify\frequire\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-notify",
    url = "https://github.com/rcarriga/nvim-notify"
  },
  ["nvim-regexplainer"] = {
    config = { "\27LJ\2\nJ\0\1\b\0\3\0\14'\1\0\0009\2\1\0)\3\0\0\1\3\2\0X\2\bÄ)\2\1\0009\3\1\0)\4\1\0M\2\4Ä\18\6\1\0'\a\2\0&\1\a\6O\2¸L\1\2\0\a> \ndepth\6\n|\1\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\5\0003\4\4\0=\4\6\3=\3\a\2B\0\2\1K\0\1\0\14narrative\14separator\1\0\0\0\1\0\1\fdisplay\nsplit\nsetup\22nvim-regexplainer\frequire\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-regexplainer",
    url = "https://github.com/bennypowers/nvim-regexplainer"
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
    config = { "\27LJ\2\nÇ\t\0\0\5\0&\00056\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\6\0=\3\a\0025\3\b\0005\4\t\0=\4\n\3=\3\v\0025\3\f\0=\3\r\0025\3\14\0=\3\15\0025\3\16\0005\4\17\0=\4\18\3=\3\19\2B\0\2\0016\0\0\0'\2\20\0B\0\2\0029\0\2\0005\2\24\0005\3\21\0005\4\22\0=\4\23\3=\3\25\0025\3\26\0=\3\27\0024\3\0\0=\3\28\2B\0\2\0016\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2!\0005\3\29\0004\4\0\0=\4\30\0035\4\31\0=\4 \3=\3\"\0025\3$\0005\4#\0=\4%\3=\3\5\2B\0\2\1K\0\1\0\20custom_captures\1\0\0\1\0\0011(method_signature name:(property_identifier)\25BP_TSMethodSignature\15playground\1\0\0\16keybindings\1\0\n\14goto_node\t<cr>\27toggle_anonymous_nodes\6a\vupdate\6R\30toggle_injected_languages\6t\21toggle_hl_groups\6i\24toggle_query_editor\6o\19focus_language\6f\14show_help\6?\21unfocus_language\6F\28toggle_language_display\6I\fdisable\1\0\3\venable\2\20persist_queries\1\15updatetime\3\25\fexclude\vexpand\1\6\0\0\rfunction\vmethod\ntable\vobject\17if_statement\fdimming\1\0\2\15treesitter\2\fcontext\3\n\ncolor\1\3\0\0\vNormal\f#ffffff\1\0\2\rinactive\1\nalpha\4\0ÄÄ¿˛\3\rtwilight\fautotag\14filetypes\1\17\0\0\thtml\bnjk\njinja\rnunjucks\ajs\15javascript\bjsx\20javascriptreact\amd\rmarkdown\vsvelte\ats\15typescript\btsx\20typescriptreact\bvue\1\0\1\venable\2\fendwise\1\0\1\venable\2\vindent\1\0\1\venable\2\16textobjects\fkeymaps\1\0\4\aac\17@class.outer\aif\20@function.inner\aaf\20@function.outer\aic\17@class.inner\1\0\2\venable\2\14lookahead\2\26incremental_selection\1\0\1\venable\2\14highlight\1\0\1\venable\2\1\0\1\21ensure_installed\15maintained\nsetup\28nvim-treesitter.configs\frequire\0" },
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
    config = { "\27LJ\2\nö\3\0\0\6\0\18\0\0226\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\n\0005\4\4\0005\5\3\0=\5\5\0045\5\6\0=\5\a\0045\5\b\0=\5\t\4=\4\v\3B\1\2\0019\1\f\0005\3\14\0005\4\r\0=\4\15\0035\4\16\0=\4\17\3B\1\2\1K\0\1\0\18tsconfig.json\1\0\3\tname\17TSConfigJson\ticon\bÔÄì\ncolor\f#519aba\f.github\1\0\0\1\0\2\ticon\bÔêà\tname\vGitHub\rset_icon\roverride\1\0\0\ats\1\0\4\16cterm_color\a67\tname\aTs\ticon\bÔØ§\ncolor\f#519aba\17node_modules\1\0\3\tname\16NodeModules\ticon\bÓúò\ncolor\f#90a959\amd\1\0\0\1\0\4\16cterm_color\a67\tname\rMarkdown\ticon\bÔíä\ncolor\f#519aba\nsetup\22nvim-web-devicons\frequire\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["omni.vim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/omni.vim",
    url = "https://github.com/yonlu/omni.vim"
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
    config = { "\27LJ\2\n@\0\0\4\0\6\0\a6\0\0\0009\0\1\0'\2\2\0006\3\3\0009\3\4\0039\3\5\3D\0\3\0\14foldlevel\6v\bvim\6>\brep\vstring§\2\1\0\6\0\r\0\0216\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\6\0005\4\4\0003\5\5\0>\5\2\4=\4\a\0035\4\b\0=\4\t\3=\3\n\2B\0\2\0016\0\0\0'\2\v\0B\0\2\0029\0\2\0005\2\f\0B\0\2\1K\0\1\0\1\0\1\bkey\6l\24pretty-fold.preview\rsections\nright\1\6\0\0\t‚î´ \27number_of_folded_lines\a: \15percentage\15 ‚î£‚îÅ‚îÅ\tleft\1\0\0\0\1\6\0\0\t‚îÅ \0\f ‚îÅ‚î´\fcontent\b‚î£\1\0\2\21keep_indentation\1\14fill_char\b‚îÅ\nsetup\16pretty-fold\frequire\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/pretty-fold.nvim",
    url = "https://github.com/anuvyklack/pretty-fold.nvim"
  },
  ["schemastore.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/schemastore.nvim",
    url = "https://github.com/b0o/schemastore.nvim"
  },
  ["splitjoin.vim"] = {
    loaded = true,
    needs_bufread = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/splitjoin.vim",
    url = "https://github.com/AndrewRadev/splitjoin.vim"
  },
  ["sqlite.lua"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/sqlite.lua",
    url = "https://github.com/tami5/sqlite.lua"
  },
  ["telescope-frecency.nvim"] = {
    config = { "\27LJ\2\nM\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\rfrecency\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/telescope-frecency.nvim",
    url = "https://github.com/nvim-telescope/telescope-frecency.nvim"
  },
  ["telescope-heading.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/telescope-heading.nvim",
    url = "https://github.com/crispgm/telescope-heading.nvim"
  },
  ["telescope-symbols.nvim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/telescope-symbols.nvim",
    url = "https://github.com/nvim-telescope/telescope-symbols.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n¶\4\0\0\t\0\27\0 6\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\2\3\0005\4\19\0005\5\4\0005\6\5\0=\6\6\0055\6\a\0=\6\b\0055\6\16\0005\a\n\0009\b\t\1=\b\v\a9\b\f\1=\b\r\a9\b\14\1=\b\15\a=\a\17\6=\6\18\5=\5\20\0045\5\22\0005\6\21\0=\6\23\0055\6\24\0=\6\25\5=\5\26\4B\2\2\1K\0\1\0\fpickers\30lsp_workspace_diagnostics\1\0\1\ntheme\rdropdown\21lsp_code_actions\1\0\0\1\0\1\ntheme\vcursor\rdefaults\1\0\0\rmappings\6i\1\0\0\n<esc>\nclose\n<C-j>\24move_selection_next\n<C-k>\1\0\0\28move_selection_previous\25file_ignore_patterns\1\3\0\0\t.git\17node_modules\22vimgrep_arguments\1\n\0\0\arg\18--color=never\17--no-heading\20--with-filename\18--line-number\r--column\17--smart-case\r--ignore\r--hidden\1\0\1\18prompt_prefix\nüîé \nsetup\22telescope.actions\14telescope\frequire\0" },
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
  ["uwu.vim"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/uwu.vim",
    url = "https://github.com/mangeshrex/uwu.vim"
  },
  ["vgit.nvim"] = {
    config = { "\27LJ\2\nÔ\4\0\2\22\0\26\3Z9\2\0\0019\3\1\0\5\2\3\0X\4\1Ä'\3\2\0006\4\3\0009\4\4\0046\6\3\0009\6\5\6B\6\1\0029\a\6\0B\4\3\2\25\4\0\0044\5\a\0005\6\a\0>\6\1\0055\6\b\0>\6\2\0055\6\t\0>\6\3\0055\6\n\0>\6\4\0055\6\v\0>\6\5\0055\6\f\0>\6\6\5)\6\1\0008\a\6\5:\b\1\a:\t\2\a)\n\1\0\1\4\n\0X\n\nÄ\21\n\5\0\4\6\n\0X\n\aÄU\n\6Ä8\a\6\5:\b\1\a:\t\2\a\"\4\b\4\22\6\1\6X\nÛ9\n\r\0009\v\14\0\14\0\v\0X\v\bÄ'\3\2\0'\n\15\0006\v\16\0009\v\17\v'\r\18\0\18\14\3\0\18\15\n\0D\v\4\0)\vˇ\0\21\f\n\0\1\v\f\0X\f\aÄ\18\14\n\0009\f\19\n)\15\1\0\18\16\v\0B\f\4\2'\r\20\0&\n\r\f6\f\16\0009\f\17\f'\14\21\0\18\15\3\0006\16\16\0009\16\17\16'\18\22\0)\19\0\0\3\19\4\0X\19\6Ä6\19\23\0009\19\24\19\22\21\2\4B\19\2\2\14\0\19\0X\20\4Ä6\19\23\0009\19\25\19\23\21\2\4B\19\2\2\18\20\t\0B\16\4\2\18\17\n\0D\f\5\0\tceil\nfloor\tmath\14%s %s ago\19 %s, %s ‚Ä¢ %s\b...\bsub\15 %s ‚Ä¢ %s\vformat\vstring\24Uncommitted changes\14committed\19commit_message\1\3\0\0\3<\fseconds\1\3\0\0\3<\fminutes\1\3\0\0\3\24\nhours\1\3\0\0\3\30\tdays\1\3\0\0\3\f\vmonths\1\3\0\0\3\1\nyears\16author_time\ttime\rdifftime\aos\bYou\vauthor\14user.nameÄ‘\29\2\1ÄÄÄˇ\3ø\f\1\0\b\0002\00096\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\0035\4\19\0005\5\6\0005\6\a\0=\6\b\0055\6\t\0=\6\n\0055\6\v\0=\6\f\0055\6\r\0=\6\14\0055\6\15\0=\6\16\0055\6\17\0=\6\18\5=\5\20\0045\5\21\0003\6\22\0=\6\23\5=\5\24\0045\5\25\0=\5\26\0045\5\27\0=\5\28\0045\5\29\0=\5\30\0045\5\31\0005\6!\0005\a \0=\a\"\0065\a#\0=\a$\0065\a%\0=\a\n\0065\a&\0=\a\14\0065\a'\0=\a\f\6=\6(\0055\6*\0005\a)\0=\a\30\0065\a+\0=\a,\6=\6-\5=\5.\0045\5/\0=\0050\4=\0041\3B\1\2\1K\0\1\0\rsettings\fsymbols\1\0\1\tvoid\b‚£ø\nsigns\nusage\tmain\1\0\3\badd\16GitSignsAdd\vremove\19GitSignsDelete\vchange\19GitSignsChange\1\0\0\1\0\2\badd\18GitSignsAddLn\vremove\21GitSignsDeleteLn\16definitions\1\0\3\vtexthl\19GitSignsChange\ticon\b‚ü´\ttext\b‚îÉ\1\0\3\vtexthl\19GitSignsDelete\ticon\b‚àí\ttext\b‚îÉ\1\0\3\vtexthl\16GitSignsAdd\ticon\b‚äû\ttext\b‚îÉ\21GitSignsDeleteLn\1\0\2\vlinehl\21GitSignsDeleteLn\ttext\5\18GitSignsAddLn\1\0\0\1\0\2\vlinehl\18GitSignsAddLn\ttext\5\1\0\1\rpriority\3\n\vscreen\1\0\1\20diff_preference\funified\25authorship_code_lens\1\0\1\fenabled\2\16live_gutter\1\0\1\fenabled\2\15live_blame\vformat\0\1\0\1\fenabled\2\bhls\1\0\0\18GitWordDelete\1\0\2\abg\f#960f3d\roverride\1\15GitWordAdd\1\0\2\abg\f#5d7a22\roverride\1\19GitSignsDelete\1\0\2\afg\f#e95678\roverride\1\19GitSignsChange\1\0\2\afg\f#f16d0a\roverride\2\16GitSignsAdd\1\0\2\afg\f#d7ffaf\roverride\1\27GitBackgroundSecondary\1\0\1\roverride\1\1\0\6\18GitSignsAddLn\fDiffAdd\25GitBackgroundPrimary\16NormalFloat\14GitBorder\vLineNr\21GitSignsDeleteLn\15DiffDelete\14GitLineNr\vLineNr\15GitComment\fComment\fkeymaps\1\0\0\1\0\14\17n <leader>gq\21project_hunks_qf\17n <leader>gd\25project_diff_preview\17n <leader>gb\25buffer_blame_preview\17n <leader>gh\27buffer_history_preview\17n <leader>gx\27toggle_diff_preference\17n <leader>gl\26project_hunks_preview\17n <leader>gp\24buffer_hunk_preview\fn <C-k>\fhunk_up\17n <leader>gr\22buffer_hunk_reset\17n <leader>gg buffer_gutter_blame_preview\17n <leader>gs\22buffer_hunk_stage\fn <C-j>\14hunk_down\17n <leader>gu\17buffer_reset\17n <leader>gf\24buffer_diff_preview\nsetup\tvgit\frequire\0" },
    loaded = true,
    needs_bufread = false,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/opt/vgit.nvim",
    url = "https://github.com/tanvirtin/vgit.nvim"
  },
  ["vim-caser"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/vim-caser",
    url = "https://github.com/arthurxavierx/vim-caser"
  },
  ["vim-devicons"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/vim-devicons",
    url = "https://github.com/ryanoasis/vim-devicons"
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
  ["vim-lion"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/vim-lion",
    url = "https://github.com/tommcdo/vim-lion"
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
  ["vim-surround"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  ["vim-visual-multi"] = {
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/vim-visual-multi",
    url = "https://github.com/mg979/vim-visual-multi"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\nå\r\0\0\a\0 \0.6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\6\0005\4\4\0005\5\3\0=\5\5\4=\4\a\3B\1\2\0016\1\b\0006\3\0\0'\4\t\0B\1\3\3\15\0\1\0X\3\3Ä9\3\2\0025\5\n\0B\3\2\0019\3\v\0005\5\f\0005\6\r\0=\6\14\0055\6\15\0=\6\16\0055\6\17\0=\6\18\0055\6\19\0=\6\20\0055\6\21\0B\3\3\0019\3\v\0005\5\22\0005\6\23\0=\6\14\0055\6\24\0=\6\25\0055\6\26\0=\6\27\0055\6\28\0=\6\16\0055\6\29\0=\6\30\0055\6\31\0B\3\3\1K\0\1\0\1\0\1\vprefix\6g\6L\1\0\1\tname\16align right\1\0\1\tname\15align left\6s\1\0\f\6_\15snake_case\6p\15mixed case\6s\18Sentence case\6U\16UPPER_SNAKE\6t\15Title Case\tname\ncaser\6-\14dash-case\6m\15mixed case\6k\14dash-case\f<space>\15space case\6u\16UPPER_SNAKE\6c\14camelCase\6n\1\0\2\tname\16incremental\6n\vselect\1\0\2\6c\17comment line\tname\rcomments\1\0\a\6d\21goto definitions\6D\21goto declaration\6r\20goto references\6u\14lowercase\6U\14uppercase\6i\25goto implementations\6%\29match surround backwards\1\0\1\vprefix\r<leader>\6g\1\0\r\6d#preview diff         (project)\6h\"preview history      (buffer)\6s\15stage hunk\6f\"preview diff         (buffer)\6u\17reset buffer\tname\bgit\6g\"preview gutter blame (buffer)\6p\"preview hunks        (buffer)\6q#hunks quickfix       (project)\6l#preview hunks        (project)\6r\17unstage hunk\6x\27toggle diff preference\6b\"preview blame        (buffer)\6f\1\0\6\tname\tfind\6h\17find in help\6s\16find symbol\6f\16format file\6g\30find in files (live grep)\6b\17find buffers\6l\1\0\a\6e(open diagnostics in floating window\6d\21goto declaration\6k\19signature_help\6f\16format file\6D\25goto type definition\tname\blsp\6r\vrename\6c\1\0\3\tname\fcolours\6h\20format as hsl()\6c\24cycle colour format\1\0\14\6e(open diagnostics in floating window\6p\15find files\6s\14save file\6.\17code actions\6t\18choose buffer\6w\17close buffer\6F\30find in files (live grep)\6D\25goto type definition\6}\16next buffer\6q\tquit\6\\\21toggle file tree\6R\20rename refactor\6k\20command pallete\6{\20previous buffer\rregister\1\0\3\18select_prompt\20Command Pallete\20include_builtin\2\28auto_register_which_key\2\14legendary\npcall\fplugins\1\0\0\rspelling\1\0\0\1\0\1\fenabled\2\nsetup\14which-key\frequire\0" },
    loaded = true,
    path = "/Users/bennyp/.local/share/nvim/site/pack/packer/start/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Setup for: nvim-cursorline
time([[Setup for nvim-cursorline]], true)
try_loadstring("\27LJ\2\n4\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\0\0=\1\2\0K\0\1\0\23cursorline_timeout\6g\bvim\0", "setup", "nvim-cursorline")
time([[Setup for nvim-cursorline]], false)
time([[packadd for nvim-cursorline]], true)
vim.cmd [[packadd nvim-cursorline]]
time([[packadd for nvim-cursorline]], false)
-- Setup for: FixCursorHold.nvim
time([[Setup for FixCursorHold.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1Ù\1=\1\2\0K\0\1\0\26cursorhold_updatetime\6g\bvim\0", "setup", "FixCursorHold.nvim")
time([[Setup for FixCursorHold.nvim]], false)
time([[packadd for FixCursorHold.nvim]], true)
vim.cmd [[packadd FixCursorHold.nvim]]
time([[packadd for FixCursorHold.nvim]], false)
-- Setup for: vgit.nvim
time([[Setup for vgit.nvim]], true)
try_loadstring("\27LJ\2\nh\0\0\2\0\a\0\r6\0\0\0009\0\1\0)\1,\1=\1\2\0006\0\0\0009\0\1\0+\1\1\0=\1\3\0006\0\0\0009\0\4\0'\1\6\0=\1\5\0K\0\1\0\byes\15signcolumn\awo\14incsearch\15updatetime\6o\bvim\0", "setup", "vgit.nvim")
time([[Setup for vgit.nvim]], false)
time([[packadd for vgit.nvim]], true)
vim.cmd [[packadd vgit.nvim]]
time([[packadd for vgit.nvim]], false)
-- Setup for: vim-polyglot
time([[Setup for vim-polyglot]], true)
try_loadstring('\27LJ\2\nÚ\1\0\0\2\0\4\0\0056\0\0\0009\0\1\0005\1\3\0=\1\2\0K\0\1\0\1\19\0\0\bcss\tscss\thtml\vpython\14py=python\ash\fbash=sh\tfish\15typescript\18ts=typescript\23diff-ts=typescript\15javascript\18js=javascript\23diff-js=javascript\20json=javascript\fgraphql\16gql=graphql\bvim"vim_markdown_fenced_languages\6g\bvim\0', "setup", "vim-polyglot")
time([[Setup for vim-polyglot]], false)
time([[packadd for vim-polyglot]], true)
vim.cmd [[packadd vim-polyglot]]
time([[packadd for vim-polyglot]], false)
-- Setup for: splitjoin.vim
time([[Setup for splitjoin.vim]], true)
try_loadstring("\27LJ\2\n€\1\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0ª\1            let g:splitjoin_split_mapping = ''\n            let g:splitjoin_join_mapping = ''\n            nmap gj :SplitjoinJoin<cr>\n            nmap g, :SplitjoinSplit<cr>\n          \bcmd\bvim\0", "setup", "splitjoin.vim")
time([[Setup for splitjoin.vim]], false)
time([[packadd for splitjoin.vim]], true)
vim.cmd [[packadd splitjoin.vim]]
time([[packadd for splitjoin.vim]], false)
-- Setup for: indent-blankline.nvim
time([[Setup for indent-blankline.nvim]], true)
try_loadstring("\27LJ\2\np\0\0\2\0\4\0\0056\0\0\0009\0\1\0005\1\3\0=\1\2\0K\0\1\0\1\a\0\0\tVGit\nalpha\rfugitive\thelp\rneo-tree\vnotify&indent_blankline_filetype_exclude\6g\bvim\0", "setup", "indent-blankline.nvim")
time([[Setup for indent-blankline.nvim]], false)
time([[packadd for indent-blankline.nvim]], true)
vim.cmd [[packadd indent-blankline.nvim]]
time([[packadd for indent-blankline.nvim]], false)
-- Setup for: nvim-lsp-installer
time([[Setup for nvim-lsp-installer]], true)
try_loadstring("\27LJ\2\nÆ\4\0\0\3\0\a\0\r6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0'\1\4\0=\1\3\0006\0\0\0009\0\5\0'\2\6\0B\0\2\1K\0\1\0©\3    call sign_define(\"LspDiagnosticsSignError\", {\"text\" : \"üî•\", \"texthl\" : \"LspDiagnosticsError\"})\n    call sign_define(\"LspDiagnosticsSignWarning\", {\"text\" : \"üöß\", \"texthl\" : \"LspDiagnosticsWarning\"})\n    call sign_define(\"LspDiagnosticsSignInformation\", {\"text\" : \"üë∑\", \"texthl\" : \"LspDiagnosticsInformation\"})\n    call sign_define(\"LspDiagnosticsSignHint\", {\"text\" : \"üôã\", \"texthl\" : \"LspDiagnosticsHint\"})\n  \bcmd\tÔö¶ #diagnostic_virtual_text_prefix#diagnostic_enable_virtual_text\6g\bvim\0", "setup", "nvim-lsp-installer")
time([[Setup for nvim-lsp-installer]], false)
time([[packadd for nvim-lsp-installer]], true)
vim.cmd [[packadd nvim-lsp-installer]]
time([[packadd for nvim-lsp-installer]], false)
-- Config for: matchparen.nvim
time([[Config for matchparen.nvim]], true)
try_loadstring("\27LJ\2\n_\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\rhl_group\15MatchParen\15on_startup\2\nsetup\15matchparen\frequire\0", "config", "matchparen.nvim")
time([[Config for matchparen.nvim]], false)
-- Config for: goto-preview
time([[Config for goto-preview]], true)
try_loadstring("\27LJ\2\n>\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\17goto-preview\frequire\0", "config", "goto-preview")
time([[Config for goto-preview]], false)
-- Config for: nvim-web-devicons
time([[Config for nvim-web-devicons]], true)
try_loadstring("\27LJ\2\nö\3\0\0\6\0\18\0\0226\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\n\0005\4\4\0005\5\3\0=\5\5\0045\5\6\0=\5\a\0045\5\b\0=\5\t\4=\4\v\3B\1\2\0019\1\f\0005\3\14\0005\4\r\0=\4\15\0035\4\16\0=\4\17\3B\1\2\1K\0\1\0\18tsconfig.json\1\0\3\tname\17TSConfigJson\ticon\bÔÄì\ncolor\f#519aba\f.github\1\0\0\1\0\2\ticon\bÔêà\tname\vGitHub\rset_icon\roverride\1\0\0\ats\1\0\4\16cterm_color\a67\tname\aTs\ticon\bÔØ§\ncolor\f#519aba\17node_modules\1\0\3\tname\16NodeModules\ticon\bÓúò\ncolor\f#90a959\amd\1\0\0\1\0\4\16cterm_color\a67\tname\rMarkdown\ticon\bÔíä\ncolor\f#519aba\nsetup\22nvim-web-devicons\frequire\0", "config", "nvim-web-devicons")
time([[Config for nvim-web-devicons]], false)
-- Config for: bufferline.nvim
time([[Config for bufferline.nvim]], true)
try_loadstring("\27LJ\2\n©\1\0\1\5\0\t\0\0216\1\0\0009\1\1\0018\1\0\0019\1\2\0016\2\0\0009\2\3\0029\2\4\2\18\4\0\0B\2\2\2\6\1\5\0X\3\6Ä\6\1\6\0X\3\4Ä\6\2\a\0X\3\2Ä\a\2\b\0X\3\2Ä+\3\1\0X\4\1Ä+\3\2\0L\3\2\0\14[No Name]\28neo-tree filesystem [1]\fTrouble\rneo-tree\fbufname\afn\rfiletype\abo\bvimÀ\2\1\0\a\0\r\0\0196\0\0\0'\2\1\0B\0\2\0026\1\2\0009\1\3\1'\3\4\0B\1\2\0019\1\5\0005\3\v\0005\4\6\0003\5\a\0=\5\b\0044\5\3\0005\6\t\0>\6\1\5=\5\n\4=\4\f\3B\1\2\1K\0\1\0\foptions\1\0\0\foffsets\1\0\4\rfiletype\rneo-tree\14highlight\14Directory\15text_align\vcenter\ttext\nFiles\18custom_filter\0\1\0\4\fnumbers\tnone\22show_buffer_icons\2\16diagnostics\rnvim_lsp\20show_close_icon\2\nsetup*source ~/.config/nvim/config/bbye.vim\bcmd\bvim\15bufferline\frequire\0", "config", "bufferline.nvim")
time([[Config for bufferline.nvim]], false)
-- Config for: nvim-notify
time([[Config for nvim-notify]], true)
try_loadstring("\27LJ\2\nV\0\0\4\0\5\0\t6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\3\0B\1\2\0016\1\4\0=\0\1\1K\0\1\0\bvim\1\0\1\vrender\fminimal\nsetup\vnotify\frequire\0", "config", "nvim-notify")
time([[Config for nvim-notify]], false)
-- Config for: indent-blankline.nvim
time([[Config for indent-blankline.nvim]], true)
try_loadstring("\27LJ\2\nw\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\31show_current_context_start\1\25show_current_context\2\nsetup\21indent_blankline\frequire\0", "config", "indent-blankline.nvim")
time([[Config for indent-blankline.nvim]], false)
-- Config for: pretty-fold.nvim
time([[Config for pretty-fold.nvim]], true)
try_loadstring("\27LJ\2\n@\0\0\4\0\6\0\a6\0\0\0009\0\1\0'\2\2\0006\3\3\0009\3\4\0039\3\5\3D\0\3\0\14foldlevel\6v\bvim\6>\brep\vstring§\2\1\0\6\0\r\0\0216\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\6\0005\4\4\0003\5\5\0>\5\2\4=\4\a\0035\4\b\0=\4\t\3=\3\n\2B\0\2\0016\0\0\0'\2\v\0B\0\2\0029\0\2\0005\2\f\0B\0\2\1K\0\1\0\1\0\1\bkey\6l\24pretty-fold.preview\rsections\nright\1\6\0\0\t‚î´ \27number_of_folded_lines\a: \15percentage\15 ‚î£‚îÅ‚îÅ\tleft\1\0\0\0\1\6\0\0\t‚îÅ \0\f ‚îÅ‚î´\fcontent\b‚î£\1\0\2\21keep_indentation\1\14fill_char\b‚îÅ\nsetup\16pretty-fold\frequire\0", "config", "pretty-fold.nvim")
time([[Config for pretty-fold.nvim]], false)
-- Config for: nvim-autopairs
time([[Config for nvim-autopairs]], true)
try_loadstring("\27LJ\2\nM\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\rcheck_ts\2\nsetup\19nvim-autopairs\frequire\0", "config", "nvim-autopairs")
time([[Config for nvim-autopairs]], false)
-- Config for: lsp-trouble.nvim
time([[Config for lsp-trouble.nvim]], true)
try_loadstring("\27LJ\2\nw\0\0\4\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\3\0B\1\2\1K\0\1\0\1\0\4\25use_diagnostic_signs\1\14auto_open\2\15auto_close\2\17auto_preview\2\nsetup\ftrouble\frequire\0", "config", "lsp-trouble.nvim")
time([[Config for lsp-trouble.nvim]], false)
-- Config for: cmp-cmdline
time([[Config for cmp-cmdline]], true)
try_loadstring("\27LJ\2\n÷\1\0\0\n\0\r\0\0286\0\0\0'\2\1\0B\0\2\0029\1\2\0009\1\3\1'\3\4\0005\4\6\0004\5\3\0005\6\5\0>\6\1\5=\5\a\4B\1\3\0019\1\2\0009\1\3\1'\3\b\0005\4\f\0009\5\t\0009\5\a\0054\a\3\0005\b\n\0>\b\1\a4\b\3\0005\t\v\0>\t\1\bB\5\3\2=\5\a\4B\1\3\1K\0\1\0\1\0\0\1\0\1\tname\fcmdline\1\0\1\tname\tpath\vconfig\6:\fsources\1\0\0\1\0\1\tname\vbuffer\6/\fcmdline\nsetup\bcmp\frequire\0", "config", "cmp-cmdline")
time([[Config for cmp-cmdline]], false)
-- Config for: vgit.nvim
time([[Config for vgit.nvim]], true)
try_loadstring("\27LJ\2\nÔ\4\0\2\22\0\26\3Z9\2\0\0019\3\1\0\5\2\3\0X\4\1Ä'\3\2\0006\4\3\0009\4\4\0046\6\3\0009\6\5\6B\6\1\0029\a\6\0B\4\3\2\25\4\0\0044\5\a\0005\6\a\0>\6\1\0055\6\b\0>\6\2\0055\6\t\0>\6\3\0055\6\n\0>\6\4\0055\6\v\0>\6\5\0055\6\f\0>\6\6\5)\6\1\0008\a\6\5:\b\1\a:\t\2\a)\n\1\0\1\4\n\0X\n\nÄ\21\n\5\0\4\6\n\0X\n\aÄU\n\6Ä8\a\6\5:\b\1\a:\t\2\a\"\4\b\4\22\6\1\6X\nÛ9\n\r\0009\v\14\0\14\0\v\0X\v\bÄ'\3\2\0'\n\15\0006\v\16\0009\v\17\v'\r\18\0\18\14\3\0\18\15\n\0D\v\4\0)\vˇ\0\21\f\n\0\1\v\f\0X\f\aÄ\18\14\n\0009\f\19\n)\15\1\0\18\16\v\0B\f\4\2'\r\20\0&\n\r\f6\f\16\0009\f\17\f'\14\21\0\18\15\3\0006\16\16\0009\16\17\16'\18\22\0)\19\0\0\3\19\4\0X\19\6Ä6\19\23\0009\19\24\19\22\21\2\4B\19\2\2\14\0\19\0X\20\4Ä6\19\23\0009\19\25\19\23\21\2\4B\19\2\2\18\20\t\0B\16\4\2\18\17\n\0D\f\5\0\tceil\nfloor\tmath\14%s %s ago\19 %s, %s ‚Ä¢ %s\b...\bsub\15 %s ‚Ä¢ %s\vformat\vstring\24Uncommitted changes\14committed\19commit_message\1\3\0\0\3<\fseconds\1\3\0\0\3<\fminutes\1\3\0\0\3\24\nhours\1\3\0\0\3\30\tdays\1\3\0\0\3\f\vmonths\1\3\0\0\3\1\nyears\16author_time\ttime\rdifftime\aos\bYou\vauthor\14user.nameÄ‘\29\2\1ÄÄÄˇ\3ø\f\1\0\b\0002\00096\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\0035\4\19\0005\5\6\0005\6\a\0=\6\b\0055\6\t\0=\6\n\0055\6\v\0=\6\f\0055\6\r\0=\6\14\0055\6\15\0=\6\16\0055\6\17\0=\6\18\5=\5\20\0045\5\21\0003\6\22\0=\6\23\5=\5\24\0045\5\25\0=\5\26\0045\5\27\0=\5\28\0045\5\29\0=\5\30\0045\5\31\0005\6!\0005\a \0=\a\"\0065\a#\0=\a$\0065\a%\0=\a\n\0065\a&\0=\a\14\0065\a'\0=\a\f\6=\6(\0055\6*\0005\a)\0=\a\30\0065\a+\0=\a,\6=\6-\5=\5.\0045\5/\0=\0050\4=\0041\3B\1\2\1K\0\1\0\rsettings\fsymbols\1\0\1\tvoid\b‚£ø\nsigns\nusage\tmain\1\0\3\badd\16GitSignsAdd\vremove\19GitSignsDelete\vchange\19GitSignsChange\1\0\0\1\0\2\badd\18GitSignsAddLn\vremove\21GitSignsDeleteLn\16definitions\1\0\3\vtexthl\19GitSignsChange\ticon\b‚ü´\ttext\b‚îÉ\1\0\3\vtexthl\19GitSignsDelete\ticon\b‚àí\ttext\b‚îÉ\1\0\3\vtexthl\16GitSignsAdd\ticon\b‚äû\ttext\b‚îÉ\21GitSignsDeleteLn\1\0\2\vlinehl\21GitSignsDeleteLn\ttext\5\18GitSignsAddLn\1\0\0\1\0\2\vlinehl\18GitSignsAddLn\ttext\5\1\0\1\rpriority\3\n\vscreen\1\0\1\20diff_preference\funified\25authorship_code_lens\1\0\1\fenabled\2\16live_gutter\1\0\1\fenabled\2\15live_blame\vformat\0\1\0\1\fenabled\2\bhls\1\0\0\18GitWordDelete\1\0\2\abg\f#960f3d\roverride\1\15GitWordAdd\1\0\2\abg\f#5d7a22\roverride\1\19GitSignsDelete\1\0\2\afg\f#e95678\roverride\1\19GitSignsChange\1\0\2\afg\f#f16d0a\roverride\2\16GitSignsAdd\1\0\2\afg\f#d7ffaf\roverride\1\27GitBackgroundSecondary\1\0\1\roverride\1\1\0\6\18GitSignsAddLn\fDiffAdd\25GitBackgroundPrimary\16NormalFloat\14GitBorder\vLineNr\21GitSignsDeleteLn\15DiffDelete\14GitLineNr\vLineNr\15GitComment\fComment\fkeymaps\1\0\0\1\0\14\17n <leader>gq\21project_hunks_qf\17n <leader>gd\25project_diff_preview\17n <leader>gb\25buffer_blame_preview\17n <leader>gh\27buffer_history_preview\17n <leader>gx\27toggle_diff_preference\17n <leader>gl\26project_hunks_preview\17n <leader>gp\24buffer_hunk_preview\fn <C-k>\fhunk_up\17n <leader>gr\22buffer_hunk_reset\17n <leader>gg buffer_gutter_blame_preview\17n <leader>gs\22buffer_hunk_stage\fn <C-j>\14hunk_down\17n <leader>gu\17buffer_reset\17n <leader>gf\24buffer_diff_preview\nsetup\tvgit\frequire\0", "config", "vgit.nvim")
time([[Config for vgit.nvim]], false)
-- Config for: neo-tree.nvim
time([[Config for neo-tree.nvim]], true)
try_loadstring("\27LJ\2\nÊ\3\0\2\n\1\24\0G9\2\0\0\14\0\2\0X\3\1Ä'\2\1\0009\3\2\0\14\0\3\0X\4\1Ä'\3\1\0009\4\3\0\14\0\4\0X\5\2Ä-\4\0\0009\4\4\0046\5\5\0'\a\6\0B\5\2\0029\6\a\1\a\6\b\0X\6\"Ä-\6\0\0009\4\t\0069\6\n\1\6\6\v\0X\6\6Ä9\6\n\1\6\6\f\0X\6\3Ä9\6\n\1\a\6\r\0X\6\bÄ9\6\14\0059\b\n\1B\6\2\3\f\2\6\0X\b\0Ä\f\4\a\0X\b\0ÄX\6\26Ä\18\b\1\0009\6\15\1B\6\2\2\15\0\6\0X\a\5Ä9\6\16\0\f\2\6\0X\a\1Ä'\2\17\0X\6\16Ä9\6\18\0\f\2\6\0X\a\1Ä'\2\19\0X\6\vÄ9\6\a\1\a\6\20\0X\6\bÄ9\6\14\0059\b\n\0019\t\21\1B\6\3\3\f\2\6\0X\b\0Ä\f\4\a\0X\b\0Ä5\6\22\0\18\a\2\0\18\b\3\0&\a\b\a=\a\23\6=\4\3\6L\6\2\0\1¿\ttext\1\0\0\bext\tfile\6+\18folder_closed\6-\16folder_open\16is_expanded\rget_icon\f.github\t.git\17node_modules\tname\19DIRECTORY_ICON\14directory\ttype\22nvim-web-devicons\frequire\14FILE_ICON\14highlight\fpadding\6 \fdefaultú\2\0\0\3\0\6\0\n6\0\0\0009\0\1\0009\0\2\0\a\0\3\0X\0\4Ä6\0\0\0009\0\4\0'\2\5\0B\0\2\1K\0\1\0”\1              setlocal nocursorcolumn\n              setlocal virtualedit=all\n              hi link NeoTreeDirectoryName Directory\n              hi link NeoTreeDirectoryIcon NeoTreeDirectoryName\n            \bcmd\rneo-tree\rfiletype\abo\bvim„\f\1\0\t\0&\00096\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\2\3\0005\4\4\0005\5\5\0005\6\6\0=\6\a\0055\6\b\0005\a\t\0=\a\n\6=\6\v\0055\6\18\0004\a\a\0005\b\f\0>\b\1\a5\b\r\0>\b\2\a5\b\14\0>\b\3\a5\b\15\0>\b\4\a5\b\16\0>\b\5\a5\b\17\0>\b\6\a=\a\19\6=\6\20\0055\6\22\0003\a\21\0=\a\23\6=\6\24\5=\5\25\0045\5\26\0005\6\27\0005\a\28\0=\a\n\6=\6\v\5=\5\29\0045\5 \0005\6\30\0005\a\31\0=\a\n\6=\6\v\5=\5!\0044\5\3\0005\6\"\0003\a#\0=\a$\6>\6\1\5=\5%\4B\2\2\0012\0\0ÄK\0\1\0\19event_handlers\fhandler\0\1\0\1\nevent\21vim_buffer_enter\15git_status\1\0\0\1\0\18\6d\vdelete\agp\rgit_push\6s\16open_vsplit\agr\20git_revert_file\6C\15close_node\18<2-LeftMouse>\topen\agg\24git_commit_and_push\6S\15open_split\6A\16git_add_all\6r\vrename\agu\21git_unstage_file\6x\21cut_to_clipboard\aga\17git_add_file\6p\25paste_from_clipboard\6c\22copy_to_clipboard\agc\15git_commit\t<cr>\topen\6R\frefresh\1\0\1\rposition\nfloat\fbuffers\1\0\r\6d\vdelete\6p\25paste_from_clipboard\6c\22copy_to_clipboard\6.\rset_root\6a\badd\18<2-LeftMouse>\topen\t<cr>\topen\6S\15open_split\6s\16open_vsplit\6r\vrename\6R\frefresh\6x\21cut_to_clipboard\t<bs>\16navigate_up\1\0\1\rposition\tleft\1\0\1\18show_unloaded\1\15filesystem\15components\ticon\1\0\0\0\14renderers\14directory\1\0\0\1\2\1\0\16diagnostics\16errors_only\2\1\2\1\0\14clipboard\14highlight\19NeoTreeDimText\1\2\1\0\19symlink_target\14highlight\30NeoTreeSymbolicLinkTarget\1\2\0\0\tname\1\2\0\0\19current_filter\1\2\3\0\ticon\18folder_closed\bÔÑî\16folder_open\bÔÅº\fpadding\6 \vwindow\rmappings\1\0\20\6d\vdelete\abd\18buffer_delete\6/\23filter_as_you_type\6R\frefresh\6C\15close_node\18<2-LeftMouse>\topen\6f\21filter_on_submit\6S\15open_split\6s\16open_vsplit\6H\18toggle_hidden\6r\vrename\n<c-x>\17clear_filter\6x\21cut_to_clipboard\6p\25paste_from_clipboard\6c\22copy_to_clipboard\6.\rset_root\6a\badd\t<cr>\topen\6I\21toggle_gitignore\t<bs>\16navigate_up\1\0\2\nwidth\3(\rposition\tleft\ffilters\1\0\2\16show_hidden\2\22respect_gitignore\2\1\0\2\24follow_current_file\2\27use_libuv_file_watcher\2\1\0\3\23popup_border_style\frounded\22enable_git_status\2\23enable_diagnostics\2\nsetup\27neo-tree.ui.highlights\rneo-tree\frequire\0", "config", "neo-tree.nvim")
time([[Config for neo-tree.nvim]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0056\0\0\0'\2\1\0B\0\2\0029\0\2\0D\0\1\0\vstatus\15lsp-status\frequireô\3\1\0\6\0\25\0\0296\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\a\0005\4\6\0=\4\b\3=\3\t\0025\3\v\0005\4\n\0=\4\f\0035\4\r\0=\4\14\0035\4\15\0=\4\16\0035\4\18\0003\5\17\0>\5\1\4=\4\19\0035\4\20\0=\4\21\0035\4\22\0=\4\23\3=\3\24\2B\0\2\1K\0\1\0\rsections\14lualine_z\1\2\0\0\rlocation\14lualine_y\1\2\0\0\rprogress\14lualine_x\1\5\0\0\0\rencoding\15fileformat\rfiletype\0\14lualine_c\1\2\0\0\rfilename\14lualine_b\1\4\0\0\vbranch\tdiff\16diagnostics\14lualine_a\1\0\0\1\2\0\0\tmode\foptions\23disabled_filetypes\1\0\0\1\2\0\0\rneo-tree\15extentions\1\2\0\0\rfugitive\1\0\1\ntheme\tauto\nsetup\flualine\frequire\0", "config", "lualine.nvim")
time([[Config for lualine.nvim]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\fComment\frequire\0", "config", "Comment.nvim")
time([[Config for Comment.nvim]], false)
-- Config for: telescope-frecency.nvim
time([[Config for telescope-frecency.nvim]], true)
try_loadstring("\27LJ\2\nM\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\rfrecency\19load_extension\14telescope\frequire\0", "config", "telescope-frecency.nvim")
time([[Config for telescope-frecency.nvim]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
try_loadstring("\27LJ\2\nå\r\0\0\a\0 \0.6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\6\0005\4\4\0005\5\3\0=\5\5\4=\4\a\3B\1\2\0016\1\b\0006\3\0\0'\4\t\0B\1\3\3\15\0\1\0X\3\3Ä9\3\2\0025\5\n\0B\3\2\0019\3\v\0005\5\f\0005\6\r\0=\6\14\0055\6\15\0=\6\16\0055\6\17\0=\6\18\0055\6\19\0=\6\20\0055\6\21\0B\3\3\0019\3\v\0005\5\22\0005\6\23\0=\6\14\0055\6\24\0=\6\25\0055\6\26\0=\6\27\0055\6\28\0=\6\16\0055\6\29\0=\6\30\0055\6\31\0B\3\3\1K\0\1\0\1\0\1\vprefix\6g\6L\1\0\1\tname\16align right\1\0\1\tname\15align left\6s\1\0\f\6_\15snake_case\6p\15mixed case\6s\18Sentence case\6U\16UPPER_SNAKE\6t\15Title Case\tname\ncaser\6-\14dash-case\6m\15mixed case\6k\14dash-case\f<space>\15space case\6u\16UPPER_SNAKE\6c\14camelCase\6n\1\0\2\tname\16incremental\6n\vselect\1\0\2\6c\17comment line\tname\rcomments\1\0\a\6d\21goto definitions\6D\21goto declaration\6r\20goto references\6u\14lowercase\6U\14uppercase\6i\25goto implementations\6%\29match surround backwards\1\0\1\vprefix\r<leader>\6g\1\0\r\6d#preview diff         (project)\6h\"preview history      (buffer)\6s\15stage hunk\6f\"preview diff         (buffer)\6u\17reset buffer\tname\bgit\6g\"preview gutter blame (buffer)\6p\"preview hunks        (buffer)\6q#hunks quickfix       (project)\6l#preview hunks        (project)\6r\17unstage hunk\6x\27toggle diff preference\6b\"preview blame        (buffer)\6f\1\0\6\tname\tfind\6h\17find in help\6s\16find symbol\6f\16format file\6g\30find in files (live grep)\6b\17find buffers\6l\1\0\a\6e(open diagnostics in floating window\6d\21goto declaration\6k\19signature_help\6f\16format file\6D\25goto type definition\tname\blsp\6r\vrename\6c\1\0\3\tname\fcolours\6h\20format as hsl()\6c\24cycle colour format\1\0\14\6e(open diagnostics in floating window\6p\15find files\6s\14save file\6.\17code actions\6t\18choose buffer\6w\17close buffer\6F\30find in files (live grep)\6D\25goto type definition\6}\16next buffer\6q\tquit\6\\\21toggle file tree\6R\20rename refactor\6k\20command pallete\6{\20previous buffer\rregister\1\0\3\18select_prompt\20Command Pallete\20include_builtin\2\28auto_register_which_key\2\14legendary\npcall\fplugins\1\0\0\rspelling\1\0\0\1\0\1\fenabled\2\nsetup\14which-key\frequire\0", "config", "which-key.nvim")
time([[Config for which-key.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n¶\4\0\0\t\0\27\0 6\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\2\3\0005\4\19\0005\5\4\0005\6\5\0=\6\6\0055\6\a\0=\6\b\0055\6\16\0005\a\n\0009\b\t\1=\b\v\a9\b\f\1=\b\r\a9\b\14\1=\b\15\a=\a\17\6=\6\18\5=\5\20\0045\5\22\0005\6\21\0=\6\23\0055\6\24\0=\6\25\5=\5\26\4B\2\2\1K\0\1\0\fpickers\30lsp_workspace_diagnostics\1\0\1\ntheme\rdropdown\21lsp_code_actions\1\0\0\1\0\1\ntheme\vcursor\rdefaults\1\0\0\rmappings\6i\1\0\0\n<esc>\nclose\n<C-j>\24move_selection_next\n<C-k>\1\0\0\28move_selection_previous\25file_ignore_patterns\1\3\0\0\t.git\17node_modules\22vimgrep_arguments\1\n\0\0\arg\18--color=never\17--no-heading\20--with-filename\18--line-number\r--column\17--smart-case\r--ignore\r--hidden\1\0\1\18prompt_prefix\nüîé \nsetup\22telescope.actions\14telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\nÇ\t\0\0\5\0&\00056\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\6\0=\3\a\0025\3\b\0005\4\t\0=\4\n\3=\3\v\0025\3\f\0=\3\r\0025\3\14\0=\3\15\0025\3\16\0005\4\17\0=\4\18\3=\3\19\2B\0\2\0016\0\0\0'\2\20\0B\0\2\0029\0\2\0005\2\24\0005\3\21\0005\4\22\0=\4\23\3=\3\25\0025\3\26\0=\3\27\0024\3\0\0=\3\28\2B\0\2\0016\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2!\0005\3\29\0004\4\0\0=\4\30\0035\4\31\0=\4 \3=\3\"\0025\3$\0005\4#\0=\4%\3=\3\5\2B\0\2\1K\0\1\0\20custom_captures\1\0\0\1\0\0011(method_signature name:(property_identifier)\25BP_TSMethodSignature\15playground\1\0\0\16keybindings\1\0\n\14goto_node\t<cr>\27toggle_anonymous_nodes\6a\vupdate\6R\30toggle_injected_languages\6t\21toggle_hl_groups\6i\24toggle_query_editor\6o\19focus_language\6f\14show_help\6?\21unfocus_language\6F\28toggle_language_display\6I\fdisable\1\0\3\venable\2\20persist_queries\1\15updatetime\3\25\fexclude\vexpand\1\6\0\0\rfunction\vmethod\ntable\vobject\17if_statement\fdimming\1\0\2\15treesitter\2\fcontext\3\n\ncolor\1\3\0\0\vNormal\f#ffffff\1\0\2\rinactive\1\nalpha\4\0ÄÄ¿˛\3\rtwilight\fautotag\14filetypes\1\17\0\0\thtml\bnjk\njinja\rnunjucks\ajs\15javascript\bjsx\20javascriptreact\amd\rmarkdown\vsvelte\ats\15typescript\btsx\20typescriptreact\bvue\1\0\1\venable\2\fendwise\1\0\1\venable\2\vindent\1\0\1\venable\2\16textobjects\fkeymaps\1\0\4\aac\17@class.outer\aif\20@function.inner\aaf\20@function.outer\aic\17@class.inner\1\0\2\venable\2\14lookahead\2\26incremental_selection\1\0\1\venable\2\14highlight\1\0\1\venable\2\1\0\1\21ensure_installed\15maintained\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\n1\0\1\4\1\2\0\5-\1\0\0009\1\0\0019\3\1\0B\1\2\1K\0\1\0\2¿\tbody\19expand_snippetÏ\t\1\0\f\0B\0ä\0016\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0026\2\0\0'\4\3\0B\2\2\0029\3\4\0005\5\b\0005\6\6\0003\a\5\0=\a\a\6=\6\t\0055\6\r\0009\a\n\0009\t\n\0009\t\v\t)\v¸ˇB\t\2\0025\n\f\0B\a\3\2=\a\14\0069\a\n\0009\t\n\0009\t\v\t)\v\4\0B\t\2\0025\n\15\0B\a\3\2=\a\16\0069\a\n\0009\t\n\0009\t\17\tB\t\1\0025\n\18\0B\a\3\2=\a\19\0069\a\20\0009\a\21\a=\a\22\0069\a\n\0005\t\24\0009\n\n\0009\n\23\nB\n\1\2=\n\25\t9\n\n\0009\n\26\nB\n\1\2=\n\27\tB\a\2\2=\a\28\0069\a\n\0009\a\29\a5\t\30\0B\a\2\2=\a\31\6=\6\n\0059\6\20\0009\6 \0064\b\n\0005\t!\0>\t\1\b5\t\"\0>\t\2\b5\t#\0>\t\3\b5\t$\0>\t\4\b5\t%\0>\t\5\b5\t&\0>\t\6\b5\t'\0>\t\a\b5\t(\0>\t\b\b5\t)\0>\t\t\b4\t\3\0005\n*\0>\n\1\tB\6\3\2=\6 \0055\0065\0004\a\t\0009\b\20\0009\b+\b9\b,\b>\b\1\a9\b\20\0009\b+\b9\b-\b>\b\2\a9\b\20\0009\b+\b9\b.\b>\b\3\a6\b\0\0'\n/\0B\b\2\0029\b0\b>\b\4\a9\b\20\0009\b+\b9\b1\b>\b\5\a9\b\20\0009\b+\b9\b2\b>\b\6\a9\b\20\0009\b+\b9\b3\b>\b\a\a9\b\20\0009\b+\b9\b4\b>\b\b\a=\a6\6=\0067\0055\6:\0009\a8\0015\t9\0B\a\2\2=\a;\6=\6<\0055\6=\0=\6>\5B\3\2\0016\3?\0009\3@\3'\5A\0B\3\2\0012\0\0ÄK\0\1\0{    augroup NoCmp\n      autocmd FileType neo-tree lua require'cmp'.setup.buffer { enabled = false }\n    augroup END\n  \bcmd\bvim\17experimental\1\0\1\15ghost_text\2\15formatting\vformat\1\0\0\1\0\1\14with_text\2\15cmp_format\fsorting\16comparators\1\0\0\norder\vlength\14sort_text\tkind\nunder\25cmp-under-comparator\nscore\nexact\voffset\fcompare\1\0\2\19keyword_length\3\5\tname\vbuffer\1\0\1\tname\tfish\1\0\1\tname\vsnippy\1\0\1\tname\nemoji\1\0\1\tname\tcalc\1\0\1\tname\bnpm\1\0\1\tname\rnvim_lua\1\0\1\tname\28nvim_lsp_signature_help\1\0\1\tname\fcmp_git\1\0\1\tname\rnvim_lsp\fsources\t<CR>\1\0\1\vselect\2\fconfirm\n<C-e>\6c\nclose\6i\1\0\0\nabort\n<C-y>\fdisable\vconfig\16<C-S-Space>\1\3\0\0\6i\6c\rcomplete\n<C-f>\1\3\0\0\6i\6c\n<C-b>\1\0\0\1\3\0\0\6i\6c\16scroll_docs\fmapping\fsnippet\1\0\0\vexpand\1\0\0\0\nsetup\vsnippy\flspkind\bcmp\frequire\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: nvim-regexplainer
time([[Config for nvim-regexplainer]], true)
try_loadstring("\27LJ\2\nJ\0\1\b\0\3\0\14'\1\0\0009\2\1\0)\3\0\0\1\3\2\0X\2\bÄ)\2\1\0009\3\1\0)\4\1\0M\2\4Ä\18\6\1\0'\a\2\0&\1\a\6O\2¸L\1\2\0\a> \ndepth\6\n|\1\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\5\0003\4\4\0=\4\6\3=\3\a\2B\0\2\1K\0\1\0\14narrative\14separator\1\0\0\0\1\0\1\fdisplay\nsplit\nsetup\22nvim-regexplainer\frequire\0", "config", "nvim-regexplainer")
time([[Config for nvim-regexplainer]], false)
-- Config for: nightfox.nvim
time([[Config for nightfox.nvim]], true)
try_loadstring("\27LJ\2\n¡\4\0\0\a\0\28\0$6\0\0\0006\2\1\0'\3\2\0B\0\3\3\14\0\0\0X\2\1ÄK\0\1\0009\2\3\0015\4\4\0005\5\5\0=\5\6\0044\5\0\0=\5\a\0045\5\b\0=\5\t\0045\5\v\0005\6\n\0=\6\f\0055\6\r\0=\6\14\0055\6\15\0=\6\16\0055\6\17\0=\6\18\0055\6\19\0=\6\20\0055\6\21\0=\6\22\0055\6\23\0=\6\24\5=\5\25\4B\2\2\0019\2\26\1'\4\27\0B\2\2\1K\0\1\0\fduskfox\tload\rhlgroups\16LspCodeLens\1\0\2\abg\n${bg}\nstyle\vitalic\vFolded\1\0\1\abg\n${bg}\19GitSignsChange\1\0\1\afg\f#f16d0a\31IndentBlankLineContextChar\1\0\1\afg\f#88ddff\15MatchParen\1\0\1\afg\vyellow\fComment\1\0\1\nstyle\vitalic\21TSPunctDelimiter\1\0\0\1\0\1\afg\v${red}\vcolors\1\0\4\14bg_visual\f#131b24\vbg_alt\f#010101\17bg_highlight\f#121820\abg\f#000000\finverse\vstyles\1\0\3\14functions\16italic,bold\rkeywords\tbold\rcomments\vitalic\1\0\2\bfox\fduskfox\valt_nc\2\nsetup\rnightfox\frequire\npcall\0", "config", "nightfox.nvim")
time([[Config for nightfox.nvim]], false)
-- Config for: alpha-nvim
time([[Config for alpha-nvim]], true)
try_loadstring("\27LJ\2\nQ\0\1\a\0\4\0\r\18\3\0\0009\1\0\0'\4\1\0B\1\3\2'\2\2\0\n\1\0\0X\3\5Ä\18\5\1\0009\3\3\1)\6\2\0B\3\3\2\18\2\3\0L\2\2\0\bsub\5\15^.+(%..+)$\nmatchD\0\1\a\2\2\0\t-\1\0\0\18\3\0\0B\1\2\2-\2\1\0009\2\0\2\18\4\0\0\18\5\1\0005\6\1\0D\2\4\0\a¿\5¿\1\0\1\fdefault\2\rget_icon°\3\0\3\16\3\17\1H\14\0\2\0X\3\1Ä\18\2\0\0+\3\0\0004\4\0\0-\5\0\0\18\a\0\0B\5\2\0036\a\0\0-\t\1\0009\t\1\tB\a\2\2\a\a\2\0X\b\fÄ\15\0\6\0X\b\nÄ-\b\1\0009\b\1\b\15\0\b\0X\t\6Ä6\b\3\0009\b\4\b\18\n\4\0005\v\5\0>\6\1\vB\b\3\1\a\a\6\0X\b\bÄ6\b\3\0009\b\4\b\18\n\4\0005\v\a\0-\f\1\0009\f\1\f>\f\1\vB\b\3\1\18\b\5\0'\t\b\0&\3\t\b-\b\2\0009\b\t\b\18\n\1\0\18\v\3\0\18\f\2\0&\v\f\v'\f\n\0\18\r\0\0'\14\v\0&\f\14\fB\b\4\2\18\v\2\0009\t\f\2'\f\r\0B\t\3\2\n\t\0\0X\n\rÄ6\n\3\0009\n\4\n\18\f\4\0005\r\14\0\21\14\3\0\23\14\0\14>\14\2\r\21\14\t\0\21\15\3\0 \14\15\14\23\14\0\14>\14\3\rB\n\3\0019\n\15\b=\4\16\nL\b\2\0\b¿\5¿\4¿\ahl\topts\1\2\0\0\fComment\b.*/\nmatch\n <CR>\f<cmd>e \vbutton\a  \1\4\0\0\0\3\0\3\1\vstring\1\4\0\0\0\3\0\3\1\vinsert\ntable\fboolean\14highlight\ttype\4i\0\2\6\1\5\0\r6\2\0\0009\2\1\2\18\4\0\0'\5\2\0B\2\3\2\14\0\2\0X\3\5Ä6\2\3\0009\2\4\2-\4\0\0\18\5\1\0B\2\3\2L\2\2\0\n¿\17tbl_contains\bvim\19COMMIT_EDITMSG\tfind\vstring–\5\0\4\20\4\23\1á\1\14\0\3\0X\4\1Ä-\3\0\0\14\0\2\0X\4\1Ä)\2\t\0004\4\0\0006\5\0\0006\a\1\0009\a\2\a9\a\3\aB\5\2\4H\b)Ä\21\n\4\0\5\n\2\0X\n\1ÄX\5'Ä+\n\0\0\14\0\1\0X\v\2Ä+\n\2\0X\v\6Ä6\v\1\0009\v\4\v\18\r\t\0\18\14\1\0B\v\3\2\18\n\v\0009\v\5\3\15\0\v\0X\f\bÄ9\v\5\3\18\r\t\0-\14\1\0\18\16\t\0B\14\2\0A\v\1\2\14\0\v\0X\f\1Ä+\v\1\0006\f\1\0009\f\6\f9\f\a\f\18\14\t\0B\f\2\2\t\f\0\0X\f\aÄ\15\0\n\0X\f\5Ä\14\0\v\0X\f\3Ä\21\f\4\0\22\f\0\f<\t\f\4F\b\3\3R\b’5\5\b\0)\6#\0004\a\0\0006\b\t\0\18\n\4\0B\b\2\4X\vAÄ+\r\0\0\15\0\1\0X\14\bÄ6\14\1\0009\14\6\0149\14\n\14\18\16\f\0'\17\v\0B\14\3\2\18\r\14\0X\14\aÄ6\14\1\0009\14\6\0149\14\n\14\18\16\f\0'\17\f\0B\14\3\2\18\r\14\0\21\14\r\0\1\6\14\0X\14\23Ä-\14\2\0009\14\r\14\18\16\r\0B\14\2\2\18\16\14\0009\14\14\14)\17\1\0005\18\15\0B\14\4\2\18\r\14\0\21\14\r\0\1\6\14\0X\14\nÄ-\14\2\0009\14\r\14\18\16\r\0B\14\2\2\18\16\14\0009\14\14\14)\17\1\0005\18\16\0B\14\4\2\18\r\14\0'\14\17\0\21\15\5\0\3\v\15\0X\15\2Ä8\14\v\5X\15\aÄ6\15\18\0 \17\0\v\23\17\0\17\21\18\5\0!\17\18\17B\15\2\2\18\14\15\0-\15\3\0\18\17\f\0'\18\19\0\18\19\14\0&\18\19\18\18\19\r\0B\15\4\2<\15\v\aE\v\3\3R\vΩ5\b\20\0=\a\21\b4\t\0\0=\t\22\bL\b\2\0\v¿\a¿\3¿\t¿\topts\bval\1\0\1\ttype\ngroup\6 \rtostring\5\1\2\0\0\3ˇˇˇˇ\15\1\3\0\0\3˛ˇˇˇ\15\3ˇˇˇˇ\15\fshorten\bnew\a:~\a:.\16fnamemodify\vipairs\1\4\0\0\6a\6s\6d\17filereadable\afn\vignore\15startswith\roldfiles\6v\bvim\npairs\2ì\2\0\0\14\1\r\0!6\0\0\0009\0\1\0)\2\1\0-\3\0\0\21\3\3\0B\0\3\2-\1\0\0008\1\0\0014\2\0\0006\3\2\0\18\5\1\0B\3\2\4X\6\rÄ'\b\3\0\18\t\6\0&\b\t\b5\t\4\0=\a\5\t5\n\6\0=\b\a\n=\n\b\t6\n\t\0009\n\n\n\18\f\2\0\18\r\t\0B\n\3\1E\6\3\3R\6Ò5\3\v\0=\2\5\0035\4\f\0=\4\b\3L\3\2\0\15¿\1\0\1\rposition\vcenter\1\0\1\ttype\ngroup\vinsert\ntable\topts\ahl\1\0\2\rposition\vcenter\18shrink_margin\1\bval\1\0\1\ttype\ttext\14StartLogo\vipairs\vrandom\tmath1\0\0\6\2\0\1\b4\0\3\0-\1\0\0)\3\1\0-\4\1\0)\5\t\0B\1\4\0?\1\0\0L\0\2\0\f¿\6¿\3ÄÄ¿ô\4ñ\r\1\0\"\0J\1æ\0016\0\0\0006\2\1\0'\3\2\0B\0\3\3\14\0\0\0X\2\1Ä2\0µÄ6\2\0\0006\4\1\0'\5\3\0B\2\3\3\14\0\2\0X\4\1Ä2\0ØÄ6\4\1\0'\6\4\0B\4\2\0026\5\1\0'\a\5\0B\5\2\0026\6\6\0009\6\a\0069\6\b\6B\6\1\0023\a\t\0003\b\n\0003\t\v\0005\n\f\0005\v\14\0003\f\r\0=\f\15\v3\f\16\0006\r\6\0009\r\a\r9\r\17\r'\15\18\0B\r\2\0024\14\3\0\18\15\r\0'\16\19\0&\15\16\15>\15\1\0146\15\6\0009\15\a\0159\15\20\15'\17\21\0B\15\2\2)\16d\0\3\16\15\0X\15\aÄ6\15\22\0009\15\23\15\18\17\14\0\18\18\r\0'\19\24\0&\18\19\18B\15\3\0016\15\6\0009\15\a\0159\15\25\15'\17\21\0B\15\2\2)\16<\0\3\16\15\0X\15\aÄ6\15\22\0009\15\23\15\18\17\14\0\18\18\r\0'\19\26\0&\18\19\18B\15\3\0014\15\0\0006\16\27\0\18\18\14\0B\16\2\4X\19\22Ä6\21\27\0006\23\6\0009\23\a\0239\23\28\23\18\25\20\0B\23\2\0A\21\0\4X\24\fÄ6\26\22\0009\26\23\26\18\28\15\0006\29\6\0009\29\a\0299\29\29\29\18\31\20\0' \30\0\18!\25\0&\31!\31B\29\2\0A\26\1\1E\24\3\3R\24ÚE\19\3\3R\19Ë3\16\31\0005\17 \0004\18\4\0005\19!\0005\20\"\0=\20#\19>\19\1\0185\19$\0>\19\2\0185\19%\0003\20&\0=\20'\0195\20(\0=\20#\19>\19\3\18=\18'\0175\18)\0004\19\n\0005\20*\0005\21+\0=\21#\20>\20\1\0195\20,\0>\20\2\0199\20-\4'\22.\0'\23/\0'\0240\0B\20\4\2>\20\3\0199\20-\4'\0221\0'\0232\0'\0243\0B\20\4\2>\20\4\0199\20-\4'\0224\0'\0235\0'\0246\0B\20\4\2>\20\5\0199\20-\4'\0227\0'\0238\0'\0249\0B\20\4\2>\20\6\0199\20-\4'\22:\0'\23;\0'\24<\0B\20\4\2>\20\a\0199\20-\4'\22=\0'\23>\0'\24?\0B\20\4\2>\20\b\0199\20-\4'\22@\0'\23A\0'\24B\0B\20\4\0?\20\0\0=\19'\0189\19C\0015\21G\0004\22\a\0005\23D\0>\23\1\22\18\23\16\0B\23\1\2>\23\2\0225\23E\0>\23\3\22>\17\4\0225\23F\0>\23\5\22>\18\6\22=\22H\0215\22I\0=\22#\21B\19\2\0012\0\0ÄK\0\1\0K\0\1\0K\0\1\0\1\0\1\vmargin\3\5\vlayout\1\0\0\1\0\2\bval\3\2\ttype\fpadding\1\0\2\bval\3\2\ttype\fpadding\1\0\2\bval\3\2\ttype\fpadding\nsetup\f:qa<CR>\14Ôôô  Quit\6q\20:PackerSync<CR>\24ÔÑπ  Update plugins\6u$:e ~/.config/nvim/init.lua <CR>\23Óòï  Configuration\6c :ene <BAR> startinsert <CR>\18ÔÖõ  New file\6n\30:Telescope live_grep <CR>\19ÔûÉ  Find text\15<leader>fg\31:Telescope find_files <CR>\19Ôúù  Find file\15<leader> p\21:NeoTreeShow<CR>\23Ôêì  File Explorer\15<leader> /\vbutton\1\0\2\bval\3\1\ttype\fpadding\1\0\2\ahl\19SpecialComment\rposition\vcenter\1\0\2\bval\16Quick links\ttype\ttext\1\0\2\rposition\vcenter\ttype\ngroup\1\0\1\18shrink_margin\1\bval\0\1\0\1\ttype\ngroup\1\0\2\bval\3\1\ttype\fpadding\topts\1\0\3\ahl\19SpecialComment\rposition\vcenter\18shrink_margin\1\1\0\2\bval\17Recent files\ttype\ttext\1\0\1\ttype\ngroup\0\6/\rreadfile\freaddir\vipairs\nlarge\14winheight\twide\vinsert\ntable\6%\rwinwidth\nsmall\28~/.config/nvim/headers/\vexpand\0\vignore\1\0\0\0\1\2\0\0\14gitcommit\0\0\0\vgetcwd\afn\bvim\22nvim-web-devicons\27alpha.themes.dashboard\17plenary.path\nalpha\frequire\npcall\19ÄÄ¿ô\4\0", "config", "alpha-nvim")
time([[Config for alpha-nvim]], false)
-- Config for: nvim-biscuits
time([[Config for nvim-biscuits]], true)
try_loadstring("\27LJ\2\nØ\2\0\0\5\0\14\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\a\0005\4\6\0=\4\b\0035\4\t\0=\4\n\0035\4\v\0=\4\f\3=\3\r\2B\0\2\1K\0\1\0\20language_config\vpython\1\0\1\rdisabled\2\15javascript\1\0\2\15max_length\3P\18prefix_string\n ‚ú® \thtml\1\0\0\1\0\1\18prefix_string\v üåê \19default_config\1\0\3\15max_length\3\f\18prefix_string\v üìé \17min_distance\3\5\1\0\1\18show_on_start\2\nsetup\18nvim-biscuits\frequire\0", "config", "nvim-biscuits")
time([[Config for nvim-biscuits]], false)
-- Config for: nvim-lsp-installer
time([[Config for nvim-lsp-installer]], true)
try_loadstring("\27LJ\2\nÏ\2\0\1\b\2\17\0\0316\1\0\0009\1\1\1'\3\2\0-\4\0\0009\4\3\0046\6\0\0009\6\4\0069\6\5\0069\6\6\6B\6\1\0A\4\0\2-\5\1\0009\5\a\5B\1\4\0029\2\b\0019\2\t\0029\2\n\2+\3\2\0=\3\v\0029\2\b\0019\2\t\0029\2\n\0025\3\14\0005\4\r\0=\4\15\3=\3\f\2-\2\1\0009\2\16\2\18\4\0\0B\2\2\1K\0\1\0\1¿\2¿\14on_attach\15properties\1\0\0\1\4\0\0\18documentation\vdetail\24additionalTextEdits\19resolveSupport\19snippetSupport\19completionItem\15completion\17textDocument\17capabilities\29make_client_capabilities\rprotocol\blsp\24update_capabilities\tkeep\15tbl_extend\bvim˚\2\0\1\4\3\6\0\17-\1\0\0\18\3\0\0B\1\2\0019\1\0\0-\2\1\0=\2\1\0019\1\0\0-\2\1\0=\2\2\1-\1\2\0\15\0\1\0X\2\4Ä6\1\3\0009\1\4\1'\3\5\0B\1\2\1K\0\1\0\0\0\0¿\1¿·\1          augroup LspFormatting\n              autocmd! * <buffer>\n              autocmd BufWritePre * sleep 200m\n              autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()\n          augroup END\n        \bcmd\bvim\30document_range_formatting\24document_formatting\26resolved_capabilities\22\1\2\3\1\1\0\0033\2\0\0002\0\0ÄL\2\2\0\4¿\0$\0\0\2\0\3\0\0046\0\0\0009\0\1\0009\0\2\0D\0\1\0\bcwd\tloop\bvimj\0\0\5\3\3\0\18-\0\0\0-\1\1\0009\1\0\0018\0\1\0\14\0\0\0X\1\1Ä4\0\0\0009\1\1\0\14\0\1\0X\2\1Ä-\1\2\0=\1\1\0-\1\1\0\18\3\1\0009\1\2\1\18\4\0\0B\1\3\1K\0\1\0\a¿\14¿\4¿\nsetup\14on_attach\tname√\15\1\0\19\0_\0®\0016\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0026\2\0\0'\4\3\0B\2\2\0025\3\4\0009\4\5\0025\6\t\0006\a\6\0009\a\a\a9\a\b\a=\a\n\0065\a\v\0=\a\f\6B\4\2\0019\4\r\2B\4\1\0013\4\14\0003\5\15\0006\6\6\0009\6\16\0066\b\17\0009\b\18\b'\t\19\0B\6\3\0026\a\20\0009\a\21\a\18\t\6\0'\n\22\0B\a\3\0016\a\20\0009\a\21\a\18\t\6\0'\n\23\0B\a\3\0015\a\26\0005\b\24\0\18\t\5\0+\v\1\0B\t\2\2=\t\25\b=\b\27\a5\b\28\0\18\t\5\0+\v\2\0+\f\2\0B\t\3\2=\t\25\b5\t\29\0005\n\30\0=\n\31\t5\n \0005\v!\0=\v\"\n=\n#\t5\n$\0=\n%\t=\t&\b=\b'\a5\b)\0003\t(\0=\t*\b5\t+\0=\t,\b=\b-\a5\b3\0005\t2\0005\n1\0006\v\0\0'\r.\0B\v\2\0029\v/\v9\v0\vB\v\1\2=\v0\n=\n/\t=\t&\b=\b4\a5\b6\0005\t5\0=\t&\b=\b7\a5\b8\0\18\t\5\0+\v\2\0+\f\2\0B\t\3\2=\t\25\b5\t9\0=\t,\b5\t;\0005\n:\0=\n<\t=\t&\b=\b=\a5\b>\0\18\t\5\0+\v\2\0+\f\2\0B\t\3\2=\t\25\b5\tR\0005\n@\0005\v?\0=\6\18\v=\vA\n5\vC\0005\fB\0=\fD\v=\vE\n5\vI\0006\f\6\0009\fF\f9\fG\f'\14H\0+\15\2\0B\f\3\2=\fJ\v=\vK\n5\vL\0=\vM\n5\vN\0=\vO\n5\vP\0=\vQ\n=\nS\t=\t&\b=\bT\a5\bU\0\18\t\5\0+\v\1\0B\t\2\2=\t\25\b5\tW\0005\nV\0=\n\31\t=\t&\b=\bX\a6\bY\0\18\n\3\0B\b\2\4H\v\18Ä9\rZ\0\18\15\f\0B\r\2\3\15\0\r\0X\15\fÄ\18\17\14\0009\15[\0143\18\\\0B\15\3\1\18\17\14\0009\15]\14B\15\2\2\14\0\15\0X\15\3Ä\18\17\14\0009\15^\14B\15\2\0012\r\0ÄF\v\3\3R\vÏ2\0\0ÄK\0\1\0\finstall\17is_installed\0\ron_ready\15get_server\npairs\rtsserver\1\0\0\1\0\1\venable\1\1\0\0\16sumneko_lua\bLua\1\0\0\14telemetry\1\0\1\venable\1\thint\1\0\1\venable\2\15completion\1\0\1\16autoRequire\1\14workspace\flibrary\1\0\1\20checkThirdParty\1\5\26nvim_get_runtime_file\bapi\16diagnostics\fglobals\1\0\0\1\3\0\0\tutf8\bvim\fruntime\1\0\0\1\0\1\fversion\vLuaJIT\1\0\0\18stylelint_lsp\18stylelintplus\1\0\0\1\0\1\fcssInJs\1\1\a\0\0\bcss\tless\tscss\fsugarss\bvue\twxss\1\0\0\14remark_ls\1\0\0\1\0\1\21defaultProcessor\vremark\vjsonls\1\0\0\1\0\0\1\0\0\fschemas\tjson\16schemastore\remmet_ls\14filetypes\1\r\0\0\thtml\bcss\tscss\bnjk\rnunjucks\njinja\ats\15typescript\amd\rmarkdown\ajs\15javascript\rroot_dir\1\0\0\0\veslint\rsettings\rlintTask\1\0\1\venable\2\22codeActionsOnSave\nrules\1\3\0\0\14!debugger\21!no-only-tests/*\1\0\1\tmode\ball\vformat\1\0\1\venable\2\1\0\3\19packageManager\bnpm\18autoFixOnSave\2\venable\2\1\0\0\vdenols\1\0\0\14on_attach\1\0\0\19lua/?/init.lua\14lua/?.lua\vinsert\ntable\6;\tpath\fpackage\nsplit\0\0\22register_progress\19spinner_frames\1\t\0\0\b‚£æ\b‚£Ω\b‚£ª\b‚¢ø\b‚°ø\b‚£ü\b‚£Ø\b‚£∑\16kind_labels\1\0\a\18status_symbol\a: \21indicator_errors\tüî•\23indicator_warnings\n üöß\21current_function\1\19indicator_info\f‚ÑπÔ∏è \17indicator_ok\tÔÄå \19indicator_hint\nüôã #completion_customize_lsp_label\6g\bvim\vconfig\1\20\0\0\14angularls\vbashls\vclangd\ncssls\rdockerls\remmet_ls\veslint\fgraphql\bhls\thtml\vjsonls\fpyright\18rust_analyzer\rspectral\18stylelint_lsp\16sumneko_lua\rtsserver\nvimls\vyamlls\15lsp-status\17cmp_nvim_lsp\31nvim-lsp-installer.servers\frequire\0", "config", "nvim-lsp-installer")
time([[Config for nvim-lsp-installer]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType fish ++once lua require("packer.load")({'cmp-fish'}, { ft = "fish" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
