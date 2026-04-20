return {
  {
    "folke/noice.nvim",
    opts = {
      views = {
        cmdline_popup = {
          border = {
            style = "none",
            padding = { 2, 3 }
          },
          filter_options = {},
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          position = {
            row = 5,
            col = "50%",
          },
          size = {
            width = 60,
            height = "auto",
          },
        },
        popupmenu = {
          relative = "editor",
          position = {
            row = 8,
            col = "50%",
          },
          size = {
            width = 60,
            height = 10,
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
          },
        },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
    },
  },
}
