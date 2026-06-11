-- Startup screen/navigation
return {
  'goolord/alpha-nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  event = 'VimEnter',
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    _Gopts = {
      position = 'center',
      hl = 'Type',
      wrap = 'overflow',
    }

    local logo = [[










                                              
       ███████████           █████      ██
      ███████████             █████ 
      ████████████████ ███████████ ███   ███████
     ████████████████ ████████████ █████ ██████████████
    █████████████████████████████ █████ █████ ████ █████
  ██████████████████████████████████ █████ █████ ████ █████
 ██████  ███ █████████████████ ████ █████ █████ ████ ██████
 ██████   ██  ███████████████   ██ █████████████████

      ]]

    -- Highlight groups configuration for each segment
    local header_hl = {
      { { 'Red', 1, 1 } },
      { { 'Red', 1, 1 } },
      { { 'Red', 1, 1 } },
      { { 'Red', 1, 1 } },
      { { 'Red', 1, 1 } },
      { { 'Red', 1, 1 } },
      { { 'Red', 1, 1 } },
      { { 'Red', 1, 1 } },
      { { 'Red', 1, 1 } },
      { { 'Red', 1, 1 } }, -- Empty lines
      { { 'AlphaHeader0_0', 46, 48 } }, -- Line 10
      { -- Line 11
        { 'AlphaHeader1_0', 7, 22 },
        { 'AlphaHeader1_1', 33, 40 },
        { 'AlphaHeader1_2', 40, 50 },
      },
      { -- Line 12
        { 'AlphaHeader2_0', 6, 21 },
        { 'AlphaHeader2_1', 33, 45 },
      },
      { -- Line 13
        { 'AlphaHeader3_0', 6, 19 },
        { 'AlphaHeader3_1', 19, 20 },
        { 'AlphaHeader3_2', 20, 35 },
        { 'AlphaHeader3_3', 35, 45 },
        { 'AlphaHeader3_4', 45, 90 },
      },
      { -- Line 14
        { 'AlphaHeader4_0', 5, 18 },
        { 'AlphaHeader4_1', 18, 36 },
        { 'AlphaHeader4_2', 36, 45 },
        { 'AlphaHeader4_3', 45, 90 },
      },
      { -- Line 15
        { 'AlphaHeader5_0', 4, 17 },
        { 'AlphaHeader5_1', 17, 24 },
        { 'AlphaHeader5_2', 24, 28 },
        { 'AlphaHeader5_3', 28, 37 },
        { 'AlphaHeader5_4', 37, 46 },
        { 'AlphaHeader5_5', 46, 90 },
      },
      { -- Line 16
        { 'AlphaHeader6_0', 2, 17 },
        { 'AlphaHeader6_1', 17, 38 },
        { 'AlphaHeader6_2', 38, 45 },
        { 'AlphaHeader6_3', 46, 90 },
      },
      { -- Line 17
        { 'AlphaHeader7_0', 1, 17 },
        { 'AlphaHeader7_1', 17, 38 },
        { 'AlphaHeader7_2', 38, 45 },
        { 'AlphaHeader7_3', 46, 90 },
      },
      { -- Line 18
        { 'AlphaHeader8_0', 1, 37 },
        { 'AlphaHeader8_1', 37, 91 },
      },
    }

    vim.api.nvim_set_hl(0, 'AlphaHeader0_0', { fg = '#db7138' }) -- Top of i
    vim.api.nvim_set_hl(0, 'AlphaHeader1_0', { fg = '#517be2' })
    vim.api.nvim_set_hl(0, 'AlphaHeader1_1', { fg = '#db7138' })
    vim.api.nvim_set_hl(0, 'AlphaHeader1_2', { fg = '#e1793f' })
    vim.api.nvim_set_hl(0, 'AlphaHeader2_0', { fg = '#5882e5' })
    vim.api.nvim_set_hl(0, 'AlphaHeader2_1', { fg = '#e1793f' })
    vim.api.nvim_set_hl(0, 'AlphaHeader3_0', { fg = '#5f88e9' })
    vim.api.nvim_set_hl(0, 'AlphaHeader3_1', { fg = '#0f2b66' })
    vim.api.nvim_set_hl(0, 'AlphaHeader3_2', { fg = '#5f88e9' })
    vim.api.nvim_set_hl(0, 'AlphaHeader3_3', { fg = '#e78046' })
    vim.api.nvim_set_hl(0, 'AlphaHeader3_4', { fg = '#e78046' })
    vim.api.nvim_set_hl(0, 'AlphaHeader4_0', { fg = '#668fed' })
    vim.api.nvim_set_hl(0, 'AlphaHeader4_1', { fg = '#668fed' })
    vim.api.nvim_set_hl(0, 'AlphaHeader4_2', { fg = '#ed884e' })
    vim.api.nvim_set_hl(0, 'AlphaHeader4_3', { fg = '#ed884e' })
    vim.api.nvim_set_hl(0, 'AlphaHeader5_0', { fg = '#6c95f0' })
    vim.api.nvim_set_hl(0, 'AlphaHeader5_1', { fg = '#6c95f0' })
    vim.api.nvim_set_hl(0, 'AlphaHeader5_2', { fg = '#0f2b66' })
    vim.api.nvim_set_hl(0, 'AlphaHeader5_3', { fg = '#6c95f0' })
    vim.api.nvim_set_hl(0, 'AlphaHeader5_4', { fg = '#f38f55' })
    vim.api.nvim_set_hl(0, 'AlphaHeader5_5', { fg = '#f38f55' })
    vim.api.nvim_set_hl(0, 'AlphaHeader6_0', { fg = '#739cf4' })
    vim.api.nvim_set_hl(0, 'AlphaHeader6_1', { fg = '#739cf4' })
    vim.api.nvim_set_hl(0, 'AlphaHeader6_2', { fg = '#f9975c' })
    vim.api.nvim_set_hl(0, 'AlphaHeader6_3', { fg = '#f9975c' })
    vim.api.nvim_set_hl(0, 'AlphaHeader7_0', { fg = '#7aa2f7' })
    vim.api.nvim_set_hl(0, 'AlphaHeader7_1', { fg = '#7aa2f7' })
    vim.api.nvim_set_hl(0, 'AlphaHeader7_2', { fg = '#ff9e64' })
    vim.api.nvim_set_hl(0, 'AlphaHeader7_3', { fg = '#ff9e64' })
    vim.api.nvim_set_hl(0, 'AlphaHeader8_0', { fg = '#0f2b66' })
    vim.api.nvim_set_hl(0, 'AlphaHeader8_1', { fg = '#852A00' })

    local utils = require 'alpha.utils'

    local header_val = vim.split(logo, '\n')
    header_hl = utils.charhl_to_bytehl(header_hl, header_val, false)

    dashboard.section.header.opts.hl = header_hl
    dashboard.section.header.val = header_val

    -- Split logo into lines
    local logoLines = {}
    for line in logo:gmatch '[^\r\n]+' do
      table.insert(logoLines, line)
    end

    local init_path = vim.fn.stdpath 'config'
    dashboard.section.buttons.val = {
      dashboard.button('n', '  New file', ':ene <BAR> startinsert<CR>'),
      dashboard.button('f', '󰥨  Find file', ':Telescope find_files<CR>'),
      dashboard.button('r', '󱑆  Recent files', ':Telescope oldfiles<CR>'),
      dashboard.button('g', '󰺮  Find text', ':Telescope live_grep<CR>'),
      dashboard.button('p', '󱏓  Projects', ':lua require("custom.project-manager").pick_project()<CR>'),
      dashboard.button('u', '󰚥  Update plugins', '<cmd>Lazy update<CR>'),
      dashboard.button('c', '  Config', ':cd ' .. init_path .. '<CR>:e init.lua<CR>'),
      dashboard.button('q', '󰩈  Quit', '<cmd>qa<CR>'),
    }

    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = 'AlphaButtons' -- Cyan (built-in)
      button.opts.hl_shortcut = 'AlphaShortcut' -- Orange (built-in)
    end

    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyVimStarted',
      desc = 'Add Alpha dashboard footer',
      once = true,
      callback = function()
        local stats = require('lazy').stats()
        local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
        dashboard.section.footer.val = {
          ' ',
          ' Loaded ' .. stats.count .. ' plugins  in ' .. ms .. ' ms ',
        }
        pcall(vim.cmd.AlphaRedraw)
      end,
    })

    -- Hide all the unnecessary visual elements while on the dashboard, and add
    -- them back when leaving the dashboard.
    local group = vim.api.nvim_create_augroup('CleanDashboard', {})

    vim.api.nvim_create_autocmd('User', {
      group = group,
      pattern = 'AlphaReady',
      callback = function()
        vim.opt.showcmd = false
        vim.opt.ruler = false
      end,
    })

    vim.api.nvim_create_autocmd('BufUnload', {
      group = group,
      pattern = '<buffer>',
      callback = function()
        vim.opt.showcmd = true
        vim.opt.ruler = true
      end,
    })

    dashboard.opts.opts.noautocmd = true
    alpha.setup(dashboard.opts)
  end,
}
