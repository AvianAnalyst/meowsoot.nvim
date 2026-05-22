-- Extras orchestrator. Builds a non-transparent palette, runs each generator,
-- writes the result. Invoked from the justfile via:
--   nvim --headless -l ... -c 'lua require("nyanuwatari.extras").setup()'

local Util = require("nyanuwatari.util")

local M = {}

M.targets = {
  { name = "ghostty", path = "extras/ghostty/nyanuwatari" },
  { name = "tmux", path = "extras/tmux/nyanuwatari.tmux" },
  { name = "fish", path = "extras/fish/nyanuwatari.fish" },
  { name = "fzf", path = "extras/fzf/nyanuwatari.conf" },
}

function M.setup()
  -- Force non-transparent, all-plugins for the snapshot
  local colors = require("nyanuwatari.colors").setup({
    transparent = false,
    styles = { sidebars = "dark", floats = "dark" },
  })

  for _, target in ipairs(M.targets) do
    local mod = require("nyanuwatari.extras." .. target.name)
    local content = mod.generate(colors)
    Util.write(target.path, content)
    io.write("[nyanuwatari] wrote " .. target.path .. "\n")
  end
end

return M
