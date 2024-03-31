local overrides = require "configs.mason" 

return {

  {
    "stevearc/conform.nvim",
    config = function()
      require("configs.conform")
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "nvchad.configs.lspconfig"
      require "configs.lspconfig"
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },
}
