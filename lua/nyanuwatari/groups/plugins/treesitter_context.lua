local Util = require("nyanuwatari.util")

local M = {}

M.url = "https://github.com/nvim-treesitter/nvim-treesitter-context"

---@type fun(c: table, opts: table): table
function M.get(c)
  -- stylua: ignore
  return {
    TreesitterContext       = { bg = Util.blend(c.fg_faint, 0.2, c.bg_0) },
    TreesitterContextLineNumber = { fg = c.fg_faint, bg = Util.blend(c.fg_faint, 0.2, c.bg_0) },
    TreesitterContextBottom = { underline = true, sp = c.bg_4 },
  }
end

return M
