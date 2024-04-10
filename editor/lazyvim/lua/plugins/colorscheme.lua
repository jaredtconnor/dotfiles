-- Plugins: Colorschemes

return {

  -- Use last-used colorscheme
  { "rafi/neo-hybrid.vim", priority = 100, lazy = false },
  { "rafi/awesome-vim-colorschemes", lazy = false },
  { "AlexvZyl/nordic.nvim" },
  { "folke/tokyonight.nvim", opts = { style = "night" } },
  { "rebelot/kanagawa.nvim" },
  { "olimorris/onedarkpro.nvim" },
  { "EdenEast/nightfox.nvim" },
  { "nyoom-engineering/oxocarbon.nvim" },
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
  },
}
