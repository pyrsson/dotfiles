return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        templ = {},
        html = {
          filetypes = { "html", "templ" },
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "templ",
        "html-lsp",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "templ",
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    --@class ConfomOpts
    opts = {
      formatters_by_ft = {
        templ = {
          "templ",
        },
      },
    },
  },
}
