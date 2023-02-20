require('nvim-tree').setup({
  sort_by = "case_sensitive",
  -- open_on_setup = true,
  -- ignore_ft_on_setup = {
  --   "gitcommit",
  -- },
  view = {
    hide_root_folder = true,
    adaptive_size = false,
    signcolumn = "auto",
    width = 30,
    mappings = {
      list = {
        { key = { "<C-e>" }, action = "" },
        { key = { "e" }, action = "edit" },
      },
    },
  },
  -- git = {
  --   show_on_open_dirs = false,
  -- },
  renderer = {
    group_empty = true,
    indent_width = 2,
    highlight_git = true,
    indent_markers = {
      enable = true,
      inline_arrows = true,
      icons = {
        corner = "┗",
        edge = "┃",
        item = "┃",
        bottom = "━",
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
        git = false,
      },
      glyphs = {
        git = {
          unstaged = "M",
          staged = "S",
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
      ignore = { "term://" },
    },
  },
})

local function open_nvim_tree(data)
  if string.match(data.file, "/tmp/") or string.match(data.file, ".git/") then
    return
  end

  -- open the tree but don't focus it
  require("nvim-tree.api").tree.toggle({ focus = false, find_file = true })

end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
