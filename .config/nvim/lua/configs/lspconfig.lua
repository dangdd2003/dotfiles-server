-- override default on_attach function from NvChad
require("nvchad.configs.lspconfig").on_attach = function(_, bufnr)
  local map = vim.keymap.set
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gd", function()
    require("telescope.builtin").lsp_definitions { reuse_win = true }
  end, opts "Go to definitions")
  map("n", "gi", function()
    require("telescope.builtin").lsp_implementations { reuse_win = true }
  end, opts "Go to implementation")
  map("n", "gr", "<cmd>Telescope lsp_references<CR>", opts "Show references")
  map("n", "gK", vim.lsp.buf.signature_help, opts "Show signature help")

  map("n", "<leader>D", function()
    require("telescope.builtin").lsp_type_definitions { reuse_win = true }
  end, opts "Go to type definition")
  map("n", "<leader>cr", function()
    local inc_rename = require "inc_rename"
    return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand "<cword>"
  end, { expr = true, buffer = bufnr, desc = "LSP Rename (inc-rename)" })

  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
  map("n", "<leader>cC", vim.lsp.codelens.refresh, opts "Refresh codelens")
  map("n", "<leader>cl", vim.lsp.codelens.clear, opts "Clear codelens")

  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")
  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")

  map("n", "<leader>uh", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, { desc = "Toggle Inlay hint" })
end

local nvlsp = require "nvchad.configs.lspconfig"

-- run defaults lsp from NvChad
nvlsp.defaults()

local lspconfig = require "lspconfig"

local servers = {
  -- pyright = {
  --   settings = {
  --     python = {
  --       analysis = {
  --         -- typeCheckingMode = "strict",
  --       },
  --     },
  --   },
  -- },
  -- ruff = {
  --   cmd_env = { RUFF_TRACE = "messages" },
  --   init_options = {
  --     settings = {
  --       logLevel = "error",
  --     },
  --   },
  -- },
  -- clangd = {
  --   root_dir = function(fname)
  --     return require("lspconfig.util").root_pattern(
  --       "Makefile",
  --       "configure.ac",
  --       "configure.in",
  --       "config.h.in",
  --       "meson.build",
  --       "meson_options.txt",
  --       "build.ninja"
  --     )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(fname) or require(
  --       "lspconfig.util"
  --     ).find_git_ancestor(fname)
  --   end,
  --   capabilities = {
  --     offsetEncoding = { "utf-16" },
  --   },
  --   cmd = {
  --     "clangd",
  --     "--background-index",
  --     "--clang-tidy",
  --     "--header-insertion=iwyu",
  --     "--completion-style=detailed",
  --     "--function-arg-placeholders",
  --     "--fallback-style=llvm",
  --   },
  --   init_options = {
  --     usePlaceholders = true,
  --     completeUnimported = true,
  --     clangdFileStatus = true,
  --   },
  -- },
  nil_ls = {}, -- comment when run "MasonInstallAll" to avoid building from source, install 'nil' from package manager instead
  nginx_language_server = {},
}

-- setup
for name, opts in pairs(servers) do
  opts.on_init = nvlsp.on_init
  opts.on_attach = nvlsp.on_attach
  opts.capabilities = nvlsp.capabilities
  lspconfig[name].setup(opts)
end
