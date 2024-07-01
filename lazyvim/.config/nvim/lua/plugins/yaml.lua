return {
  {
    -- "someone-stole-my-name/yaml-companion.nvim",
    -- temporary until PR is merged
    "agorgl/yaml-companion.nvim",
    branch = "patch-1",
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
      vim.api.nvim_create_user_command("YamlCompanion", require("yaml-companion").open_ui_select, {})
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.sections.lualine_z = {
        {
          function()
            local schema = require("yaml-companion").get_buf_schema(0)
            if schema.result[1].name == "none" then
              return ""
            end
            return schema.result[1].name
          end,
        },
        opts.sections.lualine_z,
      }
    end,
  },
}
