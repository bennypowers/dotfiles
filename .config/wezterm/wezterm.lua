local wezterm = require 'wezterm'

local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)
-- local color_scheme = "Catppuccin Mocha"
local color_scheme = 'GitHub Dark'

local color_schemes = {
  ['GitHub Dark'] = {
    foreground = "#b3b1ad",
    background = "#0d1117",
    cursor_bg = "#73b7f2",
    cursor_border = "#73b7f2",
    cursor_fg = "#0d1117",
    selection_bg = "#163356",
    selection_fg = "#b3b1ad",

    -- compose_cursor = "#f2cdcd",
    -- scrollbar_thumb = "#585b70",
    -- split = "#6c7086",
    -- visual_bell = "#313244",

    ansi = {
      "#484f58",
      "#ff7b72",
      "#3fb950",
      "#d29922",
      "#58a6ff",
      "#bc8cff",
      "#39c5cf",
      "#b1bac4"
    },
    brights = {
      "#6e7681",
      "#ffa198",
      "#56d364",
      "#e3b341",
      "#79c0ff",
      "#d2a8ff",
      "#56d4dd",
      "#f0f6fc"
    },
    indexed = {
      ['16'] = "#d18616",
      ['17'] = "#ffa198",
    },

    tab_bar = {
      background = "#11111b",
      inactive_tab_edge = "#575757",
      inactive_tab_edge_hover = "#363636",
      active_tab = {
        bg_color = "#58a6ff",
        fg_color = "#090c10",
      },
      inactive_tab = {
        bg_color = "#4d5566",
        fg_color = "#090c10",
      },
      inactive_tab_hover = {
        bg_color = "#181825",
        fg_color = "#cdd6f4",
      },
      new_tab = {
        bg_color = "#1e1e2e",
        fg_color = "#cdd6f4",
      },
      new_tab_hover = {
        bg_color = "#181825",
        fg_color = "#cdd6f4",
      },
    },
  }
}

-- local scheme = wezterm.color.get_builtin_schemes()[color_scheme]

local scheme = color_schemes['GitHub Dark']

local function f(name, params)
  return wezterm.font_with_fallback({
    name,
    "Noto Color Emoji",
    "Fira Code",
    "Hack",
  }, params)
end

scheme.tab_bar.active_tab.bg_color = scheme.brights[3]
scheme.tab_bar.active_tab.fg_color = scheme.background

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
  local pink = wezterm.color.parse(scheme.brights[6])
  local colors = {
    pink:darken(0.1),
    pink:darken(0.2),
    pink:darken(0.3),
    pink:darken(0.4),
    pink:darken(0.5),
  };

  -- Foreground color for the text across the fade
  local text_fg = scheme.background

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

wezterm.on('format-tab-title', function(tab, tabs, _, _, hover, _)
  local background = scheme.tab_bar.inactive_tab.bg_color
  local foreground = scheme.tab_bar.inactive_tab.fg_color

  local is_first = tab.tab_id == tabs[1].tab_id
  local is_last = tab.tab_id == tabs[#tabs].tab_id

  if tab.is_active then
    background = scheme.tab_bar.active_tab.bg_color
    foreground = scheme.tab_bar.active_tab.fg_color
  elseif hover then
    background = scheme.tab_bar.new_tab_hover.bg_color
    foreground = scheme.tab_bar.new_tab_hover.fg_color
  end

  local leading_fg = scheme.tab_bar.inactive_tab.fg_color
  local leading_bg = background

  local trailing_fg = background
  local trailing_bg = scheme.tab_bar.inactive_tab.bg_color

  if is_first then
    leading_fg = background
    leading_bg = background
  else
    leading_fg = scheme.tab_bar.inactive_tab.bg_color
  end

  if is_last then
    trailing_bg = scheme.tab_bar.background
  else
    trailing_bg = scheme.tab_bar.inactive_tab.bg_color
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

  color_scheme = color_scheme,
  window_background_opacity = 0.75,

  tab_bar_style = {
    new_tab = wezterm.format {
      { Background = { Color = scheme.tab_bar.new_tab.bg_color } },
      { Foreground = { Color = scheme.tab_bar.background } },
      { Text = SOLID_RIGHT_ARROW },
      { Background = { Color = scheme.tab_bar.new_tab.bg_color } },
      { Foreground = { Color = scheme.tab_bar.new_tab.fg_color } },
      { Text = " + " },
      { Background = { Color = scheme.tab_bar.background } },
      { Foreground = { Color = scheme.tab_bar.new_tab.bg_color } }, { Text = SOLID_RIGHT_ARROW },
    },
    new_tab_hover = wezterm.format {
      { Attribute = { Italic = false } },
      { Attribute = { Intensity = "Bold" } },
      { Background = { Color = scheme.tab_bar.inactive_tab.bg_color } },
      { Foreground = { Color = scheme.tab_bar.background } },
      { Text = SOLID_RIGHT_ARROW },
      { Background = { Color = scheme.tab_bar.inactive_tab.bg_color } },
      { Foreground = { Color = scheme.tab_bar.inactive_tab.fg_color } },
      { Text = " + " },
      { Background = { Color = scheme.tab_bar.background } },
      { Foreground = { Color = scheme.tab_bar.inactive_tab.bg_color } },
      { Text = SOLID_RIGHT_ARROW },
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
  font_size = 18,
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

  enable_scroll_bar = true,
  window_padding = {
    top = 0,
    right = '1cell',
    bottom = 0,
    left = 0,
  }
}
