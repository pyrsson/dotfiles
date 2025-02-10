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
            ".env",
            ".tmux.conf",
            ".Xresources",
            ".alacritty.toml",
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
          prepend_args = { "-i", "2" },
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
    },
  },
  {
    "echasnovski/mini.icons",
    opts = {
      filetype = {
        yaml = { glyph = "󰰳" },
      },
    },
    lazy = true,
    specs = {
      { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "ibhagwan/fzf-lua",
    opts = function(_, opts)
      local actions = require("fzf-lua.actions")
      opts.files.actions = {
        ["alt-t"] = { actions.toggle_hidden },
        ["alt-i"] = { actions.toggle_ignore },
      }
      opts.grep.actions = {
        ["alt-t"] = { actions.toggle_hidden },
        ["alt-i"] = { actions.toggle_ignore },
      }
    end,
  },
}
