local M = {}

M.url = "https://github.com/folke/flash.nvim"

---@type fun(c: table, opts: table): table
function M.get(c)
  -- stylua: ignore
  return {
    FlashBackdrop = { fg = c.fg_faint },
    FlashLabel    = { bg = c.pink, fg = c.bg_0, bold = true },
    FlashMatch    = { bg = c.bg_search, fg = c.fg },
    FlashCurrent  = { bg = c.peach, fg = c.bg_0, bold = true },
    FlashPrompt        = { fg = c.fg, bg = c.bg_float },
    FlashPromptIcon    = { fg = c.pink },
    FlashCursor        = { reverse = true },
  }
end

return M
