vim.api.nvim_create_autocmd({"BufNewFile","BufRead"}, {
  pattern = "*/{tasks,meta,playbooks}/*.y?ml",
  command = "setlocal filetype=yaml.ansible"
})
