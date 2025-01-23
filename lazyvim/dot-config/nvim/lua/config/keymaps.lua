-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- general
map("n", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.tmux_navigator_no_mappings = 1

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("n", "äd", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "öd", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "äe", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "öe", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "äw", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "öw", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- buffers
map("n", "<M-.>", ":bnext!<cr>", opts)
map("n", "<M-,>", ":bprevious!<cr>", opts)
map("n", "<leader>p", "<Cmd>b#<CR>", opts)
-- map('n', '<M-c>', bufdel, opts)

-- visual mode
map("v", "<Tab>", ">gv", opts)
map("v", "<S-Tab>", "<gv", opts)
map("v", "<M-Up>", ":m '<-2<CR>gv=gv", opts)
map("v", "<M-Down>", ":m '>+1<CR>gv=gv", opts)
map("v", "<leader>be", "c<c-r>=trim(system('base64 -w 0',getreg('\"')))<cr><esc>", opts)
map("v", "<leader>bd", "c<c-r>=trim(system('base64 -di',getreg('\"')))<cr><esc>", opts)
map(
  "v",
  "<leader>ve",
  "c<c-r>=trim(system('ansible-vault encrypt_string --vault-password-file=vault_password_file 2&> /dev/null',getreg('\"')))<cr><esc>",
  opts
)
map(
  "v",
  "<leader>vd",
  "c<c-r>=trim(system('grep -v '!vault' | tr -d \" \" | ansible-vault decrypt --vault-password-file=vault_password_file 2&> /dev/null',getreg('\"')))<cr><esc>",
  opts
)

-- yanking
map({ "n", "v" }, "<leader>y", '"+y', opts)
map({ "n", "v" }, "<leader>Y", '"+Y', opts)
-- map({ "n", "v" }, "<leader>p", '"+p', opts)
map({ "n", "v" }, "<leader>P", '"+P', opts)

-- editing
-- map('n', '<leader>=', vim.lsp.buf.format, opts)
map({ "n", "v" }, ",", ";", opts)
map({ "n", "v" }, ";", ",", opts)
map("v", "<leader>r", '"hy:%s/<C-r>h//g<left><left>', { noremap = true, silent = false })
