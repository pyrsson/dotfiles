return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    opts = { style = "moon" },
  },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        width = 30,
      },
      filesystem = {
        filtered_items = {
          always_show = { -- remains visible even if other settings would normally hide it
            ".gitignore",
            ".gitignored",
            ".github",
            ".config",
            ".oh-my-zsh",
            ".local",
            ".zshrc",
            ".zshenv",
            ".stowrc",
            ".envrc",
            ".tmux.conf",
          },
        },
      },
    },
  },
  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "rust",
        "go",
      })
      opts.indent = {
        enable = true,
        disable = { "yaml" },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    --@class ConfomOpts
    opts = {
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2", "-ci" },
        },
      },
    },
  },
  { "christoomey/vim-tmux-navigator" },
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    opts = {
      -- whether to automatically load preview when
      -- entering another markdown buffer
      auto_load = true,
      -- close preview window on buffer delete
      close_on_bdelete = true,

      -- syntax = true,            -- enable syntax highlighting, affects performance

      theme = "dark", -- 'dark' or 'light'

      update_on_change = true,

      -- relevant if update_on_change is true
      throttle_at = 200000, -- start throttling when file exceeds this
      -- amount of bytes in size
      throttle_time = "auto", -- minimum amount of time in milliseconds
      -- that has to pass before starting new render
    },
    init = function()
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
  {
    "someone-stole-my-name/yaml-companion.nvim",
    ft = { "yaml" },
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      builtin_matchers = {
        kubernetes = { enabled = true },
      },
    },
    config = function(_, opts)
      local cfg = require("yaml-companion").setup(opts)
      require("lspconfig")["yamlls"].setup(cfg)
    end,
  },
  -- {
  --   "hinell/lsp-timeout.nvim",
  --   dependencies = { "neovim/nvim-lspconfig" }
  -- },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
    },
  },
}
