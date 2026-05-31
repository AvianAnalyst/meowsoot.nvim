local Util = require("meowsoot.util")

local M = {}

local template = [[
# meowsoot — fzf theme.
# https://github.com/marekh19/meowsoot.nvim
# Auto-generated from lua/meowsoot/palette.lua. Do not edit by hand.
# Use via:  set -gx FZF_DEFAULT_OPTS_FILE ~/path/to/meowsoot.conf
#           (or merge --color lines into your existing FZF_DEFAULT_OPTS)

--color=bg+:${bg_2},bg:${bg_0},spinner:${pink},hl:${cyan}
--color=fg:${fg},header:${fg_faint},info:${lavender},pointer:${pink}
--color=marker:${ok},fg+:${fg},prompt:${cyan},hl+:${cyan}
--color=selected-bg:${bg_2}
--multi
]]

function M.generate(colors)
  return Util.template(template, colors)
end

return M
