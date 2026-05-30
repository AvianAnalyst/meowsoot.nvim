local Util = require("meowsoot.util")

local M = {}

M.url = "https://github.com/MeanderingProgrammer/render-markdown.nvim"

---@type fun(c: table, opts: table): table
function M.get(c)
  -- stylua: ignore
  local ret = {
    RenderMarkdownBullet     = { fg = c.peach },
    RenderMarkdownCode       = { bg = c.bg_dark },
    RenderMarkdownDash       = { fg = c.peach },
    RenderMarkdownTableHead  = { fg = c.red },
    RenderMarkdownTableRow   = { fg = c.peach },
    RenderMarkdownCodeInline = "@markup.raw.markdown_inline",
  }
  for i, color in ipairs(c.rainbow) do
    ret["RenderMarkdownH" .. i .. "Bg"] = { bg = Util.blend(color, 0.1, c.bg_0) }
    ret["RenderMarkdownH" .. i .. "Fg"] = { fg = color, bold = true }
  end
  return ret
end

return M
