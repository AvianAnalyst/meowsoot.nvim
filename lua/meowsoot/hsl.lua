-- HSL <-> hex conversion. Standard textbook HSL (not HSLuv).
-- Author the palette in HSL for ergonomic tuning on the color wheel;
-- convert once to hex at theme-load time.

local M = {}

local function round(x)
  return math.floor(x + 0.5)
end

---@param hsl table {h(0-360), s(0-100), l(0-100)}
---@return string hex "#rrggbb"
function M.to_hex(hsl)
  local h = (hsl[1] % 360) / 60
  local s = hsl[2] / 100
  local l = hsl[3] / 100

  local c = (1 - math.abs(2 * l - 1)) * s
  local x = c * (1 - math.abs(h % 2 - 1))
  local m = l - c / 2

  local r1, g1, b1 = 0, 0, 0
  if h < 1 then
    r1, g1, b1 = c, x, 0
  elseif h < 2 then
    r1, g1, b1 = x, c, 0
  elseif h < 3 then
    r1, g1, b1 = 0, c, x
  elseif h < 4 then
    r1, g1, b1 = 0, x, c
  elseif h < 5 then
    r1, g1, b1 = x, 0, c
  else
    r1, g1, b1 = c, 0, x
  end

  return string.format(
    "#%02x%02x%02x",
    round((r1 + m) * 255),
    round((g1 + m) * 255),
    round((b1 + m) * 255)
  )
end

---@param hex string "#rrggbb"
---@return table {h(0-360), s(0-100), l(0-100)}
function M.from_hex(hex)
  local r = tonumber(hex:sub(2, 3), 16) / 255
  local g = tonumber(hex:sub(4, 5), 16) / 255
  local b = tonumber(hex:sub(6, 7), 16) / 255

  local max = math.max(r, g, b)
  local min = math.min(r, g, b)
  local l = (max + min) / 2
  local h, s = 0, 0

  if max ~= min then
    local d = max - min
    s = l > 0.5 and d / (2 - max - min) or d / (max + min)
    if max == r then
      h = (g - b) / d + (g < b and 6 or 0)
    elseif max == g then
      h = (b - r) / d + 2
    else
      h = (r - g) / d + 4
    end
    h = h * 60
  end

  return { round(h), round(s * 100), round(l * 100) }
end

---Shift one or more HSL channels of a hex color. Each delta is added directly.
---@param hex string "#rrggbb"
---@param delta table {h?, s?, l?}
---@return string
function M.adjust(hex, delta)
  local hsl = M.from_hex(hex)
  hsl[1] = (hsl[1] + (delta.h or 0)) % 360
  hsl[2] = math.max(0, math.min(100, hsl[2] + (delta.s or 0)))
  hsl[3] = math.max(0, math.min(100, hsl[3] + (delta.l or 0)))
  return M.to_hex(hsl)
end

return M
