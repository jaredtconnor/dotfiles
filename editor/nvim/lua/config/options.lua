-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Ensure command line stays at the bottom
vim.opt.cmdheight = 1        -- Height of the command line
vim.opt.splitbelow = true    -- Open new split below
vim.opt.splitright = true    -- Open new split to the right

-- Message display options
vim.opt.shortmess:append("c")  -- Don't pass messages to |ins-completion-menu|
