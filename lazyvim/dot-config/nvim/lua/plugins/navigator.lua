return {
  {
    "dynamotn/Navigator.nvim",
    lazy = true,
    event = "VeryLazy",
    keys = {
      { "<m-h>", "<cmd>NavigatorLeft<cr>", mode = { "n", "t" }, silent = true, desc = "navigate left" },
      { "<m-j>", "<cmd>NavigatorDown<cr>", mode = { "n", "t" }, silent = true, desc = "navigate down" },
      { "<m-k>", "<cmd>NavigatorUp<cr>", mode = { "n", "t" }, silent = true, desc = "navigate up" },
      { "<m-l>", "<cmd>NavigatorRight<cr>", mode = { "n", "t" }, silent = true, desc = "navigate right" },
      { "<m-Left>", "<cmd>NavigatorLeft<cr>", mode = { "n", "t" }, silent = true, desc = "navigate left" },
      { "<m-Down>", "<cmd>NavigatorDown<cr>", mode = { "n", "t" }, silent = true, desc = "navigate down" },
      { "<m-Up>", "<cmd>NavigatorUp<cr>", mode = { "n", "t" }, silent = true, desc = "navigate up" },
      { "<m-Right>", "<cmd>NavigatorRight<cr>", mode = { "n", "t" }, silent = true, desc = "navigate right" },
    },
    opts = {},
  },
}
