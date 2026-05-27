local M = {}

M.url = "https://github.com/hrsh7th/nvim-cmp"

---@type fun(c: table, opts: table): table
function M.get(c)
  -- stylua: ignore
  local ret = {
    CmpDocumentation       = { fg = c.fg, bg = c.bg_float },
    CmpDocumentationBorder = { fg = c.border_highlight, bg = c.bg_float },
    CmpGhostText           = { fg = c.fg_faint, italic = true },
    CmpItemAbbr            = { fg = c.fg },
    CmpItemAbbrDeprecated  = { fg = c.fg_faint, strikethrough = true },
    CmpItemAbbrMatch       = { fg = c.pink, bold = true },
    CmpItemAbbrMatchFuzzy  = { fg = c.pink, bold = true },
    CmpItemKindCodeium     = { fg = c.cyan },
    CmpItemKindCopilot     = { fg = c.cyan },
    CmpItemKindSupermaven  = { fg = c.cyan },
    CmpItemKindTabNine     = { fg = c.cyan },
    CmpItemKindDefault     = { fg = c.fg_mute },
    CmpItemMenu            = { fg = c.fg_faint },
  }

  require("meowsoot.groups.kinds").kinds(ret, "CmpItemKind%s")
  return ret
end

return M
