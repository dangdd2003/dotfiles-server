require "nvchad.options"

local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!
local shell
if vim.fn.has "linux" == 1 then
  shell = "zsh"
elseif vim.fn.has "mac" == 1 then
  shell = "zsh"
else
  shell = "pwsh"
end
o.shell = shell

local opt = vim.opt
opt.title = true
opt.autoindent = true
opt.hlsearch = true
opt.showcmd = true
opt.smarttab = true
opt.relativenumber = true
opt.breakindent = true
opt.path:append { "**" }
opt.wildignore:append { "*/node_modules/*" }
opt.formatoptions = "jcroqlnt"
opt.cursorline = true
opt.expandtab = true
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.termguicolors = true
opt.smartindent = true
opt.wrap = false
opt.pumheight = 10

-- Neovide (if installed)
if vim.g.neovide then
  vim.o.guifont = "Hack Nerd Font:h11"
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_cursor_vfx_mode = "railgun"
end

vim.filetype.add {
  filename = {
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
    ["compose.yml"] = "yaml.docker-compose",
  },
}
