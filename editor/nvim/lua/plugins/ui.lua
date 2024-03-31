local overrides = require "configs.nvim-tree"

return {

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },
}
