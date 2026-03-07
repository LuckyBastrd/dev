#!/usr/bin/env bash

# ================================================
# Status bar script for tmux (statusbar-style)
# Inspired by tmux-statusbar.tmux
# GitHub: https://github.com/vaaleyard/tmux-statusbar.git
# ================================================

get_tmux_option() {
    local option=$1
    local default_value="$2"

    local option_value
    option_value=$(tmux show-options -gqv "$option")

    if [ "$option_value" != "" ]; then
        echo "$option_value"
        return
    fi
    echo "$default_value"
}

# Colors
bg=$(get_tmux_option "@tmux-statusbar-bg" "default")
fg=$(get_tmux_option "@tmux-statusbar-fg" "white")
accent=$(get_tmux_option "@tmux-statusbar-accent" "blue")
fg_inactive=$(get_tmux_option "@tmux-statusbar-fg-inactive" "colour245")

bg_prefix_mode=$(get_tmux_option "@tmux-statusbar-bg-prefix-mode" "green")
fg_prefix_mode=$(get_tmux_option "@tmux-statusbar-fg-prefix-mode" "black")

selection_mode=$(get_tmux_option "@tmux-statusbar-selection-mode" "colour237")
cursearch=$(get_tmux_option "@tmux-statusbar-cursearch" "violet")

bell_alert=$(get_tmux_option "@tmux-statusbar-bell-alert" "red")
activity_alert=$(get_tmux_option "@tmux-statusbar-activity-alert" "yellow")

# Options
status_position=$(get_tmux_option "@tmux-statusbar-position" "bottom")
status_justify=$(get_tmux_option "@tmux-statusbar-justify" "centre")

# Status Components
prefix_mode_content=$(get_tmux_option "@tmux-statusbar-prefix-mode-content" " #S ")
prefix_mode_position=$(get_tmux_option "@tmux-statusbar-prefix-mode-position" "left")

prefix_mode_component="
#[bg=$bg,fg=$fg]#{?client_prefix,,$prefix_mode_content}
#[bg=$bg_prefix_mode,fg=$fg_prefix_mode]#{?client_prefix,$prefix_mode_content,}
#[bg=$bg,fg=${fg}]
"

if [ "$prefix_mode_position" = "left" ]; then
    default_left="$prefix_mode_component"
    default_right=""
else
    default_left=""
    default_right="$prefix_mode_component"
fi

color_start="#[bg=$bg,fg=$fg]"
color_end="#[bg=$bg,fg=$fg]"

extend_status_left=$(get_tmux_option "@tmux-statusbar-status-left" "")
if [ -n "$extend_status_left" ]; then
    status_left="${default_left}${color_start}${extend_status_left}${color_end}"
else
    status_left="$default_left"
fi

extend_status_right=$(get_tmux_option "@tmux-statusbar-status-right" "")
if [ -n "$extend_status_right" ]; then
    status_right="${color_start}${extend_status_right}${color_end}${default_right}"
else
    status_right="$default_right"
fi

# Window Format & SSH
show_window_index=$(get_tmux_option "@tmux-statusbar-show-window-index" true)
base_window_format=$(get_tmux_option "@tmux-statusbar-window-status-format" " #W ")
ssh_enabled=$(get_tmux_option "@tmux-statusbar-ssh-enabled" true)

if [ "$ssh_enabled" = true ]; then
    ssh_icon=$(get_tmux_option "@tmux-statusbar-ssh-icon" '󰌘')
    ssh_icon_only=$(get_tmux_option "@tmux-statusbar-ssh-icon-only" false)

    if [ "$ssh_icon_only" = true ]; then
        ssh_window_format=" ${ssh_icon}${base_window_format}"
    else
        ssh_window_format=" ${ssh_icon} #(
title='#{pane_title}'

host=\$(echo \"\$title\" \
    | sed 's/^ssh //' \
    | sed 's/ .*//' \
    | sed 's/.*@//' \
    | sed 's/:.*//')

if echo \"\$host\" | grep -qE '^[0-9.]+\$|^[0-9]'; then
    result='#W'
else
    result=\"\$host\"
fi

echo \"\$result\" | cut -c1-20
) "
    fi

    window_status_format="#{?#{==:#{pane_current_command},ssh},${ssh_window_format},${base_window_format}}"
else
    window_status_format="${base_window_format}"
fi

window_status_separator=$(get_tmux_option "@tmux-statusbar-window-status-separator" " • ")
maximized_pane_icon=$(get_tmux_option "@tmux-statusbar-maximized-icon" "󰊓")
show_maximized_icon_for_all_tabs=$(get_tmux_option "@tmux-statusbar-show-maximized-icon-for-all-tabs" true)

if [ "$show_window_index" = true ]; then
    window_label=" #I${window_status_format}"
    current_label=" #[bg=${bg},fg=${accent}]#I#[bg=${bg},fg=${fg},bold]${window_status_format}"
else
    window_label="${window_status_format}"
    current_label="#[bg=${bg},fg=${fg},bold]${window_status_format}"
fi

if [ "$show_maximized_icon_for_all_tabs" = true ]; then
    zoom_segment="#{?window_zoomed_flag,${maximized_pane_icon},}"
else
    zoom_segment=""
fi

# Apply Options
tmux set-option -g status-position "$status_position"
tmux set-option -g status-justify "$status_justify"
tmux set-option -g status-style "bg=${bg},fg=${fg_inactive}"

tmux set-option -g status-left "$status_left"
tmux set-option -g status-right "$status_right"

tmux set-window-option -g window-status-separator "$window_status_separator"
tmux set-option -g window-status-style "bg=${bg},fg=${fg_inactive}"
tmux set-option -g window-status-format "${window_label}${zoom_segment}"

tmux set-option -g window-status-current-format "${current_label}\
#[fg=${accent},bg=${bg}]${zoom_segment}#[fg=${bg},bg=default]"

tmux set-option -g mode-style "bg=${selection_mode},fg=${fg}"
tmux set-option -g copy-mode-match-style "bg=${selection_mode},fg=${fg}"
tmux set-option -g copy-mode-current-match-style "bg=${cursearch},fg=${bg}"

tmux set-option -g pane-border-style "fg=${fg_inactive}"
tmux set-option -g pane-active-border-style "fg=${accent}"
