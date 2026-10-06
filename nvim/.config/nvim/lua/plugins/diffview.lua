-- diffview.nvim - rich side-by-side git diffs (also octo.nvim's review backend)
return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "[G]it [D]iff (working tree)" },
    {
      "<leader>gD",
      function()
        -- Diff the whole PR: current branch vs its merge-base with the
        -- remote default branch (main/master, resolved dynamically).
        local base = vim.fn.system("git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null")
        base = vim.trim(base)
        if base == "" then
          base = "origin/main"
        end
        vim.cmd("DiffviewOpen " .. base .. "...HEAD")
      end,
      desc = "[G]it [D]iff PR range (vs base)",
    },
    { "<leader>gH", "<cmd>DiffviewFileHistory %<CR>", desc = "[G]it file [H]istory" },
    { "<leader>gq", "<cmd>DiffviewClose<CR>", desc = "[G]it diffview [Q]uit" },
  },
  opts = {
    enhanced_diff_hl = true,
  },
}
