-- Generates static/palette.svg from the live palette.
--
-- Layout is deliberately hierarchical: the NIGHT section gets the full
-- breakdown (chromatic accents + neutrals tier on its own bg_0), while the
-- DAWN section is a single condensed accent strip on dawn's bg_0. The
-- difference in surface area communicates "primary + complementary" without
-- needing prose.
--
-- Each section renders ON its own editor background, so what you see in the
-- swatch is what you'd see in the editor — no off-brand container chrome.

local Palette = require("meowsoot.palette")

local M = {}

-- Outer canvas
local W = 880
local PAD_X = 32

-- Render a single swatch: colored rect + name + hex label underneath.
local function swatch(x, y, w, h, fg_text, fg_muted, name, hex)
  return string.format(
    '<g transform="translate(%d %d)">'
      .. '<rect width="%d" height="%d" rx="6" fill="%s"/>'
      .. '<text x="0" y="%d" font-family="ui-sans-serif,system-ui,sans-serif" font-size="11" font-weight="600" fill="%s">%s</text>'
      .. '<text x="0" y="%d" font-family="ui-monospace,SFMono-Regular,Menlo,Consolas,monospace" font-size="10" fill="%s">%s</text>'
      .. "</g>",
    x,
    y,
    w,
    h,
    hex,
    h + 16,
    fg_text,
    name,
    h + 30,
    fg_muted,
    hex
  )
end

local function section(opts)
  local parts = {}
  local y = opts.y

  -- Section background — the variant's own editor bg.
  table.insert(
    parts,
    string.format(
      '<rect x="0" y="%d" width="%d" height="%d" fill="%s"/>',
      y,
      W,
      opts.height,
      opts.bg
    )
  )

  -- Section title (monospaced; reads like a section header in code).
  table.insert(
    parts,
    string.format(
      '<text x="%d" y="%d" font-family="ui-monospace,SFMono-Regular,Menlo,Consolas,monospace" font-size="13" font-weight="700" fill="%s" letter-spacing="2">%s</text>',
      PAD_X,
      y + 28,
      opts.fg,
      opts.label
    )
  )

  -- Accent row
  local inner_w = W - 2 * PAD_X
  local n = #opts.accents
  local sw_w = math.floor((inner_w - (n - 1) * 6) / n)
  local sw_h = opts.accent_height or 64
  local ax = PAD_X
  local ay = y + 50
  for _, entry in ipairs(opts.accents) do
    table.insert(parts, swatch(ax, ay, sw_w, sw_h, opts.fg, opts.fg_muted, entry.name, entry.hex))
    ax = ax + sw_w + 6
  end

  -- Neutrals row (night only)
  if opts.neutrals then
    local m = #opts.neutrals
    local nw_w = math.floor((inner_w - (m - 1) * 4) / m)
    local nw_h = 48
    local nx = PAD_X
    local ny = ay + sw_h + 56
    for _, entry in ipairs(opts.neutrals) do
      table.insert(parts, swatch(nx, ny, nw_w, nw_h, opts.fg, opts.fg_muted, entry.name, entry.hex))
      nx = nx + nw_w + 4
    end
  end

  return table.concat(parts, "")
end

-- The orchestrator passes the night `colors` table here. We ignore it: this
-- generator documents BOTH variants and pulls each variant directly.
function M.generate(_)
  local night = Palette.resolve("night")
  local dawn = Palette.resolve("dawn")

  local night_h = 250
  local dawn_h = 130

  local night_section = section({
    y = 0,
    height = night_h,
    bg = night.bg_0,
    fg = night.fg,
    fg_muted = night.fg_mute,
    label = "NIGHT",
    accents = {
      { name = "pink", hex = night.pink },
      { name = "lavender", hex = night.lavender },
      { name = "cyan", hex = night.cyan },
      { name = "peach", hex = night.peach },
      { name = "blue", hex = night.blue },
      { name = "yellow", hex = night.yellow },
    },
    neutrals = {
      { name = "bg_deep", hex = night.bg_deep },
      { name = "bg_0", hex = night.bg_0 },
      { name = "bg_1", hex = night.bg_1 },
      { name = "bg_2", hex = night.bg_2 },
      { name = "bg_3", hex = night.bg_3 },
      { name = "bg_4", hex = night.bg_4 },
      { name = "fg_faint", hex = night.fg_faint },
      { name = "fg_mute", hex = night.fg_mute },
      { name = "fg", hex = night.fg },
    },
  })

  local dawn_section = section({
    y = night_h,
    height = dawn_h,
    bg = dawn.bg_0,
    fg = dawn.fg,
    fg_muted = dawn.fg_mute,
    label = "DAWN",
    accent_height = 44,
    accents = {
      { name = "pink", hex = dawn.pink },
      { name = "lavender", hex = dawn.lavender },
      { name = "cyan", hex = dawn.cyan },
      { name = "peach", hex = dawn.peach },
      { name = "blue", hex = dawn.blue },
      { name = "yellow", hex = dawn.yellow },
    },
  })

  local total_h = night_h + dawn_h
  return string.format(
    '<?xml version="1.0" encoding="UTF-8"?>\n'
      .. '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 %d %d" width="%d" height="%d">'
      .. "%s%s"
      .. "</svg>\n",
    W,
    total_h,
    W,
    total_h,
    night_section,
    dawn_section
  )
end

return M
