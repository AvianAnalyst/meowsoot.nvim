-- Group aggregator: enables base/treesitter/semantic_tokens/kinds always;
-- merges plugin modules based on opts.plugins (with lazy.nvim auto-detect);
-- caches the resolved highlight table to JSON for fast subsequent loads.
-- Adapted from folke/tokyonight.nvim (MIT).

local Config = require("meowsoot.config")
local Util = require("meowsoot.util")

local M = {}

-- lazy.nvim plugin name -> module name under `meowsoot.groups.plugins.`
-- stylua: ignore
M.plugins = {
  ["gitsigns.nvim"]           = "gitsigns",
  ["telescope.nvim"]          = "telescope",
  ["nvim-cmp"]                = "cmp",
  ["blink.cmp"]               = "blink",
  ["lazy.nvim"]               = "lazy",
  ["flash.nvim"]              = "flash",
  ["nvim-tree.lua"]           = "nvim_tree",
  ["indent-blankline.nvim"]   = "indent_blankline",
  ["nvim-treesitter-context"] = "treesitter_context",
  ["snacks.nvim"]             = "snacks",
  ["mini.icons"]              = "mini_icons",
  ["mini.files"]              = "mini_files",
  ["mini.statusline"]         = "mini_statusline",
  ["mini.indentscope"]        = "mini_indentscope",
  ["mini.diff"]               = "mini_diff",
  ["mini.notify"]             = "mini_notify",
  ["mini.pick"]               = "mini_pick",
  ["noice.nvim"]              = "noice",
  ["which-key.nvim"]          = "which_key",
  ["trouble.nvim"]            = "trouble",
  ["render-markdown.nvim"]    = "render_markdown",
  ["fzf-lua"]                 = "fzf_lua",
}

local function get_module(name, plugin)
  local ok, mod = pcall(require, "meowsoot.groups." .. name)
  if not ok then
    ok, mod = pcall(require, "meowsoot.groups.plugins." .. name)
  end
  if not ok then
    error(
      ("meowsoot: group module '%s' not found%s"):format(
        name,
        plugin and (" (for " .. plugin .. ")") or ""
      )
    )
  end
  return mod
end

---@param colors table
---@param opts meowsoot.Config
function M.setup(colors, opts)
  local enabled = {
    base = true,
    treesitter = true,
    semantic_tokens = true,
    kinds = true,
  }

  if opts.plugins.all then
    for _, group in pairs(M.plugins) do
      enabled[group] = true
    end
  elseif opts.plugins.auto and package.loaded.lazy then
    local plugins = require("lazy.core.config").plugins
    for plugin, group in pairs(M.plugins) do
      if plugins[plugin] then
        enabled[group] = true
      end
    end
    if plugins["mini.nvim"] then
      for _, group in pairs(M.plugins) do
        if group:find("^mini_") then
          enabled[group] = true
        end
      end
    end
  end

  -- Manual overrides: opts.plugins[group_name] takes precedence.
  for plugin, group in pairs(M.plugins) do
    local use = opts.plugins[group]
    if use == nil then
      use = opts.plugins[plugin]
    end
    if use ~= nil then
      if type(use) == "table" then
        use = use.enabled
      end
      enabled[group] = use or nil
    end
  end

  local names = vim.tbl_keys(enabled)
  table.sort(names)

  local inputs = {
    colors = colors,
    plugins = names,
    version = Config.version,
    transparent = opts.transparent,
    styles = opts.styles,
  }

  local cache = opts.cache and Util.cache.read()
  local ret = cache and vim.deep_equal(inputs, cache.inputs) and cache.groups or nil

  if not ret then
    ret = {}
    for group in pairs(enabled) do
      local mod = get_module(group)
      for k, v in pairs(mod.get(colors, opts)) do
        ret[k] = v
      end
    end
    Util.resolve(ret)
    if opts.cache then
      Util.cache.write({ groups = ret, inputs = inputs })
    end
  end

  if opts.on_highlights then
    opts.on_highlights(ret, colors)
  end

  return ret, enabled
end

return M
