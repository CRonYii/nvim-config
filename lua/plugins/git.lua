return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "<Space>gp",
        function() require("gitsigns").preview_hunk() end,
        desc = "Preview hunk",
      },
      {
        "<Space>gb",
        function() require("gitsigns").blame_line({ full = true }) end,
        desc = "Blame current line",
      },
    },
    opts = {
      current_line_blame = false,
    },
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<Space>gd", "<cmd>DiffviewOpen<cr>", desc = "Review project changes" },
      {
        "<Space>gh",
        function()
          if vim.bo.buftype ~= "" or vim.api.nvim_buf_get_name(0) == "" then
            vim.notify("Open a project file to view its Git history", vim.log.levels.INFO)
            return
          end
          vim.cmd("DiffviewFileHistory %")
        end,
        desc = "View file history",
      },
      { "<Space>gq", "<cmd>DiffviewClose<cr>", desc = "Close Git review" },
    },
    opts = {
      keymaps = {
        view = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Git review" } },
        },
        file_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Git review" } },
          -- Start with review only: no staging or file-restoration shortcuts.
          { "n", "-", false },
          { "n", "s", false },
          { "n", "S", false },
          { "n", "U", false },
          { "n", "X", false },
        },
        file_history_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Git review" } },
          { "n", "X", false },
        },
      },
    },
  },
}
