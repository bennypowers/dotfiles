local wezterm = require 'wezterm'

local function font_with_fallback(name, params)
	local names = { name, "Noto Color Emoji", "FiraCode Nerd Font" }
	return wezterm.font_with_fallback(names, params)
end

local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

local Grey = "#0f1419"
local LightGrey = "#191f26"

local TAB_BAR_BG = "Black"
local ACTIVE_TAB_BG = "Yellow"
local ACTIVE_TAB_FG = "Black"
local HOVER_TAB_BG = Grey
local HOVER_TAB_FG = "White"
local NORMAL_TAB_BG = LightGrey
local NORMAL_TAB_FG = "White"

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
		leading_fg = TAB_BAR_BG
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
		{Attribute={Italic=false}},
		{Attribute={Intensity=hover and "Bold" or "Normal"}},
		{Background={Color=leading_bg}},  {Foreground={Color=leading_fg}},
			{Text=SOLID_RIGHT_ARROW},
		{Background={Color=background}},  {Foreground={Color=foreground}},
			{Text=" "..title.." "},
		{Background={Color=trailing_bg}}, {Foreground={Color=trailing_fg}},
			{Text=SOLID_RIGHT_ARROW},
	}
end)


return {
	window_decorations = "RESIZE",
	native_macos_fullscreen_mode = true,

	hide_tab_bar_if_only_one_tab = true,
	tab_bar_at_bottom = true,
	use_fancy_tab_bar = false,
	enable_tab_bar = true,
	tab_max_width = 32,

	leader = { key="b", mods="CTRL", timeout_milliseconds=1000 },

	colors = {
		tab_bar = {
			background = TAB_BAR_BG,
		},
	},

	tab_bar_style = {
		new_tab = wezterm.format{
			{Background={Color=HOVER_TAB_BG}},			{Foreground={Color=TAB_BAR_BG}},			{Text=SOLID_RIGHT_ARROW}, {Background={Color=HOVER_TAB_BG}}, {Foreground={Color=HOVER_TAB_FG}},
			{Text=" + "},
			{Background={Color=TAB_BAR_BG}},			{Foreground={Color=HOVER_TAB_BG}},	{Text=SOLID_RIGHT_ARROW},
		},
		new_tab_hover = wezterm.format{
			{Attribute={Italic=false}},
			{Attribute={Intensity="Bold"}},
			{Background={Color=NORMAL_TAB_BG}},		{Foreground={Color=TAB_BAR_BG}},			{Text=SOLID_RIGHT_ARROW}, {Background={Color=NORMAL_TAB_BG}}, {Foreground={Color=NORMAL_TAB_FG}},
			{Text=" + "},
			{Background={Color=TAB_BAR_BG}},			{Foreground={Color=NORMAL_TAB_BG}},	{Text=SOLID_RIGHT_ARROW},
		},
	},

	keys = {
		{ key="-",  mods="LEADER", action=wezterm.action{ SplitVertical={ domain="CurrentPaneDomain" } } },
		{ key="\\", mods="LEADER", action=wezterm.action{ SplitHorizontal={ domain="CurrentPaneDomain" } } },
		{ key="h",  mods="LEADER", action=wezterm.action{ ActivatePaneDirection="Left" } },
		{ key="l",  mods="LEADER", action=wezterm.action{ ActivatePaneDirection="Right" } },
		{ key="j",  mods="LEADER", action=wezterm.action{ ActivatePaneDirection="Down" } },
		{ key="k",  mods="LEADER", action=wezterm.action{ ActivatePaneDirection="Up" } },
		{ key="n",  mods="LEADER", action=wezterm.action{ ActivateTabRelative=1 } },
		{ key="p",  mods="LEADER", action=wezterm.action{ ActivateTabRelative=-1 } },
	},

	font = font_with_fallback("FiraCode Nerd Font"),

	font_rules = {
		{ -- BOLD
			intensity = "Bold",
			weight = "Bold",
			font = font_with_fallback("FiraCode Nerd Font", { weight = "Bold" }),
		},

		{ -- ITALIC
			italic = true,
			weight = "Light",
			font = font_with_fallback("Operator Mono SSm Lig", { italic = true }),
		},

		{ -- BOLD ITALIC
			italic = true,
			intensity = "Bold",
			weight = "Book",
			font = font_with_fallback("Operator Mono SSm Lig", { weight = "Bold", italic = true }),
		},

		{ -- LIGHT
			intensity = "Half",
			weight = "Light",
			font = font_with_fallback("Operator Mono SSm Lig"),
		},
	},
}