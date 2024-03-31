local M = {}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },
  filters = {
    dotfiles = false,
  },
  view = {
    width = 40,
  },
  renderer = {
    group_empty = true,
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
  sort = {
    sorter = "case_sensitive",
  },
}

return M
