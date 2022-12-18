-- general
vim.g.mapleader = ';'

-- nav
vim.keymap.set('n', '<A-Right>', '<C-W>l', {})

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
