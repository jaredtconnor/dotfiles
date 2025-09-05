-- Appearance detection module for WezTerm
-- Handles system appearance detection across different platforms

local wezterm = require('wezterm')
local module = {}

-- ============================================================================
-- APPEARANCE DETECTION
-- ============================================================================

function module.is_dark()
  -- Check for specific desktop environments that default to dark theme
  local session_desktop = os.getenv("XDG_SESSION_DESKTOP")
  if session_desktop == "Hyprland" then
    return true
  end

  -- Use WezTerm's GUI appearance detection when available
  if wezterm.gui then
    local appearance = wezterm.gui.get_appearance()
    -- Some systems report appearance like "Dark High Contrast"
    -- so we look for the string "Dark" anywhere in the appearance string
    return appearance:find("Dark") ~= nil
  end

  -- Fallback: assume dark theme if GUI detection is not available
  -- This is common in headless environments or certain configurations
  return true
end

-- ============================================================================
-- THEME UTILITIES
-- ============================================================================

function module.get_color_scheme()
  return module.is_dark() and 'Tokyo Night' or 'Tokyo Night Day'
end

function module.get_cursor_color()
  return module.is_dark() and '#bb9af7' or '#7aa2f7'
end

-- ============================================================================
-- ACRYLIC STYLING UTILITIES
-- ============================================================================

function module.get_acrylic_opacity()
  -- Return opacity optimized for acrylic effect
  return 0.85
end

function module.get_acrylic_blur()
  -- Return blur amount for acrylic effect
  return 80
end

function module.get_acrylic_colors()
  -- Return colors optimized for acrylic backgrounds
  if module.is_dark() then
    return {
      background = '#1a1b26',  -- Slightly transparent dark background
      foreground = '#c0caf5',  -- High contrast foreground
      cursor = '#bb9af7',      -- Purple cursor for dark theme
    }
  else
    return {
      background = '#d5d6db',  -- Light background with transparency
      foreground = '#1f2937',  -- Dark foreground for contrast
      cursor = '#7aa2f7',      -- Blue cursor for light theme
    }
  end
end

return module
