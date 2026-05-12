return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    ---@class tokyonight.Config
    opts = {
      day_brightness = 0.3,
      style = "night",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      opts.colorscheme = "tokyonight"
    end,
  },
  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "yaml",
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
      diagnostics = {
        virtual_lines = false,
        virtual_text = true,
      },
    },
  },
  {
    "nvim-mini/mini.icons",
    opts = {
      filetype = {
        yaml = { glyph = "" },
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
}
