local formatters = {
  lua = { "stylua" },
  python = { "ruff" },
  cpp = { "clang_format" },
  c = { "clang_format" },
  go = { "gofumpt", "goimports" },
  yaml = { "yamlfmt" },
}

local prettier_ft = {
  "css",
  "flow",
  "graphql",
  "html",
  "json",
  "javascriptreact",
  "javascript",
  "less",
  "markdown",
  "scss",
  "typescript",
  "typescriptreact",
  "vue",
}

for _, filetype in pairs(prettier_ft) do
  formatters[filetype] = { "prettier" }
end
