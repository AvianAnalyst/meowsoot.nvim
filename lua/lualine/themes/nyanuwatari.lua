-- Lualine theme. Resolved from the live nyanuwatari palette so it stays
-- in sync with the colorscheme.
--   require("lualine").setup({ options = { theme = "nyanuwatari" } })

local Palette = require("nyanuwatari.palette")
local p = Palette.resolve()

local mode_bg = {
  normal = p.pink,
  insert = p.cyan,
  visual = p.lavender,
  replace = p.red,
  command = p.yellow,
  inactive = p.bg_1,
}

local function mode(fg, bg)
  return {
    a = { fg = fg, bg = bg, gui = "bold" },
    b = { fg = p.fg, bg = p.bg_2 },
    c = { fg = p.fg_mute, bg = p.bg_1 },
  }
end

return {
  normal = mode(p.bg_0, mode_bg.normal),
  insert = mode(p.bg_0, mode_bg.insert),
  visual = mode(p.bg_0, mode_bg.visual),
  replace = mode(p.bg_0, mode_bg.replace),
  command = mode(p.bg_0, mode_bg.command),
  inactive = {
    a = { fg = p.fg_faint, bg = mode_bg.inactive },
    b = { fg = p.fg_faint, bg = mode_bg.inactive },
    c = { fg = p.fg_faint, bg = mode_bg.inactive },
  },
}
