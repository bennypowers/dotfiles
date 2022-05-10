local wezterm = require 'wezterm'

local function f(name, params)
  return wezterm.font_with_fallback({
    name,
    -- "Noto Color Emoji",
    "Fira Code",
    "Hack",
  }, params)
end

local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)
local LEFT_ARROW = utf8.char(0xe0b3);

local Black       = "Black"
local White       = "White"
-- local Grey        = "#0f1419"
local Grey        = "#414868"
local LightGrey   = "#191f26"
-- local BrightGreen = "#dcff00"
local BrightGreen = "#9ecd6a"

local TAB_BAR_BG    = Black
local ACTIVE_TAB_BG = BrightGreen
local ACTIVE_TAB_FG = Black
local HOVER_TAB_BG  = Grey
local HOVER_TAB_FG  = White
local NORMAL_TAB_BG = LightGrey
local NORMAL_TAB_FG = White

wezterm.on('update-right-status', function(window, pane)
  -- Each element holds the text for a cell in a "powerline" style << fade
  local cells = {};

  -- Figure out the cwd and host of the current pane.
  -- This will pick up the hostname for the remote host if your
  -- shell is using OSC 7 on the remote host.
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    cwd_uri = cwd_uri:sub(8);
    local slash = cwd_uri:find("/")
    local hostname = ""
    if slash then
      hostname = cwd_uri:sub(1, slash - 1)
      -- Remove the domain name portion of the hostname
      local dot = hostname:find("[.]")
      if dot then
        hostname = hostname:sub(1, dot - 1)
      end

      table.insert(cells, hostname);
    end
  end

  -- An entry for each battery (typically 0 or 1 battery)
  for _, b in ipairs(wezterm.battery_info()) do
    table.insert(cells, string.format("%.0f%%", b.state_of_charge * 100))
  end

  -- I like my date/time in this style: "2022-02-15 07:05"
  local date = wezterm.strftime("%Y-%m-%-d %H:%M");
  table.insert(cells, date);

  -- Color palette for the backgrounds of each cell
  local colors = {
    "#3c1361",
    "#52307c",
    "#663a82",
    "#7c5295",
    "#b491c8",
  };

  -- Foreground color for the text across the fade
  local text_fg = "#c0c0c0";

  -- The elements to be formatted
  local elements = {
    { Foreground = { Color = colors[1] } },
    { Text = SOLID_LEFT_ARROW },
  };

  -- How many cells have been formatted
  local num_cells = 0;

  -- Translate a cell into elements
  local function push(text, is_last)
    local cell_no = num_cells + 1
    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Background = { Color = colors[cell_no] } })
    table.insert(elements, { Text = " " .. text .. " " })
    if not is_last then
      table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
      table.insert(elements, { Text = SOLID_LEFT_ARROW })
    end
    num_cells = num_cells + 1
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell, #cells == 0)
  end

  window:set_right_status(wezterm.format(elements));
