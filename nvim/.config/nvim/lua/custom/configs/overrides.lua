local M = {}

M.treesitter = {
	ensure_installed = {
		"astro",
		"vim",
		"lua",
		"html",
		"css",
		"javascript",
		"typescript",
		"tsx",
		"c",
		"markdown",
		"markdown_inline",
		"svelte",
    "python"
	},
	indent = {
		enable = true,
		disable = {},
	},
}

M.mason = {
	ensure_installed = {
		-- lua stuff
		"lua-language-server",
		"stylua",

		-- web dev stuff
		"css-lsp",
		"html-lsp",
		"deno",
		"astro-language-server",
		"tailwindcss-language-server",

		-- c/cpp stuff
		"clangd",
		"clang-format",

		-- python development
		"python-lsp-server",
		"debugpy",
		"mypy",
		"ruff",
		"pyright",

		-- golang development
		"gopls",

		-- rust development
		"rust-analyzer",

		-- svelt development
		"svelte-language-server",

		-- node setup
		"eslint-lsp",
		"js-debug-adapter",
		"prettier",
		"typescript-language-server",
	},
}

-- git support in nvimtree
M.nvimtree = {
	update_focused_file = {
		enable = true,
		update_cwd = true,
	},
	renderer = {
		root_folder_modifier = ":t",
		-- These icons are visible when you install web-devicons
		icons = {
			glyphs = {
				default = "",
				symlink = "",
				folder = {
					arrow_open = "",
					arrow_closed = "",
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
					symlink_open = "",
				},
				git = {
					unstaged = "",
					staged = "S",
					unmerged = "",
					renamed = "➜",
					untracked = "U",
					deleted = "",
					ignored = "◌",
				},
			},
		},
	},
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	view = {
		width = 30,
		side = "left",
	},
}

return M
