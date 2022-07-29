-- local status_ok, _ = pcall(require, "lspconfig")
-- if not status_ok then
--   vim.notify("lspconfig loading failed")
-- 	return
-- end



-- this line does this:
-- require nvim-lsp-installer
-- require lspconfig
require("user.lsp.lsp-installer")



require("user.lsp.handlers").setup()
require("user.lsp.null-ls")
