local M = {}

-- Real registry lives in projects.lua (machine-local, gitignored);
-- projects-example.lua documents the format.
local ok, projects = pcall(require, 'custom.projects')
if not ok then
  projects = require 'custom.projects-example'
end
M.projects = projects

function M.get_conda_cmd(env_name)
  return string.format('source ~/.zshrc && conda activate %s', env_name)
end

function M.get_venv_cmd(venv_path, project_path)
  -- If venv_path is relative, make it absolute
  local full_path = venv_path
  if not venv_path:match '^/' then
    full_path = project_path .. '/' .. venv_path
  end
  return string.format('source %s/bin/activate', full_path)
end

function M.activate_project(project_key, silent)
  local project = M.projects[project_key]
  if not project then
    return false
  end

  if project.conda_env then
    vim.g.project_conda_cmd = M.get_conda_cmd(project.conda_env)
  elseif project.venv_path then
    vim.g.project_conda_cmd = M.get_venv_cmd(project.venv_path, project.path)
  else
    vim.g.project_conda_cmd = nil
  end

  vim.g.current_project = project_key

  if not silent then
    vim.notify('Activated: ' .. project.name, vim.log.levels.INFO)
  end
  return true
end

function M.switch_project(project_key)
  local project = M.projects[project_key]
  if not project then
    vim.notify('Project not found: ' .. project_key, vim.log.levels.ERROR)
    return
  end

  vim.cmd('cd ' .. project.path)
  M.activate_project(project_key)
end

function M.auto_detect()
  local cwd = vim.fn.getcwd()
  -- Normalize: remove trailing slash
  cwd = cwd:gsub('/$', '')

  for key, project in pairs(M.projects) do
    local project_path = project.path:gsub('/$', '')
    -- Check if cwd matches or is inside the project path
    if cwd == project_path or cwd:find('^' .. vim.pesc(project_path) .. '/') then
      M.activate_project(key, true)
      return key
    end
  end
  return nil
end

function M.pick_project()
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  local project_list = {}
  for key, project in pairs(M.projects) do
    table.insert(project_list, {
      key = key,
      name = project.name,
      path = project.path,
      display = string.format('%s (%s)', project.name, project.path),
    })
  end

  pickers
    .new({}, {
      prompt_title = 'Select Project',
      finder = finders.new_table {
        results = project_list,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.display,
            ordinal = entry.name,
          }
        end,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          M.switch_project(selection.value.key)
        end)
        return true
      end,
    })
    :find()
end

return M
