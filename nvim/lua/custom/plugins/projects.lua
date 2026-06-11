-- Persistent terminal storage (accessible for lualine)
_G.dev_terminals = {
  django = nil,
  tailwind = nil,
}

-- Check if a terminal is running
_G.is_terminal_running = function(term)
  if term and term.job_id then
    return vim.fn.jobwait({ term.job_id }, 0)[1] == -1
  end
  return false
end

-- Auto-detect project on startup
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    require('custom.project-manager').auto_detect()
  end,
})

return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
      size = 15,
      open_mapping = [[<C-\>]],
      direction = 'horizontal',
    },
    config = function(_, opts)
      require('toggleterm').setup(opts)
      local Terminal = require('toggleterm.terminal').Terminal

      local function get_conda_cmd()
        local conda = vim.g.project_conda_cmd or ''
        return conda ~= '' and (conda .. ' && ') or ''
      end

      _G.toggle_django_server = function()
        if _G.dev_terminals.django and _G.is_terminal_running(_G.dev_terminals.django) then
          _G.dev_terminals.django:toggle()
        else
          local cmd = get_conda_cmd() .. 'python manage.py runserver'
          _G.dev_terminals.django = Terminal:new({ cmd = cmd, count = 3, hidden = true })
          _G.dev_terminals.django:toggle()
        end
      end

      _G.toggle_tailwind = function()
        if _G.dev_terminals.tailwind and _G.is_terminal_running(_G.dev_terminals.tailwind) then
          _G.dev_terminals.tailwind:toggle()
        else
          local cmd = get_conda_cmd() .. 'python manage.py tailwind start'
          _G.dev_terminals.tailwind = Terminal:new({ cmd = cmd, count = 2, hidden = true })
          _G.dev_terminals.tailwind:toggle()
        end
      end

      _G.start_dev_servers = function()
        local cmd_prefix = get_conda_cmd()

        -- Create and spawn Django server in background
        _G.dev_terminals.django = Terminal:new({
          cmd = cmd_prefix .. 'python manage.py runserver',
          count = 3,
          hidden = true,
        })
        _G.dev_terminals.django:spawn()

        -- Create and spawn Tailwind in background
        _G.dev_terminals.tailwind = Terminal:new({
          cmd = cmd_prefix .. 'python manage.py tailwind start',
          count = 2,
          hidden = true,
        })
        _G.dev_terminals.tailwind:spawn()

        vim.notify('Dev servers started in background', vim.log.levels.INFO)
      end

      _G.toggle_dev_terminals = function()
        local django = _G.dev_terminals.django
        local tailwind = _G.dev_terminals.tailwind

        -- Check if any terminal is currently open
        local any_open = (django and django:is_open()) or (tailwind and tailwind:is_open())

        if any_open then
          -- Hide both
          if django and django:is_open() then
            django:close()
          end
          if tailwind and tailwind:is_open() then
            tailwind:close()
          end
        else
          -- Show both, but keep focus on current window
          local current_win = vim.api.nvim_get_current_win()

          if django and _G.is_terminal_running(django) then
            django:open()
          end
          if tailwind and _G.is_terminal_running(tailwind) then
            tailwind:open()
          end

          -- Return focus to original window
          vim.schedule(function()
            if vim.api.nvim_win_is_valid(current_win) then
              vim.api.nvim_set_current_win(current_win)
            end
          end)
        end
      end

      _G.stop_dev_servers = function()
        local stopped = 0
        if _G.dev_terminals.django and _G.is_terminal_running(_G.dev_terminals.django) then
          _G.dev_terminals.django:shutdown()
          stopped = stopped + 1
        end
        if _G.dev_terminals.tailwind and _G.is_terminal_running(_G.dev_terminals.tailwind) then
          _G.dev_terminals.tailwind:shutdown()
          stopped = stopped + 1
        end
        _G.dev_terminals.django = nil
        _G.dev_terminals.tailwind = nil
        vim.notify('Stopped ' .. stopped .. ' dev server(s)', vim.log.levels.INFO)
      end
    end,
    keys = {
      {
        '<leader>pp',
        function()
          require('custom.project-manager').pick_project()
        end,
        desc = 'Pick Project',
      },
      {
        '<leader>dr',
        function()
          _G.toggle_django_server()
        end,
        desc = 'Django Runserver',
      },
      {
        '<leader>dt',
        function()
          _G.toggle_tailwind()
        end,
        desc = 'Django Tailwind',
      },
      {
        '<leader>da',
        function()
          _G.start_dev_servers()
        end,
        desc = 'Django All (start dev)',
      },
      {
        '<leader>ds',
        function()
          _G.toggle_dev_terminals()
        end,
        desc = 'Django Show/hide terminals',
      },
      {
        '<leader>dx',
        function()
          _G.stop_dev_servers()
        end,
        desc = 'Django Stop all',
      },
    },
  },
}
