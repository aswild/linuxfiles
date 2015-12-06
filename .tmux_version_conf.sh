#! /bin/bash

version=$(tmux -V | sed 's/tmux\s*//')
if [[ $(echo "$version" | awk '{if ($1 >= 2.1) print 1; else print 0;}') == "1" ]]; then
    # tmux >= 2.1 settings
    tmux set-option -g mouse on
    tmux bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" \
        "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
    tmux bind -n WheelDownPane select-pane -t= \\; send-keys -M
else
    tmux set -g mode-mouse on
    tmux set -g mouse-resize-pane on
    tmux set -g mouse-select-pane on
    tmux set -g mouse-select-window on
fi
