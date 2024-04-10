local map = vim.keymap.set

map("n", "<S-h>", "<cmd>tabprevious<CR>", { desc = "go to new tab" })
map("n", "<S-l>", "<cmd>tabnext<CR> ", { desc = "goto prev tab" })
