local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local util = require("lspconfig/util")

local function organize_imports()
	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
	}
	vim.lsp.buf.execute_command(params)
end 




lspconfig.pyright.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "python" },
})

lspconfig.gopls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "gopls" },
	cmd_env = {
		GOFLAGS = "-tags=test,e2e_test,integration_test,acceptance_test",
	},
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_dir = util.root_pattern("go.work", "go.mod", ".git"),
	settings = {
		gopls = {
			completeUnimported = true,
			usePlaceholders = true,
			analyses = {
				unusedparams = true,
			},
		},
	},
})

lspconfig.terraformls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "terraform-ls", "serve" },
	root_dir = util.root_pattern(".terraform", ".git"),
})

lspconfig.svelte.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "serveserver", "--stdio" },
	filetypes = { "svelte" },
	root_dir = util.root_pattern("package.json", ".git"),
})

lspconfig.astro.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "astro-ls", "--stdio" },
	filetypes = { "astro" },
  init_options = {
    typescript = {}
  },
	root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
})

lspconfig.html.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig.tsserver.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	init_options = {
		preferences = {
			disableSuggestions = true,
		},
	},
	commands = {
		OrganizeImports = {
			organize_imports,
			description = "Organize Imports",
		},
	},
})
