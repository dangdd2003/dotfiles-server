local function get_jdtls()
  -- Get the Mason Registry to gain access to downloaded binaries
  local mason_registry = require "mason-registry"
  -- Find the JDTLS package in the Mason Regsitry
  local jdtls = mason_registry.get_package "jdtls"
  -- Find the full path to the directory where Mason has downloaded the JDTLS binaries
  local jdtls_path = jdtls:get_install_path()
  -- Obtain the path to the jar which runs the language server
  local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  -- Declare white operating system we are using, windows use win, macos use mac
  local SYSTEM
  if vim.fn.has "linux" == 1 then
    SYSTEM = "linux"
  elseif vim.fn.has "mac" == 1 then
    SYSTEM = "mac"
  else
    SYSTEM = "win"
  end
  -- Obtain the path to configuration files for your specific operating system
  local config = jdtls_path .. "/config_" .. SYSTEM
  -- Obtain the path to the Lomboc jar
  local lombok = jdtls_path .. "/lombok.jar"
  return launcher, config, lombok
end

local function get_bundles()
  -- Get the Mason Registry to gain access to downloaded binaries
  local mason_registry = require "mason-registry"
  -- Find the Java Debug Adapter package in the Mason Registry
  local java_debug = mason_registry.get_package "java-debug-adapter"
  -- Obtain the full path to the directory where Mason has downloaded the Java Debug Adapter binaries
  local java_debug_path = java_debug:get_install_path()

  local bundles = {
    vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", 1),
  }

  -- Find the Java Test package in the Mason Registry
  local java_test = mason_registry.get_package "java-test"
  -- Obtain the full path to the directory where Mason has downloaded the Java Test binaries
  local java_test_path = java_test:get_install_path()
  -- Add all of the Jars for running tests in debug mode to the bundles list
  vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar", 1), "\n"))

  return bundles
end

local function get_workspace()
  -- Get the home directory of your operating system
  local home
  if vim.fn.has "win32" then
    home = vim.fn.getenv "HOMEPATH"
  else
    home = vim.fn.getenv "HOME"
  end
  -- Declare a directory where you would like to store project information
  local workspace_path = home .. "/.cache/jdtls/"
  -- Determine the project name
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  -- Create the workspace directory by concatenating the designated workspace path and the project name
  local workspace_dir = workspace_path .. project_name
  return workspace_dir
end

