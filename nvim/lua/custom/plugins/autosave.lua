return {
  'okuuva/auto-save.nvim',
  version = '^1.0.0',
  event = { 'InsertLeave', 'TextChanged' },
  opts = {
    debounce_delay = 1000, -- wait 1 sec after changes before saving
    trigger_events = {
      immediate_save = { 'BufLeave', 'FocusLost', 'QuitPre', 'VimSuspend' },
      defer_save = { 'InsertLeave', 'TextChanged' },
      cancel_deferred_save = { 'InsertEnter' },
    },
    condition = function(buf)
      -- Don't autosave special buffers
      local excluded_ft = { 'oil', 'neo-tree', 'gitcommit', 'toggleterm', 'alpha', 'TelescopePrompt' }
      local ft = vim.bo[buf].filetype
      if vim.tbl_contains(excluded_ft, ft) then
        return false
      end
      -- Don't autosave if buffer is not modifiable
      if not vim.bo[buf].modifiable then
        return false
      end
      return true
    end,
  },
}
