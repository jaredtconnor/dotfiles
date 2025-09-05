-- WezTerm Configuration
-- Main configuration file that orchestrates all modules

local wezterm = require('wezterm')
local appearance = require('appearance')
local projects = require('projects')
local smart_splits = require('smart_splits')
local act = wezterm.action
local config = wezterm.config_builder()

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

local is_linux = function()
  return wezterm.target_triple:find("linux") ~= nil
end

local is_macos = function()
  return wezterm.target_triple:find("darwin") ~= nil
end

-- ============================================================================
-- APPEARANCE CONFIGURATION
-- ============================================================================

-- Color scheme based on system appearance
if appearance.is_dark() then
  config.color_scheme = 'Tokyo Night'
else
  config.color_scheme = 'Tokyo Night Day'
end

-- Font configuration (matching Ghostty)
config.font = wezterm.font('JetBrains Mono', { weight = 'Regular' })
config.font_size = 12
config.line_height = 1.1

-- Initial window size (larger default)
config.initial_cols = 150
config.initial_rows = 50

-- Window configuration (enhanced acrylic styling)
config.window_background_opacity = appearance.get_acrylic_opacity()
config.window_decorations = is_linux() and "NONE" or "RESIZE"

-- macOS specific settings (enhanced acrylic effect)
if is_macos() then
  config.macos_window_background_blur = appearance.get_acrylic_blur()
  config.macos_forward_to_ime_modifier_mask = "SHIFT|CTRL"
end

-- Window frame configuration
config.window_frame = {
  font = wezterm.font({ family = 'Berkeley Mono', weight = 'Bold' }),
  font_size = is_linux() and 9 or 11,
}

-- Additional settings to match Ghostty behavior
config.cursor_blink_rate = 800
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.default_cursor_style = "BlinkingBlock"

-- Enhanced acrylic styling
config.hide_mouse_cursor_when_typing = true
config.scroll_to_bottom_on_input = true

-- Window behavior (optimized for acrylic with proper padding)
config.window_padding = {
  left = 15,
  right = 15,
  top = 0,
  bottom = 0,
}

-- Tab bar styling for acrylic effect
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.show_tabs_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = true
config.show_close_tab_button_in_tabs = true
config.tab_max_width = 32

-- Enhanced tab bar styling with acrylic theme
-- Note: Using format-tab-title event for custom tab styling instead of tab_bar_style

-- ============================================================================
-- TAB TITLE FORMATTING
-- ============================================================================

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local edge_background = '#1a1b26'
  local background = '#1a1b26'
  local foreground = '#565f89'
  
  if tab.is_active then
    background = '#1a1b26'
    foreground = '#c0caf5'
  elseif hover then
    background = '#1a1b26'
    foreground = '#7aa2f7'
  end

  local edge_foreground = background
  local title = tab.active_pane.title
  
  -- Truncate title if too long
  if #title > max_width - 2 then
    title = title:sub(1, max_width - 5) .. '...'
  end

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = ' ' },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = ' ' },
  }
end)

-- ============================================================================
-- STATUS BAR CONFIGURATION
-- ============================================================================

wezterm.on('update-status', function(window, _)
  local segments = projects.list_for_display()

  local color_scheme = window:effective_config()
  local active_color = wezterm.color.parse(color_scheme.window_frame.button_fg)
  local inactive_color = active_color:darken(0.3)

  -- Build status bar elements
  local elements = {}

  for _, seg in ipairs(segments) do
    if seg.active then
      table.insert(elements, { Foreground = { Color = active_color } })
    else
      table.insert(elements, { Foreground = { Color = inactive_color } })
    end
    table.insert(elements, { Background = { Color = 'none' } })
    table.insert(elements, { Text = seg.label })
  end

  table.insert(elements, { Text = ' ' }) -- padding

  window:set_right_status(wezterm.format(elements))
end)

-- ============================================================================
-- ENVIRONMENT VARIABLES
-- ============================================================================

config.set_environment_variables = {
  PATH = '/opt/homebrew/bin:' .. os.getenv('PATH')
}

-- ============================================================================
-- KEY BINDINGS CONFIGURATION
-- ============================================================================

-- Leader key configuration (matching tmux prefix)
config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 1000 }

-- Main key bindings
config.keys = {
  -- Word navigation (Option + Arrow keys)
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = act.SendString '\x1bb',
  },
  {
    key = 'RightArrow',
    mods = 'OPT',
    action = act.SendString '\x1bf',
  },
  
  -- Configuration editing
  {
    key = ',',
    mods = 'SUPER',
    action = act.SpawnCommandInNewTab {
      cwd = wezterm.home_dir,
      args = { 'nvim', wezterm.config_file },
    },
  },
  
  -- Leader key passthrough
  {
    key = ' ',
    mods = 'LEADER|CTRL',
    action = act.SendKey { key = ' ', mods = 'CTRL' },
  },
  
  -- Launcher
  {
    key = 'p',
    mods = 'LEADER',
    action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' },
  },
  
  -- Project selection
  {
    key = 'f',
    mods = 'LEADER',
    action = projects.choose_project(),
  },
  
  -- Pane zoom toggle
  {
    key = 'z',
    mods = 'LEADER',
    action = act.TogglePaneZoomState,
  },
  
  -- New tab (matching tmux 'c' for new window)
  {
    key = 'c',
    mods = 'LEADER',
    action = act.SpawnTab 'CurrentPaneDomain',
  },
  
  -- Close tab (matching tmux 'X' for kill window)
  {
    key = 'X',
    mods = 'LEADER',
    action = act.CloseCurrentTab { confirm = true },
  },
  
  -- Copy mode (matching tmux copy mode)
  {
    key = '[',
    mods = 'LEADER',
    action = act.ActivateCopyMode,
  },
  
  -- Previous/Next tab (matching tmux C-h/C-l pattern)
  {
    key = 'o',
    mods = 'LEADER|CTRL',
    action = act.ActivateTabRelative(-1),
  },
  {
    key = 'p',
    mods = 'LEADER|CTRL',
    action = act.ActivateTabRelative(1),
  },
  
  -- Switch to last tab (matching tmux Space for last-window)
  {
    key = 'Space',
    mods = 'LEADER',
    action = act.ActivateLastTab,
  },
  
  -- Reload configuration (matching tmux 'r' for reload)
  {
    key = 'r',
    mods = 'LEADER',
    action = act.ReloadConfiguration,
  },
  
  -- Open lazygit (matching tmux 'g' for lazygit)
  {
    key = 'g',
    mods = 'LEADER',
    action = act.SpawnCommandInNewTab {
      cwd = wezterm.home_dir,
      args = { 'lazygit' },
    },
  },
}

-- Workspace switching (1-9)
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = wezterm.action_callback(function(window, pane)
      projects.switch_by_id(i, window, pane)
    end),
  })
end

-- ============================================================================
-- MODULE INTEGRATION
-- ============================================================================

-- Apply smart splits configuration
smart_splits.apply_to_config(config)

-- ============================================================================
-- LOCAL CONFIGURATION OVERRIDE
-- ============================================================================

-- Load local configuration for machine-specific settings
-- This file should not be committed to the repository
local has_local_config, local_config = pcall(require, "local_config")
if has_local_config then
  local_config.apply_to_config(config)
end

return config
