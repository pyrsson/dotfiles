return {
  {
    "dynamotn/Navigator.nvim",
    lazy = true,
    event = "VeryLazy",
    keys = {
      { "<m-h>", "<cmd>NavigatorLeft<cr>", { silent = true, desc = "navigate left" } },
      { "<m-j>", "<cmd>NavigatorDown<cr>", { silent = true, desc = "navigate down" } },
      { "<m-k>", "<cmd>NavigatorUp<cr>", { silent = true, desc = "navigate up" } },
      { "<m-l>", "<cmd>NavigatorRight<cr>", { silent = true, desc = "navigate right" } },
      { "<m-Left>", "<cmd>NavigatorLeft<cr>", { silent = true, desc = "navigate left" } },
      { "<m-Down>", "<cmd>NavigatorDown<cr>", { silent = true, desc = "navigate down" } },
      { "<m-Up>", "<cmd>NavigatorUp<cr>", { silent = true, desc = "navigate up" } },
      { "<m-Right>", "<cmd>NavigatorRight<cr>", { silent = true, desc = "navigate right" } },
    },
    opts = {},
  },
}
