-- general
vim.keymap.set("n", "<Space>", "<Nop>")
vim.g.mapleader = ' '

-- nav
vim.keymap.set('n', '<leader><Right>', '<cmd>wincmd l<CR>', {})
vim.keymap.set('n', '<leader><Left>', '<cmd>wincmd h<CR>', {})
vim.keymap.set('n', '<leader><Up>', '<cmd>wincmd k<CR>', {})
vim.keymap.set('n', '<leader><Down>', '<cmd>wincmd j<CR>', {})

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-F>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- tree
vim.keymap.set('n','<C-E>',":NvimTreeFocus<CR>",{silent=true})

-- visual mode
vim.keymap.set('v','<Tab>',">gv",{silent=true})
vim.keymap.set('v','<S-Tab>',"<gv",{silent=true})

-- toggleterm
vim.keymap.set('n', '<leader>t', ":ToggleTerm<CR>", {})
