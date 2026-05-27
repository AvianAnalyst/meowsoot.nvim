local M = {}

M.url = "https://github.com/folke/lazy.nvim"

---@type fun(c: table, opts: table): table
function M.get(c)
  -- stylua: ignore
  return {
    LazyButton          = { bg = c.bg_2, fg = c.fg },
    LazyButtonActive    = { bg = c.bg_3, fg = c.fg, bold = true },
    LazySpecial         = { fg = c.cyan },
    LazyReasonCmd       = { fg = c.peach },
    LazyReasonEvent     = { fg = c.yellow },
    LazyReasonKeys      = { fg = c.lavender },
    LazyReasonRuntime   = { fg = c.pink },
    LazyReasonSource    = { fg = c.cyan },
    LazyReasonStart     = { fg = c.cyan },
    LazyReasonFt        = { fg = c.blue },
    LazyReasonImport    = { fg = c.fg_mute },
    LazyReasonPlugin    = { fg = c.lavender },
    LazyProgressDone    = { fg = c.ok, bold = true }, -- ok is green (UI success)
    LazyProgressTodo    = { fg = c.fg_faint, bold = true },
    LazyCommit          = { fg = c.ok },
    LazyCommitIssue     = { fg = c.pink },
    LazyCommitType      = { fg = c.peach, bold = true },
    LazyCommitScope     = { fg = c.lavender, italic = true },
    LazyValue           = { fg = c.peach },
    LazyDir             = { fg = c.fg_mute },
    LazyUrl             = { fg = c.cyan, underline = true },
    LazyTaskOutput      = { fg = c.fg },
    LazyNoCond          = { fg = c.warning },
    LazyLocal           = { fg = c.yellow },
  }
end

return M
