return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require "configs.conform"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- lua stuff
        "lua-language-server",
        "stylua",

        -- web dev stuff
        "css-lsp",
        "html-lsp",
        "deno",
        "astro-language-server",
        "tailwindcss-language-server",

        -- c/cpp stuff
        "clangd",
        "clang-format",

        -- python development
        "python-lsp-server",
        "debugpy",
        "mypy",
        "ruff",
        "pyright",

        -- golang development
        "gopls",

        -- rust development
        "rust-analyzer",

        -- svelt development
        "svelte-language-server",

        -- node setup
        "eslint-lsp",
        "js-debug-adapter",
        "prettier",
        "typescript-language-server",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "astro",
        "vim",
        "lua",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "c",
        "markdown",
        "markdown_inline",
        "svelte",
        "python",
      },
      indent = {
        enable = true,
        disable = {},
      },
    },
  },
}
