return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      keymap = { preset = "default" },
      -- Portable matcher: no native binary download or local compilation.
      fuzzy = { implementation = "lua" },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
      "saghen/blink.cmp",
    },
    opts = {
      -- Tools are installed explicitly on each machine, not on every startup.
      ensure_installed = {},
      automatic_enable = { "pyright", "ts_ls", "clangd", "rust_analyzer" },
    },
    config = function(_, opts)
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })
      require("mason-lspconfig").setup(opts)
    end,
  },
  {
    "stevearc/aerial.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "AerialToggle", "AerialOpen", "AerialClose", "AerialNavToggle" },
    keys = {
      { "<Space>co", "<cmd>AerialToggle<cr>", desc = "Toggle code outline" },
    },
    opts = {
      backends = { "lsp" },
    },
  },
}
