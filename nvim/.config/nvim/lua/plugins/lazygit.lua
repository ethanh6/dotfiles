-- LazyGit TUI integration
return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
  },
  init = function()
    -- Floating window size (0.0 to 1.0 = percentage of screen)
    vim.g.lazygit_floating_window_scaling_factor = 1.0
  end,
}
