local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- general
map("n", "<Space>", "<Nop>", opts)
vim.g.mapleader = ' '

-- nav
map({'n', 't'}, '<M-Right>', '<cmd>wincmd l<CR>', opts)
map({'n', 't'}, '<M-Left>', '<cmd>wincmd h<CR>', opts)
map({'n', 't'}, '<M-Up>', '<cmd>wincmd k<CR>', opts)
map({'n', 't'}, '<M-Down>', '<cmd>wincmd j<CR>', opts)
map({'n', 't'}, '<M-w>', '<cmd>wincmd p<CR>', opts)

-- buffers
map('n', '<M-.>', ":bnext!<cr>", opts)
map('n', '<M-,>', ":bprevious!<cr>", opts)
map('n', '<M-p>', '<Cmd>b#<CR>', opts)
map('n', '<M-c>', '<Cmd>bp|bd #<CR>', opts)
map('n', '<leader>1', ':LualineBuffersJump! 1<CR>', opts)
map('n', '<leader>2', ':LualineBuffersJump! 2<CR>', opts)
map('n', '<leader>3', ':LualineBuffersJump! 3<CR>', opts)
map('n', '<leader>4', ':LualineBuffersJump! 4<CR>', opts)
map('n', '<leader>5', ':LualineBuffersJump! 5<CR>', opts)
map('n', '<leader>6', ':LualineBuffersJump! 6<CR>', opts)
map('n', '<leader>7', ':LualineBuffersJump! 7<CR>', opts)
map('n', '<leader>8', ':LualineBuffersJump! 8<CR>', opts)
map('n', '<leader>9', ':LualineBuffersJump! 9<CR>', opts)

-- telescope
local builtin = require('telescope.builtin')
map('n', '<C-F>', builtin.find_files, opts)
map('n', '<leader>fg', builtin.live_grep, opts)
map('n', '<leader>fb', builtin.buffers, opts)
map('n', '<leader>fh', builtin.help_tags, opts)

-- lazygit
map('n', '<leader>g', ':LazyGit<CR>', opts)

-- tree
map('n','<C-E>',":NvimTreeFocus<CR>",opts)

-- visual mode
map("v","<Tab>",">gv",opts)
map("v","<S-Tab>","<gv",opts)
map("v","<M-Up>",":m '<-2<CR>gv=gv", opts)
map("v","<M-Down>",":m '>+1<CR>gv=gv", opts)

-- toggleterm
map('n', '<leader>t', ":ToggleTerm<CR>", opts)

-- terminal mappings
