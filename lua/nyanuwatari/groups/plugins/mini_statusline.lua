local M = {}

M.url = "https://github.com/echasnovski/mini.statusline"

---@type fun(c: table, opts: table): table
function M.get(c)
  -- stylua: ignore
  return {
    MiniStatuslineDevinfo     = { fg = c.fg_mute, bg = c.bg_2 },
    MiniStatuslineFileinfo    = { fg = c.fg_mute, bg = c.bg_2 },
    MiniStatuslineFilename    = { fg = c.fg_mute, bg = c.bg_highlight },
    MiniStatuslineInactive    = { fg = c.fg_faint, bg = c.bg_statusline },
    MiniStatuslineModeNormal  = { fg = c.bg_0, bg = c.pink, bold = true },
    MiniStatuslineModeInsert  = { fg = c.bg_0, bg = c.cyan, bold = true },
    MiniStatuslineModeVisual  = { fg = c.bg_0, bg = c.lavender, bold = true },
    MiniStatuslineModeReplace = { fg = c.bg_0, bg = c.red, bold = true },
    MiniStatuslineModeCommand = { fg = c.bg_0, bg = c.yellow, bold = true },
    MiniStatuslineModeOther   = { fg = c.bg_0, bg = c.peach, bold = true },
  }
end

return M
