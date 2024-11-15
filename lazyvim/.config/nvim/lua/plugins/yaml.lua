return {
  {
    -- "someone-stole-my-name/yaml-companion.nvim",
    -- temporary until PR is merged
    "astephanh/yaml-companion.nvim",
    branch = "kubernetes_crd_detection",
    ft = { "yaml" },
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      builtin_matchers = {
        kubernetes = { enabled = true },
      },
      schemas = {
        {
          name = "ArgoCD Application",
          uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json",
        },
        {
          name = "ArgoCD ApplicationSet",
          uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/applicationset_v1alpha1.json",
        },
        {
          name = "ArgoCD AppProject",
          uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/appproject_v1alpha1.json",
        },
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
