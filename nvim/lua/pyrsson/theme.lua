vim.g.material_style = "darker"
local colors = require("material.colors")
require('material').setup({
  contrast = {
    terminal = false, -- Enable contrast for the built-in terminal
    sidebars = true, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
    floating_windows = true, -- Enable contrast for floating windows
    cursor_line = false, -- Enable darker background for the cursor line
    non_current_windows = false, -- Enable darker background for non-current windows
    filetypes = {}, -- Specify which filetypes get the contrasted (darker) background
  },
  styles = { -- Give comments style such as bold, italic, underline etc.
    comments = { --[[ italic = true  ]] },
    strings = { --[[ bold = true ]] },
    keywords = { --[[ underline = true ]] },
    functions = { --[[ bold = true, undercurl = true ]] },
    variables = {},
    operators = {},
    types = {},
  },
  plugins = { -- Uncomment the plugins that you use to highlight them
    -- Available plugins:
    -- "dap",
    -- "dashboard",
    "gitsigns",
    -- "hop",
    "indent-blankline",
    -- "lspsaga",
    -- "mini",
    -- "neogit",
    "nvim-cmp",
    -- "nvim-navic",
    "nvim-tree",
    "nvim-web-devicons",
    -- "sneak",
    "telescope",
    -- "trouble",
    -- "which-key",
  },
  disable = {
    colored_cursor = true, -- Disable the colored cursor
    borders = false, -- Disable borders between verticaly split windows
    background = false, -- Prevent the theme from setting the background (NeoVim then uses your terminal background)
    term_colors = false, -- Prevent the theme from setting terminal colors
    eob_lines = true -- Hide the end-of-buffer lines
  },
  high_visibility = {
    lighter = false, -- Enable higher contrast text for lighter style
    darker = false -- Enable higher contrast text for darker style
  },
  lualine_style = "default", -- Lualine style ( can be 'stealth' or 'default' )
  async_loading = true, -- Load parts of the theme asyncronously for faster startup (turned on by default)
  -- custom_colors = function(colors)
  --   -- colors.editor.fg_dark = colors.editor.fg
  --   -- colors.editor.accent = "#71C6E7"
  --   -- colors.main.purple = "#SOME_COLOR"
  --   -- colors.lsp.error = "#SOME_COLOR"
  -- end,
  custom_highlights = {
    NvimTreeFolderName = { fg = colors.editor.fg, --[[ bold = true ]] },
    NvimTreeFolderIcon = { fg = colors.main.blue },
    NvimTreeOpenedFolderName = { link = "NvimTreeFolderName" },
    WinSeparator = { bg = "#1A1A1A", fg = "#1A1A1A" },
    NvimTreeExecFile = { fg = colors.editor.fg },
    NvimTreeFileStaged = { fg = colors.main.darkgreen },
    NvimTreeWindowPicker = { link = "lualine_a_normal" },
  },
})

vim.cmd "colorscheme material"
