return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "vscode",
        globalstatus = true,
        section_separators = "",
        component_separators = "│",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = { { "filename", path = 1, file_status = true } },
        lualine_x = { "filetype" },
        lualine_y = {},
        lualine_z = { "location" },
      },
    },
  },
}
