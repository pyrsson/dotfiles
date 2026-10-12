return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "starlark",
      })
      vim.treesitter.language.register("starlark", "tiltfile")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tilt_ls = {},
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "tilt",
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        tiltfile = { "buildifier" },
      },
      formatters = {
        buildifier = {
          prepend_args = { "-type=bzl" },
        },
      },
    },
  },
}
