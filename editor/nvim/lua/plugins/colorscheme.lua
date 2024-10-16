-- Plugins: Colorschemes

return {

  -- Use last-used colorscheme
  { "EdenEast/nightfox.nvim", lazy = false },
  { "scottmckendry/cyberdream.nvim", lazy = false, priority = 100 },
  { "rafi/neo-hybrid.vim", priority = 100, lazy = false },
  { "rafi/awesome-vim-colorschemes", lazy = false },
  { "AlexvZyl/nordic.nvim" },
  { "folke/tokyonight.nvim", opts = { style = "night" } },
  { "rebelot/kanagawa.nvim" },
  { "olimorris/onedarkpro.nvim" },
  { "EdenEast/nightfox.nvim" },
  { "nyoom-engineering/oxocarbon.nvim" },
  { "catppuccin/nvim", lazy = true, name = "catppuccin" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "carbonfox",
    },
  },
}
