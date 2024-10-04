local wezterm = require("wezterm")
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

local keymap = function(mods, key, action)
	return {
		mods = mods,
		key = key,
		action = action,
	}
end

local config = {
	font = wezterm.font("JetBrains Mono"),
	font_size = 16,
	color_scheme = "Gruvbox Material (Gogh)",
	colors = {
		background = "#1D2021", -- use same background as nvim theme
		tab_bar = {
			active_tab = {
				bg_color = "#1D2021",
				fg_color = "#e1a345",
			},
		},
	},
	enable_tab_bar = true,
	tab_bar_at_bottom = true,
	use_fancy_tab_bar = false,
	window_decorations = "RESIZE",
	adjust_window_size_when_changing_font_size = false,
	audible_bell = "Disabled",
	window_close_confirmation = "NeverPrompt",
	keys = {
		keymap("CMD", "s", wezterm.action.SplitVertical),
		keymap("CMD", "S", wezterm.action.SplitHorizontal),
		keymap("CMD", "w", wezterm.action.CloseCurrentPane({ confirm = true })),
	},
}

smart_splits.apply_to_config(config, {
	-- the default config is here, if you'd like to use the default keys,
	-- you can omit this configuration table parameter and just use
	-- smart_splits.apply_to_config(config)

	-- directional keys to use in order of: left, down, up, right
	direction_keys = { "h", "j", "k", "l" },
	-- if you want to use separate direction keys for move vs. resize, you
	-- can also do this:
	-- direction_keys = {
	-- 	move = { "h", "j", "k", "l" },
	-- 	resize = { "LeftArrow", "DownArrow", "UpArrow", "RightArrow" },
	-- },
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
	},
})

return config
-- vim: set ts=2 sw=2:
