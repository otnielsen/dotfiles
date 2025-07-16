bash_prompt_color_force=1
source /etc/bashrc
unset bash_prompt_color_force

HISTFILE=$XDG_STATE_HOME/bash_history

alias mvn="mvn -gs $XDG_CONFIG_HOME/maven/settings.xml"
alias gearlever='flatpak run it.mijorus.gearlever'

alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ls='ls --color=auto --group-directories-first'
alias tree='tree --dirsfirst'

alias lg='lazygit'
