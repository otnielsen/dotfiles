# If not running interactively, don't do anything
[ -z "$PS1" ] && return

if [ -z "$TMUX" ]; then
    mapfile -t tmux_unattached_sessions < <(tmux 'ls' -F '#{session_name}' -f '#{?session_attached,0,1}' 2>/dev/null)
    case ${#tmux_unattached_sessions[@]} in
    0) ;;
    1) exec tmux attach -t "${tmux_unattached_sessions[0]}" ;;
    *)
        res=$(printf '%s\n' "${tmux_unattached_sessions[@]}" | fzf --preview="tmux capture-pane -peJt '{r}:' -S \"#{e|-:#{pane_bottom},\$(( \$FZF_PREVIEW_LINES - 1 ))}\"")
        if [ -n "$res" ]; then
            exec tmux attach -t "$res"
        fi
        ;;
    esac

    exec tmux
fi

PS1='\[\e[36m\]\u@\h \w\n\[\e[39m\e]133;A\a\]$ '

[ -z "$BASH_COMPLETION_VERSINFO" ] && [ -f /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

HISTFILE=$XDG_STATE_HOME/bash_history

alias mvn='mvn -gs $XDG_CONFIG_HOME/maven/settings.xml'
alias gearlever='flatpak run it.mijorus.gearlever'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias grep='grep --color=auto'
alias egrep='grep -E --color=auto'
alias fgrep='grep -F --color=auto'

alias diff='diff --color=auto'
alias ls='ls --color=auto --group-directories-first'
alias tree='tree -alI .git --dirsfirst'
alias du='du -shD'
alias which='(alias; declare -f) | which --tty-only --read-alias --read-functions --show-tilde --show-dot'

alias lg='lazygit'
alias dl='curl -fL --remote-name-all' # dl for download

lfcd() {
    # `command` is needed in case `lfcd` is aliased to `lf`
    cd "$(
        export PAGER='less -RM'
        export BAT_PAGER="$PAGER"
        command lf -print-last-dir "$@"
    )" || return
}

alias lf='lfcd'

ff() {
    # todo: add a case to use different program depending on filetype
    #       like zathura for pdf, mpv for video etc.
    local res
    res=$(fzf)
    if [ -n "$res" ]; then
        nvim "$res"
    fi
}
