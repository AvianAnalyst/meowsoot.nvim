-- Base highlights: editor UI, diagnostics, classic Syntax/* groups, diff/git UI.
-- No-green-in-code policy: green is only legal in the explicit "Diff/Git UI"
-- section (and DiagnosticOk). Everything else uses pink/cyan/peach/yellow.

local M = {}

---@type fun(c: table, opts: table): table
function M.get(c, opts)
  local styles = opts.styles or {}
  -- stylua: ignore
  return {
    -- ============================================================
    -- Editor UI
    -- ============================================================
    Normal       = { fg = c.fg,        bg = c.bg },
    NormalFloat  = { fg = c.fg,        bg = c.bg_float },
    NormalNC     = "Normal",
    NormalSB     = { fg = c.fg,        bg = c.bg_sidebar },
    FloatBorder  = { fg = c.border_highlight, bg = c.bg_float },
    FloatTitle   = { fg = c.pink,      bg = c.bg_float, bold = true },

    Cursor       = { fg = c.bg_0,      bg = c.pink },
    lCursor      = "Cursor",
    CursorIM     = "Cursor",
    TermCursor   = "Cursor",
    TermCursorNC = { fg = c.bg_0,      bg = c.fg_faint },

    CursorLine   = { bg = c.bg_highlight },
    CursorColumn = "CursorLine",
    ColorColumn  = { bg = c.bg_1 },

    LineNr       = { fg = c.fg_gutter },
    LineNrAbove  = "LineNr",
    LineNrBelow  = "LineNr",
    CursorLineNr = { fg = c.fg,        bold = true },
    SignColumn   = { fg = c.fg_gutter, bg = opts.transparent and c.none or c.bg },
    SignColumnSB = { fg = c.fg_gutter, bg = c.bg_sidebar },
    FoldColumn   = { fg = c.fg_gutter, bg = opts.transparent and c.none or c.bg },
    Folded       = { fg = c.fg_mute,   bg = c.bg_1 },

    Visual       = { bg = c.bg_visual },
    VisualNOS    = "Visual",
    Search       = { fg = c.fg,        bg = c.bg_search },
    IncSearch    = { fg = c.bg_0,      bg = c.peach },
    CurSearch    = "IncSearch",
    Substitute   = { fg = c.bg_0,      bg = c.peach },
    MatchParen   = { fg = c.lavender,  bg = c.bg_3, bold = true },

    StatusLine   = { fg = c.fg,        bg = c.bg_statusline },
    StatusLineNC = { fg = c.fg_faint,  bg = c.bg_statusline_nc },
    WinSeparator = { fg = c.border,    bold = true },
    VertSplit    = "WinSeparator",
    WinBar       = "StatusLine",
    WinBarNC     = "StatusLineNC",
    TabLine      = { fg = c.fg_faint,  bg = c.bg_tab_line },
    TabLineFill  = { bg = c.bg_tab_line },
    TabLineSel   = { fg = c.fg,        bg = c.bg_0, bold = true },

    Pmenu        = { fg = c.fg,        bg = c.bg_popup },
    PmenuMatch   = { fg = c.pink,      bg = c.bg_popup, bold = true },
    PmenuSel     = { fg = c.fg,        bg = c.bg_3, bold = true },
    PmenuMatchSel = { fg = c.pink,     bg = c.bg_3, bold = true },
    PmenuSbar    = { bg = c.bg_2 },
    PmenuThumb   = { bg = c.bg_4 },
    WildMenu     = "PmenuSel",

    ModeMsg      = { fg = c.fg,        bold = true },
    MoreMsg      = { fg = c.cyan },
    Question     = { fg = c.cyan },
    ErrorMsg     = { fg = c.error,     bold = true },
    WarningMsg   = { fg = c.warning },
    MsgArea      = { fg = c.fg },
    MsgSeparator = { fg = c.bg_3,      bg = c.bg_0 },

    NonText      = { fg = c.bg_4 },
    SpecialKey   = { fg = c.bg_4 },
    Whitespace   = { fg = c.bg_3 },
    EndOfBuffer  = { fg = c.bg },

    Conceal      = { fg = c.fg_mute },
    Directory    = { fg = c.cyan },
    Title        = { fg = c.pink,      bold = true },

    QuickFixLine = { bg = c.bg_visual, bold = true },

    -- Spell
    SpellBad     = { sp = c.error,     undercurl = true },
    SpellCap     = { sp = c.warning,   undercurl = true },
    SpellLocal   = { sp = c.info,      undercurl = true },
    SpellRare    = { sp = c.hint,      undercurl = true },

    -- ============================================================
    -- Diff / Git UI (GREEN ALLOWED HERE — UI state, not syntax)
    -- ============================================================
    DiffAdd      = { bg = c.diff.add },
    DiffChange   = { bg = c.diff.change },
    DiffDelete   = { bg = c.diff.delete },
    DiffText     = { bg = c.diff.text, fg = c.fg, bold = true },

    Added        = { fg = c.git.add },
    Changed      = { fg = c.git.change },
    Removed      = { fg = c.git.delete },

    diffAdded    = { fg = c.git.add },
    diffChanged  = { fg = c.git.change },
    diffRemoved  = { fg = c.git.delete },
    diffOldFile  = { fg = c.git.delete },
    diffNewFile  = { fg = c.git.add },
    diffFile     = { fg = c.blue },
    diffLine     = { fg = c.fg_mute },
    diffIndexLine = { fg = c.lavender },

    -- Health
    healthError   = { fg = c.error },
    healthSuccess = { fg = c.ok },
    healthWarning = { fg = c.warning },

    -- ============================================================
    -- Diagnostics
    -- ============================================================
    DiagnosticError              = { fg = c.error },
    DiagnosticWarn               = { fg = c.warning },
    DiagnosticInfo               = { fg = c.info },
    DiagnosticHint               = { fg = c.hint }, -- cyan, NOT green
    DiagnosticOk                 = { fg = c.ok },
    DiagnosticUnnecessary        = { fg = c.fg_faint },
    DiagnosticDeprecated         = { fg = c.fg_mute, strikethrough = true },

    DiagnosticVirtualTextError   = { fg = c.error,   bg = c.bg_1 },
    DiagnosticVirtualTextWarn    = { fg = c.warning, bg = c.bg_1 },
    DiagnosticVirtualTextInfo    = { fg = c.info,    bg = c.bg_1 },
    DiagnosticVirtualTextHint    = { fg = c.hint,    bg = c.bg_1 },
    DiagnosticVirtualTextOk      = { fg = c.ok,      bg = c.bg_1 },

    DiagnosticUnderlineError     = { sp = c.error,   undercurl = true },
    DiagnosticUnderlineWarn      = { sp = c.warning, undercurl = true },
    DiagnosticUnderlineInfo      = { sp = c.info,    undercurl = true },
    DiagnosticUnderlineHint      = { sp = c.hint,    undercurl = true },
    DiagnosticUnderlineOk        = { sp = c.ok,      undercurl = true },

    DiagnosticSignError          = "DiagnosticError",
    DiagnosticSignWarn           = "DiagnosticWarn",
    DiagnosticSignInfo           = "DiagnosticInfo",
    DiagnosticSignHint           = "DiagnosticHint",
    DiagnosticSignOk             = "DiagnosticOk",

    DiagnosticFloatingError      = "DiagnosticError",
    DiagnosticFloatingWarn       = "DiagnosticWarn",
    DiagnosticFloatingInfo       = "DiagnosticInfo",
    DiagnosticFloatingHint       = "DiagnosticHint",
    DiagnosticFloatingOk         = "DiagnosticOk",

    -- LSP
    LspReferenceText             = { bg = c.bg_3 },
    LspReferenceRead             = "LspReferenceText",
    LspReferenceWrite            = "LspReferenceText",
    LspSignatureActiveParameter  = { fg = c.lavender_br, italic = true, bold = true },
    LspInlayHint                 = { fg = c.fg_faint, bg = c.bg_1, italic = true },
    LspCodeLens                  = { fg = c.fg_mute },
    LspInfoBorder                = { fg = c.border_highlight, bg = c.bg_float },

    -- ============================================================
    -- Classic syntax groups (vim builtin)
    -- ============================================================
    Comment      = { fg = c.comment,   style = styles.comments },

    Constant     = { fg = c.peach },
    String       = { fg = c.yellow },
    Character    = { fg = c.yellow },
    Number       = { fg = c.peach_dim },
    Boolean      = { fg = c.peach },
    Float        = { fg = c.peach_dim },

    Identifier   = { fg = c.fg,        style = styles.variables },
    Function     = { fg = c.pink,      style = styles.functions },

    Statement    = { fg = c.cyan },
    Conditional  = { fg = c.cyan },
    Repeat       = { fg = c.cyan },
    Label        = { fg = c.cyan },
    Operator     = { fg = c.fg_faint },
    Keyword      = { fg = c.cyan,      style = styles.keywords },
    Exception    = { fg = c.cyan },

    PreProc      = { fg = c.cyan },
    Include      = { fg = c.cyan },
    Define       = { fg = c.cyan },
    Macro        = { fg = c.peach },
    PreCondit    = { fg = c.cyan },

    Type         = { fg = c.lavender },
    StorageClass = { fg = c.cyan },
    Structure    = { fg = c.lavender },
    Typedef      = { fg = c.lavender },

    Special      = { fg = c.peach },
    SpecialChar  = { fg = c.peach }, -- was green, now peach (no-green-in-code)
    Tag          = { fg = c.cyan },
    Delimiter    = { fg = c.fg_faint },
    SpecialComment = { fg = c.fg_mute, italic = true, bold = true },
    Debug        = { fg = c.peach },

    Underlined   = { underline = true },
    Bold         = { bold = true, fg = c.fg },
    Italic       = { italic = true, fg = c.fg },

    Ignore       = { fg = c.fg_faint },
    Error        = { fg = c.error,     underline = true },
    Todo         = { fg = c.todo,      bg = c.bg_2, italic = true, bold = true },
  }
end

return M
