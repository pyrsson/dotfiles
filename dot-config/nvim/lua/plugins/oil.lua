return {
  "stevearc/oil.nvim",
  lazy = false,
  keys = {
    {
      "<leader>o",
      function()
        require("oil").toggle_float()
      end,
      desc = "Toggle Oil",
    },
  },
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    float = {
      padding = 3,
      border = "rounded",
    },
  },
  -- Optional dependencies
  dependencies = {
    { "nvim-mini/mini.icons", opts = {} },
    {
      "malewicz1337/oil-git.nvim",
      dependencies = { "stevearc/oil.nvim" },
    },
  },
}
