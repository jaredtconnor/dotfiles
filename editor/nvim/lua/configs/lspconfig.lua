-- EXAMPLE
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "html", "cssls" }

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "python" },
}

lspconfig.gopls.setup {
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
}

lspconfig.terraformls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "terraform-ls", "serve" },
  root_dir = util.root_pattern(".terraform", ".git"),
}

lspconfig.svelte.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "serveserver", "--stdio" },
  filetypes = { "svelte" },
  root_dir = util.root_pattern("package.json", ".git"),
}

lspconfig.astro.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "astro-ls", "--stdio" },
  filetypes = { "astro", "mdx" },
  init_options = {
    typescript = { tsdk = "node_modules/typescript/lib" },
  },
  root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git", "astro.config.mjs"),
}

lspconfig.html.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.tsserver.setup {
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
}
