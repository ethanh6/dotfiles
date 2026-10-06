-- Headless pre-install of everything nvim needs: Mason tools (LSP servers +
-- formatters) and treesitter parsers. Run via `nvim-bootstrap` (which does
-- `Lazy! sync` first); keeps the ~40 instances sync-tmux-sessions launches
-- from installing anything at startup. Idempotent. Ends by quitting.
local function log(msg)
  io.stdout:write("[nvim-bootstrap] " .. msg .. "\n")
end

-- These plugins are lazy-loaded on file events, absent in a headless no-file
-- session, so force them in before driving their install commands.
require("lazy").load({
  plugins = { "mason.nvim", "mason-tool-installer.nvim", "nvim-lspconfig", "nvim-treesitter" },
})

-- Mason: LSP servers + formatters. MasonToolsUpdateCompleted fires once every
-- configured tool has been checked/installed (even if all were present).
local mason_done = false
vim.api.nvim_create_autocmd("User", {
  pattern = "MasonToolsUpdateCompleted",
  callback = function(ev)
    local installed = (type(ev.data) == "table") and #ev.data or 0
    log("Mason tools ready (" .. installed .. " (re)installed this run)")
    mason_done = true
  end,
})
log("installing Mason tools…")
vim.cmd("MasonToolsInstall")
if not vim.wait(20 * 60 * 1000, function() return mason_done end, 500) then
  log("WARNING: Mason install timed out; run :MasonToolsInstall in nvim")
end

-- Treesitter (main branch): synchronous install of the parser list.
local ok, nts = pcall(require, "nvim-treesitter")
if ok then
  local parsers = require("treesitter-parsers")
  log("installing " .. #parsers .. " treesitter parsers…")
  nts.install(parsers):wait(20 * 60 * 1000)
  log("treesitter parsers ready")
else
  log("WARNING: nvim-treesitter not available")
end

log("done")
vim.cmd("qa!")
