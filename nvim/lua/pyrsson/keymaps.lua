local map = vim.keymap.set
local opts = { noremap = true, silent = true }

local function bufdel()
  local buffers = vim.api.nvim_list_bufs()
  local loaded_buffers = 0
  for _, value in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(value) and vim.api.nvim_buf_get_option(value, 'bufhidden') == '' and vim.api.nvim_buf_get_option(value, 'buflisted') == true then
      loaded_buffers = loaded_buffers + 1
    end
  end
  if loaded_buffers > 1 then
    vim.cmd.bp()
    vim.cmd.bd('#')
  else
    vim.cmd.bdelete()
  end
end

-- general
map("n", "<Space>", "<Nop>", opts)
vim.g.mapleader = ' '
vim.g.tmux_navigator_no_mappings = 1

-- nav
map({ 'n', 't' }, '<C-l>', '<cmd>TmuxNavigateRight<CR>', opts)
map({ 'n', 't' }, '<C-h>', '<cmd>TmuxNavigateLeft<CR>', opts)
map({ 'n', 't' }, '<C-k>', '<cmd>TmuxNavigateUp<CR>', opts)
map({ 'n', 't' }, '<C-j>', '<cmd>TmuxNavigateDown<CR>', opts)
map({ 'n', 't' }, '<M-Right>', '<cmd>TmuxNavigateRight<CR>', opts)
map({ 'n', 't' }, '<M-Left>', '<cmd>TmuxNavigateLeft<CR>', opts)
map({ 'n', 't' }, '<M-Up>', '<cmd>TmuxNavigateUp<CR>', opts)
map({ 'n', 't' }, '<M-Down>', '<cmd>TmuxNavigateDown<CR>', opts)
map({ 'n', 't' }, '<M-w>', '<cmd>TmuxNavigatePrevious<CR>', opts)

-- buffers
map('n', '<M-.>', ":bnext!<cr>", opts)
map('n', '<M-,>', ":bprevious!<cr>", opts)
map('n', '<M-p>', '<Cmd>b#<CR>', opts)
map('n', '<M-c>', bufdel, opts)
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
map('n', '<leader>ff', builtin.find_files, opts)
map('n', '<leader>fg', builtin.live_grep, opts)
map('n', '<leader>fb', builtin.buffers, opts)
map('n', '<leader>fh', builtin.help_tags, opts)
-- yaml_schema
map('n', '<leader>s', ':Telescope yaml_schema<CR>', opts)

-- lazygit
map('n', '<leader>g', ':LazyGit<CR>', opts)

-- tree
map('n', '<C-E>', ":NvimTreeFindFile<CR>", opts)

-- visual mode
map("v", "<Tab>", ">gv", opts)
map("v", "<S-Tab>", "<gv", opts)
map("v", "<M-Up>", ":m '<-2<CR>gv=gv", opts)
map("v", "<M-Down>", ":m '>+1<CR>gv=gv", opts)
map("v", "<leader>be", "c<c-r>=trim(system('base64',getreg('\"')))<cr><esc>", opts)
map("v", "<leader>bd", "c<c-r>=trim(system('base64 -di',getreg('\"')))<cr><esc>", opts)
map("v", "<leader>ve",
    "c<c-r>=trim(system('ansible-vault encrypt_string --vault-password-file=vault_password_file 2&> /dev/null',getreg('\"')))<cr><esc>",
    opts)
map("v", "<leader>vd",
    "c<c-r>=trim(system('grep -v \'!vault\' | tr -d \" \" | ansible-vault decrypt --vault-password-file=vault_password_file 2&> /dev/null',getreg('\"')))<cr><esc>",
    opts)

-- toggleterm
local Terminal  = require('toggleterm.terminal').Terminal
local floatterm = Terminal:new({ hidden = true, direction = "float" })

local function _floatterm_toggle()
  floatterm:toggle()
end

local function _floatterm_map()
  vim.keymap.set({"t", "n"}, "<Esc>", _floatterm_toggle, { noremap = true, silent = true, buffer = true })
end

vim.api.nvim_create_autocmd("TermOpen", {
    pattern = { "term://*toggleterm#*" },
    callback = _floatterm_map,
})

map('n', '<leader>t', _floatterm_toggle)

-- yanking
map({ 'n', 'v' }, '<leader>y', '"+y', opts)
map({ 'n', 'v' }, '<leader>Y', '"+Y', opts)
map({ 'n', 'v' }, '<leader>p', '"+p', opts)
map({ 'n', 'v' }, '<leader>P', '"+P', opts)

-- editing
map('n', '<leader>=', vim.lsp.buf.format, opts)
map({ 'n', 'v' }, ',', ';', opts)
map({ 'n', 'v' }, ';', ',', opts)
map('v', '<leader>r', '"hy:%s/<C-r>h//g<left><left>', opts)
