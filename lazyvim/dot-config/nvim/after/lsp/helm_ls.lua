return require("schema-companion").setup_client(
  require("schema-companion").adapters.helmls.setup({
    sources = {
      -- your sources for the language server
      require("schema-companion").sources.matchers.kubernetes.setup({ version = "master" }),
    },
  }),
  {
    --- your language server configuration
    yamlls = function()
      LazyVim.lsp.on_attach(function(client, buffer)
        if vim.bo[buffer].filetype == "helm" then
          vim.schedule(function()
            vim.cmd("LspStop ++force yamlls")
          end)
        end
      end, "yamlls")
    end,
  }
)
