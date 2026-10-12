---@module 'snacks'
return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      lazygit = {
        win = {
          width = 0,
          height = 0,
        },
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
        sources = {
          explorer = {
            hidden = true,
            layout = {
              auto_hide = { "input" },
            },
          },
          files = {
            hidden = true,
          },
        },
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
            },
          },
        },
      },
    },
  },
}
