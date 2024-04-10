-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymaps.set

--- tab
map("n", "<S-h>", "<cmd>tabprevious<CR>", "goto next tab")
map("n", "<S-l>", "<cmd>tabnext<CR> ", "goto prev tab")
