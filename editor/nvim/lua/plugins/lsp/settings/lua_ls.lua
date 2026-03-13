return {
  settings = {
    Lua = {
      semantic = {
        enable = false,
      },
      hint = { enable = true },
      diagnostics = {
        globals = { "vim" },
      },
      telemetry = { enable = false },
      workspace = {
        library = {},
        checkThirdParty = false,
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}
