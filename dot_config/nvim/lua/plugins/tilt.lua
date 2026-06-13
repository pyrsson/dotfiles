return {
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
}
