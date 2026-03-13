-- Plugins: Colorschemes with transparent background

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
      colorscheme = "tokyonight",
    },
  },


  -- Tokyo Night with transparent background
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "transparent",
        floats = "transparent",
      },
      sidebars = { 
        "qf", "help", "vista_kind", "terminal", "packer",
        "snacks_layout_box", -- Critical for snacks.nvim explorer transparency
        "NvimTree", "NeoTree", "BufferLine", "TelescopePrompt",
        "Lazy", "Mason", "LspInfo", "Trouble"
      },
      day_brightness = 0.3,
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = false,
    },
  },
}
