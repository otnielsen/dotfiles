PATH=$HOME/.local/bin:$PATH

export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

export EDITOR=micro
export VISUAL=$EDITOR
export MANPAGER="bat --strip-ansi=always -plman"

export CC=clang
export CXX=clang++
export CC_LD=mold
export CXX_LD=mold

export NODE_REPL_HISTORY=$XDG_STATE_HOME/node_repl_history
export MYSQL_HISTFILE=$XDG_STATE_HOME/mysql_history
export PYTHON_HISTORY=$XDG_STATE_HOME/python_history

export AMD_DEBUG=useaco

source $HOME/.bashrc
