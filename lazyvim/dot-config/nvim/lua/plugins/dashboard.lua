return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        sections = {
          -- { section = "header" },
          {
            section = "terminal",
            cmd = "chafa --format symbols --symbols vhalf --size 28 ~/Pictures/logo_white_squid.png; sleep .1",
            height = 30,
            width = 28,
            align = "center",
            indent = 17,
            padding = 0,
          },
          {
            pane = 2,
            { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
            -- { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
            { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
            { section = "startup" },
          },
        },
      },
    },
  },
}
