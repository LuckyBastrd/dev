# WIDGET: SESH SESSIONS (Ctrl+f)
function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session

    session=$(~/.config/sesh/scripts/sesh-find --widget | fzf \
      --height 50% \
      --reverse \
      --border-label ' sesh ' \
      --border \
      --prompt '⚡  ')

    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return

    local cleaned_session=$(echo "$session" | sed 's/\[TMUX\] //g')
    local final_path=$(echo "$cleaned_session" | awk '{print $NF}' | sed "s|^~|$HOME|")
    sesh connect "$final_path"
  }
}

# WIDGET: CHEZ-EDIT (Ctrl+e)
function zle-chez-edit() {
  {
    exec </dev/tty
    exec <&1

    chez-edit

    zle reset-prompt
  }
}

# Keybinds
zle -N sesh-sessions
zle -N zle-chez-edit
zle -N zle-tuist-template

bindkey '^f' sesh-sessions
bindkey '^[d' zle-chez-edit
