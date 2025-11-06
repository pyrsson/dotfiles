return {
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        mux = {
          backend = "tmux",
        },
      },
    },
  },
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     servers = {
  --       copilot = {
  --         opts = {
  --           filetypes = {
  --             yaml = true,
  --             markdown = true,
  --           },
  --         },
  --       },
  --     },
  --   },
  -- },
}
