vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
vim.g.undotree_WindowLayout = 3
vim.g.undotree_SetFocusWhenToggle = 1

if vim.fn.has("persistent_undo") then
  vim.opt.undofile = true
end
