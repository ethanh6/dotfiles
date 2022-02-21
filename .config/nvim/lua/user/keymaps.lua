-- keymap options
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- Remap space as leader
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "   
-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",


-- Normal Mode --

-- toggole Comment
keymap("n", "<C-c>", ":CommentToggle<CR>", opts)

-- toggole search highlight
keymap("n", "<esc><esc>", ":set hlsearch!<CR>", opts)

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- File Explorer Toggle
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- Open command history
keymap("n", "<leader>ch", "q:", opts)
keymap("n", "q:", "<nop>", opts)

-- Copy(yank) until the end of the line
keymap("n", "Y", "y$", opts)

-- Enter Visual-Block-Mode (ctrl-v is for pasting in WSL)
keymap("n", "<leader>v", "<C-v>", opts)

-- Easy edit and source vimrc (for Neovim, it's ~/.config/nvim/init.lua)
-- keymap("n", "<leader>ev", ":vsplit $MYVIMRC<CR>", opts)
-- keymap("n", "<leader>sv", ":source $MYVIMRC<CR>", opts)

-- Resize with arrows (this might be little off due to different buffer position)
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize -2<CR>", opts)

-- Navigate between buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Insert Mode --

-- Visual Mode --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block Mode --
-- Move visual box up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal Mode --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- open python terminal
keymap("t", "<leader>P", ":lua _PYTHON_TOGGLE()<CR> ", term_opts)


-- TODO
-- Enter recording mode: type <leader>qq, and then the register (a~z)
-- keymap("n", "<leader>qq", "q", opts)
-- Exit recording mode (default: <C-O>q)
-- keymap("n", "", "", opts)




