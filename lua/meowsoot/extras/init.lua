-- Extras orchestrator. Builds a non-transparent palette, runs each generator,
-- writes the result. Invoked from the justfile via:
--   nvim --headless -l ... -c 'lua require("meowsoot.extras").setup()'

local Util = require("meowsoot.util")

local M = {}

M.targets = {
  { name = "ghostty", path = "extras/ghostty/meowsoot" },
  { name = "tmux", path = "extras/tmux/meowsoot.tmux" },
  { name = "fish", path = "extras/fish/meowsoot.fish" },
  { name = "fzf", path = "extras/fzf/meowsoot.conf" },
}

function M.setup()
  -- Force non-transparent, all-plugins for the snapshot
  local colors = require("meowsoot.colors").setup({
    transparent = false,
    styles = { sidebars = "dark", floats = "dark" },
  })

  for _, target in ipairs(M.targets) do
    local mod = require("meowsoot.extras." .. target.name)
    local content = mod.generate(colors)
    Util.write(target.path, content)
    io.write("[meowsoot] wrote " .. target.path .. "\n")
  end
end

return M
