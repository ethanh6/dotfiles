-- [[ Autocommands ]]
-- See `:help lua-guide-autocommands`

-- YAML folding configuration using Treesitter
vim.api.nvim_create_autocmd("FileType", {
  pattern = "yaml",
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt_local.foldenable = false -- Start with folds open
  end,
  desc = "Enable Treesitter-based folding for YAML files",
})

-- Auto-resize splits when terminal is resized
vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
  desc = "Auto-resize panes when resizing nvim window",
})
