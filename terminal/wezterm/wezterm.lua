local wezterm = require("wezterm")
return {
  color_scheme = "Dracula",
  font = wezterm.font("JetBrainsMono Nerd Font"),
  font_size = 12.0,
  leader = { key = "a", mods = "CTRL" },
  hide_tab_bar_if_only_one_tab = true,
  keys = {},
}
