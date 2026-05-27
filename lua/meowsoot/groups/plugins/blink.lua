local M = {}

M.url = "https://github.com/Saghen/blink.cmp"

---@type fun(c: table, opts: table): table
function M.get(c)
  -- stylua: ignore
  local ret = {
    BlinkCmpMenu                = { fg = c.fg, bg = c.bg_float },
    BlinkCmpMenuBorder          = { fg = c.border_highlight, bg = c.bg_float },
    BlinkCmpMenuSelection       = { bg = c.bg_3, bold = true },
    BlinkCmpDoc                 = { fg = c.fg, bg = c.bg_float },
    BlinkCmpDocBorder           = { fg = c.border_highlight, bg = c.bg_float },
    BlinkCmpDocSeparator        = { fg = c.border, bg = c.bg_float },
    BlinkCmpDocCursorLine       = { bg = c.bg_3 },
    BlinkCmpSignatureHelp       = { fg = c.fg, bg = c.bg_float },
    BlinkCmpSignatureHelpBorder = { fg = c.border_highlight, bg = c.bg_float },
    BlinkCmpSignatureHelpActiveParameter = { fg = c.lavender_br, bold = true },
    BlinkCmpGhostText           = { fg = c.fg_faint, italic = true },
    BlinkCmpLabel               = { fg = c.fg },
    BlinkCmpLabelDeprecated     = { fg = c.fg_faint, strikethrough = true },
    BlinkCmpLabelMatch          = { fg = c.pink, bold = true },
    BlinkCmpLabelDetail         = { fg = c.fg_faint },
    BlinkCmpLabelDescription    = { fg = c.fg_faint },
    BlinkCmpKindCodeium         = { fg = c.cyan },
    BlinkCmpKindCopilot         = { fg = c.cyan },
    BlinkCmpKindSupermaven      = { fg = c.cyan },
    BlinkCmpKindTabNine         = { fg = c.cyan },
    BlinkCmpKindDefault         = { fg = c.fg_mute },
    BlinkCmpSource              = { fg = c.fg_faint },
  }

  require("meowsoot.groups.kinds").kinds(ret, "BlinkCmpKind%s")
  return ret
end

return M
