local wezterm = require('wezterm')
local appearance = require('appearance')
local projects = require('projects')
local smart_splits = require('smart_splits')
local act = wezterm.action
local config = wezterm.config_builder()

local is_linux = function()
  return wezterm.target_triple:find("linux") ~= nil
end

local is_macos = function()
  return wezterm.target_triple:find("darwin") ~= nil
end

local is_windows = function()
  return wezterm.target_triple:find("windows") ~= nil
end

-- Color scheme
if appearance.is_dark() then
  config.color_scheme = 'Tokyo Night'
else
  config.color_scheme = 'Tokyo Night Day'
end

-- Font
config.font = wezterm.font('Berkeley Mono')
config.font_size = is_linux() and 12 or 15

-- Window appearance
config.window_background_opacity = 0.97
if is_macos() then
  config.macos_window_background_blur = 30
elseif is_windows() then
  config.win32_system_backdrop = 'Acrylic'
end

if not is_linux() then
  config.window_decorations = "RESIZE"
end

config.window_frame = {
  font = wezterm.font({ family = 'Berkeley Mono', weight = 'Bold' }),
  font_size = is_linux() and 9 or 11,
}

-- Status bar: show workspace list in right status
wezterm.on('update-status', function(window, _)
  local segments = projects.list_for_display()

  local color_scheme = window:effective_config()
  local active_color = wezterm.color.parse(color_scheme.window_frame.button_fg)
  local inactive_color = active_color:darken(0.3)

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

  table.insert(elements, { Text = ' ' })

  window:set_right_status(wezterm.format(elements))
end)

-- Platform-specific environment & default shell
if is_macos() then
  config.set_environment_variables = {
    PATH = '/opt/homebrew/bin:' .. os.getenv('PATH')
  }
elseif is_windows() then
  local pwsh = 'powershell.exe'
  local ok, stdout = wezterm.run_child_process({
    'powershell.exe', '-NoProfile', '-Command',
    '(Get-Command pwsh -ErrorAction SilentlyContinue).Source'
  })
  if ok and stdout then
    local resolved = stdout:gsub('%s+$', '')
    if resolved ~= '' then pwsh = resolved end
  end
  config.default_prog = { pwsh, '-NoLogo' }
end

-- Leader key
config.leader = { key = 'p', mods = 'CTRL', timeout_milliseconds = 1000 }

-- Key bindings
config.keys = {
  -- Word navigation
  {
    key = 'LeftArrow',
    mods = is_macos() and 'OPT' or 'ALT',
    action = act.SendString '\x1bb',
  },
  {
    key = 'RightArrow',
    mods = is_macos() and 'OPT' or 'ALT',
    action = act.SendString '\x1bf',
  },
  -- Config editing
  {
    key = ',',
    mods = is_macos() and 'SUPER' or 'ALT',
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
}

-- Workspace switching (1-9) and tmux-style window switching
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = wezterm.action_callback(function(window, pane)
      projects.switch_by_id(i, window, pane)
    end),
  })
  if is_macos() then
    table.insert(config.keys, {
      key = tostring(i),
      mods = 'SUPER',
      action = act.SendString('\x1b' .. tostring(i)),
    })
  end
end

-- Smart splits integration
smart_splits.apply_to_config(config)

-- Local configuration override for machine-specific settings
local has_local_config, local_config = pcall(require, "local_config")
if has_local_config then
  local_config.apply_to_config(config)
end

return config
