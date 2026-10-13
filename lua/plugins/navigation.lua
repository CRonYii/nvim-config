return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    keys = {
      { "<F3>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
    },
    opts = {
      view = { width = 30 },
      renderer = { group_empty = true },
    },
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    keys = {
      {
        "<C-p>",
        function() require("fzf-lua").files() end,
        desc = "Find files",
      },
      {
        "<Space>/",
        function() require("fzf-lua").live_grep() end,
        desc = "Search project text",
      },
    },
    opts = {
      file_icons = true,
      git_icons = true,
      color_icons = true,
      winopts = { preview = { layout = "horizontal", horizontal = "right:50%" } },
    },
  },
}
