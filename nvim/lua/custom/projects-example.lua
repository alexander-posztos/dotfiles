-- Project registry for the project switcher (telescope picker, auto-detect,
-- env activation). Copy this file to projects.lua (gitignored) and list your
-- own projects. Supported fields per project: name, path, and optionally
-- conda_env or venv_path.
return {
  ['my-django-app'] = {
    name = 'My Django App',
    path = '/Users/you/projects/my-django-app',
    conda_env = 'my_django_app_env',
  },
  ['my-site'] = {
    name = 'My Site',
    path = '/Users/you/projects/my-site',
    venv_path = 'venv',
  },
  nvim = {
    name = 'Neovim Config',
    path = '/Users/you/.config/nvim',
  },
}
