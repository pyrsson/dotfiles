return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    opts = {
      transparent = true,
      style = "storm",
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  -- Configure LazyVim to load tokyonight
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
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
    "mbbill/undotree",
    keys = {
      { "<leader>U", "<cmd>UndotreeToggle<CR>", desc = "Undo tree" },
    },
  },
}
