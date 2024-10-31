return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-telescope/telescope-file-browser.nvim" },
  keys = {
    {
      "<leader>fp",
      function()
        require("telescope.builtin").find_files { cwd = require("lazy.core.config").options.root }
      end,
      desc = "telescope find plugins file",
    },
    {
      "fp",
      function()
        require("telescope.builtin").find_files { cwd = require("lazy.core.config").options.root }
      end,
      desc = "telescope(short) find Plugin File",
    },
    {
      "fb",
      function()
        local fb_actions = require("telescope").extensions.file_browser
        fb_actions.file_browser()
      end,
      desc = "telescope(short) file browser (current buffer)",
    },
    { "<leader><leader>", "<cmd>Telescope find_files<CR>", desc = "telescope find files" },
    { "<leader>fd", "<cmd>Telescope diagnostics bufnr=0<CR>", desc = "telescope document diagnostics" },
    { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "telescope find keymaps" },
    { "<leader>ft", "<cmd>Telescope<CR>", desc = "telescope builtin function" },

    -- short binding find
    {
      "fa",
      "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
      desc = "telescope(short) find all files",
    },
    { "fd", "<cmd>Telescope diagnostics bufnr=0<CR>", desc = "telescope(short) document diagnostics" },
    { "fw", "<cmd>Telescope live_grep<CR>", desc = "telescope(short) live grep" },
    { "fk", "<cmd>Telescope keymaps<CR>", desc = "telescope find keymaps" },
    { "fh", "<cmd>Telescope help_tags<CR>", desc = "telescope(short) help page" },
    { "fo", "<cmd>Telescope oldfiles<CR>", desc = "telescope(short) oldfiles" },
    { "fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "telescope(short) find in current buffer" },
    { "ff", "<cmd>Telescope find_files<CR>", desc = "telescope(short) find files" },
    { "ft", "<cmd>Telescope<CR>", desc = "telescope builtin function" },
  },
  opts = function(_, opts)
    local actions = require "telescope.actions"
    local fb_actions = require("telescope").extensions.file_browser.actions
    local function telescope_buffer_dir()
      return vim.fn.expand "%:p:h"
    end
    opts.pickers = {
      diagnostics = {
        theme = "ivy",
        initial_mode = "normal",
      },
    }

    opts.defaults.wrap_result = true
    opts.winblend = 0
    opts.defaults.mappings.n["<M-p>"] = require("telescope.actions.layout").toggle_preview
    opts.defaults.mappings.i = {
      ["<M-p>"] = require("telescope.actions.layout").toggle_preview,
    }

    opts.extensions = {
      file_browser = {
        path = "%:p:h",
        cwd = telescope_buffer_dir(),
        respect_gitignore = false,
        hidden = true,
        follow_symlinks = true,
        grouped = true,
        previewer = false,
        theme = "dropdown",
        initial_mode = "normal",
        hijack_netrw = true,
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
          },
          height = 0.80,
          preview_cutoff = 120,
        },
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        mappings = {
          ["n"] = {
            ["h"] = fb_actions.goto_parent_dir,
            ["<bs>"] = fb_actions.goto_parent_dir,
            ["<C-u>"] = function(prompt_bufnr)
              for i = 1, 5 do
                actions.move_selection_previous(prompt_bufnr)
              end
            end,
            ["<C-d>"] = function(prompt_bufnr)
              for i = 1, 5 do
                actions.move_selection_next(prompt_bufnr)
              end
            end,
            ["<C-f>"] = actions.preview_scrolling_down,
            ["<C-b>"] = actions.preview_scrolling_up,
          },
        },
      },
    }
    require("telescope").setup(opts)
    require("telescope").load_extension "file_browser"
  end,
}
