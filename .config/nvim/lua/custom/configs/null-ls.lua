local null_ls = require("null-ls")
local builtin = null_ls.builtins
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local sources = {

  -- webdev development
  builtin.formatting.deno_fmt,

  builtin.formatting.prettier.with({

    filetypes = { "html", "markdown", "css" },
    extra_filetypes = { "astro" },
    extra_args = { "--single-quote" },
  }), -- so prettier works only on these filetypes

  -- Lua
  builtin.formatting.stylua.with({
    filetypes = {
      "lua",
    },
    args = { "--indent-width", "2", "--indent-type", "Spaces", "-" },
  }),

  -- Golang
  builtin.formatting.gofumpt,
  builtin.formatting.goimports_reviser,
  builtin.formatting.golines,

  -- Python
  builtin.diagnostics.mypy,
  builtin.diagnostics.ruff,

  -- Rust
  builtin.formatting.rustfmt,

  -- Clang
  builtin.formatting.clang_format,

  -- Node
  null_ls.builtins.diagnostics.eslint,
  null_ls.builtins.formatting.prettier,

  -- Diagnostics
  -- null_ls.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
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
