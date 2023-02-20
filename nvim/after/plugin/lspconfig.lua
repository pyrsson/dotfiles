local lsp = require('lsp-zero')
local cfg = require("yaml-companion").setup({
  schemas = {
    {
      name = "Kubernetes 1.23.6",
      uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.23.6-standalone-strict/all.json",
    },
    {
      name = "Application",
      uri = "./schemas/application-argoproj-v1alpha1.json",
    },
    {
      name = "ApplicationSet",
      uri = "./schemas/applicationset-argoproj-v1alpha1.json",
    },
    {
      name = "RunnerDeployment",
      uri = "./schemas/runnerdeployment-actions-v1alpha1.json",
    },
  },
})

local cmp = require 'cmp'
-- toggle comment plugin
require('Comment').setup()
require('gitsigns').setup()
require("neodev").setup({})
-- copilot
require("copilot").setup({
  suggestion = { enabled = false },
  panel      = { enabled = false },
  filetypes  = { yaml = true }
})
require("copilot_cmp").setup()

lsp.preset({
  name = 'recommended',
  set_lsp_keymaps = true,
  manage_nvim_cmp = true,
})

lsp.set_preferences({
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I'
  }
})

lsp.ensure_installed({
  "lua_ls",
  "rust_analyzer",
  "gopls",
  "bashls",
  "yamlls",
  "tsserver",
  "eslint",
})

lsp.configure("yamlls", cfg)
lsp.configure('lua_ls', {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      },
      diagnostics = {
        globals = { 'vim' }
      },
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        }
      }
    }
  }
})
lsp.configure('eslint', {
  on_attach = function(client, _)
    client.server_capabilities.documentFormattingProvider = true
  end,
  settings = {
    format = { enable = true }, -- this will enable formatting
  },
})
lsp.configure('tsserver', {
  on_attach = function(client, _)
    client.server_capabilities.documentFormattingProvider = false
  end,
  settings = {
    format = { enable = false }, -- this will enable formatting
  },
})

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

local cmp_mappings = lsp.defaults.cmp_mappings({
  ["<PageUp>"] = function(fallback)
    if cmp.visible() then
      for _ = 1, 10 do
        cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select })(nil)
      end
    else
      fallback()
    end
  end,
  ["<PageDown>"] = function(fallback)
    if cmp.visible() then
      for _ = 1, 10 do
        cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select })(nil)
      end
    else
      fallback()
    end
  end,
  ["<C-Space>"] = cmp.mapping.complete(),
  ["<CR>"] = cmp.mapping.confirm({
    -- this is the important line
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  }),
  ["<C-s>"] = cmp.mapping.complete({
    config = {
      sources = {
        {
          name = 'copilot',
        },
      }
    }
  }),
  ["<Tab>"] = vim.schedule_wrap(function(fallback)
    if cmp.visible() and has_words_before() then
      cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
    else
      fallback()
    end
  end),
  -- ["<Tab>"] = function(fallback)
  --   if cmp.visible() then
  --     cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
  --   else
  --     fallback()
  --   end
  -- end,
  ["<S-Tab>"] = function(fallback)
    if cmp.visible() then
      cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
    else
      fallback()
    end
  end,
})

lsp.setup_nvim_cmp({
  mapping = cmp_mappings,
  sources = {
    { name = "nvim_lsp", group_index = 2 },
    { name = "buffer", group_index = 3 },
    { name = "git", group_index = 3 },
    { name = "copilot", group_index = 2 },
  },
  experimental = {
    native_menu = false,
    ghost_text = true
  },
})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done({ map_char = { tex = "" } })
)

require('nvim-treesitter.configs').setup {
  ensure_installed = { "c", "lua", "rust", "go", "gomod", "bash", "yaml", "make" },
  highlight = {
    -- `false` will disable the whole extension
    enable = true,
  },
  indent = {
    enable = true,
    disable = { "yaml" },
  },
  auto_install = true,
  playground = {
    enabled = true,
  },
}

local parser_config = require 'nvim-treesitter.parsers'.get_parser_configs()
parser_config.gotmpl = {
  install_info = {
    url = "https://github.com/ngalaiko/tree-sitter-go-template",
    files = { "src/parser.c" }
  },
  filetype = "gotmpl",
  used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl", "yaml" }
}

local ft_to_parser = require "nvim-treesitter.parsers".filetype_to_parsername
ft_to_parser.octo = "markdown"

-- change color of yaml keys
vim.api.nvim_set_hl(0, "@yamlkey", { link = "Function" })

lsp.setup()

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = false,
  float = true,
})
