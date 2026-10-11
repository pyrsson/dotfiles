vim.keymap.set("n", "<leader>r", "", { noremap = true, silent = true, buffer = true, desc = "rest" })
vim.keymap.set(
  "n",
  "<leader>rr",
  ":Rest run<cr>",
  { noremap = true, silent = true, buffer = true, desc = "Run request" }
)
