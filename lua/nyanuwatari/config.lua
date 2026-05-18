-- Configuration defaults + user-merge.

local M = {}

M.version = "0.2.0"

---@class nyanuwatari.Config
M.defaults = {
  transparent = false,
  terminal_colors = true,
  cache = true,
  styles = {
    comments = { italic = true },
    keywords = {},
    functions = {},
    variables = {},
    sidebars = "dark", -- "dark" | "transparent" | "normal"
    floats = "dark",
  },
  ---Per-plugin overrides. `nil` honors auto-detection.
  plugins = {
    all = package.loaded.lazy == nil,
    auto = true,
  },
  on_colors = function(_) end,
  on_highlights = function(_, _) end,
}

M.options = vim.deepcopy(M.defaults)

---Merge user options into defaults.
function M.extend(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

return M
