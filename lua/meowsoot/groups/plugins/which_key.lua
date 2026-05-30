local M = {}

M.url = "https://github.com/folke/which-key.nvim"

---@type fun(c: table, opts: table): table
function M.get(c)
  -- stylua: ignore
  return {
    WhichKey          = { fg = c.cyan },
    WhichKeyGroup     = { fg = c.blue },
    WhichKeyDesc      = { fg = c.pink },
    WhichKeySeparator = { fg = c.comment },
    WhichKeyNormal    = { bg = c.bg_sidebar },
    WhichKeyValue     = { fg = c.fg_faint },
  }
end

return M
