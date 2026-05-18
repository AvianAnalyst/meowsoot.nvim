# nyanuwatari — Tmux theme.
# Auto-generated from lua/nyanuwatari/palette.lua. Do not edit by hand.
# Source from your tmux.conf:  source-file ~/path/to/nyanuwatari.tmux

set -g status-style "fg=#e2e0df,bg=#201f1d"

set -g status-left ' #[fg=#eaa4c9,bold]#S #[fg=#96d8e3]'
set -g status-right '#[fg=#96d8e3]%d/%m #[fg=#eaa4c9,bold]%H:%M '

set -g window-status-current-style "fg=#171616,bg=#eaa4c9,bold"
set -g window-status-style "fg=#b1ada9"

set -g pane-border-style "fg=#454240"
set -g pane-active-border-style "fg=#eaa4c9"

set -g message-style "fg=#171616,bg=#dfd286"
set -g message-command-style "fg=#171616,bg=#96d8e3"

set -g mode-style "fg=#171616,bg=#353331"

set -g display-panes-colour "#454240"
set -g display-panes-active-colour "#eaa4c9"

set -g clock-mode-colour "#96d8e3"

set -g copy-mode-match-style "fg=#171616,bg=#dfd286"
set -g copy-mode-current-match-style "fg=#171616,bg=#e3b096"
