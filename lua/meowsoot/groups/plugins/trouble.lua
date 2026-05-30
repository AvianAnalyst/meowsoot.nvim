local M = {}

M.url = "https://github.com/folke/trouble.nvim"

---@type fun(c: table, opts: table): table
function M.get(c)
  -- stylua: ignore
  return {
    TroubleText   = { fg = c.fg_dark },
    TroubleCount  = { fg = c.pink, bg = c.fg_gutter },
    TroubleNormal = { fg = c.fg, bg = c.bg_sidebar },
  }
end

return M
