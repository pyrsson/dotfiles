return {
  -- { import = "lazyvim.plugins.extras.coding.blink" },

  -- {
  --   "saghen/blink.cmp",
  --   dependencies = {
  --     -- add source
  --     { "zbirenbaum/copilot-cmp" },
  --     { "saghen/blink.compat", opts = { impersonate_nvim_cmp = true } },
  --     -- disable suggestions for the copilot source
  --     { "zbirenbaum/copilot.lua", opts = { suggestion = { enabled = false } } },
  --   },
  --   opts = {
  --     sources = {
  --       completion = {
  --         -- remember to enable your providers here
  --         enabled_providers = { "lsp", "path", "snippets", "buffer", "copilot" },
  --       },
  --
  --       providers = {
  --         -- create provider
  --         copilot = {
  --           name = "copilot", -- IMPORTANT: use the same name as you would for nvim-cmp
  --           module = "blink.compat.source",
  --
  --           -- all blink.cmp source config options work as normal:
  --           score_offset = -3,
  --
  --           opts = {
  --             -- this table is passed directly to the proxied completion source
  --             -- as the `option` field in nvim-cmp's source config
  --           },
  --         },
  --       },
  --     },
  --   },
  -- },

  {
    "zbirenbaum/copilot.lua",
    opts = {
      filetypes = {
        markdown = true,
        yaml = true,
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            cmp.select_next_item()
          elseif vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          else
            fallback()
          end
        end, { "i", "s" }),
      })

      opts.preselect = "None"

      -- comparators
      local lspkind_comparator = function(conf)
        local lsp_types = require("cmp.types").lsp
        return function(entry1, entry2)
          if entry1.source.name ~= "nvim_lsp" then
            if entry2.source.name == "nvim_lsp" then
              return false
            else
              return nil
            end
          end
          local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
          local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

          local priority1 = conf.kind_priority[kind1] or 0
          local priority2 = conf.kind_priority[kind2] or 0
          if priority1 == priority2 then
            return nil
          end
          return priority2 < priority1
        end
      end

      local label_comparator = function(entry1, entry2)
        return entry1.completion_item.label < entry2.completion_item.label
      end
      opts.sorting = {
        priority_weight = 1,
        comparators = {
          lspkind_comparator({
            kind_priority = {
              Field = 11,
              Property = 11,
              Constant = 10,
              Enum = 10,
              EnumMember = 10,
              Event = 10,
              Function = 10,
              Method = 10,
              Operator = 10,
              Reference = 10,
              Struct = 10,
              Variable = 9,
              File = 8,
              Folder = 8,
              Class = 5,
              Color = 5,
              Module = 5,
              Keyword = 2,
              Constructor = 1,
              Interface = 1,
              Snippet = 0,
              Text = 1,
              TypeParameter = 1,
              Unit = 1,
              Value = 1,
            },
          }),
          label_comparator,
        },
      }
    end,
  },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   ---@param opts cmp.ConfigSchema
  --   opts = function(_, opts)
  --     opts.preselect = "None"
  --     opts.sources[1] = {
  --       name = "codeium",
  --       group_index = 1,
  --       priority = 1,
  --       dup = 0,
  --     }
  --   end,
  -- },
}
