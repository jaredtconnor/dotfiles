--  NOTE: LSP Configuration
return {
  "neovim/nvim-lspconfig",
  cmd = "LspInfo",
  config = function()
    local signs = { Error = "", Warn = "", Hint = "󰌵", Info = "" }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    local config = {
      -- Enable virtual text
      virtual_text = true,
      -- show signs
      signs = {
        active = signs,
      },
      update_in_insert = true,
      underline = true,
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    }

    vim.diagnostic.config(config)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "rounded",
    })
  end,
  dependencies = {

    -- NOTE: Formatting
    {
      "stevearc/conform.nvim",
      opts = require("plugins.lsp.conform"),
    },
    -- NOTE: Linting
    {
      "mfussenegger/nvim-lint",
      enabled = false,
      config = function()
        require("plugins.lsp.nvim-lint")
      end,
    },

    -- NOTE: For Typescript
    {
      "pmizio/typescript-tools.nvim",
      opts = {
        settings = {
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeCompletionsForModuleExports = true,
            quotePreference = "auto",
          },
        },
      },
    },
    -- NOTE: For Java
    {
      "mfussenegger/nvim-jdtls",
      ft = "java",
    },

    -- NOTE: Package installer
    {
      "williamboman/mason.nvim",
      cmd = {
        "Mason",
        "MasonInstall",
        "MasonInstallAll",
        "MasonUpdate",
        "MasonUninstall",
        "MasonUninstallAll",
        "MasonLog",
      },
      dependencies = {
        "williamboman/mason-lspconfig.nvim",
        config = function()
          require("plugins.lsp.mason")
        end,
      },
      opts = {
        registries = {
          "github:nvim-java/mason-registry",
          "github:mason-org/mason-registry",
        },
        ensure_installed = {
          -- Formatters
          "stylua",
          "ruff",
          "clang-format",
          "gofumpt",
          "goimports",
          "yamlfmt",
          "prettier",
          -- Debugger
          "bash-debug-adapter",
          "firefox-debug-adapter",
          "java-debug-adapter",
          "java-test",
          "js-debug-adapter",
          "node-debug2-adapter",
          "debugpy",
          "go-debug-adapter",
          "delve",
        },
      },
    },
    -- NOTE: Improve Other LSP Functionalities
    {
      "nvimdev/lspsaga.nvim",
      opts = require("plugins.lsp.lspsaga"),
    },
    -- NOTE: For managing error and warning messages
    {
      "folke/trouble.nvim",
      cmd = { "TroubleToggle", "Trouble" },
      opts = require("plugins.lsp.trouble"),
    },
    -- NOTE: Displaying References and Definition
    {
      "VidocqH/lsp-lens.nvim",
      opts = {
        enable = true,
      },
    },
  },
}
