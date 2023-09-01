local null_ls = require("null-ls")
local builtin = null_ls.builtins
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local sources = {

	-- webdev development
	builtin.formatting.prettier.with({ filetypes = { "html", "markdown", "css" } }), -- so prettier works only on these filetypes

	-- Lua
	builtin.formatting.stylua,

	-- Golang
	builtin.formatting.gofumpt,
	builtin.formatting.goimports_reviser,
	builtin.formatting.golines,

	-- Python
	builtin.formatting.black,
	builtin.diagnostics.mypy,
	builtin.diagnostics.ruff,

	-- Rust
}

null_ls.setup({
	debug = true,
	sources = sources,
})
