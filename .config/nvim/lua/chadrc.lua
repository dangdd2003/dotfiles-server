-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "catppuccin",
  theme_toggle = { "catppuccin", "blossom_light" },
  -- transparency = true,

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

M.ui = {
  -- telescope = {style = "bordered"}
  cmp = {
    style = "atom_colored",
  },
}

M.nvdash = {
  load_on_startup = true,
  header = {
    -- "                                        ",
    -- " ██████╗       ██████╗ ███████╗██╗   ██╗",
    -- " ██╔══██╗      ██╔══██╗██╔════╝██║   ██║",
    -- "████╗ ██║█████╗██║  ██║█████╗  ██║   ██║",
    -- "╚██╔╝ ██║╚════╝██║  ██║██╔══╝  ╚██╗ ██╔╝",
    -- " ██████╔╝      ██████╔╝███████╗ ╚████╔╝ ",
    -- " ╚═════╝       ╚═════╝ ╚══════╝  ╚═══╝  ",
    " █████╗ ██████╗  ██████╗ ██╗     ██╗      ██████╗ ",
    "██╔══██╗██╔══██╗██╔═══██╗██║     ██║     ██╔═══██╗",
    "███████║██████╔╝██║   ██║██║     ██║     ██║   ██║",
    "██╔══██║██╔═══╝ ██║   ██║██║     ██║     ██║   ██║",
    "██║  ██║██║     ╚██████╔╝███████╗███████╗╚██████╔╝",
    "╚═╝  ╚═╝╚═╝      ╚═════╝ ╚══════╝╚══════╝ ╚═════╝ ",
    "                                                  ",
    "     Powered By  eovim    ",
    "                            ",
  },

  buttons = {
    { txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
    { txt = "󰥨  File Browser", keys = "fb", cmd = "Telescope file_browser" },
    { txt = "  Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
    { txt = "󰈭  Find Word", keys = "fw", cmd = "Telescope live_grep" },
    { txt = "󱥚  Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
    { txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet" },
    { txt = "  Restore Session", keys = "s", cmd = ":lua require('persistence').load()" },
    { txt = "  Quit", keys = "q", cmd = ":qa" },

    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },

    {
      txt = function()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime) .. " ms"
        return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
      end,
      hl = "NvDashFooter",
      no_gap = true,
    },

    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
  },
}

M.mason = {
  pkgs = {
    -- "jdtls",
  },
}

return M
