local M = {}

---@param opts? table
function M.setup(opts)
  require("nyanuwatari.config").extend(opts)
end

---@param opts? table
function M.load(opts)
  return require("nyanuwatari.theme").setup(opts)
end

return M
