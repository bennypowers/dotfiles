local uv = vim.uv
local parser_dir = vim.fs.joinpath(vim.fn.stdpath 'data', 'site', 'parser')
local queries_dir = vim.fs.joinpath(vim.fn.stdpath 'data', 'site', 'queries')
local src_dir = vim.fs.joinpath(vim.fn.stdpath 'data', 'ts-parsers')

--- Parser specs: lang -> "owner/repo" or { "owner/repo", path = "subdir" }
--- The `path` field points to the grammar subdirectory within the repo,
--- for repos that contain multiple grammars (e.g. tree-sitter-typescript).
---@alias TSParserSpec string | { [1]: string, path?: string }

---@type table<string, TSParserSpec>
local parsers = {
  bash       = 'tree-sitter/tree-sitter-bash',
  c_sharp    = 'tree-sitter/tree-sitter-c-sharp',
  cpp        = 'tree-sitter/tree-sitter-cpp',
  css        = 'tree-sitter/tree-sitter-css',
  go         = 'tree-sitter/tree-sitter-go',
  haskell    = 'tree-sitter/tree-sitter-haskell',
  html       = 'tree-sitter/tree-sitter-html',
  java       = 'tree-sitter/tree-sitter-java',
  javascript = 'tree-sitter/tree-sitter-javascript',
  jsdoc      = 'tree-sitter/tree-sitter-jsdoc',
  json       = 'tree-sitter/tree-sitter-json',
  ocaml      = { 'tree-sitter/tree-sitter-ocaml', path = 'grammars/ocaml' },
  php        = { 'tree-sitter/tree-sitter-php', path = 'php' },
  python     = 'tree-sitter/tree-sitter-python',
  regex      = 'tree-sitter/tree-sitter-regex',
  ruby       = 'tree-sitter/tree-sitter-ruby',
  rust       = 'tree-sitter/tree-sitter-rust',
  scala      = 'tree-sitter/tree-sitter-scala',
  tsx        = { 'tree-sitter/tree-sitter-typescript', path = 'tsx' },
  typescript = { 'tree-sitter/tree-sitter-typescript', path = 'typescript' },

  dockerfile = 'tree-sitter-grammars/tree-sitter-dockerfile',
  elixir     = 'tree-sitter-grammars/tree-sitter-elixir',
  fish       = 'tree-sitter-grammars/tree-sitter-fish',
  gitcommit  = 'tree-sitter-grammars/tree-sitter-gitcommit',
  scss       = 'tree-sitter-grammars/tree-sitter-scss',
  svelte     = 'tree-sitter-grammars/tree-sitter-svelte',
  toml       = 'tree-sitter-grammars/tree-sitter-toml',
  yaml       = 'tree-sitter-grammars/tree-sitter-yaml',
  zig        = 'tree-sitter-grammars/tree-sitter-zig',

  nix        = 'nix-community/tree-sitter-nix',

  handlebars = 'bennypowers/tree-sitter-handlebars',
  jinja      = 'bennypowers/tree-sitter-jinja-dialects',
}

--- Guard against concurrent installs of the same language.
---@type table<string, true>
local installing = {}

---@param spec TSParserSpec
---@return { repo: string, path?: string }
local function resolve(spec)
  if type(spec) == 'string' then return { repo = spec } end
  return { repo = spec[1], path = spec.path }
end

--- Run a command asynchronously; must be called from a coroutine.
---@param cmd string[]
---@param opts? vim.SystemOpts
---@return vim.SystemCompleted
local function run(cmd, opts)
  local co = assert(coroutine.running(), 'run() must be called from a coroutine')
  vim.system(cmd, opts or {}, function(result)
    vim.schedule(function() coroutine.resume(co, result) end)
  end)
  return coroutine.yield()
end

--- Copy query files from a grammar repo into the site queries directory.
---@param lang string
---@param grammar_dir string
---@param repo_dir string
---@param info { repo: string, path?: string }
---@param overwrite boolean
local function install_queries(lang, grammar_dir, repo_dir, info, overwrite)
  local candidates = { vim.fs.joinpath(grammar_dir, 'queries') }
  if info.path then
    table.insert(candidates, vim.fs.joinpath(repo_dir, 'queries', lang))
    table.insert(candidates, vim.fs.joinpath(repo_dir, 'queries'))
  end
  local query_src
  for _, c in ipairs(candidates) do
    if uv.fs_stat(c) then
      query_src = c
      break
    end
  end
  if not query_src then return end

  -- Skip files that already exist in the user's config (queries/ or after/queries/)
  local config = vim.fn.stdpath 'config'
  local user_query_dirs = {
    vim.fs.joinpath(config, 'queries', lang),
    vim.fs.joinpath(config, 'after', 'queries', lang),
  }

  local query_dst = vim.fs.joinpath(queries_dir, lang)
  vim.fn.mkdir(query_dst, 'p')

  local handle = uv.fs_scandir(query_src)
  if not handle then return end
  while true do
    local name = uv.fs_scandir_next(handle)
    if not name then break end
    if name:match '%.scm$' then
      local skip = false
      for _, d in ipairs(user_query_dirs) do
        if uv.fs_stat(vim.fs.joinpath(d, name)) then
          skip = true
          break
        end
      end
      if not skip then
        local dst = vim.fs.joinpath(query_dst, name)
        if overwrite or not uv.fs_stat(dst) then
          uv.fs_copyfile(vim.fs.joinpath(query_src, name), dst)
        end
      end
    end
  end
end

--- Start treesitter highlighting on all loaded buffers matching a language.
---@param lang string
local function start_treesitter(lang)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local ft = vim.bo[buf].filetype
      local buf_lang = vim.treesitter.language.get_lang(ft) or ft
      if buf_lang == lang then
        pcall(vim.treesitter.start, buf, lang)
      end
    end
  end
