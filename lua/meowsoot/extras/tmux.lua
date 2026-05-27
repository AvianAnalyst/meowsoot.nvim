local Util = require("meowsoot.util")

local M = {}

local template = [[
# meowsoot — Tmux theme.
# Auto-generated from lua/meowsoot/palette.lua. Do not edit by hand.
# Source from your tmux.conf:  source-file ~/path/to/meowsoot.tmux

set -g status-style "fg=${fg},bg=${bg_1}"

set -g status-left ' #[fg=${pink},bold]#S #[fg=${cyan}]'
set -g status-right '#[fg=${cyan}]%d/%m #[fg=${pink},bold]%H:%M '

set -g window-status-current-style "fg=${bg_0},bg=${pink},bold"
set -g window-status-style "fg=${fg_mute}"

set -g pane-border-style "fg=${bg_4}"
set -g pane-active-border-style "fg=${pink}"

set -g message-style "fg=${bg_0},bg=${yellow}"
set -g message-command-style "fg=${bg_0},bg=${cyan}"

set -g mode-style "fg=${bg_0},bg=${bg_visual}"

set -g display-panes-colour "${bg_4}"
set -g display-panes-active-colour "${pink}"

set -g clock-mode-colour "${cyan}"

set -g copy-mode-match-style "fg=${bg_0},bg=${yellow}"
set -g copy-mode-current-match-style "fg=${bg_0},bg=${peach}"
]]

function M.generate(colors)
  return Util.template(template, colors)
end

return M
