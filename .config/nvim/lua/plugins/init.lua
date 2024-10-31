return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "python",
        "cpp",
        "c",
        "java",
        "nix",
        "nginx",
      },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        -- border = "rounded",
        height = 0.75,
      },
    },
  },

  -- jdtls
  {
    "mfussenegger/nvim-jdtls",
    enabled = false,
    ft = "java",
    dependencies = { "folke/which-key.nvim" },
    config = function()
      require("configs.jdtls").setup_jdtls()
    end,
  },
}
