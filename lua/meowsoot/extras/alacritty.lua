local Util = require("meowsoot.util")

local M = {}

local template = [=[
# meowsoot — Alacritty theme.
# https://github.com/marekh19/meowsoot.nvim
# Auto-generated from lua/meowsoot/palette.lua. Do not edit by hand.
# Import from your alacritty.toml:  [general] import = ["~/path/to/meowsoot.toml"]
# See https://alacritty.org/config-alacritty.html

# Default colors
[colors.primary]
background = '${bg_0}'
foreground = '${fg}'

[colors.cursor]
cursor = '${pink}'
text = '${bg_0}'

[colors.selection]
background = '${bg_visual}'
text = '${fg}'

# Normal colors
[colors.normal]
black = '${terminal.black}'
red = '${terminal.red}'
green = '${terminal.green}'
yellow = '${terminal.yellow}'
blue = '${terminal.blue}'
magenta = '${terminal.magenta}'
cyan = '${terminal.cyan}'
white = '${terminal.white}'

# Bright colors
[colors.bright]
black = '${terminal.black_bright}'
red = '${terminal.red_bright}'
green = '${terminal.green_bright}'
yellow = '${terminal.yellow_bright}'
blue = '${terminal.blue_bright}'
magenta = '${terminal.magenta_bright}'
cyan = '${terminal.cyan_bright}'
white = '${terminal.white_bright}'
]=]

function M.generate(colors)
  return Util.template(template, colors)
end

return M
