-- [[ Basic Keymaps ]]
-- See `:help vim.keymap.set()`

-- Quick source comfig
vim.keymap.set("n", "<leader>rr", "<cmd>source $MYVIMRC<CR>")

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc><Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Code keymaps (non-LSP diagnostics)
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "[C]ode [D]iagnostic (float)" })
vim.keymap.set("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "[C]ode diagnostics to [Q]uickfix" })

-- Git keymaps
vim.keymap.set("n", "<leader>gm", function()
  local files = vim.fn.systemlist("git status --porcelain | cut -c4-")
  if vim.v.shell_error ~= 0 then
    vim.notify("Not a git repository or git error", vim.log.levels.ERROR)
    return
  end
  -- Filter out empty strings
  files = vim.tbl_filter(function(f)
    return f ~= ""
  end, files)
  if #files == 0 then
    vim.notify("No modified files", vim.log.levels.INFO)
    return
  end
  vim.cmd("args " .. table.concat(vim.tbl_map(vim.fn.fnameescape, files), " "))
  vim.notify("Loaded " .. #files .. " modified file(s)", vim.log.levels.INFO)
end, { desc = "[G]it [M]odified files open" })

-- Exit terminal mode in the builtin terminal with a shortcut
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
-- vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Buffer navigation
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>ww", "<cmd>bd<CR>", { desc = "Close current buffer" })

-- Close all buffers except current
-- vim.keymap.set("n", "<leader>bd", function()
--   local current_buf = vim.api.nvim_get_current_buf()
--   local buffers = vim.api.nvim_list_bufs()
--
--   for _, buf in ipairs(buffers) do
--     -- Skip current buffer and special buffers
--     if buf ~= current_buf and vim.api.nvim_buf_is_valid(buf) then
--       local buf_type = vim.bo[buf].buftype
--
--       -- Don't close terminals, help buffers, or other special buffers
--       -- Also don't force-close unsaved buffers
--       if buf_type ~= "terminal" and buf_type ~= "nofile" and buf_type ~= "help" then
--         pcall(vim.api.nvim_buf_delete, buf, { force = false })
--       end
--     end
--   end
-- end, { desc = "Close all buffers except current" })

-- Theme toggle
vim.keymap.set("n", "<leader>aa", function()
  local current_theme = vim.g.colors_name
  local new_theme
  if current_theme == "catppuccin" or current_theme == "catppuccin-mocha" then
    new_theme = "catppuccin-latte"
  else
    new_theme = "catppuccin"
  end
  vim.cmd("colorscheme " .. new_theme)
  vim.notify("Theme: " .. new_theme, vim.log.levels.INFO)
end, { desc = "Toggle between light/dark theme" })

-- Better indenting
vim.keymap.set("n", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("n", ">", ">gv", { desc = "Indent right and reselect" })

-- Move lines up and down
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move lines up" })

-- [[ Basic Autocommands ]]
-- See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
-- Try it with `yap` in normal mode
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
