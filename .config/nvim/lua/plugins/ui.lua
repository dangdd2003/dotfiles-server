return {
  -- selection ui improvment
  {
    "stevearc/dressing.nvim",
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.input(...)
      end
    end,
    opts = {
      select = {
        telescope = {
          initial_mode = "normal",
          layout_config = {
            width = 0.40,
            height = 0.80,
          },
        },
      },
    },
  },
}
