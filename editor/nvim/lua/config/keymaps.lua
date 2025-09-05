local map = vim.keymap.set

map("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "go to new tab" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<CR> ", { desc = "goto prev tab" })

-- Transparent.nvim commands
map("n", "<leader>tt", "<cmd>TransparentToggle<CR>", { desc = "toggle transparency" })
map("n", "<leader>te", "<cmd>TransparentEnable<CR>", { desc = "enable transparency" })
map("n", "<leader>td", "<cmd>TransparentDisable<CR>", { desc = "disable transparency" })

