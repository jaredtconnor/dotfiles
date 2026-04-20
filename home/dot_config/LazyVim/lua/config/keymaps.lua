local map = vim.keymap.set

map("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "go to new tab" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<CR> ", { desc = "goto prev tab" })