end

--- Check whether a parser is available anywhere in 'runtimepath'.
---@param lang string
---@return boolean
local function is_installed(lang)
  return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.so', false) > 0
end

--- List user-installed parser languages (from site parser dir only).
---@return string[]
local function installed()
  local list = {}
  vim.fn.mkdir(parser_dir, 'p')
  local handle = uv.fs_scandir(parser_dir)
  if handle then
    while true do
      local name = uv.fs_scandir_next(handle)
      if not name then break end
      if name:match '%.so$' then
        list[#list + 1] = name:gsub('%.so$', '')
      end
    end
  end
  table.sort(list)
  return list
end

--- Install a treesitter parser.
---@param lang string
---@param opts? { update?: boolean }
local function install(lang, opts)
  opts = opts or {}
  local spec = parsers[lang]
  if not spec then
    vim.notify(('ts-install: unknown parser "%s"'):format(lang), vim.log.levels.ERROR)
    return
  end
  if installing[lang] then return end
  if not opts.update and is_installed(lang) then return end

  installing[lang] = true
  local info = resolve(spec)
  local url = 'https://github.com/' .. info.repo
  local repo_dir = vim.fs.joinpath(src_dir, (info.repo:gsub('/', '--')))
  local grammar_dir = info.path and vim.fs.joinpath(repo_dir, info.path) or repo_dir
  local so_path = vim.fs.joinpath(parser_dir, lang .. '.so')

  coroutine.resume(coroutine.create(function()
    vim.notify(('ts-install: %s fetching'):format(lang))
    vim.fn.mkdir(parser_dir, 'p')
    vim.fn.mkdir(src_dir, 'p')

    local result
    if uv.fs_stat(repo_dir) then
      result = run { 'git', '-C', repo_dir, 'pull', '--ff-only' }
    else
      result = run { 'git', 'clone', '--depth', '1', url, repo_dir }
    end
    if result.code ~= 0 then
      installing[lang] = nil
      vim.notify(
        ('ts-install: %s fetch failed\n%s'):format(lang, result.stderr),
        vim.log.levels.ERROR
      )
      return
    end

    vim.notify(('ts-install: %s compiling'):format(lang))
    result = run { 'tree-sitter', 'build', grammar_dir, '-o', so_path }
    if result.code ~= 0 then
      installing[lang] = nil
      vim.notify(
        ('ts-install: %s build failed\n%s'):format(lang, result.stderr),
        vim.log.levels.ERROR
      )
      return
    end

    install_queries(lang, grammar_dir, repo_dir, info, opts.update or false)
    vim.treesitter.language.add(lang, { path = so_path })
    start_treesitter(lang)

    installing[lang] = nil
    vim.notify(('ts-install: %s done'):format(lang))
  end))
end

--- Update installed parsers. With no arguments, updates all user-installed parsers.
---@param langs? string[]
local function update(langs)
  for _, lang in ipairs(langs or installed()) do
    if parsers[lang] then
      install(lang, { update = true })
    end
  end
end

--- Remove a parser .so file.
---@param lang string
local function uninstall(lang)
  local so = vim.fs.joinpath(parser_dir, lang .. '.so')
  if uv.fs_stat(so) then
    os.remove(so)
    vim.notify(('ts-install: %s removed'):format(lang))
  else
    vim.notify(('ts-install: %s not installed'):format(lang), vim.log.levels.WARN)
  end
end

local function trim_to_frontmatter(match, _, bufnr, pred, metadata)
  local id = pred[2]
  local nodes = match[id]
  if not nodes or #nodes == 0 then return end
  local node = nodes[1]
  local text = vim.treesitter.get_node_text(node, bufnr)
  local close = text:find('\n%-%-%-\n', 4) or text:find('\n%-%-%-$', 4)
  if not close then return end
  local sr, sc = node:start()
  local end_row = sr
  for _ in text:sub(1, close):gmatch '\n' do end_row = end_row + 1 end
  metadata[id] = metadata[id] or {}
  metadata[id].range = { sr, sc, end_row, 3 }
end

local function ts_install(info)
  for _, lang in ipairs(info.fargs) do
    install(lang)
  end
end

local function ts_update(info)
  update(#info.fargs > 0 and info.fargs or nil)
end

local function ts_uninstall(info)
  for _, lang in ipairs(info.fargs) do
    uninstall(lang)
  end
end

vim.treesitter.query.add_directive('trim-to-frontmatter!', trim_to_frontmatter, {})

vim.treesitter.language.register('bash', { 'sh' })
vim.treesitter.language.register('c_sharp', { 'cs' })
vim.treesitter.language.register('tsx', { 'typescriptreact' })
vim.treesitter.language.register('jinja', { 'nunjucks' })
vim.treesitter.language.register('handlebars', { 'mustache' })

vim.api.nvim_create_user_command('TSInstall', ts_install, {
  nargs = '+',
  complete = function()
    local ins = {}
    for _, l in ipairs(installed()) do ins[l] = true end
    local avail = vim.tbl_filter(function(l) return not ins[l] end,
                                 vim.tbl_keys(parsers))
    table.sort(avail)
    return avail
  end,
})

vim.api.nvim_create_user_command('TSUpdate', ts_update, {
  nargs = '*',
  complete = function() return installed() end,
})

vim.api.nvim_create_user_command('TSUninstall', ts_uninstall, {
  nargs = '+',
  complete = function() return installed() end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('ts-install', {}),
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
    if is_installed(lang) then
      pcall(vim.treesitter.start, ev.buf, lang)
    elseif parsers[lang] then
      install(lang)
    end
  end,
})
