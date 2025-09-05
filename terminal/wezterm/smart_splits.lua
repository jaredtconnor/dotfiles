-- Smart splits module for WezTerm
-- Provides vim-like pane navigation and resizing with nvim integration

local wezterm = require('wezterm')
local act = wezterm.action
local module = {}

-- ============================================================================
-- CONFIGURATION
-- ============================================================================

local direction_keys = {
  h = 'Left',
  j = 'Down', 
  k = 'Up',
  l = 'Right',
}

local resize_keys = {
  h = '>',
  j = '-',
  k = '+',
  l = '<',
}

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

local function is_vim(pane)
  -- Check if the current pane is running nvim with smart-splits integration
  -- This assumes smart-splits has been installed on the nvim side
  local user_vars = pane:get_user_vars()
  return user_vars.IS_NVIM == 'true'
end

-- ============================================================================
-- PANE OPERATIONS
-- ============================================================================

local function resize(key)
  return wezterm.action_callback(function(window, pane)
    if is_vim(pane) then
      -- Send vim smart-splits resize commands
      window:perform_action(
        wezterm.action.Multiple {
          act.SendKey { key = 'w', mods = 'CTRL' },
          act.SendKey { key = resize_keys[key] },
        },
        pane
      )
    else
      -- Use WezTerm's native pane resizing
      window:perform_action({
        AdjustPaneSize = { direction_keys[key], 3 }
      }, pane)
    end
  end)
end

local function move(key)
  return wezterm.action_callback(function(window, pane)
    if is_vim(pane) then
      -- Send vim smart-splits navigation commands
      window:perform_action(
        wezterm.action.Multiple {
          act.SendKey { key = 'w', mods = 'CTRL' },
          act.SendKey { key = key },
        },
        pane
      )
    else
      -- Use WezTerm's native pane navigation
      window:perform_action({
        ActivatePaneDirection = direction_keys[key]
      }, pane)
    end
  end)
end

-- ============================================================================
-- CONFIGURATION APPLICATION
-- ============================================================================

function module.apply_to_config(config)
  -- Navigation keys
  local keys = {
    -- Vim-style pane navigation
    {
      key = 'j',
      mods = 'LEADER',
      action = move('j'),
    },
    {
      key = 'k',
      mods = 'LEADER',
      action = move('k'),
    },
    {
      key = 'h',
      mods = 'LEADER',
      action = move('h'),
    },
    {
      key = 'l',
      mods = 'LEADER',
      action = move('l'),
    },
    
    -- Resize mode activation
    {
      key = 'r',
      mods = 'LEADER',
      action = act.ActivateKeyTable {
        name = 'resize_panes',
        timeout_milliseconds = 800,
        one_shot = false,
      },
    },
    
    -- Pane splitting (matching tmux | and -)
    {
      key = '|',
      mods = 'LEADER',
      action = act.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
      key = '-',
      mods = 'LEADER',
      action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    
    -- Close current pane
    {
      key = 'x',
      mods = 'LEADER',
      action = act.CloseCurrentPane { confirm = true },
    },
  }

  -- Add keys to config
  if not config.keys then
    config.keys = {}
  end
  for _, k in ipairs(keys) do
    table.insert(config.keys, k)
  end

  -- Add resize key table
  if not config.key_tables then
    config.key_tables = {}
  end
  config.key_tables.resize_panes = {
    {
      key = 'j',
      action = resize('j'),
    },
    {
      key = 'k',
      action = resize('k'),
    },
    {
      key = 'h',
      action = resize('h'),
    },
    {
      key = 'l',
      action = resize('l'),
    },
    -- Exit resize mode
    {
      key = 'Escape',
      action = act.PopKeyTable,
    },
  }
end

return module
