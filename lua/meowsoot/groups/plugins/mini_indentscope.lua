local M = {}

M.url = "https://github.com/echasnovski/mini.indentscope"

---@type fun(c: table, opts: table): table
function M.get(c)
  -- stylua: ignore
  return {
    MiniIndentscopeSymbol = { fg = c.lavender, nocombine = true },
    MiniIndentscopePrefix = { nocombine = true },
  }
end

return M
