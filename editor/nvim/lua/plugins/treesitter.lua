local overrides = require("configs.treesitter")

return {

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },
}