local function java_keymaps(bufnr)
  local wk = require "which-key"
  wk.add {
    {
      mode = "n",
      buffer = bufnr,
      { "<leader>cx", group = "extract" },
      { "<leader>cxv", require("jdtls").extract_variable_all, desc = "jdtls extract variable" },
      { "<leader>cxc", require("jdtls").extract_constant, desc = "jdtls extract constant" },
      { "<leader>cu", require("jdtls").update_project_config, desc = "jdtls update project config" },
      { "<leader>gs", require("jdtls").super_implementation, desc = "jdtls goto super" },
      { "<leader>gS", require("jdtls.tests").goto_subjects, desc = "jdtls goto goto subjects" },
      { "<leader>co", require("jdtls").organize_imports, desc = "jdtls organize imports" },
    },
  }
  wk.add {
    {
      mode = "v",
      buffer = bufnr,
      { "<leader>cx", group = "extract" },
      {
        "<leader>cxm",
        [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
        desc = "jdtls extract methods",
      },
      {
        "<leader>cxv",
        [[<ESC><CMD>lua require('jdtls').extract_variable_all(true)<CR>]],
        desc = "jdtls extract variable",
      },
      {
        "<leader>cxc",
        [[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]],
        desc = "jdtls extract constant",
      },
    },
  }
end

local function setup_jdtls()
  -- Get access to the jdtls plugin and all of its functionality
  local jdtls = require "jdtls"

  -- Get the paths to the jdtls jar, operating specific configuration directory, and lombok jar
  local launcher, os_config, lombok = get_jdtls()

  -- Get the path you specified to hold project information
  local workspace_dir = get_workspace()

  -- Get the bundles list with the jars to the debug adapter, and testing adapters
  local bundles = get_bundles()

  -- Determine the root directory of the project by looking for these specific markers
  local root_dir = jdtls.setup.find_root {
    ".git",
    "mvnw",
    "gradlew",
    "pom.xml",
    "build.gradle",
    "build.gradle",
    "build.gradle.kts",
    "build.xml", -- Ant
    "pom.xml", -- Maven
    "settings.gradle", -- Gradle
    "settings.gradle.kts", -- Gradle
  }

  -- Tell our JDTLS language features it is capable of
  local capabilities = {
    workspace = {
      configuration = true,
    },
    textDocument = {
      completion = {
        snippetSupport = false,
      },
    },
  }

  local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

  for k, v in pairs(lsp_capabilities) do
    capabilities[k] = v
  end

  -- Get the default extended client capablities of the JDTLS language server
  local extendedClientCapabilities = jdtls.extendedClientCapabilities
  -- Modify one property called resolveAdditionalTextEditsSupport and set it to true
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

  -- Set the command that starts the JDTLS language server jar
  local cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-javaagent:" .. lombok,
    "-jar",
    launcher,
    "-configuration",
    os_config,
    "-data",
    workspace_dir,
  }

  -- Configure settings in the JDTLS server
  local settings = {
    java = {
      -- Enable code formatting
      format = {
        enabled = true,
        -- Use the Google Style guide for code formatting
        -- settings = {
        --   url = vim.fn.stdpath "config" .. "/lang_servers/intellij-java-google-style.xml",
        --   profile = "GoogleStyle",
        -- },
      },
      -- Enable downloading archives from eclipse automatically
      eclipse = {
        downloadSource = true,
      },
      -- Enable downloading archives from maven automatically
      maven = {
        downloadSources = true,
      },
      -- Enable method signature help
      signatureHelp = {
        enabled = true,
      },
      -- Use the fernflower decompiler when using the javap command to decompile byte code back to java code
      contentProvider = {
        preferred = "fernflower",
      },
      -- Setup automatical package import oranization on file save
      saveActions = {
        organizeImports = true,
      },
      -- Customize completion options
      completion = {
        -- When using an unimported static method, how should the LSP rank possible places to import the static method from
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
        -- Try not to suggest imports from these packages in the code action window
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
        },
        -- Set the order in which the language server should organize imports
        importOrder = {
          "java",
          "jakarta",
          "javax",
          "com",
          "org",
        },
      },
      sources = {
        -- How many classes from a specific package should be imported before automatic imports combine them all into a single import
        organizeImports = {
          starThreshold = 999,
          staticThreshold = 999,
        },
      },
      -- How should different pieces of code be generated?
      codeGeneration = {
        -- When generating toString use a json format
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        -- When generating hashCode and equals methods use the java 7 objects method
        hashCodeEquals = {
          useJava7Objects = true,
        },
        -- When generating code use code blocks
        useBlocks = true,
      },
      -- If changes to the project will require the developer to update the projects configuration advise the developer before accepting the change
      configuration = {
        updateBuildConfiguration = "interactive",
      },
      -- enable code lens in the lsp
      referencesCodeLens = {
        enabled = true,
      },
      -- enable inlay hints for parameter names,
      inlayHints = {
        parameterNames = {
          enabled = "all",
        },
      },
    },
  }

  -- Create a table called init_options to pass the bundles with debug and testing jar, along with the extended client capablies to the start or attach function of JDTLS
  local init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
  }

  -- Function that will be ran once the language server is attached
  local on_attach = function(client, bufnr)
    -- Map the Java specific key mappings once the server is attached
    java_keymaps(bufnr)

    -- Adapt NvChad Config
    require("nvchad.configs.lspconfig").on_attach(nil, bufnr)
    require("nvchad.configs.lspconfig").on_init(client)

    -- Setup the java debug adapter of the JDTLS server
    -- require("jdtls.dap").setup_dap()

    -- Find the main method(s) of the application so the debug adapter can successfully start up the application
    -- Sometimes this will randomly fail if language server takes to long to startup for the project, if a ClassDefNotFoundException occurs when running
    -- the debug tool, attempt to run the debug tool while in the main class of the application, or restart the neovim instance
    -- Unfortunately I have not found an elegant way to ensure this works 100%
    -- require("jdtls.dap").setup_dap_main_class_configs()

    -- Refresh the codelens
    -- Code lens enables features such as code reference counts, implemenation counts, and more.
    vim.lsp.codelens.refresh()

    -- Setup a function that automatically runs every time a java file is saved to refresh the code lens
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = { "*.java" },
      callback = function()
        local _, _ = pcall(vim.lsp.codelens.refresh)
      end,
    })
  end

  -- Create the configuration table for the start or attach function
  local config = {
    cmd = cmd,
    root_dir = root_dir,
    settings = settings,
    capabilities = capabilities,
    init_options = init_options,
    on_attach = on_attach,
  }

  -- Start the JDTLS server
  require("jdtls").start_or_attach(config)
end

return {
  setup_jdtls = setup_jdtls,

  -- Attach the jdtls for each buffer
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = setup_jdtls,
  }),
}
