if ! [[ "$PATH" =~ $HOME/.local/bin ]]; then
    export PATH=$HOME/.local/bin${PATH:+:$PATH}
fi

export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

export EDITOR=nvim
export VISUAL=$EDITOR
export TERMINAL=alacritty
export BROWSER=firefox
export PAGER="less -RFM"
export BAT_PAGER="$PAGER"
export MANPAGER="bat --strip-ansi=always -plman"
export FZF_DEFAULT_OPTS='--reverse --list-border --cycle --no-scrollbar'

export CC=clang
export CXX=clang++
export CC_LD=mold
export CXX_LD=mold

common_flags='-march=native -mtune=native -O2 -flto=thin'
export CFLAGS="$common_flags -DNDEBUG"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="$common_flags -fuse-ld=mold"
unset common_flags

export NODE_REPL_HISTORY=$XDG_STATE_HOME/node_repl_history
export MYSQL_HISTFILE=$XDG_STATE_HOME/mysql_history
export PYTHON_HISTORY=$XDG_STATE_HOME/python_history

export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export INPUTRC=$XDG_CONFIG_HOME/readline/inputrc

vk_file='/usr/local/share/vulkan/icd.d/radeon_icd.x86_64.json'
if [ -f "$vk_file" ]; then
    export AMD_DEBUG=useaco # remove this line when mesa 26.0 is available as that will use aco for radeonsi by default

    export VK_DRIVER_FILES="$vk_file:/usr/share/vulkan/icd.d/radeon_icd.i686.json"

    if ! [[ "$LD_LIBRARY_PATH" =~ /usr/local/lib64 ]]; then
        export LD_LIBRARY_PATH="/usr/local/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    fi

    export LIBVA_DRIVERS_PATH=/usr/local/lib64/dri
    export LIBVA_DRIVER_NAME=radeonsi
fi
unset vk_file

# shellcheck source=/dev/null
[ -f ~/.bashrc ] && source ~/.bashrc
