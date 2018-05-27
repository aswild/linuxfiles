#!/bin/bash

# returns whether $version >= $1
# unlike bash (( arith )) comparisons, awk supports floats
ver_at_least() {
    return $(echo "$version $1" | awk '{if ($1 >= $2) print 0; else print 1}')
}

version=$(tmux -V | sed 's/tmux\s*//')

if ver_at_least 2.4 ; then
    # 2.4 copy mode bindings
    tmux bind -T copy-mode-vi v                 send -X begin-selection
    tmux bind -T copy-mode-vi y                 send -X copy-selection-and-cancel
    tmux bind -T copy-mode-vi Space             send -X clear-selection
    tmux bind -T copy-mode-vi Escape            send -X cancel
    tmux bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-selection-and-cancel
else
    # pre-2.4 copy mode bindings
    tmux bind -t vi-copy v                  begin-selection
    tmux bind -t vi-copy y                  copy-selection
    tmux bind -t vi-copy Space              clear-selection
    tmux bind -t vi-copy Escape             cancel
    tmux bind -t vi-edit Escape             cancel
    tmux bind -ct vi-edit Escape            cancel
    tmux bind -t vi-copy MouseDragEnd1Pane  copy-selection -x
fi

if ver_at_least 2.1 ; then
    # tmux >= 2.1 settings
    tmux set-option -g mouse on

    # Hooray! tmux mouse scrolling in less and similar applications!
    # Adapted from https://github.com/NHDaly/tmux-better-mouse-mode
    # The quoting is a bit weird, here's the logic:
    # if (application using mouse)
    #   forward mouse event
    # else
    #   if (alternate screen mode)
    #     send 3x up keystrokes
    #   else
    #     select current pane
    #     if (pane in [copy] mode)
    #       forward mouse event
    #     else
    #       enter copy mode
    #       send mouse up event
    tmux bind -n WheelUpPane if-shell -Ft= "#{mouse_any_flag}" "send-keys -M" \
        "if -Ft= '#{alternate_on}' \"send-keys -t= -N3 up\" \
        \"select-pane -t=; if -Ft= '#{pane_in_mode}' 'send-keys -M' 'copy-mode -e; send-keys -M'\""

    # if (application using mouse)
    #   forward mouse events
    # else
    #   if (alternate screen mode)
    #     send 3x down keystrokes
    #   else
    #     select current pane
    #     forward mouse event
    tmux bind -n WheelDownPane if-shell -Ft= "#{mouse_any_flag}" "send-keys -M" \
        "if -Ft= '#{alternate_on}' \"send-keys -t= -N3 down\" \"select-pane -t=; send-keys -M\""
else
    tmux set -g mode-mouse on
    tmux set -g mouse-resize-pane on
    tmux set -g mouse-select-pane on
    tmux set -g mouse-select-window on
fi

# figure out default shell
if [[ -x $(which zsh) ]]; then
    tmux set -g default-shell $(which zsh)
else
    tmux set -g default-shell $SHELL
fi
