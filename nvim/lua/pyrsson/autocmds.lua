-- terminal
vim.api.nvim_create_augroup("Terminal", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
  group = "Terminal",
  pattern = {"term://*zsh*"},
  command = "tnoremap <buffer> <Esc> <c-\\><c-n>"
})
vim.api.nvim_create_autocmd("TermOpen", {
  group = "Terminal",
  pattern = {"term://*zsh*"},
  command = "setlocal listchars= nonumber norelativenumber nocursorline nobuflisted"
})
vim.api.nvim_create_autocmd("BufEnter", {
  group = "Terminal",
  pattern = {"term://*zsh*", "*toggleterm*"},
  command = "startinsert"
})
vim.api.nvim_create_autocmd("TermClose", {
  group = "Terminal",
  pattern = {"term://*zsh*"},
  command = "bd"
})

