-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

-- Project name component for lualine
local function project_name()
  local key = vim.g.current_project
  if not key then
    return ''
  end
  local ok, pm = pcall(require, 'custom.project-manager')
  if ok and pm.projects[key] then
    return ' ' .. pm.projects[key].name
  end
  return ''
end

-- Conda/venv environment component for lualine
local function env_name()
  local key = vim.g.current_project
  if not key then
    return ''
  end
  local ok, pm = pcall(require, 'custom.project-manager')
  if ok and pm.projects[key] then
    local project = pm.projects[key]
    if project.conda_env then
      return '󱔎 ' .. project.conda_env
    elseif project.venv_path then
      -- Extract just the venv folder name
      local venv = project.venv_path:match('([^/]+)$') or 'venv'
      return ' ' .. venv
    end
  end
  return ''
end

-- Dev server status components for lualine
local function django_status()
  local running = _G.is_terminal_running and _G.dev_terminals and _G.is_terminal_running(_G.dev_terminals.django)
  if running then
    return 'DJ ●'
  else
    return 'DJ ○'
  end
end

local function tailwind_status()
  local running = _G.is_terminal_running and _G.dev_terminals and _G.is_terminal_running(_G.dev_terminals.tailwind)
  if running then
    return 'TW ●'
  else
    return 'TW ○'
  end
end

local function django_color()
  local running = _G.is_terminal_running and _G.dev_terminals and _G.is_terminal_running(_G.dev_terminals.django)
  if running then
    return { fg = '#9ece6a' } -- Tokyo Night green
  else
    return { fg = '#565f89' } -- Tokyo Night grey
  end
end

local function tailwind_color()
  local running = _G.is_terminal_running and _G.dev_terminals and _G.is_terminal_running(_G.dev_terminals.tailwind)
  if running then
    return { fg = '#9ece6a' } -- Tokyo Night green
  else
    return { fg = '#565f89' } -- Tokyo Night grey
  end
end

return {
  { -- Statusline
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        icons_enabled = vim.g.have_nerd_font,
        theme = 'tokyonight',
      },
      sections = {
        lualine_x = {
          { project_name },
          { env_name },
        },
        lualine_y = {
          { django_status, color = django_color },
          { tailwind_status, color = tailwind_color },
        },
        lualine_z = { 'location' },
      },
    },
  },
}
