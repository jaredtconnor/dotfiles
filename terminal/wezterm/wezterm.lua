local wezterm = require("wezterm")

local config = {
  font = wezterm.font("JetBrainsMono Nerd Font"),
  font_size = 12.0,
  leader = { key = "a", mods = "CTRL" },
  hide_tab_bar_if_only_one_tab = true,
  keys = {},
}

config.color_scheme = "tokyonight-storm"

return config
