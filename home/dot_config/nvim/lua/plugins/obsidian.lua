return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = false,

  -- Load obsidian.nvim for markdown files in your vault:
  event = {
    "BufReadPre " .. vim.fn.expand("~") .. "/Notes/**.md",
    "BufNewFile " .. vim.fn.expand("~") .. "/Notes/**.md",

    "BufReadPre " .. vim.fn.expand("~") .. "/work-notes/**.md",
    "BufNewFile " .. vim.fn.expand("~") .. "/work-notes/**.md",
  },

  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/personal-notes/",
      },
      {
        name = "work",
        path = "~/work-notes/",
      },
    },

    -- see below for full list of options 👇
  },
}
