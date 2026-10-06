-- octo.nvim - review GitHub PRs/issues in Neovim via the `gh` CLI.
-- Needs an authenticated gh (`gh auth login`); shares the same auth as the
-- rest of the worktree/PR tooling. Uses diffview.nvim as its review backend.
return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
    "sindrets/diffview.nvim",
  },
  keys = {
    { "<leader>O", "<cmd>Octo pr list<CR>", desc = "[O]cto: PR list" },
    { "<leader>Os", "<cmd>Octo search is:pr is:open author:@me<CR>", desc = "[O]cto: my open PRs" },
    { "<leader>Or", "<cmd>Octo review start<CR>", desc = "[O]cto: start review" },
    { "<leader>Oc", "<cmd>Octo pr checks<CR>", desc = "[O]cto: PR checks (CI)" },
    { "<leader>Oo", "<cmd>Octo pr browser<CR>", desc = "[O]cto: open in browser" },
  },
  opts = {
    picker = "telescope", -- reuse the existing telescope setup
    suppress_missing_scope = {
      projects_v2 = true, -- don't warn when the gh token lacks the projects scope
    },
  },
}
