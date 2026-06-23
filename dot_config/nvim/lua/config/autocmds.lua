-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- kcl
vim.api.nvim_command([[autocmd FileType kcl set nofoldenable]])
vim.api.nvim_command([[autocmd FileType kcl set foldmethod=syntax]])

vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "background",
  callback = function()
    if vim.o.background == "light" and vim.g.fox_theme ~= "dayfox" then
      vim.g.fox_theme = "dayfox"
      vim.cmd.colorscheme("dayfox")
    end
    if vim.o.background == "dark" and vim.g.fox_theme ~= "nightfox" then
      vim.g.fox_theme = "nightfox"
      vim.cmd.colorscheme("nightfox")
    end
  end,
})
