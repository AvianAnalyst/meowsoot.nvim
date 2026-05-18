local Util = require("nyanuwatari.util")

local M = {}

local template = [[
# nyanuwatari — Fish shell theme.
# Auto-generated from lua/nyanuwatari/palette.lua. Do not edit by hand.
# Install:  cp extras/fish/nyanuwatari.fish ~/.config/fish/conf.d/

# Palette
set -l foreground ${fg}
set -l selection  ${bg_visual}
set -l comment    ${fg_mute}
set -l red        ${red}
set -l green      ${ok}
set -l yellow     ${yellow}
set -l peach      ${peach}
set -l cyan       ${cyan}
set -l cyan_br    ${cyan_br}
set -l pink       ${pink}
set -l lavender   ${lavender}

# Syntax Highlighting Colors
set -g fish_color_normal         $foreground
set -g fish_color_command        $cyan
set -g fish_color_keyword        $lavender
set -g fish_color_quote          $yellow
set -g fish_color_redirection    $cyan
set -g fish_color_end            $foreground
set -g fish_color_error          $red
set -g fish_color_param          $foreground
set -g fish_color_option         $peach
set -g fish_color_comment        $comment
set -g fish_color_selection      --background=$selection
set -g fish_color_operator       $cyan
set -g fish_color_escape         $peach
set -g fish_color_autosuggestion $comment
set -g fish_color_cwd            $cyan
set -g fish_color_cwd_root       $red
set -g fish_color_valid_path     --underline
set -g fish_color_history_current --bold
set -g fish_color_search_match   --background=$selection
set -g fish_color_match          $cyan_br
set -g fish_color_cancel         $red

# Completion Pager Colors
set -g fish_pager_color_progress             $comment
set -g fish_pager_color_prefix               $cyan
set -g fish_pager_color_completion           $foreground
set -g fish_pager_color_description          $comment
set -g fish_pager_color_selected_background  --background=$selection
set -g fish_pager_color_selected_completion  $foreground
set -g fish_pager_color_selected_description $comment
set -g fish_pager_color_selected_prefix      $cyan
]]

---@param colors table
function M.generate(colors)
  -- Fish needs hex without '#'
  local fc = {}
  for k, v in pairs(colors) do
    if type(v) == "string" then
      fc[k] = v:gsub("^#", "")
    elseif type(v) == "table" then
      fc[k] = {}
      for kk, vv in pairs(v) do
        if type(vv) == "string" then
          fc[k][kk] = vv:gsub("^#", "")
        end
      end
    end
  end
  return Util.template(template, fc)
end

return M
