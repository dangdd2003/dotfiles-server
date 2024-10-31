return {

  -- completion
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      opts.sorting = require "cmp.config.default"().sorting
      opts.experimental = {
        ghost_text = {
          hl_group = "CmpGhostText",
        },
      }
      opts.auto_brackets = opts.auto_brackets or {}
      table.insert(opts.auto_brackets, "python")
    end,
  },

  -- surrounding
  {
    "kylechui/nvim-surround",
    event = "User FilePost",
    version = "*",
    config = function()
      require("nvim-surround").setup {
        keymaps = {
          normal = "gs",
          normal_cur = "gsa",
          normal_line = "gS",
          normal_cur_line = "gSA",
          visual = "gsa",
          visual_line = "gSA",
          delete = "gsd",
          change = "gsc",
          change_line = "gSC",
        },
      }
    end,
  },

  -- harpoon
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    },
  },

  -- incremental rename
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {
      input_buffer_type = "dressing",
    },
  },

  -- session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>qS",
        function()
          require("persistence").select()
        end,
        desc = "Select Session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load { last = true }
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
  },
}
