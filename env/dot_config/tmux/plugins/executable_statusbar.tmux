#!/usr/bin/env bash

# ================================================
# Status bar script for tmux (statusbar-style)
# Inspired by tmux-dotbar.tmux
# GitHub: https://github.com/vaaleyard/tmux-dotbar.git
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

# default colors
DEFAULT_BG=default
DEFAULT_FG=white
DEFAULT_INACTIVE_FG=colour245
DEFAULT_ACCENT=blue
DEFAULT_PREFIX_MODE=green
DEFAULT_SELECTION_MODE=colour237
DEFAULT_PREFIX_MODE_FG=black
DEFAULT_CURSEARCH=violet
DEFAULT_BELL_ALERT=red
DEFAULT_ACTIVITY_ALERT=yellow

# colors from theme
theme_file=$(get_tmux_option "@tmux-theme")

if [ -n "$theme_file" ] && [ -f "$theme_file" ]; then
    tmux source-file "$theme_file"
fi

# set colors
bg=$(get_tmux_option "@bg" "$DEFAULT_BG")
fg=$(get_tmux_option "@fg" "$DEFAULT_FG")
inactive_fg=$(get_tmux_option "@inactive_fg" "$DEFAULT_INACTIVE_FG")
accent=$(get_tmux_option "@accent" "$DEFAULT_ACCENT")
prefix_mode=$(get_tmux_option "@prefix_mode" "$DEFAULT_PREFIX_MODE")
prefix_mode_fg=$(get_tmux_option "@prefix_mode_fg" "$DEFAULT_PREFIX_MODE_FG")
selection_mode=$(get_tmux_option "@selection_mode" "$DEFAULT_SELECTION_MODE")
cursearch=$(get_tmux_option "@cursearch" "$DEFAULT_CURSEARCH")
bell_alert=$(get_tmux_option "@bell_alert" "$DEFAULT_BELL_ALERT")
activity_alert=$(get_tmux_option "@activity_alert" "$DEFAULT_ACTIVITY_ALERT")

# statusbar config
statusbar_position=$(get_tmux_option "@tmux-statusbar-position" "bottom")
statusbar_justify=$(get_tmux_option "@tmux-statusbar-justify" "centre")

status_left=$(get_tmux_option "@tmux-statusbar-status-left" "
#[bg=$bg,fg=$fg]#{?client_prefix,, #S }
#[bg=$prefix_mode,fg=$prefix_mode_fg,bold]#{?client_prefix, #S ,}
#[bg=$bg,fg=${fg}]
")

status_right=$(get_tmux_option "@tmux-statusbar-status-right" "
#[bg=$bg,fg=$fg] %I:%M %p
#[bg=$bg,fg=${fg}]
")

base_window_format=$(get_tmux_option "@tmux-statusbar-window-status-format" '#W ')

ssh_enabled=$(get_tmux_option "@tmux-statusbar-ssh-enabled" true)

if [ "$ssh_enabled" = true ]; then
  ssh_icon=$(get_tmux_option "@tmux-statusbar-ssh-icon" '󰌘')
  ssh_icon_only=$(get_tmux_option "@tmux-statusbar-ssh-icon-only" false)

  if [ "$ssh_icon_only" = true ]; then
    ssh_window_format=" ${ssh_icon}${base_window_format}"
  else
    ssh_window_format=" ${ssh_icon} #(host=\$(echo '#{pane_title}' | sed 's/^ssh //; s/ .*//; s/.*@//; s/:.*//'); if echo \"\$host\" | grep -qE '^[0-9.]+\$|^[0-9]'; then echo '#W'; else echo \"\$host\"; fi | cut -c1-20) "
  fi

  window_status_format="#{?#{==:#{pane_current_command},ssh},${ssh_window_format},${base_window_format}}"
else
  window_status_format="${base_window_format}"
fi

window_status_separator=$(get_tmux_option "@tmux-statusbar-window-status-separator" ' • ')

maximized_pane_icon=$(get_tmux_option "@tmux-statusbar-maximized-icon" '󰊓')

# apply statusbar config
tmux set-option -g status-position "$statusbar_position"
tmux set-option -g status-justify "$statusbar_justify"
tmux set-option -g status-style "bg=${bg},fg=${inactive_fg}"

tmux set-option -g status-left "$status_left"
tmux set-option -g status-right "$status_right"

tmux set-window-option -g window-status-separator "$window_status_separator"

tmux set-option -g window-status-style "bg=${bg},fg=${inactive_fg}"
tmux set-option -g window-status-format " #I.$window_status_format"

tmux set-option -g window-status-bell-style "bg=${bell_alert},fg=${bg},bold"
tmux set-option -g window-status-activity-style "bg=${activity_alert},fg=${bg}"

tmux set-option -g window-status-current-format " #[bg=${bg},fg=${accent}]#I.#[bg=${bg},fg=${fg}]${window_status_format}#[fg=${accent},bg=${bg}]#{?window_zoomed_flag,${maximized_pane_icon},}#[fg=${bg},bg=default]"

tmux set-option -g message-style "bg=${bg},fg=${fg}"
tmux set-option -g message-command-style "bg=${bg},fg=${accent}"

tmux set-option -g mode-style "bg=${selection_mode},fg=${fg}"
tmux set-option -g copy-mode-match-style "bg=${selection_mode},fg=${fg}"
tmux set-option -g copy-mode-current-match-style "bg=${cursearch},fg=${bg}"

tmux set-option -g pane-border-style "fg=${inactive_fg}"
tmux set-option -g pane-active-border-style "fg=${accent}"
