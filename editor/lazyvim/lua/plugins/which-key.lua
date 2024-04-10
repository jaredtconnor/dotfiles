-- NOTE: Keymaps Popup/Guide
return {
  "folke/which-key.nvim",
  opts = {
    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = "➜", -- symbol used between a key and it's label
      group = "", -- symbol prepended to a group
    },
  },
  config = function(_, opts)
    require("which-key").setup(opts)
    require("which-key").register({
      {},
    })
  end,
}
