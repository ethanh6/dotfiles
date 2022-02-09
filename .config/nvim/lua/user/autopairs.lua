local status_ok, npairs = pcall(require, "nvim-autopairs")
if not status_ok then
  vim.notify("Nvim-autopairs not working")
  return
end

npairs.setup {
  disable_filetype = { "TelescopePrompt" },
  check_ts = true,
  fast_wrap = {
      map = '<M-e>',
      chars = { '{', '[', '(', '"', "'" },
      pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
      offset = 0, -- Offset from pattern match
      end_key = '$',
      keys = 'qwertyuiopzxcvbnmasdfghjkl',
      check_comma = true,
      highlight = 'Search',
      highlight_grey='Comment'
    },
}

-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
