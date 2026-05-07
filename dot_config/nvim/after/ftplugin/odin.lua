local snacks = require("snacks")

local function run_from_cwd()
  local root = vim.fn.getcwd()
  local cmd = "odin run " .. root
  snacks.terminal(cmd, {
    cwd = root,
    close_on_exit = true,
  })
end

vim.keymap.set("n", "<leader>r", run_from_cwd, { noremap = true, silent = true, buffer = true })
