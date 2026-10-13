return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "dark",
      transparent = false,
    },
    config = function(_, opts)
      vim.opt.background = "dark"
      require("vscode").setup(opts)
      vim.cmd.colorscheme("vscode")
    end,
  },
}
