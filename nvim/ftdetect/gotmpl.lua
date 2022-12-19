vim.api.nvim_create_autocmd({"BufNewFile","BufRead"}, {
  pattern = "*/templates/*.y?ml",
  command = "if search('{{.\\+}}', 'nw') | setlocal filetype=gotmpl | endif"
})
