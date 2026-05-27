local M = {}

---@param opts? table
function M.setup(opts)
  require("meowsoot.config").extend(opts)
end

---@param opts? table
function M.load(opts)
  return require("meowsoot.theme").setup(opts)
end

return M
