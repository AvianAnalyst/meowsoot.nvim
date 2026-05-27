local M = {}

M.url = "https://github.com/lewis6991/gitsigns.nvim"

---@type fun(c: table, opts: table): table
function M.get(c)
  -- stylua: ignore
  return {
    GitSignsAdd      = { fg = c.git.add },
    GitSignsChange   = { fg = c.git.change },
    GitSignsDelete   = { fg = c.git.delete },
    GitSignsAddNr    = { fg = c.git.add },
    GitSignsChangeNr = { fg = c.git.change },
    GitSignsDeleteNr = { fg = c.git.delete },
    GitSignsAddLn    = { bg = c.diff.add },
    GitSignsChangeLn = { bg = c.diff.change },
    GitSignsDeleteLn = { bg = c.diff.delete },

    GitSignsCurrentLineBlame = { fg = c.fg_faint, italic = true },
    GitSignsAddInline        = { bg = c.diff.add,    fg = c.git.add },
    GitSignsChangeInline     = { bg = c.diff.change, fg = c.git.change },
    GitSignsDeleteInline     = { bg = c.diff.delete, fg = c.git.delete },
  }
end

return M
