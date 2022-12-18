-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

vim.api.nvim_create_autocmd("FileType", {
  pattern = "NvimTree",
  command = "setlocal fillchars=eob:\\ "
})

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  open_on_setup = true,
  ignore_ft_on_setup = {
    "gitcommit",
  },
  view = {
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
  },
  filters = {
    dotfiles = true,
  },
  tab = {
    sync = {
      open = true,
      close = true,
      ignore = {"term://"},
    },
  },
})

