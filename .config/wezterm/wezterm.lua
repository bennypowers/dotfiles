local wezterm = require'wezterm'

local function font_with_fallback(name, params)
	local names = { name, "Noto Color Emoji", "FiraCode Nerd Font" }
	return wezterm.font_with_fallback(names, params)
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
	-- The filled in variant of the < symbol
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

	-- The filled in variant of the > symbol
	local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

	local edge_background = "#0b0022"
	local background = "#1b1032"
	local foreground = "#808080"

	if tab.is_active then
		background = "#2b2042"
		foreground = "#c0c0c0"
	elseif hover then
		background = "#3b3052"
		foreground = "#909090"
	end

	local edge_foreground = background

	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	local title = wezterm.truncate_to_width(tab.active_pane.title, max_width-2)

	return {
		{Background={Color=edge_background}},
		{Foreground={Color=edge_foreground}},
		{Text=SOLID_LEFT_ARROW},
		{Background={Color=background}},
		{Foreground={Color=foreground}},
		{Text=title},
		{Background={Color=edge_background}},
		{Foreground={Color=edge_foreground }},
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
