-- Fish shell colorscheme runner.
-- Outputs a sourced .fish script (set -l palette, set -g fish_color_*).
-- Install: cp extras/fish/nyanuwatari.fish ~/.config/fish/conf.d/

---Strip leading '#' from a hex string so fish doesn't treat it as a comment.
local function h(color)
  return color:sub(2)
end

---@param c table see lua/nyanuwatari/term.lua M.colors_map
---@return string[] lines
local function transform(c)
  -- stylua: ignore
  local lines = {
    "# Palette",
    "set -l foreground " .. h(c.fg),
    "set -l selection  " .. h(c.selection_bg),
    "set -l comment    " .. h(c.white),
    "set -l red        " .. h(c.red),
    "set -l green      " .. h(c.green),
    "set -l yellow     " .. h(c.yellow),
    "set -l peach      " .. h(c.bright_yellow),
    "set -l cyan       " .. h(c.cyan),
    "set -l cyan_br    " .. h(c.bright_cyan),
    "set -l lavender   " .. h(c.magenta),
    "",
    "# Syntax Highlighting Colors",
    "set -g fish_color_normal        $foreground",
    "set -g fish_color_command       $cyan",
    "set -g fish_color_keyword       $lavender",
    "set -g fish_color_quote         $yellow",
    "set -g fish_color_redirection   $cyan",
    "set -g fish_color_end           $foreground",
    "set -g fish_color_error         $red",
    "set -g fish_color_param         $foreground",
    "set -g fish_color_option        $peach",
    "set -g fish_color_comment       $comment",
    "set -g fish_color_selection     --background=$selection",
    "set -g fish_color_operator      $cyan",
    "set -g fish_color_escape        $green",
    "set -g fish_color_autosuggestion $comment",
    "set -g fish_color_cwd           $green",
    "set -g fish_color_cwd_root      $red",
    "set -g fish_color_valid_path    --underline",
    "set -g fish_color_history_current --bold",
    "set -g fish_color_search_match  --background=$selection",
    "set -g fish_color_match         $cyan_br",
    "set -g fish_color_cancel        $red",
    "",
    "# Completion Pager Colors",
    "set -g fish_pager_color_progress             $comment",
    "set -g fish_pager_color_prefix               $cyan",
    "set -g fish_pager_color_completion           $foreground",
    "set -g fish_pager_color_description          $comment",
    "set -g fish_pager_color_selected_background  --background=$selection",
    "set -g fish_pager_color_selected_completion  $foreground",
    "set -g fish_pager_color_selected_description $comment",
    "set -g fish_pager_color_selected_prefix      $cyan",
  }
  return lines
end

return transform
