local M = {}

M.url = "https://github.com/echasnovski/mini.icons"

---@type fun(c: table, opts: table): table
function M.get(c)
  -- Icon names are UI category labels, not syntax — green is allowed here
  -- via the c.ok semantic alias.
  -- stylua: ignore
  return {
    MiniIconsAzure  = { fg = c.cyan },
    MiniIconsBlue   = { fg = c.blue },
    MiniIconsCyan   = { fg = c.cyan },
    MiniIconsGreen  = { fg = c.ok },
    MiniIconsGrey   = { fg = c.fg_mute },
    MiniIconsOrange = { fg = c.peach },
    MiniIconsPurple = { fg = c.lavender },
    MiniIconsRed    = { fg = c.red },
    MiniIconsYellow = { fg = c.yellow },
  }
end

return M
