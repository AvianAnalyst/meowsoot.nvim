local M = {}

M.url = "https://github.com/echasnovski/mini.notify"

---@type fun(c: table, opts: table): table
function M.get()
  return {
    MiniNotifyBorder = "FloatBorder",
    MiniNotifyNormal = "NormalFloat",
    MiniNotifyTitle = "FloatTitle",
  }
end

return M
