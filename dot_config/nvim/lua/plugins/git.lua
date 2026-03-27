return {
  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim", -- required

      {
        "sindrets/diffview.nvim", -- optional
        opts = {
          file_panel = {
            listing_style = "list",
          },
          keymaps = {
            view = {
              { "n", "q", ":DiffviewClose<CR>", desc = "Close Diffview" },
            },
            file_panel = {
              { "n", "q", ":DiffviewClose<CR>", desc = "Close Diffview" },
            },
          },
        },
      },
    },
    cmd = "Neogit",
    opts = {
      integrations = {
        telescope = false,
      },
    },
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
      { "<leader>gc", "<cmd>DiffviewOpen<cr>", desc = "Show Diffview UI" },
    },
  },
}
