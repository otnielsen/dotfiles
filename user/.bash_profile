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
export LESS='-RFM'
export PAGER="less"
export BAT_PAGER="$PAGER"
export MANPAGER="bat --strip-ansi=always -plman"
export FZF_DEFAULT_OPTS='--tmux --reverse --cycle --no-scrollbar --no-mouse'

export CC=clang
export CXX=clang++
export CFLAGS='-march=native -mtune=native -O3 -flto=thin -DNDEBUG'
export CXXFLAGS="$CFLAGS"
export LDFLAGS="$CFLAGS -fuse-ld=mold -s -Wl,--as-needed"
export CMAKE_GENERATOR=Ninja

export NODE_REPL_HISTORY=$XDG_STATE_HOME/node_repl_history
export MYSQL_HISTFILE=$XDG_STATE_HOME/mysql_history
export PYTHON_HISTORY=$XDG_STATE_HOME/python_history
export SQLITE_HISTORY=$XDG_STATE_HOME/sqlite_history

export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export INPUTRC=$XDG_CONFIG_HOME/readline/inputrc

# Make uinput virtual xbox 360 controller use dualshock 3 mappings in sdl
# applications, so square and triangle (x and y) aren't swapped
export SDL_GAMECONTROLLERCONFIG='0000c5085e0400008e02000000000000,Xbox 360 Controller,a:b0,b:b1,x:b3,y:b2,back:b8,guide:b10,start:b9,leftstick:b11,rightstick:b12,leftshoulder:b4,rightshoulder:b5,dpup:b13,dpdown:b14,dpleft:b15,dpright:b16,leftx:a0,lefty:a1,rightx:a2,righty:a3,lefttrigger:b6,righttrigger:b7,platform:Linux,'

# shellcheck source=/dev/null
[ -f ~/.bashrc ] && source ~/.bashrc
