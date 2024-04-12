local map = vim.keymap.set

map("n", "<S-h>", "<cmd>BufferLineCycleNext<CR>", { desc = "go to new tab" })
map("n", "<S-l>", "<cmd>BufferLineCyclePrev<CR> ", { desc = "goto prev tab" })
