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
	builtin.diagnostics.mypy,
	builtin.diagnostics.ruff,

	-- Rust 


  -- Node 
  null_ls.builtins.diagnostics.eslint,
  null_ls.builtins.formatting.prettier
}

local opts = {
	sources = sources,
	on_attach = function(client, bufnr)
	if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({
				group = augroup,
				buffer = bufnr,
			})
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
}
return opts

-- null_ls.setup({
-- 	debug = true,
-- 	sources = sources,
-- })
