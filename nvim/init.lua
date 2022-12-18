-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('plugin_setup')
require('lsp_setup')
require('tree_setup')
require('telescope_setup')
require('lualine_setup')
require('barbar_setup')
require('keymaps')
require('theme')

-- behaviour
vim.opt.shiftwidth = 0
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.relativenumber = true
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.api.nvim_create_augroup("terminal",{clear = false})

vim.api.nvim_create_autocmd("TermOpen", {
  group = "terminal",
  pattern = "*",
  command = ":tnoremap <buffer> <Esc> <c-\\><c-n><CR>"
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = "terminal",
  pattern = "*",
  command = "startinsert"
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = "terminal",
  pattern = "*",
  command = "setlocal listchars= nonumber norelativenumber"
})
