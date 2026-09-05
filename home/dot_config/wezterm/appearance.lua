local wezterm = require("wezterm")
local module = {}

function module.is_dark()
  if os.getenv("XDG_SESSION_DESKTOP") == "Hyprland" then
    return true
  end

  if wezterm.gui then
    return wezterm.gui.get_appearance():find("Dark") ~= nil
  end

  return true
end

-- Custom themes registered into config.color_schemes
function module.get_color_schemes()
  return {
    ["Cyberdream"] = require("themes.cyberdream"),
  }
end

function module.get_color_scheme()
  -- Cyberdream ships dark-only; fall back to a bundled light scheme in light mode.
  return module.is_dark() and "Cyberdream" or "Tokyo Night Day"
end

function module.get_cursor_color()
  return module.is_dark() and "#bb9af7" or "#7aa2f7"
end

function module.get_acrylic_opacity()
  return 0.85
end

function module.get_acrylic_blur()
  return 80
end

function module.get_acrylic_colors()
  if module.is_dark() then
    return {
      background = "#1a1b26",
      foreground = "#c0caf5",
      cursor = "#bb9af7",
    }
  else
    return {
      background = "#d5d6db",
      foreground = "#1f2937",
      cursor = "#7aa2f7",
    }
  end
end

return module
