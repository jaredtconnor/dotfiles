local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local on_attach = require("plugins.lsp.opts").on_attach
local capabilities = require("plugins.lsp.opts").capabilities

mason.setup({
  ui = {
    -- Whether to automatically check for new versions when opening the :Mason window.
    check_outdated_packages_on_open = false,
    icons = {
      package_pending = " ",
      package_installed = " ",
      package_uninstalled = " ",
    },
  },
  -- install_root_dir = path.concat { vim.fn.stdpath "config", "/lua/custom/mason" },
})

mason_lspconfig.setup({
  automatic_installation = true,
  ensure_installed = {

    -- c-sharp
    "omnisharp",

    -- lua stuff
    "lua_ls",

    -- web dev stuff
    "astro",
    "tsserver",
    "cssls",
    "html",
    "tailwindcss",
    "svelte",

    -- c/cpp stuff
    "clangd",

    -- rust
    "rust_analyzer",

    -- python
    "pyright",
    "ruff_lsp",

    -- go
    "gopls",

    -- Java
    "jdtls",

    -- Yaml
    "yamlls",

    "bashls",
  },
})

local disabled_servers = {}

mason_lspconfig.setup_handlers({
  -- Automatically configure the LSP installed
  function(server_name)
    for _, name in pairs(disabled_servers) do
      if name == server_name then
        return
      end
    end
    local opts = {
      on_attach = on_attach,
      capabilities = capabilities,
    }

    local require_ok, server = pcall(require, "plugins.lsp.settings." .. server_name)
    if require_ok then
      opts = vim.tbl_deep_extend("force", server, opts)
    end

    require("lspconfig")[server_name].setup(opts)
  end,
})
