-- nyanuwatari palette.
-- Authored in HSL for ergonomic tuning on the color wheel:
--   { hue 0-360, saturation 0-100, lightness 0-100 }
-- Resolved to hex once at theme load via lua/nyanuwatari/hsl.lua.
--
-- Accent tiering (8-point lightness spread):
--   ANCHOR   L=78 — structural anchors (functions, types, headings)
--   STANDARD L=74 — frequent but communicative (keywords, constants)
--   QUIET    L=70 — highest-frequency tokens (strings, numbers)
--   BRIGHT   L=85 — rare emphasis only

local hsl = require("nyanuwatari.hsl")

local M = {}

-- stylua: ignore
local hsl_palette = {
  -- Neutrals
  bg_deep  = {   0,  3,  6 }, -- darkest panel
  bg_0     = {   0,  2,  9 }, -- editor background
  bg_1     = {  40,  5, 12 }, -- panel
  bg_2     = {  20,  4, 15 }, -- active line
  bg_3     = {  30,  4, 20 }, -- selection
  bg_4     = {  24,  4, 26 }, -- border

  fg       = {  20,  5, 88 },
  fg_mute  = {  30,  5, 68 }, -- comments
  fg_faint = {  33,  4, 50 }, -- gutter, punctuation, operators

  -- Accents · ANCHOR (L=78)
  pink     = { 328, 62, 78 }, -- functions, methods, headings
  lavender = { 275, 58, 78 }, -- types, classes, modules

  -- Accents · STANDARD (L=74)
  cyan     = { 189, 58, 74 }, -- keywords, imports, tags, builtins
  peach    = {  20, 58, 74 }, -- constants, booleans
  blue     = { 208, 53, 73 }, -- ANSI slot 4/12, diff-change, info

  -- Accents · QUIET (L=70)
  yellow    = {  51, 58, 70 }, -- strings, regex
  peach_dim = {  20, 58, 70 }, -- numbers, floats

  -- Accents · BRIGHT (L=85) — rare emphasis
  cyan_br     = { 190, 55, 85 },
  lavender_br = { 274, 55, 85 },
  pink_br     = { 329, 55, 85 },
  peach_br    = {  20, 55, 85 },
  yellow_br   = {  50, 55, 85 },

  -- Reserved — UI/diff/git/success only. NEVER referenced from syntax groups
  -- (see lua/nyanuwatari/colors.lua semantic-alias chokepoint).
  green = { 140, 35, 70 },
  red   = {   0, 65, 75 },
}

---Resolve all HSL entries to hex strings.
---@return table<string,string>
function M.resolve()
  local out = {}
  for name, triplet in pairs(hsl_palette) do
    out[name] = hsl.to_hex(triplet)
  end
  out.none = "NONE"
  return out
end

M.hsl = hsl_palette

return M
