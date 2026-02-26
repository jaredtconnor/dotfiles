local wezterm = require('wezterm')
local module = {}

local function is_windows()
  return wezterm.target_triple:find("windows") ~= nil
end

local function h(path)
  if not path then
    return wezterm.home_dir
  end
  return wezterm.home_dir .. "/" .. path
end

local function project_dirs()
  local search_patterns = {
    'code/*',
    'Code/*',
    'Code/zendesk/*',
    'Projects/*',
    'dev/*',
    'development/*',
    'work/*',
    'repos/*',
    'repositories/*',
  }

  if is_windows() then
    table.insert(search_patterns, 'Git/*')
  end

  local projects = {
    h(),
    h(is_windows() and '.dotfiles' or 'dotfiles'),
  }

  for _, pattern in ipairs(search_patterns) do
    local full_pattern = h(pattern)
    local success, results = pcall(wezterm.glob, full_pattern)
    if success then
      for _, project_path in ipairs(results) do
        table.insert(projects, project_path)
      end
    end
  end

  if is_windows() then
    for _, drive_pattern in ipairs({ 'C:/Git/*', 'C:/repos/*', 'C:/dev/*' }) do
      local success, results = pcall(wezterm.glob, drive_pattern)
      if success then
        for _, project_path in ipairs(results) do
          table.insert(projects, project_path)
        end
      end
    end
  end

  return projects
end

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
        active = false,
      })
    end
  end

  return projects
end

function module.switch_by_id(id, window, pane)
  local success, workspaces = pcall(wezterm.mux.get_workspace_names)
  if not success then return end

  local workspace = workspaces[id]
  if not workspace then return end

  window:perform_action(
    wezterm.action.SwitchToWorkspace { name = workspace },
    pane
  )
end

function module.choose_project()
  local choices = {}
  for _, value in ipairs(project_dirs()) do
    table.insert(choices, { label = value })
  end

  return wezterm.action.InputSelector {
    title = "Workspaces",
    choices = choices,
    fuzzy = true,
    action = wezterm.action_callback(function(child_window, child_pane, id, label)
      if label then
        child_window:perform_action(wezterm.action.SwitchToWorkspace {
          name = label:match("([^/\\]+)$"),
          spawn = {
            cwd = label,
          },
        }, child_pane)
      end
    end),
  }
end

function module.get_project_dirs()
  return project_dirs()
end

return module
