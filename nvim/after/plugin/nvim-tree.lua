require('nvim-tree').setup({
  sort_by = "case_sensitive",
  open_on_setup = true,
  ignore_ft_on_setup = {
    "gitcommit",
  },
  view = {
    hide_root_folder = true,
    adaptive_size = true,
    mappings = {
      list = {
        {key = {"<C-e>", "e"}, action = "edit"},
      },
    },
  },
  renderer = {
    group_empty = true,
    indent_width = 2,
    indent_markers = {
      enable = true,
      inline_arrows = true,
      icons = {
        corner = "└",
        edge = "│",
        item = "│",
        bottom = "─",
        none = " ",
      },
    },
    icons = {
      webdev_colors = true,
      git_placement = "after",
      padding = " ",
      symlink_arrow = " ➛ ",
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        git = {
          unstaged = "M",
          staged = "M",
          unmerged = "M",
          renamed = "R",
          untracked = "U",
          deleted = "D",
          ignored = "◌",
        },
      },
    },
  },
  filters = {
    custom = {
      "^\\.git$",
    },
    -- dotfiles = true,
    -- exclude = {
    --   ".github",
    --   ".gitignore"
    -- }
  },
  tab = {
    sync = {
      open = true,
      close = true,
      ignore = {"term://"},
    },
  },
})

