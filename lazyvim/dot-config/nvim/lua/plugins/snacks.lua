---@module 'snacks'
return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      lazygit = {
        layout = "floating",
      },
      picker = {
        layouts = {
          sidebar = {
            preview = "main",
            layout = {
              width = 30,
              min_width = 30,
            },
          },
        },
      },
    },
  },
}
