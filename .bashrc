bash_prompt_color_force=1
source /etc/bashrc
unset bash_prompt_color_force

HISTFILE=$XDG_STATE_HOME/bash_history

alias mvn='mvn -gs $XDG_CONFIG_HOME/maven/settings.xml'
alias gearlever='flatpak run it.mijorus.gearlever'

alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ls='ls --color=auto --group-directories-first'
alias tree='tree -alI .git --dirsfirst'
alias du='du -shD'

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
    res="$(fzf --reverse)"
    if [ -n "$res" ]; then
        nvim "$res"
    fi
}
