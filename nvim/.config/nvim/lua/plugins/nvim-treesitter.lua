-- Treesitter — main branch. The master branch is end-of-life (frozen 2026-03)
-- and crashes on nvim 0.12 (vim.treesitter get_range: "attempt to call method
-- 'range' (a nil value)"). The main branch drops the old setup({ensure_installed,
-- highlight, indent}) module API: parsers are installed explicitly (pre-installed
-- by nvim-bootstrap, not on the fly — sync-tmux-sessions opens ~40 instances at
-- once and on-the-fly installs race), and highlighting is native nvim, started
-- per-filetype only when the parser is present.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSInstall", "TSUpdate", "TSUninstall", "TSLog" },
  config = function()
    require("nvim-treesitter").setup()

    -- mdx uses the markdown parser
    vim.treesitter.language.register("markdown", "mdx")

    -- Installed parsers (cached at load; re-open nvim after installing new ones).
    local installed = {}
    for _, lang in ipairs(require("nvim-treesitter").get_installed()) do
      installed[lang] = true
    end

    -- Enable native treesitter highlighting + indentation for a buffer, but only
    -- when its parser is installed — avoids the errors a missing parser throws.
    local function ts_enable(buf)
      if not vim.api.nvim_buf_is_valid(buf) then
        return
      end
      local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
      if not lang or not installed[lang] then
        return
      end
      pcall(vim.treesitter.start, buf, lang)
      vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("ts-enable", { clear = true }),
      callback = function(args)
        ts_enable(args.buf)
      end,
    })

    -- Buffers already open before this plugin lazy-loaded (e.g. the file that
    -- triggered BufReadPost) won't get a fresh FileType event — enable them now.
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) then
        ts_enable(buf)
      end
    end
  end,
}
