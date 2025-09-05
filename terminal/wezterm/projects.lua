-- Projects module for WezTerm
-- Handles workspace management and project directory discovery

local wezterm = require('wezterm')
local module = {}

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

local function home_path(path)
  if not path then
    return wezterm.home_dir
  end
  return wezterm.home_dir .. "/" .. path
end

-- ============================================================================
-- PROJECT DISCOVERY
-- ============================================================================

local function project_dirs()
  -- Common project directory patterns
  local search_patterns = {
    'code/*',
    'Code/*', 
    'Code/zendesk/*',
    'Projects/*',
    'dev/*',
    'development/*',
    'work/*',
    'repos/*',
    'repositories/*'
  }
  
  local projects = { 
    wezterm.home_dir,  -- Home directory
    home_path('dotfiles')  -- Dotfiles directory
  }
  
  -- Search for project directories
  for _, pattern in ipairs(search_patterns) do
    local full_pattern = home_path(pattern)
    local success, results = pcall(wezterm.glob, full_pattern)
    
    if success then
      for _, project_path in ipairs(results) do
        -- Only add directories that actually exist
        if wezterm.read_dir(project_path) then
          table.insert(projects, project_path)
        end
      end
    end
  end
  
  return projects
end

-- ============================================================================
-- WORKSPACE MANAGEMENT
-- ============================================================================

function module.list_for_display()
  local success, active = pcall(wezterm.mux.get_active_workspace)
  local success2, workspaces = pcall(wezterm.mux.get_workspace_names)
  
  if not success or not success2 then
    return {}
  end

  local projects = {}

  for i, val in ipairs(workspaces) do
    local workspace_str = i .. ": " .. val
    if active == val then
      table.insert(projects, {
        label = "[" .. workspace_str .. "]",
        active = true,
      })
    else
      table.insert(projects, {
        label = " " .. workspace_str .. " ",
        active = false
      })
    end
  end

  return projects
end

function module.switch_by_id(id, window, pane)
  local success, workspaces = pcall(wezterm.mux.get_workspace_names)
  if not success then
    return
  end
  
  local workspace = workspaces[id]
  if not workspace then 
    return 
  end
  
  window:perform_action(
    wezterm.action.SwitchToWorkspace { name = workspace },
    pane
  )
end

-- ============================================================================
-- PROJECT SELECTION
-- ============================================================================

function module.choose_project()
  local choices = {}
  local projects = project_dirs()
  
  for _, project_path in ipairs(projects) do
    -- Create a more user-friendly label
    local label = project_path:match("([^/]+)$") or project_path
    table.insert(choices, { 
      id = project_path,
      label = label
    })
  end

  return wezterm.action.InputSelector {
    title = "Choose Project",
    choices = choices,
    fuzzy = true,
    action = wezterm.action_callback(function(child_window, child_pane, id, label)
      if id and label then
        local workspace_name = label
        child_window:perform_action(wezterm.action.SwitchToWorkspace {
          name = workspace_name,
          spawn = {
            cwd = id,
          }
        }, child_pane)
      end
    end),
  }
end

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

function module.get_project_dirs()
  return project_dirs()
end

function module.add_project_dir(path)
  -- This could be used to dynamically add project directories
  -- Implementation would depend on specific needs
end

return module
