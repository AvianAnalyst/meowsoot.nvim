local M = {}

M.url = "https://github.com/nvim-telescope/telescope.nvim"

---@type fun(c: table, opts: table): table
function M.get(c)
  -- stylua: ignore
  return {
    TelescopeBorder        = { fg = c.border_highlight, bg = c.bg_float },
    TelescopeNormal        = { fg = c.fg, bg = c.bg_float },

    TelescopePromptBorder  = { fg = c.peach, bg = c.bg_float },
    TelescopePromptTitle   = { fg = c.peach, bg = c.bg_float, bold = true },
    TelescopePromptNormal  = { fg = c.fg, bg = c.bg_float },
    TelescopePromptPrefix  = { fg = c.pink, bg = c.bg_float },

    TelescopeResultsBorder = { fg = c.border, bg = c.bg_float },
    TelescopeResultsTitle  = { fg = c.cyan, bg = c.bg_float, bold = true },
    TelescopeResultsNormal = { fg = c.fg, bg = c.bg_float },
    TelescopeResultsComment = { fg = c.fg_faint },

    TelescopePreviewBorder = { fg = c.border, bg = c.bg_float },
    TelescopePreviewTitle  = { fg = c.lavender, bg = c.bg_float, bold = true },
    TelescopePreviewNormal = { fg = c.fg, bg = c.bg_float },

    TelescopeMatching      = { fg = c.pink, bold = true },
    TelescopeSelection     = { bg = c.bg_3, bold = true },
    TelescopeSelectionCaret = { fg = c.pink, bg = c.bg_3 },
    TelescopeMultiSelection = { fg = c.peach },
    TelescopeMultiIcon     = { fg = c.peach },
  }
end

return M
