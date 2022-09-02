-- vim.cmd [[colorscheme default]]
-- vim.cmd[[colorscheme gruvbox]]


-- local colorscheme = "tokyonight"
--[[ local colorscheme = "gruvbox" ]]
--[[ local colorscheme = "nightfox" ]]
local colorscheme = "dracula"

-- protected call
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
