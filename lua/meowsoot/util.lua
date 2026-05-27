-- Color manipulation, template engine, JSON cache, highlight helpers.
-- Adapted from folke/tokyonight.nvim (MIT).

local hsl = require("meowsoot.hsl")

local M = {}

M.bg = "#000000"
M.fg = "#ffffff"

local uv = vim.uv or vim.loop

local function rgb(c)
  c = string.lower(c)
  return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
end

---Linear-interpolate fg toward bg by alpha. Both hex strings.
---@param fg string
---@param alpha number 0..1 (1 = full fg, 0 = full bg)
---@param bg string
---@return string
function M.blend(fg, alpha, bg)
  local f = rgb(fg)
  local b = rgb(bg)
  local function ch(i)
    local v = alpha * f[i] + (1 - alpha) * b[i]
    return math.floor(math.min(math.max(0, v), 255) + 0.5)
  end
  return string.format("#%02x%02x%02x", ch(1), ch(2), ch(3))
end

---Blend color toward configured bg (`M.bg`). Lower amount = darker.
function M.blend_bg(c, amount, bg)
  return M.blend(c, amount, bg or M.bg)
end

---Blend color toward configured fg (`M.fg`). Lower amount = closer to bg.
function M.blend_fg(c, amount, fg)
  return M.blend(c, amount, fg or M.fg)
end

M.darken = M.blend_bg
M.lighten = M.blend_fg

---Bump perceived lightness in HSL space. Used for `_bright` ANSI slots.
---@param hex string
---@param amount number HSL lightness delta (default +12)
function M.brighten(hex, amount)
  return hsl.adjust(hex, { l = amount or 12 })
end

---Substitute `${var}` (and nested `${a.b}`) in a template against a table.
---@param str string
---@param tbl table
---@return string
function M.template(str, tbl)
  return (
    str:gsub("($%b{})", function(w)
      return vim.tbl_get(tbl, unpack(vim.split(w:sub(3, -2), ".", { plain = true }))) or w
    end)
  )
end

---Flatten `{ style = { italic = true } }` into inline `italic = true` keys
---so the table is directly consumable by `nvim_set_hl`.
function M.resolve(groups)
  for _, hl_ in pairs(groups) do
    if type(hl_) == "table" and type(hl_.style) == "table" then
      for k, v in pairs(hl_.style) do
        hl_[k] = v
      end
      hl_.style = nil
    end
  end
  return groups
end

---Read a file synchronously, return its contents (or nil).
function M.read(path)
  local fd = uv.fs_open(path, "r", 438)
  if not fd then
    return nil
  end
  local stat = uv.fs_fstat(fd)
  local data = uv.fs_read(fd, stat.size, 0)
  uv.fs_close(fd)
  return data
end

---Write `data` to `path`, creating parents as needed.
function M.write(path, data)
  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
  local fd = uv.fs_open(path, "w", 420)
  if not fd then
    error("meowsoot: cannot open " .. path)
  end
  uv.fs_write(fd, data, 0)
  uv.fs_close(fd)
end

-- JSON cache for compiled highlight groups.
M.cache = {}

function M.cache.file()
  return vim.fn.stdpath("cache") .. "/meowsoot.json"
end

function M.cache.read()
  local data = M.read(M.cache.file())
  if not data then
    return nil
  end
  local ok, decoded = pcall(vim.json.decode, data, { luanil = { object = true, array = true } })
  return ok and decoded or nil
end

function M.cache.write(data)
  pcall(M.write, M.cache.file(), vim.json.encode(data))
end

function M.cache.clear()
  pcall(uv.fs_unlink, M.cache.file())
end

return M
