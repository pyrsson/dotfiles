-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.shiftwidth = 0
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.signcolumn = "yes"
vim.opt.autoread = true
vim.opt.cursorline = true
vim.opt.linebreak = true
vim.opt.wrap = true

vim.opt.scrolloff = 8

vim.opt.termguicolors = true

vim.opt.fillchars = {
  -- horiz     = '━',
  -- horizup   = '┻',
  -- horizdown = '┳',
  -- vert      = '┃',
  -- vertleft  = '┫',
  -- vertright = '┣',
  -- verthoriz = '╋',
  eob = " ",
}

vim.opt.timeoutlen = 700
vim.g.root_spec = { "cwd" }
vim.g.lazyvim_picker = "fzf"
vim.g.ai_cmp = false

vim.filetype.add({
  extension = {
    dtsi = "dts",
  },
})
