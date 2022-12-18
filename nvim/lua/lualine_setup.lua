require('lualine').setup {
  options = {
    disabled_filetypes = {
      statusline = {'NvimTree'},
      winbar = {'NvimTree'},
    },
    ignore_focus = {'NvimTree'},
    globalstatus = true,
  },
  -- tabline = {
  --   lualine_a = {'buffers'},
  --   lualine_b = {},
  --   lualine_c = {},
  --   lualine_x = {},
  --   lualine_y = {},
  --   lualine_z = {'tabs'}
  -- },
  winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  extensions = {'nvim-tree'}
}
