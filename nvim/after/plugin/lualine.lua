-- local nvim_tree_events = require('nvim-tree.events')

local function get_tree_size()
  return require'nvim-tree.view'.View.width
end

local function fmtcwd()
  local cwd = vim.fn.getcwd()
  if string.find(cwd, vim.env.HOME) ~= nil then
    cwd = string.gsub(cwd, vim.env.HOME,"~")
  end
  local treesize = get_tree_size()
  if string.len(cwd) < treesize then
    cwd = string.format(string.gsub("%-_._s","_", treesize-3), cwd)
  end
  return cwd
end

require('lualine').setup {
  options = {
    disabled_filetypes = {
      -- statusline = {'NvimTree', 'toggleterm'},
      winbar = {'NvimTree', 'toggleterm'},
    },
    globalstatus = true,
  },
  tabline = {
    lualine_a = {
      {
        fmtcwd,
        separator = nil,
        icon = "",
        color = "NvimTreeRootFolder",
      },
      {
        'buffers',
        show_filename_only = false,
        mode = 2,
        filetype_names = {
          NvimTree = 'Tree'
        },
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
    lualine_c = {
      {
        'filename',
        path = 1,
      }
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        'filename',
        path = 1,
      }
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  sections = {
    lualine_c = {
      {
        'filename',
        path = 1,
      }
    },
  },
  extensions = {'toggleterm', 'nvim-tree'}
}