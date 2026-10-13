return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      {
        "<Space>?",
        function() require("which-key").show({ global = true }) end,
        desc = "Show keymaps",
      },
    },
    opts = {
      preset = "modern",
      delay = 300,
      -- Space is a built-in Vim key, so register its trigger explicitly.
      triggers = { { "<Space>", mode = "n" } },
      spec = {
        { "<Space>", group = "Shortcuts" },
        { "<Space>g", group = "Git" },
        { "<Space>c", group = "Code" },
        { "<Space>m", group = "Highlights" },
        { "<Space>w", proxy = "<C-w>", group = "Windows" },
        { "<Space>u", group = "Toggles" },
      },
      icons = {
        keys = { Space = "Space", C = "Ctrl-", Esc = "Esc", F3 = "F3" },
      },
    },
  },
}
