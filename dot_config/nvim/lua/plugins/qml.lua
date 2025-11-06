return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ---@type vim.lsp.Config
        qmlls = {
          cmd = { "qmlls6" },
          root_markers = { ".git", ".qmlls.ini" },
        },
      },
    },
  },
}
