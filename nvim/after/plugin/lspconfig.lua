local lsp = require('lsp-zero')
local cfg = require("yaml-companion").setup({
  schemas = {
    result = {
      {
       name = "Kubernetes 1.23.6",
       uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.23.6-standalone-strict/all.json",
      },
    },
  },

})
local cmp = require 'cmp'
-- toggle comment plugin
require('Comment').setup()
require('gitsigns').setup()
require("neodev").setup({})

lsp.preset('recommended')

lsp.set_preferences({
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I'
  }
})

lsp.ensure_installed({
  "sumneko_lua",
  "rust_analyzer",
  "gopls",
  "bashls",
  "yamlls",
  "tsserver",
  "eslint"
})

lsp.configure("yamlls", cfg)
lsp.configure('sumneko_lua', {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      },
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
})

local cmp_mappings = lsp.defaults.cmp_mappings({
  ["<C-Space>"] = cmp.mapping.complete(),
})
lsp.setup_nvim_cmp({
  mapping = cmp_mappings,
  sources = {
    { name = "nvim_lsp", group_index = 1 },
    { name = "buffer", group_index = 2 },
  },
})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

require('nvim-treesitter.configs').setup {
  ensure_installed = { "c", "lua", "rust", "go", "gomod", "bash", "yaml", "make" },
  highlight = {
    -- `false` will disable the whole extension
    enable = true,
  },
  indent = {
    enable = true,
  },
  auto_install = true,
  playground = {
    enabled = true,
  },
}

local parser_config = require'nvim-treesitter.parsers'.get_parser_configs()
parser_config.gotmpl = {
  install_info = {
    url = "https://github.com/ngalaiko/tree-sitter-go-template",
    files = {"src/parser.c"}
  },
  filetype = "gotmpl",
  used_by = {"gohtmltmpl", "gotexttmpl", "gotmpl", "yaml"}
}

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
