return {
  --   {
  --     "neovim/nvim-lspconfig",
  --     opts = {
  --       servers = {
  --         htmx = {},
  --       },
  --     },
  --   },
  --   {
  --     "williamboman/mason.nvim",
  --     opts = function(_, opts)
  --       vim.list_extend(opts.ensure_installed, {
  --         "htmx-lsp",
  --       })
  --     end,
  --   },
}
