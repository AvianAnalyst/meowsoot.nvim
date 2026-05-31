local Util = require("meowsoot.util")

local M = {}

local template = [[
# vim:ft=kitty
# meowsoot — Kitty theme.
# https://github.com/marekh19/meowsoot.nvim
# Auto-generated from lua/meowsoot/palette.lua. Do not edit by hand.
# Use from your kitty.conf:  include ~/path/to/meowsoot.conf
# See https://sw.kovidgoyal.net/kitty/conf/

background ${bg_0}
foreground ${fg}
selection_background ${bg_visual}
selection_foreground ${fg}
url_color ${cyan}
cursor ${pink}
cursor_text_color ${bg_0}

# Tabs
active_tab_background ${pink}
active_tab_foreground ${bg_0}
inactive_tab_background ${bg_highlight}
inactive_tab_foreground ${fg_mute}
#tab_bar_background ${bg_tab_line}

# Windows
active_border_color ${border_highlight}
inactive_border_color ${bg_4}

# normal
color0 ${terminal.black}
color1 ${terminal.red}
color2 ${terminal.green}
color3 ${terminal.yellow}
color4 ${terminal.blue}
color5 ${terminal.magenta}
color6 ${terminal.cyan}
color7 ${terminal.white}

# bright
color8  ${terminal.black_bright}
color9  ${terminal.red_bright}
color10 ${terminal.green_bright}
color11 ${terminal.yellow_bright}
color12 ${terminal.blue_bright}
color13 ${terminal.magenta_bright}
color14 ${terminal.cyan_bright}
color15 ${terminal.white_bright}

# extended colors
color16 ${peach}
color17 ${lavender}
]]

function M.generate(colors)
  return Util.template(template, colors)
end

return M
