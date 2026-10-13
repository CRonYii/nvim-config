return {
  {
    "okuuva/auto-save.nvim",
    event = "VeryLazy",
    cmd = "ASToggle",
    keys = {
      {
        "<Space>ua",
        function()
          local autosave = require("auto-save")
          autosave.toggle()
          vim.notify("Auto-save " .. (autosave.enabled() and "enabled" or "disabled"))
        end,
        desc = "Toggle auto-save",
      },
    },
    opts = {
      enabled = true,
      debounce_delay = 500,
      trigger_events = {
        immediate_save = {},
        defer_save = { "InsertLeave", "TextChanged" },
        cancel_deferred_save = { "InsertEnter" },
      },
      write_all_buffers = false,
      noautocmd = false,
      condition = function(buf)
        local options = vim.bo[buf]
        if options.buftype ~= "" or options.readonly or not options.modifiable then
          return false
        end
        if options.filetype == "gitcommit" or options.filetype == "gitrebase" then
          return false
        end
        local path = vim.api.nvim_buf_get_name(buf)
        return path ~= "" and vim.fn.filewritable(path) == 1
      end,
    },
  },
}
