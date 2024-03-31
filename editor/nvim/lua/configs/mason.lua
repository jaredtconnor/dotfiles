local M = { } 

M.mason = {
	ensure_installed = {
		-- lua
		"lua-language-server",
		"stylua",
		-- web
		"css-lsp",
		"html-lsp",
		"eslint-lsp",
		"typescript-language-server",
		"js-debug-adapter",
		"deno",
		"prettier",
		"prettierd",
		-- go
		"gopls",
		"golangci-lint",
		"golangci-lint-langserver",
		"goimports",
		"goimports-reviser",
		-- java
		"java-language-server",
		"jdtls",
		-- azure
		"azure-pipelines-language-server",
		-- bash
		"shellcheck",
		"bash-language-server",
		-- python
		"pyright",
		"flake8",
		"black",
		"debugpy",
		"mypy",
		"pydocstyle",
		"pylint",
		"pyre",
		"autoflake",
		"autopep8",
		"python-lsp-server",
	},
} 

return M
