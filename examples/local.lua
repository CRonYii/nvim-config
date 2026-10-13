-- Copy to lua/config/local.lua; the destination is intentionally untracked.
-- Settings run after shared defaults and before lazy.nvim setup.
vim.opt.mouse = ""

-- Return a lazy.nvim spec list (use {} for settings only).
-- Existing plugin options are merged after the shared specs.
return {
  {
    "nvim-tree/nvim-tree.lua",
    opts = { view = { width = 36 } },
  },
}
