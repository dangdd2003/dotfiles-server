require "nvchad.mappings"

local map = vim.keymap.set

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Copy all file
map("n", "<C-c>", "<cmd> %y+ <CR>")

-- Add additional undo breack-points
map("i", "?", "?<c-g>u")
map("i", "/", "/<c-g>u")
map("i", ":", ":<c-g>u")

-- Tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Tab last tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Tab close other" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "Tab first" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "Tab create" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Tab next" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Tab close" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Tab previous" })

-- Toggle options
map("n", "<leader>uT", function()
  require("base46").toggle_transparency()
end, { desc = "Toggle Transparency" })

map("n", "<leader>ut", function()
  require("base46").toggle_theme()
end, { desc = "Toggle Theme" })

map("n", "<leader>ud", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostic (Global)" })

-- harpoon
map("n", "<leader>H", function()
  require("harpoon"):list():add()
end, { noremap = true, desc = "Harpoon add file" })
map("n", "<leader>h", function()
  local harpoon = require "harpoon"
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { noremap = true, desc = "Harpoon quick menu" })
