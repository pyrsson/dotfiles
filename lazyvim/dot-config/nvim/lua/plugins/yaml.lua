return {
  {
    "cenk1cenk2/schema-companion.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require("schema-companion").setup({})
    end,
  },
  {
    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          yamlls = {
            before_init = function() end,
          },
        },
      },
    },
  },
}
