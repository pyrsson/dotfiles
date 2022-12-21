-- local nvim_tree_events = require('nvim-tree.events')

local function get_tree_size()
  return require'nvim-tree.view'.View.width
end

function Fmtcwd()
  local cwd = vim.fn.getcwd()
  if string.find(cwd, vim.env.HOME) ~= nil then
    cwd = string.gsub(cwd, vim.env.HOME,"~")
  end
  local treesize = get_tree_size()
  if string.len(cwd) < treesize then
    cwd = string.format(string.gsub("%-_._s","_", treesize-4), cwd)
  end
  return cwd
end

require('lualine').setup {
  options = {
    disabled_filetypes = {
      statusline = {'NvimTree'},
      winbar = {'NvimTree'},
    },
    ignore_focus = {'NvimTree'},
    globalstatus = true,
  },
  tabline = {
    lualine_a = {
      {
        "Fmtcwd()",
        separator = nil,
        icon = "",
        color = "NvimTreeRootFolder",
      },
      {
        'buffers',
        mode = 2
      }
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {'tabs'}
  },
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
  extensions = {'nvim-tree', 'toggleterm'}
}
