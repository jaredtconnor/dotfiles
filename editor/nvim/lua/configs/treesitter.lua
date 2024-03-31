local M ={}   

M.treesitter = {
	ensure_installed = {  
    "astro",
		"bash",
		"c",
		"css",
		"go",
		"gomod",
		"gosum",
		"html",
		"java",
		"javascript",
		"json",
		"jsonc",
		"lua",
		"markdown_inline",
		"markdown",
    "mdx",
		"python",
		"typescript",
		"vim",
		"vimdoc",
		"yaml",
	}, 
  auto_install = true, 
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
		disable = {
		  "python"
		},
	},
}
 
return M
