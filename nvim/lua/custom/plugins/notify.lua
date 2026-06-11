return {
  'rcarriga/nvim-notify',
  config = function()
    local notify = require 'notify'
    notify.setup {
      -- Animation style (fade_in_slide_out, fade, slide, static)
      stages = 'fade_in_slide_out',
      -- Timeout in milliseconds
      timeout = 3000,
      -- Where notifications appear (top_left, top_right, bottom_left, bottom_right)
      top_down = true,
      -- Render style (default, minimal, simple, compact)
      render = 'default',
      -- Icons for different levels
      icons = {
        ERROR = '',
        WARN = '',
        INFO = '',
        DEBUG = '',
        TRACE = '✎',
      },
    }
    -- Set nvim-notify as the default notification handler
    vim.notify = notify
  end,
}
