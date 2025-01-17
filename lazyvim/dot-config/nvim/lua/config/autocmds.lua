-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- kcl
vim.api.nvim_command([[autocmd FileType kcl set nofoldenable]])
vim.api.nvim_command([[autocmd FileType kcl set foldmethod=syntax]])