end);

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local background = NORMAL_TAB_BG
  local foreground = NORMAL_TAB_FG

  local is_first = tab.tab_id == tabs[1].tab_id
  local is_last = tab.tab_id == tabs[#tabs].tab_id

  if tab.is_active then
    background = ACTIVE_TAB_BG
    foreground = ACTIVE_TAB_FG
  elseif hover then
    background = HOVER_TAB_BG
    foreground = HOVER_TAB_FG
  end

  local leading_fg = NORMAL_TAB_FG
  local leading_bg = background

  local trailing_fg = background
  local trailing_bg = NORMAL_TAB_BG

  if is_first then
    -- leading_fg = TAB_BAR_BG
    leading_fg = background
    leading_bg = background
  else
    leading_fg = NORMAL_TAB_BG
  end

  if is_last then
    trailing_bg = TAB_BAR_BG
  else
    trailing_bg = NORMAL_TAB_BG
  end

  local title = tab.active_pane.title
  -- broken?
  -- local title = " " .. wezterm.truncate_to_width(tab.active_pane.title, 30) .. " "

  return {
    { Attribute = { Italic = false } },
    { Attribute = { Intensity = hover and "Bold" or "Normal" } },
    { Background = { Color = leading_bg } }, { Foreground = { Color = leading_fg } },
    { Text = SOLID_RIGHT_ARROW },
    { Background = { Color = background } }, { Foreground = { Color = foreground } },
    { Text = " " .. title .. " " },
    { Background = { Color = trailing_bg } }, { Foreground = { Color = trailing_fg } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)


return {
  -- יאללה אחי קדימה
  bidi_enabled = true,
  -- bidi_direction = 'AutoLeftToRight',

  window_decorations = "RESIZE",
  native_macos_fullscreen_mode = true,

  hide_tab_bar_if_only_one_tab = true,
  -- tab_bar_at_bottom = true,
  use_fancy_tab_bar = false,
  enable_tab_bar = true,
  tab_max_width = 32,

  enable_kitty_graphics = true,

  leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 },

  inactive_pane_hsb = {
    saturation = 0.5,
    brightness = 0.5,
  },

  color_scheme = "tokyonight_night",
  colors = {
    tab_bar = {
      background = TAB_BAR_BG,
    },
  },

  tab_bar_style = {
    new_tab = wezterm.format {
      { Background = { Color = HOVER_TAB_BG } }, { Foreground = { Color = TAB_BAR_BG } }, { Text = SOLID_RIGHT_ARROW }, { Background = { Color = HOVER_TAB_BG } }, { Foreground = { Color = HOVER_TAB_FG } },
      { Text = " + " },
      { Background = { Color = TAB_BAR_BG } }, { Foreground = { Color = HOVER_TAB_BG } }, { Text = SOLID_RIGHT_ARROW },
    },
    new_tab_hover = wezterm.format {
      { Attribute = { Italic = false } },
      { Attribute = { Intensity = "Bold" } },
      { Background = { Color = NORMAL_TAB_BG } }, { Foreground = { Color = TAB_BAR_BG } }, { Text = SOLID_RIGHT_ARROW }, { Background = { Color = NORMAL_TAB_BG } }, { Foreground = { Color = NORMAL_TAB_FG } },
      { Text = " + " },
      { Background = { Color = TAB_BAR_BG } }, { Foreground = { Color = NORMAL_TAB_BG } }, { Text = SOLID_RIGHT_ARROW },
    },
  },

  keys = {
    { key = "-", mods = "SUPER", action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } } },
    { key = "-", mods = "SUPER|SHIFT", action = 'DecreaseFontSize' },
    { key = "\\", mods = "SUPER", action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } } },
    { key = "h", mods = "SUPER", action = wezterm.action { ActivatePaneDirection = "Left" } },
    { key = "l", mods = "SUPER", action = wezterm.action { ActivatePaneDirection = "Right" } },
    { key = "j", mods = "SUPER", action = wezterm.action { ActivatePaneDirection = "Down" } },
    { key = "k", mods = "SUPER", action = wezterm.action { ActivatePaneDirection = "Up" } },
    { key = "w", mods = "SUPER", action = wezterm.action { CloseCurrentPane = { confirm = true } } },
    { key = "w", mods = "SUPER", action = wezterm.action { CloseCurrentPane = { confirm = true } } },
    { key = "{", mods = "SHIFT|ALT", action = wezterm.action { MoveTabRelative = -1 } },
    { key = "}", mods = "SHIFT|ALT", action = wezterm.action { MoveTabRelative = 1 } },
  },

  font = f("Fira Code"),

  font_rules = {
    { -- BOLD
      intensity = "Bold",
      font = f("Fira Code", { weight = "Bold" }),
    },

    { -- ITALIC
      italic = true,
      font = f("Operator Mono SSm Lig", { italic = true }),
    },

    { -- BOLD ITALIC
      italic = true,
      intensity = "Bold",
      font = f("Operator Mono SSm Lig", { weight = "Bold", italic = true }),
    },

    { -- LIGHT
      intensity = "Half",
      font = f("Operator Mono SSm Lig"),
    },
  },
}
