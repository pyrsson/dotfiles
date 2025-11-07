return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        kcl = {
          root_dir = require("lspconfig.util").root_pattern("kcl.mod"),
          mason = false,
        },
      },
    },
  },
  { "kcl-lang/kcl.nvim" },
}
